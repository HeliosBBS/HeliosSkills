# Scenario: a new subsystem spec

## Given

A design creates the first `docs/spec/cluster.md` for ADV-007, and the feature has no
operator actions.

## Expect

- The document has every section of the template in the template's order, each `##` heading
  followed by a `Serves:` line.
- `## Audit` reads `None.` with its `Serves:` line, not omitted.
- `## Configuration` is a table with Key, Default, Kind and Exposed by.
- The stack is not named anywhere in `cluster.md`.
- No process reference (an issue number, a PR, a date in the body) appears outside
  `## Revision history`.
