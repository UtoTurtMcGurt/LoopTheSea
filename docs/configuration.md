# Configuration

LoopTheSea stores its own preferences under the `loopTheSea_*` and `_loopTheSea_*` namespaces. It intentionally does not read or write legacy pLoop preferences.

Start with:

```text
LoopTheSea status
LoopTheSea sim
LoopTheSea preflight
```

Common preferences can also be edited from KoLmafia's relay browser with:

```text
relay_LoopTheSea.ash
```

The relay page only saves preferences. It does not run LoopTheSea or spend
resources. See [preferences-gui.md](preferences-gui.md).

`LoopTheSea sim` is a read-only readiness report. It does not equip, buy, use,
retrieve, consume, adventure, or maximize. Use it for a quick check of required
items, nice-to-have support, and optional miscellany before running the loop.

## Common Preferences

```text
loopTheSea_runInitialGarbo
loopTheSea_initialGarboCommand
loopTheSea_profitTrackingEnabled
loopTheSea_profitTrackingRequired
loopTheSea_profitTrackingRecap
loopTheSea_underTheSeaCommand
loopTheSea_leg1PearlPolicy
loopTheSea_leg1PearlFarmRoute
loopTheSea_allowOrganLockPearlFarming
loopTheSea_leg1PearlBuyMaxPrice
loopTheSea_leg1PearlManualCheckpoint
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
loopTheSea_ascensionType
loopTheSea_pathId
loopTheSea_className
loopTheSea_moonId
loopTheSea_gender
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

Leg1 pearl routing is being split into a public-facing acquisition policy and a
separate farming route:

```text
loopTheSea_leg1PearlPolicy
loopTheSea_leg1PearlFarmRoute
loopTheSea_allowOrganLockPearlFarming
loopTheSea_leg1PearlBuyMaxPrice
loopTheSea_leg1PearlManualCheckpoint
```

Public-safe defaults are:

```text
loopTheSea_leg1PearlPolicy = VALUE
loopTheSea_leg1PearlFarmRoute = AUTO
loopTheSea_allowOrganLockPearlFarming = false
```

`LoopTheSea sim` and `LoopTheSea preflight` will advise players to opt into the
advanced organ-lock route when Drunkula's wineglass, Stooper, the organ-lock
gear, and basic Sea support are detected. The advanced route uses:

```text
loopTheSea_leg1PearlPolicy = ALWAYS_FARM
loopTheSea_leg1PearlFarmRoute = ORGAN_LOCK
loopTheSea_allowOrganLockPearlFarming = true
```

The advanced route defaults to a conservative underwater familiar package:

```text
underTheSeaPrep_pearlFamiliar = Grouper Groupie
underTheSeaPrep_pearlFamiliarEquipment = gill rings
```

`Grouper Groupie` is the default because it can adventure underwater without
spending the familiar item slot on breathing support. `gill rings` are a safe
historical default, not a pearl-drop requirement. Advanced users may set a
different familiar or familiar item, including `none`, but the final outfit must
still pass KoLmafia's underwater access checks before turns are spent.

Leg2 pearl behavior is controlled by:

```text
loopTheSea_leg2PearlMode
```

Typical modes:

- `FARM`: farm selected Leg2 pearls.
- `REPORT`: report expected value without farming.
- `NEVER`: skip Leg2 pearl farming.

Operationally, `ORGAN_LOCK` still uses `UnderTheSeaPrep postgarbo`. Non-organ
routes use held or bought pearls, then call `UnderTheSeaPrep finishplain` for
Codpiece mounting, pre-ascension cleanup, ordinary turn burning, and PvP.
`RESERVED_TURNS` is reserved for the future normal-turn pearl farming branch
and will currently stop with a clear message.

## Player-Owned Preferences

Some KoLmafia preferences are intentionally not managed by LoopTheSea. For example, `maximizerCombinationLimit` should be set by the player according to their own performance tolerance.
