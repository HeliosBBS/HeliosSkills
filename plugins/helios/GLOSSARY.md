# Glossary

The words the estate uses, each defined once here and nowhere else. A brief or spec that
introduces a term adds it here in the same pull request; a spec's own Terms section cites this
file rather than redefining. Loaded with the constitution at the start of every session.

| Term | Meaning |
|---|---|
| board | the BBS as its users see it: one name, one database, one or more servers |
| server | one running instance of the engine, joined to a board, with its own hardware limits |
| node | one logged-in caller slot, with a board-wide stable number; each server's nodes are a contiguous range derived from its configured node count |
| caller | a person connected to the board by any surface, logged in or not |
| session | a caller's time on a node, from login to logout or loss of connection |
| surface | a way callers reach the board: Telnet, Telnet over TLS, SSH, the web |
| database | the board's single source of truth, shared by every server; always "database", never "store" |
| inter-server bus | how servers tell each other something changed; a mechanism of the stack, named in `docs/stack.md`, never in a spec |
| lease | a server's proof of life in the database, renewed on a schedule; a node belongs to a live lease |
| sysop | the operator of a running board; **co-sysop**, a limited administrator |
| local operator | whoever runs the setup tool on a server's host; authenticated by possession of that host's bootstrap record; reaches only what restores that server's connectivity |
| setup tool | `hadv-setup`: first run, join, and a server's connectivity, run on the host by the local operator |
| runtime configuration tools | `hadv-config` and `hadv-config-gui`: every board and server setting, run by a sysop against any server |
| bootstrap record | the file on a server's disk holding what it needs to reach the database and nothing else: identity, database address and trust anchor, its own login, its transport choice, the key-encryption key |
| key-encryption key | the board's key under which sensitive fields are encrypted at rest; held in every server's bootstrap record, never in the database |
| layout | the assignment of node-number ranges to servers; **re-plan**, the sysop's explicit operation that packs every range from node 1 upward |
| occupancy | whether a node is taken: occupied only while its owner's lease is live and the claim matches that lease's generation; otherwise free |
| screen boundary | the moment a session finishes sending a screen and waits for input, and again when the input arrives; for a web session, the end of a request |
| reconcile | a server's clean-up when it regains the database: releasing nodes whose sessions are gone |
| trusted proxy list | the board-wide list of address ranges from which detailed health, and later forwarded caller addresses, are believed |
| management listener | a server's HTTP listener for administration and detailed health, bound to loopback unless the sysop binds it to a management network; the **public listener** is the one callers reach |
| developer | the person building Helios; never the sysop |
| theme pack | the scripts, terminal text and graphics, and web code that give a board its personality; one is selected per board |
| scripting layer | where all BBS logic runs, through the public `bbs.*` API |
| conference | a grouping of message bases and file bases with its own permissions, which gate every base beneath it |
| base | a message base or a file base, under a conference, with its own permissions |
| estate | the seven Helios repositories developed together |
| brief | a feature in the developer's words, in `features/`, the authority for everything derived from it |
| spec | a derived document in `docs/spec/`: the architecture or one subsystem |
| plan | the checklist in an issue that a session executes without judgment |
| task, tier | one box in a plan, and the model it runs on: haiku, sonnet, opus, or session |
| sysop tunable | a setting the board's operator changes, with a key, a default and a kind |
