script "relay_LoopTheSea";

/*
LoopTheSea relay preference manager.

This relay script edits LoopTheSea-related preferences only. It intentionally
does not run LoopTheSea, spend resources, consume diet, or ascend.
*/

string LOOP_PREF = "loopTheSea_";
string PREP_PREF = "underTheSeaPrep_";

string html(string value) {
    return entity_encode(value);
}

string checked_attr(string property_name) {
    if (get_property(property_name).to_boolean()) return " checked";
    return "";
}

void save_bool(string [string] fields, string property_name) {
    set_property(property_name, (fields contains property_name) ? "true" : "false");
}

void save_string(string [string] fields, string property_name) {
    if (fields contains property_name) set_property(property_name, fields[property_name]);
}

void write_header() {
    writeln("<!doctype html>");
    writeln("<html><head><title>LoopTheSea Preferences</title>");
    writeln("<style>");
    writeln("body{font-family:Arial,Helvetica,sans-serif;background:#f4f1e8;color:#24211d;margin:0;padding:18px;}");
    writeln("main{max-width:1180px;margin:0 auto;}");
    writeln("h1{margin:0 0 6px;font-size:28px;}");
    writeln("h2{margin:0 0 10px;font-size:19px;}");
    writeln(".lede{margin:0 0 18px;color:#5b5147;}");
    writeln(".notice{background:#fff6d6;border:1px solid #d8b85f;padding:10px 12px;margin:12px 0;border-radius:6px;}");
    writeln(".success{background:#e8f7e7;border:1px solid #80bd7a;padding:10px 12px;margin:12px 0;border-radius:6px;}");
    writeln(".grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(330px,1fr));gap:14px;align-items:start;}");
    writeln("fieldset{background:#fff;border:1px solid #cfc7ba;border-radius:8px;margin:0;padding:14px;}");
    writeln("legend{font-weight:bold;padding:0 6px;}");
    writeln(".row{display:grid;grid-template-columns:minmax(150px,38%) 1fr;gap:10px;align-items:center;border-top:1px solid #eee5d9;padding:8px 0;}");
    writeln(".row:first-of-type{border-top:0;}");
    writeln("label{font-weight:bold;}");
    writeln(".help{display:block;font-weight:normal;color:#70665c;font-size:12px;margin-top:2px;line-height:1.25;}");
    writeln("input[type=text],input[type=number],select{width:100%;box-sizing:border-box;padding:6px;border:1px solid #bdb4a8;border-radius:5px;background:#fff;}");
    writeln("input[type=checkbox]{transform:scale(1.15);}");
    writeln(".actions{position:sticky;bottom:0;background:#ede6d8;border:1px solid #c9bfaf;border-radius:8px;margin-top:14px;padding:12px;display:flex;gap:10px;flex-wrap:wrap;}");
    writeln("button,input[type=submit]{background:#2f5d7c;color:#fff;border:0;border-radius:5px;padding:8px 12px;font-weight:bold;cursor:pointer;}");
    writeln(".secondary{background:#72685f;}");
    writeln(".summary{display:grid;grid-template-columns:repeat(auto-fit,minmax(170px,1fr));gap:8px;margin:12px 0 18px;}");
    writeln(".pill{background:#fff;border:1px solid #d3c9bb;border-radius:6px;padding:8px;}");
    writeln(".pill b{display:block;font-size:12px;color:#6f6257;text-transform:uppercase;letter-spacing:.04em;}");
    writeln("code{background:#eee5d9;padding:1px 4px;border-radius:3px;}");
    writeln("</style></head><body><main>");
}

void write_footer() {
    writeln("</main></body></html>");
}

void write_summary() {
    writeln("<div class='summary'>");
    writeln("<div class='pill'><b>Path</b>" + html(my_path().to_string()) + "</div>");
    writeln("<div class='pill'><b>Class</b>" + html(my_class().to_string()) + "</div>");
    writeln("<div class='pill'><b>Adventures</b>" + my_adventures() + "</div>");
    writeln("<div class='pill'><b>Ascensions</b>" + my_ascensions() + "</div>");
    writeln("<div class='pill'><b>Meat</b>" + my_meat() + "</div>");
    writeln("<div class='pill'><b>Can Interact</b>" + (can_interact() ? "true" : "false") + "</div>");
    writeln("</div>");
}

void row_start(string property_name, string label, string help) {
    writeln("<div class='row'>");
    write("<label for='" + html(property_name) + "'>" + html(label));
    if (help != "") write("<span class='help'>" + html(help) + "</span>");
    writeln("</label>");
}

void row_end() {
    writeln("</div>");
}

void write_bool(string property_name, string label, string help) {
    row_start(property_name, label, help);
    writeln("<div><input id='" + html(property_name) + "' type='checkbox' name='" + html(property_name) + "' value='true'" + checked_attr(property_name) + "></div>");
    row_end();
}

void write_text(string property_name, string label, string help) {
    row_start(property_name, label, help);
    writeln("<input id='" + html(property_name) + "' type='text' name='" + html(property_name) + "' value=\"" + html(get_property(property_name)) + "\">");
    row_end();
}

void write_number(string property_name, string label, string help) {
    row_start(property_name, label, help);
    writeln("<input id='" + html(property_name) + "' type='number' name='" + html(property_name) + "' value=\"" + html(get_property(property_name)) + "\">");
    row_end();
}

void write_option(string current, string value, string label) {
    write("<option value=\"" + html(value) + "\"");
    if (current == value) write(" selected");
    writeln(">" + html(label) + "</option>");
}

void write_select(string property_name, string label, string help, string option_spec) {
    row_start(property_name, label, help);
    string current = get_property(property_name);
    writeln("<select id='" + html(property_name) + "' name='" + html(property_name) + "'>");
    foreach i, raw in option_spec.split_string("\\|") {
        string value = raw;
        string option_label = raw;
        int separator = raw.index_of("=");
        if (separator >= 0) {
            value = raw.substring(0, separator);
            option_label = raw.substring(separator + 1);
        }
        write_option(current, value, option_label);
    }
    writeln("</select>");
    row_end();
}

void save_all(string [string] fields) {
    save_bool(fields, LOOP_PREF + "runInitialGarbo");
    save_bool(fields, LOOP_PREF + "preserveInitialGarboFishy");
    save_bool(fields, LOOP_PREF + "allowPartialInitialGarboRetry");
    save_bool(fields, LOOP_PREF + "requireInitialGarboCompleted");
    save_bool(fields, LOOP_PREF + "stopAfterLeg1");
    save_bool(fields, LOOP_PREF + "leg2RunAfterUnderSea");
    save_string(fields, LOOP_PREF + "initialGarboCommand");

    save_bool(fields, LOOP_PREF + "ascendEnabled");
    save_string(fields, LOOP_PREF + "ascensionType");
    save_string(fields, LOOP_PREF + "pathId");
    save_string(fields, LOOP_PREF + "className");
    save_string(fields, LOOP_PREF + "moonId");
    save_string(fields, LOOP_PREF + "gender");
    save_string(fields, LOOP_PREF + "astralDeli");
    save_string(fields, LOOP_PREF + "astralPet");
    save_string(fields, LOOP_PREF + "permSkills");
    save_string(fields, LOOP_PREF + "permMinimumBankedKarma");
    save_bool(fields, LOOP_PREF + "stopAfterAscension");

    save_string(fields, PREP_PREF + "pearlPolicy");
    save_string(fields, PREP_PREF + "gillTeaMaxPrice");
    save_string(fields, PREP_PREF + "pearlBuffer");
    save_string(fields, PREP_PREF + "minOrganLockTurns");
    save_string(fields, PREP_PREF + "muscleFloor");
    save_string(fields, PREP_PREF + "extraPearlBuffCommands");
    save_bool(fields, PREP_PREF + "runPvp");

    save_string(fields, LOOP_PREF + "leg2PearlMode");
    save_string(fields, LOOP_PREF + "leg2PearlTargetCount");
    save_string(fields, LOOP_PREF + "leg2PearlBuffer");
    save_string(fields, LOOP_PREF + "leg2PearlResTarget");
    save_bool(fields, LOOP_PREF + "leg2BuildPantogram");
    save_bool(fields, LOOP_PREF + "leg2RequirePantogramPressure");
    save_string(fields, LOOP_PREF + "leg2PantogramStat");
    save_string(fields, LOOP_PREF + "leg2PantogramElement");
    save_string(fields, LOOP_PREF + "leg2PantogramLeftSacrifice");
    save_bool(fields, LOOP_PREF + "leg2InstallSaltwaterbed");
    save_bool(fields, LOOP_PREF + "leg2AutoApproveSaltwaterbedReplace");
    save_string(fields, LOOP_PREF + "leg2SealeatherMaxPrice");

    save_string(fields, LOOP_PREF + "leg2FishyTopupMode");
    save_string(fields, LOOP_PREF + "leg2GillTeaMaxPrice");
    save_string(fields, LOOP_PREF + "leg2FishSauceMaxPrice");
    save_bool(fields, LOOP_PREF + "leg2UseBofaFishy");
    save_string(fields, LOOP_PREF + "leg2BofaFishyMaxAttempts");
    save_string(fields, LOOP_PREF + "leg2BofaFishyLocation");
    save_bool(fields, LOOP_PREF + "leg2UsePressureConsumables");
    save_bool(fields, LOOP_PREF + "leg2UseResistanceBuffs");
    save_bool(fields, LOOP_PREF + "leg2UseResistancePotionRescue");
    save_string(fields, LOOP_PREF + "leg2ResistancePotionTotalCap");
    save_string(fields, LOOP_PREF + "leg2ExtraPearlBuffCommands");

    save_bool(fields, LOOP_PREF + "leg2ConsumeBeforePearls");
    save_string(fields, LOOP_PREF + "leg2ConsumeMode");
    save_string(fields, LOOP_PREF + "leg2ConsumeCommand");
    save_bool(fields, LOOP_PREF + "leg2AllowBoozeConsume");
    save_bool(fields, LOOP_PREF + "leg2AllowRiskyConsume");
    save_string(fields, LOOP_PREF + "leg2PearlFamiliarMode");
    save_bool(fields, LOOP_PREF + "leg2GarboAfterPearls");
    save_string(fields, LOOP_PREF + "leg2GarboCommand");
    save_bool(fields, LOOP_PREF + "leg2RequireGarboSpendAllTurns");
    save_bool(fields, LOOP_PREF + "leg2RunBreakfastSweep");
    save_bool(fields, LOOP_PREF + "leg2RunLateDailySweep");
    save_bool(fields, LOOP_PREF + "leg2RunFinalNightcap");
    save_string(fields, LOOP_PREF + "leg2FinalNightcapCommand");
    save_bool(fields, LOOP_PREF + "leg2RunExpandedOrgansRollover");
    save_bool(fields, LOOP_PREF + "leg2UseWetDatesRollover");
    save_string(fields, LOOP_PREF + "leg2WetDatesMaxPrice");
    save_bool(fields, LOOP_PREF + "leg2PrepareRollover");
    save_string(fields, LOOP_PREF + "leg2RolloverAdventureCap");
    save_string(fields, LOOP_PREF + "leg2RolloverMaximizer");

    save_bool(fields, LOOP_PREF + "profitTrackingEnabled");
    save_bool(fields, LOOP_PREF + "profitTrackingRequired");
    save_bool(fields, LOOP_PREF + "profitTrackingRecap");
    save_string(fields, LOOP_PREF + "profitMarkerPrefix");
    save_bool(fields, LOOP_PREF + "useGovernmentPerDiem");
    save_string(fields, LOOP_PREF + "dailyRaffleTickets");
    save_bool(fields, LOOP_PREF + "protectPorquoiseBeforeUnderSea");

}

void apply_alpha_defaults() {
    set_property(LOOP_PREF + "ascendEnabled", "false");
    set_property(LOOP_PREF + "runInitialGarbo", "false");
    set_property(LOOP_PREF + "stopAfterLeg1", "true");
    set_property(LOOP_PREF + "stopAfterAscension", "true");
    set_property(LOOP_PREF + "leg2RunAfterUnderSea", "false");
    set_property(LOOP_PREF + "leg2PearlMode", "REPORT");
    set_property(LOOP_PREF + "leg2InstallSaltwaterbed", "false");
    set_property(LOOP_PREF + "leg2UseWetDatesRollover", "false");
    set_property(LOOP_PREF + "profitTrackingRequired", "false");
    set_property(LOOP_PREF + "protectPorquoiseBeforeUnderSea", "true");
    set_property(PREP_PREF + "pearlPolicy", "ALWAYS");
}

void write_run_flow_section() {
    writeln("<fieldset><legend>Run Flow and Safety</legend>");
    write_bool(LOOP_PREF + "runInitialGarbo", "Run initial Garbo", "Let LoopTheSea start Leg1 with the configured initial Garbo command.");
    write_text(LOOP_PREF + "initialGarboCommand", "Initial Garbo command", "Usually garbo ascend.");
    write_bool(LOOP_PREF + "preserveInitialGarboFishy", "Preserve Fishy during initial Garbo", "Hide Fishy pipe/Lutz availability from initial Garbo where possible.");
    write_bool(LOOP_PREF + "allowPartialInitialGarboRetry", "Allow partial initial Garbo retry", "Advanced recovery option after a failed or interrupted Garbo.");
    write_bool(LOOP_PREF + "requireInitialGarboCompleted", "Require initial Garbo completion", "Abort when Garbo does not look complete.");
    write_bool(LOOP_PREF + "stopAfterLeg1", "Stop after Leg1", "Useful for staged alpha testing before automated ascension.");
    write_bool(LOOP_PREF + "leg2RunAfterUnderSea", "Continue after UnderTheSea", "Let LoopTheSea run the post-UnderTheSea Leg2 branch.");
    writeln("</fieldset>");
}

void write_ascension_section() {
    writeln("<fieldset><legend>Automated Ascension</legend>");
    write_bool(LOOP_PREF + "ascendEnabled", "Enable automated ascension", "Required before LoopTheSea can cross Valhalla.");
    write_select(LOOP_PREF + "ascensionType", "Ascension type", "2 is normal. Review before changing.", "1=Hardcore|2=Normal");
    write_number(LOOP_PREF + "pathId", "Path ID", "11,037 Leagues Under the Sea is 55.");
    write_select(LOOP_PREF + "className", "Class", "Leave unset for manual/staged testing.", "=(unset)|Seal Clubber|Turtle Tamer|Pastamancer|Sauceror|Disco Bandit|Accordion Thief");
    write_select(LOOP_PREF + "moonId", "Moon sign", "Platypus is 4.", "=(unset)|1|2|3|4|5|6|7|8|9");
    write_select(LOOP_PREF + "gender", "Gender", "KoL afterlife numeric gender selection.", "=(unset)|1|2");
    write_select(LOOP_PREF + "astralDeli", "Astral deli", "One item can be bought per Valhalla visit.", "=(unset)|none|astral six-pack|astral hot dog dinner|astral energy drink");
    write_select(LOOP_PREF + "astralPet", "Astral pet", "Usually none for this loop.", "=(unset)|none");
    write_select(LOOP_PREF + "permSkills", "Perm skills", "ALL_HC tries offered Hardcore perms while respecting the Karma floor.", "NONE|ALL_HC|ALL_SOFTCORE");
    write_number(LOOP_PREF + "permMinimumBankedKarma", "Minimum banked Karma", "Perming stops before going below this amount.");
    write_bool(LOOP_PREF + "stopAfterAscension", "Stop after ascension", "Keep this on while testing the Valhalla crossing.");
    writeln("</fieldset>");
}

void write_leg1_section() {
    writeln("<fieldset><legend>Leg1 UnderTheSeaPrep</legend>");
    write_select(PREP_PREF + "pearlPolicy", "Pearl policy", "ALWAYS farms all unfinished Leg1 pearl zones.", "ALWAYS|ENSURE_FIVE|NEVER");
    write_number(PREP_PREF + "gillTeaMaxPrice", "Gill tea max price", "Leg1 paid Fishy fallback.");
    write_number(PREP_PREF + "pearlBuffer", "Pearl buffer", "Extra turns reserved for Sea variance.");
    write_number(PREP_PREF + "minOrganLockTurns", "Minimum organ-lock turns", "Usually 50.");
    write_number(PREP_PREF + "muscleFloor", "Muscle floor", "Leg1 overdrunk combat safety floor.");
    write_text(PREP_PREF + "extraPearlBuffCommands", "Extra pearl buff commands", "Optional CLI commands before Leg1 pearl turns.");
    write_bool(PREP_PREF + "runPvp", "Run pvp_mab", "End-of-Leg1 PvP after the stone break setup.");
    writeln("</fieldset>");
}

void write_leg2_pearl_section() {
    writeln("<fieldset><legend>Leg2 Pearls and Fishy</legend>");
    write_select(LOOP_PREF + "leg2PearlMode", "Pearl mode", "REPORT is safest for first testers; FARM/ALWAYS spends turns.", "REPORT|FARM|ALWAYS|NEVER");
    write_number(LOOP_PREF + "leg2PearlTargetCount", "Pearl target", "Usually 5.");
    write_number(LOOP_PREF + "leg2PearlBuffer", "Pearl buffer", "Extra turns reserved for Sea variance.");
    write_number(LOOP_PREF + "leg2PearlResTarget", "Resistance target", "Usually 18.");
    write_bool(LOOP_PREF + "leg2BuildPantogram", "Build Pantogram pants", "Build post-UnderTheSea pants for pressure and resistance.");
    write_bool(LOOP_PREF + "leg2RequirePantogramPressure", "Require pressure Pantogram", "Abort if pants lack the sea salt crystal pressure modifier.");
    write_select(LOOP_PREF + "leg2PantogramStat", "Pantogram stat", "Main stat modifier.", "muscle|mysticality|moxie");
    write_select(LOOP_PREF + "leg2PantogramElement", "Pantogram resistance", "auto picks the weakest pearl-zone resistance.", "auto|hot|cold|spooky|stench|sleaze");
    write_text(LOOP_PREF + "leg2PantogramLeftSacrifice", "Pantogram left sacrifice", "glowing New Age crystal or mp fallback.");
    write_bool(LOOP_PREF + "leg2InstallSaltwaterbed", "Install saltwaterbed", "May replace existing campground furniture.");
    write_bool(LOOP_PREF + "leg2AutoApproveSaltwaterbedReplace", "Auto-approve bed replace", "Avoids the KoLmafia confirmation popup.");
    write_number(LOOP_PREF + "leg2SealeatherMaxPrice", "Sea leather cap", "Used when acquiring saltwaterbed parts.");
    write_select(LOOP_PREF + "leg2FishyTopupMode", "Paid Fishy top-up", "AUTO buys paid Fishy only when expected to be justified.", "AUTO|ALWAYS|NEVER");
    write_number(LOOP_PREF + "leg2GillTeaMaxPrice", "Gill tea cap", "Paid Fishy fallback cap.");
    write_number(LOOP_PREF + "leg2FishSauceMaxPrice", "Fish sauce cap", "Cheap spleen Fishy source cap.");
    write_bool(LOOP_PREF + "leg2UseBofaFishy", "Use BOFA Fishy", "Seal Clubber Monodent some fish routing where available.");
    write_number(LOOP_PREF + "leg2BofaFishyMaxAttempts", "BOFA Fishy attempts", "Maximum Just the Facts Fishy attempts.");
    write_text(LOOP_PREF + "leg2BofaFishyLocation", "BOFA Fishy location", "Usually Shadow Rift for the Seal Clubber Monodent route.");
    write_bool(LOOP_PREF + "leg2UsePressureConsumables", "Use pressure consumables", "Fastjuice, salt, cartilage, razor where configured.");
    write_bool(LOOP_PREF + "leg2UseResistanceBuffs", "Use resistance buffs", "Low-cost resistance support for pearl zones.");
    write_bool(LOOP_PREF + "leg2UseResistancePotionRescue", "Use resistance potion rescue", "Buy/apply low-cost rescue potions if outfit is short.");
    write_number(LOOP_PREF + "leg2ResistancePotionTotalCap", "Resistance potion total cap", "Total cap for rescue potions.");
    write_text(LOOP_PREF + "leg2ExtraPearlBuffCommands", "Extra Leg2 pearl buffs", "Optional CLI commands before Leg2 pearl turns.");
    writeln("</fieldset>");
}

void write_leg2_finish_section() {
    writeln("<fieldset><legend>Leg2 Consume, Garbo, and Rollover</legend>");
    write_bool(LOOP_PREF + "leg2ConsumeBeforePearls", "Consume before pearls", "Use diet to fund post-UnderTheSea actions.");
    write_select(LOOP_PREF + "leg2ConsumeMode", "Consume mode", "IF_NEEDED skips consume if turn budget is already funded.", "ALWAYS|IF_NEEDED|NEVER");
    write_text(LOOP_PREF + "leg2ConsumeCommand", "Consume command", "Usually CONSUME ALL.");
    write_bool(LOOP_PREF + "leg2AllowBoozeConsume", "Allow booze consume", "Permit booze in Leg2 consume.");
    write_bool(LOOP_PREF + "leg2AllowRiskyConsume", "Allow risky consume", "Leave false for public alpha.");
    write_select(LOOP_PREF + "leg2PearlFamiliarMode", "Pearl familiar mode", "AUTO chooses from available familiar plans.", "AUTO|Urchin Urchin|Hobo Monkey|Grouper Groupie|none");
    write_bool(LOOP_PREF + "leg2GarboAfterPearls", "Run Garbo after pearls", "Spend remaining Leg2 turns with Garbo.");
    write_text(LOOP_PREF + "leg2GarboCommand", "Leg2 Garbo command", "Usually garbo.");
    write_bool(LOOP_PREF + "leg2RequireGarboSpendAllTurns", "Require Garbo spend-all", "Abort if Leg2 Garbo leaves turns unexpectedly.");
    write_bool(LOOP_PREF + "leg2RunBreakfastSweep", "Run Leg2 breakfast sweep", "Runs configured breakfast sweep before later Leg2 work.");
    write_bool(LOOP_PREF + "leg2RunLateDailySweep", "Run late daily sweep", "Collect remaining daily resources before final rollover consume.");
    write_bool(LOOP_PREF + "leg2RunFinalNightcap", "Run final nightcap", "Use configured nightcap command before rollover prep.");
    write_text(LOOP_PREF + "leg2FinalNightcapCommand", "Nightcap command", "Usually CONSUME NIGHTCAP.");
    write_bool(LOOP_PREF + "leg2RunExpandedOrgansRollover", "Run expanded organs", "Use organ gear after nightcap for rollover turns.");
    write_bool(LOOP_PREF + "leg2UseWetDatesRollover", "Use wet dates", "Eat pile of wet dates for tomorrow's rollover effect.");
    write_number(LOOP_PREF + "leg2WetDatesMaxPrice", "Wet dates max price", "Mall cap for pile of wet dates.");
    write_bool(LOOP_PREF + "leg2PrepareRollover", "Prepare rollover outfit", "Run rollover maximizer at the end.");
    write_number(LOOP_PREF + "leg2RolloverAdventureCap", "Rollover cap", "Usually 200.");
    write_text(LOOP_PREF + "leg2RolloverMaximizer", "Rollover maximizer", "Usually adv, 0.001 pvp fights, -tie.");
    writeln("</fieldset>");
}

void write_tracking_section() {
    writeln("<fieldset><legend>Tracking and Dailies</legend>");
    write_bool(LOOP_PREF + "profitTrackingEnabled", "Enable ptrack markers", "Writes LoopTheSea profit markers when ptrack is available.");
    write_bool(LOOP_PREF + "profitTrackingRequired", "Require ptrack", "Abort if ptrack is missing.");
    write_bool(LOOP_PREF + "profitTrackingRecap", "Print ptrack recap", "Compare markers at the end of major branches.");
    write_text(LOOP_PREF + "profitMarkerPrefix", "Profit marker prefix", "Usually lts.");
    write_bool(LOOP_PREF + "useGovernmentPerDiem", "Use government per-diem", "Safe daily meat pickup.");
    write_number(LOOP_PREF + "dailyRaffleTickets", "Daily raffle tickets", "Tickets to buy when the Raffle House is accessible.");
    write_bool(LOOP_PREF + "protectPorquoiseBeforeUnderSea", "Protect porquoise", "Closet porquoise before UnderTheSea when Pantogram is planned.");
    writeln("</fieldset>");
}

void main() {
    string [string] fields = form_fields();
    string message = "";

    if (fields contains "save") {
        save_all(fields);
        message = "Preferences saved.";
    } else if (fields contains "alpha_defaults") {
        apply_alpha_defaults();
        message = "Alpha-safe defaults applied.";
    }

    write_header();
    writeln("<h1>LoopTheSea Preferences</h1>");
    writeln("<p class='lede'>A relay-browser manager for LoopTheSea and UnderTheSeaPrep preferences.</p>");
    writeln("<div class='notice'>This page only edits preferences. It does not run Garbo, consume diet, farm turns, PvP, replace furniture, or ascend.</div>");
    if (message != "") writeln("<div class='success'>" + html(message) + "</div>");
    write_summary();

    writeln("<form action='' method='post'>");
    writeln("<div class='grid'>");
    write_run_flow_section();
    write_ascension_section();
    write_leg1_section();
    write_leg2_pearl_section();
    write_leg2_finish_section();
    write_tracking_section();
    writeln("</div>");
    writeln("<div class='actions'>");
    writeln("<input type='submit' name='save' value='Save Preferences'>");
    writeln("<input class='secondary' type='submit' name='alpha_defaults' value='Apply Alpha-Safe Defaults'>");
    writeln("<span>After saving, run <code>LoopTheSea status</code> and <code>LoopTheSea preflight</code> from the CLI.</span>");
    writeln("</div>");
    writeln("</form>");
    write_footer();
}
