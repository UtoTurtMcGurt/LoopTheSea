# Recovery

LoopTheSea is designed to be re-entrant, but KoLmafia state can still become confused after a power outage, manual intervention, or dependency abort.

## First Checks

Run:

```text
LoopTheSea status
LoopTheSea preflight
```

Then read the current phase:

- Leg1 aftercore
- pre-Valhalla checkpoint
- inside UnderTheSea
- post-UnderTheSea aftercore
- Leg2 rollover complete

## Preference Backups

LoopTheSea can write reviewable preference backups:

```text
LoopTheSea prefs backup
LoopTheSea prefs audit
```

Backups are written under KoLmafia's `data/` directory with `LoopTheSea_prefs_` filenames. These files can contain account-specific preference data and should not be committed to Git.

## Common Resume Patterns

If Leg1 completed and you are at the pre-Valhalla checkpoint:

```text
LoopTheSea ascend preflight
LoopTheSea ascend
```

If UnderTheSea completed but Leg2 did not finish:

```text
LoopTheSea leg2
```

If Leg2 pearl farming completed but Garbo or rollover did not:

```text
LoopTheSea leg2
```

The script should skip completed checkpoints and continue from the next unfinished section.

## When To Stop

Stop and inspect logs if:

- KoLmafia is in a choice adventure.
- You are in combat.
- KoLmafia preferences appear reset or blank.
- `LoopTheSea status` contradicts visible character state.
- A dependency script aborts repeatedly at the same point.
