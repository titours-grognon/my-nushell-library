#!/usr/bin/env nu
# (‾)-'"""""'-(‾)
#  /           \
# /   Ō  ●  Ō   \
# \   "( - )"   /
#  '-.._____..-'

#+--------+#
#| *INFO* |#
#+--------+#

#+-----------------+#
#| *CONFIGURATION* |#
#+-----------------+#

use term-output.nu *

#+--------+#
#| PUBLIC |#
#+--------+#

# Get parameters from a toml file
export def __get-settings [
  table?: string              # Extract collection of key/value pairs
  --settings_file: path = ""  # Configuration file in TOML format
] {

  if ($settings_file | is-empty) {
    __error $"No settings files"
    exit 1
  }

  if (($settings_file | path type) != "file") {
    __error $"($settings_file) not found"
    exit 1
  }

  if ($table | is-empty) {
    try {
      open $settings_file
    } catch {|error|
      __error $"($error.msg)"
      exit 1
    }
  } else {
    try {
      open $settings_file | get $table
    } catch {|error|
      __error $"($error.msg)"
      exit 1
    }
  }
}
