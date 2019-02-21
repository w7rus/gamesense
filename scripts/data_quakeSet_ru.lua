return {

    -- Multi-sound Subtables

    -- Indexes inside tables means amount of total events required to play sound for streaks, and for comboStreaks amount of events required in a time period.
    -- Index [0] is reserved for comboStreaks incase you run out of entries

    ["snd_headshot"] = {
        [1] = {
            sound = 'gamesense_quake\\ru\\headshot\\headshot.wav',
            volume = 1.0,
        },
        [2] = {
            sound = 'gamesense_quake\\ru\\headshot\\hattrick.wav',
            volume = 1.0,
        },
        [3] = {
            sound = 'gamesense_quake\\ru\\headshot\\goodshot.wav',
            volume = 1.0,
        },
        [4] = {
            sound = 'gamesense_quake\\ru\\headshot\\takethat.wav',
            volume = 1.0,
        },
        [5] = {
            sound = 'gamesense_quake\\ru\\headshot\\headhunter.wav',
            volume = 1.0,
        },
    },
    ["snd_headshotCombo"] = {
        [0] = {
            sound = 'gamesense_quake\\ru\\headshot\\headshot.wav',
            volume = 1.0,
        },
        [2] = {
            sound = 'gamesense_quake\\ru\\headshotCombo\\rhythmsync.wav',
            volume = 1.0,
        },
        [3] = {
            sound = 'gamesense_quake\\ru\\headshotCombo\\impressive.wav',
            volume = 1.0,
        },
    },
    ["snd_kill"] = {
        [4] = {
            sound = 'gamesense_quake\\ru\\kill\\dominating.wav',
            volume = 1.0,
        },
        [6] = {
            sound = 'gamesense_quake\\ru\\kill\\rampage.wav',
            volume = 1.0,
        },
        [8] = {
            sound = 'gamesense_quake\\ru\\kill\\killingspree.wav',
            volume = 1.0,
        },
        [10] = {
            sound = 'gamesense_quake\\ru\\kill\\megakill.wav',
            volume = 1.0,
        },
        [12] = {
            sound = 'gamesense_quake\\ru\\kill\\monsterkill.wav',
            volume = 1.0,
        },
        [14] = {
            sound = 'gamesense_quake\\ru\\kill\\unstoppable.wav',
            volume = 1.0,
        },
        [16] = {
            sound = 'gamesense_quake\\ru\\kill\\ultrakill.wav',
            volume = 1.0,
        },
        [18] = {
            sound = 'gamesense_quake\\ru\\kill\\godlike.wav',
            volume = 1.0,
        },
        [20] = {
            sound = 'gamesense_quake\\ru\\kill\\wickedsick.wav',
            volume = 1.0,
        },
    },
    ["snd_killCombo"] = {
        [0] = {
            sound = 'gamesense_quake\\ru\\kill\\dominating.wav',
            volume = 1.0,
        },
        [2] = {
            sound = 'gamesense_quake\\ru\\killCombo\\doublekill.wav',
            volume = 1.0,
        },
        [3] = {
            sound = 'gamesense_quake\\ru\\killCombo\\triplekill.wav',
            volume = 1.0,
        },
        [4] = {
            sound = 'gamesense_quake\\ru\\killCombo\\multikill.wav',
            volume = 1.0,
        },
        [5] = {
            sound = 'gamesense_quake\\ru\\killCombo\\proplayer.wav',
            volume = 1.0,
        },
        [6] = {
            sound = 'gamesense_quake\\ru\\killCombo\\perforator.wav',
            volume = 1.0,
        },
    },
    ["snd_grenade"] = {
        [1] = {
            sound = 'gamesense_quake\\ru\\grenade\\hereyougo.wav',
            volume = 1.0,
        },
        [2] = {
            sound = 'gamesense_quake\\ru\\grenade\\dieinhell.wav',
            volume = 1.0,
        },
        [3] = {
            sound = 'gamesense_quake\\ru\\grenade\\excellent.wav',
            volume = 1.0,
        },
        [4] = {
            sound = 'gamesense_quake\\ru\\grenade\\perfect.wav',
            volume = 1.0,
        },
    },
    ["snd_grenadeCombo"] = {
        [0] = {
            sound = 'gamesense_quake\\ru\\grenade\\hereyougo.wav',
            volume = 1.0,
        },
        [2] = {
            sound = 'gamesense_quake\\ru\\grenadeCombo\\3points.wav',
            volume = 1.0,
        },
    },
    ["snd_knife"] = {
        [1] = {
            sound = 'gamesense_quake\\ru\\knife\\humiliation.wav',
            volume = 1.0,
        },
        [2] = {
            sound = 'gamesense_quake\\ru\\knife\\haveyouseen.wav',
            volume = 1.0,
        },
    },
    ["snd_knifeCombo"] = {
        [0] = {
            sound = 'gamesense_quake\\ru\\knife\\humiliation.wav',
            volume = 1.0,
        },
        [2] = {
            sound = 'gamesense_quake\\ru\\knifeCombo\\meat.wav',
            volume = 1.0,
        },
        [3] = {
            sound = 'gamesense_quake\\ru\\knifeCombo\\holyshit.wav',
            volume = 1.0,
        },
    },

    -- Single-sound Subtables

    ["snd_firstBlood"] = {
        sound = 'gamesense_quake\\ru\\firstblood.wav',
        volume = 1.0,
    },
    ["snd_teamKill"] = {
        sound = 'gamesense_quake\\ru\\teamkiller.wav',
        volume = 1.0,
    },
    ["snd_selfKill"] = {
        sound = 'gamesense_quake\\ru\\suicide.wav',
        volume = 1.0,
    },
    ["snd_roundPreStart"] = {
        sound = 'gamesense_quake\\ru\\prepare.wav',
        volume = 1.0,
    },
    ["snd_roundStart"] = {
        sound = 'gamesense_quake\\ru\\play.wav',
        volume = 1.0,
    },
}