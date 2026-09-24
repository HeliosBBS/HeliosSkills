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
  other entries this changes ("None."), assumptions, where it would push back, and ends with
  at most one question or "Commit as drafted?".
- "3am" is not turned into a rule (quiet hours, a time zone): it stays in the developer's
  words, or its reading is listed under assumptions.
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

# Scenario: the whole-backlog pass

## Given

`features/backlog.md` holds, in this order: under Callers, a Telnet caller entry (depends on
nothing); an Accounts and login entry (depends on Telnet caller) whose text says a user never
sees someone they have blocked in who's-online; an SSH public-key login entry (depends on
file transfer on classic connections). Under Content, after them: a File transfer on classic
connections entry (depends on Telnet caller) and a Message bases entry (depends on Accounts
and login). No entry describes blocking. The developer says: /add-backlog an NNTP server so
users can read the message bases in a newsreader, on the usual ports 119 and 563.

## Expect

- The draft is placed after Message bases and depends on Message bases.
- The reply raises that the entry does not say the NNTP server is off by default, without
  writing it into the entry and without a threat model or a security mechanism.
- The draft adds no entry, heading or not-yet-described item the developer did not ask for.
- The reply reports SSH public-key login sitting before File transfer on classic connections,
  which it depends on, with the move it would make.
- The reply reports blocking as a gap: Accounts and login relies on it and nothing describes
  it.
- Those two findings appear under "Where I'd push back"; the draft does not change either
  entry without the developer's word.
- The reply keeps the fixed shape and ends with at most one question or "Commit as drafted?".

# Scenario: asked only to review

## Given

The same backlog, without the NNTP entry. The developer says: review the backlog for order and
gaps.

## Expect

- The review reply drafts nothing and commits nothing.
- The reply lists the SSH public-key login order finding and the blocking gap, each with the
  amendment it would make.
- It drafts amendments only for the findings the developer then accepts.
