# Constitution of the Helios estate

The first thing every skill, prompt and loop iteration loads, before anything else and in the
same form every time, followed by the repository's own `CONSTITUTION.md`, which holds only
what is specific to that repository. It is short on purpose. Anything that needs more words
belongs in a spec, a skill or the wiki, and cites this file rather than restating it.

## 1. Authority runs from features down

The developer authors and owns feature briefs, in `features/`. Everything else in the design
corpus is derived from them: the architecture, the subsystem specs, the plans, the tests. A
derived document serves features and says which, by ID, section by section. A feature with
nothing implementing it and a section serving no feature are both defects, and tooling finds
them.

When a derived document and a feature disagree, the feature wins, or the developer amends the
feature. Nothing amends a feature except the developer.

Subsystems exist because features demand them, and the developer never has to think in them.
The design skill decides placement, creates a subsystem when features require one, and the
developer may overrule a placement without ever starting from it.

A generic description ("a BBS that supports Telnet and SSH") is the normal entry point. It is
decomposed into candidate features first, each with a purpose and the repositories it touches.
Nothing derived from a generic description enters a spec until that feature has had its own
brainstorm and been approved.

The developer's attention goes where an error costs most: every brief and every plan is read in
full; diffs are spot-checked and reviewed by models. Everything shown to the developer is in
feature terms and in chunks short enough to read.

## 2. Security is designed in, never reviewed in afterwards

Every feature brief carries its threat model: the attacker at each surface, the abuse cases,
and what fails closed. A mechanism is chosen by the developer from concrete shapes offered with
their tradeoffs, the way the node-join pairing code was chosen: a code shown on a separate
channel, fitting the security need exactly.

Access gates fail closed on any error. Auth, RBAC, session handling and event fan-out each have
exactly one implementation; a program that cannot share it carries a second only where the
architecture lists that duplication and the owning spec's negative tests run against both.
Every state-changing operator action writes an audit entry. Every
permission check has a negative-path test that forces its dependency to fail and asserts denial.
A regression test is verified against the reverted fix before it counts.

## 3. Multi-node from the start

Anything that runs as a service runs as several cooperating nodes against one database, and every
design assumes it:

- identifiers that cannot collide across nodes;
- jobs that are idempotent, because any job may run twice;
- no in-memory truth: what a node remembers, another node cannot see;
- check-then-act is atomic, in one transaction or one compare-and-set;
- every cache and every counter states its invalidation rule.

## 4. The estate and its contracts

Six projects are developed together, and each other's needs are inputs to every feature:

| Project | Role | Owns | Consumes |
|---|---|---|---|
| HeliosAdvance | the BBS engine; it does not launch doors itself | the public JSON API and its OpenAPI description | the door hosting protocol |
| HeliosDoorKit | wire protocol and SDKs for BBS doors, not tied to any one BBS | the door wire protocol | nothing from the engine |
| HeliosDoors | a BBS-agnostic door hosting service, a separate daemon any supporting BBS can hand callers to | the door hosting protocol | the door wire protocol's host side |
| HeliosPortal | web client with an address book for many boards | its own UI | the public JSON API |
| HeliosSIP | SIP-to-SSH gateway for dial-up over VoIP | its own gateway | SSH or Telnet, nothing more |
| HeliosLoadTest | load-test harness for a running board | its own drivers | the engine's client surfaces |

They were carved out on one principle, and it holds for anything else that leaves the engine:
**a separate project's interface to the engine is a protocol, a wire format, or nothing.**

An interface changes in the repository that owns it, with a version. Consumers pin a version. A
change that crosses repositories lands owner-first, with contract tests on both sides. A feature
spanning repositories has one brief, in the repository that owns the user-visible behaviour,
and linked work in the others.

## 5. Spec rules

A spec is a reconstruction contract: any developer or model rebuilds the system from the
corpus alone, without the source, tests included, in whatever language they choose. Specs are
detailed enough that Sonnet 5 at high effort builds most of it with a stronger model reviewing.

- **Self-contained.** Nothing outside the corpus except public standards and the contracts
  other Helios projects publish, cited by name and version. No process files, issue or PR
  numbers, hashes, dated rulings or provenance in a body. A revision history is allowed only
  as the last section: dated, one-line, past-tense entries.
- **Language-neutral.** The corpus never names a language, library, framework, file or
  source path, and never cites code. The stack is a separate decision in `docs/stack.md`,
  outside the corpus, which the corpus never cites; the specs must read the same if that
  file changed.
- **The database as a logical schema plus stated properties**, in generic terms: entities, fields,
  keys and constraints, atomic check-then-act, a cluster mutex, error classes, identity and
  time sources, and a best-effort, commit-gated notification bus. No schema file, migration or
  query language is referenced; the physical mapping lives in `docs/stack.md`.
- **Every number says its kind**: a fixed policy backstop, a calibration target, or a sysop
  tunable with its default and key. A sysop tunable is a setting the board's operator changes.
- **No language that goes stale.** No self-counts, no "the only exception", no "currently".
- **One corpus template**, so the same thing sits in the same place in every document.
- **Each mechanism stated once, in its owner**, and cited by contract name everywhere else.
- **Changes are deltas.** A spec change is written as ADDED, MODIFIED and REMOVED requirement
  blocks, each with its scenarios, and merges into the spec on acceptance. An edit is always
  surgical and reviewable; a whole-document rewrite happens only as a ruled regeneration.
- **No open questions in a finished spec.**

## 6. Research is allowed; other people's code is not

Reading anything to understand how a problem has been solved is legitimate: public standards,
documentation, papers, other systems' observed behaviour and, where their licence allows
reading it, their source. Facts, protocols, file formats and algorithms are not owned by
anyone. Their expression is. So:

- Never copy code from another project into this estate, however renamed, reformatted or
  lightly edited, whatever its licence.
- Never implement by paraphrasing another project's source or mirroring its file, function or
  comment structure. Write your own notes on the behaviour, close the source, and implement
  from the notes.
- Briefs, specs, issues, commits and comments describe this project's own design; they never
  say where the understanding came from.
- An implementation that comes out structurally close to something you read is raised, not
  shipped.

## 7. How this file is used

Loaded first, unchanged, by every skill, every prompt and every loop iteration. A change to it
is a pull request the developer approves, and nothing else edits it.
