return {

    -- Multi-sound Subtables

    -- Indexes inside tables means amount of total events required to play sound for streaks, and for comboStreaks amount of events required in a time period.
    -- Index [0] is reserved for comboStreaks incase you run out of entries

    ["snd_headshot"] = {
        [1] = {
            sound = 'gamesense_quake\\en\\headshot\\headshot.wav',
            volume = 1.0,
            active = true,
        },
        [2] = {
            sound = 'gamesense_quake\\en\\headshot\\hattrick.wav',
            volume = 1.0,
            active = true,
        },
        [3] = {
            sound = 'gamesense_quake\\en\\headshot\\headhunter.wav',
            volume = 1.0,
            active = true,
        },
        [4] = {
            sound = 'gamesense_quake\\en\\headshot\\eagleeye.wav',
            volume = 1.0,
            active = true,
        },
        [5] = {
            sound = 'gamesense_quake\\en\\headshot\\ownage.wav',
            volume = 1.0,
            active = true,
        },
    },
    ["snd_headshotCombo"] = {
        [0] = {
            sound = 'gamesense_quake\\en\\headshot\\headshot.wav',
            volume = 1.0,
            active = true,
        },
    },
    ["snd_kill"] = {
        [4] = {
            sound = 'gamesense_quake\\en\\kill\\dominating.wav',
            volume = 1.0,
            active = true,
        },
        [3] = {
            sound = 'gamesense_quake\\en\\kill\\outstanding.wav',
            volume = 1.0,
            active = true,
        },
        [6] = {
            sound = 'gamesense_quake\\en\\kill\\rampage.wav',
            volume = 1.0,
            active = true,
        },
        [8] = {
            sound = 'gamesense_quake\\en\\kill\\killingspree.wav',
            volume = 1.0,
            active = true,
        },
        [10] = {
            sound = 'gamesense_quake\\en\\kill\\megakill.wav',
            volume = 1.0,
            active = true,
        },
        [12] = {
            sound = 'gamesense_quake\\en\\kill\\monsterkill.wav',
            volume = 1.0,
            active = true,
        },
        [14] = {
            sound = 'gamesense_quake\\en\\kill\\unstoppable.wav',
            volume = 1.0,
            active = true,
        },
        [16] = {
            sound = 'gamesense_quake\\en\\kill\\ultrakill.wav',
            volume = 1.0,
            active = true,
        },
        [18] = {
            sound = 'gamesense_quake\\en\\kill\\unreal.wav',
            volume = 1.0,
            active = true,
        },
        [20] = {
            sound = 'gamesense_quake\\en\\kill\\godlike.wav',
            volume = 1.0,
            active = true,
        },
        [22] = {
            sound = 'gamesense_quake\\en\\kill\\whickedsick.wav',
            volume = 1.0,
            active = true,
        },
        [24] = {
            sound = 'gamesense_quake\\en\\kill\\impressive.wav',
            volume = 1.0,
            active = true,
        },
        [26] = {
            sound = 'gamesense_quake\\en\\kill\\killingmachine.wav',
            volume = 1.0,
            active = true,
        },
    },
    ["snd_killCombo"] = {
        [0] = {
            sound = 'gamesense_quake\\en\\kill\\dominating.wav',
            volume = 1.0,
            active = true,
        },
        [2] = {
            sound = 'gamesense_quake\\en\\killCombo\\doublekill.wav',
            volume = 1.0,
            active = true,
        },
        [3] = {
            sound = 'gamesense_quake\\en\\killCombo\\triplekill.wav',
            volume = 1.0,
            active = true,
        },
        [4] = {
            sound = 'gamesense_quake\\en\\killCombo\\multikill.wav',
            volume = 1.0,
            active = true,
        },
        [5] = {
            sound = 'gamesense_quake\\en\\killCombo\\payback.wav',
            volume = 1.0,
            active = true,
        },
        [6] = {
            sound = 'gamesense_quake\\en\\killCombo\\comboking.wav',
            volume = 1.0,
            active = true,
        },
        [7] = {
            sound = 'gamesense_quake\\en\\killCombo\\bullseye.wav',
            volume = 1.0,
            active = true,
        },
    },
    ["snd_grenade"] = {
        [1] = {
            sound = 'gamesense_quake\\en\\grenade\\excellent.wav',
            volume = 1.0,
            active = true,
        },
        [2] = {
            sound = 'gamesense_quake\\en\\grenade\\perfect.wav',
            volume = 1.0,
            active = true,
        },
        [3] = {
            sound = 'gamesense_quake\\en\\grenade\\pancake.wav',
            volume = 1.0,
            active = true,
        },
    },
    ["snd_grenadeCombo"] = {
        [0] = {
            sound = 'gamesense_quake\\en\\grenade\\excellent.wav',
            volume = 1.0,
            active = true,
        },
        [2] = {
            sound = 'gamesense_quake\\en\\grenadeCombo\\retribution.wav',
            volume = 1.0,
            active = true,
        },
        [3] = {
            sound = 'gamesense_quake\\en\\grenadeCombo\\vengeance.wav',
            volume = 1.0,
            active = true,
        },
        [4] = {
            sound = 'gamesense_quake\\en\\grenadeCombo\\ludicrouskill.wav',
            volume = 1.0,
            active = true,
        },
    },
    ["snd_knife"] = {
        [1] = {
            sound = 'gamesense_quake\\en\\knife\\humiliation.wav',
            volume = 1.0,
            active = true,
        },
        [2] = {
            sound = 'gamesense_quake\\en\\knife\\maniac.wav',
            volume = 1.0,
            active = true,
        },
        [3] = {
            sound = 'gamesense_quake\\en\\knife\\assasin.wav',
            volume = 1.0,
            active = true,
        },
    },
    ["snd_knifeCombo"] = {
        [0] = {
            sound = 'gamesense_quake\\en\\knife\\humiliation.wav',
            volume = 1.0,
            active = true,
        },
        [2] = {
            sound = 'gamesense_quake\\en\\knifeCombp\\massacre.wav',
            volume = 1.0,
            active = true,
        },
    },

    -- Single-sound Subtables

    ["snd_firstBlood"] = {
        sound = 'gamesense_quake\\en\\firstblood.wav',
        volume = 1.0,
        active = true,
    },
    ["snd_teamKill"] = {
        
    },
    ["snd_selfKill"] = {
        sound = 'gamesense_quake\\en\\suicide.wav',
        volume = 1.0,
        active = true,
    },
    ["snd_roundPreStart"] = {
        sound = 'gamesense_quake\\en\\prepare.wav',
        volume = 1.0,
        active = true,
    },
    ["snd_roundStart"] = {
        sound = 'gamesense_quake\\en\\play.wav',
        volume = 1.0,
        active = true,
    },
}