#!/usr/bin/env nu

#+------+#
#| INFO |#
#+------+#

#+---------------+#
#| CONFIGURATION |#
#+---------------+#

use nu-modules *

const script_dir = path self | path dirname
const script_name = path self | path basename
const snippet_mode = "# @snippet_mode@\nuse nu-modules \\*\n# @snippet_mode@"

#+------------------------+
#| Setup for global usage |
#+------------------------+
def main [] {
  __note $"BEGIN SCRIPT: ($script_name)"
  let layout_dir = mktemp --directory --tmpdir-path $script_dir --suffix '-global-setup'
  let script_to_production = ls *.nu | where name != 'global-setup.nu'
  if ( ($script_to_production | length ) != 1 ) {
    __error "Only one script is allowed"
    exit 1
  }

  let script_name = ($script_to_production.name | path parse).stem | to text --no-newline
  let layout_bin = $"([ $layout_dir "usr" "local" "bin" ] | path join)"
  let layout_etc = $"([ $layout_dir "usr" "local" "etc" $script_name ] | path join)"
  let layout_lib = $"([ $layout_dir "usr" "local" "lib" $script_name ] | path join)"

  mkdir $layout_bin
  mkdir $layout_etc
  mkdir $layout_lib
  __run-sh-cmd $"chmod --recursive 755 ($layout_dir)"

  open ($script_to_production.name | to text --no-newline) | str replace --regex $"($snippet_mode)" 'use $"($$file_hierarchy.modules_dir)" *' | save --force ([ $layout_bin $script_name ] | path join)
  __run-sh-cmd $"chmod 755 ([ $layout_bin $script_name ] | path join)"

  __run-sh-cmd $"chmod 755 ($layout_etc)"
  cp settings.toml $layout_etc
  __run-sh-cmd $"chmod 644 ($layout_etc)/*"

  __run-sh-cmd $"chmod 755 ($layout_lib)"
  cp --recursive nu-modules/* $layout_lib
  __run-sh-cmd $"chmod 644 ($layout_lib)/*"

  __info 'File hierarchy created:'
  print (glob $"($layout_dir)/**/*" | path relative-to $script_dir)

  __run-sh-cmd $"tar --owner=root --group=root -cvf ($script_name).tar -C ($layout_dir) ."
  __success 'Archive created'
  let tar_content = __run-sh-cmd-analysis $"tar -tvf ($script_name).tar"
  print ($tar_content.stdout | lines)

  __run-sh-cmd $"rm --recursive --force ($layout_dir)"
  __note $"END OF SCRIPT: ($script_name)"
}
