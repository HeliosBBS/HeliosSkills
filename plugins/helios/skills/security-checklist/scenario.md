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
