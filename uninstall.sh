#!/usr/bin/env bash
# OmaClick uninstaller.
#
#   ./uninstall.sh                    remove the plugin
#   ./uninstall.sh --restore-legacy   ...and put the pre-plugin copy back
#
# Safe to run more than once.
set -euo pipefail

PLUGIN_ID="io.github.shayanshahravi.omaclick"
LEGACY_ID="${OMACLICK_LEGACY_ID:-local.desktop-menu}"
PLUGINS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins"
BACKUP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/omaclick/backups"

say() { printf '  %s\n' "$*"; }
ok() { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; }
die() {
  printf 'omaclick: %s\n' "$*" >&2
  exit 1
}

RESTORE_LEGACY=0
for arg in "$@"; do
  case "$arg" in
  --restore-legacy) RESTORE_LEGACY=1 ;;
  -h | --help)
    sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
  *) die "unknown option: $arg" ;;
  esac
done

command -v omarchy >/dev/null 2>&1 || die "the omarchy CLI was not found."

printf '\n  Removing OmaClick\n\n'

if omarchy plugin list --json 2>/dev/null | jq -e --arg id "$PLUGIN_ID" 'any(.[]; .id == $id)' >/dev/null 2>&1; then
  omarchy plugin disable "$PLUGIN_ID" >/dev/null 2>&1 || true
  omarchy plugin remove "$PLUGIN_ID" --yes >/dev/null 2>&1 ||
    die "could not remove $PLUGIN_ID"
  ok "removed $PLUGIN_ID"
else
  say "$PLUGIN_ID is not installed — nothing to remove."
fi

omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true

if [[ $RESTORE_LEGACY -eq 1 ]]; then
  backup="$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "$LEGACY_ID-*" -print 2>/dev/null | sort | tail -n 1)"
  if [[ -n $backup && -d $backup ]]; then
    rm -rf "${PLUGINS_DIR:?}/$LEGACY_ID"
    cp -a "$backup" "$PLUGINS_DIR/$LEGACY_ID"
    ok "restored $LEGACY_ID from $backup"
    omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
  else
    warn "no backup of $LEGACY_ID found in $BACKUP_DIR"
  fi
fi

printf '\n'
ok "Done. Leftovers kept on purpose: $BACKUP_DIR"
printf '\n'
