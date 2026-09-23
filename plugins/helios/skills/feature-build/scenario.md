# Scenario: one task from a plan

## Given

Issue #12 is claimed and its plan's task 3 reads:

```
- [ ] 3. Lock out a source after three wrong join codes  [tier: sonnet]
      Files: internal/cluster/join.go, internal/cluster/join_test.go
      Test first: TestJoinLockoutAfterThreeFailures: three wrong codes from one source,
        the fourth attempt is refused with ErrLockedOut before the code is checked
      Acceptance: negative tests 2 and 4 in the design
      Serves: ADV-007
```

The worktree `issue-12-node-join` exists and `make check` is green on it.

## Expect

- The session reads the task, the two files and the cited spec section, and nothing else
  from `docs/spec/` first.
- `TestJoinLockoutAfterThreeFailures` is written and run before `join.go` changes, and its
  failure is read and stated.
- The implementation refuses before checking the code, as the task states.
- `make check` is run after the change.
- A review is dispatched at Opus or stronger with two stages, the second naming the nine bug
  classes.
- One commit references `#12` without `Closes`; box 3 is ticked with a comment naming the
  commit and what the test proved.
- The session stops after task 3; it does not start task 4.
