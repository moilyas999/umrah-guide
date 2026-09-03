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
            whenToSay: "After entering ihram, and through the journey. A widespread practice is to stop the Talbiyah when tawaf of Umrah begins.",
            sourceKind: .wellKnownAuthentic,
            sourceNote: "The well-known wording of the Talbiyah recited by pilgrims. It is reported in the major authentic collections. No book number is printed here so that a guessed citation is not attached to the app."
        ),
        Dua(
            id: "tawaf.takbir",
            occasion: .tawaf,
            title: "Takbir at the Black Stone",
            arabic: "اللَّهُ أَكْبَرُ",
            transliteration: "Allahu Akbar",
            meaning: "Allah is Greater.",
            whenToSay: "When you come in line with the Black Stone at the start of a circuit — whether you kiss, touch, or point from a distance. Do not harm anyone to reach the Stone.",
            sourceKind: .wellKnownAuthentic,
            sourceNote: "Saying Allahu Akbar at the Black Stone is the well-known practice described in authentic reports of the pilgrimage. This app does not invent a hadith number."
        ),
        Dua(
            id: "tawaf.rabbana",
            occasion: .tawaf,
            title: "Between the Yemeni Corner and the Black Stone",
            arabic: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
            transliteration: "Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina ‘adhab an-nar.",
            meaning: "Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.",
            whenToSay: "A well-known recitation while walking between the Yemeni Corner (Rukn al-Yamani) and the Black Stone. You may make any other sincere dua during the rest of tawaf. Nothing is required on each lap.",
            sourceKind: .quran,
            sourceNote: "The wording is Qur'an 2:201. Using it in this stretch of tawaf is a well-known practice. The verse citation is for the Qur'an text only."
        ),
        Dua(
            id: "sai.safa.verse",
            occasion: .sai,
            title: "At Safa (opening verse)",
            arabic: "إِنَّ الصَّفَا وَالْمَرْوَةَ مِن شَعَائِرِ اللَّهِ",
            transliteration: "Inna as-Safa wal-Marwata min sha‘a’irillah.",
            meaning: "Indeed, Safa and Marwah are among the rites of Allah.",
            whenToSay: "When you first stand at Safa to begin sa'i. The wider verse continues in Qur'an 2:158; this is the clause commonly recalled at the hill.",
            sourceKind: .quran,
            sourceNote: "Qur'an 2:158. The wording is the verse itself. Reciting it at Safa is a well-known part of beginning sa'i."
        ),
        Dua(
            id: "sai.hill.dhikr",
            occasion: .sai,
            title: "Dhikr facing the Kaaba at Safa and Marwah",
            arabic: "اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ. لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "Allahu Akbar, Allahu Akbar, Allahu Akbar. La ilaha illallahu wahdahu la shareeka lah, lahul-mulku wa lahul-hamd, yuhyi wa yumit, wa huwa ‘ala kulli shay’in qadir.",
            meaning: "Allah is Greater (three times). There is no god but Allah alone, without partner. His is the dominion and His is the praise. He gives life and causes death. He is over all things able.",
            whenToSay: "A traditional sequence used when facing the Kaaba at Safa and again at Marwah: takbir, then this tahlil, then any personal dua. Raise the hands for dua if that is your practice.",
            sourceKind: .traditionalWording,
            sourceNote: "Traditional wording widely used at Safa and Marwah and described in long reports of the Prophet's pilgrimage. Labeled as traditional wording here; this app does not attach a book number or a full isnad."
        )
    ]

    static func duas(for occasion: DuaOccasion) -> [Dua] {
        duas.filter { $0.occasion == occasion }
    }
}
