# Contracts register

Every interface that crosses a repository boundary in the Helios estate, and every engine
contract that a feature not yet designed must honour because an existing specification
already consumes it. A spec cites a contract by its name and version here; the
`contracts-register` skill has the rules for changing one.

| Contract | Owner | Version | Specification | Consumers | What it is |
|---|---|---|---|---|---|
| Door wire protocol | HeliosDoorKit | none yet | HeliosDoorKit `docs/` | HeliosDoors (host side), every door built with the kit | How a door and its host exchange screens and input, front-end independent |
| Door hosting protocol | HeliosDoors | none yet | HeliosDoors `docs/` | HeliosAdvance, any other BBS software that supports it | How a BBS hands a caller to a hosted door and gets them back; the engine never launches a door itself |
| Public JSON API | HeliosAdvance | none yet | HeliosAdvance `docs/spec/` and its OpenAPI description | HeliosPortal, HeliosLoadTest | The board's HTTP interface for clients |
| Terminal surfaces | HeliosAdvance | public standards | RFC 854 (Telnet), RFC 4253 (SSH) | HeliosSIP, HeliosLoadTest | Nothing Helios-specific: a SIP caller or a load driver is an ordinary Telnet or SSH client |
| Server health (`cluster.health` v1) | HeliosAdvance | 1 | HeliosAdvance `docs/spec/` (cluster) | a proxy in front of the board, HeliosLoadTest | each server's health and utilisation over HTTP, detailed only to the trusted proxy list |
| access-control v1 | HeliosAdvance | 1 | HeliosAdvance `docs/spec/` (access-control) | every engine gate | the one authorisation check and its principals |
| sessions v1 | HeliosAdvance | 1 | the feature that provides sessions publishes it; until then the operations the engine's documents state are the contract | cluster, access-control | session identifiers (unpredictable, unique across servers), a session's end per surface, per-account concurrent-session limits, and caller display names |
| theme v1 | HeliosAdvance | 1 | the feature that provides themes publishes it; until then the operations the engine's documents state are the contract | cluster | the busy and "not accepting callers" screens |
| join v1 | HeliosAdvance | 1 | the feature that provides the join publishes it; until then the operations the engine's documents state are the contract | cluster | creating and revoking a server's database login |
| accounts v1 | HeliosAdvance | 1 | the feature that provides accounts publishes it; until then the operations the engine's documents state are the contract | access-control, the runtime configuration tools | authenticating a sysop account |
| VirtualNET wire format | separate specification | none yet | supplied ahead of the transport's implementation | HeliosAdvance | The frozen store-and-forward network format; the constitution's standing exception |
