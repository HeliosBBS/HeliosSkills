# Scenario: plan a merged design

## Given

`docs/spec/cluster.md` now contains the merged ADV-007 node-join design, including a
`join_attempt` entity, a lockout counter per source with invalidation on success, a
`cluster.join.lockout_period` sysop tunable, and six derived negative tests. The code has a
`internal/cluster` package with a `Node` type, which is a caller slot on a server (the
glossary's node), not a server, and no join logic; and a `internal/config` package that
already exposes settings to the text-mode configuration tool.

The developer says: plan ADV-007.

## Expect

- The gap table cites `internal/cluster` and `internal/config` with their file paths before any
  task is written: the settings mechanism in `internal/config` as exists (the new key itself
  may be a partial row, citing the same files), and the join as partial or missing with the
  reason (a `Node` is a caller slot, not a joining server).
- Every task has Files, Test first, Acceptance, Serves and a tier.
- Every Acceptance line names its document's file and section, and no task cites a line
  number or a test number.
- No task's test-first line is empty, no task is documentation alone, and no task contains
  "if needed" or a choice.
- The lockout tunable has a task for the text-mode tool, and the issue links a blocked,
  session-tier issue for the graphical one.
- The last task is verification through a real client session.
- The analyze table is printed with every row filled and no failed row.
- The plan is written into the issue body under `### Plan` and the issue carries a priority,
  a kind and `unattended-loop` (no task is `session`).
- Every tier follows the skill's rule by the task's shape: `haiku` or `effort: low` only where the
  work has one right answer, and a doubtful task is routed up, never down.
- No source file is changed.
