# mitsuwiki

Personal wiki — terminal + browser, offline, Neovim-native.

## install

    sh install.sh

## usage

    wiki serve [port]    # start server in byobu (default: 8080)
    wiki stop            # stop server
    wiki search [query]  # fzf search over notes
    wiki open            # fzf picker -> open in $EDITOR
    wiki new cat/name    # create note -> open in $EDITOR
    wiki index           # rebuild notes.json

## stack
- Notes: Markdown, edited with Neovim
- Browser: offline SPA (marked.js bundled)
- Terminal: fzf search, $EDITOR
- Server: python3 http.server in byobu window
- Clipboard: clipso

## devices
Termux · Debian · macOS · Raspbian
