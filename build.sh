#!/bin/bash

# build.sh "<semver.bash option>"
# build.sh "<-M|-m|-p|-s|-d>"

test -z "${1}" && {
 echo "build.sh <semver.bash option>"
 echo "build.sh <-M|-m|-p|-s|-d>"
 exit 1
}

shellcheck "aliaser.sh" && \
  shfmt -i 2 "aliaser.sh" > tmp.aliaser.build

newversion=$(bin/semver.bash "${1}" "$(<version)")

test -z "${newversion+x}" && {
  echo "Error: shfmt failed to produce any text."
  exit 1
}

echo "$newversion" > version

# gsed -i "s/aliaser-version=.*/aliaser-version=${newversion}/" aliaser.sh

cat tmp.aliaser.build > "aliaser.sh"

echo "aliaser.sh build complete."

rm tmp.aliaser.build
