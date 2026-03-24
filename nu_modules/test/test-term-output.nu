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

__info "Running tests..."

__draw-line

__info ("Test: Output message - ALERT" | str upcase)

let alert_icon = "▲"
let alert_text = "ALERT"
let alert_result = do {nu -c "use ../term-output.nu ; term-output __alert 'ALERT'"} | complete
print $alert_result

assert str contains $alert_result.stdout $alert_icon
assert str contains $alert_result.stdout $alert_text

__success "Test: Output message - ALERT"

__draw-line

__info ("Test: Output message - DEBUG" | str upcase)

let debug_icon = "∟"
let debug_text = "DEBUG"
let debug_result = do {nu -c "use ../term-output.nu ; term-output __debug 'DEBUG'"} | complete
print $debug_result

assert str contains $debug_result.stdout $debug_icon
assert str contains $debug_result.stdout $debug_text

__success "Test: Output message - DEBUG"

__draw-line

__info ("Test: Output message - ERROR" | str upcase)

let error_icon = "✗"
let error_text = "ERROR"
let error_result = do {nu -c "use ../term-output.nu ; term-output __error 'ERROR'"} | complete
print $error_result

assert str contains $error_result.stdout $error_icon
assert str contains $error_result.stdout $error_text

__success "Test: Output message - ERROR"

__draw-line

__info ("Test: Output message - INFO" | str upcase)

let info_icon = "•"
let info_text = "INFO"
let info_result = do {nu -c "use ../term-output.nu ; term-output __info 'INFO'"} | complete
print $info_result

assert str contains $info_result.stdout $info_icon
assert str contains $info_result.stdout $info_text

__success "Test: Output message - INFO"

__draw-line

__info ("Test: Output message - SUCCESS" | str upcase)

let success_icon = "✓"
let success_text = "SUCCESS"
let success_result = do {nu -c "use ../term-output.nu ; term-output __success 'SUCCESS'"} | complete
print $success_result

assert str contains $success_result.stdout $success_icon
assert str contains $success_result.stdout $success_text

__success "Test: Output message - SUCCESS"

__draw-line

__info ("Test: Output message - NOTE" | str upcase)

let note_icon = "-"
let note_text = "You have a message ?"
let note_result = do {nu -c "use ../term-output.nu ; term-output __note 'You have a message ?'"} | complete
print $note_result

assert str contains $note_result.stdout $note_icon
assert str contains $note_result.stdout $note_text

__success "Test: Output message - NOTE"

__draw-line

__info ("Test: Output message - log format" | str upcase)

let timestamp_result = do {nu -c "use ../term-output.nu ; term-output __log-info 'Log format'"}
print $timestamp_result

assert ($timestamp_result | find --regex "[0-9]\{4\}-[01][0-9]-([0-2][0-9]|3[01]) ([01][0-9]|2[04]):[0-5][0-9]:[0-5][0-9]" | is-not-empty)

__success ("Test: Output message - log format")

__draw-line

__info ("Test: Horizontal rule" | str upcase)

let separator_character = "─"
let separator_character_result = do {nu -c "use ../term-output.nu ; term-output __draw-line"} | complete
print $separator_character_result

assert str contains $separator_character_result.stdout $separator_character

__success "Test: Horizontal rule"

__draw-line

__success "Tests completed successfully"
