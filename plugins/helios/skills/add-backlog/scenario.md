# Scenario: an idea for the backlog

## Given

`features/backlog.md` has a Callers heading with a Telnet caller entry (depends on nothing)
and an Accounts and login entry (depends on Telnet caller). The developer says: /add-backlog callers should be able to page the sysop and
chat with them, like the old yell feature, but only when the sysop has marked themselves
available, and it shouldn't beep at 3am.

## Expect

- The session checks the backlog and briefs for an existing sysop-page or chat entry first.
- It judges the prose small enough for a backlog entry and does not offer a brainstorm.
- The draft keeps the developer's words (yell, available, not at 3am) and does not add
  mechanisms or a threat model.
- It is placed under Callers with `Depends on:` naming Accounts and login, its direct
  dependency; Telnet caller is not repeated, since Accounts and login already depends on it.
- The reply has, each under its own heading, the entry in a code block with where it goes,
  other entries this changes ("None."), assumptions (at least that "3am" means the sysop's
  local night), where it would push back, and ends with at most one question or "Commit as
  drafted?".
- It commits only after approval, on a `backlog/` branch, authored as the developer, with a
  pull request against `development`.

# Scenario: a full feature sent to the backlog

## Given

The same backlog. The developer says: /add-backlog a moderation queue with list and detail
views, approve, delete, ban and skip per content type, claiming, bulk actions, structured report
reasons, a configurable report threshold that withholds a post, timed suspensions, appeals once
every 7 days, and an audit entry for every action.

## Expect

- Before drafting anything, the session says this is already a full feature and offers
  `feature-brainstorm` instead.
- It drafts a backlog entry only if the developer still asks for one, and then in the reply
  shape above.
