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
| lease | a server's proof of life in the database, with an expiry on the database clock and a generation, renewed on a schedule; a node belongs to a live lease |
| sysop | the operator of a running board; **co-sysop**, a limited administrator |
| local operator | whoever runs the setup tool on a server's host, authenticated by possession of that host's bootstrap record; the setup tool offers them only what restores that server's connectivity, and stopping or starting it; they also hold that server's database login and are trusted as a server |
| setup tool | `hadv-setup`: first run, join, and a server's connectivity, run on the host by the local operator |
| runtime configuration tools | `hadv-config` and `hadv-config-gui`: every board and server setting, run by a sysop against any server |
| bootstrap record | the file on a server's disk holding what it needs to reach the database and nothing else: identity, database address and trust anchor, its own login, its transport choice, the key-encryption key |
| key-encryption key | the board's key under which sensitive fields are encrypted at rest; held in every server's bootstrap record, never in the database |
| layout | the assignment of node-number ranges to servers; **re-plan**, the sysop's explicit operation that packs every range from node 1 upward |
| occupancy | whether a node is taken, decided by the occupancy rule and nothing else |
| screen boundary | the moment a session finishes sending a screen and waits for input, and again when the input arrives; for a web session, the end of a request |
| reconcile | a server's clean-up when it regains the database: releasing nodes whose sessions are gone |
| trusted proxy list | the board-wide list of address ranges whose peers are believed when they ask for detailed health |
| management listener | a server's HTTP listener for detailed health, bound to loopback unless the sysop binds it to a management network; the **public listener** is the one callers reach |
| generation | the counter a server increases each time it acquires its lease; a node claim records it, so a claim from a lease that has since been lost is void |
| high-water mark | the highest node number assigned on a board since the last re-plan; numbers below it are never assigned again except by a re-plan |
| occupancy rule | a node is occupied exactly when its occupant fields are set, its claim generation equals its owner's lease generation, its owner is active, and its owner's lease expiry is later than the database clock; otherwise it is free |
| local lease deadline | a server's own clock reading at which its last successful renewal or acquisition was sent plus the lease timeout it wrote; never later than the database's expiry |
| registry | the declared settings, built at start-up from every subsystem's declarations; **scope**, whether a setting has one value for the board or one per server; **apply mode**, whether a change applies live or at the next start; **snapshot**, a server's in-memory copy of the values it needs |
| connectivity setting | a server-scoped setting the local operator may change through the setup tool because it can be what stands between the server and the board: its listen addresses; the bootstrap record, which is not a setting, is also the local operator's to change |
| actor | who performed an action: a sysop account, the local operator of a named server, the first-run operator, or the engine itself |
| principal | who is acting, as access control sees it: a **sysop account**, a **caller** (a session that sessions v1 vouches for), the **local operator** of a named server, or the **first-run operator** (whoever the database accepted with the administrator credential through the setup tool, at first run, at an upgrade or for a secret reset); **permission**, a named capability the one authorisation check grants or denies |
| open connection | an accepted connection counted against a listener's limit |
| exclusive hold, shared hold | an exclusive hold on a row makes any other transaction that wants to hold or change it wait; a shared hold lets other shared holders proceed and makes an exclusive holder wait; **compare-and-set**, a write whose predicate names the values it expects and reports whether it changed anything; **increasing identifier**, one the database generates, never reuses and never moves backwards |
| hold order | the one global order in which every transaction takes its holds, so no two transactions wait on each other; **operation deadline**, the time a transaction is allowed before it is Unavailable |
| applied change | the database's record that one data-model change has been applied, so it is never applied twice; **data-model change**, a change to the entities, constraints, roles or database-side operations shipped with an engine version, applied only by the setup tool under the administrator credential |
| database-side operation | an operation that runs inside the database with the data model owner's rights rather than the caller's and checks its own preconditions; the only way a server login changes anything beyond the direct writes the architecture's server-login tier lists |
| administrator credential | the database's own administrative credential, held by no program: the local operator supplies it to the setup tool at first run, at an upgrade and for a secret reset, and the tool discards it after |
| layout position | the order in which a re-plan packs servers' ranges, assigned once from the board's counter |
| settings version | the counter every setting change increases, carried on every lease renewal so a server knows its snapshot is behind; **started settings version**, the version a server's process loaded first, against which restart-needed is judged |
| node handle | what a surface holds for one claimed node: the node number and the session identifier; **caller reference**, the opaque identity of a caller that sessions v1 resolves to a display name |
| loopback address | an address literal the host's network stack delivers only to the host itself; **local socket**, an endpoint the operating system exposes only to processes on that host |
| developer | the person building Helios; never the sysop |
| theme pack | the scripts, terminal text and graphics, and web code that give a board its personality; a board installs several, each user picks one, and a new user starts on the pack the sysop flagged as the default; the shipped modern pack is the fallback every other pack falls back to, and cannot be deleted |
| scripting layer | where all BBS logic runs, through the public `bbs.*` API |
| conference | a grouping of message bases and file bases with its own permissions, which gate every base beneath it |
| base | a message base or a file base, under a conference, with its own permissions |
| estate | the six Helios projects developed together, and the repositories that serve them: the skills plugin, the tools, the design notes and the shared defaults |
| brief | a feature in the developer's words, in `features/`, the authority for everything derived from it |
| spec | a derived document in `docs/spec/`: the architecture or one subsystem |
| plan | the checklist in an issue that a session executes without judgment |
| task, tier | one box in a plan, and the model it runs on: haiku, sonnet, opus, or session |
| sysop tunable | a setting the board's operator changes, with a key, a default and a kind |
| Admin API | the board's one network interface for administration: every administration tool reaches the board through it on any server, never through the database |
| allow list | the Admin API's list of entries (an address, an address range or a hostname), each naming the accounts or roles it admits, checked on every request before a password can be tried; empty admits only the server's own host, which is always admitted |
| console token | what `hadv-console` holds between sign-ins: bound to a key pair generated on that device, allowed console actions only, with a lifetime counted from sign-in and an idle expiry |
| automation token | a named credential a signed-in sysop creates for scripts and automation, scoped by the settings groups it may read and change, never able to manage tokens, roles, accounts or second-factor rules; its secret is shown once and never stored |
| exempt source | an address that stands for many callers (a gateway, a load tester, a shared address), listed so that per-source throttling and sign-in slowdown do not treat it as one caller; separate from the trusted proxy list |
| loosening | a change that makes the board less secure than it was; it warns loudly, takes effect only on confirmation, is audited, needs an explicit acknowledgement on the command line, and is documented in the sysop guide |
