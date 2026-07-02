# Configuration

LoopTheSea stores its own preferences under the `loopTheSea_*` and `_loopTheSea_*` namespaces. It intentionally does not read or write legacy pLoop preferences.

Start with:

```text
LoopTheSea status
LoopTheSea preflight
LoopTheSea prefs audit
```

## Common Preferences

```text
loopTheSea_runInitialGarbo
loopTheSea_initialGarboCommand
loopTheSea_profitTrackingEnabled
loopTheSea_profitTrackingRequired
loopTheSea_profitTrackingRecap
loopTheSea_underTheSeaCommand
loopTheSea_leg2PearlMode
loopTheSea_leg2PearlTargetCount
loopTheSea_leg2PearlBuffer
loopTheSea_leg2GarboAfterPearls
loopTheSea_leg2GarboCommand
loopTheSea_leg2RunFinalNightcap
loopTheSea_leg2PrepareRollover
loopTheSea_leg2UseWetDatesRollover
```

## Automated Ascension

Automated ascension should be enabled only after preflight passes.

```text
loopTheSea_ascendEnabled
loopTheSea_nextAscensionType
loopTheSea_nextPathId
loopTheSea_nextClassName
loopTheSea_nextMoonId
loopTheSea_nextGender
loopTheSea_astralDeli
loopTheSea_astralPet
loopTheSea_permSkills
loopTheSea_permMinimumBankedKarma
loopTheSea_stopAfterAscension
```

Run:

```text
LoopTheSea ascend preflight
```

before:

```text
LoopTheSea ascend
```

## Pearl Modes

Leg2 pearl behavior is controlled by:

```text
loopTheSea_leg2PearlMode
```

Typical modes:

- `FARM`: farm selected Leg2 pearls.
- `REPORT`: report expected value without farming.
- `NEVER`: skip Leg2 pearl farming.

Leg1 pearl policy is handled by `UnderTheSeaPrep`.

## Player-Owned Preferences

Some KoLmafia preferences are intentionally not managed by LoopTheSea. For example, `maximizerCombinationLimit` should be set by the player according to their own performance tolerance.
