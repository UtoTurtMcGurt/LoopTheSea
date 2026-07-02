script "LoopTheSeaBofaFishyCCS";

boolean skill_is_available(string page_text, skill sk) {
    return sk != $skill[none]
        && have_skill(sk)
        && my_mp() >= mp_cost(sk)
        && contains_text(page_text, to_string(sk));
}

boolean try_skill_once(string page_text, skill sk) {
    if (!skill_is_available(page_text, sk)) return false;
    use_skill(sk);
    return true;
}

boolean try_kill_skill(string page_text) {
    foreach sk in $skills[
        Saucegeyser,
        Weapon of the Pastalord,
        Cannelloni Cannon,
        Saucestorm,
        Stream of Sauce,
        Furious Wallop,
        Lunging Thrust-Smack
    ] {
        if (try_skill_once(page_text, sk)) return true;
    }
    return false;
}

void main(int round, monster mob, string page_text) {
    if (current_round() <= 0) return;

    boolean talked_to_fish = false;
    boolean cursed = false;
    int stalled_rounds = 0;

    while (current_round() > 0 && current_round() < 30) {
        int before = current_round();

        if (!talked_to_fish) {
            talked_to_fish = true;
            if (try_skill_once(page_text, $skill[Sea *dent: Talk to Some Fish])) {
                if (current_round() <= 0) return;
            }
        }

        if (!cursed) {
            cursed = true;
            if (try_skill_once(page_text, $skill[Curse of Weaksauce])) {
                if (current_round() <= 0) return;
            }
        }

        if (try_kill_skill(page_text)) {
            if (current_round() <= 0) return;
        } else {
            attack();
        }

        if (current_round() == before) {
            stalled_rounds = stalled_rounds + 1;
            if (stalled_rounds >= 3) {
                abort("LoopTheSeaBofaFishyCCS stalled while fighting " + mob + ".");
            }
        } else {
            stalled_rounds = 0;
        }
    }

    if (current_round() > 0) {
        abort("LoopTheSeaBofaFishyCCS reached round " + current_round()
            + " while fighting " + mob + ".");
    }
}
