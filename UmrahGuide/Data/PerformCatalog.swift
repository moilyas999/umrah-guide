import Foundation

enum PerformCatalog {
    static let steps: [PerformStep] = [
        PerformStep(
            id: "wash",
            stage: .ihram,
            title: "Wash first",
            doNow: [
                "Take a full bath if you can. Washing for prayer (wudu) is the minimum.",
                "Cut nails and remove unwanted hair now — not after you enter ihram."
            ],
            jargon: "Ghusl means a full bath. Wudu means washing for prayer.",
            womenNote: nil,
            caution: nil,
            primaryDuaID: nil
        ),
        PerformStep(
            id: "dress",
            stage: .ihram,
            title: "Dress for ihram",
            doNow: [
                "Men wear two unstitched white cloths: one around the waist, one over the shoulders.",
                "Women wear modest, loose ordinary clothes — not the two cloths."
            ],
            jargon: "Ihram means the sacred state you enter for Umrah, and the clothes that mark it.",
            womenNote: "In the majority view a woman in ihram does not wear a niqab or gloves. She covers her hair as she would for prayer.",
            caution: nil,
            primaryDuaID: nil
        ),
        PerformStep(
            id: "miqat",
            stage: .ihram,
            title: "Stop at the miqat",
            doNow: [
                "The miqat is the boundary for your route.",
                "Do not cross it intending Umrah unless you are already in ihram."
            ],
            jargon: "Miqat means the station you must not pass without being in ihram.",
            womenNote: nil,
            caution: "A common mistake is crossing without ihram and only noticing in Makkah.",
            primaryDuaID: nil
        ),
        PerformStep(
            id: "intend",
            stage: .ihram,
            title: "Intend Umrah, then say the Talbiyah",
            doNow: [
                "In your heart, intend Umrah. Speaking it is optional.",
                "Then begin the Talbiyah. Men say it aloud. Women say it quietly.",
                "Keep it going on the way. Many people stop when tawaf begins."
            ],
            jargon: "Talbiyah means the “Here I am, O Allah” chant of the pilgrim.",
            womenNote: "Women recite the Talbiyah quietly.",
            caution: nil,
            primaryDuaID: "talbiyah"
        ),
        PerformStep(
            id: "restrictions",
            stage: .ihram,
            title: "Keep the ihram rules",
            doNow: [
                "No perfume or scented soap, wipes, or deodorant.",
                "Do not cut hair or nails. Men do not wear a cap or ordinary sewn clothes.",
                "No hunting and no marital relations until you finish."
            ],
            jargon: nil,
            womenNote: nil,
            caution: "Scented products after ihram has begun are a common slip.",
            primaryDuaID: nil
        ),
        PerformStep(
            id: "enter-haram",
            stage: .tawaf,
            title: "Enter the Sacred Mosque",
            doNow: [
                "Enter as you enter any mosque. Right foot first if you can.",
                "Say the short words below. There is no extra required script for this door."
            ],
            jargon: "Masjid al-Haram is the Sacred Mosque around the Kaaba.",
            womenNote: nil,
            caution: nil,
            primaryDuaID: "haram.enter"
        ),
        PerformStep(
            id: "first-sight",
            stage: .tawaf,
            title: "First look at the Kaaba",
            doNow: [
                "Pause if the crowd allows.",
                "There is no required phrase. Raise your hands and ask Allah for whatever you need."
            ],
            jargon: nil,
            womenNote: nil,
            caution: nil,
            primaryDuaID: "kaaba.accept"
        ),
        PerformStep(
            id: "start-tawaf",
            stage: .tawaf,
            title: "Start tawaf at the Black Stone",
            doNow: [
                "Be in wudu. Tawaf means walking around the Kaaba seven times.",
                "Stand with the Kaaba on your left. Begin in line with the Black Stone.",
                "Kiss, touch, or point and say Allahu Akbar. If the crowd is unsafe, just point and walk on."
            ],
            jargon: "Hajar Aswad means the Black Stone.",
            womenNote: "Tawaf itself is the same. If you are menstruating, most scholars say delay tawaf; ask a scholar about your dates.",
            caution: "Reaching the Stone is not required. Do not harm anyone to kiss it.",
            primaryDuaID: "tawaf.takbir"
        ),
        PerformStep(
            id: "seven-circuits",
            stage: .tawaf,
            title: "Walk seven circuits",
            doNow: [
                "Each full loop back to the Black Stone line is one circuit. Do seven.",
                "Walk calmly. You may recite Qur'an, make any dua, or stay quiet."
            ],
            jargon: nil,
            womenNote: "Women do not uncover the right shoulder or use the brisk pace some men use in early circuits.",
            caution: "Starting from the wrong corner or losing count are the usual mistakes.",
            primaryDuaID: nil
        ),
        PerformStep(
            id: "rabbana",
            stage: .tawaf,
            title: "Between the Yemeni Corner and the Black Stone",
            doNow: [
                "On each lap, this short stretch has a well-known verse.",
                "On the rest of the circle, any sincere words are fine. Nothing is required on every lap."
            ],
            jargon: "Rukn al-Yamani is the Yemeni Corner of the Kaaba.",
            womenNote: nil,
            caution: nil,
            primaryDuaID: "tawaf.rabbana"
        ),
        PerformStep(
            id: "maqam",
            stage: .tawaf,
            title: "Pray two rak'ahs",
            doNow: [
                "After seven circuits, pray two rak'ahs if you can.",
                "Behind Maqam Ibrahim when there is space. If not, pray anywhere suitable."
            ],
            jargon: "Maqam Ibrahim means the station of Abraham.",
            womenNote: nil,
            caution: nil,
            primaryDuaID: "after.prayer.aid"
        ),
        PerformStep(
            id: "zamzam",
            stage: .tawaf,
            title: "Drink Zamzam",
            doNow: [
                "Drink if it is available.",
                "Ask Allah for what you need while you drink."
            ],
            jargon: "Zamzam is the well in the Sacred Mosque.",
            womenNote: nil,
            caution: "Zamzam is a blessing, not a substitute for ordinary water on long walks.",
            primaryDuaID: "zamzam.ask"
        ),
        PerformStep(
            id: "start-sai",
            stage: .sai,
            title: "Begin sa'i at Safa",
            doNow: [
                "Sa'i is normally after tawaf. Go to Safa first, not Marwah.",
                "At Safa, recall that these two hills are among the rites of Allah."
            ],
            jargon: "Sa'i means walking between Safa and Marwah seven times.",
            womenNote: nil,
            caution: "Starting at Marwah is a common mistake.",
            primaryDuaID: "sai.safa.verse"
        ),
        PerformStep(
            id: "seven-legs",
            stage: .sai,
            title: "Walk seven legs, finish at Marwah",
            doNow: [
                "Safa to Marwah is leg 1. Back to Safa is leg 2. The seventh leg ends at Marwah.",
                "At each hill, face the Kaaba if you can, then make the words below and any personal dua.",
                "Between the green markers, men who are able may jog lightly. Women walk the whole way."
            ],
            jargon: nil,
            womenNote: "Women do not jog between the green markers.",
            caution: "Do not count seven round trips. Do not finish at Safa.",
            primaryDuaID: "sai.hill.dhikr"
        ),
        PerformStep(
            id: "cut-hair",
            stage: .halqTaqsir,
            title: "Cut or shorten the hair",
            doNow: [
                "Men shave the head (halq) or shorten the hair (taqsir).",
                "Women shorten the hair only. They do not shave.",
                "Do this before you put scented products or ordinary sewn clothes back on."
            ],
            jargon: "Halq means shaving. Taqsir means shortening.",
            womenNote: "A common description is about a fingertip from the ends. Confirm the amount with a scholar. Have a companion help if you want privacy.",
            caution: "Leaving ihram before the hair is cut is a common mistake.",
            primaryDuaID: "halq.accept"
        ),
        PerformStep(
            id: "complete",
            stage: .halqTaqsir,
            title: "Umrah is complete",
            doNow: [
                "Once the hair is cut, the ihram restrictions end.",
                "This Umrah is finished. Thank Allah."
            ],
            jargon: nil,
            womenNote: nil,
            caution: nil,
            primaryDuaID: "general.gratitude"
        )
    ]

    static func step(id: String) -> PerformStep {
        guard let match = steps.first(where: { $0.id == id }) else {
            preconditionFailure("Perform catalog is missing \(id)")
        }
        return match
    }

    static func steps(in stage: PerformStage) -> [PerformStep] {
        steps.filter { $0.stage == stage }
    }

    static var requiredIDs: [String] {
        [
            "wash", "dress", "miqat", "intend", "restrictions",
            "enter-haram", "first-sight", "start-tawaf", "seven-circuits",
            "rabbana", "maqam", "zamzam",
            "start-sai", "seven-legs",
            "cut-hair", "complete"
        ]
    }
}
