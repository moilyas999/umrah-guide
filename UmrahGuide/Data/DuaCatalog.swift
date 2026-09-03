import Foundation

enum DuaCatalog {
    static let duas: [Dua] = [
        Dua(
            id: "talbiyah",
            occasion: .ihram,
            title: "Talbiyah",
            arabic: "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ",
            transliteration: "Labbayk Allahumma labbayk. Labbayk la shareeka laka labbayk. Innal-hamda wan-ni‘mata laka wal-mulk. La shareeka lak.",
            meaning: "Here I am, O Allah, here I am. Here I am; You have no partner; here I am. Truly all praise, blessing, and dominion are Yours. You have no partner.",
            whenToSay: "After you intend Umrah, and on the way. A widespread practice is to stop when tawaf of Umrah begins.",
            sourceKind: .wellKnownAuthentic,
            sourceNote: "The well-known wording of the Talbiyah recited by pilgrims, reported in the major authentic collections. No book number is printed here."
        ),
        Dua(
            id: "ihram.labbayk.umrah",
            occasion: .ihram,
            title: "Spoken intention (optional)",
            arabic: "لَبَّيْكَ اللَّهُمَّ عُمْرَةً",
            transliteration: "Labbayk Allahumma ‘Umratan.",
            meaning: "Here I am, O Allah, for Umrah.",
            whenToSay: "Some pilgrims say this when they intend Umrah. The intention itself is in the heart. Speaking it is optional.",
            sourceKind: .traditionalWording,
            sourceNote: "A common spoken form of the Umrah intention. It is traditional practice, not a required formula, and this app does not attach a book number."
        ),
        Dua(
            id: "haram.enter",
            occasion: .enteringHaram,
            title: "Entering a mosque",
            arabic: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
            transliteration: "Allahumma iftah li abwaba rahmatik.",
            meaning: "O Allah, open the doors of Your mercy for me.",
            whenToSay: "When you enter Masjid al-Haram, as you would enter any mosque. Right foot first if you can.",
            sourceKind: .wellKnownAuthentic,
            sourceNote: "The well-known wording for entering a mosque, reported in authentic collections. There is no extra required script for this particular door."
        ),
        Dua(
            id: "kaaba.accept",
            occasion: .firstSightKaaba,
            title: "A first look — “accept from us”",
            arabic: "رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ",
            transliteration: "Rabbana taqabbal minna, innaka antas-sami‘ul-‘alim.",
            meaning: "Our Lord, accept from us. You are the Hearing, the Knowing.",
            whenToSay: "There is no required phrase at first sight of the Kaaba. This Qur'an verse is a sincere option. Any personal dua is also fine.",
            sourceKind: .quran,
            sourceNote: "Qur'an 2:127. Offered because the wording is authentic and short. This app does not claim a special required dua for the first glance."
        ),
        Dua(
            id: "tawaf.takbir",
            occasion: .tawaf,
            title: "Takbir at the Black Stone",
            arabic: "اللَّهُ أَكْبَرُ",
            transliteration: "Allahu Akbar",
            meaning: "Allah is Greater.",
            whenToSay: "When you come in line with the Black Stone — whether you kiss, touch, or point. Do not harm anyone to reach it.",
            sourceKind: .wellKnownAuthentic,
            sourceNote: "Saying Allahu Akbar at the Black Stone is the well-known practice described in authentic reports of the pilgrimage."
        ),
        Dua(
            id: "tawaf.rabbana",
            occasion: .tawaf,
            title: "Between the Yemeni Corner and the Black Stone",
            arabic: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
            transliteration: "Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina ‘adhab an-nar.",
            meaning: "Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.",
            whenToSay: "A well-known recitation while walking between the Yemeni Corner (Rukn al-Yamani) and the Black Stone. Nothing is required on each lap.",
            sourceKind: .quran,
            sourceNote: "The wording is Qur'an 2:201. Using it on this stretch of tawaf is a well-known practice. The verse citation is for the Qur'an text only."
        ),
        Dua(
            id: "maqam.verse",
            occasion: .maqamIbrahim,
            title: "The station of Abraham",
            arabic: "وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّى",
            transliteration: "Wattakhidhu min maqami Ibrahima musalla.",
            meaning: "And take the standing place of Abraham as a place of prayer.",
            whenToSay: "A reminder of why two rak'ahs are prayed after tawaf, behind Maqam Ibrahim when space allows.",
            sourceKind: .quran,
            sourceNote: "Qur'an 2:125. This is the verse, not a required recitation you must say before the two rak'ahs."
        ),
        Dua(
            id: "after.prayer.aid",
            occasion: .maqamIbrahim,
            title: "After the two rak'ahs",
            arabic: "اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ",
            transliteration: "Allahumma a‘inni ‘ala dhikrika wa shukrika wa husni ‘ibadatik.",
            meaning: "O Allah, help me to remember You, to thank You, and to worship You well.",
            whenToSay: "A well-known dua after prayer. Use it after the two rak'ahs, or after any salah.",
            sourceKind: .wellKnownAuthentic,
            sourceNote: "Well-known authentic wording taught for after the prescribed prayer. No book number is printed here."
        ),
        Dua(
            id: "zamzam.ask",
            occasion: .zamzam,
            title: "While drinking Zamzam",
            arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا وَاسِعًا، وَشِفَاءً مِن كُلِّ دَاءٍ",
            transliteration: "Allahumma inni as'aluka ‘ilman nafi‘an, wa rizqan wasi‘an, wa shifa'an min kulli da'.",
            meaning: "O Allah, I ask You for useful knowledge, ample provision, and healing from every illness.",
            whenToSay: "While you drink. You may also ask for anything else you need. Zamzam is drunk for what it is drunk for.",
            sourceKind: .traditionalWording,
            sourceNote: "A well-known wording attributed to Ibn Abbas when drinking Zamzam. Labeled traditional here; this app does not attach a book number or treat it as the only valid request."
        ),
        Dua(
            id: "sai.safa.verse",
            occasion: .sai,
            title: "At Safa (opening verse)",
            arabic: "إِنَّ الصَّفَا وَالْمَرْوَةَ مِن شَعَائِرِ اللَّهِ",
            transliteration: "Inna as-Safa wal-Marwata min sha‘a'irillah.",
            meaning: "Indeed, Safa and Marwah are among the rites of Allah.",
            whenToSay: "When you first stand at Safa to begin sa'i. The wider verse continues in Qur'an 2:158.",
            sourceKind: .quran,
            sourceNote: "Qur'an 2:158. Reciting this clause at Safa is a well-known way to begin sa'i."
        ),
        Dua(
            id: "sai.hill.dhikr",
            occasion: .sai,
            title: "At Safa and Marwah",
            arabic: "اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ. لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "Allahu Akbar, Allahu Akbar, Allahu Akbar. La ilaha illallahu wahdahu la shareeka lah, lahul-mulku wa lahul-hamd, yuhyi wa yumit, wa huwa ‘ala kulli shay'in qadir.",
            meaning: "Allah is Greater (three times). There is no god but Allah alone, without partner. His is the dominion and His is the praise. He gives life and causes death. He is over all things able.",
            whenToSay: "When facing the Kaaba at Safa and again at Marwah: takbir, then this tahlil, then any personal dua.",
            sourceKind: .traditionalWording,
            sourceNote: "Traditional wording widely used at the two hills and described in long reports of the Prophet's pilgrimage. No book number or full isnad is attached."
        ),
        Dua(
            id: "sai.between",
            occasion: .sai,
            title: "Between the hills",
            arabic: "رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا",
            transliteration: "Rabbana la tu'akhidhna in nasina aw akhta'na.",
            meaning: "Our Lord, do not take us to task if we forget or make a mistake.",
            whenToSay: "There is no required text for the walk itself. This short verse is one option while you move between Safa and Marwah.",
            sourceKind: .quran,
            sourceNote: "Qur'an 2:286. Offered as a short authentic option for the walk, not as a required sa'i script."
        ),
        Dua(
            id: "halq.accept",
            occasion: .halqTaqsir,
            title: "After the hair is cut",
            arabic: "رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ",
            transliteration: "Rabbana taqabbal minna, innaka antas-sami‘ul-‘alim.",
            meaning: "Our Lord, accept from us. You are the Hearing, the Knowing.",
            whenToSay: "There is no required dua for halq or taqsir. This is a short, sincere request that the rite be accepted.",
            sourceKind: .quran,
            sourceNote: "Qur'an 2:127. Used here as a short authentic request for acceptance, not as a special hair-rite formula."
        ),
        Dua(
            id: "general.forgiveness",
            occasion: .general,
            title: "Pardon",
            arabic: "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
            transliteration: "Allahumma innaka ‘afuwwun tuhibbul-‘afwa fa‘fu ‘anni.",
            meaning: "O Allah, You are Pardoning and You love to pardon, so pardon me.",
            whenToSay: "Any quiet moment — in tawaf, on sa'i, after the hair cut, or later.",
            sourceKind: .wellKnownAuthentic,
            sourceNote: "Well-known authentic wording for seeking pardon. Often remembered in the last ten nights of Ramadan; the words themselves are not limited to that time."
        ),
        Dua(
            id: "general.rabbighfir",
            occasion: .general,
            title: "Forgiveness",
            arabic: "رَبِّ اغْفِرْ لِي",
            transliteration: "Rabbighfir li.",
            meaning: "My Lord, forgive me.",
            whenToSay: "Whenever you want the shortest ask for forgiveness.",
            sourceKind: .quran,
            sourceNote: "Qur'an 38:35. A short clause from the prayer of Sulayman. Easy to repeat while walking."
        ),
        Dua(
            id: "general.parents",
            occasion: .general,
            title: "For your parents",
            arabic: "رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا",
            transliteration: "Rabbi irhamhuma kama rabbayani saghira.",
            meaning: "My Lord, have mercy on them as they raised me when I was small.",
            whenToSay: "Any time you remember your parents, living or deceased.",
            sourceKind: .quran,
            sourceNote: "Qur'an 17:24. The wording is the verse. Adjust the sense in your heart if you are praying for one parent."
        ),
        Dua(
            id: "general.ummah",
            occasion: .general,
            title: "For the believers",
            arabic: "رَبَّنَا اغْفِرْ لَنَا وَلِإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالْإِيمَانِ",
            transliteration: "Rabbana ighfir lana wa li-ikhwanina alladhina sabaquna bil-iman.",
            meaning: "Our Lord, forgive us and our brothers who believed before us.",
            whenToSay: "A short ask for yourself and the wider ummah — the community of believers.",
            sourceKind: .quran,
            sourceNote: "Qur'an 59:10. The verse continues; this is the opening request, kept short on purpose."
        ),
        Dua(
            id: "general.ease",
            occasion: .general,
            title: "Ease",
            arabic: "اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا، وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا",
            transliteration: "Allahumma la sahla illa ma ja‘altahu sahla, wa anta taj‘alul-hazna idha shi'ta sahla.",
            meaning: "O Allah, there is no ease except what You make easy, and You make the difficult easy if You will.",
            whenToSay: "When the crowd, the heat, or the walk feels hard.",
            sourceKind: .wellKnownAuthentic,
            sourceNote: "Well-known authentic wording asking Allah to make a hard thing easy. No book number is printed here."
        ),
        Dua(
            id: "general.gratitude",
            occasion: .general,
            title: "Gratitude",
            arabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
            transliteration: "Alhamdulillahi rabbil-‘alamin.",
            meaning: "All praise is for Allah, Lord of all the worlds.",
            whenToSay: "After a circuit, after sa'i, after the hair cut, or any time you want to give thanks.",
            sourceKind: .quran,
            sourceNote: "Qur'an 1:2. The wording is the verse."
        )
    ]

    static func duas(for occasion: DuaOccasion) -> [Dua] {
        duas.filter { $0.occasion == occasion }
    }

    static func dua(id: String) -> Dua? {
        duas.first(where: { $0.id == id })
    }

    static func duas(forStage stage: PerformStage) -> [Dua] {
        duas.filter { $0.occasion.performStage == stage || $0.occasion == .general }
    }

    static let requiredIDs: [String] = [
        "talbiyah",
        "haram.enter",
        "kaaba.accept",
        "tawaf.rabbana",
        "after.prayer.aid",
        "zamzam.ask",
        "sai.safa.verse",
        "sai.hill.dhikr",
        "halq.accept",
        "general.forgiveness",
        "general.parents",
        "general.ummah",
        "general.ease",
        "general.gratitude"
    ]
}
