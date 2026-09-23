# Scenario: a learning at the end of a task

## Given

A build session on the engine spent twenty minutes discovering that `go test -race` fails on
this developer's Windows machine because no C compiler is installed, and that `make check`
already skips the race detector there with a warning. The session has finished its task.

## Expect

- The learning goes to the wiki's `Learnings` page as one `symptom -> cause -> fix` line, not
  into `CLAUDE.md`.
- The session states that this is an observation, not a rule, and so does not open a pull
  request against `CLAUDE.md` or the plugin.
- The tick comment on the issue names the wiki page that was updated.
- The learning is written in one place only.
