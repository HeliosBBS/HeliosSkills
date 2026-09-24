# Review results
Serves: SKL-001

## Purpose
Serves: SKL-001
Defines what the private results repository holds for every round, how every writer updates it
without two writers racing, which records count as the developer's, the references the review
depends on being protected, and the release gate computed from them. It is storage and rules
only; running a round is review-rounds.

## Terms
Serves: SKL-001
As the glossary defines them: review round (round), question set, results repository, finding,
work-order tool, sign-off command. This document introduces:

- Conditional update: a write the results repository accepts only if it extends exactly the
  version the writer read; a refused write is re-read, re-checked and retried.
- Review-signing key: a signing key of the developer's that requires the developer's presence
  (a touch or a passphrase, never cached) for every signature, used only for review records and
  question-set changes; its public keys are pinned (Configuration).
- Developer-verified: a change whose signature verifies against a pinned review-signing key
  (Behaviour).
- Create-only record: a runner record written once and never changed.
- Runner-signing key: a key held only by the loop machine's runner account, or, for the
  scheduler, only as an environment secret of the defaults repository released to the scheduler's
  runs; their public keys are pinned (Configuration), and every commit the round runner or the
  application's open writes to the results repository is signed with one; the developer's open
  signs its Opening with a review-signing key instead.
- Runner-verified: a change whose signature verifies against a pinned runner-signing key.
- Fixed: an instance is fixed when a developer-verified fixed record lists its fix issue, for a
  pull request merged by the developer's account into the repository and branch that fix issue's
  Base names, or, with no Base, into the reviewed repository's integration branch; a fix issue,
  fixed record or merge identity that cannot be read counts as not fixed. The gate and rule-pr
  both use this rule.
- Value record: a developer record whose latest verified change is its content.
- Event record: a developer record written once, at the next sequence number of its kind.
- Tampered: a record whose history the rules below forbid.
- Round head: the per-repository record naming the round that holds the repository's slot, and
  the round's lease.
- Estate lease: the one record naming the review agent running anywhere in the estate.
- Release round: a round whose branch matches the release branch pattern.
- Gate state: green, overridden, red with a reason class, or not applicable.
- Release check: the required check on a pull request into the releases branch that reports gate
  state.

## Contracts
Serves: SKL-001
Provided: **review results v1.** Every record is one JSON document (RFC 8259, UTF-8) carrying a
field "version" of "review-results/1" and a field "kind". Its location is derived only from its
key, one record per location. `<repo>` is the repository's name; `<round>` is the round issue's
number in decimal; `<agent>`, `<merged key>` and `<proposal key>` are keys percent-encoded as
one segment (RFC 3986); `<n>` is a decimal integer.

| Record | Location | Writer | Nature |
|---|---|---|---|
| Estate lease | estate/lease.json | round runner | mutable by conditional update |
| Round head | `<repo>`/head.json | round runner | mutable by conditional update |
| Release claim | `<repo>`/release-claims/`<branch>`.json, the branch percent-encoded as one segment | open | mutable by conditional update |
| Opening | `<repo>`/rounds/`<round>`/opening.json | open | create-only |
| Round | .../round.json | round runner | create-only |
| End | .../end.json | round runner | create-only |
| Coverage | .../coverage.json | round runner | create-only |
| Extra input | .../inputs/`<input name>`.json | round runner | create-only |
| Attempt | .../attempts/`<agent>`/`<n>`.json | round runner | create-only |
| Output | .../outputs/`<agent>`.json | round runner | create-only |
| Synthesis | .../synthesis.json | round runner | create-only |
| Must-fix list | .../must-fix.json | round runner | create-only |
| Report | .../report.md, in CommonMark 0.31.2 | round runner | create-only |
| Upload attempt | .../upload/`<n>`.json | round runner | create-only |
| Alert map | .../alerts.json | round runner | create-only |
| Summary | .../summary.json | round runner | create-only |
| Decision | .../developer/decision/`<merged key>`.json | triage command | value |
| Rule | .../developer/rule/`<proposal key>`.json | triage command | value |
| Calibration | .../developer/calibration.json | triage command | value |
| Triage complete | .../developer/triage-complete.json | triage command | value |
| Close | .../developer/close.json | triage command | value |
| Cut short | .../developer/cut-short/`<n>`.json | triage command | event |
| Retry | .../developer/retry/`<n>`.json | triage command | event |
| Fixed | `<repo>`/fixed/`<pull request number>`.json | sign-off command | value |
| Override | `<repo>`/overrides/`<pull request number>`.json | sign-off command | value |

A developer record is written only by the command named, run by the developer in their own
terminal, as one commit signed with a review-signing key and pushed by conditional update. An
Opening written by the developer's open is developer-verified the same way; an Opening's
validity is review-rounds' author check.

Fields, beyond version and kind (times are RFC 3339 in UTC; commits are full hexadecimal object
names):
- Estate lease and round head: round (string `<repo>#<round>`, or null), lease {runner: string,
  nonce: string, agent: string, attempt: integer, taken_at: time} or null.
- Release claim: branch, round (the round issue's number, or null until the issue exists),
  claimed_at.
- Opening: contract ("review round v1"), repository, branch, trigger (release, milestone or
  hand), milestone ({number, title} or null), opened_by (the numeric account identifier),
  opened_at.
- Round: pinned_commit, phase_tiers (object: phase to tier), started_at.
- End: reason (refused or invalid, with the fault), at.
- Coverage: question_set_version, question_set_change (the commit of its verified change),
  question_set_sha256, file_count (integer), file_list_digest (string), assignment
  (object: group name to array of paths).
- Extra input: name, gathered_at, commits (object: repository to commit, for sibling trees),
  content (as review-questions defines for the input).
- Attempt: agent, number, model (a tier's model, or plain), effort, model_served (array of string), started_at, ended_at,
  usage {input_tokens, output_tokens, cache_read_tokens, cache_write_tokens} (integers), outcome
  (accepted, invalid, incomplete, model-mismatch, paused or stopped), messages (array of string, written by plain
  code).
- Output: the agent's output as review-rounds defines it for its kind, with plain code adding to
  every finding its key and fingerprint.
- Synthesis: merged (array of {key, class, members: array of finding keys, fingerprints: array,
  severity, status, priority, security: boolean, title, description, chains: array of merged
  keys, previously_accepted: {references: array, date, severity} or null}), rule_proposals (array
  of {key: the rule proposer's agent key, class, instances: array of merged keys}).
- Must-fix list: keys (array of merged keys), fresh_decision_needed (array of merged keys).
- Upload attempt: number, at, outcome, analysis (string or null), messages.
- Alert map: alerts (object: merged key to alert number).
- Summary: started_at, finished_at, phases (object: phase to {seconds, usage}, every attempt's
  included, paused and stopped ones too).
- Decision: merged_key, finding_title (copied by the triage command from the synthesis record at
  decision time), decision (fix, accept or reject), reason, fingerprints, severity, fix_issue
  (integer or null), alert (integer or null), decided_at.
- Rule: proposal_key, decision (approve or reject), work_item (integer or null), owning_work_item
  ({repository, number} or null), pull_request (integer or null), decided_at.
- Calibration: statistics_shown, conclusions.
- Triage complete: must_fix_seen (array of merged keys), triage_seconds (integer, from the upload
  attempt that succeeded to completion), completed_at.
- Close: reason, closed_at.
- Cut short: reason, at. Retry: target (agent key or "upload"), from_attempt (integer), at.
- Fixed: repository (where the pull request was merged), pull_request, fix_issues (array of
  {repository, number}, the fix issues the developer confirmed this pull request fixes), at. It
  sits under the name of the repository where the pull request was merged.
- Override: pull_request, head_commit, round (string or null), reason_class, reason, at.

Operations:
- **read(location)** gives the record, or Unavailable, NotFound, or Invalid (malformed, an
  unknown version, or tampered).
- **list rounds(repository)** gives the round identities that have an Opening record, or
  Unavailable.
- **list records(round or repository, kind)** gives every location of that kind that has existed
  at any point in the history, each marked present or removed, or Unavailable.
- **conditional update(changes, precondition)** gives applied, or Conflict (retry up to the
  conditional-update retries per iteration) or Unavailable.
- **verified(records, or commits of a reviewed repository)** gives those that are
  developer-verified, and the rest with a reason each. The developer authorship check is stated
  here once; review-questions' load, review-rounds' synthesis and triage, and the gate all call it.
- **gate state(repository, pull request)** gives green, overridden, red with a reason class, or
  not applicable (Behaviour).

Error classes: as in architecture.

Versioning: a reader refuses a version it does not know; for the gate, a refusal means red.

Consumed: the code-hosting service's published REST interface at its dated version 2022-11-28,
for issue and pull-request state, pull-request merge identity, commit statuses, and the
service's current time.

## Data model
Serves: SKL-001
Constraints:
- A create-only record's location changes once in the whole history, by a runner-verified
  change, or, for an Opening of the developer's open, a developer-verified one; any other change, and any later change or removal, is tampering,
  permanently for that round, and a new round on the branch supersedes it. So is a round head,
  estate lease or release claim whose latest change is not runner-verified: it is reported and
  treated as held until the lease expiry, counted from its last runner-verified change, or, with
  none, from the time the service recorded for the forged change, after
  which the next runner-verified conditional update replaces it; open replaces a tampered release
  claim the same way.
- A developer record is tampered while its latest change is not developer-verified, or while it
  is removed; a later developer-verified change at its location clears it.
- The results repository refuses history rewrites, branch deletion and merge commits. Each
  reader with persistent local state also keeps the last commit it read, and treats a history
  that no longer contains it as tampered; the release check, which has none, relies on the
  service's refusal of history rewrites.
- Access is limited to the developer and the application.

Check-then-act, every one a conditional update:
- claim a repository's slot (review-rounds, Behaviour, Start);
- take the estate lease and the round lease together, numbering the attempt, in one update;
- write an output if its location is absent and both leases still name this holder and nonce;
- record an attempt outcome;
- record an upload attempt;
- append a developer event record at the next sequence number of its kind.

A lease holds while it names this holder and nonce, expired or not. Another holder may take it
over only once it is older than the lease expiry; a process of the same runner identity that
holds the installation's local lock may take it over at once under another nonce when no output
is pending under that nonce (review-rounds).
Lease times come from the taking runner's clock, and a runner whose clock differs from the
service's current time by more than the clock skew bound takes no lease at all.

The slot claim reads whether the holder has ended outside the update; only the holder's own
records end it (review-rounds, Ended), so a tracker close or reopen of its issue changes nothing.

Identity and time sources: round and agent identities as in review-rounds, Data model; developer
record times from the developer's clock, carried in the signed record.

## Behaviour
Serves: SKL-001

**Developer authorship check.** A change is developer-verified only if its commit carries a
signature, an SSH signature in the SSHSIG format with the namespace "git" or an OpenPGP
signature (RFC 9580), that the
check itself verifies against a pinned review-signing key. The check never relies on the
service's verified flag or on a commit's author or committer fields. It accepts a subkey of a
pinned OpenPGP key and ignores key expiry. A revoked key is removed from the pinned list: each
developer record it signed must be signed again by a later change, and a round whose Opening it
signed is superseded by opening a new round on the branch.
- A record's change is found by walking from the latest commit back through parents, following
  any parent whose content at the record's location equals the commit's own, until a commit
  whose content differs from that at every one of its parents; that commit is the change. So a
  merge that merely carries a change is not the change, and a merge that itself alters the
  content is. For a commit in a reviewed repository, the declaration is verified only when its
  content at the pinned commit equals what that developer-verified change introduced, and every
  other developer-verified change of it reachable from the pinned commit is an ancestor of that
  change; commit dates are never used.
- For results records, the check reads each location's whole history through list records;
  the tamper rules are the Data model's.
- A tampered record is reported and ignored, and the gate is red for its round ("record
  tampered"); an ignored decision's finding comes back undecided.
- Each ignored or tampered record is listed with its reason in the report's coverage and
  confidence section and at the start of triage.

**Protected references**, each a rule on the code-hosting service with no bypass for the
application, and each verified by a negative test:
- only the developer creates a release branch, and a release branch changes only by pull
  requests the developer merges;
- only the developer creates a hotfix branch, and a hotfix branch changes only by pull requests
  the developer merges;
- only the developer creates, moves or deletes a version tag, in every repository of the estate,
  the work-order tool's own included;
- the releases branch: rule set A lets only the developer and the merge queue acting on the
  developer's merge update it; rule set B requires every
  change to come through a pull request and the merge queue with the merge queue group size, and
  every
  required check, the release check among them, with no bypass for anyone, and requires no
  approving review;
- the estate's defaults repository's default branch changes only by pull requests the developer
  merges;
- every reviewed repository, and the repository holding a question set, merges pull requests by
  merge commit only;
- the application key is stored only as an environment secret, in each repository whose run
  needs it (the defaults repository for the scheduler, each reviewed repository for the release
  check and the release step), each environment's deployment rule admitting only the references
  named in Security considerations, Disclosure through workflows; no organisation-level copy
  exists;
- no token carries the workflows permission (review-rounds, Credential isolation).

**Gate state(repository, pull request)**, evaluated in order; the first rule that applies
decides:

| Step | Condition | Result |
|---|---|---|
| 1 | any read in any step fails, or meets an unknown version or a malformed record | red "unreadable" |
| 2 | the pull request's base is not the releases branch | not applicable |
| 3 | the head repository is not the base repository | red "foreign head" |
| 4 | the head matches the hotfix branch pattern and no commit on the head that is not on the base is reachable from the integration branch | not applicable |
| 5 | a developer-verified override record exists for this pull request whose head commit is the current head and whose round is the round step 6 would choose | overridden |
| 6 | list rounds finds no round for this repository whose Opening branch is the head (of several, the highest round number) | red "no round" |
| 7 | any record of that round is tampered | red "record tampered" |
| 8 | the round has no Round record | red "round incomplete" |
| 9 | the round's pinned commit is not an ancestor of the head commit | red "different commit" |
| 10 | the round has no must-fix list | red "round incomplete" |
| 11 | the round has no developer-verified triage-complete record, or its must-fix-seen set differs from the must-fix list | red "not triaged" |
| 12 | a must-fix key is unresolved | red "undecided" |
| 13 | otherwise | green |

A must-fix key is resolved only by its developer-verified decision record in this round, of
decision accept, reject, or fix where the decision's fix issue is fixed, its Base naming the
round's repository and branch, or, for a finding located only in a sibling repository, that
sibling and its integration branch.
Neither of two decisions in a round that name the same fix issue is resolved. The gate applies
no revisit or severity rule, and a previously accepted finding counts only
through a decision in this round.

**Callers.** Gate state has one implementation, in the work-order tool.
- **The release check** is one reusable definition in the estate's defaults repository, which each
  reviewed repository's releases branch calls, run by the event that takes the definition from
  the pull request's base, never its head, and again on the merge queue's group for the pull
  request, so it is recomputed at the moment of merging; the merge-group run reads its one pull
  request from the group's reference. It is a required check in rule set B whose expected
  source is the organisation's application,
  so a status of the same name from any other poster does not satisfy it; it reports by posting a
  commit status on the pull request's head commit, and on the group's commit in the merge
  queue. It runs a pinned released version of the work-order tool and reports only pass or
  fail: green, overridden and not applicable pass; red fails; the reason class is never printed.
  Its credentials are tokens from mint (review-rounds) with the release check's rows.
- **The sign-off command** merges pull requests without bypassing any rule, and shows the
  developer, in their terminal, the gate's reason class. For any pull request whose body names a
  fix issue, into whatever base, merged or about to be, it shows those fix issues that
  review-rounds' fix issue references admit and that a developer-verified decision record names,
  each shown, escaped as review-rounds' Triage requires, by the round, merged key and finding title
  that decision record holds, never by the
  issue's own text, and, for each the developer confirms, writes the fixed record, before the merge when it merges. For a pull request into
  the releases branch, it recomputes gate state and refuses when red; with the explicit override
  flag and a reason, it first writes the override record, and the check then passes as
  overridden. For a pull request into the releases branch, it always re-runs the release check on the head
  before merging and waits for its result up to the release check wait bound, refusing unless it
  passes. A
  state that cannot be computed is red.
- **The release step** is one reusable definition in the estate's defaults repository, run on a
  version tag, with tokens from mint with the release step's rows. The published notes are the
  service's generated notes for the release; a tag whose commit is not the merge of a pull
  request into the releases branch publishes nothing. It looks up the pull request that merged the release into the releases branch;
  when it has an override record, the step adds the line "The review gate was overridden for this
  release." to the published notes, and nothing more; when the lookup fails, or when that override record is tampered or
  cannot be read, it publishes nothing.

## Failure directions
Serves: SKL-001

| Dependency | On failure | Direction |
|---|---|---|
| Results repository unreachable | writers stall and keep work local; the gate is red; the release step publishes nothing | closed |
| Conflict | re-read, re-check, retry up to the bound, then end the iteration | no loss |
| Signature unverifiable | the change is unverified; the record ignored; the gate red where it depends on it | closed |
| Tracker unreadable (base, head, fix issue, pull request, merge identity, reachability) | the gate is red | closed |
| The release check's credential cannot be minted | the read fails; the check fails | closed |
| The service's time unreadable | no lease is taken | closed |
| The override or fixed record not pushed | the merge is refused | closed |
| The release step's pull-request lookup fails | nothing is published | closed |

## Multi-node invariants
Serves: SKL-001
**Truth.** Every record lives only in the results repository. The gate also reads, from the
tracker, pull-request base, head, head repository and merging account, and reachability.

**Idempotence.** Every create-only write is refused as present when repeated, and the writer
treats that as done. A value record rewritten with the same content changes nothing. An event
record is keyed by its sequence number, so a repeat finds its number taken and re-reads. The gate
is a pure read, computed afresh at every call.

**Caches.** A reader's local copy is refreshed before every read the gate uses and before every
conditional update. Every merge into the releases branch goes through the merge queue, where the
release check is recomputed for the merge itself, and rule set B has no bypass; that
recomputation is what keeps a stale earlier result from letting a merge through.

## Audit
Serves: SKL-001
- Overriding the gate: the override record (pull request, head commit, round, reason class,
  reason, time), pushed before the merge.
- Confirming a fix: the fixed record (repository, pull request, fix issues, time), pushed before
  the merge, or after it for a pull request already merged.
- Every other developer action: review-rounds, Audit.
- Every developer record carries its signature, which is itself the proof of who acted.

## Configuration
Serves: SKL-001

| Key | Default | Kind | Scope | Apply | Exposed by |
|---|---|---|---|---|---|
| pinned review-signing keys | the public keys of the developer's review-signing keys, fixed in the work-order tool's reviewed source; a key retired from use stays listed, a revoked key is removed | fixed policy backstop | fixed | restart | not exposed |
| results repository | HeliosReviews, in the organisation | fixed policy backstop | fixed | restart | not exposed |
| releases branch | main | fixed policy backstop | fixed | restart | not exposed |
| integration branch | development | fixed policy backstop | fixed | restart | not exposed |
| release branch pattern | "release/v" followed by a version as Semantic Versioning 2.0.0 defines it | fixed policy backstop | fixed | restart | not exposed |
| hotfix branch pattern | "hotfix/v" followed by a version as Semantic Versioning 2.0.0 defines it | fixed policy backstop | fixed | restart | not exposed |
| conditional-update retries per iteration | 5 | fixed policy backstop | fixed | restart | not exposed |
| release check wait bound | 10 minutes | calibration target | fixed | restart | not exposed |
| merge queue group size | 1 | fixed policy backstop | fixed | restart | not exposed |
| pinned runner-signing keys | the public keys of the runner account's and the scheduler's signing keys, fixed in the work-order tool's reviewed source | fixed policy backstop | fixed | restart | not exposed |
| clock skew bound | 5 minutes | calibration target | fixed | restart | not exposed |

## Security considerations
Serves: SKL-001

**The pipeline silencing itself.** *Attacker:* the application or a misbehaving session.
*Abuse:* forging acceptances, deleting or rewriting a later decision so an earlier one wins,
shrinking the must-fix list after triage, hiding an override, or presenting a clean-looking
round. *Decision:* only developer-verified records resolve findings; an unverified latest change
or a removal of a developer record, and any change to a create-only record, is tampering and
turns the gate red; the triage-complete record names the exact must-fix set the developer saw;
list records returns removed locations, so a deleted override stops the release. *Fails closed:*
an unverified or tampered record is ignored and the gate is red.

**Forged signatures.** *Attacker:* the application, which can create commits through the service
that the service marks verified, and any model session under the developer's account, which can
use the developer's everyday signing (that such a session can also read the runner-signing key
and forge runner-verified records is the accepted residual: review-rounds, Account isolation). *Decision:* only a pinned review-signing key makes a change
developer-verified, and it signs only with the developer present; the check verifies each
signature itself and ignores the service's flag and the author fields. *Fails closed:* anything
it cannot verify is unverified.

**A fix that did not fix.** *Attacker:* a steered build session that writes a closing reference
into an unrelated pull request. *Decision:* a fix resolves a must-fix finding only through the
developer's fixed record, written at merge after the developer confirms each fix issue.

**Gate bypass.** *Attacker:* a hurried merge by any path, or the application. *Decision:* the
protected references; rule set B has no bypass for anyone, so the web interface, the sign-off
command and any other path all meet the check; an override needs an explicit flag, a reason and a
signed record, and its public note names no count, class or finding. *Fails closed:* an
unreadable state is red.

**Disclosure through workflows.** *Surface:* public run logs. *Attacker:* anything that can push
a branch or a workflow definition. *Abuse:* a definition that runs with the application key and
prints findings. *Decision:* the application key, stored as environment secrets, is released only
to runs whose definition comes from a protected reference: a releases branch for the check, a version tag
for the release step, the defaults repository's default branch for the scheduler, and the merge
queue's groups for the releases branch; a foreign head is red before the results repository is
read; the release check prints pass or fail only. *Fails
closed:* without its credential the release check fails.

**Results repository exposure.** *Decision:* two principals only; the residual risk is accepted.

## Negative tests
Serves: SKL-001
- A decision record last changed by the application: tampered; ignored; the gate red.
- The application rewrites a later developer decision so an earlier accept would win: tampered.
- The application deletes a developer decision or an override record: listed as removed;
  tampered; the gate red, and the release step publishes nothing.
- A later developer-verified change to a tampered developer record: the tamper clears.
- The application changes the must-fix list after triage: tampered; the gate red.
- A must-fix list that differs from the triage-complete must-fix-seen set: red.
- A commit the application made through the service, marked verified by it, with the developer as
  author: unverified.
- A commit signed with the developer's everyday key, not a review-signing key: unverified.
- A signature made without the developer's presence: the review-signing key produces none.
- A merge commit pushed to the results repository: refused.
- A results history that no longer contains the commit a reader last read: tampered.
- A record signed by a revoked key: unverified.
- A record signed by an expired pinned key, or by a subkey of one: verified.
- An SSH signature with a namespace other than "git": unverified.
- A pull request merged by squash or rebase into a reviewed repository: refused.
- An override for an earlier head commit, or for an earlier round: not overridden.
- An Output or Attempt pushed by the developer's account, or by anything but the runner: not
  runner-verified; tampered.
- A fix issue closed by a pull request the developer merged into the integration branch, with no
  fixed record: not fixed.
- A release pull request signed off with no new record: the release check is re-run before the
  merge.
- Two must-fix decisions naming one fix issue: both unresolved; red.
- A fix issue retitled by the application and named in an unrelated pull request: shown by its
  decision record's finding title; an issue no decision names: not offered.
- The release step cannot look up the merge pull request: nothing is published.
- The merging account of a fix's pull request cannot be read: unresolved; red.
- A forged round head or estate lease: treated as held until its lease expiry, then replaced.
- A status named like the release check from a source other than the application: does not
  satisfy rule set B.
- A merge carrying an older developer-verified question set, or an unverified change dated
  before a verified one: load refuses.
- The application moves or deletes a version tag, in any repository: refused.
- The release check does not pass within its wait bound after the sign-off command writes a
  record: the merge is refused.
- A definition holding the application key contains no step that runs content from a reviewed
  tree.
- The highest round on the head branch has an End record: red "round incomplete".
- A history rewrite of the results repository: refused.
- The reachability or base read fails for a hotfix-named head: red.
- A pull request whose head is in another repository, branch named like a release: red.
- A pull request into the releases branch from a release branch with no round: red.
- A branch named like a hotfix whose commits are reachable from the integration branch: gated.
- The results repository unreachable: red, and the sign-off command refuses.
- A record with an unknown format version: red.
- A closing reference the application wrote, with no fixed record: unresolved; red.
- A fixed record for a pull request merged by the application, or based on another branch:
  unresolved.
- The round's pinned commit not an ancestor of the head: red.
- A previously accepted must-fix finding with no decision in this round: red.
- A genuine hotfix branch into the releases branch: not applicable.
- A merge into the releases branch through the web interface while red: refused by rule set B.
- The sign-off command on a red gate without the flag: refuses.
- The sign-off command with the flag while the override record cannot be pushed: refuses.
- A release whose merge pull request has an override record: the notes carry the line.
- The application creates a release branch, pushes to one, creates a version tag, or updates the
  releases branch or the defaults repository's default branch: refused.
- A workflow definition on any other reference asks for the application key: not released.
- A runner whose clock differs from the service's by more than the bound: takes no lease.
- The release check's log and the sign-off command's public output: no finding text, counts,
  keys or reason class.
- The release check's credential cannot be minted: the check fails.
- The service's time cannot be read: no lease is taken.
- The results repository unreachable at release: the release step publishes nothing.
- The fixed record cannot be pushed: the merge is refused.
- The developer pushes a commit directly to the releases branch: refused.
- The application creates a hotfix branch or pushes to one: refused.
- A fixed record for an already-merged pull request merged by the application: unresolved.
- A workflow on a feature branch asks for the application key: not released.
- A not-applicable gate: the release check passes.
- A round with an Opening but no Round record, on the head branch: red.
- The check and the sign-off command given the same records: identical gate state.
- Two writers append an event record at the same sequence: one is refused and re-sequenced.
- Each consumer given an unknown version of any contract: refuses.
- Two rounds on one branch: the gate uses the higher round number.
