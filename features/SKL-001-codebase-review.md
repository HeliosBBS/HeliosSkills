# SKL-001 Whole-codebase review

Status: approved. Brainstorm record: https://github.com/HeliosBBS/HeliosDesign/blob/main/records/SKL-001-brainstorm.md

## Purpose

At key moments (every release cut, milestones the developer names, and on demand), the
unattended loop reviews a whole repository, one agent at a time, and finds what reviewing one
change at a time cannot: mistakes that span files, security logic duplicated across surfaces,
specs the code no longer matches, and architecture worth rebuilding. Confirmed findings reach
the developer as GitHub code-scanning alerts, and everything is triaged with them in chunks.
A class of mistake that keeps recurring becomes a proposed rule, the way the project's current
rules came from an earlier version of this scanner.

## Behaviour

### Starting a round

- When a release branch is cut, the system shall open a review round for that repository on
  that branch.
- When every other issue in a milestone the developer marked for review has closed, the system
  shall make that milestone's round ready for the loop.
- When the developer opens a round by hand, the system shall run it like any other.
- When ADV-001 is verified, the developer shall open the engine's first round as a pilot, while
  a round is still small and cheap.
- When a round starts, the system shall fix the commit it reviews, and review that commit
  throughout, whatever lands on the branch afterwards.
- If a round is already open for a repository, then the system shall refuse to open a second
  one and name the open round.

### Coverage

- When a round begins, the system shall list every file in the repository, assign each to
  exactly one review group, and check that assignment against the file list.
- If any file is unassigned, or any assigned file does not exist, then the system shall stop
  the round before any review runs and name the files.

### Running

- While a round runs, the loop shall run one review agent at a time, each in a session of its
  own at the model and effort its phase names, and push each finished output to
  `HeliosReviews` before starting the next.
- When a round runs, the system shall run the phases in order: coverage, security, quality,
  specs and documents, architecture, synthesis, upload, triage. A round cut short then has its
  security pass finished, and architecture is judged with the other phases' evidence.
- If a session ends before its agent finishes (a session limit, a crash, a restart), then the
  system shall discard that agent's partial output and run it again, keeping every finished
  output.
- When a phase has no output left to produce, the system shall tick its task and move to the
  next phase.
- If an agent's output fails validation twice, then the system shall run it once more one tier
  up with the failed attempts' notes, and on a further failure stop the round and hand it to
  the developer. A review is never run below its phase's tier.
- When the developer stops the loop, the round shall stop after the current agent and resume
  from the first missing output when the loop restarts.
- When a round finishes, the system shall record how long it took, and the time and usage of
  each phase.

### Reviewing

- When a reviewer examines a group or runs a sweep, it shall not see the ledger or any past
  dismissal.
- When a reviewer reports, it shall state what it checked and what it did not reach; a
  spec-against-code agent shall also report how many of its document's claims it checked.

### Verifying

- When a critical finding is reported, the system shall have three refuters, each in a session
  of its own and without seeing the others, try to refute it, and keep or drop it by majority.
- When a high finding is reported, the system shall have one refuter try to refute it.
- If the refuters cannot decide a finding, then the system shall carry it to triage marked
  unverified.
- When a finding is refuted, the system shall move it to the dropped-findings appendix with the
  refuter's reason.

### Synthesis

- When synthesis runs, the system shall merge duplicates into one finding that lists its other
  locations, and link findings that chain into one attack.
- When a finding matches a dismissed alert or a ledger entry, the system shall list it under
  previously accepted, still visible.
- If a previously accepted finding comes back at a higher severity than when it was accepted,
  or its acceptance is older than the revisit period, then the system shall return it to the
  findings to triage.
- When the same class of confirmed finding appears in three or more places across at least two
  packages, or appears in two rounds in a row, the system shall propose a rule: the lightest
  enforcement that stops it (a linter setting, a test or a hook before a line of written
  policy), shown catching the instances that triggered it.
- When synthesis finishes, the system shall write the round's report to `HeliosReviews`:
  coverage and confidence first, then the findings by priority, then the rule proposals, then
  the dropped-findings appendix.
- If any part of the round was cut short or reached only part of its scope, then the report
  and the upload shall say so.

### Upload

- When the report is written, the system shall upload every confirmed finding that has a
  location in the code to GitHub code scanning, under the review's own category, against the
  reviewed commit and its branch.
- If the upload fails, then the system shall retry it at the next iteration, and after repeated
  failure hand the round to the developer.

### Triage

- When the upload succeeds, the system shall hand the round's triage to the developer as an
  interactive session.
- When the first round of a repository is triaged, the session shall begin with calibration
  before any finding: how severity is spread, the refutation rate, groups that came back
  suspiciously clean, whether coverage notes admit what was skipped, and which sweeps earned
  their cost. The developer's conclusions are recorded before triage continues.
- When triage runs, the session shall present findings in chunks, worst first (must-fix,
  should-fix, backlog, architecture rewrites, rule proposals), and take the developer's
  decision on each: fix, accept with a reason, or reject as wrong.
- When the developer says fix, the session shall open an issue; for a security finding the
  issue describes the work without the exploit path and cites the code-scanning alert; a
  must-fix finding in a release round is attached to that release's milestone.
- When the developer accepts a code-scanning finding, the session shall name the alert for the
  developer to dismiss in GitHub with the reason; when they accept any other finding, the
  session shall write the ledger entry as the developer.
- When the developer rejects a finding as wrong, the session shall record it as a reviewer
  false positive in the round's calibration notes.
- When the developer approves a rule proposal, the session shall open a pull request that adds
  the rule where it belongs, and the rule joins the known-bug-class sweep.

### The release gate

- While a release round has a must-fix finding that is neither fixed nor accepted, the system
  shall not let that release merge to `main`.
- When a hotfix merges to `main`, the system shall require no round; the next release's round
  covers it.

### What the system never does

- The system shall never dismiss a code-scanning alert, never write the ledger except as the
  developer in triage, and never let a reviewer see what was accepted before.

### The engine's questions

The engine's round asks these; every other repository writes its own set when it first needs a
round. Each sweep reads the whole codebase; each lens judges the whole system.

Security:

- Authentication across every surface.
- Authorisation and RBAC bypass.
- Session and token lifecycle.
- Cryptography and secret management.
- Injection and untrusted input parsing.
- The Lua sandbox and the scripting trust boundary.
- Concurrency, races and shared state, as a security property and as correctness.
- Denial of service and resource exhaustion.
- Information disclosure and isolation between users.
- The known bug classes in `CLAUDE.md`, as a dedicated sweep.
- Negative-path tests: does every permission check have one, and would it fail if the check
  failed open?
- Dependencies, supply chain and build integrity.
- The security decisions in the approved briefs: one agent per brief, checking that every
  decision in its threat model is enforced in the code and has a negative test.
- The repository's own automation: the workflows, the loop, the App's permissions and the
  release pipeline.
- Legacy formats and time: the old wire and file formats as hostile input, and the Y2K and
  Y2K38 rule.

Quality:

- Error-handling discipline.
- Resource lifetime and leaks.
- Scalability risks that grow with users, nodes or servers.
- Simplification, duplication and dead code.
- Do the tests actually constrain the code?
- The sysop guide and help text against actual behaviour.
- Naming and style the linters cannot check: names readable without knowing the
  abbreviations, the comment rules, lang-string tags, and Allman braces in Pascal and Lua until
  those have linters.
- Portability across Windows and Linux, x86-64 and ARM.
- Database access patterns and schema use.
- Logging, metrics and operability.
- Consistency of internal APIs and interfaces.
- Settings completeness: every sysop setting exposed in `hadv-config`, documented, secure by
  default, with its `hadv-config-gui` issue.

Architecture and documents:

- Subsystem boundaries, coupling and where responsibility sits.
- The data model and schema, and the cost of getting them wrong.
- Coordination across servers, consistency and where state lives.
- Failure modes, blast radius and recovery.
- Security architecture at the design level.
- Extensibility, the `bbs.*` scripting contract and long-term evolution.
- Deployment, configuration, upgrade and the sysop's experience.
- Spec against code: one agent per `docs/spec/` file, reporting how many claims it checked.
- Consistency across the corpus: the traceability check run as it stands, then contradictions
  between documents and decisions made in code that no document records.
- Contracts against reality: does each repository provide and consume what the contracts
  register says, at the versions it says?
- A completeness critic that audits the review itself, then synthesis.

## Security decisions

1. **Disclosure of findings.** *Attacker:* anyone reading the public repositories, their
   issues, pull requests, CI logs or artifacts. *Abuse:* learning unfixed vulnerabilities with
   working attack scenarios. *Decision:* raw output lives only in the private `HeliosReviews`.
   Alerts are uploaded only against a branch, never a pull request, so the alert list is
   visible only to write access. A public issue describes the work and cites the alert number,
   never the exploit path. Nothing from a round enters a public tree, a CI log, an Actions
   artifact or the loop's log, which records which agent ran and its outcome, never finding
   text. *Why:* a committed or annotated finding is a disclosure, and history keeps it after
   deletion. *Fails closed:* if the upload cannot be confirmed as going to a branch, nothing is
   uploaded.
2. **The code under review is hostile input.** *Attacker:* whoever wrote something a reviewer
   reads: a hostile-packet test fixture, a dependency, a document, a comment. *Abuse:* text
   that tells a reviewer to report nothing, drop a finding or take an action. *Decision:*
   reviewer sessions are read-only, with no edits, no pushes and no GitHub credential.
   Everything in the repository is data, never instructions. Every output is validated, and
   every reviewer must say what it checked; the completeness critic hunts for groups that came
   back suspiciously clean. Refuters work independently. *Why:* the most dangerous injection
   is the quiet one that makes a review report clean. *Fails closed:* output that fails
   validation is run again; it is never read as "no findings".
3. **The pipeline silencing itself.** *Attacker:* a misbehaving agent, or the loop's App.
   *Abuse:* suppressing findings by dismissing alerts or writing ledger entries. *Decision:*
   only plain code, never a model session, holds the credential that uploads, and no step ever
   dismisses an alert. The ledger counts only entries committed by the developer; any other
   entry is ignored and reported. *Why:* anything that can suppress its own findings makes the
   review worthless. *Fails closed:* an entry whose author cannot be verified is ignored, so
   the finding comes back.
4. **The App's new permission.** *Attacker:* anything that obtains the loop's token. *Abuse:*
   the permission to upload scan results (security events) also allows dismissing alerts.
   *Decision:* the developer grants it in the browser. The loop mints the upload token with
   that permission alone, just for the upload step, and build and review sessions get tokens
   without it. *Why:* least privilege; the power to dismiss exists only for the seconds the
   upload runs, and only in plain code. *Fails closed:* if a scoped token cannot be minted,
   nothing is uploaded.
5. **Bypassing the release gate.** *Attacker:* a hurried merge, the developer's own or
   automation's. *Abuse:* releasing with a must-fix finding nobody decided on. *Decision:* the
   gate is a check on the release pull request that stays red while a must-fix finding is
   neither fixed nor accepted. `gh signoff` merges with `--admin`, which skips required
   checks, so a check alone would not hold. The sign-off command therefore refuses a release
   merge while the gate is red. Overriding takes an explicit flag, and the override is
   recorded in the release notes. *Why:* a gate the normal merge path walks straight past is
   not a gate. *Fails closed:* if the round's state cannot be read, the gate is red.
6. **Starting rounds to burn the plan.** *Attacker:* anyone who can open an issue on a public
   repository. *Abuse:* opening review issues so the loop spends a week and a half of the
   plan's usage. *Decision:* the loop runs a round only from an issue the developer or the
   system opened, never one opened by anyone else, and a repository has at most one open
   round. *Why:* a round is the most expensive thing the loop does. *Fails closed:* an issue
   whose author cannot be confirmed is not run.
7. **Dependency failures.** *Decision, each failing to the answer that loses nothing:*
   - GitHub unreachable: the upload waits and retries.
   - `HeliosReviews` unreachable: finished output is kept locally and pushed when it can be,
     and a round cannot finish until everything is pushed.
   - The wrong model served: if the transcript shows a model other than the one the phase
     named, the output is rejected and the agent runs again.
   - A dismissal's date unreadable: it counts as older than the revisit period, and the
     finding comes back.
8. **`HeliosReviews` itself.** *Attacker:* anyone who gains access to the private repository.
   *Abuse:* reading every unfixed finding in one place. *Decision:* access is limited to the
   developer and the App, and this is an accepted residual risk. *Why:* the findings have to
   live somewhere durable, and a private repository with two principals is the smallest
   exposure that still survives a disk failure.

## Limits

| Limit | Kind | Value |
|---|---|---|
| Review agents running at once | fixed policy backstop | 1 |
| Open rounds per repository | fixed policy backstop | 1 |
| Refuters per critical finding | fixed policy backstop | 3, deciding by majority |
| Refuters per high finding | fixed policy backstop | 1 |
| Output validation failures before stepping up a tier | fixed policy backstop | 2, then one tier up, then the developer |
| Upload attempts before the round goes to the developer | calibration target | 3 iterations |
| Rule proposal threshold | calibration target | 3 confirmed locations across at least 2 packages, or the same class in 2 rounds in a row |
| Revisit period for accepted findings | calibration target | 6 months |
| Model and effort per phase | calibration target, in each phase's task tag | Opus at `xhigh` for every review, refutation, critic and synthesis agent; the coverage audit, bookkeeping and upload are plain code |
| Rounds and dropped findings kept | fixed policy backstop | all, for every round |

`xhigh` rather than `max`: on an open-ended hostile review, `max` tends to overthink into
confident false positives, and depth comes from the refutation stage instead.

## Non-goals

- Skipping unchanged groups. Every round is full. This is revisited only once a measured round
  is too long, and then only for groups where nothing they depend on has changed, with the
  skipped groups listed in the report and a full round at every major release.
- Question sets for repositories other than the engine; each is written when that repository
  first needs a round.
- Live exploit verification against a running board, deferred until a board can run locally
  in a container.
- Fixing anything. The review reports; fixes go through issues and `feature-build`, test first.
- Running more than one agent at a time.
- Replacing per-task review, CodeQL or `make check`; it covers what those cannot see and does
  not stand in for them.
- Running on every feature or pull request; rounds happen only at release cuts, at named
  milestones and on demand.
- Dismissing alerts or writing the ledger from the loop.
- Reviewing dependencies' own source; the supply-chain sweep checks what they are, how they
  are pinned, their licences and their known vulnerabilities, not their code.
- Carrying over the old scripts or prompts; only the lessons and the list of questions come
  across.

## Repositories and contracts affected

Repositories that change:

- **HeliosSkills** (owner): the review skill, synthesis, triage, rule proposals and SARIF
  output; the `features/` setup and the contracts below.
- **HeliosAdvance**: the loop gets a path for review issues, one agent per iteration; its tag
  parser learns `xhigh`; a scoped upload token; the check on who opened the issue. The engine
  also gets its own set of review questions.
- **HeliosTools**: `work` recognises review issues. The sign-off command moves in here, so the
  release-gate check travels with it instead of living in one machine's `gh` alias.
- **HeliosBBS/.github**: the `kind:review` label; a workflow that opens a round when a release
  branch is cut; one that makes a milestone's round ready when its other issues close; the
  gate check on release pull requests.
- **HeliosReviews** (new, private): every round's results, the ledger and calibration notes.
- **The organisation's settings**: the developer grants Phaethusa the security-events
  permission in the browser.

New contracts, owned by HeliosSkills, added to the register at version 1:

- **review round v1**: the shape of a review issue, meaning its phases as tagged checklist
  boxes and its labels. Consumers: the loop, `work`, the `.github` workflows.
- **review question set v1**: how a repository declares its review groups and the questions
  its sweeps and lenses ask. Provided by each repository that runs rounds, the engine first;
  consumed by the review skill.
- **review results v1**: the layout of a round in `HeliosReviews`: outputs, report, dropped
  findings, ledger, and the round's gate state. Consumers: synthesis, triage, the gate check,
  the sign-off command.

Consumed from outside the estate:

- **GitHub code scanning**: SARIF 2.1.0 upload through the code-scanning API, a public
  standard.

Order: the owner goes first. HeliosSkills publishes the three contracts, and then the loop,
`work`, `.github` and the engine's question set each move to them as their own tasks.

## Open questions

None.
