# Scenario: a design overtakes a half-built plan

## Given

Issue #19 has a sixty-five-task plan with task 1 ticked and is labelled `blocked`. The stale
check commented that `database-access.md` and `architecture.md` changed in the ADV-002 design
PR, which has merged, and the design's hand-over comment says tasks 61 to 63 (the
configuration tool reading the database) are overturned: every tool now goes through the
Admin API. Issue #20, the graphical tool's second database implementation, has the same
comment and loses its reason to exist.

The developer says: /re-plan 19.

## Expect

- Task 1 stays ticked and word for word unchanged.
- Tasks 61 to 63 appear under changed or struck, each with its reason citing the hand-over.
- Every unticked task cites documents by name, never a line or test number.
- The session shows four lists (kept, changed, struck, added) in chunks and writes nothing to
  the issue before the developer approves.
- After approval the plan is replaced, the four lists are posted as a comment, and `blocked`
  is removed.
- The session raises that #20 is obsolete and closes it only when the developer says so.
