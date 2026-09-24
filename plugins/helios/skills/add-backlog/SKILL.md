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
2. **Check its size first.** If the prose is already a full feature (many decided requirements,
   defaults, per-case behaviour), say so before drafting and offer `feature-brainstorm` instead;
   draft the entry only if the developer still wants it in the backlog.
3. **Draft the entry** in the file's shape: a bold name, what it does and for whom in the
   developer's words (tidy the grammar, never the meaning; keep their name for it unless they
   agree to another), what the developer has already decided about it, and `Depends on:` the
   entries or briefs it needs directly (not what those already depend on). Place it under the
   heading where it belongs.
4. **Reply in this shape, every time,** with each part under its own heading and none left
   out (write "None." when a part is empty):
   - **The entry**: the exact lines, in a code block, and where they go.
   - **Other entries this changes**: each existing entry whose `Depends on:` changes, and how.
   - **Assumptions**: everything the draft decided that the developer did not say.
   - **Where I'd push back**: what you would do differently and why, or "None."
   - **Question**: at most one, only for what the entry cannot be written without; end the
     reply with it, or with "Commit as drafted?".
5. **On approval**, and never before it, commit on a `backlog/<slug>` branch off `development`,
   authored as the developer, and open a pull request against `development`. Give the number.

Never brainstorm here: no threat model, no scenarios.
