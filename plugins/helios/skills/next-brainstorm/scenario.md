# Scenario: choosing the next brainstorm

## Given

`features/` holds approved briefs ADV-001 and ADV-002. The backlog lists Accounts and login
(depends on ADV-001), Telnet caller (depends on accounts, the scripting layer and theme
packs), Scripting layer (depends on ADV-001), and Theme packs (depends on
the scripting layer). The developer says: /next-brainstorm.

## Expect

- Only entries whose dependencies all have approved briefs are listed as ready: Accounts and
  login and Scripting layer, not Telnet caller or Theme packs.
- One is recommended with two or three sentences of reasoning that include the strongest case
  against it, and the rest are listed one line each.
- Telnet caller and Theme packs are named as waiting, with what they wait on.
- Nothing is brainstormed until the developer picks; the pick then starts `feature-brainstorm`
  with the backlog entry as the developer's words.
