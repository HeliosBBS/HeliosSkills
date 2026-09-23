---
name: traceability
description: How feature IDs tie briefs, spec sections, plan tasks and tests together, and the check that finds a feature nothing implements and a spec section serving no feature. Use after applying a design, before a plan leaves, and when asked whether the corpus is consistent.
---

# Traceability

Every derived thing says which feature it serves, by ID. The IDs are the only link between the
developer's words and the engineering, so they are stable forever and never reused.

## The tags

- A brief's ID is its filename's prefix: `features/ADV-007-node-join.md` is `ADV-007`.
- Every section of `docs/spec/architecture.md` and of each subsystem spec carries a line
  `Serves: ADV-007, ADV-012` directly under its heading (the corpus template places it).
  A section serving a principle rather than a feature says `Serves: constitution §3`.
- Every plan task carries `Serves: <ID>`; every test file that exists for a feature names the
  ID in its package comment or test name.

## The check

Run both directions and report; either list being non-empty is a defect to fix before
proceeding:

1. **Features nothing serves.** For each ID in `features/` (excluding `backlog.md`), grep
   `docs/spec/` for `Serves:.*<ID>`. No hit: the feature has no design yet (fine before
   `feature-design`) or the design lost it (a defect after).
2. **Sections serving nothing.** For each heading in `docs/spec/`, the next non-empty line
   must be a `Serves:` line naming an existing ID or a constitution section. A section
   without one, or naming an ID that does not exist, is a defect.

Report as two lists with file and line. When the `make trace` target exists, it runs exactly
this and `make check` includes it; until then, run the greps.
