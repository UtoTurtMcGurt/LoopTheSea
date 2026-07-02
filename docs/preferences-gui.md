# Preference GUI

LoopTheSea includes a KoLmafia relay-browser preference page:

```text
relay_LoopTheSea.ash
```

After installing the project, open KoLmafia's relay browser and use the relay
script menu to launch LoopTheSea Preferences. Depending on your KoLmafia relay
setup, it can also be opened directly from the relay browser as:

```text
relay_LoopTheSea.ash
```

## What It Does

The relay page edits preferences in these namespaces:

- `loopTheSea_*`
- `underTheSeaPrep_*`

It covers the common configuration groups:

- run flow and safety
- automated ascension
- Leg1 UnderTheSeaPrep settings
- Leg2 pearl and Fishy settings
- Leg2 consume, Garbo, and rollover settings
- tracking and daily pickups

## What It Does Not Do

The relay page does not run the loop. It does not:

- run Garbo
- consume diet
- farm turns
- replace campground furniture
- PvP
- ascend

After saving preferences, run the usual read-only checks from the CLI:

```text
LoopTheSea status
LoopTheSea preflight
```

## Alpha-Safe Defaults

The page includes an `Apply Alpha-Safe Defaults` button. This is intended for
new testers and staged runs. It disables automated ascension, disables automatic
Leg2 continuation, switches Leg2 pearls to `REPORT`, and disables saltwaterbed
installation.

Experienced users can then opt into the more aggressive pieces one by one.
