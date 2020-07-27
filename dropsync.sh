#!/bin/bash
name="dropsync"
dropbox="$HOME/Dropbox"
sourcedir=""
targetdir="sync"        #Target folder on Dropbox for individual files

# Check starting arguments.

if [ $# -eq 0] ; then
  echo "Usage: $0 [-d source-folder] {file, file, file}" >&2
  exit 1
fi

if [ "$1" = "-d" ] ; then
  sourcedir="$2"
  shift; shift
fi

# Validity Checks

if [ ! -z "$sourcedir" -a $# -ne 0 ] ; then
  echo "$name: You can't specify both a directory and specific files." >&2
  exit 1
fi

if [ ! -z "$sourcedir" ] ; then
  if [ ! -d "$sourcedir" ] ; then
    echo "$name: Please specify a source directory with -d." >&2
    exit 1
  fi
fi

####################
#### MAIN BLOCK
####################

if [ ! -z "$sourcedir" ] ; then
  if [ -f "$dropbox/$sourcedir" -o -d "$dropbox/$sourcedir"] ; then
    echo "$name: Specified source directory $sourcedir already exists." >&2
    exit 1
  fi

  echo "Copying contents of $sourcedir to $dropbox..."
  # -a does a recursive copy, preserving owner info, etc.
  cp -a "$sourcedir" $dropbox
else
  #No source directory, so we've been given individual files.
  if [ ! -d "$dropbox/$targetdir" ] ; then
    mkdir "$dropbox/$targetdir"
    if [ $? -ne 0 ] ; then
      echo "$name: Error encountered during mkdir $dropbox/$targetdir." >&2
      exit 1
    fi
  fi
# Copy specified files
cp -p -v "$@" "$dropbox/$targetdir"
fi

#Start Dropbox
exec startdropbox -s
