# interactor-anny-follow-guest

The avatar follows the muscle skeleton: a SafeGDScript guest that poses ANNY's 104 bones from the body placements of MS-Human-700.

## What is here

- `follow.sgd`: the mapping, as data plus arithmetic.
- `data/drive.yamlld`: which body of the muscle skeleton drives which bone, canonical YAML-LD written by `tools/drive_table.exs`.
- `proof/` and `tests/math_proof.gd`: what arithmetic a SafeGDScript guest has.
- `tests/follow_gate.gd`, `tests/follow_rig.gd`, `tests/follow_movie.gd`: the gate against a reference, the apparatus, and the movie.
- `docs/follow.md`: frames, the mapping, the calls and the controls.

    godot --headless --path . -s tests/follow_gate.gd -- <mujoco.double.elf> <anny_base.glb> <reference dir> [--control=swap]

This guest came out of `entities-muscle-course`, which keeps the course itself.

## The other parts

Each part of the presence slice is a repository of its own in `V-Sekai-fire`, and they are checked
out side by side.

| Repository | What it holds |
| --- | --- |
| `interactor-packets-guest` | the Packet codec and the order of a body's 21 parts |
| `interactor-zone-router-guest` | the model of a zone that only routes, and the trace a relay replays |
| `interactor-observer-guest` | one client's check of what the zone relays: hashes, tags and verdicts |
| `interactor-curve-guest` | curve playback between sends |
| `interactor-replica-guest` | a shared object as four replicas |
| `interactor-anny-follow-guest` | the avatar posed from the muscle skeleton |
| `transport-zone-relay` | the relay in C, on sockets, with its load generator |
| `interactor-presence-gates` | the gates that join the parts on a real body, the videos and the ledger |

## Rules of the source

Guests are SafeGDScript and gates are GDScript run on a double-precision editor with the sandbox
built in. A gate prints a `RESULT:` line and has controls that must fail. Comments are at most 3%
of a file's lines, which `tools/comment_density.exs` of `interactor-presence-gates` checks, and
the explanation is in the documentation.

## Licence

MIT; see `LICENSE`.
