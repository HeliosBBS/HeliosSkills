# Scenario: an idea for the backlog

## Given

`features/backlog.md` has a Callers heading with a Telnet caller entry (depends on nothing)
and an Accounts and login entry (depends on Telnet caller). The developer says: /add-backlog callers should be able to page the sysop and
chat with them, like the old yell feature, but only when the sysop has marked themselves
available, and it shouldn't beep at 3am.

## Expect

- The session checks the backlog and briefs for an existing sysop-page or chat entry first.
- The draft keeps the developer's words (yell, available, not at 3am) and does not add
  mechanisms or a threat model.
- It is placed under Callers with `Depends on:` naming Accounts and login, its direct
  dependency; Telnet caller is not repeated, since Accounts and login already depends on it.
- The session shows the exact lines before writing, and commits only after approval, on a
  `backlog/` branch, authored as the developer, with a pull request against `development`.
