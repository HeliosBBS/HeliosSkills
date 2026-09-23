#!/bin/sh
# Loads the shared constitution and the repository's own, unchanged, at the start of
# every session. Their text is the hook's output, which becomes session context.
cat "${CLAUDE_PLUGIN_ROOT}/CONSTITUTION.md"
if [ -f CONSTITUTION.md ]; then
    echo
    cat CONSTITUTION.md
fi
