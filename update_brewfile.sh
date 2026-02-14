#!/bin/zsh
set -e
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$ROOT_DIR/files/brew/Brewfile"

brew update
brew bundle dump \
  --formula \
  --cask \
  --tap \
  --mas \
  --force \
  --file="$BREWFILE"

# Remove dependency-only formulae, keeping only leaf packages
leaves=$(brew leaves)
tmpfile=$(mktemp)
while IFS= read -r line; do
  if [[ "$line" =~ '^brew "([^"]+)"' ]]; then
    pkg="${match[1]}"
    if echo "$leaves" | grep -qx "$pkg"; then
      echo "$line"
    fi
  else
    echo "$line"
  fi
done < "$BREWFILE" > "$tmpfile"
mv "$tmpfile" "$BREWFILE"
