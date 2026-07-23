script "UnderTheSeaPrep";

/*
Post-Garbo preparation for the next UnderTheSea loop.

Usage:
  UnderTheSeaPrep status
  UnderTheSeaPrep preflight
  UnderTheSeaPrep postgarbo
  UnderTheSeaPrep finishplain
  UnderTheSeaPrep pearls
  UnderTheSeaPrep mount

This script intentionally owns its preferences. It does not read or write
legacy loop-script properties.
*/

string PREF = "underTheSeaPrep_";
string INTERNAL = "_underTheSeaPrep_";

item WINEGLASS = $item[Drunkula's wineglass];
item CODPIECE = $item[The Eternity Codpiece];
item PEARL = $item[unblemished pearl];
item GILL_TEA = $item[cuppa Gill tea];
item FISHY_PIPE = $item[fishy pipe];
item MERKIN_STRONGJUICE = $item[Mer-kin strongjuice];
item PHILTER_OF_PHORCE = $item[philter of phorce];
item FERRIGNOS_ELIXIR = $item[Ferrigno's Elixir of Power];
item BEACH_COMB = $item[Beach Comb];
item DRIFTWOOD = $item[piece of driftwood];
item DRIFTWOOD_COMB = $item[driftwood beach comb];
item GRAIN_OF_SAND = $item[grain of sand];
item DAY_SHORTENER = $item[day shortener];
item EXTRA_TIME = $item[extra time];
item CONFUSING_LED_CLOCK = $item[confusing LED clock];
item MAYAM_CALENDAR = $item[Mayam Calendar];
item CHRONER_TRIGGER = $item[Chroner trigger];
item CHRONER_CROSS = $item[Chroner cross];
item MR_STORE_2002_CATALOG = $item[2002 Mr. Store Catalog];
item SPOOKY_VHS_TAPE = $item[Spooky VHS Tape];
item BAKED_VEGGIE_RICOTTA_CASSEROLE = $item[baked veggie ricotta casserole];
item PLAIN_CALZONE = $item[plain calzone];
item ROASTED_VEGETABLE_FOCACCIA = $item[roasted vegetable focaccia];
item PETES_RICH_RICOTTA = $item[Pete's rich ricotta];
item ROASTED_VEGETABLE_OF_JARLSBERG = $item[roasted vegetable of Jarlsberg];
item BORISS_BREAD = $item[Boris's bread];
item DEEP_DISH_OF_LEGEND = $item[Deep Dish of Legend];
item CALZONE_OF_LEGEND = $item[Calzone of Legend];
item PIZZA_OF_LEGEND = $item[Pizza of Legend];

item ANGELBONE_TOTEM = $item[angelbone totem];
item DEVILBONE_CORSET = $item[devilbone corset];
item DEVILBONE_GREAVES = $item[devilbone greaves];
item ANGELBONE_CHOPSTICKS = $item[angelbone chopsticks];

item SWIMMING_TRUNKS = $item[really\, really nice swimming trunks];
item OLD_SCUBA_TANK = $item[old SCUBA tank];
item ELF_GUARD_SCUBA_TANK = $item[Elf Guard SCUBA tank];

familiar STOOPER = $familiar[Stooper];

boolean old_scuba_purchase_attempted = false;
location BARF_MOUNTAIN = $location[Barf Mountain];

location [int] PEARL_LOCATIONS = {
    0: $location[Anemone Mine],
    1: $location[The Dive Bar],
    2: $location[Madness Reef],
    3: $location[The Marinara Trench],
    4: $location[The Briniest Deepests]
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

string [int] PEARL_PROPERTIES = {
    0: "_unblemishedPearlAnemoneMine",
    1: "_unblemishedPearlDiveBar",
    2: "_unblemishedPearlMadnessReef",
    3: "_unblemishedPearlMarinaraTrench",
    4: "_unblemishedPearlTheBriniestDeepests"
};

item [int] HAT_AIR_SUPPLIES = {
    0: $item[aerated diving helmet],
    1: $item[crappy Mer-kin mask],
    2: $item[Mer-kin gladiator mask],
    3: $item[Mer-kin scholar mask]
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

slot [int] CODPIECE_SLOTS = {
    0: $slot[codpiece1],
    1: $slot[codpiece2],
    2: $slot[codpiece3],
    3: $slot[codpiece4],
    4: $slot[codpiece5]
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

familiar configured_pearl_familiar() {
    string raw = pref_string("pearlFamiliar", "Grouper Groupie");
    if (raw.to_lower_case() == "none") return $familiar[none];

    familiar fam = raw.to_familiar();
    if (fam == $familiar[none]) {
        abort("Invalid " + PREF + "pearlFamiliar: " + raw + ". Use a familiar name or none.");
    }
    return fam;
}

item configured_pearl_familiar_equipment() {
    string raw = pref_string("pearlFamiliarEquipment", "gill rings");
    if (raw == "" || raw.to_lower_case() == "none") return $item[none];

    item it = raw.to_item();
    if (it == $item[none]) {
        abort("Invalid " + PREF + "pearlFamiliarEquipment: " + raw + ". Use an item name or none.");
    }
    return it;
}

string pearl_policy() {
    string policy = pref_string("pearlPolicy", "ALWAYS").to_upper_case();
    if (policy == "ENSURE FIVE") policy = "ENSURE_FIVE";
    if (policy != "ALWAYS" && policy != "NEVER" && policy != "ENSURE_FIVE") {
        abort("Invalid " + PREF + "pearlPolicy: " + policy + ". Use ALWAYS, NEVER, or ENSURE_FIVE.");
    }
    return policy;
}

int voa() {
    int value = get_property("valueOfAdventure").to_int();
    if (value <= 0) return 10000;
    return value;
}

void run_cli(string command) {
    print("Running: " + command, "teal");
    if (!cli_execute(command)) {
        abort("Command failed: " + command);
    }
}

string loop_pref_string(string key, string fallback) {
    string value = get_property("loopTheSea_" + key);
    if (value == "") return fallback;
    return value;
}

boolean loop_pref_bool(string key, boolean fallback) {
    string value = get_property("loopTheSea_" + key);
    if (value == "") return fallback;
    return value.to_boolean();
}

boolean loop_profit_tracking_active() {
    return get_property("_loopTheSea_profitTrackingActive").to_boolean();
}

string loop_profit_marker_name(string marker) {
    return loop_pref_string("profitMarkerPrefix", "lts") + "_" + marker;
}

boolean ptrack_event_logged_today(string event) {
    if (get_property("prusias_profitTracking_date") != today_to_string()) return false;

    foreach i, logged in get_property("thoth19_event_list").split_string(",") {
        if (logged == event) return true;
    }
    return false;
}

void loop_profit_marker(string marker) {
    if (!loop_profit_tracking_active()) return;
    if (!loop_pref_bool("profitTrackingEnabled", true)) return;

    string event = loop_profit_marker_name(marker);
    if (ptrack_event_logged_today(event)) {
        print("Profit marker already logged: " + event, "gray");
        return;
    }

    print("Profit marker: " + event, "fuchsia");
    if (!cli_execute("ptrack add " + event)) {
        string message = "Unable to log PTrack marker: " + event + ".";
        if (loop_pref_bool("profitTrackingRequired", false)) abort(message);
        print(message, "red");
    }
}

boolean have_item_or_equipped(item it) {
    return available_amount(it) > 0 || have_equipped(it);
}

void require_item(item it, string context) {
    if (!have_item_or_equipped(it)) {
        abort(context + ": missing " + it + ".");
    }
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
        if (equipped_item(sl) != it) {
            equip(sl, it);
        }
    }
}

void equip_required(slot sl, item it, string context) {
    require_item(it, context);
    if (equipped_item(sl) != it && !equip(sl, it)) {
        abort(context + ": unable to equip " + it + " in " + sl + ".");
    }
    if (equipped_item(sl) != it) {
        abort(context + ": " + it + " is not equipped in " + sl + ".");
    }
}

boolean organ_lock_active() {
    return get_property(INTERNAL + "organLockActive").to_boolean();
}

boolean post_garbo_first_nightcap_done() {
    return get_property(INTERNAL + "firstNightcapDone").to_boolean();
}

boolean post_garbo_second_garbo_done() {
    if (get_property(INTERNAL + "secondGarboDone").to_boolean()) return true;

    if (ptrack_event_logged_today(loop_profit_marker_name("leg1_second_garbo_done"))) return true;

    string completed = get_property("_garboCompleted").to_lower_case();
    return completed.contains_text("garbo") && completed.contains_text("ascend") && completed.contains_text("turns=");
}

int organ_lock_until_turn() {
    return get_property(INTERNAL + "organLockUntilTurn").to_int();
}

void set_organ_lock() {
    int until_turn = total_turns_played() + pref_int("minOrganLockTurns", 50);
    set_property(INTERNAL + "organLockActive", "true");
    set_property(INTERNAL + "organLockUntilTurn", until_turn);
    print("Organ gear locked until turn " + until_turn + ".", "teal");
}

boolean pants_lock_required() {
    if (organ_lock_active()) return true;

    int capacity = to_int(numeric_modifier("Spleen Capacity"));
    return my_spleen_use() > spleen_limit() - max(0, capacity);
}

void verify_organ_limits(string context, boolean require_wineglass) {
    if (require_wineglass && equipped_item($slot[off-hand]) != WINEGLASS) {
        abort(context + ": Drunkula's wineglass is not equipped.");
    }

    if (my_fullness() > fullness_limit()) {
        abort(context + ": fullness " + my_fullness() + " exceeds limit " + fullness_limit() + ".");
    }

    if (my_spleen_use() > spleen_limit()) {
        abort(context + ": spleen use " + my_spleen_use() + " exceeds limit " + spleen_limit() + ".");
    }
}

void equip_organ_lock(boolean include_pants) {
    string context = "Organ lock";
    equip_required($slot[weapon], ANGELBONE_TOTEM, context);
    equip_required($slot[off-hand], WINEGLASS, context);
    equip_required($slot[shirt], DEVILBONE_CORSET, context);
    if (include_pants) {
        equip_required($slot[pants], DEVILBONE_GREAVES, context);
    }
    equip_required($slot[acc1], ANGELBONE_CHOPSTICKS, context);
    verify_organ_limits(context, true);
}

void verify_organ_lock(string context, boolean include_pants) {
    if (equipped_item($slot[weapon]) != ANGELBONE_TOTEM) {
        abort(context + ": angelbone totem is not equipped.");
    }
    if (equipped_item($slot[off-hand]) != WINEGLASS) {
        abort(context + ": Drunkula's wineglass is not equipped.");
    }
    if (equipped_item($slot[shirt]) != DEVILBONE_CORSET) {
        abort(context + ": devilbone corset is not equipped.");
    }
    if (include_pants && equipped_item($slot[pants]) != DEVILBONE_GREAVES) {
        abort(context + ": devilbone greaves are not equipped.");
    }
    if (equipped_item($slot[acc1]) != ANGELBONE_CHOPSTICKS) {
        abort(context + ": angelbone chopsticks are not equipped.");
    }
    verify_organ_limits(context, true);
}

string organ_lock_maximizer(boolean include_pants) {
    string result = "equip angelbone totem, equip Drunkula's wineglass, equip devilbone corset, equip angelbone chopsticks";
    if (include_pants) result = result + ", equip devilbone greaves";
    return result;
}

void use_stooper() {
    if (!have_familiar(STOOPER)) {
        abort("Post-Garbo flow requires Stooper.");
    }
    use_familiar(STOOPER);
    if (my_familiar() != STOOPER) abort("Unable to switch to Stooper.");
}

void maximize_liver_with_stooper() {
    use_stooper();
    run_cli("maximize +liver, -tie");
    use_stooper();
}

void collect_rumpus_visit(int spot, int furni, string preference, int expected_adventures) {
    if (get_property(preference).to_boolean()) return;

    int before = my_adventures();
    visit_url("clan_rumpus.php?action=click&spot=" + spot + "&furni=" + furni);
    int gained = my_adventures() - before;
    if (gained != expected_adventures) {
        abort("Clan rumpus visit for spot " + spot + "/" + furni + " gained " + gained
            + " adventures; expected " + expected_adventures + ".");
    }
}

void collect_safe_rumpus_adventures() {
    visit_url("clan_rumpus.php");
    int [string] rumpus = get_clan_rumpus();

    if (!get_property("_clanRumpusSpot1Visited").to_boolean()) {
        if (rumpus contains "Girls of Loathing Calendar") {
            collect_rumpus_visit(1, 1, "_clanRumpusSpot1Visited", 3);
        } else if (rumpus contains "Boys of Loathing Calendar") {
            collect_rumpus_visit(1, 2, "_clanRumpusSpot1Visited", 3);
        } else {
            print("Clan rumpus room has no +3 calendar in spot 1.", "yellow");
        }
    }

    if (!get_property("_clanRumpusSpot2Visited").to_boolean()) {
        if (rumpus contains "Collection of Self-Help Books") {
            collect_rumpus_visit(2, 3, "_clanRumpusSpot2Visited", 5);
        } else {
            print("Clan rumpus room has no Collection of Self-Help Books.", "yellow");
        }
    }

    if (!get_property("_clanRumpusSpot4Visited").to_boolean()) {
        if (rumpus contains "Inspirational Desk Calendar") {
            collect_rumpus_visit(4, 3, "_clanRumpusSpot4Visited", 1);
        } else {
            print("Clan rumpus room has no Inspirational Desk Calendar.", "yellow");
        }
    }
}

int mounted_pearl_count() {
    if (!have_item_or_equipped(CODPIECE)) return 0;

    int count = 0;
    foreach i, sl in CODPIECE_SLOTS {
        if (equipped_item(sl) == PEARL) count = count + 1;
    }
    return count;
}

int held_pearl_count() {
    return item_amount(PEARL) + closet_amount(PEARL);
}

int usable_pearl_count() {
    return held_pearl_count() + mounted_pearl_count();
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

boolean [int] target_pearl_zones() {
    boolean [int] result;
    string policy = pearl_policy();
    if (policy == "NEVER") return result;

    int pearls_needed = 5;
    if (policy == "ENSURE_FIVE") {
        pearls_needed = max(0, 5 - usable_pearl_count());
    }

    foreach zone_index, loc in PEARL_LOCATIONS {
        if (pearl_zone_complete(zone_index)) continue;
        if (policy == "ENSURE_FIVE" && pearls_needed <= 0) break;
        result[zone_index] = true;
        pearls_needed = pearls_needed - 1;
    }

    if (policy == "ENSURE_FIVE" && pearls_needed > 0) {
        abort("Not enough unfinished pearl zones remain to ensure five pearls.");
    }
    return result;
}

int projected_pearl_combats() {
    int result = 0;
    boolean [int] targets = target_pearl_zones();
    foreach zone_index, loc in PEARL_LOCATIONS {
        if (targets[zone_index]) {
            result = result + projected_pearl_combats_for_zone(zone_index);
        }
    }
    return result;
}

int pearl_budget() {
    int combats = projected_pearl_combats();
    if (combats <= 0) return 0;
    return combats + pref_int("pearlBuffer", 5);
}

void print_pearl_plan() {
    print("Pearl policy: " + pearl_policy(), "teal");
    boolean [int] targets = target_pearl_zones();
    foreach zone_index, loc in PEARL_LOCATIONS {
        string state = pearl_zone_complete(zone_index)
            ? "complete"
            : pearl_zone_progress(zone_index) + "% progress; projected "
                + projected_pearl_combats_for_zone(zone_index) + " combat(s)";
        if (targets[zone_index]) state = state + "; selected";
        print("- " + loc + ": " + state);
    }
    print("Projected pearl combats: " + projected_pearl_combats(), "teal");
    print("Pearl budget including noncombat buffer: " + pearl_budget(), "teal");
}

void take_closeted_pearls_if_needed() {
    int needed = 5 - item_amount(PEARL);
    if (needed <= 0 || closet_amount(PEARL) <= 0) return;

    int to_take = min(needed, closet_amount(PEARL));
    run_cli("closet take " + to_take + " unblemished pearl");
}

void clear_codpiece_slots() {
    require_item(CODPIECE, "Codpiece mount");
    visit_url("inventory.php?action=docodpiece");
    for slot_number from 5 to 1 {
        visit_url("choice.php?whichchoice=1588&option=2&which=" + slot_number);
    }
    cli_execute("refresh all");
}

void verify_codpiece_pearls() {
    foreach i, sl in CODPIECE_SLOTS {
        if (equipped_item(sl) != PEARL) {
            abort("Codpiece slot #" + (i + 1) + " does not contain an unblemished pearl.");
        }
    }
}

void mount_codpiece_pearls() {
    require_item(CODPIECE, "Codpiece mount");
    if (mounted_pearl_count() == 5) {
        print("The Eternity Codpiece already has five unblemished pearls mounted.", "green");
        return;
    }

    take_closeted_pearls_if_needed();
    if (usable_pearl_count() < 5) {
        abort("Need five unblemished pearls before mounting. Have " + usable_pearl_count()
            + " including mounted and closeted pearls.");
    }

    clear_codpiece_slots();
    take_closeted_pearls_if_needed();
    if (item_amount(PEARL) < 5) {
        abort("Need five inventory pearls after clearing the Codpiece. Have " + item_amount(PEARL) + ".");
    }

    visit_url("inventory.php?action=docodpiece");
    for slot_number from 1 to 5 {
        visit_url("choice.php?whichchoice=1588&option=1&which=" + slot_number + "&iid=" + to_int(PEARL));
    }
    cli_execute("refresh all");

    verify_codpiece_pearls();
    print("Mounted five unblemished pearls in The Eternity Codpiece.", "green");
}

void apply_effect(effect ef) {
    if (have_effect(ef) > 0) return;
    if (to_skill(ef) != $skill[none] && !have_skill(to_skill(ef))) return;
    cli_execute(ef.default);
}

void apply_pearl_buffs(int zone_index) {
    foreach ef in $effects[Carlweather's Cantata of Confrontation,
        Fresh Breath, Musk of the Moose, Crunchy Steps, Towering Muscles,
        Attracting Snakes, Bloodbathed] {
        if (ef == $effect[Crunchy Steps] && item_amount($item[crunchy brush]) == 0) continue;
        if (ef == $effect[Towering Muscles] && get_property("yogUrtDefeated") == "false") continue;
        apply_effect(ef);
    }

    if (have_effect($effect[Apriling Band Battle Cadence]) == 0
        && total_turns_played() >= get_property("nextAprilBandTurn").to_int()) {
        cli_execute("aprilband effect c");
    }

    foreach ef in $effects[Astral Shell, Minor Invulnerability, Elemental Saucesphere] {
        if (ef == $effect[Minor Invulnerability]
            && item_amount($item[scroll of minor invulnerability]) == 0) continue;
        apply_effect(ef);
    }
    if (PEARL_MAXIMIZERS[zone_index] == "sleaze res") {
        apply_effect($effect[scarysauce]);
    }

    foreach ef in $effects[Carol of the Hells, Elron's Explosive Etude,
        Big, Favored by Lyle, The Magical Mojomuscular Melody,
        Tubes of Universal Meat, Mariachi Moisture] {
        apply_effect(ef);
    }

    string extra = pref_string("extraPearlBuffCommands", "");
    if (extra != "") run_cli(extra);
}

void setup_pearl_familiar() {
    familiar fam = configured_pearl_familiar();
    item familiar_item = configured_pearl_familiar_equipment();

    if (fam != $familiar[none]) {
        if (!have_familiar(fam)) {
            abort("Pearl farming requires configured familiar " + fam + ".");
        }

        use_familiar(fam);
        if (my_familiar() != fam) {
            abort("Unable to switch to configured pearl familiar " + fam + ".");
        }
    } else {
        print("Pearl familiar switching is disabled by " + PREF + "pearlFamiliar=none.", "yellow");
    }

    if (familiar_item != $item[none]) {
        require_item(familiar_item, "Pearl farming");
        equip_required($slot[familiar], familiar_item, "Pearl farming");
    } else {
        print("Pearl familiar equipment is unlocked by " + PREF + "pearlFamiliarEquipment=none.", "yellow");
    }
}

void ensure_fishy() {
    if (have_effect($effect[Fishy]) > 0) return;

    if (!get_property("_fishyPipeUsed").to_boolean() && have_item_or_equipped(FISHY_PIPE)) {
        if (!use(1, FISHY_PIPE)) abort("Failed to use fishy pipe.");
    }
    if (have_effect($effect[Fishy]) > 0) return;

    if (!get_property("_skateBuff1").to_boolean()) {
        print("Attempting Lutz's skate-park Fishy buff.", "teal");
        visit_url("sea_skatepark.php?action=state2buff1");
    }
    if (have_effect($effect[Fishy]) > 0) return;

    if (item_amount(GILL_TEA) == 0 && available_amount(GILL_TEA) > 0) {
        retrieve_item(1, GILL_TEA);
    }
    if (item_amount(GILL_TEA) == 0) {
        int max_price = pref_int("gillTeaMaxPrice", 100000);
        int price = mall_price(GILL_TEA);
        if (price <= 0 || price > max_price) {
            abort("Fishy expired. cuppa Gill tea mall price is " + price
                + " Meat; configured cap is " + max_price + ".");
        }
        if (buy(1, GILL_TEA, max_price) == 0) {
            abort("Failed to buy cuppa Gill tea below " + max_price + " Meat.");
        }
    }
    if (!use(1, GILL_TEA)) abort("Failed to use cuppa Gill tea.");
    if (have_effect($effect[Fishy]) <= 0) abort("Unable to acquire Fishy.");
}

void attempt_old_scuba_purchase() {
    if (old_scuba_purchase_attempted || have_item_or_equipped(OLD_SCUBA_TANK)) return;
    old_scuba_purchase_attempted = true;

    if (my_meat() < 10000) {
        print("Skipping old SCUBA tank purchase attempt: fewer than 10,000 Meat on hand.", "yellow");
        return;
    }

    print("Attempting conditional old SCUBA tank purchase from the Old Man.", "teal");
    visit_url("oldman.php?whichplace=sea_oldman&action=oldman_oldman");
    if (!have_item_or_equipped(OLD_SCUBA_TANK)) {
        visit_url("oldman.php?whichplace=sea_oldman&action=oldman_oldman");
    }
    if (have_item_or_equipped(OLD_SCUBA_TANK)) {
        print("Acquired old SCUBA tank.", "green");
    } else {
        print("Old Man did not sell an old SCUBA tank; continuing to the Elf Guard fallback.", "yellow");
    }
}

slot air_supply_slot(item supply) {
    if (supply == SWIMMING_TRUNKS) return $slot[pants];
    if (supply == OLD_SCUBA_TANK || supply == ELF_GUARD_SCUBA_TANK) return $slot[back];
    return $slot[hat];
}

boolean air_supply_equipped(item supply) {
    return equipped_item(air_supply_slot(supply)) == supply;
}

boolean reject_air_supply(item supply, string reason, boolean verbose) {
    if (verbose) print("Rejecting " + supply + ": " + reason + ".", "yellow");
    return false;
}

string pearl_maximizer(int zone_index, item supply, boolean include_pants) {
    item familiar_item = configured_pearl_familiar_equipment();
    string familiar_lock = familiar_item == $item[none] ? "" : ", equip " + familiar_item;
    return "min " + pref_int("pearlResTarget", 18) + " " + PEARL_MAXIMIZERS[zone_index]
        + ", " + organ_lock_maximizer(include_pants)
        + familiar_lock + ", equip " + supply + ", -tie";
}

boolean outfit_feasible(int zone_index, item supply, boolean include_pants, boolean verbose) {
    if (!have_item_or_equipped(supply)) return reject_air_supply(supply, "item is not available", verbose);
    if (supply == SWIMMING_TRUNKS && include_pants) {
        return reject_air_supply(supply, "pants are locked for expanded spleen capacity", verbose);
    }

    string expression = pearl_maximizer(zone_index, supply, include_pants);
    if (!cli_execute("maximize " + expression)) {
        return reject_air_supply(supply, "maximizer rejected the outfit", verbose);
    }

    if (!air_supply_equipped(supply)) return reject_air_supply(supply, "air supply did not equip", verbose);
    if (equipped_item($slot[weapon]) != ANGELBONE_TOTEM) return reject_air_supply(supply, "angelbone totem did not equip", verbose);
    if (equipped_item($slot[off-hand]) != WINEGLASS) return reject_air_supply(supply, "Drunkula's wineglass did not equip", verbose);
    if (equipped_item($slot[shirt]) != DEVILBONE_CORSET) return reject_air_supply(supply, "devilbone corset did not equip", verbose);
    if (include_pants && equipped_item($slot[pants]) != DEVILBONE_GREAVES) {
        return reject_air_supply(supply, "devilbone greaves did not equip", verbose);
    }
    if (equipped_item($slot[acc1]) != ANGELBONE_CHOPSTICKS) return reject_air_supply(supply, "angelbone chopsticks did not equip", verbose);
    item familiar_item = configured_pearl_familiar_equipment();
    if (familiar_item != $item[none] && equipped_item($slot[familiar]) != familiar_item) {
        return reject_air_supply(supply, familiar_item + " did not equip", verbose);
    }

    float resistance = numeric_modifier(PEARL_MODIFIERS[zone_index]);
    if (resistance < pref_int("pearlResTarget", 18)) {
        return reject_air_supply(supply, "only " + resistance + " " + PEARL_MODIFIERS[zone_index], verbose);
    }
    if (my_fullness() > fullness_limit()) return reject_air_supply(supply, "fullness exceeds the equipped limit", verbose);
    if (my_spleen_use() > spleen_limit()) return reject_air_supply(supply, "spleen exceeds the equipped limit", verbose);
    return true;
}

item best_hat_air_supply(int zone_index, boolean include_pants) {
    item best = $item[none];
    int best_muscle = -1;
    foreach i, supply in HAT_AIR_SUPPLIES {
        if (!outfit_feasible(zone_index, supply, include_pants, true)) continue;
        int muscle = my_buffedstat($stat[Muscle]);
        if (muscle > best_muscle) {
            best = supply;
            best_muscle = muscle;
        }
    }
    return best;
}

item select_air_supply(int zone_index) {
    boolean include_pants = pants_lock_required();

    if (!include_pants && outfit_feasible(zone_index, SWIMMING_TRUNKS, false, true)) {
        return SWIMMING_TRUNKS;
    }

    item hat_supply = best_hat_air_supply(zone_index, include_pants);
    if (hat_supply != $item[none]) {
        outfit_feasible(zone_index, hat_supply, include_pants, true);
        return hat_supply;
    }

    if (!have_item_or_equipped(OLD_SCUBA_TANK)) attempt_old_scuba_purchase();
    if (outfit_feasible(zone_index, OLD_SCUBA_TANK, include_pants, true)) {
        return OLD_SCUBA_TANK;
    }

    if (outfit_feasible(zone_index, ELF_GUARD_SCUBA_TANK, include_pants, true)) {
        return ELF_GUARD_SCUBA_TANK;
    }

    abort("No underwater air-supply outfit reaches " + pref_int("pearlResTarget", 18)
        + " " + PEARL_MODIFIERS[zone_index] + " in " + PEARL_LOCATIONS[zone_index] + ".");
    return $item[none];
}

void use_muscle_potion(item potion, effect buff, string cap_preference, int default_cap) {
    if (have_effect(buff) > 0) return;

    if (item_amount(potion) == 0 && available_amount(potion) > 0) {
        retrieve_item(1, potion);
    }
    if (item_amount(potion) == 0) {
        int max_price = pref_int(cap_preference, default_cap);
        int price = mall_price(potion);
        if (price <= 0 || price > max_price) {
            abort("Need " + potion + " for the Muscle floor. Mall price is " + price
                + " Meat; configured cap is " + max_price + ".");
        }
        if (buy(1, potion, max_price) == 0) {
            abort("Failed to buy " + potion + " below " + max_price + " Meat.");
        }
    }

    print("Using " + potion + " for the pearl-farming Muscle floor.", "teal");
    if (!use(1, potion)) abort("Failed to use " + potion + ".");
    if (have_effect(buff) <= 0) abort(potion + " did not grant " + buff + ".");
}

void ensure_muscle_floor() {
    int floor = pref_int("muscleFloor", 2000);
    if (my_buffedstat($stat[Muscle]) >= floor) return;

    use_muscle_potion(MERKIN_STRONGJUICE, $effect[Juiced Out], "strongjuiceMaxPrice", 5000);
    if (my_buffedstat($stat[Muscle]) >= floor) return;

    use_muscle_potion(PHILTER_OF_PHORCE, $effect[Phorcefullness], "philterOfPhorceMaxPrice", 5000);
    if (my_buffedstat($stat[Muscle]) >= floor) return;

    use_muscle_potion(FERRIGNOS_ELIXIR, $effect[Incredibly Hulking], "ferrignosElixirMaxPrice", 5000);
    if (my_buffedstat($stat[Muscle]) >= floor) return;

    abort("Buffed Muscle is " + my_buffedstat($stat[Muscle]) + "; need " + floor
        + ". Add another source with " + PREF + "extraPearlBuffCommands.");
}

void restore_hp(string context) {
    if (my_hp() < my_maxhp()) {
        cli_execute("restore hp");
    }
    if (my_hp() <= 0) abort(context + ": HP recovery failed.");
}

void cure_beaten_up(string context) {
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

boolean feast_of_boris_wanderer(monster mon) {
    return mon == $monster[Candied Yam Golem]
        || mon == $monster[Malevolent Tofurkey]
        || mon == $monster[Possessed Can of Cranberry Sauce]
        || mon == $monster[Stuffing Golem];
}

void verify_pearl_turn_ready(int zone_index, item supply) {
    string context = "Before " + PEARL_LOCATIONS[zone_index];
    boolean include_pants = pants_lock_required();

    cure_beaten_up(context);
    ensure_fishy();
    verify_organ_lock(context, include_pants);
    setup_pearl_familiar();
    ensure_muscle_floor();
    if (!air_supply_equipped(supply)) abort(context + ": underwater air supply is not equipped.");
    if (!can_adventure(PEARL_LOCATIONS[zone_index])) {
        print(context + ": KoLmafia does not currently think the zone is adventureable; refreshing session state.", "yellow");
        cli_execute("refresh all");
    }
    if (!can_adventure(PEARL_LOCATIONS[zone_index])) abort(context + ": zone is not adventureable.");

    float resistance = numeric_modifier(PEARL_MODIFIERS[zone_index]);
    if (resistance < pref_int("pearlResTarget", 18)) {
        abort(context + ": only " + resistance + " " + PEARL_MODIFIERS[zone_index] + ".");
    }

    int muscle = my_buffedstat($stat[Muscle]);
    if (muscle < pref_int("muscleFloor", 2000)) {
        abort(context + ": buffed Muscle is " + muscle + "; need "
            + pref_int("muscleFloor", 2000) + ".");
    }
    restore_hp(context);
}

int farm_pearl_zone(int zone_index, int noncombats_remaining) {
    if (pearl_zone_complete(zone_index)) return noncombats_remaining;

    setup_pearl_familiar();
    apply_pearl_buffs(zone_index);
    item supply = select_air_supply(zone_index);
    print("Farming " + PEARL_LOCATIONS[zone_index] + " with " + supply + ".", "teal");

    while (!pearl_zone_complete(zone_index)) {
        if (my_adventures() <= 0) abort("Ran out of adventures while farming pearls.");

        apply_pearl_buffs(zone_index);
        verify_pearl_turn_ready(zone_index, supply);
        int adventures_before = my_adventures();
        string combat_before = get_property("_lastCombatStarted");
        float progress_before = pearl_zone_progress(zone_index);

        if (!adventure(1, PEARL_LOCATIONS[zone_index])) {
            abort("Adventure failed or timed out in " + PEARL_LOCATIONS[zone_index] + ".");
        }

        int adventures_spent = adventures_before - my_adventures();
        if (adventures_spent != 1) {
            abort("Expected one Fishy adventure in " + PEARL_LOCATIONS[zone_index]
                + ", but spent " + adventures_spent + ".");
        }

        string combat_after = get_property("_lastCombatStarted");
        if (combat_after != combat_before) {
            if (get_property("_lastCombatLost").to_boolean()
                || !get_property("_lastCombatWon").to_boolean()) {
                monster opponent = last_monster();
                if (get_property("_lastCombatLost").to_boolean()
                    && feast_of_boris_wanderer(opponent)) {
                    noncombats_remaining = noncombats_remaining - 1;
                    if (noncombats_remaining < 0) {
                        abort("A Feast of Boris wanderer loss exceeded the configured pearl buffer.");
                    }
                    print("Lost one buffered pearl-farming adventure to " + opponent
                        + " while overdrunk; recovering and continuing.", "yellow");
                    cure_beaten_up("After losing to " + opponent);
                    restore_hp("After losing to " + opponent);
                    continue;
                }
                abort("Combat failed or timed out in " + PEARL_LOCATIONS[zone_index] + ".");
            }
            float progress_after = pearl_zone_progress(zone_index);
            if (!pearl_zone_complete(zone_index) && progress_after + 0.001 < progress_before + 10.0) {
                abort("Combat in " + PEARL_LOCATIONS[zone_index]
                    + " did not advance pearl progress by 10%. Before: " + progress_before
                    + "; after: " + progress_after + ".");
            }
        } else {
            noncombats_remaining = noncombats_remaining - 1;
            if (noncombats_remaining < 0) {
                abort("Pearl farming exceeded the configured noncombat buffer.");
            }
        }
    }

    print("Obtained pearl from " + PEARL_LOCATIONS[zone_index] + ".", "green");
    return noncombats_remaining;
}

void farm_selected_pearls() {
    string policy = pearl_policy();
    if (policy == "NEVER") {
        print("Pearl farming skipped by " + PREF + "pearlPolicy=NEVER.", "yellow");
        return;
    }

    require_item(CODPIECE, "Pearl farming");
    string previous_battle_action = get_property("battleAction");
    string previous_ccs = get_property("customCombatScript");
    write_ccs(to_buffer("attack"), "UnderTheSeaPrep");
    set_ccs("UnderTheSeaPrep");
    set_property("battleAction", "custom combat script");

    try {
        int noncombats_remaining = pref_int("pearlBuffer", 5);
        boolean [int] targets = target_pearl_zones();
        foreach zone_index, loc in PEARL_LOCATIONS {
            if (targets[zone_index]) {
                noncombats_remaining = farm_pearl_zone(zone_index, noncombats_remaining);
            }
        }
    } finally {
        set_ccs(previous_ccs);
        set_property("battleAction", previous_battle_action);
    }
}

string expanded_organ_consume_command(int fullness, int spleen, boolean simulate) {
    string command = "CONSUME ORGANS " + fullness + " 0 " + spleen;
    if (simulate) command = command + " SIM";
    return command;
}

string expanded_organ_consume_command(boolean simulate) {
    int fullness = max(0, fullness_limit() - my_fullness());
    int spleen = max(0, spleen_limit() - my_spleen_use());
    return expanded_organ_consume_command(fullness, spleen, simulate);
}

int organ_lock_item_capacity(string modifier_name) {
    return to_int(numeric_modifier(ANGELBONE_TOTEM, modifier_name)
        + numeric_modifier(DEVILBONE_CORSET, modifier_name)
        + numeric_modifier(DEVILBONE_GREAVES, modifier_name)
        + numeric_modifier(ANGELBONE_CHOPSTICKS, modifier_name));
}

int simulated_expanded_organs_lower_bound() {
    string command = expanded_organ_consume_command(true);
    string output = cli_execute_output(command);
    print(output);

    matcher organs = create_matcher("In total, you're filling up ([0-9]+) fullness, ([0-9]+) liver, and ([0-9]+) spleen", output);
    if (!organs.find()) {
        abort("Unable to parse " + command + " organ usage.");
    }

    matcher yield = create_matcher("Adventure yield should be roughly ([0-9]+)-([0-9]+)", output);
    if (!yield.find()) {
        abort("Unable to parse " + command + " adventure yield.");
    }
    return yield.group(1).to_int();
}

void ensure_planned_expanded_organ_food(string sim_output, item it) {
    if (!sim_output.contains_text(to_string(it))) return;
    if (item_amount(it) > 0) return;

    print("Expanded-organ diet wants " + it + "; sourcing it before CONSUME.", "teal");
    if (!retrieve_item(1, it)) {
        create(1, it);
    }
    if (item_amount(it) == 0) {
        abort("Expanded-organ diet wants " + it + ", but it could not be sourced. "
            + "Acquire or craft it, then rerun the checkpoint.");
    }
}

void prepare_expanded_organ_consume_diet() {
    string sim_output = cli_execute_output(expanded_organ_consume_command(true));

    ensure_planned_expanded_organ_food(sim_output, BAKED_VEGGIE_RICOTTA_CASSEROLE);
    ensure_planned_expanded_organ_food(sim_output, PLAIN_CALZONE);
    ensure_planned_expanded_organ_food(sim_output, ROASTED_VEGETABLE_FOCACCIA);
    ensure_planned_expanded_organ_food(sim_output, PETES_RICH_RICOTTA);
    ensure_planned_expanded_organ_food(sim_output, ROASTED_VEGETABLE_OF_JARLSBERG);
    ensure_planned_expanded_organ_food(sim_output, BORISS_BREAD);
}

void run_second_garbo(int simulated_lower_bound) {
    int required_after_consume = max(pref_int("minOrganLockTurns", 50), pearl_budget());
    int retain_before_garbo = max(0, required_after_consume - simulated_lower_bound);

    print("Second consume lower-bound yield: " + simulated_lower_bound, "teal");
    print("Required turns after second consume: " + required_after_consume, "teal");
    print("Retaining " + retain_before_garbo + " existing adventures before limited Garbo.", "teal");

    if (my_adventures() < retain_before_garbo) {
        abort("Need to retain " + retain_before_garbo + " adventures before the second consume, but only have "
            + my_adventures() + ".");
    }

    int spendable = my_adventures() - retain_before_garbo;
    if (spendable > 0) {
        run_cli("garbo ascend turns=" + spendable);
    } else {
        print("No spendable adventures for the second Garbo phase.", "teal");
    }
    set_property(INTERNAL + "secondGarboDone", "true");
    loop_profit_marker("leg1_second_garbo_done");
}

void consume_expanded_organs() {
    equip_organ_lock(true);
    prepare_expanded_organ_consume_diet();
    run_cli(expanded_organ_consume_command(false));
    equip_organ_lock(true);
    verify_organ_limits("After expanded-organ CONSUME", true);
    if (my_fullness() != fullness_limit()) {
        abort("Expanded-organ CONSUME left fullness at " + my_fullness() + "/" + fullness_limit() + ".");
    }
    if (my_spleen_use() != spleen_limit()) {
        abort("Expanded-organ CONSUME left spleen at " + my_spleen_use() + "/" + spleen_limit() + ".");
    }
    set_organ_lock();

    int required = max(pref_int("minOrganLockTurns", 50), pearl_budget());
    if (my_adventures() < required) {
        abort("Expanded-organ consume left " + my_adventures() + " adventures; need at least "
            + required + " for pearl farming and the organ-lock commitment.");
    }
}

void collect_post_garbo_organs() {
    if (post_garbo_second_garbo_done()) {
        print("Second Garbo checkpoint already complete; resuming at expanded-organ consume.", "teal");
        consume_expanded_organs();
        return;
    }

    if (!post_garbo_first_nightcap_done()) {
        maximize_liver_with_stooper();
        run_cli("CONSUME NIGHTCAP");
        set_property(INTERNAL + "firstNightcapDone", "true");
    } else {
        print("First nightcap checkpoint already complete; resuming before second Garbo.", "teal");
    }

    if (my_inebriety() <= inebriety_limit()) {
        abort("First CONSUME NIGHTCAP did not produce an overdrunk state.");
    }

    equip_organ_lock(true);
    int sim_lower_bound = simulated_expanded_organs_lower_bound();
    run_second_garbo(sim_lower_bound);
    consume_expanded_organs();
}

int remaining_organ_lock_turns() {
    if (!organ_lock_active()) return 0;
    return max(0, organ_lock_until_turn() - total_turns_played());
}

void resume_locked_organs() {
    print("Existing expanded-organ lock detected; resuming after the organ consume.", "teal");
    equip_organ_lock(true);
    verify_organ_lock("Resuming expanded-organ checkpoint", true);
    if (my_fullness() != fullness_limit()) {
        abort("Resuming expanded-organ checkpoint: fullness is " + my_fullness() + "/" + fullness_limit() + ".");
    }
    if (my_spleen_use() != spleen_limit()) {
        abort("Resuming expanded-organ checkpoint: spleen is " + my_spleen_use() + "/" + spleen_limit() + ".");
    }
}

void require_checkpoint_turn_budget() {
    int organ_turns = remaining_organ_lock_turns();
    int pearls = pearl_budget();
    int required = max(organ_turns, pearls);
    if (my_adventures() < required) {
        abort("Checkpoint needs at least " + required + " adventures before continuing. Have "
            + my_adventures() + "; remaining organ-lock turns: " + organ_turns
            + "; selected pearl budget: " + pearls + ".");
    }
}

boolean need_to_acquire(item it) {
    return available_amount(it) + closet_amount(it) + storage_amount(it) == 0;
}

void prepare_legendary_pizzas() {
    boolean need_calzone = need_to_acquire($item[calzone of legend]);
    boolean need_deep_dish = need_to_acquire($item[deep dish of legend]);
    boolean need_pizza = need_to_acquire($item[pizza of legend]);
    if (!need_calzone && !need_deep_dish && !need_pizza) return;

    int pizza_price = 2 * mall_price($item[Yeast of Boris])
        + 2 * mall_price($item[Vegetable of Jarlsberg])
        + 2 * mall_price($item[St. Sneaky Pete's Whey]);

    if (pizza_price < 50 * voa()) {
        if (need_calzone) run_cli("make calzone of legend");
        if (need_deep_dish) run_cli("make deep dish of legend");
        if (need_pizza) run_cli("make pizza of legend");
        return;
    }

    if (need_calzone || need_deep_dish || need_pizza) {
        abort("Legendary pizza ingredients are outside the safe price range. Acquire the three pizzas manually.");
    }
}

void acquire_if_needed(item it) {
    if (need_to_acquire(it)) run_cli("acquire 1 " + it);
}

void append_stash_tracking(item it) {
    string tracked = get_property(INTERNAL + "takenFromClanStashItems");
    string escaped = replace_all(create_matcher(",", it.to_string()), "\\\\,");
    if (tracked == "") {
        set_property(INTERNAL + "takenFromClanStashItems", escaped);
    } else {
        set_property(INTERNAL + "takenFromClanStashItems", tracked + ", " + escaped);
    }
    set_property(INTERNAL + "clanStashTakenFrom", get_clan_name());
}

void acquire_stash_item(item it) {
    cli_execute("refresh stash");
    if (!need_to_acquire(it) || stash_amount(it) <= 0) return;
    run_cli("stash take " + it);
    append_stash_tracking(it);
}

void run_custom_acquisition_list(string value, boolean from_stash) {
    foreach i, raw in value.split_string('(?<!\\\\)(, |,)') {
        string cleaned = replace_all(create_matcher("\\\\", raw), "");
        item it = cleaned.to_item();
        if (it == $item[none]) continue;
        if (from_stash) {
            acquire_stash_item(it);
        } else {
            acquire_if_needed(it);
        }
    }
}

void preascension_acquisitions() {
    int ascension_type = pref_int("nextAscensionType", 2);
    int path_id = pref_int("nextPathId", 0);

    if (ascension_type < 3) {
        prepare_legendary_pizzas();
        if (!have_skill($skill[Summon Clip Art])) acquire_if_needed($item[borrowed time]);
        acquire_if_needed($item[non-Euclidean angle]);
        acquire_if_needed($item[abstraction: category]);
        acquire_if_needed($item[tobiko marble soda]);
        acquire_if_needed($item[wasabi marble soda]);
        if (!get_property("stenchAirportAlways").to_boolean()) {
            acquire_if_needed($item[one-day ticket to Dinseylandfill]);
        }
    }

    if (path_id == 49) {
        prepare_legendary_pizzas();
        if (!pref_bool("smolNoSaladFork", false)) {
            if (!retrieve_item(1, $item[Ol' Scratch's salad fork])) {
                abort("Failed to acquire Ol' Scratch's salad fork. Set "
                    + PREF + "smolNoSaladFork=true to skip.");
            }
        }
        if (!pref_bool("smolNoFrostyMug", false)) {
            if (!retrieve_item(1, $item[Frosty's frosty mug])) {
                abort("Failed to acquire Frosty's frosty mug. Set "
                    + PREF + "smolNoFrostyMug=true to skip.");
            }
        }
    }

    run_custom_acquisition_list(pref_string("preAscendAcquireList", ""), false);
    run_custom_acquisition_list(pref_string("preAscendClanStashAcquireList", ""), true);
}

void verify_organ_turn_commitment() {
    if (!organ_lock_active()) return;
    if (total_turns_played() < organ_lock_until_turn()) {
        abort("Need to spend " + (organ_lock_until_turn() - total_turns_played())
            + " more turns while wearing expanded-organ gear.");
    }
}

boolean prioritize_pvp_with_leftovers() {
    return pref_bool("runPvp", true)
        && pref_bool("prioritizePvpWithLeftoverAdventures", true);
}

void acquire_day_shortener() {
    if (item_amount(DAY_SHORTENER) == 0 && available_amount(DAY_SHORTENER) > 0) {
        retrieve_item(1, DAY_SHORTENER);
    }
    if (item_amount(DAY_SHORTENER) == 0
        && !get_property("_leafDayShortenerCrafted").to_boolean()) {
        create(1, DAY_SHORTENER);
    }
    if (item_amount(DAY_SHORTENER) == 0) {
        abort("Need one " + DAY_SHORTENER
            + " to turn the final five adventures into " + EXTRA_TIME + ".");
    }
}

void use_day_shortener() {
    if (my_adventures() < 5) {
        abort("Need at least five adventures before using " + DAY_SHORTENER + ".");
    }
    acquire_day_shortener();

    int adventures_before = my_adventures();
    int extra_time_before = item_amount(EXTRA_TIME);
    print("Using one " + DAY_SHORTENER + " to bank five adventures as " + EXTRA_TIME + ".", "teal");
    if (!use(1, DAY_SHORTENER)) abort("Failed to use " + DAY_SHORTENER + ".");
    if (adventures_before - my_adventures() != 5) {
        abort(DAY_SHORTENER + " did not remove exactly five adventures.");
    }
    if (item_amount(EXTRA_TIME) <= extra_time_before) {
        abort(DAY_SHORTENER + " did not create " + EXTRA_TIME + ".");
    }
}

void acquire_confusing_led_clock() {
    if (item_amount(CONFUSING_LED_CLOCK) == 0 && available_amount(CONFUSING_LED_CLOCK) > 0) {
        retrieve_item(1, CONFUSING_LED_CLOCK);
    }
    if (item_amount(CONFUSING_LED_CLOCK) > 0) return;

    int max_price = pref_int("confusingLedClockMaxPrice", 100000);
    int price = mall_price(CONFUSING_LED_CLOCK);
    if (price <= 0 || price > max_price) {
        abort("Need " + CONFUSING_LED_CLOCK + " for the final five-adventure PvP conversion. Mall price is "
            + price + " Meat; configured cap is " + max_price + ".");
    }
    if (buy(1, CONFUSING_LED_CLOCK, max_price) == 0) {
        abort("Failed to buy " + CONFUSING_LED_CLOCK + " below " + max_price + " Meat.");
    }
}

void break_hippy_stone() {
    if (hippy_stone_broken()) return;
    print("Breaking the Hippy Stone before the final PvP conversion.", "teal");
    visit_url("peevpee.php?action=smashstone&pwd&confirm=on", true);
    if (!hippy_stone_broken()) abort("Failed to break the Hippy Stone.");
}

void collect_remaining_breakfast_resources() {
    if (!pref_bool("runLateBreakfast", true)) {
        print("Final Leg1 breakfast sweep skipped by " + PREF + "runLateBreakfast=false.", "yellow");
        return;
    }
    if (get_property("breakfastCompleted").to_boolean()) {
        print("KoLmafia breakfast is already complete; no final Leg1 sweep needed.", "green");
        return;
    }

    string command = pref_string("lateBreakfastCommand", "breakfast");
    if (command == "") {
        abort(PREF + "lateBreakfastCommand is blank.");
    }

    if (pref_bool("runPvp", true)) {
        break_hippy_stone();
    }

    int adventures_before = my_adventures();
    int pvp_before = pvp_attacks_left();
    print("Collecting remaining KoLmafia breakfast resources before the final Leg1 turn burn.", "teal");
    run_cli(command);
    print("Final Leg1 breakfast sweep gained " + (my_adventures() - adventures_before)
        + " adventure(s) and " + (pvp_attacks_left() - pvp_before)
        + " PvP fight(s).", "green");
}

void use_chroner_item(item it, string used_property) {
    if (get_property(used_property).to_boolean()) return;
    if (item_amount(it) == 0 && available_amount(it) > 0) {
        retrieve_item(1, it);
    }
    if (item_amount(it) == 0) {
        print("Chroner cleanup skipped; " + it + " is not available.", "yellow");
        return;
    }

    print("Using remaining Leg1 daily item: " + it + ".", "teal");
    if (!use(1, it)) abort("Failed to use " + it + " during final Leg1 cleanup.");
    if (!get_property(used_property).to_boolean()) {
        abort(it + " use did not set " + used_property + ".");
    }
}

void use_remaining_chroner_items() {
    // The cross only becomes usable after the trigger, so breakfast can miss it.
    use_chroner_item(CHRONER_TRIGGER, "_chronerTriggerUsed");
    use_chroner_item(CHRONER_CROSS, "_chronerCrossUsed");
}

void spend_mr_store_2002_credits() {
    if (!pref_bool("spend2002Credits", true)) {
        print("Mr. Store 2002 credit spending skipped by "
            + PREF + "spend2002Credits=false.", "yellow");
        return;
    }

    if (!get_property("_2002MrStoreCreditsCollected").to_boolean()
        && have_item_or_equipped(MR_STORE_2002_CATALOG)) {
        if (item_amount(MR_STORE_2002_CATALOG) == 0) {
            retrieve_item(1, MR_STORE_2002_CATALOG);
        }
        print("Collecting remaining Mr. Store 2002 credits.", "teal");
        if (!use(1, MR_STORE_2002_CATALOG)) {
            abort("Failed to collect Mr. Store 2002 credits.");
        }
    }

    int credits = get_property("availableMrStore2002Credits").to_int();
    if (credits <= 0) {
        print("No Mr. Store 2002 credits remain to spend.", "gray");
        return;
    }

    item reward = pref_string("mrStore2002Reward", "Spooky VHS Tape").to_item();
    if (reward == $item[none]) {
        abort("Invalid " + PREF + "mrStore2002Reward: "
            + pref_string("mrStore2002Reward", "Spooky VHS Tape") + ".");
    }

    int reward_before = item_amount(reward);
    print("Spending " + credits + " Mr. Store 2002 credit(s) on " + reward + ".", "teal");
    buy($coinmaster[Mr. Store 2002], credits, reward);
    int remaining = get_property("availableMrStore2002Credits").to_int();
    if (remaining != 0) {
        abort("Mr. Store 2002 purchase left " + remaining + "/" + credits
            + " credit(s) unspent. Configured reward: " + reward + ".");
    }
    print("Mr. Store 2002 purchase acquired "
        + (item_amount(reward) - reward_before) + " " + reward + ".", "green");
}

int preascension_owned_amount(item it) {
    return item_amount(it) + closet_amount(it) + storage_amount(it);
}

void craft_preascension_target(item it, int target) {
    int owned = preascension_owned_amount(it);
    if (target <= 0 || owned >= target) return;

    int needed = target - owned;
    print("Crafting " + needed + " " + it + " for the pre-ascension stockpile.", "teal");
    create(needed, it);
    owned = preascension_owned_amount(it);
    if (owned < target) {
        abort("Pre-ascension crafting only reached " + owned + "/"
            + target + " " + it + ".");
    }
}

void craft_preascension_cookbookbat_foods() {
    if (!pref_bool("craftPreAscendCookbookbatFoods", true)) {
        print("Pre-ascension Cookbookbat food crafting skipped by "
            + PREF + "craftPreAscendCookbookbatFoods=false.", "yellow");
        return;
    }

    // Build the Legends first, then restore every ingredient tier to its final target.
    craft_preascension_target(DEEP_DISH_OF_LEGEND, 1);
    craft_preascension_target(CALZONE_OF_LEGEND, 1);
    craft_preascension_target(PIZZA_OF_LEGEND, 1);

    craft_preascension_target(BAKED_VEGGIE_RICOTTA_CASSEROLE, 3);
    craft_preascension_target(PLAIN_CALZONE, 3);
    craft_preascension_target(ROASTED_VEGETABLE_FOCACCIA, 3);

    craft_preascension_target(PETES_RICH_RICOTTA, 3);
    craft_preascension_target(ROASTED_VEGETABLE_OF_JARLSBERG, 3);
    craft_preascension_target(BORISS_BREAD, 3);
    print("Pre-ascension Cookbookbat food set is ready: one of each Legend and three of each lower tier.", "green");
}

void print_preascension_cookbookbat_status() {
    print("Pre-ascension Cookbookbat food targets:", "teal");
    print("- Legends: " + DEEP_DISH_OF_LEGEND + " " + preascension_owned_amount(DEEP_DISH_OF_LEGEND)
        + "/1; " + CALZONE_OF_LEGEND + " " + preascension_owned_amount(CALZONE_OF_LEGEND)
        + "/1; " + PIZZA_OF_LEGEND + " " + preascension_owned_amount(PIZZA_OF_LEGEND) + "/1");
    print("- Middle tier: " + BAKED_VEGGIE_RICOTTA_CASSEROLE + " "
        + preascension_owned_amount(BAKED_VEGGIE_RICOTTA_CASSEROLE) + "/3; "
        + PLAIN_CALZONE + " " + preascension_owned_amount(PLAIN_CALZONE) + "/3; "
        + ROASTED_VEGETABLE_FOCACCIA + " "
        + preascension_owned_amount(ROASTED_VEGETABLE_FOCACCIA) + "/3");
    print("- Base tier: " + PETES_RICH_RICOTTA + " " + preascension_owned_amount(PETES_RICH_RICOTTA)
        + "/3; " + ROASTED_VEGETABLE_OF_JARLSBERG + " "
        + preascension_owned_amount(ROASTED_VEGETABLE_OF_JARLSBERG) + "/3; "
        + BORISS_BREAD + " " + preascension_owned_amount(BORISS_BREAD) + "/3");
}

boolean mayam_symbol_used(string symbol) {
    string normalized_used = ","
        + get_property("_mayamSymbolsUsed").to_lower_case().replace_string(" ", "")
        + ",";
    string normalized_symbol = "," + symbol.to_lower_case().replace_string(" ", "") + ",";
    return normalized_used.contains_text(normalized_symbol);
}

boolean mayam_pvp_symbols_available() {
    return !mayam_symbol_used("vessel")
        && !mayam_symbol_used("yam2")
        && !mayam_symbol_used("cheese")
        && !mayam_symbol_used("explosion");
}

void claim_mayam_pvp_fights() {
    if (!pref_bool("useMayamPvpFights", true)) {
        print("Mayam +5 PvP fights skipped by " + PREF + "useMayamPvpFights=false.", "yellow");
        return;
    }
    if (!have_item_or_equipped(MAYAM_CALENDAR)) {
        print("Mayam +5 PvP fights skipped; missing " + MAYAM_CALENDAR + ".", "yellow");
        return;
    }
    if (mayam_symbol_used("explosion")) {
        print("Mayam +5 PvP fights already claimed earlier today; explosion is already used.", "green");
        return;
    }
    if (!mayam_pvp_symbols_available()) {
        print("Mayam +5 PvP fights skipped; required symbols already used: "
            + get_property("_mayamSymbolsUsed") + ".", "yellow");
        return;
    }

    print("Mayam PvP symbol check passed with symbols used: "
        + get_property("_mayamSymbolsUsed") + ".", "teal");
    print("Claiming Mayam +5 PvP fights after the Hippy Stone break.", "teal");
    if (!cli_execute("mayam rings vessel yam cheese explosion")) {
        print("Mayam +5 PvP fight claim failed; continuing to pvp_mab.", "red");
        return;
    }
    if (!mayam_symbol_used("explosion")) {
        print("Mayam +5 PvP fight claim did not record explosion; continuing to pvp_mab.", "red");
    }
}

void spend_barf_turns_until(int target_adventures) {
    if (my_adventures() <= target_adventures) return;
    if (!can_adventure(BARF_MOUNTAIN)) {
        abort("Cannot adventure at " + BARF_MOUNTAIN + " to reach "
            + target_adventures + " adventures.");
    }

    string previous_battle_action = get_property("battleAction");
    string previous_ccs = get_property("customCombatScript");
    write_ccs(to_buffer("attack"), "UnderTheSeaPrep");
    set_ccs("UnderTheSeaPrep");
    set_property("battleAction", "custom combat script");

    try {
        int turns_spent = 0;
        while (my_adventures() > target_adventures) {
            if (turns_spent >= 100) {
                abort("Spent 100 turns at " + BARF_MOUNTAIN
                    + " without reaching " + target_adventures + " adventures.");
            }

            equip_organ_lock(true);
            verify_organ_lock("Before residual Barf Mountain turn", true);
            restore_hp("Before residual Barf Mountain turn");

            int turns_before = total_turns_played();
            if (!adventure(1, BARF_MOUNTAIN)) {
                abort("Adventure failed or timed out at " + BARF_MOUNTAIN + ".");
            }
            if (total_turns_played() != turns_before + 1) {
                abort("Expected one turn at " + BARF_MOUNTAIN + ".");
            }
            if (my_adventures() < target_adventures) {
                abort(BARF_MOUNTAIN + " burn passed the " + target_adventures
                    + "-adventure target.");
            }
            turns_spent = turns_spent + 1;
        }
    } finally {
        set_ccs(previous_ccs);
        set_property("battleAction", previous_battle_action);
    }
}

boolean rest_would_restore_something() {
    return my_hp() < my_maxhp() || my_mp() < my_maxmp();
}

void ensure_rest_is_needed() {
    if (rest_would_restore_something()) return;

    print("At full HP and MP; opening HP headroom for the confusing LED clock rest.", "teal");
    cli_execute("maximize hp, " + organ_lock_maximizer(true) + ", -tie");
    equip_organ_lock(true);
    verify_organ_lock("After maximizing HP for confusing LED clock rest", true);
    if (rest_would_restore_something()) return;

    skill dark_depths = to_skill("Dark Depths");
    if (dark_depths != $skill[none] && have_skill(dark_depths)) {
        print("HP maximization did not open a gap; casting Dark Depths before resting.", "teal");
        if (!use_skill(1, dark_depths)) abort("Failed to cast " + dark_depths + ".");
    }
    if (!rest_would_restore_something()) {
        abort("Unable to create HP or MP headroom for the confusing LED clock rest.");
    }
}

void convert_five_adventures_to_pvp() {
    if (my_adventures() != 5) {
        abort("Confusing LED clock conversion requires exactly five adventures; have "
            + my_adventures() + ".");
    }
    if (get_property("_confusingLEDClockUsed").to_boolean()) {
        abort(CONFUSING_LED_CLOCK + " was already used today.");
    }

    if (!get_property(INTERNAL + "confusingLedClockPending").to_boolean()) {
        acquire_confusing_led_clock();
        print("Using " + CONFUSING_LED_CLOCK + " for the final five adventures.", "teal");
        if (!use(1, CONFUSING_LED_CLOCK)) abort("Failed to use " + CONFUSING_LED_CLOCK + ".");
        set_property(INTERNAL + "confusingLedClockPending", "true");
    } else {
        print("Resuming the pending " + CONFUSING_LED_CLOCK + " conversion.", "teal");
    }

    break_hippy_stone();
    verify_organ_lock("Before confusing LED clock rest", true);
    ensure_rest_is_needed();

    string old_chateau = get_property("restUsingChateau");
    string old_campaway = get_property("restUsingCampAwayTent");
    set_property("restUsingChateau", "false");
    set_property("restUsingCampAwayTent", "false");
    try {
        run_cli("rest");
    } finally {
        set_property("restUsingChateau", old_chateau);
        set_property("restUsingCampAwayTent", old_campaway);
    }

    if (my_adventures() != 0) {
        abort(CONFUSING_LED_CLOCK + " rest left " + my_adventures()
            + " adventures; expected zero.");
    }
    if (!get_property("_confusingLEDClockUsed").to_boolean()) {
        abort(CONFUSING_LED_CLOCK + " rest conversion was not recorded.");
    }
    set_property(INTERNAL + "confusingLedClockPending", "false");
}

boolean burn_small_residual_turns(boolean trim_excess) {
    int adventures = my_adventures();
    if (adventures < 5) return false;
    if (adventures > 10) {
        if (!trim_excess) return false;
        print("Driftwood is not profitable; trimming " + adventures
            + " residual adventures to 10 at " + BARF_MOUNTAIN + ".", "teal");
        spend_barf_turns_until(10);
        adventures = my_adventures();
    }

    boolean prioritize_pvp = prioritize_pvp_with_leftovers();
    if (prioritize_pvp && get_property("_confusingLEDClockUsed").to_boolean()) {
        print(CONFUSING_LED_CLOCK + " was already used today; using the "
            + DAY_SHORTENER + " route instead.", "yellow");
        prioritize_pvp = false;
    }

    print("Routing " + adventures + " residual adventures before the pre-Valhalla checkpoint.", "teal");
    if (prioritize_pvp) {
        if (adventures == 10 && remaining_organ_lock_turns() <= 5) {
            use_day_shortener();
        } else {
            spend_barf_turns_until(5);
        }
        convert_five_adventures_to_pvp();
    } else {
        int barf_turns = adventures - 5;
        if (remaining_organ_lock_turns() > barf_turns) {
            abort("Cannot use the final " + DAY_SHORTENER + ": expanded-organ gear must remain locked for "
                + remaining_organ_lock_turns() + " more turns, but this route spends only "
                + barf_turns + " Barf Mountain turn(s).");
        }
        spend_barf_turns_until(5);
        use_day_shortener();
    }

    verify_organ_lock("After residual turn routing", true);
    if (my_adventures() != 0) {
        abort("Residual turn routing left " + my_adventures() + " adventures.");
    }
    verify_organ_turn_commitment();
    set_property(INTERNAL + "organLockActive", "false");
    return true;
}

void ensure_combo_available() {
    if (have_item_or_equipped(BEACH_COMB) || have_item_or_equipped(DRIFTWOOD_COMB)) return;
    if (my_adventures() <= 0) return;

    int sand_value = mall_price(GRAIN_OF_SAND) * 3;
    int driftwood_price = mall_price(DRIFTWOOD);
    if (sand_value <= 0 || driftwood_price <= 0) {
        abort("Unable to value driftwood combo purchase. Three grains of sand: " + sand_value
            + " Meat; piece of driftwood: " + driftwood_price + " Meat.");
    }

    int purchase_threshold = driftwood_price / sand_value;
    if (my_adventures() <= purchase_threshold) {
        if (burn_small_residual_turns(true)) return;
        abort("Driftwood beach comb is not profitable for the required turn burn. Adventures: "
            + my_adventures() + "; threshold: " + purchase_threshold + "; driftwood: "
            + driftwood_price + " Meat; three grains of sand: " + sand_value + " Meat.");
    }

    run_cli("buy 1 piece of driftwood");
    run_cli("use piece of driftwood");
    if (!have_item_or_equipped(DRIFTWOOD_COMB)) {
        abort("Failed to create driftwood beach comb.");
    }
}

void burn_remaining_turns() {
    equip_organ_lock(true);
    verify_organ_lock("Before combo burn", true);
    if (burn_small_residual_turns(false)) return;
    ensure_combo_available();

    int unused_free_combs = max(0, 11 - get_property("_freeBeachWalksUsed").to_int());
    if (my_adventures() <= 0) {
        if (unused_free_combs > 0
            && !have_item_or_equipped(BEACH_COMB)
            && !have_item_or_equipped(DRIFTWOOD_COMB)) {
            print("Skipping " + unused_free_combs
                + " unused free beach walks: no comb is available and no turn burn remains.", "yellow");
        }
        verify_organ_turn_commitment();
        set_property(INTERNAL + "organLockActive", "false");
        return;
    }
    if (!have_item_or_equipped(BEACH_COMB) && !have_item_or_equipped(DRIFTWOOD_COMB)) {
        verify_organ_turn_commitment();
        return;
    }

    int requested_combs = my_adventures() + unused_free_combs;
    run_cli("combo " + requested_combs);

    verify_organ_lock("After combo burn", true);
    if (my_adventures() > 0) {
        abort("Combo burn left " + my_adventures() + " adventures.");
    }
    if (get_property("_freeBeachWalksUsed").to_int() < 11) {
        abort("Combo burn left unused free beach walks: "
            + (11 - get_property("_freeBeachWalksUsed").to_int()) + ".");
    }

    verify_organ_turn_commitment();
    set_property(INTERNAL + "organLockActive", "false");
}

void burn_remaining_turns_without_organ_lock() {
    if (my_adventures() <= 0) return;

    string command = pref_string("plainTurnBurnCommand",
        loop_pref_string("leg1OverflowGarboCommand", "garbo nodiet"));
    if (command == "") {
        abort("Non-organ Leg1 cleanup has " + my_adventures()
            + " adventure(s) to burn, but no plain turn-burn command is configured.");
    }

    print("Burning " + my_adventures()
        + " non-organ Leg1 cleanup adventure(s) with " + command + ".", "teal");
    run_cli(command + " turns=" + my_adventures());
    if (my_adventures() > 0) {
        abort("Non-organ Leg1 cleanup turn burn left " + my_adventures()
            + " adventure(s).");
    }
}

void prep_and_run_pvp() {
    if (!pref_bool("runPvp", true)) {
        print("PvP skipped by " + PREF + "runPvp=false.", "yellow");
        return;
    }

    break_hippy_stone();
    claim_mayam_pvp_fights();
    item fire = $item[CSA fire-starting kit];
    if (item_amount(fire) > 0 && !get_property("_fireStartingKitUsed").to_boolean()) {
        string old_choice = get_property("choiceAdventure595");
        set_property("choiceAdventure595", "1");
        use(1, fire);
        set_property("choiceAdventure595", old_choice);
    }
    run_cli("pvp_mab");
}

void print_fishy_status() {
    print("Fishy turns: " + have_effect($effect[Fishy]), "teal");
    print("- fishy pipe available: " + have_item_or_equipped(FISHY_PIPE)
        + "; used today: " + get_property("_fishyPipeUsed"));
    print("- Lutz skate-park Fishy buff used today: " + get_property("_skateBuff1"));
    print("- cuppa Gill tea held: " + available_amount(GILL_TEA)
        + "; mall price: " + mall_price(GILL_TEA)
        + "; configured cap: " + pref_int("gillTeaMaxPrice", 100000));
}

void print_air_supply_status() {
    print("Underwater air-supply candidates:", "teal");
    print("- " + SWIMMING_TRUNKS + ": " + have_item_or_equipped(SWIMMING_TRUNKS)
        + "; pants locked: " + pants_lock_required());
    foreach i, supply in HAT_AIR_SUPPLIES {
        print("- " + supply + ": " + have_item_or_equipped(supply));
    }
    print("- " + OLD_SCUBA_TANK + ": " + have_item_or_equipped(OLD_SCUBA_TANK));
    print("- " + ELF_GUARD_SCUBA_TANK + ": " + have_item_or_equipped(ELF_GUARD_SCUBA_TANK));
}

void print_residual_turn_status() {
    boolean prioritize = prioritize_pvp_with_leftovers();
    print("Residual-turn routing:", "teal");
    print("- prioritize PvP with leftovers: " + prioritize
        + "; " + PREF + "runPvp: " + pref_bool("runPvp", true));
    print("- " + CONFUSING_LED_CLOCK + " held: " + available_amount(CONFUSING_LED_CLOCK)
        + "; used today: " + get_property("_confusingLEDClockUsed")
        + "; conversion pending: " + get_property(INTERNAL + "confusingLedClockPending")
        + "; configured cap: " + pref_int("confusingLedClockMaxPrice", 100000));
    print("- " + DAY_SHORTENER + " held: " + available_amount(DAY_SHORTENER)
        + "; leaf craft used today: " + get_property("_leafDayShortenerCrafted"));
    print("- Mayam +5 PvP fights: " + pref_bool("useMayamPvpFights", true)
        + "; calendar available: " + have_item_or_equipped(MAYAM_CALENDAR)
        + "; symbols used: " + get_property("_mayamSymbolsUsed"));
    print("- final KoLmafia breakfast sweep: " + pref_bool("runLateBreakfast", true)
        + "; completed today: " + get_property("breakfastCompleted")
        + "; command: \"" + pref_string("lateBreakfastCommand", "breakfast") + "\"");
    print("- final Chroner cleanup: available-gated"
        + "; trigger used: " + get_property("_chronerTriggerUsed")
        + "; cross used: " + get_property("_chronerCrossUsed"));
    print("- Mr. Store 2002: spend=" + pref_bool("spend2002Credits", true)
        + "; reward=\"" + pref_string("mrStore2002Reward", "Spooky VHS Tape") + "\""
        + "; credits=" + get_property("availableMrStore2002Credits"));
    print("- pre-ascension Cookbookbat food crafting: one of each Legend, three of each lower tier; enabled="
        + pref_bool("craftPreAscendCookbookbatFoods", true));
    print_preascension_cookbookbat_status();
}

void status() {
    print("UnderTheSeaPrep status", "blue");
    print("Adventures: " + my_adventures());
    print("Fullness: " + my_fullness() + "/" + fullness_limit());
    print("Inebriety: " + my_inebriety() + "/" + inebriety_limit());
    print("Spleen: " + my_spleen_use() + "/" + spleen_limit());
    print("Organ lock active: " + organ_lock_active() + "; until turn: " + organ_lock_until_turn());
    print("Buffed Muscle: " + my_buffedstat($stat[Muscle])
        + "; floor: " + pref_int("muscleFloor", 2000));
    print("Pearl familiar: " + configured_pearl_familiar()
        + "; familiar equipment: " + configured_pearl_familiar_equipment());
    print("Held pearls: " + held_pearl_count() + "; mounted pearls: " + mounted_pearl_count());
    print_pearl_plan();
    print_fishy_status();
    print_air_supply_status();
    print("Free beach walks remaining: " + max(0, 11 - get_property("_freeBeachWalksUsed").to_int()));
    print_residual_turn_status();
}

void require_preflight_items() {
    require_item(WINEGLASS, "Preflight");
    require_item(CODPIECE, "Preflight");
    require_item(ANGELBONE_TOTEM, "Preflight");
    require_item(DEVILBONE_CORSET, "Preflight");
    require_item(DEVILBONE_GREAVES, "Preflight");
    require_item(ANGELBONE_CHOPSTICKS, "Preflight");
    item familiar_item = configured_pearl_familiar_equipment();
    if (familiar_item != $item[none]) require_item(familiar_item, "Preflight");
    if (!have_familiar(STOOPER)) abort("Preflight: missing Stooper.");
    familiar fam = configured_pearl_familiar();
    if (fam != $familiar[none] && !have_familiar(fam)) {
        abort("Preflight: missing configured pearl familiar " + fam + ".");
    }
}

void preflight() {
    print("UnderTheSeaPrep preflight", "blue");
    require_preflight_items();
    item [slot] snapshot = equipment_snapshot();

    int guaranteed_fullness = 0;
    int guaranteed_spleen = 0;
    try {
        equip_organ_lock(true);
        guaranteed_fullness = organ_lock_item_capacity("Stomach Capacity");
        guaranteed_spleen = organ_lock_item_capacity("Spleen Capacity");
    } finally {
        restore_equipment(snapshot);
    }
    if (guaranteed_fullness <= 0 || guaranteed_spleen <= 0) {
        abort("Unable to determine the expanded-organ gear capacity for preflight: "
            + guaranteed_fullness + " fullness, " + guaranteed_spleen + " spleen.");
    }

    int required_after_consume = max(pref_int("minOrganLockTurns", 50), pearl_budget());

    print("Guaranteed expanded-organ gear capacity: " + guaranteed_fullness
        + " fullness, " + guaranteed_spleen + " spleen.", "teal");
    print("Second-consume yield estimate: deferred until after the first nightcap.", "teal");
    print("Projected required post-consume turns: " + required_after_consume, "teal");
    print("Turns to retain before limited Garbo: calculated from the authoritative post-nightcap simulation.", "teal");
    print("Current adventures: " + my_adventures(), "teal");
    print_pearl_plan();
    print_fishy_status();
    print_air_supply_status();
    print_preascension_cookbookbat_status();
    print("Preflight complete. No resources consumed.", "green");
}

void postgarbo() {
    require_preflight_items();
    collect_safe_rumpus_adventures();
    if (organ_lock_active()) {
        resume_locked_organs();
    } else {
        collect_post_garbo_organs();
    }
    require_checkpoint_turn_budget();
    farm_selected_pearls();
    loop_profit_marker("leg1_pearls_done");
    preascension_acquisitions();
    mount_codpiece_pearls();
    collect_remaining_breakfast_resources();
    use_remaining_chroner_items();
    spend_mr_store_2002_credits();
    craft_preascension_cookbookbat_foods();
    burn_remaining_turns();
    prep_and_run_pvp();
    print("UnderTheSeaPrep checkpoint complete. Ready for the pre-Valhalla stop.", "green");
}

void finishplain() {
    collect_safe_rumpus_adventures();
    preascension_acquisitions();
    mount_codpiece_pearls();
    collect_remaining_breakfast_resources();
    use_remaining_chroner_items();
    spend_mr_store_2002_credits();
    craft_preascension_cookbookbat_foods();
    burn_remaining_turns_without_organ_lock();
    prep_and_run_pvp();
    print("UnderTheSeaPrep non-organ checkpoint complete. Ready for the pre-Valhalla stop.", "green");
}

void pearls() {
    require_preflight_items();
    equip_organ_lock(true);
    farm_selected_pearls();
    print("Pearl farming checkpoint complete.", "green");
}

void help() {
    print("Usage: UnderTheSeaPrep status | preflight | postgarbo | finishplain | pearls | mount", "teal");
    print("postgarbo starts after the first garbo ascend and stops before Valhalla.");
    print("finishplain skips Wineglass/organ-lock farming and finishes with held or purchased pearls.");
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
        case "postgarbo":
            postgarbo();
            return;
        case "finishplain":
        case "finish plain":
            finishplain();
            return;
        case "pearls":
            pearls();
            return;
        case "mount":
            mount_codpiece_pearls();
            return;
        default:
            help();
            return;
    }
}
