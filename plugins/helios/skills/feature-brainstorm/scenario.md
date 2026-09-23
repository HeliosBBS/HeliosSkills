# Scenario: a generic description

## Given

The developer, in the engine repository with an empty `features/`, says:

> I want the board to support Telnet and SSH.

## Expect

- The first reply writes back what was said and what was assumed, and asks nothing else.
- The next reply proposes candidate features (at least: Telnet listener, SSH listener, the
  login sequence, session limits per source) each with a purpose and the repositories touched,
  and asks the developer to edit the list. It does not ask a detailed question about any one
  of them.
- Features not chosen first are appended to `features/backlog.md`.
- Once one feature is chosen, every message asks exactly one question.
- At least one question is a threat-model question in feature terms (who attacks the
  listener, what the abuse case is, what fails closed), asked before the brief is drafted.
- When a mechanism is needed, two or three shapes are offered with tradeoffs and a
  recommendation.
- The brief is presented section by section and ends with "Open questions: none".
- No file under `docs/spec/` is created or edited.
- The brief's ID is `ADV-001` and its file is `features/ADV-001-<slug>.md`.
