#!/bin/sh
# Self-test for the hook scripts: each is fed the JSON a real event carries and its exit
# code and output are asserted. Run from the plugin root: sh hooks/test.sh
set -u
cd "$(dirname "$0")/.." || exit 1
export CLAUDE_PLUGIN_ROOT="$PWD"
fail=0
check() {
    if [ "$2" -eq "$3" ]; then echo "ok   $1"; else echo "FAIL $1: exit $2, expected $3"; fail=1; fi
}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git -C "$tmp" init -q

# protect-paths: the developer's identity may edit features/; the bot's may not.
git -C "$tmp" config user.name "Developer"
(cd "$tmp" && printf '{"tool_input":{"file_path":"%s/features/ADV-001-x.md"}}' "$tmp" | sh "$CLAUDE_PLUGIN_ROOT/hooks/protect-paths.sh")
check "developer may edit features/" $? 0

git -C "$tmp" config user.name "phaethusa[bot]"
(cd "$tmp" && printf '{"tool_input":{"file_path":"%s/features/ADV-001-x.md"}}' "$tmp" | sh "$CLAUDE_PLUGIN_ROOT/hooks/protect-paths.sh" 2>/dev/null)
check "bot denied on features/" $? 2
(cd "$tmp" && printf '{"tool_input":{"file_path":"C:\\\\repo\\\\CONSTITUTION.md"}}' | sh "$CLAUDE_PLUGIN_ROOT/hooks/protect-paths.sh" 2>/dev/null)
check "bot denied on CONSTITUTION.md with Windows path" $? 2
(cd "$tmp" && printf '{"tool_input":{"file_path":"%s/internal/x.go"}}' "$tmp" | sh "$CLAUDE_PLUGIN_ROOT/hooks/protect-paths.sh")
check "bot may edit source" $? 0

# format: a Go file is gofmt'd after an edit.
printf 'package x\nfunc  F( ) { }\n' > "$tmp/f.go"
printf '{"tool_input":{"file_path":"%s/f.go"}}' "$tmp" | sh "$CLAUDE_PLUGIN_ROOT/hooks/format.sh"
check "format exits 0" $? 0
grep -q '^func F() {}$' "$tmp/f.go"; check "format applied gofmt" $? 0

# stop-check: nothing to check without a Makefile; a red check blocks; stop_hook_active passes.
(cd "$tmp" && printf '{}' | sh "$CLAUDE_PLUGIN_ROOT/hooks/stop-check.sh")
check "stop passes without Makefile" $? 0
printf 'check:\n\t@exit 1\n' > "$tmp/Makefile"
(cd "$tmp" && printf '{}' | sh "$CLAUDE_PLUGIN_ROOT/hooks/stop-check.sh" 2>/dev/null)
check "stop blocks on red check with uncommitted work" $? 2
(cd "$tmp" && printf '{"stop_hook_active":true}' | sh "$CLAUDE_PLUGIN_ROOT/hooks/stop-check.sh")
check "stop passes when stop_hook_active" $? 0
rm -f "$tmp/f.go"
git -C "$tmp" add Makefile && git -C "$tmp" -c user.name=t -c user.email=t@t commit -qm m
mkdir -p "$tmp/features" && printf 'x\n' > "$tmp/features/backlog.md"
(cd "$tmp" && printf '{}' | sh "$CLAUDE_PLUGIN_ROOT/hooks/stop-check.sh" 2>/dev/null)
check "stop passes on a Markdown-only change despite a red check" $? 0
printf 'package x\n' > "$tmp/g.go"
(cd "$tmp" && printf '{}' | sh "$CLAUDE_PLUGIN_ROOT/hooks/stop-check.sh" 2>/dev/null)
check "stop blocks when Markdown and code change together" $? 2

# session-start prints the shared constitution.
sh "$CLAUDE_PLUGIN_ROOT/hooks/session-start.sh" | grep -q '^# Constitution of the Helios estate'
check "session-start prints the constitution" $? 0

exit $fail
