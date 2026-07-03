# Dependencies

LoopTheSea is an orchestrator. It does not replace the scripts it calls.

## Required Scripts

- [Garbage Collector (Garbo)](https://github.com/loathers/garbage-collector):
  main Meat farming engine. LoopTheSea calls `garbo ascend`, `garbo`, and
  `garbo nodiet` depending on phase.
- [soolar/CONSUME.ash](https://github.com/soolar/CONSUME.ash): diet planning and
  execution. LoopTheSea calls `CONSUME NIGHTCAP`, `CONSUME ALL`, and
  `CONSUME ORGANS ...`.
- [Astro3207/UnderTheSea](https://github.com/Astro3207/UnderTheSea): completes
  `11,037 Leagues Under the Sea`.

## Optional Scripts

- [Prusias-kol/pTrack](https://github.com/Prusias-kol/pTrack): used for
  profit markers and recap output.
- [Pantocyclus/PVP_MAB](https://github.com/Pantocyclus/PVP_MAB): used when
  `underTheSeaPrep_runPvp=true`.

## Conditional Script Commands

- [loathers/combo](https://github.com/loathers/combo) / BeachComber support:
  used by UnderTheSeaPrep for Leg1
  beach-comb turn burning after pearls and Codpiece mounting. If no turns need
  that route, it may not be exercised, but full automation should have it
  available.

## KoLmafia Built-Ins Used

LoopTheSea also calls KoLmafia CLI commands and features such as `breakfast`,
`maximize`, `raffle`, `hagnk all`, `terminal educate`, `mayam`, `rest`,
`refresh`, `closet`, and `stash`. These are KoLmafia/game features rather than
separate script dependencies.

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
