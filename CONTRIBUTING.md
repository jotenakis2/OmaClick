# Contributing to OmaClick

Thanks for taking the time to improve OmaClick.

## Before you start

- The plugin runs **inside the long-lived `omarchy-shell` process**, unsandboxed,
  with your user permissions. Keep that in mind: no second Quickshell process, no
  blocking calls on the shell's thread, no privileged commands.
- Requirements: Omarchy (Quattro), `jq`, `bash`, `git`.

## Local development

Work on a copy inside your plugin directory, never on the packaged Omarchy
source:

```sh
git clone https://github.com/shayanshahravi/OmaClick.git \
  ~/.config/omarchy/plugins/io.github.shayanshahravi.omaclick
```

The shell reloads saved QML automatically. If it does not pick a change up:

```sh
omarchy-shell shell rescanPlugins
```

## Checks to run before opening a pull request

```sh
omarchy plugin validate .          # manifest contract, entry points, no symlinks
shellcheck --severity=warning install.sh uninstall.sh
jq -e . manifest.json > /dev/null
```

`qmllint` is optional but welcome if you have the Qt tooling installed.

## What makes a good change

- **Keep it scoped.** One behaviour per pull request.
- **Stay native.** Use Omarchy's own commands (`omarchy-*`), `qs.Ui` components
  and theme colours instead of hard-coded colours or new dependencies.
- **No shell-config surgery.** The plugin must not edit Hyprland configuration
  without explicit consent, and installing it must never require a keybinding.
- **Document new menu entries** in both `README.md` and `README.fa.md` when they
  change the defaults.

## Commit messages

Short imperative subject lines, for example:

```
feat: open the menu above the pointer near the screen bottom
fix: keep the focus grab from swallowing clicks on other screens
docs: describe MenuEntries.js separators
```

## Reporting bugs

Open an issue using the bug report template and include your Omarchy version
(`cat /usr/share/omarchy/version`), the shell log lines around the problem
(`qs log -p /usr/share/omarchy/shell --tail 100`) and the steps to reproduce.

## License

By contributing you agree that your work is released under the [MIT License](LICENSE).
