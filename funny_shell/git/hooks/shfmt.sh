#!/bin/bash

if [[ -z "$(command -v shfmt)" ]]; then
  echo "shfmt not found, please install this tool referring https://github.com/mvdan/sh"
  exit 0
fi

if [[ -z ${VTTOP} ]]; then
  echo "please source dev.env first"
  exit 0
fi

shebang_pattern=("#!/bin/bash" "#!/bin/sh" "#!/usr/bin/env bash")

# Try our best to find shell files
shfiles=()
dot_shfiles=($(git diff --cached --name-only --diff-filter=ACMR | grep '.*\.sh$'))

normal_shfiles=($(git diff --cached --name-only --diff-filter=ACMR | grep -v '\.'))
for file in ${normal_shfiles[@]}; do
  first_line=$(head -1 ${VTTOP}/${file})
  for pattern in ${shebang_pattern[@]}; do
    if [[ ${first_line} == ${pattern} ]]; then
      shfiles=(${shfiles[@]} ${file})
      break
    fi
  done
done

shfiles=(${shfiles[@]} ${dot_shfiles[@]})

[[ -z ${shfiles[@]} ]] && exit 0
unformatted=$(shfmt -s -l -i 2 -ci ${shfiles[@]} 2>&1)
[[ -z ${unformatted} ]] && exit 0

# Some files are not gofmt'd. Print command to fix them and fail.

# Deduplicate files first in case a file has multiple errors.
files=$(
  # Split the "shfmt" output on newlines only.
  OLDIFS=$IFS
  IFS='
'
  for line in ${unformatted}; do
    echo ${line/:*/}
  done |
    # Remove duplicates.
    sort -u
  IFS=${OLDIFS}
)

echo >&2
echo >&2 "Shell files must be formatted with shfmt. Please run:"
echo >&2
echo >&2 -n "  shfmt -i 2 -ci -s -w"

for f in ${files}; do
  # Print " \" after the "shfmt" above and each filename (except for the last one).
  echo >&2 ' \'
  echo >&2 -n "    ${VTTOP}/$f"
done
echo >&2

echo >&2
echo >&2 "If shfmt fails and outputs errors, you have to fix them manually."
echo >&2

exit 1
