#!/usr/bin/env nu
# (‾)-'"""""'-(‾)
#  /           \
# /   Ō  ●  Ō   \
# \   "( - )"   /
#  '-.._____..-'

#+------+#
#| INFO |#
#+------+#
#
# Module for controling the output of external commands such as *bash*
#
#+---------------+#
#| CONFIGURATION |#
#+---------------+#

use term-output.nu *

#+--------+#
#| PUBLIC |#
#+--------+#

export def __run-sh-cmd [
  cmd: string
  --shell: string = 'bash'
] {
  __external-command-control $cmd
}

export def __run-sh-cmd-analysis [
  cmd: string
  --shell: string = 'bash'
] {
  __external-command-control $cmd --mode analyze
}

export def __run-sh-cmd-continue [
  cmd: string
  --shell: string = 'bash'
] {
  __external-command-control $cmd --mode continue
}

export def __run-sh-cmd-debug [
  cmd: string
  --shell: string = 'bash'
] {
  __external-command-control $cmd --mode debug
}

#+---------+#
#| PRIVATE |#
#+---------+#

# Run an external command based on a mode :
#
# - analyze     (allows to process data return)
# - continue    (allows to continue script execution in case of error)
# - debug       (display all information)
# - standard    (display command success or failure)
def __external-command-control [
  external_command: string    # Command to execute
  --mode: string = "standard" # Mode option: analyze, continue, debug or standard
  --shell: string = "bash"    # Command line interpreter
] {

  if not ($mode in ["analyze" "continue" "debug" "standard"]) {
    __error "Control parameter not managed"
    exit 1
  }

  let external_command_result = run-external "/usr/bin/env" $shell "-c" $external_command | complete

  if ($mode == "analyze") {
    return (command-analyze $external_command $external_command_result)
  }

  if ($mode == "debug") {
    return (command-debug $external_command $external_command_result)
  }

  if ($external_command_result.exit_code != 0) {
    command-stop $external_command $external_command_result $mode
  } else {
    command-success $external_command $external_command_result
  }
}

def command-analyze [
  external_command: string
  external_command_result: record
]: nothing -> record {
  $external_command_result
}

def command-debug [
  external_command: string
  external_command_result: record
] {
  __info $external_command
  __info $"Return code: ($external_command_result.exit_code)"
  if ($external_command_result.stdout | is-not-empty) {
    __debug $"Stdout:\n($external_command_result.stdout)"
  }
  if ($external_command_result.stderr | is-not-empty) {
    __debug $"Stderr:\n($external_command_result.stderr)"
    exit 1
  }
}

def command-stop [
  external_command: string
  external_command_result: record
  mode: string
] {
  __alert $external_command
  __error "Not properly execution of the external command"
  __debug $"($external_command_result.stderr)"
  if ($mode != "continue") {
    exit 1
  }
}

def command-success [
  external_command: string
  external_command_result: record
] {
  __info $external_command    
  __success "Execution successfully"
}
