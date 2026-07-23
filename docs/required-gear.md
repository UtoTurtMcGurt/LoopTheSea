# Hard Required Gear

This page describes the gear and familiar requirements for the full LoopTheSea
route. It separates true blockers from configurable or purchasable support.
For live account context, run:

```text
LoopTheSea sim
```

LoopTheSea is not intended as a low-resource general account script. Some pieces
can be bought or assembled after prism, but the account still needs access to
the relevant slots, familiars, effects, paths, and dependency scripts.

## Always Required For 11,037 Leagues Looping

These are hard blockers for the intended Leg1 -> 11,037 Leagues -> Leg2 loop
when the next UnderTheSea run should start with pearls smuggled through the
Codpiece.

- `The Eternity Codpiece`
- five `unblemished pearl`, held or mounted before ascension

Why:

- The Codpiece smuggles five mounted pearls into the next UnderTheSea run.
- The pearls are consumed by the 11,037 Leagues Under the Sea run.

LoopTheSea can use held pearls, buy missing pearls when configured, or use an
advanced farm route when the account opts into it.

## Advanced Leg1 Organ-Lock Route

These are required only when:

```text
loopTheSea_leg1PearlFarmRoute = ORGAN_LOCK
loopTheSea_allowOrganLockPearlFarming = true
```

- `Drunkula's wineglass`
- `angelbone totem`
- `devilbone corset`
- `devilbone greaves`
- `angelbone chopsticks`
- `Stooper` familiar

Why:

- The wineglass lets Garbo/LoopTheSea use overdrunk turns.
- The angelbone/devilbone organ-lock set is explicitly equipped and verified
  during expanded-organ routing.
- Stooper is required for the nightcap phase that enters the overdrunk route.

## Leg1 Pearl Farming

The advanced Leg1 pearl farm runs while overdrunk and usually
overfull/overtoxic, so it has stricter equipment locks than ordinary Sea
adventuring.

Hard requirements:

- a familiar/familiar-equipment plan that can adventure underwater
- one valid underwater air source that can still satisfy resistance checks
- enough resistance gear/buffs to reach `18` resistance for each targeted zone

Default familiar plan:

- `Grouper Groupie`
- `gill rings`

`Grouper Groupie` is the default because it naturally supports underwater
adventuring, leaving the familiar item slot free. `gill rings` are the script's
safe default familiar item, but they are configurable with
`underTheSeaPrep_pearlFamiliarEquipment`; pearls are forced by zone progress,
not by familiar item drop.

Air-supply candidates, in script order:

- `really, really nice swimming trunks`
- `aerated diving helmet`
- `crappy Mer-kin mask`
- `Mer-kin gladiator mask`
- `Mer-kin scholar mask`
- `old SCUBA tank`
- `Elf Guard SCUBA tank`

Important caveat:

- `really, really nice swimming trunks` only works when the pants slot is not
  locked. During the normal expanded-spleen Leg1 pearl route, pants are usually
  locked by `devilbone greaves`, so a hat or back-slot air source is normally
  required.

Also required in practice:

- a Fishy source, via existing Fishy, `fishy pipe`, Lutz when available, or
  `cuppa Gill tea`

## Leg2 Pearl Pressure Gear

For automated Leg2 pearl farming, LoopTheSea explicitly locks this pressure
gear into the maximizer.

Hard requirements when `loopTheSea_leg2PearlMode=FARM` or `ALWAYS`:

- `cozy bazooka`
- `Goggles of Loathing`
- `aquamariner's necklace`
- `aquamariner's ring`
- `teflon swim fins`

The script can acquire or assemble `cozy bazooka` after prism if the price cap
allows it:

- `cozy bazooka`, or
- `fish bazooka` + `bazooka cozy`

The other core pressure pieces must be accessible or buyable within
`loopTheSea_leg2GearMaxPrice`.

## Leg2 Pearl Familiar Gear

LoopTheSea must be able to select one Leg2 pearl familiar and equip the expected
familiar item.

Supported options:

- `Hobo Monkey` with `Das Boot`
- `Urchin Urchin` with `Li'l Businessman Kit`
- `Grouper Groupie` with `Li'l Businessman Kit`

In `AUTO` mode, the script prefers:

1. Hobo Monkey with `Das Boot`, if the configured Moxie floor is met.
2. Urchin Urchin.
3. Grouper Groupie.

If Urchin Urchin or Grouper Groupie is selected, `Li'l Businessman Kit` becomes
the required familiar equipment.

## Conditional Pantogram Requirements

Pantogram pants are not globally mandatory, but they are part of the preferred
Leg2 pressure/resistance setup.

Required when building Leg2 Pantogram pants:

- `portable pantogram`
- `porquoise`
- `11 sea salt crystal`

Optional left sacrifice:

- `glowing New Age crystal`, preferred by current config
- free `mp` fallback if the crystal is unavailable

If Pantogram pants already exist and
`loopTheSea_leg2RequirePantogramPressure=true`, they must have the underwater
pressure modifier from `11 sea salt crystal`.

## Conditional BOFA Fishy Gear

Seal Clubber BOFA Fishy is optional fallback routing for Leg2 Fishy.

Required only for that route:

- `Monodent of the Sea`

If this is unavailable, LoopTheSea can still use retained Fishy, `fishy pipe`,
Lutz, or paid `cuppa Gill tea` according to configuration and availability.

## Not Hard Required But Commonly Used

These are useful, but the loop either treats them as optional, has fallback
logic, or buys them when configured.

- `fishy pipe`
- `cuppa Gill tea`
- `fish sauce`
- `shark cartilage`
- `shavin' razor`
- `Mer-kin fastjuice`
- `sea salt crystal` for temporary pressure buffing
- `saltwaterbed`
- `pile of wet dates`
- `Mayam Calendar`
- `Chroner trigger`
- `Chroner cross`
- `2002 Mr. Store Catalog`
- `Spooky VHS Tape`
- `day shortener`
- `confusing LED clock`
- `Beach Comb` or `driftwood beach comb`

## External Dependency Requirements

This list covers LoopTheSea and UnderTheSeaPrep. The external scripts called by
LoopTheSea may have their own requirements, especially:

- `garbo`
- `CONSUME`
- `UnderTheSea`

If one of those scripts aborts because it needs an item, that item should be
documented as a dependency-script requirement rather than a LoopTheSea gear
lock, unless LoopTheSea itself starts managing it.
