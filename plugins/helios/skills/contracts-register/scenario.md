# Scenario: a design wants something unregistered

## Given

An engine design for a Portal feature proposes that the Portal read the board's message
counts by querying the engine's PostgreSQL database directly, because it is faster than the API.

## Expect

- The skill rejects the direct database access: it is neither a protocol nor a wire format, so
  under the separation principle it cannot cross the boundary.
- The skill points at the Public JSON API row and says the counts must be added to the API,
  owner-first, with a version bump in the register.
- No change is made to `contracts.md` by the consumer's design.
