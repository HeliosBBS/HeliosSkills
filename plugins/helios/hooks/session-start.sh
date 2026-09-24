#!/bin/sh
# Loads the shared constitution and the repository's own, unchanged, at the start of
# every session. Their text is the hook's output, which becomes session context. A cloud
# session (CLAUDE_CODE_REMOTE=true) also gets what differs there, since CLAUDE.local.md,
# which says it on the developer's PC, never reaches the cloud.
cat "${CLAUDE_PLUGIN_ROOT}/CONSTITUTION.md"
echo
cat "${CLAUDE_PLUGIN_ROOT}/GLOSSARY.md"
if [ -f CONSTITUTION.md ]; then
    echo
    cat CONSTITUTION.md
fi
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then
    echo
    cat "${CLAUDE_PLUGIN_ROOT}/CLOUD.md"
fi
