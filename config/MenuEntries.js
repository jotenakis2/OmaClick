.pragma library

// OmaClick menu layout.
//
// Edit this file to change what the right-click menu shows; no QML changes are
// needed. Each entry is either a row ({ label, command }) or a separator
// ({ separator: true }).
//
//   label   text shown in the menu
//   command shell command run with Util.execDetached when the row is clicked
//
// After editing, reload the shell:
//   omarchy-shell shell rescanPlugins

var wallpaperCommand = 'background=$(omarchy-theme-bg-switcher); [[ -n $background ]] && omarchy-theme-bg-set "$background"'
var themeCommand = 'theme=$(omarchy-theme-switcher); [[ -n $theme ]] && omarchy-theme-set "$theme" >/dev/null 2>&1 &'

var entries = [
  { label: "Open Terminal", command: "omarchy-launch-terminal" },
  { label: "Open Files", command: "nautilus" },
  { separator: true },
  { label: "Change Wallpaper…", command: wallpaperCommand },
  { label: "Change Theme…", command: themeCommand },
  { separator: true },
  { label: "Settings…", command: "omarchy-shell omasettings toggle" },
  { label: "Lock Screen", command: "omarchy-system-lock" }
]
