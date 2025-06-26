extends Node

@warning_ignore("unused_signal")
signal spell_collided(spell1: Area2D, spell2: Area2D)

@warning_ignore("unused_signal")
signal spell_fired

@warning_ignore("unused_signal")
signal spell_selected

@warning_ignore("unused_signal")
signal companion_zone_entered
@warning_ignore("unused_signal")
signal companion_zone_exited

@warning_ignore("unused_signal")
signal spell_dropped(from_index: int, to_index: int)

@warning_ignore("unused_signal")
signal open_selector

@warning_ignore("unused_signal")
signal apply_dmg_and_debuff

@warning_ignore("unused_signal")
signal dmg_debuff_applied

@warning_ignore("unused_signal")
signal dead

@warning_ignore("unused_signal")
signal updateUi

@warning_ignore("unused_signal")
##emitted when spell is casted
signal spell_casted



#effects!
@warning_ignore("unused_signal")
signal do_hitstop

@warning_ignore("unused_signal")
signal do_screen_shake
