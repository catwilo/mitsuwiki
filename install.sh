#!/bin/sh
# install.sh — symlink wiki into ~/.local/bin (idempotent)
set -eu

WIKI_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/wiki"

mkdir -p "$BIN_DIR"
chmod +x "$WIKI_DIR/wiki.sh"

if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$WIKI_DIR/wiki.sh" ]; then
    printf '  ok  already installed: %s\n' "$TARGET"
else
    ln -sf "$WIKI_DIR/wiki.sh" "$TARGET"
    printf '  ok  installed: %s -> %s\n' "$TARGET" "$WIKI_DIR/wiki.sh"
fi

case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) printf '  !!  add to PATH: export PATH="%s:$PATH"\n' "$BIN_DIR" ;;
esac
