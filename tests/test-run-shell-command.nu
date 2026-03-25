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

#+--------+#
#| *MAIN* |#
#+--------+#

use std/assert
use ../nu-modules *

__info "Running tests..."

__draw-line

__info ("Test: valid command" | str upcase)

let test_valid_command = do --ignore-errors {nu -c "use ../nu-modules/run-shell-command.nu; run-shell-command __run-sh-cmd 'ls -1'"} | complete
print $test_valid_command

assert equal $test_valid_command.exit_code 0

__success "Test: valid command"

__draw-line

__info ("Test: not valid command" | str upcase)

let test_not_valid_command = do --ignore-errors {nu -c "use ../nu-modules/run-shell-command.nu; run-shell-command __run-sh-cmd 'ls --not-valid-parameter'"} | complete
print $test_not_valid_command

assert equal $test_not_valid_command.exit_code 1

__success "Test: not valid command"

__draw-line

__info ("Test: valid command in debug mode" | str upcase)

let test_control_mode_debug_with_valid_command = do --ignore-errors {nu -c "use ../nu-modules/run-shell-command.nu; run-shell-command __run-sh-cmd-debug 'ls'"} | complete
print $test_control_mode_debug_with_valid_command

assert equal $test_control_mode_debug_with_valid_command.exit_code 0

__success "Test: valid command in debug mode"

__draw-line

__info ("Test: not valid command in debug mode" | str upcase)

let test_control_mode_debug_with_not_valid_command = do --ignore-errors {nu -c "use ../nu-modules/run-shell-command.nu; run-shell-command __run-sh-cmd-debug 'ls --not-valid-parameter'"} | complete
print $test_control_mode_debug_with_not_valid_command

assert equal $test_control_mode_debug_with_not_valid_command.exit_code 1

__success "Test: not valid command in debug mode"

__draw-line

__success "Tests completed successfully"
