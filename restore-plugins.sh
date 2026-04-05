#!/bin/bash
# restore-plugins.sh - Restore plugins to lockfile versions without writing lockfile
LOCKFILE="${HOME}/.config/nvim/lazy-lock.json"
PLUGIN_DIR="${HOME}/.local/share/nvim/lazy"
# Parse lockfile and checkout each plugin
jq -r 'to_entries[] | "\(.key) \(.value.commit)"' "$LOCKFILE" | while read -r plugin commit; do
  plugin_path="$PLUGIN_DIR/$plugin"
  if [[ -d "$plugin_path/.git" ]]; then
    echo "Restoring $plugin to $commit"
    git -C "$plugin_path" fetch --quiet origin 2>/dev/null
    git -C "$plugin_path" checkout --quiet "$commit" 2>/dev/null
  fi
done
echo "Done"
