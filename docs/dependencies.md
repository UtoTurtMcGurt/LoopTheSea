# Dependencies

LoopTheSea is an orchestrator. It does not replace the scripts it calls.

## Required Scripts

- `garbo`: main Meat farming engine.
- `CONSUME`: diet planning and execution.
- `UnderTheSea`: completes `11,037 Leagues Under the Sea`.

## Optional Scripts

- `ptrack`: used for profit markers and recap output.
- `pvp_mab`: used when `loopTheSea_runPvp=true`.

## Important Account/Item Assumptions

The script is designed around an account with access to:

- Drunkula's wineglass
- The Eternity Codpiece
- unblemished pearl routing
- Underwater gear or Fishy access
- enough rollover, diet, and farming resources for Garbo-style aftercore play

Leg2 pressure optimization may use or acquire:

- cozy bazooka, or fish bazooka + bazooka cozy
- Goggles of Loathing
- aquamariner's necklace
- aquamariner's ring
- teflon swim fins
- Pantogram pants
- sea salt crystals
- porquoise

When a piece is missing, `LoopTheSea status` and `LoopTheSea preflight` should explain whether it is ready, assemble-ready, buy-ready, or blocked.

See [required-gear.md](required-gear.md) for the hard gear and familiar list used by LoopTheSea itself.
