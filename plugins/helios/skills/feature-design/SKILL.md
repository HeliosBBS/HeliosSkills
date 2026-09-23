---
name: feature-design
description: Use when an approved feature brief exists and the developer asks to design it, or right after a brief is approved. Derives the delta to the architecture and subsystem specs from the brief, with feature-ID traceability, a clean-room design challenge and a critic, and shows the developer the result in chunks. Authority order: brief over architecture over subsystem spec.
---

# Feature design

The brief is the authority. You derive from it; you never rule out something it asks for. If
the brief is wrong, the developer amends the brief; you do not design around it.

## 1. Extract the constraints

Before reading any existing spec, list every constraint the design must satisfy, each with
its source: every scenario in the brief, every security decision, every limit, every non-goal,
the affected contracts, and the constitution's invariants (fail closed, one implementation of
each security mechanism, audit entries, negative tests, the multi-node rules). This list is the
checklist the rest of the skill is measured against.

## 2. Clean-room challenge

Dispatch a subagent given only the brief, the constraint list and the corpus template, told
to produce an independent design: placement, contracts, data model, state machine, fail
directions, multi-node invariants. It must not read `docs/spec/`.

Then read the existing corpus (`docs/spec/architecture.md`, the subsystem specs the brief's
repositories and contracts point at, and `contracts.md` from this plugin) and produce your own
design. Compare the two: where they differ, say which is better and why. A clean-room design
that is simpler and meets every constraint wins over one that fits the existing shape.

## 3. Derive the delta

For the chosen design, write each of these, in feature terms where the developer will read
them and in spec terms where the spec will hold them:

- **Placement.** Which subsystem owns each part, and why. Create a subsystem only when no
  existing one can own the part without stretching its purpose; say so explicitly.
- **Contracts.** Each interface provided or consumed, by name and version. A change to a
  contract another repository consumes is owner-first: it lands in the owning repository with
  a version bump before any consumer changes.
- **Data model**, as logical schema plus stated properties, in generic terms: entities, fields,
  keys that cannot collide across nodes, constraints, which operations are check-then-act and
  how they are made atomic, error classes, identity and time sources. No schema file, migration
  or query language; a reader in any language must be able to build the database from it.
- **State machine**, with every input class in every state: the normal input, the invalid
  input, the timeout, the disconnect, the duplicate, the concurrent action from another
  session and from another node. An unhandled cell is a defect.
- **Fail directions.** For every dependency the feature calls, what happens when it fails, and
  in which direction. Access gates fail closed.
- **Multi-node invariants.** Which state lives only in the database, which jobs may run twice and
  how they are idempotent, every cache and counter with its invalidation rule.
- **Audit entries.** Every state-changing operator action, with the fields it records.
- **Config-tool footprint.** Every sysop tunable: key, default, kind, and which of the setup
  and runtime configuration tools exposes it (both, or say why not).
- **Derived negative tests.** One line each, mechanically from the brief's `If` scenarios and
  from every permission check: what is forced to fail, what must be denied.
- **Spec deltas.** For each affected document, ADDED, MODIFIED and REMOVED blocks in the
  corpus template's form, each block tagged `Serves: <feature IDs>`. Every sentence in the
  delta traces to a brief scenario, a security decision or a constitution rule; a sentence
  that traces to nothing is removed.

## 4. Critic

Dispatch a critic subagent with the brief, the constraint list and the delta, at a strong
model, asking three things and nothing else:

1. **Security.** Run the `security-checklist`. Which constraint is unmet, which surface is
   unmodelled, which gate fails open, which mechanism is now implemented twice?
2. **Buildability.** Could a Sonnet 5 session at high effort build each part from this delta
   plus the corpus without asking a question? Name every place it would have to guess.
3. **Spec rules.** Every rule in the constitution's section 5, checked line by line.

Fix everything the critic finds before the developer sees anything. Then run the critic once
more; a second round with new findings means the design is not settled.

## 5. Show the developer, in chunks

Present the design one section at a time, in the order above, each short enough to read in
one sitting and written in feature terms ("the lockout counter lives with sessions because a
second node must see it"). The developer may overrule any placement; record the overruling and
its reason. Section-by-section approval; nothing is applied until every section is approved.

## 6. Apply and hand over

- Apply the deltas to `docs/spec/`, surgically: a block merges into its section; nothing else
  in the document changes. Where a subsystem is new, create its spec from the template.
- Run the `traceability` check: every affected section carries `Serves:`, and the feature ID
  is served by at least one section.
- Commit on a branch and open a pull request titled `Design: <ID> <name>` whose description
  is the section list; `docs/spec/` is developer-owned and merges on review.
- Say what comes next: `feature-plan` once the design is merged.
