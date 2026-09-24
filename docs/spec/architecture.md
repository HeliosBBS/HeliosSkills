# Architecture
Serves: SKL-001

## Purpose
Serves: SKL-001
The map of the estate's whole-codebase review: which subsystem owns what, the programs that take
part, and what they share. Every mechanism is stated once, in the subsystem that owns it; this
document owns only the error classes and the division of work.

## Terms
Serves: SKL-001
As the glossary defines them: review round (round), question set, results repository, finding,
work-order tool, sign-off command. Round runner and triage command are as review-rounds defines
them; developer-verified as review-results defines it.

## Contracts
Serves: SKL-001
Provided: none at this level; each subsystem lists its own.

| Subsystem | Owns | Provides |
|---|---|---|
| review-questions | how a repository declares its groups, classes and questions; the coverage assignment; the agent plan | review question set v1 |
| review-rounds | the round issue, opening and selection, the round lifecycle, agent execution and validation, step-up, refutation, synthesis, the upload, triage, account and credential isolation | review round v1 |
| review-results | the records in the results repository, the conditional update, the developer authorship check, the release gate | review results v1 |

Programs that take part, each built once:
- the work-order tool, in its own repository, builds every operation of these contracts: open,
  select, the round runner's step, mint, the triage command, the developer authorship check, gate
  state and the sign-off command; every repository's rounds use this one build;
- the loop's review mode, one process for the estate under the runner account, drives the round
  runner (review-rounds);
- the estate's defaults repository holds the scheduler, which opens rounds for new release
  branches, and reusable definitions: the release check, which each reviewed repository's
  releases branch calls, and the release step, which publishes a release; each of these mints
  its tokens through mint from the pinned work-order tool;
- the developer's triage session, which reads and presents, and itself writes, signs and runs
  nothing, and whose instructions,
  with the session hook that refuses commands entering the loop machine, live in the estate's
  skills repository;
- in the loop's own repository, the idle task on the developer's computer that starts and stops
  the loop machine, and the loop machine's setup, which creates its accounts, container runtimes
  and network rules.

Consumed from outside the estate: the code-scanning upload interface, which takes SARIF 2.1.0;
the code-hosting service's published REST interface at its dated version 2022-11-28.

Error classes, used by every contract here and owned here:

| Class | Meaning |
|---|---|
| Unavailable | a dependency could not be reached, or an operation passed its bound; a write's outcome is unknown |
| Conflict | a conditional update found the results repository changed since it was read |
| Refused | a policy check failed; the reason is reported |
| Invalid | an input, a record or an agent output failed validation, or a record is tampered |
| NotFound | the named record, issue or branch does not exist |

## Data model
Serves: SKL-001
Every round record lives only in the results repository (review-results). The issue tracker
holds the round issue, which mirrors progress, and is read for issue creators, states and
milestones, and for the fix issues and pull requests the gate reads. Nothing lives only on one
machine except outputs awaiting their push with the nonce they were taken under, developer
records awaiting their push, transcripts, the paused-until times, a runner's identity, its local locks, and the triage
command's hold marker.

## Behaviour
Serves: SKL-001
Round lifecycle: review-rounds. Gate evaluation: review-results.

## Failure directions
Serves: SKL-001
Every gate in the review fails closed: the account check, the round author check, the coverage
check, output validation, the upload-target check, the developer authorship check and the
release gate. Each owner states its own.

## Multi-node invariants
Serves: SKL-001
Every check-then-act is one conditional update of the results repository (review-results). No
runner holds truth in memory, and every step is idempotent (review-rounds).

## Audit
Serves: SKL-001
Developer actions are recorded as developer-verified records in the results repository or, for
alert dismissals, by the code-scanning service
together with the decision record naming the alert (review-rounds, Audit;
review-results, Audit).

## Configuration
Serves: SKL-001

| Key | Default | Kind | Scope | Apply | Exposed by |
|---|---|---|---|---|---|
| service request bound | 60 seconds per request to the code-hosting service or the results repository, after which it is Unavailable | calibration target | fixed | restart | not exposed |

Every other number is listed by its owner.

## Security considerations
Serves: SKL-001
The trust boundaries, each answered in its owner:
- the reviewed tree and extra inputs, hostile to every reviewer (review-rounds);
- the public repositories, logs and CI runs, which never carry finding content (review-rounds,
  review-results);
- the application's credentials, which never silence a finding (review-rounds);
- the application's private key and the round data on the loop machine, separated across its
  operating-system accounts, and the developer's credentials, which the loop machine cannot reach
  (review-rounds, account isolation);
- the references everything leans on, protected on the code-hosting service (review-results);
- the developer's triage, which reads text derived from hostile input (review-rounds);
- the release merge path, which never walks past the gate (review-results).

## Negative tests
Serves: SKL-001
Held by each owner.
