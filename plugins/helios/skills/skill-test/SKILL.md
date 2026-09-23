---
name: skill-test
description: Runs every skill's scenario.md and the hook self-test, and reports pass or fail per skill. Use before trusting a new or changed skill, after editing any hook, and when asked whether the plugin still works. A skill without a passing scenario is a draft.
---

# Skill test

Every skill in this plugin ships a `scenario.md` with a **Given** (the situation and what the
developer says) and an **Expect** (observable behaviours). This skill runs them.

## Hooks

Run `sh hooks/test.sh` from the plugin root. It feeds each hook script the JSON a real event
would carry and asserts the exit code and output. It must pass before anything else is judged.

## Skills

For each `skills/*/scenario.md`, in a fresh subagent:

1. Give the subagent the skill's `SKILL.md`, the plugin's `CONSTITUTION.md`, and the
   scenario's **Given** as the situation, with any files the Given names created in a
   scratch directory. Tell it to act as the skill would, in a transcript, without asking the
   real developer anything: where the scenario needs a developer answer, it answers in the
   developer's voice with the simplest plausible reply and marks it so.
2. Give a second, independent subagent the transcript and the scenario's **Expect** list and
   have it judge each line pass or fail with the evidence quoted.
3. A skill passes only when every Expect line passes.

Report a table: skill, pass or fail, and for a failure the first Expect line that failed with
its evidence. A failing skill is fixed and re-run; a scenario that was wrong is fixed with the
reason stated. Never mark a skill passing from the actor's own claim; the judge's quoted
evidence is the proof.
