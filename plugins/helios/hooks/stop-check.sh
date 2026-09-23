#!/bin/sh
# A turn does not end on a red `make check` when there is uncommitted work. Exit 2 keeps
# the session going with the failure in front of it; stop_hook_active prevents a loop.
input=$(cat)
case "$input" in
    *'"stop_hook_active":true'*|*'"stop_hook_active": true'*) exit 0 ;;
esac
[ -f Makefile ] || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[ -n "$(git status --porcelain)" ] || exit 0
# Prose alone (a brief, the backlog, a spec) is not what make check checks, and a cloud
# session has none of its tools, so a Markdown-only change never runs it.
git status --porcelain --untracked-files=all | cut -c4- | grep -v '\.md"\{0,1\}$' >/dev/null || exit 0

output=$(make check 2>&1)
status=$?
if [ "$status" -ne 0 ]; then
    echo "make check is red; fix it before stopping:" >&2
    echo "$output" | tail -n 40 >&2
    exit 2
fi
exit 0
