# HeliosSkills

The skills plugin every Helios repository loads: the estate's shared constitution, the
feature-first skills, the hooks that enforce the mechanical rules, and the contracts register.
Written once here; a fix reaches every repository.

A repository enables it in `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "helios": { "source": { "source": "github", "repo": "HeliosBBS/HeliosSkills" } }
  },
  "enabledPlugins": { "helios@helios": true }
}
```

| Path | What it is |
|---|---|
| `plugins/helios/CONSTITUTION.md` | the shared constitution; each repository's own `CONSTITUTION.md` adds only what is specific to it |
| `plugins/helios/contracts.md` | the register of interfaces between repositories |
| `plugins/helios/skills/` | `feature-brainstorm`, `feature-design`, `feature-plan`, `feature-build`, `compound`, and the supporting `security-checklist`, `traceability`, `contracts-register`, `corpus-template`, `skill-test`; each ships a `scenario.md` it must pass |
| `plugins/helios/hooks/` | session-start loads the constitutions; pre-tool denies the loop's identity on developer-owned paths; post-edit formats; stop refuses to end a turn on a red `make check`; `test.sh` proves them |

A change here is a pull request the developer approves. Run `sh plugins/helios/hooks/test.sh`
and the `skill-test` skill before merging.
