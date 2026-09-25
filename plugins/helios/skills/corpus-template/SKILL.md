---
name: corpus-template
description: The one template every architecture and subsystem spec follows, and the delta block form a design uses to change one. Use when creating or editing anything under docs/spec/, so the same thing sits in the same place in every document.
---

# Corpus template

Every document under `docs/spec/` has these sections, in this order, with these headings.
A section that does not apply says `None.` rather than being omitted, so a reader knows it
was considered. Every `##` section except Revision history is followed by its `Serves:`
line.

```
# <Subsystem name>
Serves: <feature IDs, or "constitution §n">

## Purpose
Serves: ...
What this subsystem is for, in three sentences at most, and what it deliberately is not.

## Terms
Serves: ...
Each term this document introduces, one line each. Terms defined elsewhere are cited, not redefined.

## Contracts
Serves: ...
Provided: each interface this subsystem offers, by name, with its operations, inputs, outputs and error classes.
Consumed: each interface it uses, cited by name and version from the contracts register or the owning spec.

## Data model
Serves: ...
Entities and their fields as a logical schema; keys; which operations are check-then-act and how they are made atomic; identity and time sources.

## Behaviour
Serves: ...
The state machine: states, and for each state every input class (normal, invalid, timeout, disconnect, duplicate, concurrent from another session, concurrent from another node) with its transition.

## Failure directions
Serves: ...
Every dependency, what happens when it fails, and in which direction. Access gates fail closed.

## Multi-node invariants
Serves: ...
What lives only in the database; which jobs may run twice and how they are idempotent; every cache and counter with its invalidation rule.

## Audit
Serves: ...
Every state-changing operator action and the fields its entry records.

## Configuration
Serves: ...
| Key | Default | Kind | Scope | Apply | Exposed by |
Kind is fixed policy backstop, calibration target, or sysop tunable (with its validation). Scope is board or server, or fixed for a number that is not a setting. Apply is live or restart. Exposed by names the setup tool, the runtime configuration tools, both, or "not exposed" for a fixed number.

## Security considerations
Serves: ...
The threat model this subsystem answers to: surface, attacker, abuse case, the decision, what fails closed.

## Negative tests
Serves: ...
One line each, derived from the brief's `If` scenarios and every permission check: what is forced to fail, what must be denied.

## Revision history
Dated, one-line, past-tense entries. Last section, never cited, optional.
```

`architecture.md` uses the same sections at the level of the whole system. The stack (languages,
database, physical mapping, build tooling) is not in the corpus at all: it is `docs/stack.md`, a
decision record the specs never cite, so that the corpus reads the same in any language.

## Delta blocks

A design changes a document with blocks a reviewer can read on their own:

```
### ADDED: <section> / <requirement name>
Serves: <IDs>
<the new text, in the section's form>

### MODIFIED: <section> / <requirement name>
Serves: <IDs>
Before: <the exact current text>
After: <the new text>

### REMOVED: <section> / <requirement name>
Reason: <the feature or ruling that removes it>
```

Applying a block merges it into its section and changes nothing else in the document. Rules
that hold across every document: nothing outside the corpus except public standards and
registered contracts; no process references; no language, library, file, path, schema file or
query language named; no stale language; each mechanism stated once, in its owner, cited by
name elsewhere; no open questions.
