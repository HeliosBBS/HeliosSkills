#!/bin/sh
# Formats a Go file after every edit so formatting never reaches review.
path=$(sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1 | sed 's#\\\\#/#g')
case "$path" in
    *.go) [ -f "$path" ] && gofmt -w "$path" ;;
esac
exit 0
