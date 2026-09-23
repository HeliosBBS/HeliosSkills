---
name: feature-plan
description: Use when a feature's design has merged and the developer asks to plan it, or before any code on a work item that has no plan. Does gap analysis against the code first, writes a checklist into the issue that a Sonnet 5 session at high effort can execute without judgment, and runs the analyze gate across brief, design, plan and constitution. No code before the plan is in the issue.
---

# Feature plan

A plan is disposable. A wrong plan is regenerated from the design, not patched. A bad line in a
plan becomes hundreds of bad lines of code, so the developer reads the whole plan; write it for
them as much as for the session that will execute it.

## 1. Gap analysis: never assume "not implemented"

For every contract, mechanism, entity, setting and test the design names, search the code
(`Grep` for the contract name, the type, the config key, the migration) and classify it:
**exists** (cite the file), **partial** (what is there and what is missing), or **missing**.
A task for something that exists is waste; a task that assumes something exists when it does
not is a session that will guess. Record the table at the top of the plan.

## 2. Write the tasks

Each task is one sitting for a Sonnet 5 session at high effort with no judgment left in it:

```
- [ ] <n>. <what lands>  [tier: haiku|sonnet|opus|session]   or   [tier: opus, effort: max]
      Files: <exact paths, new or changed>
      Test first: <test name>: <what it asserts, and what it must fail on before the change>
      Acceptance: <the derived negative tests it satisfies, by their lines in the design>
      Serves: <feature ID>
```

Rules:

- Small: if a task needs more than one test to describe, split it.
- Tests first, always; the test names the behaviour before the code exists.
- Every permission check gets its negative-path task. Every audit entry gets its task.
- Every sysop tunable gets its text-mode tool task in this plan, and the plan's issue links
  one issue for the graphical tool: blocked on this plan's PR, session-tier (the developer
  writes the forms), planned when that PR merges.
- The last task is verification through the real surface (a real Telnet or SSH session, a
  real HTTP call) against the brief's scenarios; a feature is not done without it.
- Order by dependency; a task never depends on a later one.
- **Tier** is the model the task needs, by shape, not by where its files live: `haiku` for
  purely mechanical work with one right answer (a rename, a generated file, a fixture, a doc
  line); `sonnet` for fully specified implementation; `opus` for a task with reasoning left in
  it (it should not be, but say so); `session` for anything that changes the architecture or a
  contract another repository consumes, meaning an interactive session with the developer.
  The loop runs the task on that tier and raises it on the routing triggers; it never lowers it.
- **Effort** is high unless the tag says otherwise, and most tags say nothing. `effort: low`
  marks a mechanical task that still needs the codebase in view (a dependency, a version
  constant, a key declaration); `effort: max` marks a task where the reasoning is the whole
  task (a state machine, a privilege model). A route-up raises the model and keeps the effort.
- Security-sensitive tasks say so, and say only the work, never the exploit path.

## 3. The analyze gate

Before the plan leaves your hands, check the four artifacts against each other and print the
result as a table:

| Check | Result |
|---|---|
| Every brief scenario has a task whose test exercises it | |
| Every derived negative test is some task's acceptance | |
| Every security decision in the brief has a task that implements it | |
| Every task's `Serves:` is the feature, and every file it names is in the design's placement | |
| Every constitution rule that applies (fail closed, audit entry, negative test, multi-node) is a task, not an assumption | |
| No task contains a question, an "if needed", or a choice | |
| The design and the brief do not contradict each other | |

Any empty or failed row: fix the plan; if the fault is in the design, stop and say so, because
the design is fixed by `feature-design`, not by a plan that works around it.

## 4. Put the plan in the issue

Create or update the work item so its body follows the issue form's rendered shape (the
headings `### Files`, `### Exact change`, `### Reason`, `### Security-sensitive`,
`### Priority`, `### Kind`, `### Plan`), with the gap table and the checklist under `### Plan`.
Labels: the priority, the kind, `security-sensitive` if any task is, `unattended-loop` if no
task is `session`. Link the design PR and the brief. If the plan spans repositories,
one issue per repository, the owner's first, linked as sub-issues or dependencies.

The plan checklist is a gate: no code until it is there. Say what comes next: `feature-build`,
one task per iteration.
