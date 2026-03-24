#!/usr/bin/env nu
# (‾)-'"""""'-(‾)
#  /           \
# /   Ō  ●  Ō   \
# \   "( - )"   /
#  '-.._____..-'

#+--------+#
#| *INFO* |#
#+--------+#
#
# Utilities functions
#
#+-----------------+#
#| *CONFIGURATION* |#
#+-----------------+#

use term-output.nu *

#+--------+#
#| PUBLIC |#
#+--------+#

export def __check-directory-path [
  --create    # If present, try to create the directory
]: [
  list<string> -> bool
  string -> bool
] {
  let file_to_check = $in | path join

  if (($file_to_check | path expand | path type) != "dir") {
    __alert "Directory not found"
    if $create {
      try {
        mkdir $file_to_check
      } catch {|error|
        __error $"($file_to_check) \n\t($error.msg)"
        return false
      }
    }
    __debug $"($file_to_check)"
    return false
  }
  true
}

export def __check-file-path [
]: [
  list<string> -> bool
  string -> bool
] {
  let file_to_check = $in | path join

  if (($file_to_check | path expand | path type) != "file") {
    return false
  }
  true
}

export def __delete-file [
]: [
  list<string> -> bool
  string -> bool
] {
  let file_to_delete = $in | path join

  rm --verbose $file_to_delete

  if ($file_to_delete | __check-file-path) {
    __error $"($file_to_delete) could not be delete"
    __error "Aborted"
    return false
  }

  __info $"File deleted: ($file_to_delete)"

  true
}
