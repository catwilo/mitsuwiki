#!/bin/sh
# wiki.sh — mitsuwiki entrypoint
# Usage: wiki <serve|stop|search|open|new> [args]
set -eu

WIKI_DIR="$(cd "$(dirname "$0")" && pwd)"
WIKI_PORT="${WIKI_PORT:-8080}"
WIKI_WIN="mitsuwiki"
NOTES_DIR="$WIKI_DIR/notes"
NOTES_JSON="$WIKI_DIR/notes.json"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; RESET='\033[0m'
ok()   { printf "${GREEN}  ok${RESET}  %s\n" "$*"; }
warn() { printf "${YELLOW}  !!${RESET}  %s\n" "$*"; }
die()  { printf "${RED}  !!${RESET}  %s\n" "$*" >&2; exit 1; }

_detect_ip() {
    ifconfig 2>/dev/null \
        | grep 'inet ' \
        | awk '{print $2}' \
        | grep -v '^127\.' \
        | grep -v '^100\.' \
        | head -1
}

_gen_index() {
    printf '[\n'
    first=1
    find "$NOTES_DIR" -name '*.md' | sort | while IFS= read -r f; do
        rel="${f#"$WIKI_DIR"/}"
        title="$(head -1 "$f" | sed 's/^#* *//')"
        [ -z "$title" ] && title="$(basename "$f" .md)"
        [ "$first" = "1" ] && first=0 || printf ',\n'
        printf '  {"path":"%s","title":"%s"}' "$rel" "$title"
    done
    printf '\n]\n'
}

_usage() {
    printf 'mitsuwiki\n\n'
    printf '  wiki serve [port]    start server in byobu window (default: 8080)\n'
    printf '  wiki stop            stop server\n'
    printf '  wiki search [query]  fzf search over note contents\n'
    printf '  wiki open            fzf picker -> open in $EDITOR\n'
    printf '  wiki new <cat/name>  create note -> open in $EDITOR\n'
}

cmd="${1:-}"; [ -z "$cmd" ] && { _usage; exit 0; }; shift

case "$cmd" in
  serve)
    port="${1:-$WIKI_PORT}"
    _gen_index > "$NOTES_JSON"
    count="$(grep -c '"path"' "$NOTES_JSON" 2>/dev/null || echo 0)"
    ok "index: $count notes"
    ip="$(_detect_ip)"
    url="http://${ip:-localhost}:${port}"
    if tmux list-windows -F '#{window_name}' 2>/dev/null | grep -qx "$WIKI_WIN"; then
        warn "already running — use: wiki stop"
        exit 0
    fi
    byobu new-window -n "$WIKI_WIN" \
        "cd '$WIKI_DIR' && python3 -m http.server $port --bind 0.0.0.0; exec sh"
    ok "server started: $url"
    printf '%s' "$url" | clipso 2>/dev/null || true
    ;;
  stop)
    tmux kill-window -t "$WIKI_WIN" 2>/dev/null \
        && ok "server stopped" \
        || warn "no wiki window found"
    ;;
  search)
    query="${1:-}"
    if [ -n "$query" ]; then
        results="$(grep -rl "$query" "$NOTES_DIR" --include='*.md' 2>/dev/null || true)"
        [ -z "$results" ] && { warn "no results for: $query"; exit 0; }
        chosen="$(printf '%s\n' "$results" | fzf --preview 'cat {}' --prompt='wiki> ')"
    else
        chosen="$(find "$NOTES_DIR" -name '*.md' \
            | fzf --preview 'cat {}' --prompt='wiki> ')"
    fi
    [ -n "$chosen" ] && "${EDITOR:-nvim}" "$chosen"
    ;;
  open)
    chosen="$(find "$NOTES_DIR" -name '*.md' \
        | fzf --preview 'cat {}' --prompt='open> ')"
    [ -n "$chosen" ] && "${EDITOR:-nvim}" "$chosen"
    ;;
  new)
    [ $# -ge 1 ] || die "usage: wiki new <category/name>"
    target="$NOTES_DIR/$1.md"
    mkdir -p "$(dirname "$target")"
    if [ ! -f "$target" ]; then
        title="$(basename "$1" .md)"
        printf '# %s\n\n' "$title" > "$target"
        ok "created: $target"
    fi
    "${EDITOR:-nvim}" "$target"
    ;;
  index)
    _gen_index > "$NOTES_JSON"
    ok "index rebuilt: $NOTES_JSON"
    ;;
  *)
    die "unknown command: $cmd — run wiki for help"
    ;;
esac
