#!/bin/sh
# Denies edits to the developer-owned paths from the loop's identity. The loop commits
# as the organisation's GitHub App; a session authored as the developer is developer-driven
# by definition and is allowed through.
case "$(git config --get user.name 2>/dev/null)" in
    *"[bot]"*) ;;
    *) exit 0 ;;
esac

path=$(sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1 | sed 's#\\\\#/#g; s#\\#/#g')
case "$path" in
    */features/*|*/CONSTITUTION.md|*/LICENSE|*/LICENSE.exception)
        echo "Denied: $path is developer-owned (features/, CONSTITUTION.md, the licences). File a human-action item instead." >&2
        exit 2
        ;;
esac
exit 0
