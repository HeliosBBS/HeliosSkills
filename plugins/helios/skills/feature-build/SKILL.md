---
name: feature-build
description: Use when a work item with a plan checklist is claimed and a task is to be built, in the unattended loop or interactively. One task per iteration with fresh context in its own worktree, red/green TDD, make check, commit, tick the box, note learnings, stop. Review is two-stage and never downgraded; a feature is done only after verification through its real surface.
---

# Feature build

One task. Fresh context. The plan already made every decision; if you find one it did not
make, that is a routing trigger, not an invitation to decide.

## 0. Baseline, or stop

- Work in the worktree for this issue (`feature/issue-<n>-<slug>`), created from `development`.
- Run `make bootstrap` and `make check`. Red before you have changed anything means the
  baseline is broken: do not build on it; record it on the issue as a human-action item and
  stop.
- Read only the task, the files it names, and the spec sections its `Serves:` and acceptance
  lines point at. The rest of the corpus is noise for this task.

## 1. Red

Write the test the task names first. Run it and read the failure: it must fail for the reason
the task states, not for a compile error or a missing fixture. A test that passes before the
change is the wrong test; stop and say so.

Go tests: standard `testing`, table-driven, `t.Parallel()` where independent, real sockets and
temp files rather than I/O mocks, the database-backed tests against the real Postgres from
`make bootstrap`. A negative-path test forces the dependency to fail and asserts denial.

## 2. Green

The minimum code that makes the test pass and satisfies the task's acceptance lines. No
unrequested features, no single-use abstractions, no comments that explain what the code
shows. Read a file's exports and callers before adding to it. Remove what your change made
unused; leave pre-existing dead code alone and mention it.

Then `make check`. It is the only definition of green.

## 3. Routing triggers

Stop the task and route up (record the attempt's notes on the issue, then hand the same task
to Opus at high effort, or in the loop let the loop do so) when any of these happens. They are
decided by what happened, never by how you feel about the task:

- the tests fail twice with two different fixes;
- the gutter detector fires: the same failure repeats, files thrash, or a placeholder passes;
- a security-sensitive path appears that the plan did not name;
- the diff outgrows what the task described.

A second failure at the higher tier is a human-action item, not a third attempt.

## 4. Review, two-stage, never downgraded

Dispatch the review at Opus or stronger, whatever tier built the task:

1. **Against the brief and the plan.** Was the task's behaviour built, exactly, and nothing
   else? Does the test prove the acceptance lines? Does the `Serves:` feature's scenario now
   hold?
2. **Code quality**, naming the nine bug classes from `CLAUDE.md` explicitly, plus the
   constitution's security invariants.

Anything labelled `security-sensitive` goes to the hostile reviewer: the same two stages,
prompted to break it, with the `security-checklist`. Fix findings before committing. A
reviewer's self-report is not proof; the test is.

## 5. Commit, tick, learn, stop

- Commit atomically with the task's title, referencing the issue (`#<n>`, never `Closes` until
  the last task). Push.
- Tick the task's box and comment: the commit, what the test proved, anything learned.
- Run `compound` for anything that would make the next task easier.
- Stop. The next task is a new iteration with fresh context.

## 6. Finishing the feature

The plan's last task is verification through the real surface: drive the feature the way a
user or sysop would (a real Telnet or SSH session, a real HTTP call, a real door launch), against
every scenario in the brief. Unit tests do not count for this task. Only then: every box
ticked or struck with a reason, the pull request with `Closes #<n>` and the template's
checklist, the write-up as the issue's final comment, and the worktree removed after merge.
