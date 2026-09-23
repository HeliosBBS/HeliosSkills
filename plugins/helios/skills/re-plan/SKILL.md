---
name: re-plan
description: Use when the developer says /re-plan <issue>, or asks to re-plan an issue a merged design has overtaken (usually one labelled blocked by the stale check). Keeps every ticked task, regenerates the unticked ones from the specs as they now stand under feature-plan's rules, shows the developer only what changed, and writes nothing until the developer approves; approval also removes blocked.
---

# Re-plan

A plan is disposable; built code is not. This skill regenerates what has not been built and
shows the difference, so the developer re-approves a delta rather than rereading the plan.
Everything `feature-plan` requires of a task, its tiers, its citations and its analyze gate
applies here unchanged.

## 1. Refuse what is not ready

Stop and say why when the issue has no plan, or when a design pull request that the issue's
stale comments or impact lists name is still open: a re-plan against specifications in review
is stale before it is written.

## 2. Read before regenerating

Read the issue's plan, every comment the stale check and the design hand-overs posted on it
(the impact lists name which tasks a design overturns and why), the brief, and the
specifications the plan cites as they now stand on `development`. Then run `feature-plan`'s
gap analysis against the code as it now is, which includes what the ticked tasks built.

## 3. Regenerate

- A ticked task stays, ticked and unchanged: its code exists and passed review.
- Where a design overturns built code, add a task that changes or removes it. Never untick
  a task and never rewrite one that is done.
- Every unticked task is rewritten from the current specifications by `feature-plan`'s rules,
  numbered after the last ticked task, citing documents by name.
- Run the analyze gate on the whole plan, ticked tasks included.

## 4. Show the difference, in chunks

Four lists, each task with a one-line reason: kept as it was, changed (what and why), struck
(why), added (why). Chunks short enough to read in one sitting; the developer approves each.
A task changed by a later approval is shown again.

## 5. Write it, on approval only

Replace the issue's plan with the approved one, comment the four lists as the record, and
remove `blocked`: approving the new plan is the decision to let the loop resume. An issue
the design makes obsolete (a whole plan struck) is closed with that comment instead, on the
developer's word.
