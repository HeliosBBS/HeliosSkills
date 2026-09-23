# Scenario: plan a merged design

## Given

`docs/spec/cluster.md` now contains the merged ADV-007 node-join design, including a
`join_attempt` entity, a lockout counter per source with invalidation on success, a
`cluster.join.lockout_period` sysop tunable, and six derived negative tests. The code has a
`internal/cluster` package with a `Node` type and no join logic, and a `internal/config`
package that already exposes settings to both configuration tools.

The developer says: plan ADV-007.

## Expect

- The gap table cites `internal/cluster` as partial and `internal/config` as exists, with the
  file paths, before any task is written.
- Every task has Files, Test first, Acceptance, Serves and a tier.
- No task's test-first line is empty, and no task contains "if needed" or a choice.
- The lockout tunable has tasks for both configuration tools.
- The last task is verification through a real client session.
- The analyze table is printed with every row filled and no failed row.
- The plan is written into the issue body under `### Plan` and the issue carries a priority,
  a kind and `unattended-loop` (no task is `session`).
- At least one purely mechanical task (the config key's registration, say) is tagged `haiku`.
- No source file is changed.
