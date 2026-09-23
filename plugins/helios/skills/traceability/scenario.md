# Scenario: a section that serves nothing

## Given

`features/` holds `ADV-001` and `ADV-007`. `docs/spec/cluster.md` has a section
`## Node heartbeat` whose next line is `Serves: ADV-009`, and a section `## Node join` with
`Serves: ADV-007`. No section anywhere serves `ADV-001`.

## Expect

- The report lists `ADV-001` under features nothing serves.
- The report lists `docs/spec/cluster.md` `## Node heartbeat` under sections serving nothing,
  because `ADV-009` does not exist.
- `## Node join` appears in neither list.
- The skill does not edit any file; it reports.
