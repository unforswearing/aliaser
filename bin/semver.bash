#!/bin/bash
# https://github.com/unforswearing/bash_semver

# @todo enforce precedence 
#       https://semver.org/spec/v2.0.0.html#spec-item-11

# main
main() {
  local opt="$1"
  local version="$2"

  # Change the IFS for this script in order to better recognize
  # the formatting for a semantic version string. The previous value
  # of the `IFS` environment variable will be saved to `OIFS` allowing
  # the script to restore the `IFS` value when the script exits.
  local OIFS="${IFS}"
  IFS='.'

  # Check that the `$version` variable contains a value
  # if no version is passed to the script, unset
  # $opt to trigger the usage in the case statement
  if [[ -z "$version" ]]; then
    [[ "$opt" != "--help" ]] && opt="";
  fi;

  # read the version into an array to extract any subpatches or metadata
  read -r -a darr <<< "${version}"

  # Variable 'rest' is any subpatch or metadata included in
  # the version passed to this script
  # note: this does not work with version that do not have metadata
  #       the `rest` var will contain the patch value
  local rest=
  rest="$(echo "${darr[2]}" | cut -d"-" -f2)"

  local M=; local m=; local p=; local s=; 
  case "$opt" in
    -n|--normal) 
      echo "print the 'normal' version without subpatch or metadata (eg. 1.0.1)"
    ;;
    -c|--components)
      # print the individual componets of the version
      echo "${darr[@]}"
    ;;
    -r|--rest) 
      # print only the subpatch / metadata
      echo "$rest"
    ;;
    -v|--validate)
      echo "validate the version matches a regex suggested by semver.org"
    ;;
    -M|--major)
      M="$(echo "$version" | cut -d. -f1)"
      echo "$((++M)).0.0"
    ;;
    -m|--minor)
      M="$(echo "$version" | cut -d. -f1)"
      m="$(echo "$version" | cut -d"." -f2)"

      version="$M.$((++m))"
      echo "$version.0"
    ;;
    -p|--patch)
      read -r -a parr <<< "${version}"
      p="${parr[2]}"

      echo "${version/%$p/$((++p))}"
    ;;
    -s|--subpatch)
      s="$(echo "$version" | cut -d"-" -f2 | fold -w1 | tail -n1)"

      # increment a single [aA-zZ] character, from "a" to "b"
      # from: https://stackoverflow.com/a/16824640
      incrs="$(echo "$s" | tr "0-9a-z" "1-9a-z_")"

      # make sure the last item in version has a subpatch
      # if the version doesn't have a subpatch to increment
      # append "-a" to create a new subpatch for the version
      # from: https://unix.stackexchange.com/a/316540
      [ -z "${s//[0-9]}" ] && [ -n "$s" ] && incrs="$s-a"

      echo "${version/%$s/$incrs}"
    ;;
    -d|--metadata)
      local meta="${2}"
      version="${3%%-*}"

      echo "${version}-$meta"
    ;;
    --help) fullusage ;;
    *) usage ;;
  esac

  IFS="${OIFS}"
}

usage() {
  cat <<EOF
usage: semver.bash [ -M | -m | -p | -s | -d ] version
use option --help for full help text.
EOF
}

fullusage() {
  cat <<EOF
usage:
  semver.bash [ -M | -m | -p | -s | -d ] version

options:
  -M  increment Major version, eg: '1.0.0' -> '2.0.0'
  -m  increment minor version, eg: '1.0.0' -> '1.1.0'
  -p  increment patch version, eg: '1.0.0' -> '1.0.1'
  -s  increment subpatch version, eg: '1.0.0' -> '1.0.0-a'
  -d  add metadata to the version, eg: '1.0.0' -> '1.0.0-dev-1.0.1'

  semver.bash assumes your version is formatted as "M.m.p-s",
  that is: M[ajor].m[inor].p[atch]-s[ubpatch]. for example, '1.5.2-r'.

  -s | --subpatch
  option -s is append only. when passing a version to without a so-called
  "subpatch", option -s will append "a" as the subpatch to the version as
  "version-a". if the version already has a subpatch that is in the format "-[aA-zZ]",
  the subpatch will be incrmented, eg: version '1.5.2-r' will increment
  to '1.5.2-s'. incrementation of single letters works through letter z.

  if the version contains a subpatch not matching the "-[aA-zZ]" format
  (such as metadata set with option -d), the subpatch will be appended to
  the version after the metadata. for example, version '1.5.2-r-dev-1.5.3'
  will be updated to '1.5.2-r-dev-1.5.3-a'.

  -d | --metadata
  metadata can be added to a version by using option -d. you must provide the
  metdata as a parameter to option d, for example:
  - the command 'semver.bash -d "beta-1.5.3" 1.5.2' will produce
    '1.5.2-beta-1.5.3'
  - metadata will replace a version containing a subpatch, eg. version '1.5.2-r'
    updated with metadata "beta-1.5.3" produces '1.5.2-beta-1.5.3'.

note:
  semver.bash is a loose implementation of semantic versioning
  that suits a particular need and may not strictly adhere to the specification
  described at https://semver.org/.

EOF
}

main "$@"