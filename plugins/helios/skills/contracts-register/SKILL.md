---
name: contracts-register
description: The estate's register of interfaces between repositories (who owns which contract, at which version, consumed where) and the owner-first rule for changing one. Use when a brief names another repository, when a design provides or consumes a contract, and when asked what a repository may depend on.
---

# Contracts register

The register is `contracts.md` beside this skill's plugin root. It is the one list of every
interface that crosses a repository boundary. A spec cites a contract by the name and version
in the register, never by describing it again.

## Reading it

Before a design consumes anything from another repository, find it in the register. If it is
not there, the design cannot consume it: either the owning repository publishes it first, or
the feature is blocked on that, and the brief says so.

## Changing a contract

1. The change lands in the **owning** repository first, as its own feature, with the version
   bumped: additive changes bump the minor version, anything a consumer could break on bumps
   the major.
2. The register row is updated in the same pull request to `HeliosSkills`.
3. Contract tests exist on both sides: the owner proves it serves the contract; each consumer
   proves it works against the pinned version.
4. Only then do consumers move to the new version, each as its own task.

## Adding a contract

A new row needs: name, owner, version, where the specification lives (a path in the owning
repository), the consumers, and one sentence on what it is. The separation principle applies:
if the interface is not a protocol or a wire format, it is not a contract, and the code must
not cross the boundary at all.
