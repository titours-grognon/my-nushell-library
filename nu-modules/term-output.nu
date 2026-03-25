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
#| PUBLIC |#
#+--------+#

export def __alert [
  msg: string
] {
  display-message $msg --level alert
}

export def __log-alert [
  msg: string
] {
  display-message $msg --level alert --log
}

export def __debug [
  msg: string
] {
  display-message $msg --level debug
}

export def __log-debug [
  msg: string
] {
  display-message $msg --level debug --log
}

export def __error [
  msg: string
] {
  display-message $msg --level error
}

export def __log-error [
  msg: string
] {
  display-message $msg --level error --log
}

export def __info [
  msg: string
] {
  display-message $msg --level info
}

export def __log-info [
  msg: string
] {
  display-message $msg --level info --log
}

export def __success [
  msg: string
] {
  display-message $msg --level success
}

export def __log-success [
  msg: string
] {
  display-message $msg --level success --log
}

export def __note [
  msg: string
] {
  display-message $msg
}

export def __log-note [
  msg: string
] {
  display-message $msg --log
}

# Draw a character line
export def __draw-line [
  splitter_character = '─'  # Horizontal bar
  --bg = "reset"            # Background color
  --fg = "white_bold"       # Foreground color
] {
  let line = ('' | fill --character $"($splitter_character)" --width 80)
  print ($"(ansi reset)(ansi $bg)(ansi $fg)($line)(ansi reset)")
}
#+---------+#
#| PRIVATE |#
#+---------+#

# Generate a message with or without timestamp to display or log 
def display-message [
  msg:        string  # Message to display
  --level:    string  # Message level : alert, debug, error, info, successful_script, successful_step
  --log               # Add timestamp
] {

  let timestamp = if $log {
    date now | format date "[%F %T]"
  }

  print (
    match $level {
      "alert"   => $"(ansi reset)($timestamp)(ansi yellow_bold) ▲ ($msg)(ansi reset)"
      "debug"   => $"(ansi reset)($timestamp)(ansi white_dimmed) ∟ ($msg)(ansi reset)"
      "error"   => $"(ansi reset)($timestamp)(ansi red_bold) ✗ ($msg)(ansi reset)"
      "info"    => $"(ansi reset)($timestamp)(ansi white_bold) • ($msg)(ansi reset)"
      "success" => $"(ansi reset)($timestamp)(ansi green_bold) ✓ ($msg)(ansi reset)"
      _         => $"(ansi reset)($timestamp)(ansi white_underline) - ($msg) (ansi reset)"
    }
  )
}
