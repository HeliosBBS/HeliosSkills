---
name: next-brainstorm
description: Use when the developer says /next-brainstorm, or asks what to brainstorm next. Reads the backlog and the briefs, ranks the entries that are ready, recommends one with its reasoning and lists the alternatives, and on the developer's pick runs feature-brainstorm on it.
---

# Next brainstorm

Dependency order says what can come next; what should come next is the developer's call. This
skill argues for a pick and never makes it.

1. **Read** `features/backlog.md` and every brief in `features/` (their IDs, status and what
   they depend on), and the open issues' labels, so an entry blocked on work in flight is
   known.
2. **Ready entries** are those whose dependencies all have an approved brief. List only those.
3. **Rank** by, in order: what the most other entries depend on (it unblocks the most); what
   the developer has said matters (their words in the backlog and briefs); what reshapes
   existing briefs or plans least if done later (settle foundations first); size.
4. **Recommend one** with its reasoning in two or three sentences, then list the next few
   ready entries, one line each with the reason it ranks there. Name any entry that cannot
   start yet and what it waits on, in one line.
5. **On the developer's pick** (the recommendation or any other), run `feature-brainstorm` on
   it, taking the backlog entry as the developer's words for the write-back.
