script "KoLmafiaPrefGuard";

/*
KoLmafia preference backup and audit utility.

Standalone helper for taking reviewable snapshots of LoopTheSea,
UnderTheSeaPrep, and selected KoLmafia prefs before risky experiments.

Usage:
  KoLmafiaPrefGuard audit
  KoLmafiaPrefGuard backup [phase]
  KoLmafiaPrefGuard checkpoint [phase]
  KoLmafiaPrefGuard status

Backups are written to KoLmafia's data directory as TSV snapshots plus a
reviewable restore-command text file.
*/

string TOOL_PREF = "kolmafiaPrefGuard_";
string TOOL_INTERNAL = "_kolmafiaPrefGuard_";
string PREF = "loopTheSea_";
string INTERNAL = "_loopTheSea_";

string tool_pref_string(string key, string fallback) {
    string value = get_property(TOOL_PREF + key);
    if (value == "") return fallback;
    return value;
}

boolean tool_pref_bool(string key, boolean fallback) {
    string value = get_property(TOOL_PREF + key);
    if (value == "") return fallback;
    return value.to_boolean();
}

void set_tool_default(string key, string value) {
    if (get_property(TOOL_PREF + key) == "") set_property(TOOL_PREF + key, value);
}

void initialize_defaults() {
    set_tool_default("backupEnabled", "true");
    set_tool_default("checkpointBackupsEnabled", "true");
    set_tool_default("backupPrefix", "KoLmafiaPrefGuard_prefs");
}

string loop_pref_string(string key, string fallback) {
    string value = get_property(PREF + key);
    if (value == "") return fallback;
    return value;
}

boolean loop_pref_bool(string key, boolean fallback) {
    string value = get_property(PREF + key);
    if (value == "") return fallback;
    return value.to_boolean();
}

string trim_string(string value) {
    matcher m = create_matcher("^\\s*(.*?)\\s*$", value);
    if (m.find()) return m.group(1);
    return value;
}

string backup_safe_fragment(string value) {
    value = replace_string(value, " ", "_");
    value = replace_string(value, ":", "");
    value = replace_string(value, "/", "_");
    value = replace_string(value, "\\", "_");
    value = replace_string(value, ",", "_");
    return value;
}

string backup_value(string value) {
    value = replace_string(value, "\t", "\\t");
    value = replace_string(value, "\r", "\\r");
    value = replace_string(value, "\n", "\\n");
    return value;
}

void append_property_snapshot(buffer snapshot, buffer restore, string scope, string property_name) {
    string value = get_property(property_name);
    snapshot.append(scope + "\t" + property_name + "\t" + backup_value(value) + "\n");
    restore.append("set " + property_name + " = " + value + "\n");
}

void append_loop_prefs(buffer snapshot, buffer restore) {
    string [int] keys = {
        0: "runInitialGarbo",
        1: "initialGarboCommand",
        2: "preserveInitialGarboFishy",
        3: "allowPartialInitialGarboRetry",
        4: "requireInitialGarboCompleted",
        5: "ascendEnabled",
        6: "ascensionType",
        7: "pathId",
        8: "className",
        9: "moonId",
        10: "gender",
        11: "astralPet",
        12: "astralDeli",
        13: "permSkills",
        14: "permMinimumBankedKarma",
        15: "stopAfterAscension",
        16: "underTheSeaCommand",
        17: "underTheSeaAutoRecoverFishy",
        18: "hagnkAllAfterUnderSea",
        19: "stopAfterLeg1",
        20: "leg2PearlMode",
        21: "leg2PearlTargetCount",
        22: "leg2PearlBuffer",
        23: "leg2PearlResTarget",
        24: "leg2RunAfterUnderSea",
        25: "leg2BuildPantogram",
        26: "leg2RequirePantogramPressure",
        27: "leg2PantogramStat",
        28: "leg2PantogramElement",
        29: "leg2PantogramLeftSacrifice",
        30: "leg2GearMaxPrice",
        31: "leg2GillTeaMaxPrice",
        32: "leg2FishyTopupMode",
        33: "leg2FishSauceMaxPrice",
        34: "leg2FishyValueOfAdventure",
        35: "leg2UseBofaFishy",
        36: "leg2BofaFishyMaxAttempts",
        37: "leg2BofaFishyLocation",
        38: "leg2SharkCartilageMaxPrice",
        39: "leg2ShavinRazorMaxPrice",
        40: "leg2FastjuiceMaxPrice",
        41: "leg2SeaSaltCrystalMaxPrice",
        42: "leg2DonhoRecordingMaxPrice",
        43: "leg2InstallSaltwaterbed",
        44: "leg2SealeatherMaxPrice",
        45: "leg2ReserveLimitedBuffsForGarbo",
        46: "leg2PearlOutfitPriority",
        47: "leg2PressureMaximizer",
        48: "leg2UseGenericMeatBuffs",
        49: "leg2UseDonho",
        50: "leg2AllowDonhoItemFallback",
        51: "leg2UsePressureConsumables",
        52: "leg2UseResistanceBuffs",
        53: "leg2MinorInvulnerabilityMaxPrice",
        54: "leg2UseResistancePotionRescue",
        55: "leg2ResistancePotionMaxPrice",
        56: "leg2ResistancePotionTotalCap",
        57: "leg2ExtraPearlBuffCommands",
        58: "leg2AutoApproveSaltwaterbedReplace",
        59: "leg2ConsumeBeforePearls",
        60: "leg2ConsumeMode",
        61: "leg2ConsumeCommand",
        62: "leg2AllowBoozeConsume",
        63: "leg2AllowRiskyConsume",
        64: "leg2PearlFamiliarMode",
        65: "leg2HoboMonkeyMoxieFloor",
        66: "leg2GarboAfterPearls",
        67: "leg2GarboCommand",
        68: "leg2RequireGarboSpendAllTurns",
        69: "leg2RunBreakfastSweep",
        70: "leg2BreakfastCommand",
        71: "leg2RunLateDailySweep",
        72: "leg2RerunBreakfastAtRollover",
        73: "leg2UseRemainingChronerItems",
        74: "leg2Spend2002Credits",
        75: "leg2MrStore2002Reward",
        76: "leg2LateDailyCommand",
        77: "leg2LateDailyTurnBurnCommand",
        78: "leg2RunFinalNightcap",
        79: "leg2FinalNightcapCommand",
        80: "leg2RunExpandedOrgansRollover",
        81: "leg2KeepOrganGearForRollover",
        82: "leg2UseWetDatesRollover",
        83: "leg2WetDatesMaxPrice",
        84: "leg2PrepareRollover",
        85: "leg2RolloverAdventureCap",
        86: "leg2RolloverMaximizer",
        87: "leg2OverflowGarboCommand",
        88: "leg2RolloverCommand",
        89: "postRunPearlMode",
        90: "postRunFishyOnly",
        91: "postRunMinimumPearlMpa",
        92: "postRunPearlCombatScript",
        93: "leg2PearlRecoverHpPercent",
        94: "leg2PearlRecoverMpTarget",
        95: "leg2PearlCureBeatenUp",
        96: "leg2PearlCureTheColors",
        97: "leg2NegativeEffectCureMaxPrice",
        98: "leg2UseExtract",
        99: "leg2UseSourceTerminalMeat",
        100: "pearlValueOverride",
        101: "profitTrackingEnabled",
        102: "profitTrackingRequired",
        103: "profitTrackingRecap",
        104: "profitMarkerPrefix",
        105: "useGovernmentPerDiem",
        106: "dailyRaffleTickets",
        107: "protectPorquoiseBeforeUnderSea",
        108: "leg1PrepareRollover",
        109: "leg1RolloverAdventureCap",
        110: "leg1RolloverMaximizer",
        111: "leg1OverflowGarboCommand",
        112: "leg1RolloverCommand"
    };
    foreach i, key in keys {
        append_property_snapshot(snapshot, restore, "loop", PREF + key);
    }
}

void append_internal_prefs(buffer snapshot, buffer restore) {
    string [int] keys = {
        0: "checkpointDate",
        1: "initialGarboDone",
        2: "leg1Complete",
        3: "underTheSeaComplete",
        4: "leg2Complete",
        5: "profitTrackingActive",
        6: "raffleTicketsBought",
        7: "leg2PantogramElementChoice",
        8: "leg2ConsumeDone",
        9: "porquoiseClosetedBeforeUnderSea",
        10: "leg2PearlFamiliar",
        11: "leg2BreakfastDone",
        12: "leg2LateDailyDone",
        13: "leg2GarboDone",
        14: "leg2NightcapDone",
        15: "leg2ExpandedOrgansDone",
        16: "leg2RolloverHookDone",
        17: "leg2RolloverDone",
        18: "leg2BofaFishyAttempts",
        19: "leg2PearlBudgetFloor",
        20: "leg1RolloverHookDone",
        21: "leg1RolloverDone",
        22: "enteredValhalla",
        23: "ascensionComplete",
        24: "ascensionStartedFrom",
        25: "ascensionNumber",
        26: "afterlifeDeliBoughtFor",
        27: "afterlifeArmoryBoughtFor"
    };
    foreach i, key in keys {
        append_property_snapshot(snapshot, restore, "internal", INTERNAL + key);
    }
}

void append_tool_prefs(buffer snapshot, buffer restore) {
    string [int] keys = {
        0: "backupEnabled",
        1: "checkpointBackupsEnabled",
        2: "backupPrefix"
    };
    foreach i, key in keys {
        append_property_snapshot(snapshot, restore, "prefguard", TOOL_PREF + key);
    }
}

void append_undertheseaprep_prefs(buffer snapshot, buffer restore) {
    string [int] keys = {
        0: "underTheSeaPrep_pearlPolicy",
        1: "underTheSeaPrep_gillTeaMaxPrice",
        2: "underTheSeaPrep_pearlBuffer",
        3: "underTheSeaPrep_minOrganLockTurns",
        4: "underTheSeaPrep_muscleFloor",
        5: "underTheSeaPrep_extraPearlBuffCommands",
        6: "underTheSeaPrep_runPvp",
        7: "underTheSeaPrep_nextAscensionType",
        8: "underTheSeaPrep_nextPathId",
        9: "underTheSeaPrep_preAscendAcquireList",
        10: "underTheSeaPrep_preAscendClanStashAcquireList",
        11: "underTheSeaPrep_smolNoSaladFork",
        12: "underTheSeaPrep_smolNoFrostyMug",
        13: "_underTheSeaPrep_organLockActive",
        14: "_underTheSeaPrep_organLockUntilTurn",
        15: "_underTheSeaPrep_firstNightcapDone",
        16: "_underTheSeaPrep_secondGarboDone",
        17: "_underTheSeaPrep_confusingLedClockPending"
    };
    foreach i, key in keys {
        append_property_snapshot(snapshot, restore, "prep", key);
    }
}

void append_critical_mafia_prefs(buffer snapshot, buffer restore) {
    string [int] keys = {
        0: "valueOfAdventure",
        1: "customCombatScript",
        2: "choiceAdventureScript",
        3: "betweenBattleScript",
        4: "afterAdventureScript",
        5: "recoveryScript",
        6: "currentMood",
        7: "maximizerCombinationLimit",
        8: "autoSatisfyWithCloset",
        9: "autoSatisfyWithCoinmasters",
        10: "autoSatisfyWithMall",
        11: "autoSatisfyWithNPCs",
        12: "autoSatisfyWithStorage",
        13: "hpAutoRecovery",
        14: "hpAutoRecoveryTarget",
        15: "mpAutoRecovery",
        16: "mpAutoRecoveryTarget",
        17: "bankedKarma",
        18: "leprecondoInstalled",
        19: "leprecondoNeedOrder",
        20: "leprecondoCurrentNeed",
        21: "leprecondoLastNeedChange",
        22: "skateParkStatus",
        23: "_skateBuff1",
        24: "_fishyPipeUsed",
        25: "mapToTheDiveBarPurchased",
        26: "mapToMadnessReefPurchased",
        27: "mapToTheMarinaraTrenchPurchased",
        28: "mapToTheSkateParkPurchased",
        29: "_unblemishedPearlAnemoneMine",
        30: "_unblemishedPearlDiveBar",
        31: "_unblemishedPearlMadnessReef",
        32: "_unblemishedPearlMarinaraTrench",
        33: "_unblemishedPearlTheBriniestDeepests",
        34: "_unblemishedPearlAnemoneMineProgress",
        35: "_unblemishedPearlDiveBarProgress",
        36: "_unblemishedPearlMadnessReefProgress",
        37: "_unblemishedPearlMarinaraTrenchProgress",
        38: "_unblemishedPearlTheBriniestDeepestsProgress",
        39: "sourceTerminalEducateKnown",
        40: "sourceTerminalEnhanceKnown",
        41: "lastAdventure",
        42: "lastAdventureTrail",
        43: "nextAdventure",
        44: "lastEncounter",
        45: "lastCopyableMonster",
        46: "trackedMonsters",
        47: "_mayamSymbolsUsed",
        48: "_mapToACandyRichBlockUsed",
        49: "_mapToACandyRichBlockDrops",
        50: "_pantogramModifier"
    };
    foreach i, key in keys {
        append_property_snapshot(snapshot, restore, "mafia", key);
    }
}

string prefs_backup(string phase) {
    initialize_defaults();

    buffer snapshot;
    buffer restore;
    string stamp = now_to_string("YYYYMMddHHmmss");
    string safe_phase = backup_safe_fragment(phase);
    string prefix = backup_safe_fragment(tool_pref_string("backupPrefix", "KoLmafiaPrefGuard_prefs"));
    string user = backup_safe_fragment(my_name());
    string filename = prefix + "_" + user + "_" + stamp + "_" + safe_phase + ".tsv";
    string restore_filename = prefix + "_" + user + "_" + stamp + "_" + safe_phase + "_restore.txt";
    string latest_filename = prefix + "_" + user + "_latest.tsv";
    string latest_restore_filename = prefix + "_" + user + "_latest_restore.txt";

    snapshot.append("scope\tproperty\tvalue\n");
    snapshot.append("meta\tbackupPhase\t" + backup_value(phase) + "\n");
    snapshot.append("meta\tbackupStamp\t" + stamp + "\n");
    snapshot.append("meta\tuser\t" + backup_value(my_name()) + "\n");
    snapshot.append("meta\tascensions\t" + my_ascensions() + "\n");
    snapshot.append("meta\tpath\t" + backup_value("" + my_path()) + "\n");
    snapshot.append("meta\tclass\t" + backup_value("" + my_class()) + "\n");
    snapshot.append("meta\tturnsPlayed\t" + turns_played() + "\n");
    snapshot.append("meta\tadventures\t" + my_adventures() + "\n");
    snapshot.append("meta\tfullness\t" + my_fullness() + "/" + fullness_limit() + "\n");
    snapshot.append("meta\tinebriety\t" + my_inebriety() + "/" + inebriety_limit() + "\n");
    snapshot.append("meta\tspleen\t" + my_spleen_use() + "/" + spleen_limit() + "\n");

    restore.append("# KoLmafiaPrefGuard restore commands\n");
    restore.append("# Snapshot: " + filename + "\n");
    restore.append("# Review before running; do not blindly restore stale daily state.\n");

    append_tool_prefs(snapshot, restore);
    append_loop_prefs(snapshot, restore);
    append_internal_prefs(snapshot, restore);
    append_undertheseaprep_prefs(snapshot, restore);
    append_critical_mafia_prefs(snapshot, restore);

    if (!buffer_to_file(snapshot, filename)) abort("Unable to write preference backup " + filename + ".");
    if (!buffer_to_file(restore, restore_filename)) abort("Unable to write preference restore file " + restore_filename + ".");
    buffer_to_file(snapshot, latest_filename);
    buffer_to_file(restore, latest_restore_filename);

    set_property(TOOL_INTERNAL + "lastBackupFile", filename);
    set_property(TOOL_INTERNAL + "lastBackupRestoreFile", restore_filename);
    set_property(TOOL_INTERNAL + "lastBackupPhase", phase);
    set_property(TOOL_INTERNAL + "lastBackupStamp", stamp);

    print("Preference backup written: data/" + filename, "green");
    print("Reviewable restore commands: data/" + restore_filename, "green");
    return filename;
}

void prefs_checkpoint(string phase) {
    initialize_defaults();
    if (!tool_pref_bool("backupEnabled", true)) {
        print("KoLmafiaPrefGuard checkpoint skipped: backups are disabled.", "yellow");
        return;
    }
    if (!tool_pref_bool("checkpointBackupsEnabled", true)) {
        print("KoLmafiaPrefGuard checkpoint skipped: checkpoint backups are disabled.", "yellow");
        return;
    }
    prefs_backup(phase);
}

int audit_warning(int warnings, string message) {
    print("WARN: " + message, "red");
    return warnings + 1;
}

int audit_notice(int notices, string message) {
    print("NOTE: " + message, "yellow");
    return notices + 1;
}

void prefs_audit() {
    initialize_defaults();
    int warnings = 0;
    int notices = 0;

    print("KoLmafia preference guard audit", "teal");
    string last_backup = get_property(TOOL_INTERNAL + "lastBackupFile");
    if (last_backup == "") {
        warnings = audit_warning(warnings, "No KoLmafiaPrefGuard backup has been recorded yet. Run `KoLmafiaPrefGuard backup`.");
    } else {
        print("Last logical backup: data/" + last_backup
            + " [" + get_property(TOOL_INTERNAL + "lastBackupPhase") + "]", "green");
    }

    if (get_property("valueOfAdventure").to_int() <= 0) {
        warnings = audit_warning(warnings, "valueOfAdventure is missing or non-positive.");
    }
    if (get_property("leprecondoInstalled") == "" || get_property("leprecondoInstalled") == "0,0,0,0") {
        warnings = audit_warning(warnings, "leprecondoInstalled is blank/0,0,0,0. This broke UnderTheSea recently.");
    }
    if (get_property("leprecondoNeedOrder") == "") {
        notices = audit_notice(notices, "leprecondoNeedOrder is blank; this may be fine if KoLmafia has not rediscovered the order yet.");
    }
    if (get_property("skateParkStatus") == "") {
        warnings = audit_warning(warnings, "skateParkStatus is blank, which can confuse Fishy/Lutz routing.");
    }
    if (loop_pref_bool("ascendEnabled", false)) {
        if (loop_pref_string("className", "") == "") warnings = audit_warning(warnings, PREF + "className is blank while automated ascension is enabled.");
        if (loop_pref_string("moonId", "") == "") warnings = audit_warning(warnings, PREF + "moonId is blank while automated ascension is enabled.");
        if (loop_pref_string("gender", "") == "") warnings = audit_warning(warnings, PREF + "gender is blank while automated ascension is enabled.");
    }
    if (loop_pref_bool("leg2BuildPantogram", true) && get_property("_pantogramModifier") != ""
        && !get_property("_pantogramModifier").contains_text("env(underwater)")) {
        warnings = audit_warning(warnings, "Current Pantogram pants do not show the underwater pressure modifier.");
    }
    if (get_property("customCombatScript") == "") {
        notices = audit_notice(notices, "customCombatScript is blank.");
    }
    if (get_property(INTERNAL + "checkpointDate") != today_to_string()) {
        notices = audit_notice(notices, "LoopTheSea checkpoint date is not today.");
    }

    print("Sea map prefs: Dive Bar=" + get_property("mapToTheDiveBarPurchased")
        + "; Madness Reef=" + get_property("mapToMadnessReefPurchased")
        + "; Marinara=" + get_property("mapToTheMarinaraTrenchPurchased")
        + "; Skate Park=" + get_property("mapToTheSkateParkPurchased"), "gray");
    print("Loop checkpoints: leg1=" + get_property(INTERNAL + "leg1Complete")
        + "; undersea=" + get_property(INTERNAL + "underTheSeaComplete")
        + "; leg2=" + get_property(INTERNAL + "leg2Complete"), "gray");

    if (warnings == 0) {
        print("Preference audit passed with " + notices + " notice(s).", "green");
    } else {
        print("Preference audit found " + warnings + " warning(s) and " + notices + " notice(s).", "red");
    }
}

boolean matches_command(string input, string command) {
    matcher m = create_matcher("^\\s*" + command + "(\\s+.*)?$", input.to_lower_case());
    return m.find();
}

string command_argument(string input, string command, string fallback) {
    matcher m = create_matcher("^\\s*" + command + "\\s*(.*)$", input);
    if (!m.find()) return fallback;
    string argument = trim_string(m.group(1));
    if (argument == "") return fallback;
    return argument;
}

void status() {
    initialize_defaults();
    print("KoLmafiaPrefGuard", "teal");
    print("Backups enabled: " + tool_pref_bool("backupEnabled", true), "gray");
    print("Checkpoint backups: " + tool_pref_bool("checkpointBackupsEnabled", true), "gray");
    print("Backup prefix: " + tool_pref_string("backupPrefix", "KoLmafiaPrefGuard_prefs"), "gray");
    if (get_property(TOOL_INTERNAL + "lastBackupFile") == "") {
        print("No recorded backup yet.", "yellow");
    } else {
        print("Last backup: data/" + get_property(TOOL_INTERNAL + "lastBackupFile")
            + " [" + get_property(TOOL_INTERNAL + "lastBackupPhase") + "]", "green");
    }
}

void help() {
    print("Usage: KoLmafiaPrefGuard audit | backup [phase] | checkpoint [phase] | status", "teal");
    print("Manual backup: `KoLmafiaPrefGuard backup before-experiment`.", "teal");
    print("Standalone utility; LoopTheSea does not call it automatically.", "teal");
}

void main(string input) {
    string trimmed = trim_string(input);
    string mode = trimmed.to_lower_case();

    if (mode == "" || mode == "help") {
        help();
        return;
    }
    if (mode == "status") {
        status();
        return;
    }
    if (mode == "audit" || mode == "prefs audit" || mode == "audit prefs") {
        prefs_audit();
        return;
    }
    if (matches_command(trimmed, "backup")) {
        prefs_backup(command_argument(trimmed, "backup", "manual"));
        return;
    }
    if (matches_command(trimmed, "checkpoint")) {
        prefs_checkpoint(command_argument(trimmed, "checkpoint", "manual"));
        return;
    }

    help();
}
