script "LoopTheSea";

/*
Preliminary orchestration for the UnderTheSea loop.

Usage:
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
  LoopTheSea prefs backup
  LoopTheSea prefs audit
  LoopTheSea run
  LoopTheSea fullday
  LoopTheSea reset

This script intentionally owns its preferences. It does not read or write
legacy pLoop properties.
*/

string PREF = "loopTheSea_";
string INTERNAL = "_loopTheSea_";

item PEARL = $item[unblemished pearl];
item CODPIECE = $item[The Eternity Codpiece];
item FISHY_PIPE = $item[fishy pipe];
item WINEGLASS = $item[Drunkula's wineglass];
item GOVERNMENT_PER_DIEM = $item[government per-diem];
item CHRONER_TRIGGER = $item[Chroner trigger];
item CHRONER_CROSS = $item[Chroner cross];
item MR_STORE_2002_CATALOG = $item[2002 Mr. Store Catalog];
item KING_RALPH_LETTER = $item[letter from King Ralph XI];
item PORK_ELF_GOODIES_SACK = $item[pork elf goodies sack];
item PORTABLE_PANTOGRAM = $item[portable pantogram];
item PANTOGRAM_PANTS = $item[pantogram pants];
item SEA_SALT_CRYSTAL = $item[sea salt crystal];
item GLOWING_NEW_AGE_CRYSTAL = $item[glowing New Age crystal];
item FISH_BAZOOKA = $item[fish bazooka];
item BAZOOKA_COZY = $item[bazooka cozy];
item COZY_BAZOOKA = $item[cozy bazooka];
item GOGGLES_OF_LOATHING = $item[Goggles of Loathing];
item AQUAMARINERS_NECKLACE = $item[aquamariner's necklace];
item AQUAMARINERS_RING = $item[aquamariner's ring];
item TEFLON_SWIM_FINS = $item[teflon swim fins];
item FISHY_TEA = $item[cuppa Gill tea];
item FISH_SAUCE = $item[fish sauce];
item SHARK_CARTILAGE = $item[shark cartilage];
item SHAVIN_RAZOR = $item[shavin' razor];
item MERKIN_FASTJUICE = $item[Mer-kin fastjuice];
item DONHO_RECORDING = $item[recording of Donho's Bubbly Ballad];
item DONHO_SINGLE = $item[single of Donho's Bubbly Ballad];
item SALTWATERBED = $item[saltwaterbed];
item SCROLL_MINOR_INVULNERABILITY = $item[scroll of minor invulnerability];
item SCROLL_PROTECTION_BAD_STUFF = $item[scroll of Protection from Bad Stuff];
item PEC_OIL = $item[pec oil];
item PROGRAMMABLE_TURTLE = $item[programmable turtle];
item SMUDGE_STICK = $item[smudge stick];
item OIL_OF_PARRRLAY = $item[Oil of Parrrlay];
item SOFT_GREEN_ECHO_EYEDROP_ANTIDOTE = $item[soft green echo eyedrop antidote];
item DAS_BOOT = $item[Das Boot];
item LIL_BUSINESSMAN_KIT = $item[Li'l Businessman Kit];
item SOURCE_TERMINAL = $item[Source Terminal];
item PILE_OF_WET_DATES = $item[pile of wet dates];
item ANGELBONE_TOTEM = $item[angelbone totem];
item DEVILBONE_CORSET = $item[devilbone corset];
item DEVILBONE_GREAVES = $item[devilbone greaves];
item ANGELBONE_CHOPSTICKS = $item[angelbone chopsticks];
item MONODENT_OF_THE_SEA = $item[Monodent of the Sea];

familiar STOOPER = $familiar[Stooper];
familiar HOBO_MONKEY = $familiar[Hobo Monkey];
familiar URCHIN_URCHIN = $familiar[Urchin Urchin];
familiar GROUPER_GROUPIE = $familiar[Grouper Groupie];

slot [int] CODPIECE_SLOTS = {
    0: $slot[codpiece1],
    1: $slot[codpiece2],
    2: $slot[codpiece3],
    3: $slot[codpiece4],
    4: $slot[codpiece5]
};

slot [int] SNAPSHOT_SLOTS = {
    0: $slot[hat],
    1: $slot[weapon],
    2: $slot[off-hand],
    3: $slot[shirt],
    4: $slot[pants],
    5: $slot[back],
    6: $slot[acc1],
    7: $slot[acc2],
    8: $slot[acc3],
    9: $slot[familiar]
};

location [int] PEARL_LOCATIONS = {
    0: $location[Anemone Mine],
    1: $location[The Dive Bar],
    2: $location[Madness Reef],
    3: $location[The Marinara Trench],
    4: $location[The Briniest Deepests]
};

string [int] PEARL_PROPERTIES = {
    0: "_unblemishedPearlAnemoneMine",
    1: "_unblemishedPearlDiveBar",
    2: "_unblemishedPearlMadnessReef",
    3: "_unblemishedPearlMarinaraTrench",
    4: "_unblemishedPearlTheBriniestDeepests"
};

string [int] PEARL_MAXIMIZERS = {
    0: "spooky res",
    1: "sleaze res",
    2: "stench res",
    3: "hot res",
    4: "cold res"
};

string [int] PEARL_MODIFIERS = {
    0: "Spooky Resistance",
    1: "Sleaze Resistance",
    2: "Stench Resistance",
    3: "Hot Resistance",
    4: "Cold Resistance"
};

string pref_string(string key, string fallback) {
    string value = get_property(PREF + key);
    if (value == "") return fallback;
    return value;
}

boolean pref_bool(string key, boolean fallback) {
    string value = get_property(PREF + key);
    if (value == "") return fallback;
    return value.to_boolean();
}

int pref_int(string key, int fallback) {
    string value = get_property(PREF + key);
    if (value == "") return fallback;
    return value.to_int();
}

string trim_string(string value) {
    matcher m = create_matcher("^\\s*(.*?)\\s*$", value);
    if (m.find()) return m.group(1);
    return value;
}

void set_default(string key, string value) {
    if (get_property(PREF + key) == "") set_property(PREF + key, value);
}

void initialize_defaults() {
    set_default("runInitialGarbo", "false");
    set_default("initialGarboCommand", "garbo ascend");
    set_default("preserveInitialGarboFishy", "true");
    set_default("allowPartialInitialGarboRetry", "false");
    set_default("requireInitialGarboCompleted", "true");
    set_default("ascendEnabled", "false");
    set_default("ascensionType", "2");
    set_default("pathId", "55");
    set_default("className", "");
    set_default("moonId", "");
    set_default("gender", "");
    set_default("astralPet", "");
    set_default("astralDeli", "");
    set_default("permSkills", "NONE");
    set_default("permMinimumBankedKarma", "0");
    set_default("stopAfterAscension", "true");
    set_default("underTheSeaCommand", "UnderTheSea");
    set_default("underTheSeaAutoRecoverFishy", "true");
    set_default("hagnkAllAfterUnderSea", "true");
    set_default("stopAfterLeg1", "true");
    set_default("leg2PearlMode", "FARM");
    set_default("leg2PearlTargetCount", "5");
    set_default("leg2PearlBuffer", "10");
    set_default("leg2PearlResTarget", "18");
    set_default("leg2RunAfterUnderSea", "false");
    set_default("leg2BuildPantogram", "true");
    set_default("leg2RequirePantogramPressure", "true");
    set_default("leg2PantogramStat", "moxie");
    set_default("leg2PantogramElement", "auto");
    set_default("leg2PantogramLeftSacrifice", "glowing New Age crystal");
    set_default("leg2GearMaxPrice", "1000000");
    set_default("leg2GillTeaMaxPrice", "100000");
    set_default("leg2FishyTopupMode", "AUTO");
    set_default("leg2FishSauceMaxPrice", "10000");
    set_default("leg2FishyValueOfAdventure", "0");
    set_default("leg2UseBofaFishy", "true");
    set_default("leg2BofaFishyMaxAttempts", "3");
    set_default("leg2BofaFishyLocation", "Shadow Rift");
    set_default("leg2SharkCartilageMaxPrice", "50000");
    set_default("leg2ShavinRazorMaxPrice", "10000");
    set_default("leg2FastjuiceMaxPrice", "5000");
    set_default("leg2SeaSaltCrystalMaxPrice", "5000");
    set_default("leg2DonhoRecordingMaxPrice", "50000");
    set_default("leg2InstallSaltwaterbed", "false");
    set_default("leg2SealeatherMaxPrice", "5000");
    set_default("leg2ReserveLimitedBuffsForGarbo", "true");
    set_default("leg2PearlOutfitPriority", "PRESSURE_RESISTANCE_MEAT");
    set_default("leg2PressureMaximizer", "meat drop penalty, item drop penalty, initiative penalty, sea");
    set_default("leg2UseGenericMeatBuffs", "false");
    set_default("leg2UseDonho", "true");
    set_default("leg2AllowDonhoItemFallback", "false");
    set_default("leg2UsePressureConsumables", "true");
    set_default("leg2UseResistanceBuffs", "true");
    set_default("leg2MinorInvulnerabilityMaxPrice", "5000");
    set_default("leg2UseResistancePotionRescue", "true");
    set_default("leg2ResistancePotionMaxPrice", "5000");
    set_default("leg2ResistancePotionTotalCap", "15000");
    set_default("leg2ExtraPearlBuffCommands", "");
    set_default("leg2AutoApproveSaltwaterbedReplace", "true");
    set_default("leg2ConsumeBeforePearls", "true");
    set_default("leg2ConsumeMode", "ALWAYS");
    set_default("leg2ConsumeCommand", "CONSUME ALL");
    set_default("leg2AllowBoozeConsume", "true");
    set_default("leg2AllowRiskyConsume", "false");
    set_default("leg2PearlFamiliarMode", "AUTO");
    set_default("leg2HoboMonkeyMoxieFloor", "600");
    set_default("leg2GarboAfterPearls", "true");
    set_default("leg2GarboCommand", "garbo");
    if (get_property(PREF + "leg2GarboCommand") == "garbo ascend") {
        set_property(PREF + "leg2GarboCommand", "garbo");
    }
    set_default("leg2RequireGarboSpendAllTurns", "true");
    set_default("leg2RunBreakfastSweep", "true");
    set_default("leg2BreakfastCommand", "breakfast");
    set_default("leg2RunLateDailySweep", "true");
    set_default("leg2RerunBreakfastAtRollover", "true");
    set_default("leg2UseRemainingChronerItems", "true");
    set_default("leg2Spend2002Credits", "true");
    set_default("leg2MrStore2002Reward", "Spooky VHS Tape");
    set_default("leg2LateDailyCommand", "");
    set_default("leg2LateDailyTurnBurnCommand", "garbo nodiet");
    set_default("leg2RunFinalNightcap", "true");
    set_default("leg2FinalNightcapCommand", "CONSUME NIGHTCAP");
    set_default("leg2RunExpandedOrgansRollover", "true");
    set_default("leg2KeepOrganGearForRollover", "false");
    set_default("leg2UseWetDatesRollover", "false");
    set_default("leg2WetDatesMaxPrice", "40000");
    set_default("leg2PrepareRollover", "true");
    set_default("leg2RolloverAdventureCap", "200");
    set_default("leg2RolloverMaximizer", "adv, 0.001 pvp fights, -tie");
    if (get_property(PREF + "leg2RolloverMaximizer") == "10 adv, 1 pvp fights, -tie") {
        set_property(PREF + "leg2RolloverMaximizer", "adv, 0.001 pvp fights, -tie");
    }
    set_default("leg2OverflowGarboCommand", "garbo nodiet");
    set_default("leg2RolloverCommand", "");
    set_default("postRunPearlMode", "REPORT");
    set_default("postRunFishyOnly", "true");
    set_default("postRunMinimumPearlMpa", "10000");
    set_default("postRunPearlCombatScript", "LoopTheSeaPearl");
    set_default("leg2PearlRecoverHpPercent", "95");
    set_default("leg2PearlRecoverMpTarget", "120");
    set_default("leg2PearlCureBeatenUp", "true");
    set_default("leg2PearlCureTheColors", "true");
    set_default("leg2NegativeEffectCureMaxPrice", "5000");
    set_default("leg2UseExtract", "true");
    set_default("leg2UseSourceTerminalMeat", "false");
    set_default("pearlValueOverride", "0");
    set_default("profitTrackingEnabled", "true");
    set_default("profitTrackingRequired", "false");
    set_default("profitTrackingRecap", "true");
    set_default("profitMarkerPrefix", "lts");
    set_default("prefsBackupEnabled", "true");
    set_default("prefsBackupBeforeRiskyPhases", "true");
    set_default("prefsAuditBeforeFullday", "true");
    set_default("prefsBackupPrefix", "LoopTheSea_prefs");
    set_default("useGovernmentPerDiem", "true");
    set_default("dailyRaffleTickets", "11");
    set_default("protectPorquoiseBeforeUnderSea", "true");
    set_default("leg1PrepareRollover", "true");
    set_default("leg1RolloverAdventureCap", "200");
    set_default("leg1RolloverMaximizer", "adv, 0.001 pvp fights, -tie");
    set_default("leg1OverflowGarboCommand", "garbo nodiet");
    set_default("leg1RolloverCommand", "");
}

boolean afterlife_resume_active() {
    return visit_url("charpane.php").contains_text("Astral Spirit");
}

void reset_checkpoints_for_new_day() {
    string today = today_to_string();
    if (get_property(INTERNAL + "checkpointDate") == today) return;

    if (afterlife_resume_active()) {
        print("Preserving LoopTheSea checkpoints while already in Valhalla.", "yellow");
        return;
    }

    set_property(INTERNAL + "checkpointDate", today);
    set_property(INTERNAL + "initialGarboDone", "false");
    set_property(INTERNAL + "leg1Complete", "false");
    set_property(INTERNAL + "underTheSeaComplete", "false");
    set_property(INTERNAL + "leg2Complete", "false");
    set_property(INTERNAL + "profitTrackingActive", "false");
    set_property(INTERNAL + "raffleTicketsBought", "0");
    set_property(INTERNAL + "leg2PantogramElementChoice", "");
    set_property(INTERNAL + "leg2ConsumeDone", "false");
    set_property(INTERNAL + "porquoiseClosetedBeforeUnderSea", "0");
    set_property(INTERNAL + "leg2PearlFamiliar", "");
    set_property(INTERNAL + "leg2BreakfastDone", "false");
    set_property(INTERNAL + "leg2LateDailyDone", "false");
    set_property(INTERNAL + "leg2GarboDone", "false");
    set_property(INTERNAL + "leg2NightcapDone", "false");
    set_property(INTERNAL + "leg2ExpandedOrgansDone", "false");
    set_property(INTERNAL + "leg2RolloverHookDone", "false");
    set_property(INTERNAL + "leg2RolloverDone", "false");
    set_property(INTERNAL + "leg2BofaFishyAttempts", "0");
    set_property(INTERNAL + "leg2PearlBudgetFloor", "0");
    set_property(INTERNAL + "leg1RolloverHookDone", "false");
    set_property(INTERNAL + "leg1RolloverDone", "false");
    set_property(INTERNAL + "enteredValhalla", "false");
    set_property(INTERNAL + "ascensionComplete", "false");
    set_property(INTERNAL + "ascensionStartedFrom", "");
    set_property(INTERNAL + "ascensionNumber", "");
    set_property(INTERNAL + "afterlifeDeliBoughtFor", "");
    set_property(INTERNAL + "afterlifeArmoryBoughtFor", "");
}

void prepare_loop_state() {
    initialize_defaults();
    reset_checkpoints_for_new_day();
    if (get_property(INTERNAL + "leg2Complete") == "") {
        set_property(INTERNAL + "leg2Complete", "false");
    }
    if (get_property(INTERNAL + "leg2LateDailyDone") == "") {
        set_property(INTERNAL + "leg2LateDailyDone",
            get_property(INTERNAL + "leg2Complete").to_boolean() ? "true" : "false");
    }
    if (get_property(INTERNAL + "leg1RolloverDone") == "") {
        set_property(INTERNAL + "leg1RolloverDone", "false");
    }
    if (get_property(INTERNAL + "leg1RolloverHookDone") == "") {
        set_property(INTERNAL + "leg1RolloverHookDone", "false");
    }
    if (get_property(INTERNAL + "leg2BofaFishyAttempts") == "") {
        set_property(INTERNAL + "leg2BofaFishyAttempts", "0");
    }
    if (get_property(INTERNAL + "leg2PearlBudgetFloor") == "") {
        set_property(INTERNAL + "leg2PearlBudgetFloor", "0");
    }
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
        105: "prefsBackupEnabled",
        106: "prefsBackupBeforeRiskyPhases",
        107: "prefsAuditBeforeFullday",
        108: "prefsBackupPrefix",
        109: "useGovernmentPerDiem",
        110: "dailyRaffleTickets",
        111: "protectPorquoiseBeforeUnderSea",
        112: "leg1PrepareRollover",
        113: "leg1RolloverAdventureCap",
        114: "leg1RolloverMaximizer",
        115: "leg1OverflowGarboCommand",
        116: "leg1RolloverCommand"
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
    buffer snapshot;
    buffer restore;
    string stamp = now_to_string("YYYYMMddHHmmss");
    string safe_phase = backup_safe_fragment(phase);
    string prefix = backup_safe_fragment(pref_string("prefsBackupPrefix", "LoopTheSea_prefs"));
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

    restore.append("# LoopTheSea preference restore commands\n");
    restore.append("# Snapshot: " + filename + "\n");
    restore.append("# Review before running; do not blindly restore stale daily state.\n");

    append_loop_prefs(snapshot, restore);
    append_internal_prefs(snapshot, restore);
    append_undertheseaprep_prefs(snapshot, restore);
    append_critical_mafia_prefs(snapshot, restore);

    if (!buffer_to_file(snapshot, filename)) abort("Unable to write preference backup " + filename + ".");
    if (!buffer_to_file(restore, restore_filename)) abort("Unable to write preference restore file " + restore_filename + ".");
    buffer_to_file(snapshot, latest_filename);
    buffer_to_file(restore, latest_restore_filename);

    set_property(INTERNAL + "lastPrefsBackupFile", filename);
    set_property(INTERNAL + "lastPrefsBackupRestoreFile", restore_filename);
    set_property(INTERNAL + "lastPrefsBackupPhase", phase);
    set_property(INTERNAL + "lastPrefsBackupStamp", stamp);

    print("Preference backup written: data/" + filename, "green");
    print("Reviewable restore commands: data/" + restore_filename, "green");
    return filename;
}

void prefs_checkpoint(string phase) {
    if (!pref_bool("prefsBackupEnabled", true)) return;
    if (!pref_bool("prefsBackupBeforeRiskyPhases", true)) return;
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
    prepare_loop_state();
    int warnings = 0;
    int notices = 0;

    print("LoopTheSea preference audit", "teal");
    string last_backup = get_property(INTERNAL + "lastPrefsBackupFile");
    if (last_backup == "") {
        warnings = audit_warning(warnings, "No LoopTheSea preference backup has been recorded yet. Run `LoopTheSea prefs backup`.");
    } else {
        print("Last logical backup: data/" + last_backup
            + " [" + get_property(INTERNAL + "lastPrefsBackupPhase") + "]", "green");
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
    if (pref_bool("ascendEnabled", false)) {
        if (pref_string("className", "") == "") warnings = audit_warning(warnings, PREF + "className is blank while automated ascension is enabled.");
        if (pref_string("moonId", "") == "") warnings = audit_warning(warnings, PREF + "moonId is blank while automated ascension is enabled.");
        if (pref_string("gender", "") == "") warnings = audit_warning(warnings, PREF + "gender is blank while automated ascension is enabled.");
    }
    if (pref_bool("leg2BuildPantogram", true) && get_property("_pantogramModifier") != ""
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

void run_cli(string command) {
    print("Running: " + command, "teal");
    if (!cli_execute(command)) abort("Command failed: " + command);
}

string profit_marker_name(string marker) {
    return pref_string("profitMarkerPrefix", "lts") + "_" + marker;
}

boolean ptrack_event_logged_today(string event) {
    if (get_property("prusias_profitTracking_date") != today_to_string()) return false;

    foreach i, logged in get_property("thoth19_event_list").split_string(",") {
        if (logged == event) return true;
    }
    return false;
}

void profit_marker(string marker) {
    if (!pref_bool("profitTrackingEnabled", true)) return;

    string event = profit_marker_name(marker);
    if (ptrack_event_logged_today(event)) {
        print("Profit marker already logged: " + event, "gray");
        return;
    }

    print("Profit marker: " + event, "fuchsia");
    if (!cli_execute("ptrack add " + event)) {
        string message = "Unable to log PTrack marker: " + event + ".";
        if (pref_bool("profitTrackingRequired", false)) abort(message);
        print(message, "red");
    }
}

boolean have_item_or_equipped(item it) {
    return available_amount(it) > 0 || have_equipped(it);
}

item [slot] equipment_snapshot() {
    item [slot] snapshot;
    foreach i, sl in SNAPSHOT_SLOTS {
        snapshot[sl] = equipped_item(sl);
    }
    return snapshot;
}

void restore_equipment(item [slot] snapshot) {
    foreach i, sl in SNAPSHOT_SLOTS {
        item it = snapshot[sl];
        if (equipped_item(sl) == it) continue;
        if (!equip(sl, it)) {
            abort("Unable to restore " + it + " in " + sl + ".");
        }
    }
}

void take_from_closet_if_needed(item it, int quantity) {
    if (item_amount(it) >= quantity) return;
    int needed = quantity - item_amount(it);
    int closeted = closet_amount(it);
    if (closeted <= 0) return;

    int to_take = min(needed, closeted);
    run_cli("closet take " + to_take + " " + it);
}

boolean have_accessible_component(item it) {
    return item_amount(it) > 0 || closet_amount(it) > 0 || have_equipped(it);
}

int component_price_if_needed(item it) {
    if (have_accessible_component(it)) return 0;
    return mall_price(it);
}

string cozy_bazooka_diagnostic(int max_price) {
    int cozy_price = mall_price(COZY_BAZOOKA);
    int fish_price = component_price_if_needed(FISH_BAZOOKA);
    int cozy_part_price = component_price_if_needed(BAZOOKA_COZY);
    int component_total = fish_price + cozy_part_price;
    return "Have: cozy=" + have_item_or_equipped(COZY_BAZOOKA)
        + ", fish bazooka=" + have_accessible_component(FISH_BAZOOKA)
        + ", bazooka cozy=" + have_accessible_component(BAZOOKA_COZY)
        + ". Mall: cozy bazooka=" + cozy_price
        + "; fish bazooka=" + fish_price
        + "; bazooka cozy=" + cozy_part_price
        + "; component total=" + component_total
        + "; cap=" + max_price + ".";
}

string cozy_bazooka_status() {
    int cap = pref_int("leg2GearMaxPrice", 1000000);
    if (have_item_or_equipped(COZY_BAZOOKA)) {
        return "ready; have cozy bazooka. " + cozy_bazooka_diagnostic(cap);
    }
    if (have_accessible_component(FISH_BAZOOKA) && have_accessible_component(BAZOOKA_COZY)) {
        return "assemble-ready; have fish bazooka + bazooka cozy. "
            + cozy_bazooka_diagnostic(cap);
    }

    int cozy_price = mall_price(COZY_BAZOOKA);
    if (can_interact() && cozy_price > 0 && cozy_price <= cap) {
        return "buy-ready; cozy bazooka is buyable. " + cozy_bazooka_diagnostic(cap);
    }

    int fish_price = component_price_if_needed(FISH_BAZOOKA);
    int cozy_part_price = component_price_if_needed(BAZOOKA_COZY);
    if (can_interact()
        && fish_price >= 0 && cozy_part_price >= 0
        && (fish_price + cozy_part_price) > 0
        && fish_price + cozy_part_price <= cap
        && (have_accessible_component(FISH_BAZOOKA) || fish_price > 0)
        && (have_accessible_component(BAZOOKA_COZY) || cozy_part_price > 0)) {
        return "parts-buy-ready; components are buyable. " + cozy_bazooka_diagnostic(cap);
    }

    return "blocked. " + cozy_bazooka_diagnostic(cap);
}

boolean assemble_cozy_bazooka_from_parts() {
    if (have_item_or_equipped(COZY_BAZOOKA)) return true;

    take_from_closet_if_needed(FISH_BAZOOKA, 1);
    take_from_closet_if_needed(BAZOOKA_COZY, 1);
    if ((item_amount(FISH_BAZOOKA) <= 0 && !have_equipped(FISH_BAZOOKA))
        || item_amount(BAZOOKA_COZY) <= 0) {
        return false;
    }

    print("Assembling cozy bazooka from fish bazooka and bazooka cozy.", "teal");
    if (create(1, COZY_BAZOOKA) && have_item_or_equipped(COZY_BAZOOKA)) return true;
    if (use(1, BAZOOKA_COZY) && have_item_or_equipped(COZY_BAZOOKA)) return true;
    return have_item_or_equipped(COZY_BAZOOKA);
}

boolean ensure_cozy_bazooka(int max_price, string context) {
    if (item_amount(COZY_BAZOOKA) > 0 || have_equipped(COZY_BAZOOKA)) return true;

    take_from_closet_if_needed(COZY_BAZOOKA, 1);
    if (item_amount(COZY_BAZOOKA) > 0 || have_equipped(COZY_BAZOOKA)) return true;

    if (assemble_cozy_bazooka_from_parts()) return true;

    if (!can_interact()) return false;

    int cozy_price = mall_price(COZY_BAZOOKA);
    if (cozy_price > 0 && cozy_price <= max_price) {
        print("Buying cozy bazooka for Leg2 pressure gear.", "teal");
        buy(1, COZY_BAZOOKA, max_price);
        take_from_closet_if_needed(COZY_BAZOOKA, 1);
        if (item_amount(COZY_BAZOOKA) > 0 || have_equipped(COZY_BAZOOKA)) return true;
    }

    int fish_price = component_price_if_needed(FISH_BAZOOKA);
    int cozy_part_price = component_price_if_needed(BAZOOKA_COZY);
    int component_total = fish_price + cozy_part_price;
    boolean fish_accessible = have_accessible_component(FISH_BAZOOKA) || fish_price > 0;
    boolean cozy_part_accessible = have_accessible_component(BAZOOKA_COZY) || cozy_part_price > 0;
    if (fish_accessible && cozy_part_accessible && component_total > 0 && component_total <= max_price) {
        if (!have_accessible_component(FISH_BAZOOKA)) {
            buy(1, FISH_BAZOOKA, fish_price);
        }
        if (!have_accessible_component(BAZOOKA_COZY)) {
            buy(1, BAZOOKA_COZY, cozy_part_price);
        }
        if (assemble_cozy_bazooka_from_parts()) return true;
    }

    return false;
}

void require_accessible_item(item it, string context) {
    if (!have_item_or_equipped(it)) {
        abort(context + ": missing " + it + ".");
    }
}

void ensure_inventory_item(item it, int quantity, int max_price, string context) {
    if (item_amount(it) >= quantity) return;

    take_from_closet_if_needed(it, quantity);
    if (item_amount(it) >= quantity) return;

    if (it == COZY_BAZOOKA && quantity <= 1) {
        if (ensure_cozy_bazooka(max_price, context)) return;
        abort(context + ": cannot acquire " + COZY_BAZOOKA + ". "
            + cozy_bazooka_diagnostic(max_price));
    }

    int needed = quantity - item_amount(it);
    if (!can_interact()) {
        abort(context + ": need " + quantity + " " + it + ", but only have "
            + item_amount(it) + " and cannot use the mall.");
    }

    int price = mall_price(it);
    if (price <= 0 || price > max_price) {
        abort(context + ": " + it + " mall price is " + price
            + " Meat; configured cap is " + max_price + ".");
    }

    int bought = buy(needed, it, max_price);
    if (bought <= 0 && item_amount(it) < quantity) {
        abort(context + ": failed to buy " + needed + " " + it + ".");
    }
    if (item_amount(it) < quantity) {
        abort(context + ": need " + quantity + " " + it + ", but only have "
            + item_amount(it) + " after acquisition.");
    }
}

void equip_required(slot sl, item it, string context) {
    require_accessible_item(it, context);
    if (equipped_item(sl) != it && !equip(sl, it)) {
        abort(context + ": unable to equip " + it + " in " + sl + ".");
    }
    if (equipped_item(sl) != it) {
        abort(context + ": " + it + " is not equipped in " + sl + ".");
    }
}

void ensure_accessible_item(item it, int max_price, string context) {
    if (have_item_or_equipped(it)) return;
    ensure_inventory_item(it, 1, max_price, context);
}

item porquoise_item() {
    item it = "porquoise".to_item();
    if (it == $item[none]) abort("KoLmafia does not recognize porquoise.");
    return it;
}

boolean leg2_pantogram_available() {
    return have_item_or_equipped(PANTOGRAM_PANTS)
        || have_item_or_equipped(PORTABLE_PANTOGRAM);
}

boolean leg2_pantogram_planned() {
    return pref_bool("leg2BuildPantogram", true) && leg2_pantogram_available();
}

boolean should_protect_porquoise_before_undersea() {
    return pref_bool("protectPorquoiseBeforeUnderSea", true)
        && pref_bool("leg2BuildPantogram", true)
        && !have_item_or_equipped(PANTOGRAM_PANTS)
        && have_item_or_equipped(PORTABLE_PANTOGRAM);
}

void profit_recap() {
    if (!pref_bool("profitTrackingEnabled", true)) return;
    if (!pref_bool("profitTrackingRecap", true)) return;
    if (!cli_execute("ptrack recap")) {
        string message = "Unable to run PTrack recap.";
        if (pref_bool("profitTrackingRequired", false)) abort(message);
        print(message, "red");
    }
}

void begin_profit_tracking_scope() {
    set_property(INTERNAL + "profitTrackingActive", "true");
}

void end_profit_tracking_scope() {
    set_property(INTERNAL + "profitTrackingActive", "false");
}

void use_government_per_diem() {
    if (!pref_bool("useGovernmentPerDiem", true)) return;
    if (get_property("_governmentPerDiemUsed").to_boolean()) return;

    if (item_amount(GOVERNMENT_PER_DIEM) == 0 && available_amount(GOVERNMENT_PER_DIEM) > 0) {
        retrieve_item(1, GOVERNMENT_PER_DIEM);
    }
    if (item_amount(GOVERNMENT_PER_DIEM) == 0) {
        print("No " + GOVERNMENT_PER_DIEM + " available for LoopTheSea breakfast.", "yellow");
        return;
    }

    print("Using " + GOVERNMENT_PER_DIEM + " during LoopTheSea breakfast.", "teal");
    if (!use(1, GOVERNMENT_PER_DIEM)) {
        abort("Failed to use " + GOVERNMENT_PER_DIEM + ".");
    }
}

boolean raffle_accessible() {
    return can_interact()
        && my_path() != $path[Zombie Slayer];
}

int raffle_tickets_today() {
    string page = visit_url("raffle.php");
    if (page.contains_text("You haven't bought any tickets for today's raffle.")) return 0;

    string [int] patterns = {
        0: "You have purchased ([0-9,]+) tickets? for today's raffle",
        1: "You have ([0-9,]+) tickets? for today's raffle",
        2: "You currently have ([0-9,]+) tickets? for today's raffle",
        3: "You have ([0-9,]+) tickets? in the raffle",
        4: "You currently have ([0-9,]+) tickets? in the raffle",
        5: "bought ([0-9,]+) tickets? for today's raffle"
    };
    foreach i, pattern in patterns {
        matcher tickets = create_matcher(pattern, page);
        if (tickets.find()) return replace_string(tickets.group(1), ",", "").to_int();
    }
    return 0;
}

int detected_raffle_tickets_today() {
    return max(raffle_tickets_today(), get_property(INTERNAL + "raffleTicketsBought").to_int());
}

void buy_daily_raffle_tickets() {
    int target = pref_int("dailyRaffleTickets", 11);
    if (target <= 0) return;
    if (!raffle_accessible()) {
        print("Raffle House is not accessible; skipping LoopTheSea raffle tickets.", "yellow");
        return;
    }

    int current = detected_raffle_tickets_today();
    int needed = max(0, target - current);
    if (needed <= 0) {
        print("Already have " + current + " raffle ticket(s) today; target is " + target + ".", "gray");
        set_property(INTERNAL + "raffleTicketsBought", current);
        return;
    }

    int before_tracked = get_property(INTERNAL + "raffleTicketsBought").to_int();
    string source = can_interact() ? "inventory" : "storage";
    run_cli("raffle " + needed + " " + source);
    int after = max(raffle_tickets_today(), before_tracked + needed);
    set_property(INTERNAL + "raffleTicketsBought", after);
    if (after < target) {
        abort("Raffle ticket purchase ended at " + after + " ticket(s); expected at least " + target + ".");
    }
    print("Raffle ticket purchase verified at " + after + " ticket(s).", "teal");
}

void loop_breakfast() {
    print("Running safe early-Leg1 daily routing.", "teal");
    use_government_per_diem();
    buy_daily_raffle_tickets();
}

void run_leg2_breakfast_sweep() {
    if (get_property(INTERNAL + "leg2BreakfastDone").to_boolean()) {
        print("Leg2 aftercore breakfast sweep is already complete.", "green");
        return;
    }
    if (!pref_bool("leg2RunBreakfastSweep", true)) {
        print("Skipping Leg2 aftercore breakfast sweep by " + PREF
            + "leg2RunBreakfastSweep=false.", "yellow");
        set_property(INTERNAL + "leg2BreakfastDone", "true");
        return;
    }
    if (get_property("breakfastCompleted").to_boolean()) {
        print("KoLmafia breakfast is already complete in Leg2 aftercore.", "green");
        set_property(INTERNAL + "leg2BreakfastDone", "true");
        return;
    }

    string command = pref_string("leg2BreakfastCommand", "breakfast");
    if (command == "") abort(PREF + "leg2BreakfastCommand is blank.");

    int adventures_before = my_adventures();
    int pvp_before = pvp_attacks_left();
    print("Collecting reset daily resources before Leg2 Garbo.", "teal");
    run_cli(command);
    print("Leg2 breakfast sweep gained " + (my_adventures() - adventures_before)
        + " adventure(s) and " + (pvp_attacks_left() - pvp_before)
        + " PvP fight(s).", "green");
    set_property(INTERNAL + "leg2BreakfastDone", "true");
}

void use_leg2_chroner_item(item it, string used_property) {
    if (get_property(used_property).to_boolean()) return;
    if (item_amount(it) == 0 && available_amount(it) > 0) retrieve_item(1, it);
    if (item_amount(it) == 0) {
        print("Leg2 rollover Chroner cleanup skipped; " + it + " is not available.", "yellow");
        return;
    }

    print("Using remaining Leg2 daily item: " + it + ".", "teal");
    if (!use(1, it)) abort("Failed to use " + it + " during the Leg2 rollover sweep.");
    if (!get_property(used_property).to_boolean()) {
        abort(it + " use did not set " + used_property + ".");
    }
}

void use_remaining_leg2_chroner_items() {
    if (!pref_bool("leg2UseRemainingChronerItems", true)) return;

    // The cross only becomes usable after the trigger, so one breakfast pass can miss it.
    use_leg2_chroner_item(CHRONER_TRIGGER, "_chronerTriggerUsed");
    use_leg2_chroner_item(CHRONER_CROSS, "_chronerCrossUsed");
}

void spend_leg2_mr_store_2002_credits() {
    if (!pref_bool("leg2Spend2002Credits", true)) return;

    if (!get_property("_2002MrStoreCreditsCollected").to_boolean()
        && available_amount(MR_STORE_2002_CATALOG) > 0) {
        if (item_amount(MR_STORE_2002_CATALOG) == 0) retrieve_item(1, MR_STORE_2002_CATALOG);
        if (item_amount(MR_STORE_2002_CATALOG) > 0) {
            print("Collecting remaining Leg2 Mr. Store 2002 credits.", "teal");
            if (!use(1, MR_STORE_2002_CATALOG)) {
                abort("Failed to collect Leg2 Mr. Store 2002 credits.");
            }
        }
    }

    int credits = get_property("availableMrStore2002Credits").to_int();
    if (credits <= 0) return;

    item reward = pref_string("leg2MrStore2002Reward", "Spooky VHS Tape").to_item();
    if (reward == $item[none]) {
        abort("Invalid " + PREF + "leg2MrStore2002Reward: "
            + pref_string("leg2MrStore2002Reward", "Spooky VHS Tape") + ".");
    }

    int reward_before = item_amount(reward);
    print("Spending " + credits + " remaining Leg2 Mr. Store 2002 credit(s) on "
        + reward + ".", "teal");
    buy($coinmaster[Mr. Store 2002], credits, reward);
    int remaining = get_property("availableMrStore2002Credits").to_int();
    if (remaining != 0) {
        abort("Leg2 Mr. Store 2002 purchase left " + remaining + "/" + credits
            + " credit(s) unspent.");
    }
    print("Leg2 Mr. Store 2002 purchase acquired "
        + (item_amount(reward) - reward_before) + " " + reward + ".", "green");
}

void burn_leg2_late_daily_adventures() {
    if (!pref_bool("leg2RequireGarboSpendAllTurns", true) || my_adventures() <= 0) return;
    if (have_effect($effect[A Date With Tomorrow]) > 0) {
        abort("Refusing the late Leg2 daily turn burn because A Date With Tomorrow is already active.");
    }

    string command = pref_string("leg2LateDailyTurnBurnCommand", "garbo nodiet");
    if (command == "") {
        abort("The late Leg2 daily sweep generated " + my_adventures()
            + " adventure(s), but " + PREF + "leg2LateDailyTurnBurnCommand is blank.");
    }
    print("Burning " + my_adventures()
        + " adventure(s) generated by the late Leg2 daily sweep with " + command + ".", "teal");
    run_cli(command + " turns=" + my_adventures());
    if (my_adventures() > 0) {
        abort("Late Leg2 daily turn burn left " + my_adventures() + " adventure(s).");
    }
}

void run_leg2_late_daily_sweep() {
    if (!get_property(INTERNAL + "leg2LateDailyDone").to_boolean()) {
        if (!pref_bool("leg2RunLateDailySweep", true)) {
            print("Skipping the late Leg2 daily sweep by "
                + PREF + "leg2RunLateDailySweep=false.", "yellow");
            set_property(INTERNAL + "leg2LateDailyDone", "true");
        } else {
            int adventures_before = my_adventures();
            int pvp_before = pvp_attacks_left();
            print("Collecting once-daily and breakfast resources before Leg2 rollover.", "teal");

            if (pref_bool("leg2RerunBreakfastAtRollover", true)) {
                string command = pref_string("leg2BreakfastCommand", "breakfast");
                if (command == "") abort(PREF + "leg2BreakfastCommand is blank.");
                set_property("breakfastCompleted", "false");
                run_cli(command);
            }

            use_government_per_diem();
            use_remaining_leg2_chroner_items();
            spend_leg2_mr_store_2002_credits();

            string extra_command = pref_string("leg2LateDailyCommand", "");
            if (extra_command != "") {
                print("Running configured late Leg2 daily command.", "teal");
                run_cli(extra_command);
            }

            print("Late Leg2 daily sweep gained " + (my_adventures() - adventures_before)
                + " adventure(s) and " + (pvp_attacks_left() - pvp_before)
                + " PvP fight(s).", "green");
            set_property(INTERNAL + "leg2LateDailyDone", "true");
        }
    } else {
        print("Late Leg2 daily sweep is already complete.", "green");
    }

    burn_leg2_late_daily_adventures();
}

string path_name() {
    return "" + my_path();
}

boolean in_undersea_path() {
    return path_name() == "11,037 Leagues Under the Sea";
}

boolean king_liberated() {
    return get_property("kingLiberated").to_boolean();
}

boolean valhalla_ready() {
    return visit_url("charpane.php").contains_text("Astral Spirit");
}

int mounted_pearl_count() {
    int result = 0;
    foreach i, sl in CODPIECE_SLOTS {
        if (equipped_item(sl) == PEARL) result = result + 1;
    }
    return result;
}

int held_pearl_count() {
    return item_amount(PEARL) + closet_amount(PEARL);
}

boolean pearl_zone_complete(int zone_index) {
    return get_property(PEARL_PROPERTIES[zone_index]).to_boolean();
}

float pearl_zone_progress(int zone_index) {
    return get_property(PEARL_PROPERTIES[zone_index] + "Progress").to_float();
}

int projected_pearl_combats_for_zone(int zone_index) {
    if (pearl_zone_complete(zone_index)) return 0;

    float progress = pearl_zone_progress(zone_index);
    int combats = 0;
    while (progress < 100.0) {
        progress = progress + 10.0;
        combats = combats + 1;
    }
    return combats;
}

int projected_unfinished_pearl_combats() {
    int result = 0;
    foreach zone_index, loc in PEARL_LOCATIONS {
        result = result + projected_pearl_combats_for_zone(zone_index);
    }
    return result;
}

int unfinished_pearl_zone_count() {
    int result = 0;
    foreach zone_index, loc in PEARL_LOCATIONS {
        if (!pearl_zone_complete(zone_index)) result = result + 1;
    }
    return result;
}

int effective_pearl_value() {
    int override = pref_int("pearlValueOverride", 0);
    if (override > 0) return override;
    return mall_price(PEARL);
}

float projected_pearl_mpa() {
    int combats = projected_unfinished_pearl_combats();
    int zones = unfinished_pearl_zone_count();
    if (combats <= 0 || zones <= 0) return 0.0;
    return (effective_pearl_value() * zones * 1.0) / combats;
}

boolean lutz_fishy_available() {
    return get_property("skateParkStatus") == "ice"
        && !get_property("_skateBuff1").to_boolean();
}

int leg2_bofa_fishy_attempts_used() {
    return get_property(INTERNAL + "leg2BofaFishyAttempts").to_int();
}

int leg2_bofa_fishy_attempts_remaining() {
    if (!pref_bool("leg2UseBofaFishy", true)) return 0;
    return max(0, pref_int("leg2BofaFishyMaxAttempts", 3) - leg2_bofa_fishy_attempts_used());
}

location leg2_bofa_fishy_location() {
    return to_location(pref_string("leg2BofaFishyLocation", "Shadow Rift"));
}

boolean leg2_bofa_fishy_available() {
    if (!pref_bool("leg2UseBofaFishy", true)) return false;
    if (my_class() != $class[Seal Clubber]) return false;
    if (leg2_bofa_fishy_attempts_remaining() <= 0) return false;
    if (!have_skill($skill[Just the Facts])) return false;
    if (!have_item_or_equipped(MONODENT_OF_THE_SEA)) return false;

    location loc = leg2_bofa_fishy_location();
    if (loc == $location[none]) return false;
    return can_adventure(loc);
}

int leg2_bofa_fishy_projected_turns() {
    if (!leg2_bofa_fishy_available()) return 0;
    return leg2_bofa_fishy_attempts_remaining() * 10;
}

int cheap_fishy_turns_available() {
    int turns = have_effect($effect[Fishy]);
    if (available_amount(FISHY_PIPE) > 0 && !get_property("_fishyPipeUsed").to_boolean()) {
        turns = turns + 10;
    }
    if (lutz_fishy_available()) turns = turns + 30;
    return turns;
}

int leg2_fishy_value_of_adventure() {
    int configured = pref_int("leg2FishyValueOfAdventure", 0);
    if (configured > 0) return configured;
    return max(0, get_property("valueOfAdventure").to_int());
}

boolean initial_garbo_completed() {
    if (get_property(INTERNAL + "initialGarboDone").to_boolean()) return true;
    string completed = get_property("_garboCompleted").to_lower_case();
    return completed.contains_text("garbo") && completed.contains_text("ascend");
}

boolean initial_garbo_activity_today() {
    if (get_property("garboResultsDate") == today_to_string()) return true;
    if (get_property("_chocolatesUsed").to_int() > 0) return true;
    if (get_property("_borrowedTimeUsed").to_boolean()) return true;
    if (get_property("_distentionPillUsed").to_boolean()) return true;
    if (get_property("_milkOfMagnesiumUsed").to_boolean()) return true;
    return false;
}

string initial_garbo_activity_summary() {
    string summary = "garboResultsDate=" + get_property("garboResultsDate")
        + "; garboResultsTurns=" + get_property("garboResultsTurns")
        + "; _garboCompleted=" + get_property("_garboCompleted")
        + "; _chocolatesUsed=" + get_property("_chocolatesUsed")
        + "; _borrowedTimeUsed=" + get_property("_borrowedTimeUsed")
        + "; _distentionPillUsed=" + get_property("_distentionPillUsed")
        + "; _milkOfMagnesiumUsed=" + get_property("_milkOfMagnesiumUsed");
    return summary;
}

void require_clean_initial_garbo_launch() {
    if (initial_garbo_completed()) return;
    if (!initial_garbo_activity_today()) return;
    if (pref_bool("allowPartialInitialGarboRetry", false)) {
        print("Initial Garbo retry guard is overridden by "
            + PREF + "allowPartialInitialGarboRetry=true. "
            + initial_garbo_activity_summary(), "yellow");
        return;
    }

    abort("Refusing to start initial garbo ascend because Garbo appears to have "
        + "already touched today's setup or diet, but completion is not recorded. "
        + initial_garbo_activity_summary()
        + ". This is usually a partial failed Garbo run; run `LoopTheSea status` "
        + "and recover manually, or set " + PREF
        + "allowPartialInitialGarboRetry=true if you intentionally want to retry.");
}

string current_phase() {
    if (in_undersea_path() && !king_liberated()) return "inside UnderTheSea";
    if (in_undersea_path() && king_liberated() && can_interact()) return "post-UnderTheSea aftercore";
    if (can_interact() && get_property(INTERNAL + "underTheSeaComplete").to_boolean()) {
        return "post-UnderTheSea aftercore";
    }
    if (king_liberated() && get_property(INTERNAL + "leg1Complete").to_boolean()) {
        return "pre-Valhalla checkpoint";
    }
    if (king_liberated()) return "Leg1 aftercore";
    return "unknown";
}

void print_pearl_snapshot() {
    print("Held pearls: " + held_pearl_count() + "; mounted pearls: " + mounted_pearl_count());
    foreach zone_index, loc in PEARL_LOCATIONS {
        string state = pearl_zone_complete(zone_index)
            ? "complete"
            : pearl_zone_progress(zone_index) + "% progress; projected "
                + projected_pearl_combats_for_zone(zone_index) + " combat(s)";
        print("- " + loc + ": " + state);
    }
    print("Projected unfinished pearl combats: " + projected_unfinished_pearl_combats(), "teal");
}

void print_postrun_pearl_report() {
    int pearl_value = effective_pearl_value();
    int min_mpa = pref_int("postRunMinimumPearlMpa", 10000);
    string pearl_mode = pref_string("leg2PearlMode", pref_string("postRunPearlMode", "REPORT"));

    print("Post-run pearl report", "blue");
    print_pearl_snapshot();
    print("Fishy turns now: " + have_effect($effect[Fishy]));
    print("- fishy pipe available: " + (available_amount(FISHY_PIPE) > 0)
        + "; used today: " + get_property("_fishyPipeUsed"));
    print("- Lutz Fishy available: " + lutz_fishy_available()
        + "; _skateBuff1: " + get_property("_skateBuff1")
        + "; skateParkStatus: " + get_property("skateParkStatus"));
    print("Cheap/retained Fishy projection: " + cheap_fishy_turns_available() + " turn(s)");
    print("Leg2 paid Fishy top-up: mode=" + pref_string("leg2FishyTopupMode", "AUTO")
        + "; fish sauce cap=" + pref_int("leg2FishSauceMaxPrice", 10000)
        + "; Gill tea cap=" + pref_int("leg2GillTeaMaxPrice", 100000)
        + "; adventure value override=" + pref_int("leg2FishyValueOfAdventure", 0)
        + "; resolved adventure value=" + leg2_fishy_value_of_adventure());
    print("Leg2 BOFA Fishy: enabled=" + pref_bool("leg2UseBofaFishy", true)
        + "; class=" + my_class()
        + "; available=" + leg2_bofa_fishy_available()
        + "; location=\"" + pref_string("leg2BofaFishyLocation", "Shadow Rift") + "\""
        + "; attempts=" + leg2_bofa_fishy_attempts_used()
        + "/" + pref_int("leg2BofaFishyMaxAttempts", 3)
        + "; projected=" + leg2_bofa_fishy_projected_turns() + " turn(s)");
    print("Leg2 pearl mode: " + pearl_mode
        + "; target pearls after UnderTheSea: " + pref_int("leg2PearlTargetCount", 5)
        + " (five Leg1 + five Leg2 = ten total for the day)");
    print("Leg2 pearl priority: pearls first; outfit priority "
        + pref_string("leg2PearlOutfitPriority", "PRESSURE_RESISTANCE_MEAT") + ".");
    print("Pressure maximizer base: " + pref_string("leg2PressureMaximizer",
        "meat drop penalty, item drop penalty, initiative penalty, sea"));
    print("Leg2 cozy bazooka: " + cozy_bazooka_status());
    print("Reserve Garbo-limited buffs: " + pref_bool("leg2ReserveLimitedBuffsForGarbo", true)
        + "; generic +Meat buffs for Leg2 pearls: " + pref_bool("leg2UseGenericMeatBuffs", false));
    print("Leg2 Donho: use=" + pref_bool("leg2UseDonho", true)
        + "; item fallback=" + pref_bool("leg2AllowDonhoItemFallback", false));
    print("Leg2 pressure upkeep: consumables=" + pref_bool("leg2UsePressureConsumables", true)
        + "; fastjuice cap=" + pref_int("leg2FastjuiceMaxPrice", 5000)
        + "; sea salt cap=" + pref_int("leg2SeaSaltCrystalMaxPrice", 5000)
        + "; shark cartilage cap=" + pref_int("leg2SharkCartilageMaxPrice", 50000)
        + "; shavin' razor cap=" + pref_int("leg2ShavinRazorMaxPrice", 10000));
    print("Leg2 resistance buffs: use=" + pref_bool("leg2UseResistanceBuffs", true)
        + "; minor invulnerability cap=" + pref_int("leg2MinorInvulnerabilityMaxPrice", 5000)
        + "; potion rescue=" + pref_bool("leg2UseResistancePotionRescue", true)
        + "; potion cap=" + pref_int("leg2ResistancePotionMaxPrice", 5000)
        + "; potion total cap=" + pref_int("leg2ResistancePotionTotalCap", 15000)
        + "; extra commands=\"" + pref_string("leg2ExtraPearlBuffCommands", "") + "\"");
    print("Leg2 pre-pearl consume: enabled=" + pref_bool("leg2ConsumeBeforePearls", true)
        + "; mode=" + pref_string("leg2ConsumeMode", "ALWAYS")
        + "; done=" + get_property(INTERNAL + "leg2ConsumeDone")
        + "; command=\"" + pref_string("leg2ConsumeCommand", "CONSUME ALL") + "\""
        + "; allow booze=" + pref_bool("leg2AllowBoozeConsume", true)
        + "; allow risky=" + pref_bool("leg2AllowRiskyConsume", false));
    print("Leg2 pearl familiar: mode=" + pref_string("leg2PearlFamiliarMode", "AUTO")
        + "; selected=" + get_property(INTERNAL + "leg2PearlFamiliar")
        + "; Hobo Monkey Moxie floor=" + pref_int("leg2HoboMonkeyMoxieFloor", 600));
    print("Leg2 saltwaterbed: install=" + pref_bool("leg2InstallSaltwaterbed", false)
        + "; sea leather cap=" + pref_int("leg2SealeatherMaxPrice", 5000)
        + "; auto-approve replace=" + pref_bool("leg2AutoApproveSaltwaterbedReplace", true));
    print("Book of Facts wishes used: " + get_property("_bookOfFactsWishes"));
    print("Source Terminal Extract for Leg2 pearls: " + pref_bool("leg2UseExtract", true)
        + "; known=" + get_property("sourceTerminalEducateKnown").contains_text("extract.edu")
        + "; active=" + (get_property("sourceTerminalEducate1") == "extract.edu"
            || get_property("sourceTerminalEducate2") == "extract.edu"));
    print("Source Terminal meat.enh for Leg2 pearls: " + pref_bool("leg2UseSourceTerminalMeat", false));
    print("Post-run pearl CCS: "
        + pref_string("postRunPearlCombatScript", "LoopTheSeaPearl")
        + "; recover HP%=" + pref_int("leg2PearlRecoverHpPercent", 95)
        + "; MP target=" + pref_int("leg2PearlRecoverMpTarget", 120)
        + "; cure beaten up=" + pref_bool("leg2PearlCureBeatenUp", true)
        + "; cure The Colors=" + pref_bool("leg2PearlCureTheColors", true)
        + "; cure cap=" + pref_int("leg2NegativeEffectCureMaxPrice", 5000));
    print("Pearl value used: " + pearl_value + " Meat; projected pearl MPA: "
        + projected_pearl_mpa() + "; minimum: " + min_mpa, "teal");

    string normalized_pearl_mode = pearl_mode.to_upper_case();
    if (unfinished_pearl_zone_count() <= 0) {
        print("All pearl zones are complete today.", "green");
        return;
    }

    if (normalized_pearl_mode == "REPORT" || normalized_pearl_mode == "NEVER") {
        print("Recommendation: Leg2 pearl farming is disabled by mode=" + normalized_pearl_mode + ".", "yellow");
    } else if (have_effect($effect[Fishy]) > 0) {
        print("Recommendation: retained Fishy is live. Farm pearl zones before any ordinary Garbo turn if you choose to test the Leg2 pearl branch.", "green");
    } else if (cheap_fishy_turns_available() > 0 && projected_pearl_mpa() >= min_mpa) {
        print("Recommendation: pearl farming clears the configured value floor with cheap Fishy available.", "green");
    } else {
        print("Warning: mode=" + normalized_pearl_mode + " will farm Leg2 pearls even though projected pearl MPA is below the reporting minimum. Set "
            + PREF + "leg2PearlMode=NEVER to preserve those turns for Garbo or rollover.", "yellow");
    }
    print("Note: Leg2 pearl farming should use a skill-capable CCS. UnderTheSeaPrep's attack-only CCS is only for the overdrunk Leg1 organ-lock state.", "teal");
}

void print_ascension_config() {
    print("Ascension config", "blue");
    print("- enabled: " + pref_bool("ascendEnabled", false));
    print("- type: " + pref_int("ascensionType", 2)
        + "; pathId: " + pref_int("pathId", 55)
        + " (11,037 Leagues Under the Sea)");
    print("- className: " + pref_string("className", "(unset)")
        + "; moonId: " + pref_string("moonId", "(unset)")
        + "; gender: " + pref_string("gender", "(unset)"));
    print("- astralPet: " + pref_string("astralPet", "(none)")
        + "; astralDeli: " + pref_string("astralDeli", "(none)")
        + "; permSkills: " + pref_string("permSkills", "NONE"));
    print("- perm minimum banked Karma: " + pref_int("permMinimumBankedKarma", 0));
    print("- stopAfterAscension: " + pref_bool("stopAfterAscension", true));
}

void status() {
    prepare_loop_state();
    print("LoopTheSea status", "blue");
    print("Phase: " + current_phase());
    print("Path: " + path_name() + "; kingLiberated: " + king_liberated()
        + "; can_interact: " + can_interact());
    print("Adventures: " + my_adventures() + "; fullness: " + my_fullness() + "/"
        + fullness_limit() + "; liver: " + my_inebriety() + "/" + inebriety_limit()
        + "; spleen: " + my_spleen_use() + "/" + spleen_limit());
    print("Checkpoints: initialGarboDone=" + get_property(INTERNAL + "initialGarboDone")
        + "; leg1Complete=" + get_property(INTERNAL + "leg1Complete")
        + "; leg1RolloverDone=" + get_property(INTERNAL + "leg1RolloverDone")
        + "; underTheSeaComplete=" + get_property(INTERNAL + "underTheSeaComplete")
        + "; leg2Complete=" + get_property(INTERNAL + "leg2Complete")
        + "; profitTrackingActive=" + get_property(INTERNAL + "profitTrackingActive"));
    print("Leg2 finish checkpoints: breakfast=" + get_property(INTERNAL + "leg2BreakfastDone")
        + "; lateDaily=" + get_property(INTERNAL + "leg2LateDailyDone")
        + "; consume=" + get_property(INTERNAL + "leg2ConsumeDone")
        + "; garbo=" + get_property(INTERNAL + "leg2GarboDone")
        + "; nightcap=" + get_property(INTERNAL + "leg2NightcapDone")
        + "; expandedOrgans=" + get_property(INTERNAL + "leg2ExpandedOrgansDone")
        + "; hook=" + get_property(INTERNAL + "leg2RolloverHookDone")
        + "; rollover=" + get_property(INTERNAL + "leg2RolloverDone"));
    print("Leg1 rollover checkpoints: hook=" + get_property(INTERNAL + "leg1RolloverHookDone")
        + "; rollover=" + get_property(INTERNAL + "leg1RolloverDone"));
    print("Configured initial Garbo: run=" + pref_bool("runInitialGarbo", false)
        + "; command=\"" + pref_string("initialGarboCommand", "garbo ascend") + "\""
        + "; preserve Fishy pipe/Lutz=" + pref_bool("preserveInitialGarboFishy", true));
    print("Initial Garbo retry guard: allowPartialRetry="
        + pref_bool("allowPartialInitialGarboRetry", false)
        + "; activityToday=" + initial_garbo_activity_today()
        + "; completed=" + initial_garbo_completed());
    print("Profit tracking: enabled=" + pref_bool("profitTrackingEnabled", true)
        + "; required=" + pref_bool("profitTrackingRequired", false)
        + "; recap=" + pref_bool("profitTrackingRecap", true)
        + "; prefix=" + pref_string("profitMarkerPrefix", "lts"));
    print("LoopTheSea breakfast: government per-diem="
        + pref_bool("useGovernmentPerDiem", true)
        + "; daily raffle ticket target=" + pref_int("dailyRaffleTickets", 11)
        + "; Leg2 sweep=" + pref_bool("leg2RunBreakfastSweep", true)
        + "; Leg2 command=\"" + pref_string("leg2BreakfastCommand", "breakfast") + "\""
        + "; breakfastCompleted=" + get_property("breakfastCompleted"));
    print("Leg2 late daily sweep: enabled=" + pref_bool("leg2RunLateDailySweep", true)
        + "; rerun breakfast=" + pref_bool("leg2RerunBreakfastAtRollover", true)
        + "; Chroner=" + pref_bool("leg2UseRemainingChronerItems", true)
        + "; 2002 credits=" + pref_bool("leg2Spend2002Credits", true)
        + "; reward=\"" + pref_string("leg2MrStore2002Reward", "Spooky VHS Tape") + "\""
        + "; turn burn=\"" + pref_string("leg2LateDailyTurnBurnCommand", "garbo nodiet") + "\""
        + "; extra command=\"" + pref_string("leg2LateDailyCommand", "") + "\"");
    print_ascension_config();
    print("Configured UnderTheSea command: \""
        + pref_string("underTheSeaCommand", "UnderTheSea") + "\""
        + "; auto-recover Fishy=" + pref_bool("underTheSeaAutoRecoverFishy", true));
    print("Leg2 automation: runAfterUnderSea=" + pref_bool("leg2RunAfterUnderSea", false)
        + "; pearlMode=" + pref_string("leg2PearlMode", "FARM")
        + "; target=" + pref_int("leg2PearlTargetCount", 5)
        + "; buffer=" + pref_int("leg2PearlBuffer", 10));
    print("Leg2 Pantogram: build=" + pref_bool("leg2BuildPantogram", true)
        + "; require pressure=" + pref_bool("leg2RequirePantogramPressure", true)
        + "; available/planned=" + leg2_pantogram_available() + "/" + leg2_pantogram_planned()
        + "; protect porquoise now=" + should_protect_porquoise_before_undersea()
        + "; stat=" + pref_string("leg2PantogramStat", "moxie")
        + "; element=" + pref_string("leg2PantogramElement", "auto")
        + "; cachedChoice=" + get_property(INTERNAL + "leg2PantogramElementChoice")
        + "; left=" + pref_string("leg2PantogramLeftSacrifice", "glowing New Age crystal"));
    print("Leg2 cozy bazooka: " + cozy_bazooka_status());
    print("Leg2 Garbo: run=" + pref_bool("leg2GarboAfterPearls", true)
        + "; command=\"" + pref_string("leg2GarboCommand", "garbo") + "\""
        + "; require spent=" + pref_bool("leg2RequireGarboSpendAllTurns", true));
    print("Leg2 Donho: use=" + pref_bool("leg2UseDonho", true)
        + "; item fallback=" + pref_bool("leg2AllowDonhoItemFallback", false));
    print("Leg2 pressure upkeep: consumables=" + pref_bool("leg2UsePressureConsumables", true)
        + "; fastjuice cap=" + pref_int("leg2FastjuiceMaxPrice", 5000)
        + "; sea salt cap=" + pref_int("leg2SeaSaltCrystalMaxPrice", 5000)
        + "; shark cartilage cap=" + pref_int("leg2SharkCartilageMaxPrice", 50000)
        + "; shavin' razor cap=" + pref_int("leg2ShavinRazorMaxPrice", 10000));
    print("Leg2 resistance buffs: use=" + pref_bool("leg2UseResistanceBuffs", true)
        + "; minor invulnerability cap=" + pref_int("leg2MinorInvulnerabilityMaxPrice", 5000)
        + "; potion rescue=" + pref_bool("leg2UseResistancePotionRescue", true)
        + "; potion cap=" + pref_int("leg2ResistancePotionMaxPrice", 5000)
        + "; potion total cap=" + pref_int("leg2ResistancePotionTotalCap", 15000)
        + "; extra commands=\"" + pref_string("leg2ExtraPearlBuffCommands", "") + "\"");
    print("Leg2 pre-pearl consume: enabled=" + pref_bool("leg2ConsumeBeforePearls", true)
        + "; mode=" + pref_string("leg2ConsumeMode", "ALWAYS")
        + "; done=" + get_property(INTERNAL + "leg2ConsumeDone")
        + "; command=\"" + pref_string("leg2ConsumeCommand", "CONSUME ALL") + "\""
        + "; allow booze=" + pref_bool("leg2AllowBoozeConsume", true)
        + "; allow risky=" + pref_bool("leg2AllowRiskyConsume", false));
    print("Leg2 pearl familiar: mode=" + pref_string("leg2PearlFamiliarMode", "AUTO")
        + "; selected=" + get_property(INTERNAL + "leg2PearlFamiliar")
        + "; Hobo Monkey Moxie floor=" + pref_int("leg2HoboMonkeyMoxieFloor", 600));
    print("Leg2 saltwaterbed: install=" + pref_bool("leg2InstallSaltwaterbed", false)
        + "; sea leather cap=" + pref_int("leg2SealeatherMaxPrice", 5000)
        + "; auto-approve replace=" + pref_bool("leg2AutoApproveSaltwaterbedReplace", true));
    print("Leg2 pearl combat: CCS="
        + pref_string("postRunPearlCombatScript", "LoopTheSeaPearl")
        + "; recover HP%=" + pref_int("leg2PearlRecoverHpPercent", 95)
        + "; MP target=" + pref_int("leg2PearlRecoverMpTarget", 120)
        + "; cure beaten up=" + pref_bool("leg2PearlCureBeatenUp", true)
        + "; cure The Colors=" + pref_bool("leg2PearlCureTheColors", true)
        + "; cure cap=" + pref_int("leg2NegativeEffectCureMaxPrice", 5000));
    print("Leg2 rollover: final nightcap=" + pref_bool("leg2RunFinalNightcap", true)
        + "; nightcap command=\"" + pref_string("leg2FinalNightcapCommand", "CONSUME NIGHTCAP") + "\""
        + "; expanded organs=" + pref_bool("leg2RunExpandedOrgansRollover", true)
        + "; keep organ gear=" + pref_bool("leg2KeepOrganGearForRollover", false)
        + "; wet dates=" + pref_bool("leg2UseWetDatesRollover", false)
        + "@" + pref_int("leg2WetDatesMaxPrice", 40000)
        + "; prep=" + pref_bool("leg2PrepareRollover", true)
        + "; cap=" + pref_int("leg2RolloverAdventureCap", 200)
        + "; maximizer=\"" + pref_string("leg2RolloverMaximizer", "adv, 0.001 pvp fights, -tie") + "\""
        + "; overflow Garbo=\"" + pref_string("leg2OverflowGarboCommand", "garbo nodiet") + "\""
        + "; hook=\"" + pref_string("leg2RolloverCommand", "") + "\"");
    print("Leg1 rollover: prep=" + pref_bool("leg1PrepareRollover", true)
        + "; cap=" + pref_int("leg1RolloverAdventureCap", 200)
        + "; maximizer=\"" + pref_string("leg1RolloverMaximizer", "adv, 0.001 pvp fights, -tie") + "\""
        + "; overflow Garbo=\"" + pref_string("leg1OverflowGarboCommand", "garbo nodiet") + "\""
        + "; hook=\"" + pref_string("leg1RolloverCommand", "") + "\"");
    print("Daily routing state: 2002 credits=" + get_property("_2002MrStoreCreditsCollected")
        + "; April globs=" + get_property("_aprilShowerGlobsCollected")
        + "; April shower=" + get_property("_aprilShower")
        + "; etched hourglass=" + get_property("_etchedHourglassUsed")
        + "; government per-diem=" + get_property("_governmentPerDiemUsed")
        + "; Chroner trigger/cross=" + get_property("_chronerTriggerUsed")
        + "/" + get_property("_chronerCrossUsed")
        + "; Mayam symbols=\"" + get_property("_mayamSymbolsUsed") + "\"");
    print_pearl_snapshot();
    print("Fishy now: " + have_effect($effect[Fishy])
        + "; cheap/retained projection: " + cheap_fishy_turns_available());
    print("Leg2 BOFA Fishy: enabled=" + pref_bool("leg2UseBofaFishy", true)
        + "; available=" + leg2_bofa_fishy_available()
        + "; attempts=" + leg2_bofa_fishy_attempts_used()
        + "/" + pref_int("leg2BofaFishyMaxAttempts", 3)
        + "; projected=" + leg2_bofa_fishy_projected_turns());
    item porquoise = porquoise_item();
    print("Porquoise: inventory=" + item_amount(porquoise)
        + "; closet=" + closet_amount(porquoise)
        + "; protected before UnderTheSea="
        + get_property(INTERNAL + "porquoiseClosetedBeforeUnderSea")
        + "; Pantogram modifier=\"" + get_property("_pantogramModifier") + "\"");
}

void preflight() {
    prepare_loop_state();
    print("LoopTheSea preflight", "blue");
    print("Leg1 prep preflight follows.", "teal");
    run_cli("UnderTheSeaPrep preflight");
    print_postrun_pearl_report();
    print("LoopTheSea preflight complete.", "green");
}

void maybe_run_initial_garbo() {
    if (!pref_bool("runInitialGarbo", false)) return;
    if (initial_garbo_completed()) {
        if (!get_property(INTERNAL + "initialGarboDone").to_boolean()) {
            set_property(INTERNAL + "initialGarboDone", "true");
            print("Initial Garbo is already complete; continuing from the external _garboCompleted checkpoint.", "teal");
        }
        return;
    }
    require_clean_initial_garbo_launch();

    if (!king_liberated()) abort("Initial Garbo should be run in Leg1 aftercore.");
    if (my_inebriety() > inebriety_limit()) {
        abort("Initial Garbo is enabled, but you are already overdrunk.");
    }

    boolean preserve_fishy = pref_bool("preserveInitialGarboFishy", true);
    int protected_pipe_count = 0;
    string previous_lutz_used = get_property("_skateBuff1");
    string previous_closet_satisfaction = get_property("autoSatisfyWithCloset");
    string previous_storage_satisfaction = get_property("autoSatisfyWithStorage");

    if (preserve_fishy) {
        protected_pipe_count = item_amount(FISHY_PIPE);
        if (protected_pipe_count > 0
            && !put_closet(protected_pipe_count, FISHY_PIPE)) {
            abort("Unable to closet " + protected_pipe_count + " " + FISHY_PIPE
                + " before initial Garbo.");
        }
        if (item_amount(FISHY_PIPE) > 0) {
            abort("Initial Garbo Fishy protection left " + item_amount(FISHY_PIPE)
                + " inventory " + FISHY_PIPE + ".");
        }

        set_property("autoSatisfyWithCloset", "false");
        set_property("autoSatisfyWithStorage", "false");
        set_property("_skateBuff1", "true");
        print("Preserving the Fishy pipe and Lutz during initial Garbo"
            + (have_effect($effect[Fishy]) > 0
                ? "; existing Fishy remains available to Garbo."
                : "."), "teal");
    }

    boolean pipe_restored = true;
    try {
        run_cli(pref_string("initialGarboCommand", "garbo ascend"));
    } finally {
        if (preserve_fishy) {
            set_property("_skateBuff1", previous_lutz_used);
            set_property("autoSatisfyWithCloset", previous_closet_satisfaction);
            set_property("autoSatisfyWithStorage", previous_storage_satisfaction);

            if (protected_pipe_count > 0) {
                pipe_restored = take_closet(protected_pipe_count, FISHY_PIPE);
            }
            print("Restored initial Garbo Fishy availability: pipe="
                + (protected_pipe_count == 0 ? "not moved" : pipe_restored)
                + "; _skateBuff1=" + get_property("_skateBuff1") + ".", "teal");
        }
    }
    if (!pipe_restored || item_amount(FISHY_PIPE) < protected_pipe_count) {
        abort("Initial Garbo completed, but LoopTheSea could not restore "
            + protected_pipe_count + " inventory " + FISHY_PIPE + ".");
    }

    set_property(INTERNAL + "initialGarboDone", "true");
    profit_marker("leg1_initial_garbo_done");
}

void require_initial_garbo_checkpoint() {
    if (!pref_bool("requireInitialGarboCompleted", true)) return;
    if (initial_garbo_completed()) {
        if (!get_property(INTERNAL + "initialGarboDone").to_boolean()) {
            set_property(INTERNAL + "initialGarboDone", "true");
            print("Initial Garbo checkpoint satisfied from the external _garboCompleted state.", "teal");
        }
        return;
    }

    abort("LoopTheSea leg1 expects the first garbo ascend to be complete. Run `garbo ascend` first, or set "
        + PREF + "runInitialGarbo=true to let this wrapper do it.");
}

void leg1() {
    prepare_loop_state();
    profit_marker("leg1_start");
    loop_breakfast();
    maybe_run_initial_garbo();
    require_initial_garbo_checkpoint();
    profit_marker("leg1_initial_garbo_done");

    begin_profit_tracking_scope();
    try {
        run_cli("UnderTheSeaPrep postgarbo");
    } finally {
        end_profit_tracking_scope();
    }

    buy_daily_raffle_tickets();
    set_property(INTERNAL + "leg1Complete", "true");
    profit_marker("leg1_done");
    profit_recap();
    print("Leg1 checkpoint complete. Stop here for manual Valhalla and 11,037 Leagues ascension.", "green");
}

void leg1_full() {
    prepare_loop_state();
    string previous = get_property(PREF + "runInitialGarbo");
    set_property(PREF + "runInitialGarbo", initial_garbo_completed() ? "false" : "true");
    try {
        leg1();
    } finally {
        set_property(PREF + "runInitialGarbo", previous);
    }
}

int configured_ascension_type() {
    int ascension_type = pref_int("ascensionType", 2);
    if (ascension_type < 1 || ascension_type > 3) {
        abort(PREF + "ascensionType must be 1, 2, or 3. Current value: " + ascension_type + ".");
    }
    return ascension_type;
}

int configured_path_id() {
    int path_id = pref_int("pathId", 55);
    if (path_id != 55) {
        abort(PREF + "pathId is " + path_id
            + ", but this preliminary loop only supports 11,037 Leagues Under the Sea path id 55.");
    }
    return path_id;
}

int configured_moon_id() {
    string raw = pref_string("moonId", "");
    if (raw == "") abort("Set " + PREF + "moonId before automated ascension.");

    int moon_id = raw.to_int();
    if (moon_id <= 0) {
        abort(PREF + "moonId must be a numeric KoL sign id. Current value: " + raw + ".");
    }
    return moon_id;
}

int configured_gender_id() {
    string raw = pref_string("gender", "").to_lower_case();
    if (raw == "") abort("Set " + PREF + "gender before automated ascension.");

    if (raw == "1" || raw == "m" || raw == "male" || raw == "boy") return 1;
    if (raw == "2" || raw == "f" || raw == "female" || raw == "girl") return 2;

    abort(PREF + "gender must be 1/boy/male or 2/girl/female. Current value: " + raw + ".");
    return 0;
}

class configured_class() {
    string raw = pref_string("className", "");
    if (raw == "") abort("Set " + PREF + "className before automated ascension.");

    class target_class = raw.to_class();
    if (to_int(target_class) <= 0) {
        abort(PREF + "className did not resolve to a KoL class: " + raw + ".");
    }
    return target_class;
}

item configured_afterlife_item(string key) {
    string raw = pref_string(key, "");
    if (raw == "" || raw.to_lower_case() == "none") return $item[none];

    item target_item = raw.to_item();
    if (to_int(target_item) <= 0) {
        abort(PREF + key + " did not resolve to an item: " + raw + ".");
    }
    return target_item;
}

boolean perm_config_is_none() {
    string raw = trim_string(pref_string("permSkills", "NONE"));
    return raw == "" || raw.to_upper_case() == "NONE";
}

string perm_config_all_mode() {
    string raw = trim_string(pref_string("permSkills", "NONE")).to_upper_case();
    if (raw == "ALL_HC" || raw == "ALL_HARDCORE") return "HC";
    if (raw == "ALL_SC" || raw == "ALL_SOFTCORE") return "SC";
    if (raw == "ALL") {
        abort(PREF + "permSkills=ALL is ambiguous. Use ALL_HC or ALL_SC.");
    }
    return "";
}

boolean perm_config_is_all() {
    return perm_config_all_mode() != "";
}

string perm_entry_type(string entry) {
    int separator = entry.index_of(":");
    if (separator <= 0) {
        abort("Perm entry must be prefixed with HC: or SC:. Bad entry: `" + entry + "`.");
    }

    string mode = trim_string(entry.substring(0, separator)).to_upper_case();
    if (mode == "HC" || mode == "HARDCORE") return "HC";
    if (mode == "SC" || mode == "SOFTCORE") return "SC";
    abort("Perm entry must use HC: or SC:. Bad entry: `" + entry + "`.");
    return "";
}

skill perm_entry_skill(string entry) {
    int separator = entry.index_of(":");
    if (separator <= 0) {
        abort("Perm entry must be prefixed with HC: or SC:. Bad entry: `" + entry + "`.");
    }

    string skill_name = trim_string(entry.substring(separator + 1));
    if (skill_name == "") abort("Perm entry has no skill name: `" + entry + "`.");

    skill target_skill = skill_name.to_skill();
    if (target_skill == $skill[none] || to_int(target_skill) <= 0) {
        abort("Perm entry did not resolve to a skill: `" + skill_name + "`.");
    }
    return target_skill;
}

int perm_entry_cost(string mode) {
    if (mode == "HC") return 200;
    if (mode == "SC") return 100;
    abort("Unknown perm mode: " + mode + ".");
    return 0;
}

string perm_entry_action(string mode) {
    if (mode == "HC") return "hcperm";
    if (mode == "SC") return "scperm";
    abort("Unknown perm mode: " + mode + ".");
    return "";
}

int map_size(int [int] values) {
    int size = 0;
    foreach i, value in values {
        size = size + 1;
    }
    return size;
}

int configured_perm_karma_cost_from_ids(int [int] skill_ids, string mode) {
    return map_size(skill_ids) * perm_entry_cost(mode);
}

int [int] offered_perm_skill_ids(buffer page, string action) {
    int [int] result;
    boolean [int] seen;
    int result_count = 0;

    string html = page.to_string();
    string quoted_action = action;

    matcher direct_get = create_matcher("(?s)action=" + quoted_action + ".{0,500}?whichskill=([0-9]+)", html);
    while (direct_get.find()) {
        int skill_id = direct_get.group(1).to_int();
        if (!seen[skill_id]) {
            result[result_count] = skill_id;
            seen[skill_id] = true;
            result_count = result_count + 1;
        }
    }

    matcher reverse_get = create_matcher("(?s)whichskill=([0-9]+).{0,500}?action=" + quoted_action, html);
    while (reverse_get.find()) {
        int skill_id = reverse_get.group(1).to_int();
        if (!seen[skill_id]) {
            result[result_count] = skill_id;
            seen[skill_id] = true;
            result_count = result_count + 1;
        }
    }

    matcher direct_form = create_matcher("(?s)name=['\"]?action['\"]?[^>]*value=['\"]?" + quoted_action + "['\"]?.{0,1000}?name=['\"]?whichskill['\"]?[^>]*value=['\"]?([0-9]+)", html);
    while (direct_form.find()) {
        int skill_id = direct_form.group(1).to_int();
        if (!seen[skill_id]) {
            result[result_count] = skill_id;
            seen[skill_id] = true;
            result_count = result_count + 1;
        }
    }

    matcher reverse_form = create_matcher("(?s)name=['\"]?whichskill['\"]?[^>]*value=['\"]?([0-9]+).{0,1000}?name=['\"]?action['\"]?[^>]*value=['\"]?" + quoted_action, html);
    while (reverse_form.find()) {
        int skill_id = reverse_form.group(1).to_int();
        if (!seen[skill_id]) {
            result[result_count] = skill_id;
            seen[skill_id] = true;
            result_count = result_count + 1;
        }
    }

    return result;
}

boolean permery_offers_skill_id(buffer page, string action, int skill_id) {
    int [int] offered = offered_perm_skill_ids(page, action);
    foreach i, offered_skill_id in offered {
        if (offered_skill_id == skill_id) return true;
    }
    return false;
}

boolean permery_offers_skill(buffer page, string action, skill target_skill) {
    return permery_offers_skill_id(page, action, to_int(target_skill));
}

int configured_perm_karma_cost() {
    if (perm_config_is_none()) return 0;
    if (perm_config_is_all()) return 0;

    int cost = 0;
    foreach i, raw_entry in pref_string("permSkills", "NONE").split_string("\\s*,\\s*") {
        string entry = trim_string(raw_entry);
        if (entry == "") continue;
        string mode = perm_entry_type(entry);
        perm_entry_skill(entry);
        cost = cost + perm_entry_cost(mode);
    }
    return cost;
}

void validate_perm_config() {
    if (perm_config_is_none()) return;
    if (perm_config_is_all()) return;

    foreach i, raw_entry in pref_string("permSkills", "NONE").split_string("\\s*,\\s*") {
        string entry = trim_string(raw_entry);
        if (entry == "") continue;
        perm_entry_type(entry);
        perm_entry_skill(entry);
    }
}

void validate_ascension_settings(boolean require_enabled) {
    if (require_enabled && !pref_bool("ascendEnabled", false)) {
        abort("Automated ascension is disabled. Set " + PREF + "ascendEnabled=true after reviewing `LoopTheSea status`.");
    }

    configured_ascension_type();
    configured_path_id();
    configured_class();
    configured_moon_id();
    configured_gender_id();
    configured_afterlife_item("astralPet");
    configured_afterlife_item("astralDeli");
    validate_perm_config();
}

void validate_ascension_config(boolean require_enabled) {
    validate_ascension_settings(require_enabled);

    if (in_undersea_path() && !king_liberated()) return;

    boolean already_in_valhalla = valhalla_ready();
    if (!already_in_valhalla) {
        if (!king_liberated()) abort("Ascension requires kingLiberated=true.");
        if (!get_property(INTERNAL + "leg1Complete").to_boolean()) {
            abort("Run `LoopTheSea leg1` before automated ascension.");
        }
        if (my_adventures() != 0) abort("Ascension checkpoint expects zero adventures; have " + my_adventures() + ".");
        if (mounted_pearl_count() != 5) abort("The Eternity Codpiece must have five mounted pearls before ascending.");
    }
}

void validate_ascension_config() {
    validate_ascension_config(true);
}

void ascend_preflight() {
    prepare_loop_state();
    validate_ascension_settings(false);
    print_ascension_config();
    if (in_undersea_path() && !king_liberated()) {
        print("Already in 11,037 Leagues Under the Sea. No ascension action needed.", "green");
    } else if (valhalla_ready()) {
        print("Already in Valhalla. `LoopTheSea ascend` will submit the configured afterlife choices.", "yellow");
    } else if (!get_property(INTERNAL + "leg1Complete").to_boolean()) {
        print("Ascension settings are valid. Operational ascension is still locked until `LoopTheSea leg1` completes today.", "yellow");
    } else if (my_adventures() != 0) {
        print("Ascension settings are valid. Operational ascension is still locked until adventures are burned to 0; current adventures: "
            + my_adventures() + ".", "yellow");
    } else if (mounted_pearl_count() != 5) {
        print("Ascension settings are valid. Operational ascension is still locked until The Eternity Codpiece has five mounted pearls; mounted: "
            + mounted_pearl_count() + ".", "yellow");
    } else {
        print("Ascension preflight passed. `LoopTheSea ascend` will enter Valhalla and submit the configured 11,037 Leagues ascension.", "green");
    }
}

void enter_valhalla_if_needed() {
    if (valhalla_ready()) {
        if (get_property(INTERNAL + "ascensionStartedFrom") == "" && my_ascensions() > 0) {
            set_property(INTERNAL + "ascensionStartedFrom", "" + my_ascensions());
        }
        print("Already in Valhalla.", "green");
        return;
    }

    int starting_ascensions = my_ascensions();
    set_property(INTERNAL + "ascensionStartedFrom", "" + starting_ascensions);
    prefs_checkpoint("before-ascension");

    print("Entering Valhalla.", "teal");
    visit_url("council.php", false, true);
    visit_url("ascend.php?pwd&action=ascend&confirm=on&confirm2=on", true, true);

    if (!valhalla_ready()) {
        abort("Failed to enter Valhalla. Resolve the relay state manually, then rerun `LoopTheSea ascend`.");
    }
    set_property(INTERNAL + "enteredValhalla", "true");
}

string afterlife_visit_key() {
    string starting_ascensions = get_property(INTERNAL + "ascensionStartedFrom");
    if (starting_ascensions != "") return "asc:" + starting_ascensions;

    int current_ascensions = my_ascensions();
    if (current_ascensions > 0) return "asc:" + current_ascensions;

    return "date:" + today_to_string();
}

void mark_ascension_complete() {
    set_property(INTERNAL + "checkpointDate", today_to_string());
    set_property(INTERNAL + "initialGarboDone", "false");
    set_property(INTERNAL + "leg1Complete", "false");
    set_property(INTERNAL + "underTheSeaComplete", "false");
    set_property(INTERNAL + "leg2Complete", "false");
    set_property(INTERNAL + "profitTrackingActive", "false");
    set_property(INTERNAL + "raffleTicketsBought", "0");
    set_property(INTERNAL + "leg2PantogramElementChoice", "");
    set_property(INTERNAL + "leg2ConsumeDone", "false");
    set_property(INTERNAL + "porquoiseClosetedBeforeUnderSea", "0");
    set_property(INTERNAL + "leg2PearlFamiliar", "");
    set_property(INTERNAL + "leg2BreakfastDone", "false");
    set_property(INTERNAL + "leg2LateDailyDone", "false");
    set_property(INTERNAL + "leg2GarboDone", "false");
    set_property(INTERNAL + "leg2NightcapDone", "false");
    set_property(INTERNAL + "leg2ExpandedOrgansDone", "false");
    set_property(INTERNAL + "leg2RolloverHookDone", "false");
    set_property(INTERNAL + "leg2RolloverDone", "false");
    set_property(INTERNAL + "leg2BofaFishyAttempts", "0");
    set_property(INTERNAL + "leg2PearlBudgetFloor", "0");
    set_property(INTERNAL + "leg1RolloverHookDone", "false");
    set_property(INTERNAL + "leg1RolloverDone", "false");
    set_property(INTERNAL + "enteredValhalla", "false");
    set_property(INTERNAL + "ascensionComplete", "true");
    set_property(INTERNAL + "ascensionStartedFrom", "");
    set_property(INTERNAL + "ascensionNumber", "" + my_ascensions());
    set_property(INTERNAL + "afterlifeDeliBoughtFor", "");
    set_property(INTERNAL + "afterlifeArmoryBoughtFor", "");
}

void resolve_post_ascension_choice() {
    if (!handling_choice()) return;
    if (last_choice() != 1564) {
        print("Post-ascension resolver found choice " + last_choice()
            + "; leaving it alone and continuing verification.", "yellow");
        return;
    }

    print("Acknowledging the 11,037 Leagues intro choice.", "teal");
    run_choice(1);
    if (handling_choice() && last_choice() == 1564) {
        abort("11,037 Leagues intro choice 1564 did not resolve.");
    }
}

void buy_afterlife_item(string label, string action, item target_item) {
    if (target_item == $item[none]) {
        print("Skipping " + label + " purchase.", "gray");
        return;
    }

    string visit_key = afterlife_visit_key();
    string purchase_property = INTERNAL + "afterlife" + action + "BoughtFor";
    if (action == "buydeli") purchase_property = INTERNAL + "afterlifeDeliBoughtFor";
    if (action == "buyarmory") purchase_property = INTERNAL + "afterlifeArmoryBoughtFor";
    if (get_property(purchase_property) == visit_key) {
        print("Skipping " + label + " purchase; already handled " + action
            + " for this Valhalla visit.", "gray");
        return;
    }

    print("Buying " + label + ": " + target_item + ".", "teal");
    buffer response = visit_url("afterlife.php?action=" + action + "&whichitem=" + to_int(target_item), true, true);
    if (response.contains_text("don't have enough Karma")) {
        abort("KoL refused to buy " + target_item + ": not enough Karma.");
    }
    set_property(purchase_property, visit_key);
}

void run_configured_perm_skills() {
    if (perm_config_is_none()) {
        print("Skipping skill perming by " + PREF + "permSkills=NONE.", "gray");
        return;
    }

    validate_perm_config();

    buffer permery = visit_url("afterlife.php?place=permery", false, true);
    int minimum_karma = pref_int("permMinimumBankedKarma", 0);
    int starting_karma = get_property("bankedKarma").to_int();
    if (minimum_karma > 0 && starting_karma > 0 && starting_karma <= minimum_karma) {
        print("Skipping skill perming because banked Karma is " + starting_karma
            + ", which is not above configured threshold " + minimum_karma + ".", "yellow");
        return;
    }

    if (perm_config_is_all()) {
        string mode = perm_config_all_mode();
        string action = perm_entry_action(mode);
        int [int] all_skill_ids = offered_perm_skill_ids(permery, action);
        int offered_count = map_size(all_skill_ids);
        if (offered_count <= 0) {
            print("Valhalla is not offering any " + mode
                + " perms for " + PREF + "permSkills=" + pref_string("permSkills", "NONE")
                + "; continuing without perming.", "yellow");
            return;
        }

        int expected_cost = configured_perm_karma_cost_from_ids(all_skill_ids, mode);
        if (starting_karma > 0 && starting_karma < expected_cost) {
            abort("Configured " + mode + " all-mode perms cost " + expected_cost
                + " Karma for " + offered_count
                + " skill(s), but KoLmafia currently reports only "
                + starting_karma + " banked Karma.");
        }

        print("Perming all " + offered_count + " offered " + mode
            + " skill(s) for " + expected_cost + " Karma.", "teal");
        foreach i, skill_id in all_skill_ids {
            print("Perming skill #" + skill_id + " as " + mode
                + " for " + perm_entry_cost(mode) + " Karma.", "teal");
            string url = "afterlife.php?pwd&action=" + action
                + "&whichskill=" + skill_id
                + (mode == "HC" ? "&hc=1" : "&hc=0");
            buffer response = visit_url(url, true, true);
            if (response.contains_text("don't have enough Karma")) {
                abort("KoL refused to perm skill #" + skill_id + ": not enough Karma.");
            }

            permery = visit_url("afterlife.php?place=permery", false, true);
            if (permery_offers_skill_id(permery, action, skill_id)) {
                abort("Attempted to perm skill #" + skill_id
                    + ", but it is still offered in the Valhalla permery.");
            }
        }
        return;
    }

    int expected_cost = configured_perm_karma_cost();
    if (starting_karma > 0 && starting_karma < expected_cost) {
        abort("Configured skill perms cost " + expected_cost
            + " Karma, but KoLmafia currently reports only "
            + starting_karma + " banked Karma.");
    }

    foreach i, raw_entry in pref_string("permSkills", "NONE").split_string("\\s*,\\s*") {
        string entry = trim_string(raw_entry);
        if (entry == "") continue;

        string mode = perm_entry_type(entry);
        skill target_skill = perm_entry_skill(entry);
        string action = perm_entry_action(mode);
        int skill_id = to_int(target_skill);

        if (!permery_offers_skill(permery, action, target_skill)) {
            abort("Valhalla is not offering " + mode + " perm for "
                + target_skill + ". Check whether the skill was learned this life, "
                + "is already permanent, or the requested perm type is unavailable.");
        }

        print("Perming " + target_skill + " as " + mode + " for "
            + perm_entry_cost(mode) + " Karma.", "teal");
        string url = "afterlife.php?pwd&action=" + action
            + "&whichskill=" + skill_id
            + (mode == "HC" ? "&hc=1" : "&hc=0");
        buffer response = visit_url(url, true, true);
        if (response.contains_text("don't have enough Karma")) {
            abort("KoL refused to perm " + target_skill + ": not enough Karma.");
        }

        permery = visit_url("afterlife.php?place=permery", false, true);
        if (permery_offers_skill(permery, action, target_skill)) {
            abort("Attempted to perm " + target_skill
                + ", but the skill is still offered in the Valhalla permery.");
        }
    }
}

void submit_afterlife_ascension() {
    int ascension_type = configured_ascension_type();
    int path_id = configured_path_id();
    class target_class = configured_class();
    int moon_id = configured_moon_id();
    int gender_id = configured_gender_id();
    item astral_pet = configured_afterlife_item("astralPet");
    item astral_deli = configured_afterlife_item("astralDeli");

    print("Visiting the Pearly Gates.", "teal");
    visit_url("afterlife.php?action=pearlygates", false, true);
    buy_afterlife_item("astral deli item", "buydeli", astral_deli);
    buy_afterlife_item("astral pet", "buyarmory", astral_pet);
    run_configured_perm_skills();

    int starting_ascensions = get_property(INTERNAL + "ascensionStartedFrom").to_int();
    if (starting_ascensions <= 0) starting_ascensions = my_ascensions();

    print("Submitting 11,037 Leagues Under the Sea ascension.", "teal");
    string url = "afterlife.php?pwd&action=ascend&confirmascend=1"
        + "&whichsign=" + moon_id
        + "&gender=" + gender_id
        + "&whichclass=" + to_int(target_class)
        + "&whichpath=" + path_id
        + "&asctype=" + ascension_type
        + "&nopetok=1&noskillsok=1&lamesignok=1&lamepathok=1";
    visit_url(url, true, true);
    resolve_post_ascension_choice();
    visit_url("main.php", false, true);
    resolve_post_ascension_choice();

    if (!in_undersea_path()) {
        abort("Ascension submit completed, but current path is " + path_name()
            + " instead of 11,037 Leagues Under the Sea.");
    }
    if (king_liberated()) {
        abort("Ascension submit completed, but kingLiberated is still true.");
    }
    if (my_class() != target_class) {
        abort("Ascension submit completed, but class is " + my_class()
            + " instead of " + target_class + ".");
    }
    if (my_ascensions() <= starting_ascensions) {
        abort("Ascension submit completed, but ascension count did not increase from "
            + starting_ascensions + ".");
    }

    mark_ascension_complete();
    prefs_checkpoint("after-ascension");
    print("Automated ascension complete. Current path: " + path_name()
        + "; ascensions: " + my_ascensions() + ".", "green");
}

void ascend_checkpoint() {
    prepare_loop_state();
    validate_ascension_config();
    print_ascension_config();
    if (in_undersea_path() && !king_liberated()) {
        mark_ascension_complete();
        print("Already in 11,037 Leagues Under the Sea. No ascension action needed.", "green");
        return;
    }

    enter_valhalla_if_needed();
    submit_afterlife_ascension();

    if (pref_bool("stopAfterAscension", true)) {
        print("Stopping after automated ascension by " + PREF
            + "stopAfterAscension=true. Run `LoopTheSea undersea` or `LoopTheSea leg2` next.", "green");
    }
}

void require_ascension_enabled(string command_name) {
    if (!pref_bool("ascendEnabled", false)) {
        abort(command_name + " requires " + PREF
            + "ascendEnabled=true before it can cross Valhalla.");
    }
}

void resolve_undersea_council_choice() {
    if (!handling_choice()) return;
    if (last_choice() != 1565) {
        abort("Unexpected choice " + last_choice()
            + " while collecting the UnderTheSea Toot package.");
    }

    print("Acknowledging the UnderTheSea Council message.", "teal");
    run_choice(1);
    if (handling_choice()) {
        abort("UnderTheSea Council choice 1565 did not resolve.");
    }
}

void protect_porquoise_before_undersea() {
    if (!pref_bool("protectPorquoiseBeforeUnderSea", true)) {
        print("Skipping porquoise protection by " + PREF
            + "protectPorquoiseBeforeUnderSea=false.", "yellow");
        return;
    }
    if (!pref_bool("leg2BuildPantogram", true)) {
        print("Skipping porquoise protection because Leg2 Pantogram building is disabled.", "yellow");
        return;
    }
    if (have_item_or_equipped(PANTOGRAM_PANTS)) {
        print("Skipping porquoise protection because Pantogram pants already exist.", "green");
        return;
    }
    if (!have_item_or_equipped(PORTABLE_PANTOGRAM)) {
        print("Skipping porquoise protection because no portable Pantogram is available.", "yellow");
        return;
    }

    resolve_undersea_council_choice();

    if (in_undersea_path() && get_property("questM05Toot") == "started") {
        print("Collecting the Toot Oriole package before UnderTheSea can autosell its porquoise.", "teal");
        visit_url("council.php");
        resolve_undersea_council_choice();
        visit_url("tutorial.php?action=toot");
        resolve_undersea_council_choice();
        visit_url("council.php");
        resolve_undersea_council_choice();
    }

    if (item_amount(KING_RALPH_LETTER) > 0) {
        int letters = item_amount(KING_RALPH_LETTER);
        print("Opening " + letters + " " + KING_RALPH_LETTER + " before UnderTheSea.", "teal");
        if (!use(letters, KING_RALPH_LETTER)) {
            abort("Failed to use " + KING_RALPH_LETTER + " before UnderTheSea.");
        }
    }

    if (item_amount(PORK_ELF_GOODIES_SACK) > 0) {
        int sacks = item_amount(PORK_ELF_GOODIES_SACK);
        print("Opening " + sacks + " " + PORK_ELF_GOODIES_SACK + " before UnderTheSea.", "teal");
        if (!use(sacks, PORK_ELF_GOODIES_SACK)) {
            abort("Failed to use " + PORK_ELF_GOODIES_SACK + " before UnderTheSea.");
        }
    }

    item porquoise = porquoise_item();
    int porquoise_count = item_amount(porquoise);
    if (porquoise_count <= 0) {
        print("No inventory " + porquoise + " to closet before UnderTheSea.", "gray");
        return;
    }

    print("Closeting " + porquoise_count + " " + porquoise + " before UnderTheSea autosell cleanup.", "teal");
    if (!put_closet(porquoise_count, porquoise)) {
        abort("Failed to closet " + porquoise + " before UnderTheSea.");
    }
    if (item_amount(porquoise) > 0) {
        abort("Inventory " + porquoise + " remains after closeting attempt.");
    }
    set_property(INTERNAL + "porquoiseClosetedBeforeUnderSea", closet_amount(porquoise));
    print("Protected " + closet_amount(porquoise) + " closeted " + porquoise
        + " before UnderTheSea.", "green");
}

int pantogram_stat_choice() {
    string stat_name = pref_string("leg2PantogramStat", "moxie").to_lower_case();
    if (stat_name == "muscle" || stat_name == "mus") return 1;
    if (stat_name == "mysticality" || stat_name == "mys") return 2;
    if (stat_name == "moxie" || stat_name == "mox") return 3;
    abort("Invalid " + PREF + "leg2PantogramStat=" + stat_name + ". Use muscle, mysticality, or moxie.");
    return 3;
}

int pantogram_element_choice() {
    string element_name = pref_string("leg2PantogramElement", "auto").to_lower_case();
    if (element_name == "auto") {
        string cached = get_property(INTERNAL + "leg2PantogramElementChoice");
        if (cached != "") return cached.to_int();
        abort(PREF + "leg2PantogramElement=auto must be resolved before Pantogram choice submission.");
    }
    if (element_name == "hot") return 1;
    if (element_name == "cold") return 2;
    if (element_name == "spooky") return 3;
    if (element_name == "sleaze") return 4;
    if (element_name == "stench") return 5;
    abort("Invalid " + PREF + "leg2PantogramElement=" + element_name
        + ". Use hot, cold, spooky, sleaze, stench, or auto.");
    return 1;
}

string pantogram_element_modifier_for_choice(int choice) {
    if (choice == 1) return "Hot Resistance";
    if (choice == 2) return "Cold Resistance";
    if (choice == 3) return "Spooky Resistance";
    if (choice == 4) return "Sleaze Resistance";
    return "Stench Resistance";
}

int pantogram_choice_for_zone(int zone_index) {
    if (zone_index == 0) return 3;
    if (zone_index == 1) return 4;
    if (zone_index == 2) return 5;
    if (zone_index == 3) return 1;
    return 2;
}

int pantogram_left_sacrifice_choice() {
    string sacrifice = pref_string("leg2PantogramLeftSacrifice", "glowing New Age crystal").to_lower_case();
    if (sacrifice == "hp" || sacrifice == "max hp" || sacrifice == "-1") return -1;
    if (sacrifice == "mp" || sacrifice == "max mp" || sacrifice == "-2") return -2;
    if (sacrifice == "glowing new age crystal" || sacrifice == "glowing crystal") {
        take_from_closet_if_needed(GLOWING_NEW_AGE_CRYSTAL, 1);
        if (item_amount(GLOWING_NEW_AGE_CRYSTAL) <= 0
            && storage_amount(GLOWING_NEW_AGE_CRYSTAL) > 0
            && can_interact()) {
            take_storage(1, GLOWING_NEW_AGE_CRYSTAL);
        }
        if (item_amount(GLOWING_NEW_AGE_CRYSTAL) <= 0) {
            print("No " + GLOWING_NEW_AGE_CRYSTAL
                + " is accessible for the preferred Pantogram left sacrifice; "
                + "using the free MP fallback.", "yellow");
            return -2;
        }
        return 8455;
    }
    abort("Invalid " + PREF + "leg2PantogramLeftSacrifice=" + sacrifice
        + ". Use `glowing New Age crystal`, `hp`, or `mp`.");
    return -2;
}

int pantogram_left_sacrifice_quantity(int sacrifice) {
    if (sacrifice < 0) return 0;
    return 1;
}

void take_porquoise_out_for_pantogram() {
    item porquoise = porquoise_item();
    take_from_closet_if_needed(porquoise, 1);
    if (item_amount(porquoise) > 0) return;

    ensure_inventory_item(porquoise, 1, pref_int("leg2GearMaxPrice", 1000000), "Leg2 Pantogram");
}

boolean pantogram_has_pressure_modifier() {
    string mods = get_property("_pantogramModifier");
    return mods.contains_text("Meat Drop Penalty")
        && mods.contains_text("Item Drop Penalty")
        && mods.contains_text("Initiative Penalty")
        && mods.contains_text("env(underwater)");
}

void ensure_leg2_core_pressure_gear() {
    int cap = pref_int("leg2GearMaxPrice", 1000000);
    ensure_inventory_item(COZY_BAZOOKA, 1, cap, "Leg2 pressure gear");
    ensure_accessible_item(GOGGLES_OF_LOATHING, cap, "Leg2 pressure gear");
    ensure_accessible_item(AQUAMARINERS_NECKLACE, cap, "Leg2 pressure gear");
    ensure_accessible_item(AQUAMARINERS_RING, cap, "Leg2 pressure gear");
    ensure_accessible_item(TEFLON_SWIM_FINS, cap, "Leg2 pressure gear");
}

string leg2_core_pressure_gear_locks() {
    return "equip " + COZY_BAZOOKA
        + ", equip " + GOGGLES_OF_LOATHING
        + ", equip " + AQUAMARINERS_NECKLACE
        + ", equip " + AQUAMARINERS_RING
        + ", equip " + TEFLON_SWIM_FINS;
}

string leg2_core_pressure_gear_maximizer() {
    return leg2_core_pressure_gear_locks()
        + ", " + pref_string("leg2PressureMaximizer",
            "meat drop penalty, item drop penalty, initiative penalty, sea")
        + ", -tie";
}

int auto_pantogram_element_choice() {
    string configured = pref_string("leg2PantogramElement", "auto").to_lower_case();
    if (configured != "auto") return pantogram_element_choice();

    ensure_leg2_core_pressure_gear();
    int best_zone = -1;
    float weakest_resistance = 999999.0;
    foreach zone_index, loc in PEARL_LOCATIONS {
        string expression = PEARL_MAXIMIZERS[zone_index] + ", "
            + leg2_core_pressure_gear_locks()
            + ", -tie";
        print("Assessing Pantogram resistance target: " + expression, "teal");
        if (!maximize(expression, false)) {
            abort("Unable to assess Pantogram resistance target for " + loc + ".");
        }

        item pants = equipped_item($slot[pants]);
        float resistance = numeric_modifier(PEARL_MODIFIERS[zone_index]);
        float pants_resistance = numeric_modifier(pants, PEARL_MODIFIERS[zone_index]);
        float resistance_without_pants = resistance - pants_resistance;
        print("- " + loc + ": " + resistance_without_pants + " "
            + PEARL_MODIFIERS[zone_index] + " without pants slot"
            + " (" + resistance + " raw; " + pants + " contributed "
            + pants_resistance + ")", "teal");
        if (resistance_without_pants < weakest_resistance) {
            weakest_resistance = resistance_without_pants;
            best_zone = zone_index;
        }
    }

    if (best_zone < 0) abort("Unable to choose an automatic Pantogram resistance element.");
    int choice = pantogram_choice_for_zone(best_zone);
    set_property(INTERNAL + "leg2PantogramElementChoice", choice);
    print("Automatic Pantogram resistance target: " + pantogram_element_modifier_for_choice(choice)
        + " for " + PEARL_LOCATIONS[best_zone]
        + " at base resistance " + weakest_resistance + ".", "green");
    return choice;
}

void build_leg2_pantogram_pants() {
    if (!pref_bool("leg2BuildPantogram", true)) {
        print("Skipping Leg2 Pantogram pants by " + PREF + "leg2BuildPantogram=false.", "yellow");
        return;
    }
    if (pref_string("leg2PearlMode", "FARM").to_upper_case() == "NEVER") {
        print("Skipping Leg2 Pantogram pants because " + PREF + "leg2PearlMode=NEVER.", "yellow");
        return;
    }

    if (have_item_or_equipped(PANTOGRAM_PANTS)) {
        if (get_property("_pantogramModifier") == "") {
            abort("Pantogram pants already exist, but KoLmafia does not know their modifiers. "
                + "Refresh/inspect _pantogramModifier before automatic Leg2 farming.");
        }
        if (!pantogram_has_pressure_modifier()) {
            string message = "Existing Pantogram pants are missing the sea salt crystal pressure modifier: "
                + get_property("_pantogramModifier");
            if (pref_bool("leg2RequirePantogramPressure", true)) abort(message);
            print(message + ". Continuing because " + PREF
                + "leg2RequirePantogramPressure=false.", "yellow");
        }
        print("Pantogram pants already exist: " + get_property("_pantogramModifier"), "green");
        return;
    }

    if (!have_item_or_equipped(PORTABLE_PANTOGRAM)) {
        print("No portable Pantogram is available; continuing Leg2 without Pantogram pants.", "yellow");
        return;
    }
    if (item_amount(PORTABLE_PANTOGRAM) <= 0) {
        retrieve_item(1, PORTABLE_PANTOGRAM);
    }
    if (item_amount(PORTABLE_PANTOGRAM) <= 0) {
        abort("Portable Pantogram is available but could not be moved into inventory.");
    }
    take_porquoise_out_for_pantogram();
    ensure_inventory_item(SEA_SALT_CRYSTAL, 11, pref_int("leg2SeaSaltCrystalMaxPrice", 5000), "Leg2 Pantogram");
    int left = pantogram_left_sacrifice_choice();
    int pant_stat = pantogram_stat_choice();
    int pant_element = auto_pantogram_element_choice();

    print("Building Leg2 underwater Pantogram pants.", "teal");
    visit_url("inv_use.php?whichitem=9573");
    string page = visit_url("choice.php?whichchoice=1270&pwd&option=1&m=" + pant_stat
        + "&e=" + pant_element
        + "&s1=" + left + "%2C" + pantogram_left_sacrifice_quantity(left)
        + "&s2=706%2C1&s3=3495%2C11", true, true);

    if (!page.contains_text("pantogram pants") && !have_item_or_equipped(PANTOGRAM_PANTS)) {
        abort("Pantogram request did not produce " + PANTOGRAM_PANTS + ".");
    }

    string mods = get_property("_pantogramModifier");
    if (!mods.contains_text("Meat Drop: +60")) {
        abort("Pantogram pants are missing the porquoise +60% Meat modifier: " + mods);
    }
    if (!pantogram_has_pressure_modifier()) {
        abort("Pantogram pants are missing the sea salt crystal pressure modifier: " + mods);
    }
    if (!mods.contains_text(pantogram_element_modifier_for_choice(pant_element) + ": +2")) {
        abort("Pantogram pants are missing the configured resistance modifier: " + mods);
    }
    print("Built Pantogram pants: " + mods, "green");
}

void ensure_leg2_pressure_gear() {
    ensure_leg2_core_pressure_gear();
}

item leg2_pearl_familiar_equipment(familiar fam) {
    if (fam == HOBO_MONKEY) return DAS_BOOT;
    return LIL_BUSINESSMAN_KIT;
}

familiar select_leg2_pearl_familiar() {
    string mode = pref_string("leg2PearlFamiliarMode", "AUTO").to_upper_case();
    if (mode == "HOBO" || mode == "HOBO_MONKEY" || mode == "HOBO MONKEY") {
        if (!have_familiar(HOBO_MONKEY)) abort("Configured Leg2 pearl familiar Hobo Monkey is unavailable.");
        if (!have_item_or_equipped(DAS_BOOT)) abort("Hobo Monkey requires an available " + DAS_BOOT + ".");
        return HOBO_MONKEY;
    }
    if (mode == "URCHIN" || mode == "URCHIN_URCHIN" || mode == "URCHIN URCHIN") {
        if (!have_familiar(URCHIN_URCHIN)) abort("Configured Leg2 pearl familiar Urchin Urchin is unavailable.");
        return URCHIN_URCHIN;
    }
    if (mode == "GROUPER" || mode == "GROUPER_GROUPIE" || mode == "GROUPER GROUPIE") {
        if (!have_familiar(GROUPER_GROUPIE)) abort("Configured Leg2 pearl familiar Grouper Groupie is unavailable.");
        return GROUPER_GROUPIE;
    }
    if (mode != "AUTO") {
        abort("Invalid " + PREF + "leg2PearlFamiliarMode=" + mode
            + ". Use AUTO, HOBO_MONKEY, URCHIN_URCHIN, or GROUPER_GROUPIE.");
    }

    if (have_familiar(HOBO_MONKEY)
        && have_item_or_equipped(DAS_BOOT)
        && my_buffedstat($stat[Moxie]) >= pref_int("leg2HoboMonkeyMoxieFloor", 600)) {
        return HOBO_MONKEY;
    }
    if (have_familiar(URCHIN_URCHIN)) return URCHIN_URCHIN;
    if (have_familiar(GROUPER_GROUPIE)) return GROUPER_GROUPIE;
    abort("AUTO Leg2 pearl familiar selection found no Hobo Monkey, Urchin Urchin, or Grouper Groupie.");
    return GROUPER_GROUPIE;
}

void ensure_leg2_pearl_familiar() {
    familiar selected = select_leg2_pearl_familiar();
    item familiar_item = leg2_pearl_familiar_equipment(selected);
    if (!have_equipped(familiar_item)) {
        ensure_inventory_item(familiar_item, 1, pref_int("leg2GearMaxPrice", 1000000),
            "Leg2 pearl familiar equipment");
    }
    if (my_familiar() != selected && !use_familiar(selected)) {
        abort("Unable to use Leg2 pearl familiar " + selected + ".");
    }
    set_property(INTERNAL + "leg2PearlFamiliar", selected);
}

string leg2_pearl_familiar_lock() {
    return "equip " + leg2_pearl_familiar_equipment(my_familiar());
}

void verify_leg2_pearl_familiar() {
    item expected = leg2_pearl_familiar_equipment(my_familiar());
    if (equipped_item($slot[familiar]) != expected) {
        abort("Leg2 pearl familiar " + my_familiar() + " is not wearing " + expected + ".");
    }
    if (my_familiar() == HOBO_MONKEY
        && my_buffedstat($stat[Moxie]) < pref_int("leg2HoboMonkeyMoxieFloor", 600)) {
        abort("Hobo Monkey pearl outfit only has " + my_buffedstat($stat[Moxie])
            + " buffed Moxie; configured floor is "
            + pref_int("leg2HoboMonkeyMoxieFloor", 600) + ".");
    }
}

string leg2_bofa_fishy_ccs_name() {
    return "LoopTheSeaBofaFishy";
}

void ensure_leg2_bofa_fishy_ccs() {
    write_ccs(to_buffer("consult LoopTheSeaBofaFishyCCS.ash\nabort"), leg2_bofa_fishy_ccs_name());
}

boolean equip_leg2_bofa_fishy_items() {
    take_from_closet_if_needed(MONODENT_OF_THE_SEA, 1);

    if (equipped_item($slot[weapon]) != MONODENT_OF_THE_SEA) {
        if (item_amount(MONODENT_OF_THE_SEA) <= 0 || !equip($slot[weapon], MONODENT_OF_THE_SEA)) {
            print("Unable to equip " + MONODENT_OF_THE_SEA + " for Leg2 BOFA Fishy.", "yellow");
            return false;
        }
    }

    return have_equipped(MONODENT_OF_THE_SEA);
}

void recover_for_leg2_bofa_fishy() {
    if (have_effect($effect[Beaten Up]) > 0 && have_skill($skill[Tongue of the Walrus])) {
        use_skill($skill[Tongue of the Walrus]);
    }

    if (my_hp() < my_maxhp()) restore_hp(my_maxhp());

    int mp_target = pref_int("leg2PearlRecoverMpTarget", 120);
    if (mp_target > 0) {
        mp_target = min(mp_target, my_maxmp());
        if (my_mp() < mp_target) restore_mp(mp_target);
    }
}

boolean try_leg2_bofa_fishy() {
    if (have_effect($effect[Fishy]) > 0) return true;
    if (!leg2_bofa_fishy_available()) return false;
    if (my_inebriety() > inebriety_limit()) {
        print("Skipping Leg2 BOFA Fishy while overdrunk; combat skills would be unreliable.", "yellow");
        return false;
    }
    int budget_floor = get_property(INTERNAL + "leg2PearlBudgetFloor").to_int();
    if (budget_floor > 0 && my_adventures() <= budget_floor) {
        print("Skipping Leg2 BOFA Fishy because no surplus adventure remains beyond the pearl budget.", "yellow");
        return false;
    }

    location loc = leg2_bofa_fishy_location();
    if (loc == $location[none] || !can_adventure(loc)) return false;

    item [slot] snapshot = equipment_snapshot();
    string previous_ccs = get_property("customCombatScript");
    string previous_battle_action = get_property("battleAction");
    int fishy_before = have_effect($effect[Fishy]);
    int adventures_before = my_adventures();
    string combat_before = get_property("_lastCombatStarted");

    print("Attempting Seal Clubber BOFA Fishy via Monodent some fish at " + loc + ".", "teal");
    try {
        recover_for_leg2_bofa_fishy();
        if (!equip_leg2_bofa_fishy_items()) return false;

        ensure_leg2_bofa_fishy_ccs();
        if (!set_ccs(leg2_bofa_fishy_ccs_name())) {
            abort("Unable to set Leg2 BOFA Fishy CCS.");
        }
        set_property("battleAction", "custom combat script");

        if (!adventure(1, loc)) {
            abort("Leg2 BOFA Fishy adventure failed or timed out at " + loc + ".");
        }
    } finally {
        set_ccs(previous_ccs);
        set_property("battleAction", previous_battle_action);
        restore_equipment(snapshot);
    }

    int spent = adventures_before - my_adventures();
    if (spent != 1) {
        abort("Leg2 BOFA Fishy expected to spend one adventure at " + loc
            + ", but spent " + spent + ".");
    }
    set_property(INTERNAL + "leg2BofaFishyAttempts", "" + (leg2_bofa_fishy_attempts_used() + 1));

    if (get_property("_lastCombatStarted") == combat_before
        || get_property("_lastCombatLost").to_boolean()
        || !get_property("_lastCombatWon").to_boolean()) {
        abort("Leg2 BOFA Fishy combat did not finish cleanly at " + loc + ".");
    }

    int fishy_gain = have_effect($effect[Fishy]) - fishy_before;
    if (fishy_gain >= 5) {
        print("BOFA some fish added " + fishy_gain + " Fishy turn(s).", "green");
        return true;
    }

    print("BOFA some fish did not add enough Fishy; gained " + fishy_gain
        + " turn(s). Falling back to the paid Fishy source.", "yellow");
    return false;
}

void ensure_leg2_fishy() {
    if (have_effect($effect[Fishy]) > 0) return;

    if (available_amount(FISHY_PIPE) > 0 && !get_property("_fishyPipeUsed").to_boolean()) {
        print("Using fishy pipe for Leg2 pearl farming.", "teal");
        take_from_closet_if_needed(FISHY_PIPE, 1);
        if (item_amount(FISHY_PIPE) > 0) use(1, FISHY_PIPE);
    }
    if (have_effect($effect[Fishy]) > 0) return;

    if (lutz_fishy_available()) {
        print("Attempting Lutz's skate-park Fishy buff for Leg2 pearl farming.", "teal");
        visit_url("sea_skatepark.php?action=state2buff1");
    }
    if (have_effect($effect[Fishy]) > 0) return;

    if (try_leg2_bofa_fishy()) return;

    ensure_inventory_item(FISHY_TEA, 1, pref_int("leg2GillTeaMaxPrice", 100000), "Leg2 Fishy");
    use(1, FISHY_TEA);
    if (have_effect($effect[Fishy]) <= 0) abort("Unable to acquire Fishy for Leg2 pearl farming.");
}

void ensure_effect_from_item(effect wanted, item source, int minimum_turns, int max_price, string context) {
    if (have_effect(wanted) >= minimum_turns) return;

    ensure_inventory_item(source, 1, max_price, context);
    print("Using " + source + " for " + wanted + ".", "teal");
    if (!use(1, source)) abort(context + ": failed to use " + source + ".");
    if (have_effect(wanted) <= 0) abort(context + ": did not acquire " + wanted + ".");
}

void apply_leg2_effect(effect ef) {
    if (have_effect(ef) > 0) return;
    if (to_skill(ef) != $skill[none] && !have_skill(to_skill(ef))) return;
    cli_execute(ef.default);
}

void ensure_leg2_resistance_buffs(int zone_index) {
    if (!pref_bool("leg2UseResistanceBuffs", true)) return;

    foreach ef in $effects[Astral Shell, Elemental Saucesphere] {
        apply_leg2_effect(ef);
    }

    if (have_effect($effect[Minor Invulnerability]) <= 0) {
        ensure_effect_from_item($effect[Minor Invulnerability], SCROLL_MINOR_INVULNERABILITY, 1,
            pref_int("leg2MinorInvulnerabilityMaxPrice", 5000), "Leg2 resistance buffs");
    }

    if (PEARL_MAXIMIZERS[zone_index] == "sleaze res") {
        apply_leg2_effect($effect[Scarysauce]);
    }

    foreach ef in $effects[Carol of the Hells, Mariachi Moisture] {
        apply_leg2_effect(ef);
    }

    string extra = pref_string("leg2ExtraPearlBuffCommands", "");
    if (extra != "") run_cli(extra);
}

boolean campground_has_item(item it) {
    int [item] campground = get_campground();
    return campground[it] > 0;
}

void maybe_install_saltwaterbed() {
    if (!pref_bool("leg2InstallSaltwaterbed", false)) return;

    visit_url("campground.php?action=inspectdwelling");
    if (campground_has_item(SALTWATERBED)) {
        print("Saltwaterbed is already installed.", "green");
        return;
    }

    item sea_leather = "sea leather".to_item();
    if (sea_leather == $item[none]) abort("KoLmafia does not recognize sea leather.");
    if (item_amount(SALTWATERBED) <= 0) {
        ensure_inventory_item(sea_leather, 15, pref_int("leg2SealeatherMaxPrice", 5000),
            "Leg2 saltwaterbed");
        print("Buying saltwaterbed from Grandma Sea Monkey for Leg2 pearl pressure.", "teal");
        if (!cli_execute("coinmaster buy grandma " + SALTWATERBED)) {
            abort("Failed to buy " + SALTWATERBED + " from Grandma Sea Monkey.");
        }
    }

    if (item_amount(SALTWATERBED) <= 0) {
        abort("Saltwaterbed purchase completed, but no " + SALTWATERBED
            + " is available to install.");
    }

    print("Installing saltwaterbed for Leg2 pearl pressure.", "teal");
    if (pref_bool("leg2AutoApproveSaltwaterbedReplace", true)) {
        // KoLmafia's use() always opens a GUI confirmation when bedding is already installed.
        visit_url("inv_use.php?which=3&whichitem=" + to_int(SALTWATERBED)
            + "&pwd&confirm=true&ajax=1");
    } else {
        if (!use(1, SALTWATERBED)) {
            abort("Failed to install " + SALTWATERBED + ".");
        }
    }

    visit_url("campground.php?action=inspectdwelling");
    if (!campground_has_item(SALTWATERBED)) {
        abort("Saltwaterbed installation completed, but the campground does not show " + SALTWATERBED + ".");
    }
    print("Saltwaterbed installed.", "green");
}

void ensure_leg2_donho() {
    if (!pref_bool("leg2UseDonho", true)) return;
    if (have_effect($effect[Donho's Bubbly Ballad]) > 0) return;

    print("Casting Donho's Bubbly Ballad for Leg2 pearl farming.", "teal");
    cli_execute("cast Donho's Bubbly Ballad");
    if (have_effect($effect[Donho's Bubbly Ballad]) > 0) return;

    if (!pref_bool("leg2AllowDonhoItemFallback", false)) {
        abort("Casting Donho's Bubbly Ballad did not apply it. "
            + "Check MP, skill availability, and the active AT song cap. Item fallback is disabled by "
            + PREF + "leg2AllowDonhoItemFallback=false.");
    }

    if (item_amount(DONHO_RECORDING) > 0 || closet_amount(DONHO_RECORDING) > 0) {
        ensure_effect_from_item($effect[Donho's Bubbly Ballad], DONHO_RECORDING, 1,
            pref_int("leg2DonhoRecordingMaxPrice", 50000), "Leg2 Donho");
        return;
    }

    if (item_amount(DONHO_SINGLE) > 0 || closet_amount(DONHO_SINGLE) > 0) {
        ensure_effect_from_item($effect[Donho's Bubbly Ballad], DONHO_SINGLE, 1,
            pref_int("leg2DonhoRecordingMaxPrice", 50000), "Leg2 Donho");
        return;
    }

    ensure_effect_from_item($effect[Donho's Bubbly Ballad], DONHO_SINGLE, 1,
        pref_int("leg2DonhoRecordingMaxPrice", 50000), "Leg2 Donho");
}

void ensure_leg2_pressure_effects() {
    ensure_leg2_donho();

    if (!pref_bool("leg2UsePressureConsumables", true)) return;

    ensure_effect_from_item($effect[Swimming with Sharks], SHARK_CARTILAGE, 1,
        pref_int("leg2SharkCartilageMaxPrice", 50000), "Leg2 pressure buffs");
    ensure_effect_from_item($effect[Hairless and Airless], SHAVIN_RAZOR, 1,
        pref_int("leg2ShavinRazorMaxPrice", 10000), "Leg2 pressure buffs");
    ensure_effect_from_item($effect[Juiced Up], MERKIN_FASTJUICE, 1,
        pref_int("leg2FastjuiceMaxPrice", 5000), "Leg2 pressure buffs");
    ensure_effect_from_item($effect[Salty Dogs], SEA_SALT_CRYSTAL, 1,
        pref_int("leg2SeaSaltCrystalMaxPrice", 5000), "Leg2 pressure buffs");
}

item [int] leg2_resistance_rescue_items() {
    item [int] result;
    result[0] = SCROLL_PROTECTION_BAD_STUFF;
    result[1] = PEC_OIL;
    result[2] = PROGRAMMABLE_TURTLE;
    result[3] = SMUDGE_STICK;
    result[4] = OIL_OF_PARRRLAY;
    return result;
}

effect leg2_resistance_rescue_effect(item source) {
    if (source == SCROLL_PROTECTION_BAD_STUFF) return $effect[Protection from Bad Stuff];
    if (source == PEC_OIL) return $effect[Oiled-Up];
    if (source == PROGRAMMABLE_TURTLE) return $effect[Spiro Gyro];
    if (source == SMUDGE_STICK) return $effect[Wreathed in Smoke];
    if (source == OIL_OF_PARRRLAY) return $effect[Well-Oiled];
    return $effect[none];
}

boolean try_leg2_resistance_potion_rescue(int zone_index, float resistance) {
    if (!pref_bool("leg2UseResistancePotionRescue", true)) return false;

    int target = pref_int("leg2PearlResTarget", 18);
    int max_price = pref_int("leg2ResistancePotionMaxPrice", 5000);
    int total_cap = pref_int("leg2ResistancePotionTotalCap", 15000);
    int spent = 0;
    boolean used_any = false;

    while (resistance < target) {
        int best_price = 2147483647;
        float best_gain = 0.0;
        item best_item = $item[none];
        effect best_effect = $effect[none];

        item [int] candidates = leg2_resistance_rescue_items();
        foreach i, source in candidates {
            effect ef = leg2_resistance_rescue_effect(source);
            if (ef == $effect[none] || have_effect(ef) > 0) continue;

            float gain = numeric_modifier(ef, PEARL_MODIFIERS[zone_index]);
            if (gain <= 0.0) continue;

            int price = mall_price(source);
            if (price <= 0 || price > max_price || spent + price > total_cap) continue;
            if (best_item == $item[none]
                || (price * best_gain) < (best_price * gain)) {
                best_price = price;
                best_gain = gain;
                best_item = source;
                best_effect = ef;
            }
        }

        if (best_item == $item[none]) break;
        print("Using " + best_item + " (" + best_price + " Meat, +" + best_gain + " "
            + PEARL_MODIFIERS[zone_index] + ") as a Leg2 resistance potion rescue for "
            + PEARL_LOCATIONS[zone_index] + ".", "teal");
        ensure_effect_from_item(best_effect, best_item, 1, max_price, "Leg2 resistance potion rescue");
        spent = spent + best_price;
        used_any = true;
        resistance = numeric_modifier(PEARL_MODIFIERS[zone_index]);
    }

    if (!used_any) {
        print("No capped resistance potion rescue found for "
            + PEARL_MODIFIERS[zone_index] + ".", "yellow");
    } else {
        print("Leg2 resistance potion rescue spent at most " + spent
            + " Meat and reached " + resistance + " " + PEARL_MODIFIERS[zone_index] + ".", "teal");
    }
    return used_any;
}

string leg2_pearl_maximizer(int zone_index) {
    string expression = "min " + pref_int("leg2PearlResTarget", 18) + " " + PEARL_MAXIMIZERS[zone_index]
        + ", equip " + COZY_BAZOOKA
        + ", equip " + GOGGLES_OF_LOATHING
        + ", equip " + AQUAMARINERS_NECKLACE
        + ", equip " + AQUAMARINERS_RING
        + ", equip " + TEFLON_SWIM_FINS;
    if (have_item_or_equipped(PANTOGRAM_PANTS)) {
        expression = expression + ", equip " + PANTOGRAM_PANTS;
    }
    return expression
        + ", " + leg2_pearl_familiar_lock()
        + ", " + pref_string("leg2PressureMaximizer", "meat drop penalty, item drop penalty, initiative penalty, sea")
        + ", meat drop, -tie";
}

void verify_leg2_pearl_locked_gear() {
    if (!have_equipped(COZY_BAZOOKA)) abort("Leg2 pearl outfit did not equip " + COZY_BAZOOKA + ".");
    if (!have_equipped(GOGGLES_OF_LOATHING)) abort("Leg2 pearl outfit did not equip " + GOGGLES_OF_LOATHING + ".");
    if (have_item_or_equipped(PANTOGRAM_PANTS) && !have_equipped(PANTOGRAM_PANTS)) {
        abort("Leg2 pearl outfit did not equip " + PANTOGRAM_PANTS + ".");
    }
    if (!have_equipped(AQUAMARINERS_NECKLACE)) abort("Leg2 pearl outfit did not equip " + AQUAMARINERS_NECKLACE + ".");
    if (!have_equipped(AQUAMARINERS_RING)) abort("Leg2 pearl outfit did not equip " + AQUAMARINERS_RING + ".");
    if (!have_equipped(TEFLON_SWIM_FINS)) abort("Leg2 pearl outfit did not equip " + TEFLON_SWIM_FINS + ".");
    verify_leg2_pearl_familiar();
}

void maximize_leg2_pearl_outfit(int zone_index) {
    string expression = leg2_pearl_maximizer(zone_index);
    print("Leg2 pearl maximizer: " + expression, "teal");
    if (!maximize(expression, false)) {
        abort("Maximizer rejected the Leg2 pearl outfit for " + PEARL_LOCATIONS[zone_index] + ".");
    }
    verify_leg2_pearl_locked_gear();
}

void equip_leg2_pearl_outfit(int zone_index) {
    ensure_leg2_pressure_gear();
    ensure_leg2_pearl_familiar();
    maximize_leg2_pearl_outfit(zone_index);

    float resistance = numeric_modifier(PEARL_MODIFIERS[zone_index]);
    int target = pref_int("leg2PearlResTarget", 18);
    if (resistance < target && try_leg2_resistance_potion_rescue(zone_index, resistance)) {
        maximize_leg2_pearl_outfit(zone_index);
        resistance = numeric_modifier(PEARL_MODIFIERS[zone_index]);
    }

    if (resistance < target) {
        abort("Leg2 pearl outfit only reaches " + resistance + " "
            + PEARL_MODIFIERS[zone_index] + " in " + PEARL_LOCATIONS[zone_index] + ".");
    }
}

boolean [int] leg2_target_pearl_zones() {
    boolean [int] targets;
    string mode = pref_string("leg2PearlMode", "FARM").to_upper_case();
    if (mode == "REPORT" || mode == "NEVER") return targets;
    if (mode != "FARM" && mode != "ALWAYS") {
        abort("Invalid " + PREF + "leg2PearlMode=" + mode + ". Use REPORT, NEVER, FARM, or ALWAYS.");
    }

    int remaining = (mode == "ALWAYS") ? 5 : pref_int("leg2PearlTargetCount", 5);
    foreach zone_index, loc in PEARL_LOCATIONS {
        if (remaining <= 0) break;
        if (pearl_zone_complete(zone_index)) continue;
        targets[zone_index] = true;
        remaining = remaining - 1;
    }
    return targets;
}

int first_leg2_target_pearl_zone() {
    boolean [int] targets = leg2_target_pearl_zones();
    foreach zone_index, loc in PEARL_LOCATIONS {
        if (targets[zone_index]) return zone_index;
    }
    return -1;
}

int projected_leg2_pearl_combats() {
    int result = 0;
    boolean [int] targets = leg2_target_pearl_zones();
    foreach zone_index, loc in PEARL_LOCATIONS {
        if (targets[zone_index]) {
            result = result + projected_pearl_combats_for_zone(zone_index);
        }
    }
    return result;
}

int leg2_pearl_budget() {
    int combats = projected_leg2_pearl_combats();
    if (combats <= 0) return 0;
    return combats + pref_int("leg2PearlBuffer", 10);
}

string default_leg2_pearl_ccs_name() {
    return "LoopTheSeaPearl";
}

string leg2_pearl_ccs_name() {
    return pref_string("postRunPearlCombatScript", default_leg2_pearl_ccs_name());
}

void ensure_default_leg2_pearl_ccs() {
    write_ccs(to_buffer("consult LoopTheSeaPearlCCS.ash\nabort"), default_leg2_pearl_ccs_name());
}

void install_leg2_pearl_ccs() {
    string ccs = leg2_pearl_ccs_name();
    if (ccs.to_upper_case() == "NONE") {
        print("Using current KoLmafia combat settings for Leg2 pearls by "
            + PREF + "postRunPearlCombatScript=NONE.", "yellow");
        return;
    }

    if (ccs == default_leg2_pearl_ccs_name()) ensure_default_leg2_pearl_ccs();
    if (!set_ccs(ccs)) abort("Unable to set Leg2 pearl CCS: " + ccs + ".");
    set_property("battleAction", "custom combat script");
}

void cure_leg2_the_colors() {
    if (!pref_bool("leg2PearlCureTheColors", true)) return;
    if (have_effect($effect[The Colors...]) <= 0) return;

    ensure_inventory_item(SOFT_GREEN_ECHO_EYEDROP_ANTIDOTE, 1,
        pref_int("leg2NegativeEffectCureMaxPrice", 5000), "Leg2 negative effect cure");
    print("Removing The Colors... before Leg2 pearl farming.", "teal");
    cli_execute("uneffect The Colors...");
    if (have_effect($effect[The Colors...]) > 0) {
        abort("Unable to remove The Colors... before Leg2 pearl farming.");
    }
}

void recover_leg2_pearl_turn() {
    cure_leg2_the_colors();

    if (pref_bool("leg2PearlCureBeatenUp", true)
        && have_effect($effect[Beaten Up]) > 0) {
        if (have_skill($skill[Tongue of the Walrus])) {
            use_skill($skill[Tongue of the Walrus]);
        }
        if (have_effect($effect[Beaten Up]) > 0) {
            cli_execute("uneffect Beaten Up");
        }
        if (have_effect($effect[Beaten Up]) > 0) {
            abort("Unable to remove Beaten Up before Leg2 pearl farming.");
        }
    }

    int hp_percent = pref_int("leg2PearlRecoverHpPercent", 95);
    hp_percent = max(1, min(100, hp_percent));
    int hp_target = max(1, (my_maxhp() * hp_percent + 99) / 100);
    if (my_hp() < hp_target) {
        print("Recovering HP for Leg2 pearl farming: " + my_hp()
            + "/" + hp_target + ".", "teal");
        restore_hp(hp_target);
    }
    if (my_hp() < hp_target) {
        abort("HP recovery failed before Leg2 pearl farming: " + my_hp()
            + "/" + hp_target + ".");
    }

    int mp_target = pref_int("leg2PearlRecoverMpTarget", 120);
    if (mp_target > 0) {
        mp_target = min(mp_target, my_maxmp());
        if (my_mp() < mp_target) {
            print("Recovering MP for Leg2 pearl farming: " + my_mp()
                + "/" + mp_target + ".", "teal");
            restore_mp(mp_target);
        }
        if (my_mp() < mp_target) {
            abort("MP recovery failed before Leg2 pearl farming: " + my_mp()
                + "/" + mp_target + ".");
        }
    }
}

void cure_beaten_up_for_context(string context) {
    if (have_effect($effect[Beaten Up]) <= 0) return;

    print(context + ": removing Beaten Up before continuing.", "yellow");
    if (have_skill($skill[Tongue of the Walrus])) {
        use_skill($skill[Tongue of the Walrus]);
    }
    if (have_effect($effect[Beaten Up]) > 0) {
        cli_execute("uneffect Beaten Up");
    }
    if (have_effect($effect[Beaten Up]) > 0) {
        abort(context + ": unable to remove Beaten Up.");
    }
}

void recover_for_leg2_garbo() {
    cure_beaten_up_for_context("Leg2 Garbo");
    if (my_hp() < my_maxhp()) {
        print("Recovering HP before Leg2 Garbo: " + my_hp()
            + "/" + my_maxhp() + ".", "teal");
        restore_hp(my_maxhp());
    }
    if (my_hp() <= 0 || have_effect($effect[Beaten Up]) > 0) {
        abort("Leg2 Garbo recovery failed.");
    }
}

string leg2_consume_command(boolean simulate) {
    string command = pref_string("leg2ConsumeCommand", "CONSUME ALL");
    if (pref_bool("leg2UseWetDatesRollover", false)) {
        if (command != "CONSUME ALL") {
            abort(PREF + "leg2UseWetDatesRollover=true currently requires "
                + PREF + "leg2ConsumeCommand=CONSUME ALL.");
        }
        int fullness = max(0, fullness_limit() - my_fullness() - 1);
        int liver = max(0, inebriety_limit() - my_inebriety());
        int spleen = max(0, spleen_limit() - my_spleen_use());
        command = "CONSUME ORGANS " + fullness + " " + liver + " " + spleen;
    }
    if (simulate) command = command + " SIM";
    return command;
}

int consume_simulation_lower_bound(string command, boolean require_spleen_only) {
    string output = cli_execute_output(command);

    matcher organs = create_matcher("In total, you're filling up ([0-9]+) fullness, ([0-9]+) liver, and ([0-9]+) spleen", output);
    if (!organs.find()) {
        print("Unable to parse organ usage from " + command + ".", "yellow");
        return -1;
    }
    if (require_spleen_only
        && (organs.group(1).to_int() != 0 || organs.group(2).to_int() != 0)) {
        print(command + " unexpectedly includes fullness or liver; refusing to value marginal spleen from it.", "yellow");
        return -1;
    }

    matcher yield_match = create_matcher("Adventure yield should be roughly ([0-9]+)-([0-9]+)", output);
    if (!yield_match.find()) {
        print("Unable to parse adventure yield from " + command + ".", "yellow");
        return -1;
    }
    return yield_match.group(1).to_int();
}

int marginal_spleen_adventure_lower_bound() {
    int remaining = max(0, spleen_limit() - my_spleen_use());
    if (remaining <= 0) return -1;

    int full_lower_bound = consume_simulation_lower_bound(
        "CONSUME ORGANS 0 0 " + remaining + " SIM", true);
    int reduced_lower_bound = remaining <= 1
        ? 0
        : consume_simulation_lower_bound(
            "CONSUME ORGANS 0 0 " + (remaining - 1) + " SIM", true);
    if (full_lower_bound < 0 || reduced_lower_bound < 0) return -1;
    return max(0, full_lower_bound - reduced_lower_bound);
}

boolean maybe_preconsume_leg2_fishy_topup() {
    int projected_combats = projected_leg2_pearl_combats();
    int cheap_turns = cheap_fishy_turns_available();
    int bofa_turns = leg2_bofa_fishy_projected_turns();
    int deficit = max(0, projected_combats - cheap_turns);
    if (deficit <= 0) {
        print("No paid Fishy top-up is projected before Leg2 consume: "
            + cheap_turns + "/" + projected_combats + " turns available.", "green");
        return false;
    }
    if (bofa_turns >= deficit) {
        print("Skipping paid pre-consume Fishy top-up: Seal Clubber BOFA can cover "
            + deficit + " projected Fishy turn(s) with up to " + bofa_turns
            + " turn(s) available from Monodent some fish.", "green");
        return false;
    }

    string mode = pref_string("leg2FishyTopupMode", "AUTO").to_upper_case();
    if (mode != "AUTO" && mode != "FISH_SAUCE" && mode != "GILL_TEA") {
        abort("Invalid " + PREF + "leg2FishyTopupMode=" + mode
            + ". Use AUTO, FISH_SAUCE, or GILL_TEA.");
    }
    if (mode == "GILL_TEA") {
        print("Leaving " + deficit + " projected Fishy turn(s) for Gill tea by "
            + PREF + "leg2FishyTopupMode=GILL_TEA.", "yellow");
        return false;
    }
    if (my_spleen_use() >= spleen_limit()) {
        print("Cannot use fish sauce before Leg2 consume because spleen is already full; "
            + "Gill tea remains the fallback.", "yellow");
        return false;
    }

    int sauce_price = mall_price(FISH_SAUCE);
    int sauce_cap = pref_int("leg2FishSauceMaxPrice", 10000);
    if (sauce_price <= 0 || sauce_price > sauce_cap) {
        print("Fish sauce is not eligible for the Leg2 Fishy top-up: mall price "
            + sauce_price + " Meat; configured cap " + sauce_cap
            + ". Gill tea remains the fallback.", "yellow");
        return false;
    }

    boolean use_sauce = mode == "FISH_SAUCE";
    if (mode == "AUTO") {
        int lost_adventures = marginal_spleen_adventure_lower_bound();
        if (lost_adventures < 0) {
            print("Could not establish a trustworthy marginal spleen adventure value; "
                + "preserving spleen and leaving Gill tea as the fallback.", "yellow");
            return false;
        }

        int adventure_value = leg2_fishy_value_of_adventure();
        int sauce_effective_cost = sauce_price + lost_adventures * adventure_value;
        int tea_price = mall_price(FISHY_TEA);
        int tea_cap = pref_int("leg2GillTeaMaxPrice", 100000);
        print("Leg2 Fishy AUTO comparison: need " + deficit + " paid turn(s); fish sauce "
            + sauce_price + " Meat + " + lost_adventures + " marginal spleen adventure(s) * "
            + adventure_value + " Meat = " + sauce_effective_cost
            + " effective Meat; Gill tea=" + tea_price + " Meat.", "teal");

        use_sauce = tea_price <= 0 || tea_price > tea_cap || sauce_effective_cost < tea_price;
        if (!use_sauce) {
            print("Preserving the spleen slot for Garbo-valued adventures; Gill tea is cheaper "
                + "than fish sauce's measured opportunity cost.", "green");
            return false;
        }
    }

    ensure_inventory_item(FISH_SAUCE, 1, sauce_cap, "Leg2 pre-consume Fishy");
    int fishy_before = have_effect($effect[Fishy]);
    int spleen_before = my_spleen_use();
    print("Chewing fish sauce before Leg2 consume for the paid Fishy top-up.", "teal");
    if (!chew(1, FISH_SAUCE)) abort("Failed to chew " + FISH_SAUCE + ".");
    if (have_effect($effect[Fishy]) <= fishy_before) {
        abort(FISH_SAUCE + " did not add Fishy.");
    }
    print("Fish sauce added " + (have_effect($effect[Fishy]) - fishy_before)
        + " Fishy turn(s) and used " + (my_spleen_use() - spleen_before)
        + " spleen.", "green");
    return true;
}

int validate_leg2_consume_simulation(string sim_command, int required) {
    string output = cli_execute_output(sim_command);
    print(output);

    matcher organs = create_matcher("In total, you're filling up ([0-9]+) fullness, ([0-9]+) liver, and ([0-9]+) spleen", output);
    if (!organs.find()) abort("Unable to parse " + sim_command + " organ usage.");
    int simulated_liver = organs.group(2).to_int();
    if (!pref_bool("leg2AllowBoozeConsume", true) && simulated_liver > 0) {
        abort(sim_command + " includes " + simulated_liver + " liver, but "
            + PREF + "leg2AllowBoozeConsume=false.");
    }

    matcher yield_match = create_matcher("Adventure yield should be roughly ([0-9]+)-([0-9]+)", output);
    if (!yield_match.find()) abort("Unable to parse " + sim_command + " adventure yield.");
    int lower_bound = yield_match.group(1).to_int();
    if (my_adventures() + lower_bound < required && !pref_bool("leg2AllowRiskyConsume", false)) {
        abort("Conservative Leg2 consume lower bound would leave "
            + (my_adventures() + lower_bound) + "/" + required
            + " adventures for pearl farming. Set " + PREF
            + "leg2AllowRiskyConsume=true to run it anyway.");
    }
    return lower_bound;
}

void ensure_leg2_turn_budget() {
    int required = leg2_pearl_budget();
    if (required <= 0) return;
    boolean funded = my_adventures() >= required;
    string mode = pref_string("leg2ConsumeMode", "ALWAYS").to_upper_case();
    if (!pref_bool("leg2ConsumeBeforePearls", true)) mode = "NEVER";
    if (mode != "ALWAYS" && mode != "IF_NEEDED" && mode != "NEVER") {
        abort("Invalid " + PREF + "leg2ConsumeMode=" + mode + ". Use ALWAYS, IF_NEEDED, or NEVER.");
    }
    if (get_property(INTERNAL + "leg2ConsumeDone").to_boolean()) {
        if (!funded) {
            abort("Leg2 post-UnderTheSea consume already ran, but only " + my_adventures()
                + "/" + required + " adventures remain.");
        }
        print("Leg2 post-UnderTheSea consume already complete; turn budget is "
            + my_adventures() + "/" + required + ".", "green");
        return;
    }
    if (mode == "NEVER" || (mode == "IF_NEEDED" && funded)) {
        if (!funded) {
            abort("Leg2 pearl farming needs " + required + " adventures, but only has "
                + my_adventures() + " and consume mode is " + mode + ".");
        }
        print("Skipping Leg2 post-UnderTheSea consume by mode " + mode
            + "; turn budget is already " + my_adventures() + "/" + required + ".", "green");
        return;
    }

    profit_marker("leg2_consume_start");
    string sim_command = leg2_consume_command(true);
    validate_leg2_consume_simulation(sim_command, required);
    if (maybe_preconsume_leg2_fishy_topup()) {
        print("Re-simulating Leg2 consume after the fish sauce spleen commitment.", "teal");
        validate_leg2_consume_simulation(sim_command, required);
    }

    string command = leg2_consume_command(false);
    run_cli(command);
    if (my_inebriety() > inebriety_limit()) abort("Leg2 consume made you overdrunk; cannot run skill-capable pearl farming.");
    if (my_fullness() > fullness_limit()) abort("Leg2 consume left you overfull in the pearl outfit.");
    if (my_spleen_use() > spleen_limit()) abort("Leg2 consume left you overtoxic in the pearl outfit.");
    if (pref_bool("leg2UseWetDatesRollover", false)
        && fullness_limit() - my_fullness() < 1) {
        abort("Leg2 consume did not preserve the final fullness slot for " + PILE_OF_WET_DATES + ".");
    }
    if (my_adventures() < required) {
        abort("Leg2 consume left " + my_adventures() + "/" + required
            + " adventures for pearl farming.");
    }
    set_property(INTERNAL + "leg2ConsumeDone", "true");
    profit_marker("leg2_consume_done");
    print("Leg2 pearl turn budget funded: " + my_adventures()
        + "/" + required + " adventures.", "green");
}

int farm_leg2_pearl_zone(int zone_index, int noncombats_remaining) {
    if (pearl_zone_complete(zone_index)) return noncombats_remaining;

    set_property(INTERNAL + "leg2PearlBudgetFloor", "" + leg2_pearl_budget());
    cure_leg2_the_colors();
    ensure_leg2_fishy();
    ensure_leg2_pressure_effects();
    ensure_leg2_resistance_buffs(zone_index);
    equip_leg2_pearl_outfit(zone_index);
    print("Farming Leg2 pearl zone: " + PEARL_LOCATIONS[zone_index] + ".", "teal");

    while (!pearl_zone_complete(zone_index)) {
        if (my_adventures() <= 0) abort("Ran out of adventures while farming Leg2 pearls.");

        cure_leg2_the_colors();
        set_property(INTERNAL + "leg2PearlBudgetFloor", "" + leg2_pearl_budget());
        ensure_leg2_fishy();
        ensure_leg2_pressure_effects();
        ensure_leg2_resistance_buffs(zone_index);
        equip_leg2_pearl_outfit(zone_index);
        recover_leg2_pearl_turn();
        if (!can_adventure(PEARL_LOCATIONS[zone_index])) {
            abort("Cannot adventure in " + PEARL_LOCATIONS[zone_index]
                + ". Check Sea Floor access and Fishy/underwater access.");
        }

        int adventures_before = my_adventures();
        string combat_before = get_property("_lastCombatStarted");
        float progress_before = pearl_zone_progress(zone_index);

        if (!adventure(1, PEARL_LOCATIONS[zone_index])) {
            abort("Adventure failed or timed out in " + PEARL_LOCATIONS[zone_index] + ".");
        }

        int adventures_spent = adventures_before - my_adventures();
        if (adventures_spent != 1) {
            abort("Expected one adventure in " + PEARL_LOCATIONS[zone_index]
                + ", but spent " + adventures_spent + ".");
        }

        string combat_after = get_property("_lastCombatStarted");
        if (combat_after != combat_before) {
            if (get_property("_lastCombatLost").to_boolean()
                || !get_property("_lastCombatWon").to_boolean()) {
                abort("Combat failed or timed out in " + PEARL_LOCATIONS[zone_index] + ".");
            }

            float progress_after = pearl_zone_progress(zone_index);
            float progress_gain = progress_after - progress_before;
            if (!pearl_zone_complete(zone_index) && progress_gain < 9.999) {
                if (progress_gain > 0.001) {
                    print("Combat in " + PEARL_LOCATIONS[zone_index]
                        + " advanced pearl progress by only " + progress_gain
                        + "%. Before: " + progress_before + "; after: "
                        + progress_after + ". Continuing after recovery.", "yellow");
                } else {
                    abort("Combat in " + PEARL_LOCATIONS[zone_index]
                        + " did not advance pearl progress. Before: " + progress_before
                        + "; after: " + progress_after + ".");
                }
            }
        } else {
            noncombats_remaining = noncombats_remaining - 1;
            if (noncombats_remaining < 0) abort("Leg2 pearl farming exceeded the noncombat buffer.");
        }
    }

    print("Obtained Leg2 pearl from " + PEARL_LOCATIONS[zone_index] + ".", "green");
    return noncombats_remaining;
}

boolean source_terminal_extract_active() {
    return get_property("sourceTerminalEducate1") == "extract.edu"
        || get_property("sourceTerminalEducate2") == "extract.edu";
}

void ensure_leg2_extract_education() {
    if (!pref_bool("leg2UseExtract", true)) {
        print("Source Terminal Extract skipped by " + PREF + "leg2UseExtract=false.", "yellow");
        return;
    }
    if (source_terminal_extract_active()) {
        print("Source Terminal Extract is already educated for Leg2 pearls.", "green");
        return;
    }
    if (!get_property("sourceTerminalEducateKnown").contains_text("extract.edu")) {
        print("Source Terminal Extract is not known; continuing without it.", "yellow");
        return;
    }

    int [item] campground = get_campground();
    if (campground[SOURCE_TERMINAL] <= 0) {
        print("Source Terminal is not installed; continuing without Extract.", "yellow");
        return;
    }

    print("Educating Source Terminal Extract for Leg2 pearl farming.", "teal");
    if (!cli_execute("terminal educate extract.edu") || !source_terminal_extract_active()) {
        print("Unable to educate Source Terminal Extract; continuing with the remaining pearl CCS.", "yellow");
        return;
    }
    print("Source Terminal Extract is active for Leg2 pearl farming.", "green");
}

void farm_leg2_pearls() {
    string mode = pref_string("leg2PearlMode", "FARM").to_upper_case();
    if (mode == "REPORT" || mode == "NEVER") {
        print("Leg2 pearl farming skipped by " + PREF + "leg2PearlMode=" + mode + ".", "yellow");
        return;
    }

    profit_marker("leg2_pearls_start");
    ensure_leg2_extract_education();

    string previous_ccs = get_property("customCombatScript");
    string previous_battle_action = get_property("battleAction");
    install_leg2_pearl_ccs();

    try {
        int noncombats_remaining = pref_int("leg2PearlBuffer", 10);
        boolean [int] targets = leg2_target_pearl_zones();
        foreach zone_index, loc in PEARL_LOCATIONS {
            if (targets[zone_index]) {
                noncombats_remaining = farm_leg2_pearl_zone(zone_index, noncombats_remaining);
            }
        }
    } finally {
        set_ccs(previous_ccs);
        set_property("battleAction", previous_battle_action);
    }

    profit_marker("leg2_pearls_done");
}

void run_leg2_garbo() {
    if (get_property(INTERNAL + "leg2GarboDone").to_boolean()) {
        print("Leg2 Garbo is already complete.", "green");
        return;
    }
    if (!pref_bool("leg2GarboAfterPearls", true)) {
        print("Skipping Leg2 Garbo by " + PREF + "leg2GarboAfterPearls=false.", "yellow");
        set_property(INTERNAL + "leg2GarboDone", "true");
        return;
    }

    if (my_adventures() <= 0) {
        print("No adventures remain for Leg2 Garbo.", "yellow");
        set_property(INTERNAL + "leg2GarboDone", "true");
        return;
    }

    profit_marker("leg2_garbo_start");
    recover_for_leg2_garbo();
    run_cli(pref_string("leg2GarboCommand", "garbo"));
    if (pref_bool("leg2RequireGarboSpendAllTurns", true) && my_adventures() > 0) {
        abort("Leg2 Garbo left " + my_adventures()
            + " adventures. Rollover automation requires plain Garbo to finish all profitable turns.");
    }
    set_property(INTERNAL + "leg2GarboDone", "true");
    profit_marker("leg2_garbo_done");
}

void run_leg2_rollover_hook() {
    if (get_property(INTERNAL + "leg2RolloverHookDone").to_boolean()) {
        print("Leg2 pre-Garbo rollover hook is already complete.", "green");
        return;
    }
    string command = pref_string("leg2RolloverCommand", "");
    if (command == "") {
        print("No Leg2 rollover command configured.", "gray");
        set_property(INTERNAL + "leg2RolloverHookDone", "true");
        return;
    }

    print("Running the configured rollover hook before Leg2 Garbo so generated turns are profitable.", "teal");
    run_cli(command);
    set_property(INTERNAL + "leg2RolloverHookDone", "true");
}

void use_stooper_for_leg2_nightcap() {
    if (!have_familiar(STOOPER)) abort("Leg2 final nightcap requires Stooper.");
    use_familiar(STOOPER);
    if (my_familiar() != STOOPER) abort("Unable to switch to Stooper for the Leg2 final nightcap.");
}

void eat_leg2_rollover_wet_dates() {
    if (!pref_bool("leg2UseWetDatesRollover", false)) return;
    if (have_effect($effect[A Date With Tomorrow]) > 0) {
        print("A Date With Tomorrow is already active for rollover.", "green");
        return;
    }
    if (fullness_limit() - my_fullness() < 1) {
        abort("No fullness remains for the configured final " + PILE_OF_WET_DATES + ".");
    }

    ensure_inventory_item(PILE_OF_WET_DATES, 1,
        pref_int("leg2WetDatesMaxPrice", 40000), "Leg2 rollover");
    int adventures_before = my_adventures();
    print("Eating " + PILE_OF_WET_DATES + " as the final Leg2 food.", "teal");
    if (!eat(1, PILE_OF_WET_DATES)) abort("Failed to eat " + PILE_OF_WET_DATES + ".");
    if (have_effect($effect[A Date With Tomorrow]) <= 0) {
        abort(PILE_OF_WET_DATES + " did not grant A Date With Tomorrow.");
    }
    print(PILE_OF_WET_DATES + " gained " + (my_adventures() - adventures_before)
        + " immediate adventure(s) and secured +10 rollover adventures.", "green");
}

string leg2_organ_lock_maximizer() {
    return "equip angelbone totem, equip Drunkula's wineglass, equip devilbone corset, "
        + "equip devilbone greaves, equip angelbone chopsticks";
}

boolean leg2_expanded_organs_locked() {
    return pref_bool("leg2RunExpandedOrgansRollover", true)
        && pref_bool("leg2KeepOrganGearForRollover", false)
        && get_property(INTERNAL + "leg2ExpandedOrgansDone").to_boolean();
}

void verify_leg2_organ_lock(string context) {
    if (equipped_item($slot[weapon]) != ANGELBONE_TOTEM) {
        abort(context + ": angelbone totem is not equipped.");
    }
    if (equipped_item($slot[off-hand]) != WINEGLASS) {
        abort(context + ": Drunkula's wineglass is not equipped.");
    }
    if (equipped_item($slot[shirt]) != DEVILBONE_CORSET) {
        abort(context + ": devilbone corset is not equipped.");
    }
    if (equipped_item($slot[pants]) != DEVILBONE_GREAVES) {
        abort(context + ": devilbone greaves are not equipped.");
    }
    if (equipped_item($slot[acc1]) != ANGELBONE_CHOPSTICKS) {
        abort(context + ": angelbone chopsticks are not equipped.");
    }
    if (my_fullness() > fullness_limit()) {
        abort(context + ": fullness " + my_fullness() + " exceeds limit " + fullness_limit() + ".");
    }
    if (my_spleen_use() > spleen_limit()) {
        abort(context + ": spleen use " + my_spleen_use() + " exceeds limit " + spleen_limit() + ".");
    }
}

void equip_leg2_organ_lock() {
    string context = "Leg2 rollover organ lock";
    equip_required($slot[weapon], ANGELBONE_TOTEM, context);
    equip_required($slot[off-hand], WINEGLASS, context);
    equip_required($slot[shirt], DEVILBONE_CORSET, context);
    equip_required($slot[pants], DEVILBONE_GREAVES, context);
    equip_required($slot[acc1], ANGELBONE_CHOPSTICKS, context);
    verify_leg2_organ_lock(context);
}

string leg2_expanded_organ_command(int fullness, int spleen, boolean simulate) {
    string command = "CONSUME ORGANS " + fullness + " 0 " + spleen;
    if (simulate) command = command + " SIM";
    return command;
}

void validate_leg2_expanded_organ_simulation(string command, int expected_fullness, int expected_spleen) {
    string output = cli_execute_output(command);
    print(output);

    matcher organs = create_matcher("In total, you're filling up ([0-9]+) fullness, ([0-9]+) liver, and ([0-9]+) spleen", output);
    if (!organs.find()) abort("Unable to parse " + command + " organ usage.");

    int simulated_fullness = organs.group(1).to_int();
    int simulated_liver = organs.group(2).to_int();
    int simulated_spleen = organs.group(3).to_int();
    if (simulated_liver != 0) {
        abort(command + " unexpectedly includes " + simulated_liver + " liver.");
    }
    if (simulated_fullness != expected_fullness || simulated_spleen != expected_spleen) {
        abort(command + " expected " + expected_fullness + " fullness and "
            + expected_spleen + " spleen, but simulation returned "
            + simulated_fullness + " fullness and " + simulated_spleen + " spleen.");
    }
}

void run_leg2_expanded_organs_rollover() {
    if (get_property(INTERNAL + "leg2ExpandedOrgansDone").to_boolean()) {
        print("Leg2 expanded-organ rollover consume is already complete.", "green");
        if (leg2_expanded_organs_locked()) equip_leg2_organ_lock();
        return;
    }
    if (!pref_bool("leg2RunExpandedOrgansRollover", true)) {
        print("Skipping Leg2 expanded-organ rollover consume by "
            + PREF + "leg2RunExpandedOrgansRollover=false.", "yellow");
        set_property(INTERNAL + "leg2ExpandedOrgansDone", "true");
        return;
    }

    equip_leg2_organ_lock();
    int fullness = max(0, fullness_limit() - my_fullness());
    int spleen = max(0, spleen_limit() - my_spleen_use());
    boolean eat_wet_dates = pref_bool("leg2UseWetDatesRollover", false)
        && have_effect($effect[A Date With Tomorrow]) <= 0;
    int consume_fullness = fullness - (eat_wet_dates ? 1 : 0);
    if (consume_fullness < 0) {
        abort("No expanded fullness remains for the configured final " + PILE_OF_WET_DATES + ".");
    }
    if (fullness <= 0 && spleen <= 0) {
        abort("Leg2 expanded-organ rollover consume found no remaining +stomach or +spleen capacity while wearing the organ-lock set.");
    }

    string sim_command = leg2_expanded_organ_command(consume_fullness, spleen, true);
    validate_leg2_expanded_organ_simulation(sim_command, consume_fullness, spleen);
    run_cli(leg2_expanded_organ_command(consume_fullness, spleen, false));
    equip_leg2_organ_lock();
    if (eat_wet_dates) {
        eat_leg2_rollover_wet_dates();
        equip_leg2_organ_lock();
    }

    if (my_fullness() != fullness_limit()) {
        abort("Leg2 expanded-organ consume left fullness at "
            + my_fullness() + "/" + fullness_limit() + ".");
    }
    if (my_spleen_use() != spleen_limit()) {
        abort("Leg2 expanded-organ consume left spleen at "
            + my_spleen_use() + "/" + spleen_limit() + ".");
    }

    set_property(INTERNAL + "leg2ExpandedOrgansDone", "true");
    set_property(INTERNAL + "leg2RolloverDone", "false");
    if (pref_bool("leg2KeepOrganGearForRollover", false)) {
        print("Leg2 expanded-organ rollover consume complete; organ gear remains locked by configuration.", "green");
    } else {
        print("Leg2 expanded-organ rollover consume complete; organ gear may now be released for rollover maximization.", "green");
    }
}

void run_leg2_final_nightcap() {
    if (get_property(INTERNAL + "leg2NightcapDone").to_boolean()) {
        print("Leg2 final nightcap is already complete.", "green");
        return;
    }
    if (!pref_bool("leg2RunFinalNightcap", true)) {
        print("Skipping Leg2 final nightcap by " + PREF + "leg2RunFinalNightcap=false.", "yellow");
        set_property(INTERNAL + "leg2NightcapDone", "true");
        return;
    }
    if (pref_bool("leg2RequireGarboSpendAllTurns", true) && my_adventures() > 0) {
        abort("Refusing the final nightcap while " + my_adventures()
            + " profitable Leg2 adventure(s) remain.");
    }

    if (my_inebriety() <= inebriety_limit()) {
        use_stooper_for_leg2_nightcap();
        print("Maximizing +liver for the final Leg2 nightcap.", "teal");
        if (!maximize("+liver, -tie", false)) abort("Unable to maximize +liver for the Leg2 nightcap.");
        use_stooper_for_leg2_nightcap();
        if (!pref_bool("leg2RunExpandedOrgansRollover", true)) eat_leg2_rollover_wet_dates();
        run_cli(pref_string("leg2FinalNightcapCommand", "CONSUME NIGHTCAP"));
    } else {
        if (!pref_bool("leg2RunExpandedOrgansRollover", true)) eat_leg2_rollover_wet_dates();
        print("Character is already overdrunk; treating the final Leg2 nightcap as complete.", "yellow");
    }
    if (my_inebriety() <= inebriety_limit()) {
        abort("Final Leg2 nightcap did not produce an overdrunk state.");
    }
    set_property(INTERNAL + "leg2NightcapDone", "true");
}

int rollover_campground_adventures() {
    int result = 0;
    string dwelling = visit_url("campground.php?action=inspectdwelling");
    if (dwelling.contains_text("maid2.gif")) {
        result = result + 8;
    } else if (dwelling.contains_text("maid.gif")) {
        result = result + 4;
    }
    if (dwelling.contains_text("Cuckooclock.gif")) result = result + 3;
    if (visit_url("campground.php").contains_text("pagoda.gif")) result = result + 3;
    if (get_property("_borrowedTimeUsed").to_boolean()) result = result - 20;
    return result;
}

int projected_rollover_adventures() {
    int gear_and_passives = numeric_modifier("Adventures");
    return my_adventures() + 40 + gear_and_passives + rollover_campground_adventures();
}

void maximize_leg2_rollover() {
    string expression = pref_string("leg2RolloverMaximizer", "adv, 0.001 pvp fights, -tie");
    if (leg2_expanded_organs_locked()) {
        expression = expression + ", " + leg2_organ_lock_maximizer();
    }
    print("Leg2 rollover maximizer: " + expression, "teal");
    if (!maximize(expression, false)) abort("Unable to maximize the Leg2 rollover outfit.");
    if (leg2_expanded_organs_locked()) {
        verify_leg2_organ_lock("After Leg2 rollover maximizer");
    }
}

void burn_leg2_rollover_overflow(int overflow) {
    if (overflow <= 0) return;
    if (leg2_expanded_organs_locked()) {
        abort("Projected rollover exceeds the cap by " + overflow
            + " adventure(s), but the expanded-organ rollover consume is complete and its gear cannot be removed.");
    }
    if (have_effect($effect[A Date With Tomorrow]) > 0) {
        abort("Projected rollover exceeds the cap by " + overflow
            + " adventure(s), but spending a turn would remove A Date With Tomorrow.");
    }
    if (my_adventures() < overflow) {
        abort("Projected rollover exceeds the cap by " + overflow
            + " adventure(s), but only " + my_adventures() + " can be spent.");
    }
    string command = pref_string("leg2OverflowGarboCommand", "garbo nodiet");
    print("Burning " + overflow + " rollover-overflow adventure(s) with " + command + ".", "teal");
    run_cli(command + " turns=" + overflow);
}

void run_leg1_rollover_hook() {
    if (get_property(INTERNAL + "leg1RolloverHookDone").to_boolean()) {
        print("Leg1 rollover hook is already complete.", "green");
        return;
    }
    string command = pref_string("leg1RolloverCommand", "");
    if (command == "") {
        print("No Leg1 rollover hook configured.", "gray");
        set_property(INTERNAL + "leg1RolloverHookDone", "true");
        return;
    }

    print("Running the configured Leg1 rollover hook.", "teal");
    run_cli(command);
    set_property(INTERNAL + "leg1RolloverHookDone", "true");
}

void maximize_leg1_rollover() {
    string expression = pref_string("leg1RolloverMaximizer", "adv, 0.001 pvp fights, -tie");
    print("Leg1 rollover maximizer: " + expression, "teal");
    if (!maximize(expression, false)) abort("Unable to maximize the Leg1 rollover outfit.");
}

void burn_leg1_rollover_overflow(int overflow) {
    if (overflow <= 0) return;
    if (have_effect($effect[A Date With Tomorrow]) > 0) {
        abort("Projected Leg1 rollover exceeds the cap by " + overflow
            + " adventure(s), but spending a turn would remove A Date With Tomorrow.");
    }
    if (my_adventures() < overflow) {
        abort("Projected Leg1 rollover exceeds the cap by " + overflow
            + " adventure(s), but only " + my_adventures() + " can be spent.");
    }
    string command = pref_string("leg1OverflowGarboCommand", "garbo nodiet");
    if (command == "") {
        abort("Projected Leg1 rollover exceeds the cap by " + overflow
            + " adventure(s), but " + PREF + "leg1OverflowGarboCommand is blank.");
    }

    print("Burning " + overflow + " Leg1 rollover-overflow adventure(s) with " + command + ".", "teal");
    run_cli(command + " turns=" + overflow);
}

void prepare_leg1_rollover() {
    if (get_property(INTERNAL + "leg1RolloverDone").to_boolean()) {
        print("Leg1 rollover preparation is already complete.", "green");
        return;
    }
    if (!pref_bool("leg1PrepareRollover", true)) {
        print("Skipping Leg1 rollover preparation by " + PREF + "leg1PrepareRollover=false.", "yellow");
        set_property(INTERNAL + "leg1RolloverDone", "true");
        return;
    }

    int cap = pref_int("leg1RolloverAdventureCap", 200);
    if (cap <= 0) abort(PREF + "leg1RolloverAdventureCap must be positive.");
    for attempt from 1 to 3 {
        maximize_leg1_rollover();
        int gear_and_passives = numeric_modifier("Adventures");
        int campground_turns = rollover_campground_adventures();
        int projected = projected_rollover_adventures();
        int overflow = max(0, projected - cap);
        string color = "green";
        if (overflow > 0) color = "red";
        print("Projected Leg1 rollover adventures: " + projected + "/" + cap
            + " (held " + my_adventures() + ", equipment/passives "
            + gear_and_passives + ", campground/borrowed-time "
            + campground_turns + ", base 40).", color);
        if (overflow <= 0) {
            set_property(INTERNAL + "leg1RolloverDone", "true");
            return;
        }
        burn_leg1_rollover_overflow(overflow);
    }
    abort("Unable to reach the configured Leg1 rollover adventure cap after three overflow burns.");
}

void prepare_leg2_rollover() {
    if (get_property(INTERNAL + "leg2RolloverDone").to_boolean()) {
        print("Leg2 rollover preparation is already complete.", "green");
        return;
    }
    if (!pref_bool("leg2PrepareRollover", true)) {
        print("Skipping Leg2 rollover preparation by " + PREF + "leg2PrepareRollover=false.", "yellow");
        set_property(INTERNAL + "leg2RolloverDone", "true");
        return;
    }

    int cap = pref_int("leg2RolloverAdventureCap", 200);
    if (cap <= 0) abort(PREF + "leg2RolloverAdventureCap must be positive.");
    for attempt from 1 to 3 {
        maximize_leg2_rollover();
        int gear_and_passives = numeric_modifier("Adventures");
        int campground_turns = rollover_campground_adventures();
        int projected = projected_rollover_adventures();
        int overflow = max(0, projected - cap);
        string color = "green";
        if (overflow > 0) color = "red";
        print("Projected rollover adventures: " + projected + "/" + cap
            + " (held " + my_adventures() + ", equipment/passives "
            + gear_and_passives + ", campground/borrowed-time "
            + campground_turns + ", base 40).", color);
        if (overflow <= 0) {
            set_property(INTERNAL + "leg2RolloverDone", "true");
            return;
        }
        if (have_effect($effect[A Date With Tomorrow]) > 0) {
            print("Projected rollover exceeds the cap by " + overflow
                + " adventure(s), but A Date With Tomorrow is active. Accepting rollover truncation at "
                + cap + " rather than spending a turn and losing the effect.", "yellow");
            set_property(INTERNAL + "leg2RolloverDone", "true");
            return;
        }
        burn_leg2_rollover_overflow(overflow);
    }
    abort("Unable to reach the configured rollover adventure cap after three overflow burns.");
}

void finish_leg2_rollover() {
    if (!can_interact()) abort("Leg2 rollover finish requires can_interact=true.");
    string pearl_mode = pref_string("leg2PearlMode", "FARM").to_upper_case();
    if ((pearl_mode == "FARM" || pearl_mode == "ALWAYS")
        && projected_leg2_pearl_combats() > 0) {
        abort("Refusing the Leg2 rollover finish while "
            + projected_leg2_pearl_combats() + " projected pearl combat(s) remain.");
    }

    prefs_checkpoint("before-leg2-rollover");
    run_leg2_breakfast_sweep();
    run_leg2_rollover_hook();
    run_leg2_garbo();
    run_leg2_late_daily_sweep();
    run_leg2_final_nightcap();
    run_leg2_expanded_organs_rollover();
    prepare_leg2_rollover();
    set_property(INTERNAL + "leg2Complete", "true");
    profit_marker("leg2_done");
    profit_recap();
    print("Leg2 rollover checkpoint complete.", "green");
}

void finish_leg1_rollover() {
    if (!can_interact()) abort("Leg1 rollover finish requires can_interact=true.");
    if (!king_liberated()) abort("Leg1 rollover finish requires kingLiberated=true.");
    if (in_undersea_path()) {
        abort("Leg1 rollover finish is only for the pre-Valhalla Leg1 checkpoint.");
    }
    if (!get_property(INTERNAL + "leg1Complete").to_boolean()) {
        abort("Run `LoopTheSea leg1` before `LoopTheSea leg1rollover`.");
    }
    if (mounted_pearl_count() != 5) {
        abort("Leg1 rollover expects five mounted unblemished pearls in The Eternity Codpiece; mounted: "
            + mounted_pearl_count() + ".");
    }

    run_leg1_rollover_hook();
    prepare_leg1_rollover();
    print("Leg1 rollover checkpoint complete. This branch intentionally stops before Valhalla.", "green");
}

void leg2_after_undersea() {
    if (!can_interact()) abort("Leg2 aftercore requires can_interact=true after UnderTheSea.");
    if (get_property(INTERNAL + "leg2Complete").to_boolean()) {
        print("Leg2 automation checkpoint is already complete.", "green");
        return;
    }
    if (pref_string("leg2PearlMode", "FARM").to_upper_case() == "REPORT") {
        abort("LoopTheSea leg2 is the full automation branch, but "
            + PREF + "leg2PearlMode=REPORT would only print a report. "
            + "Set it to FARM, ALWAYS, or NEVER before running the full Leg2 branch.");
    }

    maybe_install_saltwaterbed();
    build_leg2_pantogram_pants();
    ensure_leg2_turn_budget();
    farm_leg2_pearls();
    finish_leg2_rollover();
}

boolean restore_undersea_fishy_before_resume() {
    if (!pref_bool("underTheSeaAutoRecoverFishy", true)) return false;
    if (!in_undersea_path() || king_liberated() || turns_played() < 30) return false;
    if (have_effect($effect[Fishy]) > 0
        || have_effect($effect[Driving Waterproofly]) > 0
        || get_property("_fishyPipeUsed").to_boolean()) {
        return false;
    }

    take_from_closet_if_needed(FISHY_PIPE, 1);
    if (item_amount(FISHY_PIPE) == 0 && storage_amount(FISHY_PIPE) > 0) {
        take_storage(1, FISHY_PIPE);
    }
    if (item_amount(FISHY_PIPE) == 0) {
        print("Resuming UnderTheSea without Fishy, but no Fishy Pipe could be retrieved.", "red");
        return false;
    }

    print("Resuming UnderTheSea after Fishy expired; using the unused Fishy Pipe before launch.",
        "yellow");
    if (!use(1, FISHY_PIPE) || have_effect($effect[Fishy]) <= 0) {
        print("Unable to acquire Fishy from the Fishy Pipe before resuming UnderTheSea.", "red");
        return false;
    }
    return true;
}

void run_undersea_command() {
    string command = pref_string("underTheSeaCommand", "UnderTheSea");
    string previous_choice_804 = get_property("choiceAdventure804");
    restore_undersea_fishy_before_resume();
    set_property("choiceAdventure804", "2");
    try {
        print("Running: " + command, "teal");
        run_cli(command);
    } finally {
        set_property("choiceAdventure804", previous_choice_804);
    }
}

void undersea() {
    prepare_loop_state();

    if (!in_undersea_path() && !king_liberated()) {
        abort("You are not in 11,037 Leagues Under the Sea. Ascend into that path before running this phase.");
    }

    if (!king_liberated()) {
        protect_porquoise_before_undersea();
        prefs_checkpoint("before-undersea");
        run_undersea_command();
    } else {
        print("King is already liberated; treating this as post-UnderTheSea aftercore and skipping UnderTheSea command.", "yellow");
    }

    if (!king_liberated() || !can_interact()) {
        abort("UnderTheSea command returned without completing the path; the king is not liberated or aftercore is unavailable.");
    }

    set_property(INTERNAL + "underTheSeaComplete", "true");
    prefs_checkpoint("after-undersea");
    if (can_interact() && pref_bool("hagnkAllAfterUnderSea", true)) {
        run_cli("hagnk all");
    }
    print_postrun_pearl_report();
    print("UnderTheSea phase complete.", "green");
}

void leg2() {
    prepare_loop_state();
    undersea();
    profit_marker("leg2_undersea_done");
    leg2_after_undersea();
}

void postrun() {
    prepare_loop_state();
    if (can_interact() && pref_bool("hagnkAllAfterUnderSea", true)) {
        run_cli("hagnk all");
    }
    print_postrun_pearl_report();
}

void run_breakfast_command() {
    prepare_loop_state();
    loop_breakfast();
}

void run_leg2_rollover_command() {
    prepare_loop_state();
    finish_leg2_rollover();
}

void run_leg1_rollover_command() {
    prepare_loop_state();
    finish_leg1_rollover();
}

void run_rollover_command() {
    prepare_loop_state();
    if (get_property(INTERNAL + "leg1Complete").to_boolean()
        && !get_property(INTERNAL + "underTheSeaComplete").to_boolean()
        && !in_undersea_path()) {
        finish_leg1_rollover();
        return;
    }
    finish_leg2_rollover();
}

void run_loop() {
    prepare_loop_state();

    if (valhalla_ready()) {
        require_ascension_enabled("LoopTheSea run");
        ascend_checkpoint();
        return;
    }

    if (in_undersea_path() && !king_liberated()) {
        if (pref_bool("leg2RunAfterUnderSea", false)) {
            leg2();
        } else {
            undersea();
        }
        return;
    }

    if (!get_property(INTERNAL + "leg1Complete").to_boolean()) {
        leg1();
        if (pref_bool("stopAfterLeg1", true)) return;
    }

    if (king_liberated() && !in_undersea_path()) {
        if (pref_bool("ascendEnabled", false)) {
            require_ascension_enabled("LoopTheSea run");
            ascend_checkpoint();
            return;
        }
        abort("LoopTheSea is at the pre-Valhalla checkpoint. Ascend into 11,037 Leagues Under the Sea, then run `LoopTheSea undersea`.");
    }

    if (can_interact()) {
        if (in_undersea_path() && pref_bool("leg2RunAfterUnderSea", false)) {
            leg2_after_undersea();
        } else {
            postrun();
        }
        return;
    }

    abort("LoopTheSea does not recognize a safe next phase. Run `LoopTheSea status`.");
}

void fullday_ascend_checkpoint() {
    string previous_stop = get_property(PREF + "stopAfterAscension");
    set_property(PREF + "stopAfterAscension", "false");
    try {
        ascend_checkpoint();
    } finally {
        set_property(PREF + "stopAfterAscension", previous_stop);
    }
}

void full_day() {
    prepare_loop_state();

    if (pref_bool("prefsAuditBeforeFullday", true)) prefs_audit();
    prefs_checkpoint("fullday-start");

    if (get_property(INTERNAL + "leg2Complete").to_boolean()) {
        print("LoopTheSea fullday is already complete for this checkpoint date.", "green");
        return;
    }

    if (valhalla_ready()) {
        require_ascension_enabled("LoopTheSea fullday");
        fullday_ascend_checkpoint();
        print("LoopTheSea fullday is continuing into Leg2 after automated ascension.", "teal");
    }

    if (in_undersea_path() && !king_liberated()) {
        leg2();
        return;
    }

    if (can_interact() && get_property(INTERNAL + "underTheSeaComplete").to_boolean()) {
        leg2_after_undersea();
        return;
    }

    if (!get_property(INTERNAL + "leg1Complete").to_boolean()) {
        leg1_full();
    }

    if (king_liberated() && !in_undersea_path()) {
        require_ascension_enabled("LoopTheSea fullday");
        fullday_ascend_checkpoint();
        print("LoopTheSea fullday is continuing into Leg2 after automated ascension.", "teal");
    }

    if (in_undersea_path() && !king_liberated()) {
        leg2();
        return;
    }

    if (can_interact() && get_property(INTERNAL + "underTheSeaComplete").to_boolean()) {
        leg2_after_undersea();
        return;
    }

    if (get_property(INTERNAL + "leg2Complete").to_boolean()) {
        print("LoopTheSea fullday complete.", "green");
        return;
    }

    abort("LoopTheSea fullday could not identify the next safe phase. Run `LoopTheSea status`.");
}

void reset_checkpoints() {
    set_property(INTERNAL + "checkpointDate", today_to_string());
    set_property(INTERNAL + "initialGarboDone", "false");
    set_property(INTERNAL + "leg1Complete", "false");
    set_property(INTERNAL + "underTheSeaComplete", "false");
    set_property(INTERNAL + "leg2Complete", "false");
    set_property(INTERNAL + "profitTrackingActive", "false");
    set_property(INTERNAL + "raffleTicketsBought", "0");
    set_property(INTERNAL + "leg2PantogramElementChoice", "");
    set_property(INTERNAL + "leg2ConsumeDone", "false");
    set_property(INTERNAL + "porquoiseClosetedBeforeUnderSea", "0");
    set_property(INTERNAL + "leg2PearlFamiliar", "");
    set_property(INTERNAL + "leg2BreakfastDone", "false");
    set_property(INTERNAL + "leg2LateDailyDone", "false");
    set_property(INTERNAL + "leg2GarboDone", "false");
    set_property(INTERNAL + "leg2NightcapDone", "false");
    set_property(INTERNAL + "leg2ExpandedOrgansDone", "false");
    set_property(INTERNAL + "leg2RolloverHookDone", "false");
    set_property(INTERNAL + "leg2RolloverDone", "false");
    set_property(INTERNAL + "leg2BofaFishyAttempts", "0");
    set_property(INTERNAL + "leg2PearlBudgetFloor", "0");
    set_property(INTERNAL + "leg1RolloverHookDone", "false");
    set_property(INTERNAL + "leg1RolloverDone", "false");
    set_property(INTERNAL + "enteredValhalla", "false");
    set_property(INTERNAL + "ascensionComplete", "false");
    set_property(INTERNAL + "ascensionStartedFrom", "");
    set_property(INTERNAL + "ascensionNumber", "");
    set_property(INTERNAL + "afterlifeDeliBoughtFor", "");
    set_property(INTERNAL + "afterlifeArmoryBoughtFor", "");
    print("LoopTheSea checkpoints reset.", "green");
}

void help() {
    print("Usage: LoopTheSea status | preflight | breakfast | leg1 | leg1full | leg1rollover | ascend preflight | ascend | undersea | leg2 | postrun | rollover | prefs backup | prefs audit | run | fullday | reset", "teal");
    print("Today-full Leg1 path: run `LoopTheSea leg1full`.", "teal");
    print("Today-full Leg2 path after manual ascension: run `LoopTheSea leg2`.", "teal");
    print("Hands-off path: run `LoopTheSea fullday` after setting " + PREF + "ascendEnabled=true.", "teal");
    print("Manual Garbo path: run `garbo ascend`, then `LoopTheSea leg1`.", "teal");
    print("Optional: set " + PREF + "runInitialGarbo=true to let `LoopTheSea run` start with garbo ascend.", "teal");
    print("Optional: set " + PREF + "leg2RunAfterUnderSea=true to let `LoopTheSea run` continue into Leg2 farming.", "teal");
    print("Ascension uses only " + PREF + "* prefs. It does not read pLoop preferences.", "teal");
    print("Preference safety: run `LoopTheSea prefs backup` before experiments and `LoopTheSea prefs audit` after crashes.", "teal");
}

void main(string input) {
    string mode = input.to_lower_case();
    switch (mode) {
        case "status":
            status();
            return;
        case "preflight":
            preflight();
            return;
        case "breakfast":
            run_breakfast_command();
            return;
        case "leg1":
        case "postgarbo":
            leg1();
            return;
        case "leg1full":
        case "fullleg1":
        case "start":
            leg1_full();
            return;
        case "leg1rollover":
        case "leg1 rollover":
            run_leg1_rollover_command();
            return;
        case "ascend":
            ascend_checkpoint();
            return;
        case "ascend preflight":
        case "ascension preflight":
        case "ascendpreflight":
            ascend_preflight();
            return;
        case "undersea":
            undersea();
            return;
        case "leg2":
        case "underseafull":
            leg2();
            return;
        case "postrun":
            postrun();
            return;
        case "rollover":
            run_rollover_command();
            return;
        case "leg2rollover":
            run_leg2_rollover_command();
            return;
        case "prefs backup":
        case "pref backup":
        case "backup prefs":
            prepare_loop_state();
            prefs_backup("manual");
            return;
        case "prefs audit":
        case "pref audit":
        case "audit prefs":
            prefs_audit();
            return;
        case "prefs":
            print("Usage: LoopTheSea prefs backup | prefs audit", "teal");
            return;
        case "run":
            run_loop();
            return;
        case "fullday":
        case "full day":
        case "full-day":
            full_day();
            return;
        case "reset":
            reset_checkpoints();
            return;
        default:
            help();
            return;
    }
}
