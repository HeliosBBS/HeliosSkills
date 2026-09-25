---
name: security-checklist
description: The security questions asked while a feature is shaped, the invariants the design critic checks, and the prompt the hostile reviewer runs on anything security-sensitive. Use from feature-brainstorm, feature-design and feature-build; also when asked to review anything for security.
---

# Security checklist

Security is designed in during shaping, checked at design, and attacked at review. The same
list serves all three so nothing is asked at review that was not asked at shaping.

## Shaping questions (feature terms, one at a time)

For each surface the feature touches (Telnet, SSH, the JSON API, a door, mail exchange, the
sysop's console, a configuration tool):

1. Who is the attacker here: an anonymous caller, a logged-in user, a user with a role, a
   sysop of another board, a door, a peer system? What do they gain?
2. What is the abuse case: spam, enumeration of users or codes, locking others out, exhausting
   connections or storage, escalating a role, replaying a message, acting from two nodes at
   once?
3. What happens when a dependency fails (the database, the clock, the peer, the exporter)? The
   answer that denies is the fail-closed answer; anything else needs a reason in the brief.
4. What must be logged for the sysop to see it happened, and what must never be logged (a
   password, a session token, a pairing code)?
5. What limit bounds it, and of which kind (fixed backstop, calibration target, sysop tunable)?
6. Which permission gates each action the feature adds, and who holds it by default? A default
   is a seed value, set at first-run setup; the brief says how an upgrade that brings a new
   permission grants it without changing any grant the sysop made.
7. Can this be used to take over, impersonate, lock out or strip account #1, or any staff
   account, directly or through a chain (its email address, second factor, keys or role)?
   Guard against each path, and name it in the brief.

## Design invariants (the critic checks each)

- Every access gate fails closed on any error, including "no result".
- Every action is gated by a registered permission; an action with no permission is a defect.
- Auth, RBAC, session handling and event fan-out each have exactly one implementation; the
  design cites it by contract name and adds none.
- Every state-changing operator action writes an audit entry with actor, target, before and
  after.
- Every permission check has a negative-path test that forces its dependency to fail and
  asserts denial.
- Every identifier is unforgeable and cannot collide across nodes; every check-then-act is
  atomic.
- Every counter that gates something (attempts, rate, quota) lives in the database, states its
  invalidation, and cannot be reset by the party it limits.
- Secrets are never in code, tests, config examples, logs or issue text.
- A security-sensitive issue or PR describes the work, never the exploit path.

## Hostile review prompt

> You are trying to break this. Assume the author is competent and the obvious is handled.
> For each of the invariants above, find the input, timing or failure that violates it, and
> show the sequence. Check the nine bug classes named in `CLAUDE.md` by name. Then try to
> reach the protected outcome through a different surface than the one the change guards.
> Report only findings with a concrete sequence; "consider" is not a finding.
