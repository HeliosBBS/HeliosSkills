# In a cloud session

This session runs on claude.ai/code, not on the developer's PC. What that changes:

- **Every repository in the HeliosBBS organisation is reachable**, the private ones
  (HeliosDesign, HeliosLoadTest) included: the Claude GitHub App is installed on the whole
  organisation. Never tell the developer you lack access to one; clone what you need with
  `git clone https://github.com/HeliosBBS/<name>.git` beside the attached repository.
- **Pull requests and other GitHub API calls reach only the repositories attached to this
  session.** Work that ends in a pull request elsewhere (a brainstorm record in HeliosDesign)
  needs that repository attached; say so when the work starts, not when it is done.
- **`HeliosBBS/.github` cannot be attached**: the system refuses repository names that start
  with a dot. Read it by cloning. A change to it (the shared workflows, issue form, labels,
  health files) is handed to a local session or the GitHub web UI, never worked around by
  copying its files into another repository.
- **GraphQL reaches only pull-request operations**, so organisation Projects are out of reach.
- **`CLAUDE.local.md` is absent**: it is private to the developer's PC. Commands handed to the
  developer are for their own PowerShell 7 terminal.
