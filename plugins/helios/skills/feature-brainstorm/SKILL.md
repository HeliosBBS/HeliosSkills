---
name: feature-brainstorm
description: Use when the developer says "I want X", describes something the board should do, or gives a generic description ("it needs Telnet and SSH"). Turns it into an approved feature brief with a stable ID, in the developer's words, threat model included, zero open questions. Nothing is designed or built until this brief is approved.
---

# Feature brainstorm

You are shaping a feature with the developer, in feature language only: what happens, for whom,
what must never happen, what it costs when it fails. Never ask a subsystem-shaped question
("should sessions own the lockout counter?"). Subsystems are the design skill's problem.

One question per message, at most; a message that needs the developer's decision ends with that one question, asked as a question. No echo chamber: when the developer is wrong, or you would have chosen differently, say so with the reasoning before proceeding; agreement without a reason is worthless, and a decision repeated after the objection stands. Offer knowledge the
developer would otherwise have to type (how classic boards did it, what the protocols allow)
and ask only for what is theirs to decide.

## The model check

Open your first reply with one line naming the model this session runs on, as your system
prompt names it, and the effort level if it is visible to you, or that it is not (a session
cannot see its own effort); then carry on in the same reply. A brainstorm wants Fable in-session or Opus, at high effort. Below
that, say so and stop until the developer switches (`/model`, `/effort`) or says continue;
above it is never a reason to stop.

## 0. Write back before asking anything

Restate what you heard in two lists: **what was said** and **what I assumed**. The developer
corrects both before any question is asked. Assumptions left uncorrected are still assumptions;
they are re-asked when they matter.

## 1. Decompose a generic description

If the request is generic, do not go deep on any part of it yet:

1. Propose candidate features: name, one-line purpose, the repositories each touches (see the
   estate table in the constitution), and which existing features or contracts each depends on.
2. Let the developer add, remove, merge or rename. Repeat until the list is theirs.
3. Order by dependency and propose which to brainstorm first.
4. Append every candidate not brainstormed now to `features/backlog.md` (one line each: name,
   purpose, depends on). The backlog is the memory of things mentioned and not yet shaped.

Only then continue with the one feature chosen.

## 2. Announce the path

Say which path this is and why, and stay on it unless the developer ratchets up (never down):

- **spike**: throwaway learning; the brief records what is to be learned and what decides it.
- **bounded**: a feature that fits inside existing contracts and subsystems.
- **architectural**: new contracts, new subsystems, or a change another repository consumes.

## 3. Shape it, one question at a time

Work through these, in the order the pain suggests, skipping any the write-back already
settled. Each question carries a recommendation and, where the developer might not know the
options, the two or three shapes classic boards used.

- Who does this: which roles, which surfaces (Telnet, SSH, the JSON API, a door, mail exchange).
- What happens when: the normal sequence, then every branch (denied, timed out, disconnected
  mid-way, repeated, done from two sessions at once, done from two nodes at once).
- What must never happen.
- What the other repositories see: the Portal through the JSON API, a door through the Door
  Kit, the load tester through the client surfaces.
- Is it worth its complexity: what the sysop or user loses if it does not exist.

**Threat modelling is part of shaping, not a step after it.** For each surface the feature
touches, ask in feature terms: who is the attacker here, what do they gain, what is the abuse
case (spam, enumeration, lockout of others, resource exhaustion, privilege escalation), and
what happens when a dependency fails (fail closed: the answer that denies). Use the
`security-checklist` skill's questions; record every answer as a decision with its reason.

**When a mechanism is needed**, offer two or three concrete shapes with their tradeoffs and a
recommendation, and ask which fits. Keep offering until the developer picks or proposes one;
their proposal often fits the need better than the offered ones did (the node-join pairing
code, a code shown on a separate channel like a smart-TV app pairing, was such a proposal).

## 4. Draft the brief, section by section

Present each section for approval before the next. The brief is in the developer's words; do
not rewrite their reasons into yours. Sections, in this order:

1. **ID and name.** The ID is stable forever: the repository's prefix and the next number
   (`ADV-` engine, `DK-` Door Kit, `PTL-` Portal, `SIP-`, `LT-` load tester, `DRS-` doors),
   found by listing `features/`. File: `features/<ID>-<slug>.md`.
2. **Purpose.** Two or three sentences: what it does, for whom, why it is worth having.
3. **Behaviour**, as EARS-style scenarios, each one line: `When <trigger>, the system shall
   <response>.`; `While <state>, when <trigger>, ...`; `If <unwanted condition>, then the
   system shall <response>.` Every branch from step 3 is a scenario. Scenarios are the
   design skill's input and the negative tests fall out of the `If` lines.
4. **Security decisions**, each with its reason: the surface, the attacker, the abuse case,
   the decision, why, and what fails closed.
5. **Limits**, each with its kind: fixed policy backstop, calibration target, or sysop
   tunable with default and key.
6. **Non-goals**: what this feature deliberately does not do, so nobody designs it in later.
7. **Repositories and contracts affected**: which repositories change, which contracts are
   consumed or must change (owner-first, versioned; see `contracts-register`).
8. **Open questions: none.** If any remain, the brief is not finished; go back to step 3.

## 5. The hard gate

The brief is approved when the developer says so after reading it in full. Approving the idea
did not approve the brief; approving the brief does not approve a design or a plan. Nothing
in `docs/spec/` changes here. Then:

- Save the brief under `features/`. If the feature spans repositories, the brief lives in the
  repository that owns the user-visible behaviour and names the others.
- Record the session as `records/<ID>-brainstorm.md` in `HeliosBBS/HeliosDesign`: the
  write-back, each question with the answer and reason, the shapes offered and the one
  chosen, and who decided each. That repository is private; the brief's status line links to
  the file. Commit it as the developer on a branch there and open a pull request, as for the
  brief; any session can, local or cloud.
- Commit the brief and backlog on a branch and open a pull request; `features/` is
  developer-owned and merges on the developer's review.
- Say what comes next: `feature-design` for this brief.
