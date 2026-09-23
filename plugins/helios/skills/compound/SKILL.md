---
name: compound
description: Use at the end of every feature and every loop iteration, and whenever something was learned the hard way (a failure, a wrong assumption, a tool quirk, a skill that misbehaved). Writes the learning where the next session will read it. Work that does not make the next unit easier is not finished.
---

# Compound

Ask one question: what would have saved this session time, had it been written down before
it started? Then write exactly that, in the one place the next session reads it.

| Kind of learning | Where it goes | Form |
|---|---|---|
| An operational sign: a failure and what it meant, a build or test quirk, a runner or tool oddity, how a stuck state was recovered | the repository's wiki, page `Learnings` | one line: `symptom -> cause -> fix`, dated |
| A build or test command the loop must run | the wiki's `Runbook` page and, if it belongs in `make check`, the Makefile | the command, and when it applies |
| A rule that holds in this repository | `CLAUDE.md`, the section it belongs to | one sentence, imperative; a pull request |
| A rule that holds across the estate | this plugin's `CONSTITUTION.md` or the relevant skill | a pull request to `HeliosSkills` with the reason |
| A skill that misbehaved | that skill's `scenario.md` gains the case; the skill is fixed | a pull request to `HeliosSkills` |
| A pattern the code should carry so no prompt has to (a helper, a test fixture, a lint rule) | the code, under `make check` | a task on the issue, or the change itself if it is small |

Rules:

- Steer with the codebase, not with prose: a lint rule beats a sentence in `CLAUDE.md`, a
  fixture beats a paragraph in a skill.
- Never write the same learning in two places; the wiki cites `CLAUDE.md`, not the reverse.
- The wiki is unreviewed and disposable; `CLAUDE.md`, the constitution and the skills are
  reviewed. Put a learning in the reviewed place only when it is a rule, not an observation.
- Say what you wrote and where in the issue's tick comment, so the write-up carries it.
