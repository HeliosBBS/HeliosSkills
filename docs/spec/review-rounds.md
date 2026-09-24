# Review rounds
Serves: SKL-001

## Purpose
Serves: SKL-001
Runs one review of one repository at one pinned commit, through phases in a fixed order, one
agent at a time across the estate: outputs validated, serious findings verified by independent
refuters, everything merged into one report and one code-scanning upload, then handed to the
developer for triage. It never fixes code, dismisses an alert or writes an acceptance.

## Terms
Serves: SKL-001
As the glossary defines them: review round (round), question set, results repository, finding,
work-order tool, sign-off command. This document introduces:

- Round issue: the tracker issue that represents a round (review round v1).
- Trigger: release (a release branch was cut), milestone, or hand.
- Ended: a round has ended once its triage-complete or close record is written, or the round
  runner writes its End record. A tracker close of the issue of a round that has not ended, by
  anyone, the developer included, ends nothing and is reopened and reported; the close of an
  ended round's issue is only its mirror.
- Stop file: the developer's instruction to stop the loop between steps.
- Session limit: the model service ending one session before it finishes, which makes that
  attempt incomplete. Usage limit: the plan's allowance running out, recognised only from the
  model service's own structured signal, never from model-written text, which pauses the loop
  and records no failed or incomplete attempt; a session end with no such signal is an
  incomplete attempt.
- Build loop: the loop's mode that builds work items one task at a time.
- Loop machine: the virtual machine on the developer's computer that the loop runs in
  (Security considerations, account isolation).
- Waiting round: a round with an Opening, no Round record, and not ended.
- Started round: a round with a Round record that has not ended.
- Previous round: the latest earlier round of the repository that has a synthesis record.
- First round: the repository's first round that has a synthesis record.
- Round runner: the program that runs rounds, built once in the work-order tool.
- Review mode: the loop's mode that drives the round runner (Contracts).
- Runner account, build-session account, review-session account, sandbox account: the loop
  machine's operating-system accounts (Security considerations, account isolation); the last
  three are the session accounts.
- Isolated environment: a disposable container under the sandbox account holding no credential,
  with no network and no access to any other file, used to gather inputs that process the tree
  and to demonstrate rule proposals.
- Fetch environment: a disposable container under the sandbox account with network but no
  credential and no access to any other file, which reads a tree's dependency declarations as data, runs none
  of the tree's code, and hands what it fetched read-only to an isolated environment.
- Pinned commit: the commit the round reviews throughout.
- Phase tier: the model and effort a phase runs at, copied into the Round record at start; plain
  means plain code with no model; session means the developer's triage.
- Attempt: one run of one agent key, with outcome accepted, invalid, incomplete, model-mismatch,
  paused or stopped.
- Refuter: an agent that tries to refute one finding and returns refuted, upheld or undecided,
  with a reason.
- Severity: critical, high, medium, low or informational (Data model).
- Security finding: a finding whose class the question set marks security, a finding from the
  security phase, or one carrying an attack scenario.
- Finding status: confirmed, unverified or dropped.
- Priority: must-fix, should-fix, backlog or architecture rewrite.
- Rule proposal: a proposed enforcement for a recurring finding class.
- Security proposal: a rule proposal whose class the question set marks security, or any of
  whose instances is a security finding (its merged finding's security flag); everything the
  design says of a security class's rule applies to it.
- Cut short: the developer's instruction to skip the review phases after security.
- Fix issue: a work item triage opens for a finding the developer decided to fix.
- Triage command: the work-order tool's command the developer runs in their own terminal to
  record triage (Behaviour, Triage).

## Contracts
Serves: SKL-001
Provided: **review round v1**: the round issue, the fix issue, the tier tags, the agent output
formats, the review mode's contract, and the operations below.

**The round issue.** Labels: kind:review; exactly one of P0 to P3 (the application round
priority when the application opens it); unattended-loop; human-action-required while handed to the developer, or once the round runner reports a tracker
close of an unended round, until the developer removes it. Body, in CommonMark 0.31.2, with these level-three headings in this order:
- `### Files`: the line "The whole repository at the pinned commit."
- `### Exact change`: the line "None: a review changes no code."
- `### Reason`: the trigger and, for a milestone round, the milestone.
- `### Round`: the lines `Contract: review round v1`, `Branch: <branch>`, `Trigger: <release,
  milestone or hand>`, and, once started, `Pinned commit: <commit>` and
  `Round: <repository>#<number>`.
- `### Plan`: these lines, in this order, each ticked when its phase completes, each tag showing
  that phase's tier:

  ```
  - [ ] 1. Coverage [tier: plain]
  - [ ] 2. Security [tier: opus, effort: xhigh]
  - [ ] 3. Quality [tier: opus, effort: xhigh]
  - [ ] 4. Specs and documents [tier: opus, effort: xhigh]
  - [ ] 5. Architecture [tier: opus, effort: xhigh]
  - [ ] 6. Synthesis [tier: opus, effort: xhigh]
  - [ ] 7. Upload [tier: plain]
  - [ ] 8. Triage [tier: session]
  ```

The body is a mirror, never read: branch, trigger and milestone come from the Opening, and the
pinned commit and phase tiers from the Round record; each iteration repairs the body's lines,
tags and ticks from those records. A tier tag is `[tier: plain]`, `[tier: session]`, or
`[tier: <model>, effort: <effort>]` with model one of haiku, sonnet, opus and effort one of low,
medium, high, xhigh, max.

**Fix issue references.** A pull request names a fix issue in its body as `Fixes
<repository>#<number>`, the repository being the reviewed repository even for a pull request in a
sibling. The sign-off command offers only fix issues of reviewed repositories that carry the
kind:bug label and a Round line and were created by the developer's pinned identity.

**The fix issue.** Labels: kind:bug; the priority label for its finding's priority
(Configuration); security-sensitive for a security fix issue. Body, with these level-three
headings in this order:
- `### Files`: for a security fix issue, the line "See the cited alert, or, with none, the round
  named below."; otherwise the paths of its finding's locations.
- `### Exact change`: for a security fix issue, the line "See the cited alert, or, with none, the
  round named below."; otherwise the finding's fix approach.
- `### Reason`: for a security fix issue, the class's description from the question set and the
  alert number, if any; otherwise the finding's title and description.
- `### Plan`: the line "Not yet planned."
- `### Round`: the line `Round: <repository>#<number>, <merged key>`.
- `### Base`, for a must-fix finding of a release round and for any finding located only in a
  sibling repository: the lines `Repository: <repository>` and `Branch: <branch>`, naming the
  round's repository and branch, or, for a finding located only in a sibling repository, that
  sibling and its integration branch; the fix
  is built from that branch and its pull request targets it. Without a Base section the fix is
  built from, and targets, the reviewed repository's integration branch. A fix issue is always
  opened in the reviewed repository, and for a sibling-located finding it only tracks the fix:
  the build loop never builds a fix issue whose Base names another repository; its plan opens the
  work as a work item in the sibling, whose pull request names the fix issue in the reference
  form.
**Rule work items.** The tracked work item for a security proposal, opened by decide, and the
work item in an owning repository for enforcement that lives there, opened by rule-pr, carry the
labels
kind:infra and P2, the tracked one also human-action-required since its next step is the
developer's rule-pr, and with the sections Files ("See the Rule record named below."), Exact
change ("See the Rule record named below."), Reason (the class's description from the question
set), Plan ("Not yet planned.") and Round (`Round: <repository>#<number>, <proposal key>`); no
model-written field enters either, except that rule-pr, when it runs, writes the enforcement
content, the raw content whose escaped rendering the developer was shown, into the
owning-repository work item's Exact change, where it is public only once rule-pr may run.

A security fix issue is one for a security finding, or one the developer marks
security-sensitive when asked. Its title is typed by the developer, and no model-written field
enters its body; any other fix issue's title is its finding's title.

**Agent outputs.** Each is one JSON document (RFC 8259, UTF-8) returned as the session's final
message, with field "version" of "review-output/1" and field "agent" echoing its agent key:
- Kinds sweep, group-review, lens and critic: kind "review"; checked (array of scope names);
  not_reached (array of {scope, reason}); claims_checked (integer for a per-spec question, else
  null); findings (array of {title, class, severity, cwe (string or null), locations (array of
  {repository (null for the reviewed one), path, start_line, end_line}), subject (string or
  null), description, evidence, attack_scenario (string or null), fix_approach, verification}).
  A finding has at least one location or a subject. Scope names: for a group review, the group's
  paths; for a sweep or lens, the group names; for a per-spec or per-brief question, its document
  and the group names; for the critic, every agent key in the plan before it; plus, for every
  question, the names of the extra inputs it declares.
- Refuter: kind "verdict"; finding (the finding key); verdict (refuted, upheld or undecided);
  reason.
- Synthesis: kind "synthesis"; merges (array of {members: array of finding keys, title,
  description}); chains (array of {members: array of merge positions, narrative}).
- Rule proposer: kind "rule-proposal"; class; enforcement (linter-setting, test, hook or policy);
  owning_repository; content (the enforcement itself); instances (array of merged keys).

**The review mode's contract.** One review-mode process runs for the whole estate, under the
runner account, and only while the loop machine runs (Security considerations, account
isolation). It exits when every repository's step returns nothing to do, and at start it exits at once
while its own paused-until time, set by a usage-limit pause, has not passed. Each step goes through the repositories that have any Opening record, in byte
order of name; for each, it calls run step for the round its round head names when that round is
in coverage, reviewing, synthesis or upload, and otherwise for the round select names, and it
stops at the first call that returns ran, halted or paused; a round in triage is skipped, and
so is a round halted for the developer: one whose latest failed attempt ran at the step-up tier,
or whose incomplete attempts in a row or upload attempts, each counted since its latest retry
record, reached their bound, or whose current agent key's recorded usage since that key's
latest retry passed the agent usage bound. Run step returns ran, nothing to do, halted (handed to the developer) or paused
(a usage limit: both leases are released by conditional update, the session's time and usage
are recorded in a paused Attempt that counts toward neither failures nor incompletes, the next
take uses the next attempt number, and the paused-until time is set to the service's reset,
capped by the usage-limit pause bound). The stop file is
read between steps. At most one review-mode process runs per installation: it holds an exclusive
local lock, and a second process exits.

Operations, each built once in the work-order tool:
- **open(repository, branch, trigger, milestone?)** creates a round. The scheduler calls it as
  the application with trigger release: a conditional update creates the branch's release claim,
  or finds it. When the claim names an issue with an Opening, open returns that round; when it
  names an issue without one, open writes that issue's Opening; when it names none, open creates
  the round issue, records it in the claim, then writes its Opening. The developer calls it with
  trigger milestone or hand: it is Refused while the repository has a started round, naming it;
  otherwise it creates the round issue and writes its Opening, signed with a review-signing key.
  A developer may open a new round on a branch whose earlier rounds have all ended. An issue left
  without an Opening is never a round, and nothing touches it except open completing the issue a
  release claim names.
- **select(repository)** answers which round the round runner may start: none while the
  repository has a started round; otherwise the lowest-numbered waiting round that, when its
  trigger is milestone, has no other open issue in its milestone. An issue counts as closed only
  when the service records its close as made by the developer's account, or as caused by a pull
  request the developer's account merged, through that pull request's closing reference; an
  issue another account removed from the milestone still counts as in it; events that cannot be
  read mean the round is not selected. A pure read over Opening
  records, computed afresh at every call; tracker labels and body lines never identify a round.
- **run step(repository)**: the round runner's one iteration (Behaviour).
- **the triage command**, each form with enumerated arguments only, prompting for any free text
  itself: session(round), which starts the triage session and relays each line the developer
  types to it and each of its replies back, escaped; decide(round, merged key or proposal key,
  decision); calibrate(round);
  complete(round); close(round); cut(round); retry(round, agent key or "upload"), whose
  from-attempt is the target's latest attempt number; rule-pr(round, proposal key), which opens the
  approved proposal's pull request, rewrites the Rule record with it and closes any tracked work
  item, and which, for a security proposal, is refused while any instance is not fixed
  (review-results, the fixed rule); a fix issue, fixed record or merge identity that cannot be
  read counts as not fixed (Behaviour, Triage).
- **mint(scope)**: the one implementation that mints an application token, wherever the key is
  held: on the loop's machine under the runner account, and in the estate's workflow runs from the
  pinned work-order tool. It returns a token with exactly the permissions and repository of its
  caller's row in Credential isolation, and refuses the results repository for every row but the
  results rows.

Round issues are never picked by the ordinary work selection, which skips any issue labelled
kind:review, and never carry a claim; the round head is their only arbiter.

Error classes (architecture): Refused (a failed author check, Behaviour, Start; a developer open
while a round is started; an unknown contract version; an absent branch); Invalid (no question set, a coverage failure, or an extra input that cannot be
gathered). A Refused or Invalid round ends by its End record.

Versioning: the Opening carries the contract version, which the body's Contract line mirrors;
every consumer refuses a version it does not know.

Consumed: review question set v1; review results v1; the model service's session interface and
its transcripts; the code-scanning upload interface, which takes SARIF 2.1.0; the code-hosting service's published REST interface at its dated version
2022-11-28, for issues, issue events, milestones, commit statuses, installation tokens with an
explicit permission subset and repository list, and code-scanning alerts.

## Data model
Serves: SKL-001
Records, and their check-then-act rules, are review-results'. This subsystem adds:
- **Round identity:** the repository and the round issue's number, which the tracker never
  reuses.
- **Runner identity:** a random identifier of the runner identity and nonce length, created once
  per installation and kept locally; each iteration adds a fresh random nonce of that length, kept
  locally with the iteration's unpushed output until it is pushed.
- **Agent key:** as in review-questions; a refuter's key is `refute/<finding key>/<index>`, the
  index counting from 1; a rule proposer's key ends with "/" and its class name.
- **Attempt number:** the next integer for the agent key, assigned in the update that takes the
  leases.
- **Finding key:** the agent key, "#", and the finding's position in that output from 1.
- **Merged key:** "merged#" and a number from 1, assigned after combining, in order of each
  merged finding's lowest synthesis position.
- **Fingerprint:** computed by plain code, never by a model, so the same defect keeps its
  identity while its code is unchanged or moves within its file: SHA-256 over the class, the
  repository (null for the reviewed one, encoded as the empty string) and path of the first
  location, and that location's lines with all whitespace removed, joined by line feeds; without
  a location, SHA-256 over the question name and the subject.
- **Severity**, as the reviewer reports it against this scale:
  - critical: reachable in a default configuration by a party with no or low privilege to take
    control, read or destroy others' data, or pass a gate; or loses or corrupts data for every
    user;
  - high: the same harm with a precondition (a role, a non-default setting, a race), or a defect
    that corrupts data or stops a service;
  - medium: harm with limited reach or an unlikely precondition, or a rule violation a likely
    change turns into high;
  - low: no reachable harm today;
  - informational: an observation, not a defect.
  An architecture finding is rated by the cost of leaving it on the same scale.
- **Verification outcome:**

  | Severity | Refuters | Dropped | Confirmed | Unverified |
  |---|---|---|---|---|
  | critical | the refuters per critical finding, each in its own session, none seeing another's verdict | a majority say refuted | a majority say upheld | any other split |
  | high | the refuters per high finding | refuted | upheld | undecided |
  | medium, low, informational | none | never | always, as reported | never |

- **A merged finding**, set by plain code from its members: class, the highest-severity member's,
  ties going to the lowest finding key; severity, the highest member's;
  status, confirmed if any member is, else unverified; security, if any member is a security
  finding; its fingerprints, every member's; chains never change a severity. Merged findings that
  share any fingerprint are combined by plain code into one. Priority, fixed by severity and phase
  alone, never by a model: critical or high is must-fix whatever its phase; below high, a finding
  with an architecture-phase member is an architecture rewrite; otherwise medium is should-fix,
  and low and informational are backlog.
- **Time sources:** round start and durations from the round runner's clock; acceptance dates
  from the developer-verified record, or the service's dismissal time.

## Behaviour
Serves: SKL-001

**Opening.** The scheduler, run from the estate's defaults repository's default branch at the
scheduler interval, scans every repository's release branches; for each whose head holds a
question set and whose release claim names no round with an Opening, it calls open as the
application with trigger release and the milestone titled with the branch's version (for
"release/v1.2.0", "v1.2.0"), creating the milestone if absent, with the scheduler's tokens
(Credential isolation). The Opening records the milestone's number. The developer opens a
milestone round with that milestone, or a round by hand with a branch.

**Start.** The round runner calls select, then, for the round it names:
1. **Account check** (Security considerations): any failure means nothing runs.
2. **Author check:** the issue's creator and the Opening's opened_by must be the same pinned
   identity; an application Opening must have trigger release on a branch matching the release
   branch pattern and be the round its branch's release claim names; a developer Opening must be
   developer-verified. A creator or event
   that cannot be read: not run, and the round keeps waiting. Any other failure: the End record,
   with the reason, and the issue closed as its mirror.
3. **Claim the slot:** the conditional update that succeeds only if the repository's round head
   is empty, names a round that has ended, or already names this round; otherwise the iteration
   ends and this round keeps waiting.
4. **Pin the commit and the tiers:** in the same update, the Round record takes the Opening
   branch's head as the pinned commit, and each phase's tier from the round runner's
   configuration.
5. **Coverage and inputs**, in plain code: load and assign at the pinned commit, and gather the
   extra inputs its questions declare, each input that processes the tree inside the isolated
   environment, supplied by the fetch environment, by pinned programs only (review-questions). Any Invalid writes
   the End record, naming the
   fault, and closes the issue as its mirror; on success the coverage and input records are
   written and the box is ticked.

**Each iteration** runs one agent:
1. Push first any output left pending from an earlier iteration, under the nonce it was taken
   with, by a conditional update that re-checks both leases, then tick and release both leases as
   step 7 does; if they no longer name that nonce, discard it.
2. Recompute the plan and find the first agent key with no accepted output.
3. Take the estate lease and the round lease together, under this runner's identity and a fresh
   nonce (review-results, Data model); otherwise the iteration ends. If the review-session
   account's lock is taken, by the build loop's diff review for example, it releases both leases
   and ends the iteration. A process holding the local
   lock that finds a lease naming its own runner identity under another nonce, with no output
   pending under that nonce, takes it over at once. Every takeover first records an incomplete
   attempt for the lease's attempt number.
4. Build the agent's input in plain code, as a read-only copy the review-session account can read
   and nothing else: the tree at the pinned commit; the question text; the extra inputs the
   question declares; for lenses, the round's accepted outputs; for the critic, those and the Coverage record; for synthesis, the
   confirmed and unverified findings; for a rule proposer, its class's instances. No input ever
   carries a decision, a dismissal, a prior acceptance or an ignored record; a refuter's input carries
   the tree at the pinned commit, any sibling tree its finding is located in at its recorded
   commit, and only the one finding it tests.
5. Probe as the review-session account (Security considerations, account isolation); then start
   the session under the review-session account at the phase tier the Round record names, or one
   tier up for a stepped-up attempt,
   in a fresh home and transcript location of its own, with a working directory outside its
   input, loading configuration only from the round runner's fixed configuration and no
   settings, instruction files, hooks or tool servers from its input, with the model service's
   credential, handed in by the runner for that session, as the only credential present, bounded
   by the agent session bound; a session over the bound is ended and the attempt is incomplete.
6. When the session ends, move its transcript to the runner account and delete it, the
   session's home and its input copy from the review-session account; read from it the model that served every message, which must be one of
   the served model identifiers for the tier's model, and validate the output; the runner sets
   the effort, and the transcript is not used to verify it. A transcript that is missing or
   unreadable, or any message without a model, is model-mismatch.
7. Commit the outcome locally, push it under its nonce by a conditional update that re-checks
   both leases, tick the phase box when the phase is complete, then release both leases. At most
   once per progress-line interval, post on the round issue the line "Round in progress: <phase>"
   and nothing else.

**Round issue integrity.** Each iteration also reads the events of every round issue of the
repository that has an Opening and no triage-complete, close or End record. A tracker close of
such an issue, by any account, the developer's included, ends nothing: the runner reopens the
issue, labels it human-action-required and reports it; to abandon a round the developer uses the
triage command's close.

**Validation.** Plain code checks every output: valid JSON of its kind within the output size
bound; the agent key echoed; checked and not-reached together covering its scope; a per-spec
output's claims count; every finding with a class from the question set's vocabulary, a severity
from the scale, and either a subject or locations whose paths exist in the reviewed tree at the
pinned commit, or in a sibling tree at its recorded commit, with lines within the file; a
security-phase finding with an attack scenario; a refuter verdict with a reason; synthesis
accounting for every confirmed and unverified input finding exactly once, with merges and chains
naming keys that exist; a rule proposal naming its enforcement, content and instances, and an
owning repository that is the reviewed repository or one the register names, never the results
repository. An output that fails any check is invalid and is never read as "no findings". A
severity, status or priority in a synthesis output is ignored; plain code sets them.

**Attempts and step-up.**
- An invalid or model-mismatch attempt counts toward its agent key's failure count; counts cover
  only attempts after the latest retry record's from-attempt for that key.
- After the failed attempts before step-up, one more attempt runs one tier up (Configuration), given the failed
  attempts' validation messages, which plain code writes and which never quote the model's
  output.
- A failure at the higher tier halts the round for the developer, and so does an agent key whose
  recorded usage since its latest retry passes the agent usage bound.
- An incomplete attempt (a session end, a crash, a disconnect, a takeover) is discarded and
  recorded as an incomplete Attempt, without counting toward failures; incomplete attempts in a
  row for one agent key halt the round at the incomplete attempts in a row before the developer; a
  paused or stopped attempt neither counts toward such a run nor breaks it.
  A usage-limit pause is recorded as a paused attempt, counting toward neither failures nor
  incompletes; an immediate stop is recorded as a stopped attempt, counting toward neither (Security
  considerations, account isolation).
- No attempt runs below its phase tier; the first attempt after a retry runs at the phase tier.

**Cut short.** A developer-verified cut-short record takes effect once the security phase is
complete: the quality, specs-and-documents and architecture phases are complete with no outputs,
their boxes ticked with the note "skipped", and the report and the upload say so.

**Synthesis phase:**
1. The critic runs, then synthesis.
2. Plain code builds the merged findings (Data model) and applies prior acceptances by
   fingerprint; no model sees one. A prior acceptance is a developer-verified accept or reject
   decision in an earlier round of the repository, or a code-scanning alert in the review's
   category dismissed by the developer's account and named by a developer-verified decision
   record, read with the synthesis token; a dismissal by any other account, or one whose
   dismissing account cannot be read, is ignored and reported, as is a dismissal no decision
   record names; an alert list that cannot be read ends the iteration, synthesis being retried. A dismissed alert's fingerprints are those of the
   merged finding its round's alert map pairs it with. A merged finding is previously accepted
   only when every one of its fingerprints matches a prior acceptance; the lowest accepted
   severity and the oldest date among them count. For one fingerprint matched by both a decision
   and a dismissal, the decision's severity and the older date count; a dismissal named only by a fix
   decision takes the severity the finding had in the round that uploaded it.
3. The revisit rule, stated here and applied only here: a previously accepted finding is listed
   as such unless its acceptance is older than the revisit period, its date cannot be read, its
   accepted severity is lower than the finding's severity now, or that severity cannot be read,
   in which cases it returns to triage undecided. In a release round a previously accepted
   must-fix finding is listed as needing a fresh decision.
4. Plain code counts, for each class, the locations of its confirmed merged findings, each in the
   group its path falls in (a subject-only finding, or a location in a sibling repository, counts
   as one place in no group): a class with at least the rule-proposal threshold, or confirmed in
   this round and the previous round, adds its rule proposer to the plan.
5. After the last rule proposer, plain code writes the synthesis record and the must-fix list,
   and renders the report: coverage and confidence first (every not-reached statement, every
   skipped phase, the question set's verified change and digest, every agent key that ran, every ignored or tampered
   record, every close without a close record), then the findings by priority, then the rule
   proposals, then the dropped appendix with the refuters' reasons.

**Upload**, in plain code:
1. Confirm the target is a branch reference, the round's branch, which exists and contains the
   pinned commit; anything else, including a pull-request reference or a failed read, uploads
   nothing.
2. Mint the upload token.
3. Build one SARIF 2.1.0 run: the tool name and category (Configuration); one result per
   confirmed merged finding with a location in the reviewed repository, its message beginning
   with its merged key, its rule identifier the class, its partial fingerprint under the
   fingerprint key being SHA-256 over its member fingerprints sorted, each followed by a line
   feed, its other locations related
   locations, its security severity the fixed number for its severity; when the round was cut
   short or reached only part of its scope, the invocation is marked unsuccessful with a
   notification naming what was not covered. An unverified finding reaches the developer only
   through the report.
4. Upload it against the pinned commit and the branch, wait for processing up to the upload
   processing bound, and write the alert map, pairing each alert with the merged key that begins
   its message.
5. Revoke the token and record the upload attempt; a wait over the bound is a failed attempt.

**Triage**, run by the developer:
- The triage session is a model session the triage command starts, with a read-only tool
  allowlist confined to the round's records in the developer's local copy of the results
  repository and to the tree at the pinned commit, with a working directory outside both, loading
  configuration only from the triage command's own fixed configuration, which includes the
  triage session's instructions from the estate's skills repository, and none from the
  developer's user or plugin settings, hooks or tool servers: it holds no shell, no network, no credential and no read access
  outside those paths. It presents the findings and shows, for each, the triage command's
  enumerated arguments as text, never a reason or any other free text as a line to paste.
- The triage command's session form runs the triage session non-interactively, one exchange per
  line the developer types, and renders every model message itself. Everything the triage command
  or the sign-off command prints that comes from an agent output, a record written from one (a
  finding title), a tree, a demonstration or the tracker (an issue's title or body), the triage
  session's messages included, is shown with each control character, other than line feed and tab, replaced by
  a visible escape; nothing is rejected for holding one, since a hostile-packet fixture
  legitimately carries control bytes.
- The developer records everything with the triage command in their own terminal. It takes only
  enumerated arguments, prompts for any free text itself and stores it literally, writes each
  developer record as one commit signed with a review-signing key, opens fix issues as the
  developer, and names alerts for the developer to dismiss in the service's web interface. No
  model runs it.
- A repository's first round opens with calibration from plain-code statistics: the severity
  spread, the refutation rate, per-group finding counts with the zeros, the not-reached lists,
  findings and usage per question; the developer's conclusions are recorded before triage goes
  on, and in that round decide and complete are refused until a developer-verified calibration
  record exists. complete is refused while any finding needing a decision has no
  developer-verified decision.
- Findings follow in chunks, worst first: must-fix, should-fix, backlog, architecture rewrites,
  rule proposals. Each finding needing a decision gets fix, accept with a reason, or reject as
  wrong; a previously accepted finding is listed, and needs a decision only when it is a must-fix
  finding in a release round, shown pre-marked.
  - fix opens a fix issue (Contracts); for a finding that is not a security finding it first asks
    the developer, defaulting to yes, whether it is security-sensitive; it first looks for an
    existing fix issue created by the developer's pinned identity whose Round line names this
    round and merged key, that no decision record of the repository names as its fix issue other
    than this round's own decision for this merged key, and shows its number, title and open or
    closed state for the developer to confirm before using
    it, reporting any other issue carrying that line; a must-fix
    finding of a release round goes on the milestone titled with its branch's version, created if
    absent, with the Base the fix issue contract gives it;
  - accept of a finding with an alert names the alert to dismiss with the reason; accept of any
    other finding is a ledger entry;
  - reject names the alert, if any, to dismiss as a false positive; the calibration record's
    false positives are derived from the reject decisions.
- A rule proposal is shown catching its instances before the developer decides. The triage
  command shows the enforcement's full content. Catching is judged by the triage command from the
  exit status and reported locations of the pinned tool that runs the enforcement's kind
  (demonstration tool digests), never from text the content prints: a linter
  setting catches an instance when the linter reports a location within the instance's lines; a
  test, run by the pinned test runner for its language with the dependencies the
  fetch environment supplied, catches the instances when it fails at the pinned commit, each instance then shown for the
  developer to judge; a hook catches an instance when it refuses a change that introduces the
  instance's lines. A linter setting, a test or a hook is run against
  a scratch copy of the pinned commit inside the isolated environment, supplied by the fetch
  environment with the dependency cache the repository's build declares, and run by the pinned
  tool for its enforcement kind and the language of the files it checks (demonstration tool
  digests), never by a tool
  the tree declares; one that
  cannot run without the network is shown as not demonstrated and cannot be approved, and so is
  one that runs but misses an instance. For a demonstration, the triage command first writes its hold
  marker, then waits until no loop mode is running, starts the loop machine if it is off, fetches the pinned commit with the
  developer's credential, checks that its object name is the pinned commit, and copies the tree
  into the machine, reaching it through the administrator entry the accepted residual names, and
  asks the runner account to run the demonstration as the sandbox account under that account's
  lock and probe, as for any environment; its hold on the machine is a marker on the developer's computer
  carrying the command's process identity, which the idle task treats as released once that
  process is gone. A policy is
  shown with each instance quoted against its text, needs no run, and can be approved. The
  decision is a rule record. An approved proposal's pull request is opened by rule-pr: for any
  proposal that is not a security proposal, at once, decide(approve) running rule-pr itself; for
  a security proposal, only once every
  instance is fixed (review-results, the fixed rule), the triage command having opened a tracked
  work item, written from fixed text and
  blocked on them. An instance accepted or rejected rather than fixed keeps a security proposal
  from landing, since the rule would flag it in public; the developer may reject the proposal
  instead. That pull request adds the class, marked known, to the
  question set by a commit the developer signs with a review-signing key, on a branch of its own,
  together with any enforcement that lives in the question set's repository, as the raw content
  whose escaped rendering was shown;
  enforcement in another repository is a work item rule-pr opens in the owning repository, written
  from fixed text and citing the Rule record, with the enforcement content rule-pr adds, which the
  build loop may build; for a security proposal it is blocked on the same fix issues.
- Triage ends with the triage-complete record, naming the must-fix set the developer saw and
  triage's duration; the developer ticks the box and closes the issue as its mirror. When the
  developer
  abandons a round before triage-complete, the triage command writes a close record with the
  reason and closes the issue.

**Finish.** When the upload succeeds, the summary records the round's duration and each phase's
time and usage up to the upload; triage's time is recorded in the triage-complete record.

**State table.** States: **W** waiting; **C** coverage and inputs; **R** reviewing (security
through architecture, one agent key current); **S** synthesis; **U** upload; **T** awaiting or in
triage; **H** halted for the developer; **X** ended. Input classes: normal; invalid (the output
fails validation); session end (a session limit or the agent session bound); crash (a crash or
disconnect); duplicate (a re-run agent, a retried upload, a re-delivered open); other runner (a
concurrent action from another runner or process); tracker fails; results fails; upload fails;
wrong model (the served model differs, or the transcript cannot show it); stop (the developer
stops the loop between steps); cut (the developer cuts the round short); usage limit or immediate
stop.

| State | normal | invalid | session end | crash | duplicate | other runner |
|---|---|---|---|---|---|---|
| W | selected: account and author checks, claim, pin; to C. A check fails for good: End record; to X. Slot held by a round that has not ended: stays W | cannot occur | cannot occur | claim not written: stays W; written: the next iteration finds it held by this round and continues | a second application open for the branch returns or completes the same round | one claim succeeds; the other re-reads and stays W; a second process of one installation exits on the local lock |
| C | assignment and inputs valid: record, tick; to R. Invalid: End record naming the fault; to X | an absent, malformed or unverified set is a coverage failure; to X | cannot occur: plain code | nothing recorded: coverage re-runs deterministically | the second record is refused as present | leases held: the iteration ends |
| R | valid: push, tick when the phase is complete; stay R, or to S after architecture | below the failed attempts before step-up: stay R; at it, one tier up; a higher-tier failure: to H | discarded, recorded incomplete; stay R; at the incomplete attempts in a row before the developer: to H | the pending output is pushed first at restart; otherwise the same runner takes the lease over at once, recording the attempt incomplete | an output already accepted for the key: the new one is discarded | leases held and not expired: the iteration ends; expired: take over, recording the attempt incomplete, and the old holder's push is refused and discarded |
| S | each agent valid, merged findings built, acceptances applied, records and report written, tick; to U | as in R; synthesis losing a finding is invalid | as in R | as in R | as in R | as in R |
| U | uploaded and processed: record, tick, summary, hand over; to T | cannot occur: plain code | cannot occur | before recording: the next iteration re-uploads; the same commit, branch and category supersede | a retried upload supersedes | leases as in R |
| T | every finding needing a decision decided and triage-complete written; to X, the developer's close of the issue mirroring it | an unverified developer record is ignored and reported; the finding stays undecided | the developer resumes; pushed records persist | as session end | a repeated value record: the latest verified change wins | no runner acts in T |
| H | a retry record naming the target and from-attempt: back to the state it halted in, at the phase tier. Or a close record: to X | cannot occur | cannot occur | cannot occur | a repeated retry record changes nothing | runners skip it: human-action-required |
| X | nothing runs; the slot counts as free | cannot occur | cannot occur | cannot occur | an ended round is never selected, whatever its issue's state | cannot occur |

| State | tracker fails | results fails | upload fails | wrong model | stop | cut | usage limit or immediate stop |
|---|---|---|---|---|---|---|---|
| W | select, the creator, the events or a milestone's issues unreadable: not run; stays W | the claim fails: the iteration ends; stays W | cannot occur | cannot occur | the stop takes effect before start | recorded; applies in R | the stop takes effect before start |
| C | the tick fails: re-ticked next iteration from results | the record is not pushed: the iteration ends; the round cannot pass C | cannot occur | cannot occur | stops after coverage | recorded; applies in R | no effect: plain code |
| R | a tick, comment or event read fails: reconciled next iteration | the output stays local under its nonce; no next agent starts; pushed first next iteration if both leases still name that nonce, else discarded | cannot occur | a failed attempt; re-run | stops after the current agent; resumes at the first missing output | honoured once security completes; later review phases skipped; to S | the session ends and both leases are released; a usage limit records a paused attempt, an immediate stop a stopped attempt; stays R |
| S | as in R | as in R; synthesis reads only pushed outputs | cannot occur | as in R | as in R | already past | as in R |
| U | the tick fails: reconciled next time | the upload attempt is not pushed: the next iteration re-uploads idempotently | target unconfirmed, token not minted, upload refused or processing over the upload processing bound: nothing counts as uploaded; a failed attempt; at the upload attempts before the developer, to H | cannot occur | stops after the upload step | already past | the step stops and both leases are released; the upload re-runs next time, idempotently |
| T | a fix issue cannot be created: the decision is not recorded until it exists | developer records stay local until pushed; the gate stays red meanwhile | alert reads fail: shown as state unknown; decisions still taken | cannot occur | cannot occur | cannot occur | no effect on triage: no loop mode acts in T |
| H | the label is not written: re-derived and written next iteration | the halt is re-derived from results next iteration | cannot occur | cannot occur | no effect | cannot occur | no effect |
| X | cannot occur | cannot occur | cannot occur | cannot occur | no effect | cannot occur | no effect |

Concurrent action on the round issue while a runner is mid-agent:

| State | The developer closes it | Another account closes it | The developer writes a record |
|---|---|---|---|
| W | nothing ends; reopened, reported | nothing ends; reopened, reported | a cut short is kept until R; a close record ends the round |
| C, R, S, U | nothing ends; reopened, reported | nothing ends; reopened, reported | the runner's update is refused once, re-read and retried; it sees the record at its next plan; a close record ends the round, the slot counts as free, and the old holder's next update finds the head's round ended, so its push is refused and its output discarded |
| T | nothing ends; reopened, reported | nothing ends; reopened, reported | the normal triage path |
| H | nothing ends; reopened, reported | nothing ends; reopened, reported | a retry resumes it; a close record abandons the round |
| X | cannot occur | ignored: the round has ended | ignored, except a rule record rewritten by rule-pr and a fixed record |

## Failure directions
Serves: SKL-001

| Dependency | On failure | Direction |
|---|---|---|
| Issue tracker | creator, events, selection or milestone unreadable: not run; ticks, tags and comments reconciled next iteration | closed |
| Results repository | nothing advances past the last pushed output; local outputs and developer records wait; no round finishes with anything unpushed | stall, lose nothing |
| Code-scanning service | nothing counts as uploaded; retried each iteration; at the upload attempts before the developer, to the developer | closed |
| Token minting | nothing uploaded, read or opened | closed |
| Model service, or its transcript | a model other than the tier's, or none shown: output rejected, agent re-run | closed |
| Reviewed tree or extra inputs | round stops before review | closed |
| Isolated or fetch environment unavailable | the input is not gathered, or the rule is not demonstrated | closed |
| Developer authorship check | record ignored and reported; the finding returns | closed |
| The account check | no loop mode runs anything | closed |

## Multi-node invariants
Serves: SKL-001
**Truth.** The results repository is the only truth for a round (review-results). The tracker is
read for the round issue's creator, events and milestone issues, and each iteration re-derives
box ticks, tags, body lines, labels (kind:review, its priority, unattended-loop and the halt
label) and the issue's state (open until the round has ended) from the results repository and
repairs any that differ; the repair adds human-action-required when a record calls for it and
never removes it, which only the developer does. The only local state is outputs not yet pushed, with the nonce they were taken under,
and developer records not yet pushed, which count for nothing until pushed; transcripts, read
only at their session's end; the paused-until times; the runner identity; the local locks; and,
on the developer's computer, the triage command's hold marker.

**Idempotence:** open (returns or completes the round a release claim names); start (a claim
already held by this round continues); coverage (deterministic; a second record is refused); an
agent (an accepted output for the key makes a re-run's output a discard); ticking and repairing
the body (no-ops when repeated); upload (the same commit, branch and category supersede); select
(a pure read); the progress line (at most one per interval); fix issues (found again by their
Round line).

**Counters and caches:** the failure count per agent key, counted from the latest retry record's
from-attempt; the incomplete count per agent key, reset by an accepted output or a retry; the
upload attempt count, counted from the latest upload retry; the usage per agent key, summed from
its attempts after the latest retry record's from-attempt for that key; the conditional-update retry count,
per iteration; the plan, recomputed every iteration; the local copy of the results repository,
refreshed before every conditional update.

## Audit
Serves: SKL-001

| Developer action | Recorded by | Fields |
|---|---|---|
| Opening a round, or marking a milestone | the Opening record, signed, and the round issue | branch, trigger, milestone, opened by, opened at |
| Cutting a round short | cut-short record | reason, time |
| Retrying a halted round | retry record | target, from-attempt, time |
| Calibration conclusions | calibration record | statistics shown, conclusions |
| Each triage decision | decision record | merged key, decision, reason, fingerprints, severity, fix issue or alert, time |
| Ledger entry | a decision record of kind accept on a finding with no alert | as a decision record |
| Dismissing an alert | the code-scanning service, together with the decision record naming the alert | dismissed by, dismissed at, reason, comment; the decision record's fields |
| Deciding a rule proposal | rule record | proposal key, decision, work item or pull request, time |
| Completing triage | triage-complete record | must-fix set seen, duration, time |
| Closing a round | the close record written by the triage command (the tracker close only mirrors it) | reason, time |

The round runner's local log records an agent key (a refuter only as "refuter") and an outcome;
the round issue carries only the progress line. Neither ever records finding text, counts, paths
or finding keys.

## Configuration
Serves: SKL-001

| Key | Default | Kind | Scope | Apply | Exposed by |
|---|---|---|---|---|---|
| review agents at once, across the estate | 1 | fixed policy backstop | fixed | restart | not exposed |
| started rounds per repository | 1 | fixed policy backstop | fixed | restart | not exposed |
| refuters per critical finding | 3, decided by majority | fixed policy backstop | fixed | restart | not exposed |
| refuters per high finding | 1 | fixed policy backstop | fixed | restart | not exposed |
| failed attempts before step-up | 2, then one tier up, then the developer | fixed policy backstop | fixed | restart | not exposed |
| step-up tier | the next of haiku, sonnet, opus at the same effort; above opus, opus at max | calibration target | fixed | restart | not exposed |
| incomplete attempts in a row before the developer | 3 | calibration target | fixed | restart | not exposed |
| agent session bound | 6 hours | calibration target | fixed | restart | not exposed |
| lease expiry | 24 hours | calibration target | fixed | restart | not exposed |
| output size bound | 4 MiB | fixed policy backstop | fixed | restart | not exposed |
| upload processing bound | 30 minutes | calibration target | fixed | restart | not exposed |
| upload attempts before the developer | 3 iterations | calibration target | fixed | restart | not exposed |
| rule-proposal threshold | 3 locations of confirmed findings across at least 2 groups, or the same class in 2 rounds in a row | calibration target | fixed | restart | not exposed |
| revisit period | 6 months | calibration target | fixed | restart | not exposed |
| phase tiers | coverage and upload plain; security, quality, specs and documents, architecture and synthesis opus at xhigh; triage session; copied into each round's Round record at its start | calibration target | fixed | restart | not exposed |
| application round priority | P1 | fixed policy backstop | fixed | restart | not exposed |
| fix issue priority by priority | must-fix P1, should-fix P2, backlog P3, architecture rewrite P3 | fixed policy backstop | fixed | restart | not exposed |
| security severity by severity | critical 9.5, high 8.0, medium 5.5, low 2.0, informational none | fixed policy backstop | fixed | restart | not exposed |
| code-scanning tool name and category | helios-review | fixed policy backstop | fixed | restart | not exposed |
| partial fingerprint key | heliosReview/v1 | fixed policy backstop | fixed | restart | not exposed |
| scheduler interval | 1 day | calibration target | fixed | restart | not exposed |
| progress-line interval | 1 day | calibration target | fixed | restart | not exposed |
| runner identity and nonce length | 128 bits | fixed policy backstop | fixed | restart | not exposed |
| pinned identities | the immutable numeric account identifiers of the developer and of the organisation's application, fixed in the work-order tool's reviewed source | fixed policy backstop | fixed | restart | not exposed |
| runner, build-session, review-session and sandbox accounts | the loop machine's operating-system account names | fixed policy backstop | fixed | restart | not exposed |
| served model identifiers per tier model | the exact identifiers accepted for each of haiku, sonnet and opus | fixed policy backstop | fixed | restart | not exposed |
| loop start interval | 30 minutes, while the computer is idle | calibration target | fixed | restart | not exposed |
| idle before start | 10 minutes | calibration target | fixed | restart | not exposed |
| machine shutdown bound | 5 minutes after the immediate-stop instruction | calibration target | fixed | restart | not exposed |
| live sessions per session account | 1 | fixed policy backstop | fixed | restart | not exposed |
| usage-limit pause bound | 7 days | calibration target | fixed | restart | not exposed |
| agent usage bound | 20 million tokens (input, output and cache writes added together) recorded by the current agent key's attempts since its latest retry, after which the round halts for the developer | calibration target | fixed | restart | not exposed |
| demonstration tool digests | the SHA-256 digest of the linter, test runner and hook runner for each enforcement kind and each language the estate's repositories use | fixed policy backstop | fixed | restart | not exposed |
| rule work item priority | P2 | fixed policy backstop | fixed | restart | not exposed |
| input program digests | the SHA-256 digest of each program that gathers an extra input, and of the toolchain it runs on | fixed policy backstop | fixed | restart | not exposed |
| triage session model and effort | opus at high | calibration target | fixed | restart | not exposed |
| rounds and dropped findings kept | all | fixed policy backstop | fixed | restart | not exposed |

## Security considerations
Serves: SKL-001

**Hostile tree.** *Surface:* every file and extra input a reviewer reads. *Attacker:* the author
of a fixture, a dependency, a document, a comment, or a settings, instruction or hook file.
*Abuse:* instructions to report nothing or to act, or configuration that runs code in the
session. *Decision:* reviewer, refuter, critic, synthesis and rule-proposer sessions run under the
review-session account with read-only tools, no network tool and no edit, write or push
capability, and can read only their prepared input; each starts outside its input and loads no
settings, instruction files, hooks or tool servers from it; the review-session account reaches
the model service and nothing else on the network; they hold no credential but the model
service's, handed in for that session; output is data and passes validation; refuters see only
the one finding; synthesis must account for every finding, and severity, status and priority are
never a model's call; inputs that process the tree are gathered in the isolated environment, and
anything fetched for them is fetched by the fetch environment. *Fails closed:* invalid output is
re-run, never read as clean.

**Account isolation.** *Surface:* the developer's computer and the loop machine. *Attacker:* any
model session, build or review, and any code a build session writes. *Abuse:* acting as the
developer or the application, reading round data to leak it, or reaching another account's files
through a shared directory, a container runtime or elevation. *Decision:* the loop runs in the
loop machine, a virtual machine on the developer's computer that mounts none of the developer's
files, runs none of the developer's programs, and reaches no container runtime of the
developer's. A task on the developer's computer, holding no secret, starts it only while the
computer is idle (no user input for the idle-before-start period; any input ends it), and on
input gives the loop its immediate-stop instruction: the review mode ends the running session,
releases both leases as a usage-limit pause does, records a stopped attempt with the session's
time and usage, which counts toward neither failures nor incompletes, and exits, and the build
loop ends its iteration as its own usage-limit pause does; the task shuts the
machine down once every loop mode it started has exited, within the machine shutdown bound. The
triage command may also start the machine, outside idle and without starting any loop mode, to
run a rule demonstration; while it holds the machine the task starts no loop, and it shuts the
machine down when it finishes. While the computer is idle the task starts both loop modes, the
build loop, one for each repository in the loop's configured repository list, and the review
mode, at every loop start interval, leaving any mode that is still running as it is; each keeps
its own paused-until time. The modes may run together, but each session account runs at most the live
sessions per session account at a time, across every loop mode: the runner takes that account's
local lock before it starts anything as that account (a session, an environment, or a command
that executes a build clone's content, such as its check or its tests), and releases it only
once no process runs as that account and the session's home and any input copy, and, for the
build-session account, its home and container storage, are deleted. A build clone is owned by the
runner account between its own sessions, and handed to the build-session account only for its
repository's session and check. The machine's
operating-system accounts, none holding the developer's signing keys, key agents or stored
logins:
- the runner account runs plain code only (the loop's modes, the round runner, mint) and alone
  holds the application's private key, the runner-signing key, the local copy of the results
  repository, every transcript and the paused-until times; it never runs a tool in a directory
  another account can write, and fetches into its own clones with version-control hooks and
  repository configuration disabled;
- the build-session account runs build sessions and every command that executes a build clone's
  content (its bootstrap, its check, its tests and its hooks), each build session in a clone of
  its own, handed to the account for that repository's session and check, which the build loop
  calls its worktree, with a container
  runtime of its own that runs with only that account's rights; it holds nothing but that clone,
  the scoped token and the model service's credential the runner hands it;
- the review-session account runs review-class sessions and the build loop's per-task diff
  review, each in a fresh home and transcript location, can read only the input copy prepared for
  that session, reaches the model service and nothing else, and has no container runtime;
- the sandbox account runs the isolated and fetch environments on a container runtime of its own
  that runs with only that account's rights and that no other account can reach.
Only the runner account may run commands as another account, and only as a session account; no
session account may run commands as another account, hold administrative rights, or belong to a
group that grants another account's files or container runtime. The build-session and sandbox
accounts' network excludes the developer's computer's own addresses. The account check, one
operation in the work-order tool that every loop mode calls before any work and the probe that
it runs before every session, verifies all of this: that it runs as the runner account; that no
key agent is reachable; that no credential for the code-hosting service is readable beyond the
runner's own; that the loop machine mounts no folder of the developer's computer, runs none of
its programs, and reaches none of its container runtime's endpoints (its socket locations, and
its ports on the machine's loopback and on the developer's computer's address); and, as the
session's account, that reading the application key, the results copy or another account's files
fails, that a password-less elevation fails, that a connection to any host but the model service
fails for the review-session account, that every other container runtime, the developer's
included, is unreachable, and that no process is already running as that account (the live
sessions per session account); the probe runs before anything the runner starts as a session
account: a session, an environment, or a command that executes a build clone's content. *Fails closed:* any failed or unanswerable check or probe means nothing
runs. *Accepted residual:* any process under the developer's computer account, including a model
session the developer runs, can enter the loop machine as its administrator and read its keys;
this is accepted. Two narrowings go with it: the estate's session hooks refuse any command that
enters the loop machine (one that invokes the computer's virtual-machine manager, or names the
loop machine, its shared-file path or its address), and a dismissal counts as a prior acceptance only when a
developer-verified decision record names its alert (Behaviour, Synthesis phase).

**Credential isolation.** *Surface:* the application's tokens. *Attacker:* any model session.
*Abuse:* dismissing alerts, forging acceptances, reading the results, or changing a workflow.
*Decision:* every token is minted by mint for exactly one caller's row, one repository per token,
and nothing broader; no token carries the workflows permission:

| Caller | Permissions | Repository |
|---|---|---|
| build session | contents, issues and pull requests write | its own repository |
| round runner, reviewed repository | contents read; issues write | the reviewed repository |
| round runner, results writer | contents write | the results repository |
| round runner, discovery | contents read | each repository with an Opening, one token each |
| upload | security events write | the reviewed repository |
| synthesis | security events read | the reviewed repository |
| extra inputs | contents read | each sibling repository and the repository that publishes the contracts register, one token each, never the results repository; the application's own installation details are read with its own credential |
| scheduler, discovery | contents read | each repository scanned, one token each |
| scheduler, opening | issues and milestones write | the one reviewed repository |
| scheduler, claim and Opening | contents write | the results repository |
| release check, reviewed repository | contents read; issues and pull requests read; commit statuses write | the reviewed repository |
| release check, siblings | pull requests read | each sibling a must-fix fix issue's Base names, one token each |
| release check, results | contents read | the results repository |
| release step, reviewed repository | contents write; pull requests read | the reviewed repository |
| release step, results | contents read | the results repository |

A build session's token never includes security events or the results repository; review-class
sessions receive no token and run with version-control credential helpers disabled; tokens for
the results repository and for security events are held by plain code only, exist only inside
their step's memory, pass to no child process or environment, are never logged, and are revoked
when the step ends. A definition that holds the application key runs only the pinned work-order
tool and nothing from any reviewed tree; pinned means an artefact whose SHA-256 digest is written
in the developer-merged definition, or in the developer-installed copy on the loop machine, and a
mismatch runs nothing. *Fails closed:* a token that cannot be minted with
exactly its row is not used.

**Triage.** *Surface:* the developer's triage, which reads text derived from hostile input.
*Attacker:* a crafted finding, or a settings, instruction or hook file in the tree. *Abuse:*
steering the triage model to sign an acceptance, dismiss an alert, read a credential, run code,
or smuggle a command into the developer's shell. *Decision:* the triage model holds a read-only
tool allowlist confined to the round's records and the tree, with no shell, no network and no
credential, and loads no configuration from either; only the developer runs the triage command,
which takes enumerated arguments, prompts for free text itself and signs with a review-signing
key; alerts are dismissed only by the developer in the service's web interface; a rule
demonstration runs in the isolated environment after its full content is shown; a security fix
issue's public text comes only from fixed text. *Fails closed:* a record the model produced is
not developer-verified and is ignored.

**Round issue tampering.** *Attacker:* anything holding issue write, including a build session.
*Abuse:* closing a round to end a review, reopening one to rerun it, editing its branch, trigger
or tier tags, attaching issues to its milestone, or planting a round-looking issue. *Decision:*
branch, trigger and milestone come only from the Opening, and the pinned commit and tiers only
from the Round record; a tracker close of a round that has not ended, by any account, ends
nothing, and the issue is reopened and reported; a round with trigger release never waits on its milestone; an issue
without an Opening is never a round. *Fails closed:*
unreadable events mean not run.

**Disclosure.** *Surface:* public issues, logs, artifacts and CI runs. *Decision:* finding content
goes only to the results repository and to code scanning against a branch; the upload refuses any
target but the round's existing branch containing the pinned commit; the round issue carries only
the progress line; a security fix issue carries only fixed text; a security proposal's rule lands
only after its instances are fixed, so its public CI run catches nothing. *Fails closed:* an
unconfirmed target uploads nothing.

**Cost abuse.** *Surface:* issue creation on public repositories, and the application's own
credential. *Decision:* a round starts only from an Opening that passes the author check
(Behaviour, Start), and a release branch, which an application round needs, is a protected
reference (review-results); labels are never proof. *Fails closed:* an unreadable creator means not run.

**Silencing.** *Decision:* no step dismisses or reopens an alert; developer records are written
only by the commands review-results names; records the authorship check cannot verify are ignored
and reported.

## Negative tests
Serves: SKL-001
- A round whose issue's creator is not a pinned identity, or differs from its Opening's
  opened_by: End record; not run.
- The tracker fails reading the creator or the events: not run; the round keeps waiting.
- An application Opening with trigger milestone or hand, on a branch not matching the release
  pattern, or not the round its release claim names: End record.
- A developer Opening that is not developer-verified: End record.
- The developer opens a round while one is started: refused, naming it.
- A second application open for the same branch: returns or completes the same round.
- A crash after the claim records the issue and before the Opening: the next open writes that
  issue's Opening.
- An issue created in the web form, or labelled kind:review with no Opening: never selected, and
  left untouched; the scheduler still opens the real round.
- A round issue closed by a closing reference in a developer-merged pull request: reopened and
  reported; the round runs on.
- A session whose final message imitates a usage-limit notice: incomplete, not paused.
- A paused session: its time and usage are in the summary; it counts toward neither failures nor
  incompletes.
- The application closes a started or waiting round: nothing ends; reopened, reported, and the
  round runs on.
- A coverage failure: an End record, the slot free, and the issue not reopened.
- The developer opens a round on a branch whose earlier rounds have ended: a new round.
- A started round in reviewing: the next step runs its next agent.
- One repository's round in triage and another's waiting: the waiting round runs.
- A repository whose releases branch holds no question set yet, with a developer Opening: its
  round runs.
- A release round whose milestone has another open issue: selected all the same.
- A milestone round while its milestone has another open issue, or its issues unreadable: not
  selected.
- An edited tier tag on a started round: ignored, repaired, and the phase runs at its recorded
  tier.
- An edited Branch line on a waiting round: ignored and repaired.
- The results repository fails at push, then recovers: the pending output is pushed first under
  its nonce, not discarded.
- A crash mid-agent, then restart: the pending output, if any, is pushed first; otherwise the
  lease is reclaimed at once and one incomplete attempt is recorded.
- A lease taken over by another runner after expiry: one incomplete attempt is recorded.
- Two runners claim the same slot at once: exactly one succeeds.
- Two runners in two repositories take the estate lease at once: exactly one runs an agent.
- Two processes of one installation: the second exits on the local lock.
- The branch advances after the pin: every later agent reads the pinned commit.
- Coverage finds an unassigned file, or an extra input cannot be gathered: the round ends before
  any agent runs.
- The isolated or fetch environment is unavailable: the input is not gathered and the round
  ends.
- A tree whose declarations name an install script or a toolchain to run: the fetch environment
  runs neither and holds no credential.
- The tree carries a settings file with a hook and an instruction file: a reviewer session loads
  neither and the hook does not run; the same for the triage session.
- An agent output that is empty or not valid JSON: invalid and re-run, never no findings.
- An output whose checked and not-reached lists miss part of its scope, including a declared
  input: invalid.
- A critic output that omits an earlier agent key: invalid.
- A per-spec output without a claims count: invalid.
- A finding with a class outside the vocabulary, or a path absent at its commit: invalid.
- A synthesis output setting a severity, status or priority: ignored.
- A merge that combines a critical finding with medium ones: the merged finding is critical.
- A merge of a new finding with a previously accepted one: returns to triage.
- A merged finding whose member set differs from a dismissed alert's: uploaded under a new
  partial fingerprint.
- Two triggered rule proposers: distinct agent keys and records.
- Two invalid attempts: the third runs one tier up; a failure there halts the round.
- A retry: the next attempt runs at the phase tier, and earlier failures no longer count.
- On every failure path, no attempt runs below its phase tier.
- A usage-limit pause: recorded as a paused attempt; it counts toward neither failures nor
  incompletes.
- A transcript showing another model, a missing transcript, or a message without a model:
  model-mismatch.
- A session over the agent session bound: ended, incomplete, discarded.
- A re-run agent's output after an accepted output exists: discarded.
- The stop file set mid-round: stops after the current agent; resumes at the first missing
  output.
- Any agent input containing a decision, dismissal or acceptance, or a refuter's input
  containing another refuter's verdict: the input builder refuses.
- A refuter session reads an earlier session's transcript: not found.
- A review-class session reads the local results copy or the application key, or reaches a host
  other than the model service: the review-session account cannot.
- A build session, or a test in a build clone, reads the application key: the build-session
  account cannot.
- A build session pushes a change to a workflow definition: no token it holds permits it.
- An acceptance date unreadable, or its severity lower than now: the finding returns.
- A dismissal by an account other than the developer's: ignored and reported.
- A defect moved to other lines within its file: the same fingerprint.
- An unverified finding: not uploaded; present in the report.
- An upload target that is a pull-request reference, an absent branch, or a branch read that
  fails: nothing uploaded.
- The upload token cannot be minted with exactly its row, or carries more: not used.
- Processing over the upload processing bound: a failed upload attempt; at the upload attempts
  before the developer, the round halts.
- The scheduler's opening token cannot write the reviewed repository's contents.
- A review-class session's environment holding any credential other than the model service's,
  or a credential helper: not started.
- A loop mode running as any account but the runner account, or with a reachable key agent, or
  with a readable service credential beyond the runner's own, or unable to determine any of
  these: runs nothing.
- The round issue's comments and the local log: no finding text, counts, paths, finding keys or
  refuter keys.
- A security fix issue's body: contains no finding field text; a security finding is never asked
  whether it is security-sensitive.
- A build session plants a hook or a command setting in its clone: nothing runs as the runner.
- A test asks a container runtime to mount the runner's files: the build account's runtime cannot.
- A session account that can read the results copy or the application key: no session starts.
- A replaced work-order tool artefact: digest mismatch, nothing runs.
- A register naming the results repository: the results repository is left out of the sibling
  set and reported, the rest is gathered, and a mint for it under the extra-inputs row is
  refused.
- Fix issues closed by the application, or an instance with no fix issue: rule-pr for a security
  class refused.
- An issue not created by the developer carrying a fix issue's Round line: not adopted; reported.
- A usage-limit pause: both leases released; the next attempt takes the next number.
- A merge of members with different classes: the class of the highest-severity member.
- A served model identifier outside the tier's list: model-mismatch.
- The computer stops being idle mid-agent: the loop stops at once, both leases released, a stopped
  attempt recorded that counts toward neither failures nor incompletes; three such interruptions
  of one agent do not halt the round.
- The triage command starts the loop machine for a demonstration: no loop mode starts, and the
  machine shuts down when the command finishes.
- A session account allowed to elevate without a password, or in a group granting another
  account's files: no session starts.
- A build-session test connects to the developer's container runtime: refused.
- The probe cannot run as the session account: no session starts.
- decide before the calibration record in a repository's first round: refused.
- complete while a finding needing a decision is undecided: refused.
- Two build loops at once: the second's session does not start while the first's runs, and
  starts after it ends; a process already running as the review-session account: no session
  starts.
- The application closes, or removes from the milestone, a milestone's last open issue: the
  round is not selected.
- A dismissal that no developer-verified decision record names: not a prior acceptance.
- A command entering the loop machine from a session under the developer's account: the session
  hook refuses it.
- A sibling-located must-fix finding fixed by a developer-merged pull request in the sibling,
  with its fixed record: resolved.
- A triage command killed mid-demonstration: the next idle period starts the loop.
- A demonstration that runs but misses an instance: not approvable.
- A fetched commit whose object name differs from the pinned commit: no demonstration.
- The idle period begins while the triage command waits: no loop starts.
- Repository A's check still running: repository B's session does not start.
- A session writes into another repository's clone, or into the build account's container
  storage: refused, or gone before that repository's next session.
- A proposal for an unmarked class with a security-phase instance: rule-pr refused until its
  instances are fixed.
- Enforcement content with an escape sequence, or a triage-session message carrying one: shown
  escaped; a finding title carrying one, printed by the sign-off command, or an issue title
  carrying one, printed by the triage command: shown escaped.
- An issue already named by a decision record, whose Round line was edited to name another key:
  not adopted.
- A pull request naming an issue the application created with a Round line and kind:bug: not
  offered by the sign-off command; the tracker fails reading it: nothing offered.
- A fix issue whose Base names a sibling: the reviewed repository's build loop does not build it.
- An agent key whose recorded usage since its latest retry passes the agent usage bound: the round
  halts for the developer.
- A tree whose build logic would run, or whose declarations name an analyser, while an input is
  gathered: none of it runs, and the input comes from the pinned program.
- The loop machine mounts a folder of the developer's computer, runs one of its programs or
  reaches its container runtime: the account check refuses to run.
- A session reads an earlier session's home or input copy: not found.
- A triage reason containing shell syntax: stored literally.
- The triage model asks to run a shell, reach the network, change an alert or read the
  developer's credential store: refused.
- A developer record written by the triage model rather than the triage command: unverified,
  ignored.
- A rule demonstration attempts network access or reads a credential: the isolated environment
  has neither.
- A policy rule proposal: shown with its instances quoted, and approvable without a run.
- rule-pr for a security proposal while an instance's fix issue is open, was closed by any account
  but the developer's, or was closed by a developer-merged pull request with no fixed record:
  refused; the tracker fails reading a fix issue: refused.
- A crash between creating a fix issue and pushing its decision: the re-run finds and uses the
  same fix issue.
- A cut short before security completes: security still finishes; the report and upload say what
  was skipped.
- A round closed without triage-complete: the gate for its branch stays red.
