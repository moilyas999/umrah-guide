import Foundation

enum RitualCatalog {
    static let steps: [RitualStep] = [
        RitualStep(
            id: .ihram,
            order: 1,
            title: "Ihram",
            subtitle: "Intention, miqat, clothing, and Talbiyah",
            systemImage: "tshirt",
            whatToDo: [
                "Prepare with a bath (ghusl) if you can, or at least wudu. Many pilgrims also trim nails and remove unwanted hair before entering ihram — not after.",
                "Men wear two unstitched white cloths: a waist wrap (izar) and a shoulder wrap (rida). Women wear modest, loose ordinary clothes. In the majority Sunni view, a woman in ihram does not wear a niqab or gloves; she covers her hair as she normally would in prayer.",
                "Enter ihram at or before your miqat (the designated station for your route). Do not cross the miqat intending Umrah without being in ihram. If you live inside the miqat boundary, ask a scholar which place applies to you.",
                "Make the intention (niyyah) for Umrah in the heart. Speaking it aloud is practiced by many but is not itself a pillar.",
                "Begin the Talbiyah after the intention. Men commonly recite it audibly; women recite it quietly. Continue it through the journey until you begin tawaf, according to a widespread practice.",
                "Observe the well-known ihram restrictions: no perfume or scented products, no cutting hair or nails, no hunting, no marital relations. Men do not cover the head with a fitted cap or similar, and do not wear ordinary sewn clothing."
            ],
            commonMistakes: [
                "Crossing the miqat without ihram, then discovering it only in Makkah.",
                "Using scented soap, wipes, or deodorant after ihram has begun.",
                "Treating a packing list or this screen as a legal ruling for every school.",
                "Men covering the head or putting ordinary shirts and underwear back on while still in ihram.",
                "Delaying the intention until after passing the miqat."
            ],
            womenNotes: """
            Women wear modest regular clothing rather than the two cloths. In the majority view they do not wear a niqab or gloves in ihram, and they recite the Talbiyah quietly. If menses begin before tawaf, the other rites wait on purification for tawaf in the majority view — arrange timing with a scholar rather than improvising from a phone guide.
            """
        ),
        RitualStep(
            id: .tawaf,
            order: 2,
            title: "Tawaf",
            subtitle: "Seven circuits around the Kaaba",
            systemImage: "arrow.triangle.2.circlepath",
            whatToDo: [
                "Be in wudu. The majority treat ritual purity as required for tawaf, as they do for prayer.",
                "Uncover the face of the Kaaba in your mind's map: begin at the Black Stone corner, with the Kaaba on your left. Each full loop back to that line is one circuit. Complete seven.",
                "If you can reach the Black Stone without harming yourself or others, you may kiss it, touch it, or point toward it and say Allahu Akbar. If the crowd is unsafe, pass by and continue. Reaching the Stone is not a pillar of Umrah.",
                "Walk with dignity. Harming others to get closer is not part of the rite. A wheelchair or helper is acceptable when needed.",
                "There is no required phrase for each circuit. You may recite Qur'an, make any sincere dua, or remain silent in remembrance. A well-known recitation between the Yemeni Corner and the Black Stone is the verse Rabbana atina… (see Duas).",
                "After seven circuits, pray two rak'ahs if you can — behind Maqam Ibrahim when space allows, otherwise anywhere suitable. Drink Zamzam if it is available."
            ],
            commonMistakes: [
                "Pushing, crowding, or harming people to kiss the Black Stone.",
                "Believing that missing the Black Stone invalidates tawaf. It does not.",
                "Starting from the wrong corner or losing count of the seven circuits.",
                "Stopping in walkways for photographs and blocking those still circling.",
                "Assuming a specific dua printed in a booklet is obligatory for each lap."
            ],
            womenNotes: """
            Tawaf itself is the same. Women do not perform idtiba (uncovering the right shoulder) or raml (the brisk pace some men use in early circuits of arrival tawaf). Choose a less crowded time if you can. If you are menstruating, the majority require you to delay tawaf until you are able to pray; ask a scholar about your travel dates rather than relying on this summary.
            """
        ),
        RitualStep(
            id: .sai,
            order: 3,
            title: "Sa'i",
            subtitle: "Seven legs between Safa and Marwah",
            systemImage: "figure.walk",
            whatToDo: [
                "Sa'i is normally performed after tawaf of Umrah. Go to Safa first, not Marwah.",
                "At Safa, the well-known opening is to recall that Safa and Marwah are among the rites of Allah (Qur'an 2:158), face the Kaaba if you can, and make takbir and dua. See the Duas tab for the traditional wording used at the hill.",
                "Walk to Marwah. That is the first leg. Returning to Safa is the second. Continue until you finish the seventh leg at Marwah.",
                "Between the green markers, men who are able may jog lightly. This is a sunnah for men, not a requirement, and it must not harm anyone.",
                "You may pause for dua at each end. There is no required text for the walk itself."
            ],
            commonMistakes: [
                "Starting at Marwah instead of Safa.",
                "Counting seven round trips (fourteen legs) or stopping at Safa on the seventh leg.",
                "Treating wudu as a condition for sa'i. Many scholars recommend purity but do not make it a condition; follow the scholar you trust.",
                "Running in a way that knocks into children, elders, or wheelchair users."
            ],
            womenNotes: """
            Women walk the full distance. They do not jog between the green markers. Take the time you need, and use the quieter hours if crowds are heavy.
            """
        ),
        RitualStep(
            id: .halqTaqsir,
            order: 4,
            title: "Halq or Taqsir",
            subtitle: "Shaving or shortening the hair to leave ihram",
            systemImage: "scissors",
            whatToDo: [
                "After completing sa'i, men either shave the head (halq) or shorten the hair (taqsir). Many scholars consider shaving preferable for men when it is suitable, but shortening is valid.",
                "Women do not shave. They shorten the hair (taqsir) only.",
                "A widespread description of a woman's taqsir is to cut a small amount from the ends — often described as about a fingertip's length. Confirm the amount with a scholar you trust.",
                "For men who shorten rather than shave, a common description is to take from all over the head, not only a few hairs at the nape. Details differ by school.",
                "Once the hair rite is done, the ihram restrictions end and this Umrah is complete."
            ],
            commonMistakes: [
                "Leaving ihram — putting on scented products or ordinary sewn clothes — before the hair has been cut.",
                "A woman shaving her head, which is not the Sunni practice for this rite.",
                "A man intending taqsir but clipping only one lock and assuming that matches every school.",
                "Assuming this screen replaces a ruling for someone with very short hair, illness, or another excuse. Ask a scholar."
            ],
            womenNotes: """
            Women perform taqsir only: a small cut from the ends of the hair, not shaving. Have a companion help if you prefer privacy. Do not imitate the men's halq.
            """
        )
    ]

    static func step(id: RitualID) -> RitualStep {
        guard let match = steps.first(where: { $0.id == id }) else {
            preconditionFailure("Ritual catalog is missing \(id.rawValue)")
        }
        return match
    }

    static var requiredIDs: [RitualID] {
        [.ihram, .tawaf, .sai, .halqTaqsir]
    }
}
