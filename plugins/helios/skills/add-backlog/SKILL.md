---
name: add-backlog
description: Use when the developer says /add-backlog followed by prose, asks to add an idea to the backlog, or asks to review the backlog. Turns the prose into a backlog entry in the developer's words, placed and checked against what is already there, checks the whole backlog's order and gaps, and lands it by pull request. It records an idea; it does not shape it (that is feature-brainstorm).
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
4. **Check the whole backlog**, not only the new entry. The developer adds entries one at a
   time and cannot hold the file's dependency graph in their head; this pass does:
   - **Dangling**: every `Depends on:` names an entry, a brief, or an item under the heading
     for things not yet described. A name that matches none, or a feature an entry's text
     relies on (honours, sends, is owned by) that nothing describes, is a gap.
   - **Order**: the file is in dependency order; an entry sitting before one it depends on,
     under any heading, is out of place.
   - **Split**: an entry holding a piece other entries need much earlier than the rest (a
     mechanism every later caller or tool uses, inside a user-facing feature) is offered as
     two entries: the early piece and the rest.
   - **Secure default**: a listener or anything else reachable from the network that the
     entry does not say is off by default is raised, since the constitution's default is
     closed.
   Findings the new entry causes or fixes go in the draft; the rest are reported under
   **Where I'd push back**, one line each with the amendment you would make, and are drafted
   only on the developer's word. Asked only to review the backlog, run this step alone and
   reply with the findings; the amendments the developer accepts are then drafted in the
   shape below.
5. **Reply in this shape, every time,** with each part under its own heading and none left
   out (write "None." when a part is empty):
   - **The entry**: the exact lines, in a code block, and where they go.
   - **Other entries this changes**: each existing entry whose `Depends on:` changes, and how.
   - **Assumptions**: everything the draft decided that the developer did not say.
   - **Where I'd push back**: what you would do differently and why, or "None."
   - **Question**: at most one, only for what the entry cannot be written without; end the
     reply with it, or with "Commit as drafted?".
6. **On approval**, and never before it, commit on a `backlog/<slug>` branch off `development`,
   authored as the developer, and open a pull request against `development`. Give the number.

Never brainstorm here: no threat model, no scenarios.
