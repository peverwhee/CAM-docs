#! /bin/bash

# Check out a directory from a revision
# Must be called from the git repo which contains the files

usage() {
  echo "Usage: `basename ${0}` <revision> <directory / filename> <destination>"
  echo ""
  echo "  <revision> is a tag, hash, or branch"
  echo "  <directory / filename> is a pattern to match from the repo"
  echo "  <destination> is the location to which the files will be copied"
}

perr() {
  if [ -n "${1}" ]; then
    echo -e "ERROR: ${1}\n"
  fi
  usage
  if [ $# -gt 1 ]; then
    exit $2
  else
    exit -1
  fi
}

if [ $# -ne 3 ]; then
  perr
fi

files="$( git ls-tree -r --name-only ${1}:${2} )"
for file in ${files}; do
  # Make sure any subdirectories are present
  outfile="${3}/${file}"
  mkdir -p `dirname ${outfile}`
  git show ${1}:${2}/${file} > ${outfile}
done
