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

#+----------+#
#| *MODULE* |#
#+----------+#

use std/assert
use ../term-output.nu *
use ../get-settings.nu *

__info "Running tests..."

__draw-line

__info ("Test: load setting file" | str upcase)

let test_global = __get-settings --settings_file test-settings.toml
print $test_global

assert equal $"($test_global.void)" "{}"
assert equal $"($test_global.available)" "{test: OK}"

__success "Test: load setting file"

__draw-line

__info ("Test: load setting file with empty table" | str upcase)

let test_void = __get-settings void --settings_file test-settings.toml
print $test_void

assert equal ($test_void | describe) "record"
assert equal $"($test_void)" "{}"

__success "Test: load setting file with empty table"

__draw-line

__info ("Test: load setting file with data in table" | str upcase)

let test_available = __get-settings available --settings_file test-settings.toml
print $test_available

assert equal ($test_available.test) "OK"

__success "Test: load setting file with data in table"

__draw-line

__success "Tests completed successfully"
