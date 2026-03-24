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
use ../term-output.nu *
use ../run-shell-command.nu *

__info "Running tests..."

__draw-line

__info ("Test: valid command" | str upcase)

let test_valid_command = do --ignore-errors {nu -c "use ../run-shell-command.nu; run-shell-command __run-sh-cmd 'ls -1'"} | complete
print $test_valid_command

assert equal $test_valid_command.exit_code 0

__success "Test: valid command"

__draw-line

__info ("Test: not valid command" | str upcase)

let test_not_valid_command = do --ignore-errors {nu -c "use ../run-shell-command.nu; run-shell-command __run-sh-cmd 'ls --not-valid-parameter'"} | complete
print $test_not_valid_command

assert equal $test_not_valid_command.exit_code 1

__success "Test: not valid command"

__draw-line

__display-message --level info ("Test: unknown control mode" | str upcase)

let test_control_mode_unknown = do --ignore-errors {nu -c "use ../run-shell-command.nu; run-shell-command __run-shell-command 'ls' --mode 'mode'"} | complete
print $test_control_mode_unknown

assert equal $test_control_mode_unknown.exit_code 1

__display-message --level successful_step "Test: unknown control mode"

__draw-line

__display-message --level info ("Test: valid command in debug mode" | str upcase)

let test_control_mode_debug_with_valid_command = do --ignore-errors {nu -c "use ../run-shell-command.nu; run-shell-command __run-shell-command 'ls' --mode 'debug'"} | complete
print $test_control_mode_debug_with_valid_command

assert equal $test_control_mode_debug_with_valid_command.exit_code 0

__display-message --level successful_step "Test: valid command in debug mode"

__draw-line

__display-message --level info ("Test: not valid command in debug mode" | str upcase)

let test_control_mode_debug_with_not_valid_command = do --ignore-errors {nu -c "use ../run-shell-command.nu; run-shell-command __run-shell-command 'ls --not-valid-parameter' --mode 'debug'"} | complete
print $test_control_mode_debug_with_not_valid_command

assert equal $test_control_mode_debug_with_not_valid_command.exit_code 1

__display-message --level successful_step "Test: not valid command in debug mode"

__draw-line

__display-message --level successful_script "Tests completed successfully"
