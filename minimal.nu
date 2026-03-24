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

const script_dir = path self | path dirname

const file_hierarchy = if ($script_dir == "/usr/local/bin") {
  # Applies [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/fhs.shtml)
  # to use script since the - /usr/local
  #   /usr/local
  #   ├── bin
  #   │  └── script-name.nu
  #   ├── etc
  #   │  └── script-name
  #   │     └── settings.toml
  #   └── lib
  #      └── script-name
  #         ├── module-<aaa>.nu
  #         ├── [...]
  #         └── module-<zzz>.nu

  const usr_local = "/usr/local"
  const script_basename = path self | path basename | path parse | get stem

  {
    settings_dir: ([$usr_local etc $script_basename settings.toml] | path join),
    modules_dir: ([$usr_local lib $script_basename] | path join)
  }
} else {
  # Tree structure for local usage of script:
  #   .
  #   ├── script-name.nu
  #   ├── nu_modules
  #   │  ├── module-<aaa>.nu
  #   │  ├── [...]
  #   │  └── module-<zzz>.nu
  #   └── settings.toml
  {
    settings_dir: ([$script_dir settings.toml] | path join),
    modules_dir: ([$script_dir nu_modules] | path join)
  }
}

#+----------+#
#| *IMPORT* |#
#+----------+#

# DEVELOPMENT MODE:
# use nu_modules *
# PRODUCTION MODE:
# use $"($file_hierarchy.modules_path)" *

use nu_modules *

#+--------------------+#
#| Script description |#
#+--------------------+#
@example "Get help: " { ./<script-name>.nu [--help]}
@example "Get information about the script environment: " { ./<script-name>.nu [--show-env]}
def main [
  --show-env  # Show script configuration environment
]: nothing -> any {
  __display-message "Welcome in « My-Nushell-Library »"

  nu $env.PROCESS_PATH --help

  if $show_env {
    __display-horizontal-rule
    __display-message --level info $"Path to script: \n\t\t($script_dir)"
    __display-message --level info $"Path to configuration file: \n\t\t($file_hierarchy.settings_path)"
    if not ($file_hierarchy.settings_path | __check-file-path) {
      __display-message --level alert "Configuration file not present"
    }
    __display-message --level info $"Path to script module folder: \n\t\t($file_hierarchy.modules_path)"
    if not ($file_hierarchy.modules_path | __check-directory-path) {
      __display-message --level alert "Script module folder not present"
    }
    __display-horizontal-rule
  }
}
