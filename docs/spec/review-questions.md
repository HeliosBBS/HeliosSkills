# Review questions
Serves: SKL-001

## Purpose
Serves: SKL-001
Defines how a repository declares what a review of it asks, how its files divide into review
groups, which finding classes exist, and how that declaration becomes the coverage check and the
ordered list of agents. It asks no questions itself: each repository writes its own set.

## Terms
Serves: SKL-001
As the glossary defines them: review round (round), question set, results repository, finding,
work-order tool, sign-off command. This document introduces:

- Group: a named set of the repository's files, declared by path prefixes; the rule-proposal
  count's "package" is a group.
- Question: a named instruction to a reviewer, with a phase, a kind, a multiplicity, optional
  extra inputs and its text.
- Kind: sweep (one question across the whole codebase), group review (every question at once,
  one group read in full), lens (a judgement of the whole system), critic (an audit of the
  review itself), synthesis, or rule proposer.
- Multiplicity: once, per group, per brief or per spec document; how many agents one question
  becomes.
- Extra input: a read-only fact from outside the tree that plain code gathers before the session
  (Contracts).
- Class: a named defect shape from the set's closed vocabulary, narrow enough that one
  enforcement could stop it at every instance; a class marked known is on the known-bug-class
  list, and a class marked security makes its findings security findings.
- Agent key: the phase, the question name and, for a multiplied question, the group, brief or
  document name, joined by "/"; unique within a round.
- Assignment: the mapping of every file at the pinned commit to exactly one group.

## Contracts
Serves: SKL-001
Provided: **review question set v1.** One JSON document (RFC 8259, UTF-8) at the location
`.helios/review-questions.json` relative to the providing repository's root:

| Field | Type | Meaning |
|---|---|---|
| version | string, "review-question-set/1" | the format version |
| groups | array of {name: string, prefixes: array of string}; names, like every name in the set, are lower-case letters, digits and hyphens | each prefix is a path relative to the repository root, using "/" as separator; a prefix ending in "/" names a directory, otherwise an exact file; the empty string names the whole tree |
| briefs | string | the directory prefix enumerating the repository's briefs, one agent per file directly in it |
| specs | string | the directory prefix enumerating the repository's spec documents, one agent per file directly in it |
| classes | array of {name: string, known: boolean, security: boolean, description: string} | the closed class vocabulary: every known bug class the repository's own rules name, marked known, and every class a question's text names; names are lower case letters, digits and hyphens |
| questions | array of {name, phase, kind, multiplicity, inputs, text} | phase is one of security, quality, specs-and-documents, architecture, synthesis; kind and multiplicity as in Terms, spelled sweep, group-review, lens, critic, synthesis, rule-proposer and once, per-group, per-brief, per-spec; inputs is an array drawn from register, sibling-repositories, vulnerability-report, application-permissions, traceability-report; text is the instruction |

Extra inputs, each gathered by plain code at the round's start, recorded with its content, and
fixed for the round. Every program that gathers an input, and the toolchain it runs on, is a
pinned artefact whose SHA-256 digest is written in the round runner's configuration (review-rounds,
input program digests), never resolved through the tree's declarations. No input is gathered by running the tree's own code; where an answer would need it
run, the input records "unknown". An input that processes the reviewed tree is gathered inside
the disposable isolated environment review-rounds defines, with no credential and no network;
anything it needs from the network is fetched beforehand and handed in read-only.
- register: the estate's contracts register, read at the default branch head of the repository
  that publishes it, with that commit recorded, as a list of {contract, owner, version, specification
  location, consumers}.
- sibling-repositories: the owner and consumer repositories the register names, never the results
  repository, which is left out and reported if the register names it, each as a read-only tree at
  its releases-branch head, with that commit recorded; a finding located in one names its
  repository in the location, and the location is read at the commit recorded for it.
- vulnerability-report: every dependency of the tree at the pinned commit with each known
  vulnerability affecting it, in the Open Source Vulnerability schema version 1.6, and for each
  whether the vulnerable code is reachable from the tree: reachable, not reachable, or unknown
  where no reachability analysis exists for the language.
- application-permissions: the organisation application's granted permissions and the
  repositories it is installed on.
- traceability-report: every feature ID in the tree's briefs that no spec section's Serves line
  names, and every spec section whose Serves line names no feature ID in the briefs.

Operations:
- **load(tree at commit)** gives the set, or Invalid naming the fault: absent; not valid JSON; an
  unknown version; a missing or mistyped field; a duplicate group, class or question name; an
  unknown phase, kind, multiplicity or input; no questions; a synthesis phase without exactly one
  critic question, then exactly one synthesis question, then exactly one rule-proposer question,
  in that order; or a declaration whose most recent change is not developer-verified
  (review-results, the developer authorship check, applied to a commit in a reviewed repository);
  or a name outside the permitted characters.
- **assign(file list, groups)** gives the assignment, or Invalid naming each file no prefix
  matches, each prefix that two groups declare, each prefix that matches no file, and each group
  whose total file content exceeds the group size bound. A file belongs to the group whose
  matching prefix is longest.
- **plan(set, tree, accepted outputs, the previous round's synthesis record)** gives the ordered
  agent keys (Behaviour).

Consumed: review results v1 (the developer authorship check).

Versioning: a consumer refuses a version it does not know. A new version is added beside the
old, and consumers move owner-first.

## Data model
Serves: SKL-001
- The question set is read at the round's pinned commit only, never from a working branch.
- The file list is every tracked file in the tree at the pinned commit, as paths relative to the
  root with "/" separators.
- The file-list digest is SHA-256 (FIPS 180-4) over the sorted paths, each followed by a single
  line feed, encoded as lower-case hexadecimal.
- Nothing here is check-then-act: every operation is a pure function of its inputs.

## Behaviour
Serves: SKL-001
Plan order is fixed:
1. Phases in the order security, quality, specs-and-documents, architecture, synthesis.
2. Within a phase, questions in declaration order.
3. Within a multiplied question, its groups, briefs or documents in byte order of their names.
4. After any agent whose accepted output contains a critical or high finding, that finding's
   refuter agents follow at once, in finding order, as many as review-rounds' configuration sets
   for its severity.
5. In the synthesis phase: the critic, then synthesis, then one rule proposer for each class the
   rule-proposal count triggers (review-rounds), in class-name order.

A multiplied question that enumerates nothing contributes no agents, and a phase with no agents
is complete at once. The plan is recomputed from its inputs every time it is needed.

## Failure directions
Serves: SKL-001
Any Invalid from load or assign stops the round before any review runs, naming the files or the
fault (review-rounds). A repository with no question set cannot run a round. An extra input that
cannot be gathered stops the round before any review runs. None of these is ever read as an
empty set.

## Multi-node invariants
Serves: SKL-001
Every operation here is a pure function: two runners given the same commit, extra inputs and
outputs compute the same plan. There are no caches or counters.

## Audit
Serves: SKL-001
None here: the declaration changes only by developer-verified commits in the repository's own
reviewed pull requests.

## Configuration
Serves: SKL-001

| Key | Default | Kind | Scope | Apply | Exposed by |
|---|---|---|---|---|---|
| group size bound | 400 KiB of file content per group | calibration target | fixed | restart | not exposed |

## Security considerations
Serves: SKL-001
- *Surface:* the declaration is part of the tree under review.
- *Attacker:* whoever can change it, including a build session.
- *Abuse:* narrowing the review by deleting questions or classes, or folding sensitive files into
  a lightly reviewed group.
- *Decision:* the declaration is developer-owned: load refuses one whose most recent change is not
  developer-verified, so no other writer can narrow a review. The round's report states the set's
  verified change and digest and lists every agent key that ran, and the completeness critic sees the full list.
- *Fails closed:* an absent, malformed, unknown-version or unverified declaration, an incomplete
  assignment, or an extra input that cannot be gathered stops the round.

## Negative tests
Serves: SKL-001
- A file no prefix matches: assign refuses and names it.
- Two groups declaring the same prefix: assign refuses and names it.
- A prefix matching no file: assign refuses and names it.
- A group over the size bound: assign refuses and names the group.
- An absent declaration: load refuses; never an empty plan.
- An unknown version: load refuses.
- A declaration last changed by a commit that is not developer-verified: load refuses.
- A declaration whose last change is a merge commit that itself changed it, signed by the
  code-hosting service: load refuses.
- A synthesis phase without the critic, or with the rule proposer before synthesis: load refuses.
- An extra input that cannot be gathered: the round stops before any review.
- A group or question name containing "/": load refuses.
- A tree whose build logic would run, or whose declarations name an analyser, while an input is
  gathered: none of it runs, and the input comes from the pinned program.
- A critical finding: plan places its refuters immediately after its agent.
