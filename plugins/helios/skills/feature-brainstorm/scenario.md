# Scenario: a generic description

## Given

The developer, in the engine repository with an empty `features/`, says:

> I want the board to support Telnet and SSH.

## Expect

- The first reply opens with one line naming the model, then writes back what was said and
  what was assumed, and asks nothing else.
- The next reply proposes candidate features (at least: Telnet listener, SSH listener, the
  login sequence, session limits per source) each with a purpose and the repositories touched,
  and asks the developer to edit the list. It does not ask a detailed question about any one
  of them.
- Features not chosen first are appended to `features/backlog.md`.
- Once one feature is chosen, no message asks more than one question, and every message that
  needs the developer's decision ends with that one question.
- At least one question is a threat-model question in feature terms (who attacks the
  listener, what the abuse case is, what fails closed), asked before the brief is drafted.
- When a mechanism is needed, two or three shapes are offered with tradeoffs and a
  recommendation.
- The brief is presented section by section and ends with "Open questions: none".
- No file under `docs/spec/` is created or edited.
- The brief's ID is `ADV-001` and its file is `features/ADV-001-<slug>.md`.

# Scenario: a backlog entry that carries defaults

## Given

`features/` holds the approved brief ADV-001 (servers, nodes and one board). The backlog has:

> **Account deletion**: a user can delete their own account after a confirmation. Deleting
> puts the account in a deleted state for up to 30 days before it is deleted permanently.
> Maintenance deletes an account inactive longer than its role's limit: New User 30 days,
> User 180. Maintenance runs as a scheduled job once for the whole board; the daily statistics
> rollover will use it too. After permanent deletion the username may be reused at once.
> Depends on: accounts and login.

The developer says: let's brainstorm account deletion. Run through the write-back and the
first two questions.

## Expect

- The write-back has three lists: what was said, what I assumed, what is already decided.
- "What is already decided" names each of: the 30-day ceiling, the New User and User
  inactivity limits, and immediate username reuse; each has a line saying why it holds or
  what it may have missed.
- At least one default is challenged with a concrete reason (for example, reusing a username
  at once lets a newcomer impersonate the deleted user).
- The write-back names the scheduled maintenance job as a piece other features need earlier;
  splitting it off as its own entry is offered as the first question after the developer's
  corrections.
- The write-back asks nothing but whether its lists are right; after the developer's
  corrections, each challenged default that is asked about is its own question, one per
  message.
- If the developer takes the split, the piece brainstormed first gets its own write-back
  before any shaping question, and the account deletion entry keeps the developer's words
  (only its `Depends on:` changes).
