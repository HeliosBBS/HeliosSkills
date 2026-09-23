# CLAUDE.md

Every change under `plugins/helios/` raises the plugin's version, in
`plugins/helios/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` alike, in
the same pull request: at an unchanged version Claude Code keeps serving its cached copy and
the change reaches no session. The `plugin-version` check fails a pull request that forgets.
