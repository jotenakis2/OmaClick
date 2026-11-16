#!/usr/bin/env bash
# OmaClick installer.
#
# Safe to run more than once: it installs the plugin when it is missing,
# updates it when it is already there, and re-enables it if it was disabled.
# The pre-plugin copy of the menu ($LEGACY_ID) is backed up before it is
# retired, so two surfaces never fight over the same right-click.
#
#   ./install.sh
set -euo pipefail

PLUGIN_ID="io.github.shayanshahravi.omaclick"
REPO_URL="${OMACLICK_REPO_URL:-https://github.com/shayanshahravi/OmaClick.git}"
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

known_ids() {
  omarchy plugin list --json 2>/dev/null || printf '[]\n'
}

is_known() {
  known_ids | jq -e --arg id "$1" 'any(.[]; .id == $id)' >/dev/null 2>&1
}

header() {
  printf '\n  OmaClick — desktop context menu for Omarchy\n'
  printf '  %s\n\n' "──────────────────────────────────────────────"
}

header

command -v omarchy >/dev/null 2>&1 ||
  die "the omarchy CLI was not found; this installer only runs on Omarchy Linux."
command -v jq >/dev/null 2>&1 ||
  die "jq is required; install it with your package manager and run this again"
command -v git >/dev/null 2>&1 ||
  die "git is required; install it with your package manager and run this again"

mkdir -p "$PLUGINS_DIR" "$BACKUP_DIR"
stamp="$(date +%Y%m%d-%H%M%S)"

# 1. Retire the pre-plugin copy, after keeping a copy of it.
if [[ -d $PLUGINS_DIR/$LEGACY_ID ]]; then
  backup="$BACKUP_DIR/$LEGACY_ID-$stamp"
  cp -a "$PLUGINS_DIR/$LEGACY_ID" "$backup"
  ok "backed up $LEGACY_ID → $backup"

  if is_known "$LEGACY_ID"; then
    omarchy plugin disable "$LEGACY_ID" >/dev/null 2>&1 || true
    if omarchy plugin remove "$LEGACY_ID" --yes >/dev/null 2>&1; then
      ok "retired $LEGACY_ID (restore it with ./uninstall.sh --restore-legacy)"
    else
      warn "could not retire $LEGACY_ID — remove it by hand if the menu opens twice"
    fi
  else
    rm -rf "${PLUGINS_DIR:?}/$LEGACY_ID"
    ok "removed the unmanaged copy of $LEGACY_ID"
  fi
fi

# 2. Install or update OmaClick itself.
if is_known "$PLUGIN_ID"; then
  say "OmaClick is already installed — updating it."
  omarchy plugin update "$PLUGIN_ID" --yes
else
  say "Installing OmaClick from $REPO_URL"
  omarchy plugin add "$REPO_URL" --enable --yes
fi

# 3. Make sure it is enabled and the running shell knows about it.
if ! known_ids | jq -e --arg id "$PLUGIN_ID" 'any(.[]; .id == $id and .enabled == true)' >/dev/null 2>&1; then
  omarchy plugin enable "$PLUGIN_ID"
  ok "enabled $PLUGIN_ID"
fi

omarchy-shell shell rescanPlugins >/dev/null 2>&1 ||
  warn "could not ask the shell to rescan; restart it with: omarchy-shell shell restartPlugins"

printf '\n'
ok "OmaClick is ready — right-click anywhere on the desktop."
say "Menu entries live in: $PLUGINS_DIR/$PLUGIN_ID/config/MenuEntries.js"
say "Remove it again with: ./uninstall.sh"
printf '\n'
