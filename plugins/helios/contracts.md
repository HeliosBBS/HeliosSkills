# Contracts register

Every interface that crosses a repository boundary in the Helios estate. A spec cites a
contract by its name and version here; the `contracts-register` skill has the rules for
changing one.

| Contract | Owner | Version | Specification | Consumers | What it is |
|---|---|---|---|---|---|
| Door wire protocol | HeliosDoorKit | none yet | HeliosDoorKit `docs/` | HeliosAdvance (host side), HeliosDoors (door side) | How a door and a host exchange screens and input, front-end independent |
| Public JSON API | HeliosAdvance | none yet | HeliosAdvance `docs/spec/` and its OpenAPI description | HeliosPortal, HeliosLoadTest | The board's HTTP interface for clients |
| Terminal surfaces | HeliosAdvance | public standards | RFC 854 (Telnet), RFC 4253 (SSH) | HeliosSIP, HeliosLoadTest | Nothing Helios-specific: a SIP caller or a load driver is an ordinary Telnet or SSH client |
| VirtualNET wire format | separate specification | none yet | supplied ahead of the transport's implementation | HeliosAdvance | The frozen store-and-forward network format; the constitution's standing exception |
