# Contracts register

Every interface that crosses a repository boundary in the Helios estate. A spec cites a
contract by its name and version here; the `contracts-register` skill has the rules for
changing one.

| Contract | Owner | Version | Specification | Consumers | What it is |
|---|---|---|---|---|---|
| Door wire protocol | HeliosDoorKit | none yet | HeliosDoorKit `docs/` | HeliosDoors (host side), every door built with the kit | How a door and its host exchange screens and input, front-end independent |
| Door hosting protocol | HeliosDoors | none yet | HeliosDoors `docs/` | HeliosAdvance, any other BBS software that supports it | How a BBS hands a caller to a hosted door and gets them back; the engine never launches a door itself |
| Public JSON API | HeliosAdvance | none yet | HeliosAdvance `docs/spec/` and its OpenAPI description | HeliosPortal, HeliosLoadTest | The board's HTTP interface for clients |
| Terminal surfaces | HeliosAdvance | public standards | RFC 854 (Telnet), RFC 4253 (SSH) | HeliosSIP, HeliosLoadTest | Nothing Helios-specific: a SIP caller or a load driver is an ordinary Telnet or SSH client |
| Server health (`cluster.health` v1) | HeliosAdvance | 1 | HeliosAdvance `docs/spec/` (cluster) | a proxy in front of the board, HeliosLoadTest | each server's health and utilisation over HTTP, detailed only to the trusted proxy list |
| access-control v1, sessions v1, theme v1, join v1 | HeliosAdvance | none yet | HeliosAdvance `docs/spec/` (each is published by the feature that provides it; access-control's minimum is in `docs/spec/access-control.md`) | engine subsystems | contracts the engine's own subsystems consume from features not yet designed: authorisation; session identity, end and display names; theme screens; a server's database login |
| VirtualNET wire format | separate specification | none yet | supplied ahead of the transport's implementation | HeliosAdvance | The frozen store-and-forward network format; the constitution's standing exception |
