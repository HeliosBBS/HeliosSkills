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
   draft the entry only if the developer still wants it in the backlog. That offer is the
   whole reply: no reply shape and no backlog pass around it.
3. **Draft the entry** in the file's shape: a bold name, what it does and for whom in the
   developer's words (tidy the grammar, never the meaning; keep their name for it unless they
   agree to another), what the developer has already decided about it, and `Depends on:` the
   entries or briefs it needs directly (not what those already depend on). Place it under the
   heading where it belongs.
4. **Check the whole backlog**, not only the new entry. The developer adds entries one at a
   time and cannot hold the file's dependency graph in their head; this pass does:
   - **Dangling**: every `Depends on:` names an entry, a brief, or an item under the heading
     for things not yet described. A name that matches none, or a feature an entry's text
     relies on (honours, sends, is owned by) that nothing describes, is a gap. A part of the
     entry's own feature is not a gap: the gap is something another feature would own.
   - **Order**: the file is in dependency order; an entry sitting before one it depends on,
     under any heading, is out of place.
   - **Split**: an entry holding a piece other entries need much earlier than the rest (a
     mechanism every later caller or tool uses, inside a user-facing feature) is offered as
     two entries: the early piece and the rest.
   - **Secure default**: a listener or anything else reachable from the network whose entry
     does not say whether it is on or off by default (a default port is not an answer) is
     raised, with off as the recommendation, since the constitution's default is closed. Only
     the on-or-off question; how to secure it is the brainstorm's.

   The pass reports; it does not fix. The draft holds only the developer's entry and the
   `Depends on:` changes it causes: a gap is named, never filled with an invented entry or
   heading, and a secure default is raised, never written into the developer's words. Each
   finding is one line with the amendment you would make, under **Where I'd push back**, the
   five that matter most first and a count of the rest; say nothing about a check that found
   nothing, offer no design options, and do not raise again a finding the developer has
   passed over in this conversation. Where two amendments would fix one finding, name the
   one that leaves every entry under its natural heading. Asked only to review the backlog,
   run this step alone and reply with every finding; the amendments the developer accepts
   are then drafted in the shape below.
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
