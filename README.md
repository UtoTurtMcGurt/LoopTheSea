# LoopTheSea

LoopTheSea is a KoLmafia automation script for a two-leg `garbo` and `11,037 Leagues Under the Sea` loop. It coordinates Leg1 Garbo, post-Garbo pearl preparation, pre-ascension cleanup, optional automated ascension, UnderTheSea execution, Leg2 pearl farming, Leg2 Garbo, and rollover preparation.

This is an alpha script. It can spend Meat, consume diet, PvP, manipulate equipment, use limited daily resources, and ascend. Read the configuration and run preflight before enabling full-day automation.

## Install

In KoLmafia, install from GitHub with the branch you intend to use:

```text
git checkout https://github.com/UtoTurtMcGurt/LoopTheSea.git main
```

Then validate:

```text
validate LoopTheSea
validate LoopTheSeaPrefs
validate UnderTheSeaPrep
validate LoopTheSeaPearlCCS
validate LoopTheSeaBofaFishyCCS
```

## Dependencies

LoopTheSea expects several external scripts and account capabilities.

Required or commonly required:

- `garbo`
- `CONSUME`
- `UnderTheSea`
- KoLmafia with ASH support and current item/effect data

Optional but strongly recommended:

- `ptrack` for profit checkpoints
- `pvp_mab` for end-of-Leg1 PvP

See [docs/dependencies.md](docs/dependencies.md) for more detail.

## First Run

Start with read-only checks:

```text
LoopTheSea status
LoopTheSea preflight
LoopTheSeaPrefs audit
```

For a guarded first operational run, use the staged commands instead of full automation:

```text
LoopTheSea leg1full
LoopTheSea ascend preflight
LoopTheSea ascend
LoopTheSea leg2
```

Once the account and preferences are stable:

```text
LoopTheSea fullday
```

## Main Commands

```text
LoopTheSea status
LoopTheSea preflight
LoopTheSea breakfast
LoopTheSea leg1
LoopTheSea leg1full
LoopTheSea leg1rollover
LoopTheSea ascend preflight
LoopTheSea ascend
LoopTheSea undersea
LoopTheSea leg2
LoopTheSea postrun
LoopTheSea rollover
LoopTheSea run
LoopTheSea fullday
LoopTheSea reset
```

Preference backup/audit commands are provided by the companion utility:

```text
LoopTheSeaPrefs status
LoopTheSeaPrefs audit
LoopTheSeaPrefs backup before-experiment
```

## Safety Notes

- Do not enable automated ascension until `LoopTheSea ascend preflight` passes.
- Keep your own KoLmafia preference backups. `LoopTheSeaPrefs` writes reviewable snapshots, but power loss or preference corruption can still put KoLmafia in a confused state.
- Review `LoopTheSea status` after any crash before resuming.
- `maximizerCombinationLimit` is deliberately not managed by LoopTheSea. Set it yourself if your local maximizer searches become too expensive.

## License

This project is distributed under the MIT License. External dependencies retain their own licenses and are not bundled here.
