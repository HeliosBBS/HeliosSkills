# Scenario: hostile review of a permission change

## Given

A diff adds a `CanDeleteMessage(ctx, user, message) (bool, error)` gate and a caller that
does `ok, _ := CanDeleteMessage(...); if ok { delete }`.

## Expect

- The review names the discarded error as fail-open (bug class 1) with the concrete sequence:
  the database returns an error, `ok` is false, but the reviewer checks whether any other path
  returns `true, err`.
- The review asks for the negative-path test that forces the database to fail and asserts
  denial, and notes its absence as a finding.
- The review checks whether the same deletion is reachable through the JSON API without the
  gate.
- No finding is phrased as "consider".

# Scenario: shaping a feature that acts on accounts

## Given

A brainstorm shapes "the sysop can reset a user's password and clear their second factor from
the user editor". The board has several Sysop-role accounts.

## Expect

- The shaping asks which permission gates each of the two actions and who holds it by default,
  and how an upgrade that adds the permission grants it.
- The shaping asks whether the actions can take over account #1, and names the chain: another
  Sysop-role account resets #1's password and clears its second factor.
- The brief guards the chain (for example, only #1 itself or the local operator at the host
  acts on #1's credentials) rather than leaving it open.
