---
name: add-backlog
description: Use when the developer says /add-backlog followed by prose, or asks to add an idea to the backlog. Turns the prose into a backlog entry in the developer's words, placed and checked against what is already there, and lands it by pull request. It records an idea; it does not shape it (that is feature-brainstorm).
---

# Add to the backlog

The backlog (`features/backlog.md` in the repository that owns the behaviour) is the memory of
features mentioned and not yet brainstormed. An entry keeps the developer's words; nothing
here is designed.

1. **Read the backlog and the briefs in `features/`.** If the idea is already an entry, part
   of one, or covered by a brief, say which and offer to amend that entry instead of adding a
   second.
2. **Draft the entry** in the file's shape: a bold name, what it does and for whom in the
   developer's words (tidy the grammar, never the meaning), what the developer has already
   decided about it, and `Depends on:` the entries or briefs it needs. Place it under the
   heading where it belongs. If it changes an existing entry's dependencies, say which.
3. **Show the exact lines and where they go.** Ask only what the entry cannot be written
   without, one question at a time; otherwise state the assumption in the draft.
4. **On approval**, commit on a `backlog/<slug>` branch off `development`, authored as the
   developer, and open a pull request against `development`. Give the number.

Never brainstorm here: no threat model, no scenarios. If the prose is already a full feature,
say so and offer `feature-brainstorm` instead.
