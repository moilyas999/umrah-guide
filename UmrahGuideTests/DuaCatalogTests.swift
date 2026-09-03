import XCTest
@testable import UmrahGuide

final class DuaCatalogTests: XCTestCase {
    func testEveryOccasionHasAtLeastOneDua() {
        for occasion in DuaOccasion.allCases {
            XCTAssertFalse(
                DuaCatalog.duas(for: occasion).isEmpty,
                "Missing duas for \(occasion.rawValue)"
            )
        }
    }

    func testRequiredDuasExistWithArabicTransliterationAndMeaning() {
        for id in DuaCatalog.requiredIDs {
            let dua = DuaCatalog.dua(id: id)
            XCTAssertNotNil(dua, "Missing required dua \(id)")
            XCTAssertFalse(dua?.arabic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            XCTAssertFalse(dua?.transliteration.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            XCTAssertFalse(dua?.meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            XCTAssertFalse(dua?.sourceNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        }
    }

    func testEveryDuaHasMatchingArabicAndLatinTransliteration() {
        let expected: [String: (arabicToken: String, latinToken: String)] = [
            "talbiyah": ("لَبَّيْكَ", "Labbayk"),
            "ihram.labbayk.umrah": ("عُمْرَةً", "Umratan"),
            "haram.enter": ("أَبْوَابَ", "abwaba"),
            "kaaba.accept": ("تَقَبَّلْ", "taqabbal"),
            "tawaf.takbir": ("أَكْبَرُ", "Akbar"),
            "tawaf.rabbana": ("آتِنَا", "atina"),
            "maqam.verse": ("إِبْرَاهِيمَ", "Ibrahima"),
            "after.prayer.aid": ("أَعِنِّي", "dhikrika"),
            "zamzam.ask": ("عِلْمًا", "ilman"),
            "sai.safa.verse": ("الصَّفَا", "Safa"),
            "sai.hill.dhikr": ("يُحْيِي", "yuhyi"),
            "sai.between": ("تُؤَاخِذْنَا", "tu'akhidhna"),
            "halq.accept": ("تَقَبَّلْ", "taqabbal"),
            "general.forgiveness": ("عَفُوٌّ", "afuwwun"),
            "general.rabbighfir": ("اغْفِرْ", "ighfir"),
            "general.parents": ("ارْحَمْهُمَا", "irhamhuma"),
            "general.ummah": ("إِخْوَانِنَا", "ikhwanina"),
            "general.ease": ("سَهْلَ", "sahla"),
            "general.gratitude": ("الْحَمْدُ", "Alhamdu"),
            "personal.provision": ("فَقِيرٌ", "faqir"),
            "personal.protection": ("كَلِمَاتِ", "kalimat"),
            "personal.guidance": ("الصِّرَاطَ", "sirat"),
            "personal.family": ("ذُرِّيَّاتِنَا", "dhurriyyatina"),
            "personal.health": ("الشَّافِي", "shafi"),
            "personal.travel": ("سَخَّرَ", "sakhkhara"),
            "personal.anxiety": ("صَدْرِي", "sadri"),
            "personal.ending": ("مُسْلِمًا", "musliman"),
            "personal.knowledge": ("عِلْمًا", "ilma")
        ]

        for dua in DuaCatalog.duas {
            XCTAssertFalse(dua.arabic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, dua.id)
            XCTAssertFalse(dua.transliteration.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, dua.id)
            XCTAssertFalse(dua.meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, dua.id)
            XCTAssertTrue(
                dua.transliteration.unicodeScalars.contains { CharacterSet.letters.contains($0) },
                "Transliteration for \(dua.id) should be readable Latin"
            )
            if let pair = expected[dua.id] {
                XCTAssertTrue(dua.arabic.contains(pair.arabicToken), "\(dua.id) Arabic should contain \(pair.arabicToken)")
                XCTAssertTrue(
                    dua.transliteration.localizedCaseInsensitiveContains(pair.latinToken),
                    "\(dua.id) transliteration should correspond to the Arabic (\(pair.latinToken))"
                )
            }
        }
        XCTAssertEqual(Set(expected.keys), Set(DuaCatalog.duas.map(\.id)))
    }

    func testRabbanaAtinaIsQuranAndTiedToTawaf() {
        let dua = DuaCatalog.dua(id: "tawaf.rabbana")
        XCTAssertEqual(dua?.occasion, .tawaf)
        XCTAssertEqual(dua?.sourceKind, .quran)
        XCTAssertTrue(dua?.sourceNote.contains("2:201") ?? false)
        XCTAssertTrue(dua?.arabic.contains("رَبَّنَا") ?? false)
    }

    func testTalbiyahAndMosqueEntryAreAuthenticWording() {
        XCTAssertEqual(DuaCatalog.dua(id: "talbiyah")?.sourceKind, .wellKnownAuthentic)
        XCTAssertEqual(DuaCatalog.dua(id: "haram.enter")?.sourceKind, .wellKnownAuthentic)
        XCTAssertEqual(DuaCatalog.dua(id: "general.parents")?.sourceKind, .quran)
        XCTAssertEqual(DuaCatalog.dua(id: "general.ummah")?.sourceKind, .quran)
        XCTAssertEqual(DuaCatalog.dua(id: "general.ease")?.sourceKind, .wellKnownAuthentic)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.protection")?.sourceKind, .wellKnownAuthentic)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.health")?.sourceKind, .wellKnownAuthentic)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.provision")?.sourceKind, .quran)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.guidance")?.sourceKind, .quran)
    }

    func testPersonalEverydayGroupHasCountRequiredFieldsAndCategory() {
        XCTAssertEqual(DuaOccasion.personal.title, "Personal / Everyday")
        XCTAssertTrue(DuaOccasion.personal.isPersonalEveryday)
        XCTAssertTrue(DuaOccasion.personal.meaning.localizedCaseInsensitiveContains("everyday"))

        XCTAssertEqual(DuaCatalog.duas.count, 28)
        let personal = DuaCatalog.duas(for: .personal)
        XCTAssertEqual(personal.count, DuaCatalog.personalEverydayIDs.count)
        XCTAssertEqual(personal.count, 15)
        XCTAssertEqual(Set(personal.map(\.id)), Set(DuaCatalog.personalEverydayIDs))
        XCTAssertTrue(personal.allSatisfy { $0.occasion == .personal })
        XCTAssertTrue(personal.allSatisfy(\.occasion.isPersonalEveryday))

        for id in DuaCatalog.personalEverydayIDs {
            let dua = try! XCTUnwrap(DuaCatalog.dua(id: id), "Missing personal dua \(id)")
            XCTAssertEqual(dua.occasion, .personal, id)
            XCTAssertFalse(dua.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, id)
            XCTAssertFalse(dua.arabic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, id)
            XCTAssertFalse(dua.transliteration.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, id)
            XCTAssertFalse(dua.meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, id)
            XCTAssertFalse(dua.sourceNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, id)
            XCTAssertTrue(
                dua.transliteration.unicodeScalars.contains { CharacterSet.letters.contains($0) },
                "\(id) needs readable Latin transliteration"
            )
        }

        let newPersonalIDs = [
            "personal.provision",
            "personal.protection",
            "personal.guidance",
            "personal.family",
            "personal.health",
            "personal.travel",
            "personal.anxiety",
            "personal.ending",
            "personal.knowledge"
        ]
        XCTAssertTrue(Set(newPersonalIDs).isSubset(of: Set(DuaCatalog.personalEverydayIDs)))
        XCTAssertEqual(DuaCatalog.dua(id: "personal.provision")?.sourceNote.contains("28:24") ?? false, true)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.guidance")?.sourceNote.contains("1:6") ?? false, true)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.knowledge")?.sourceNote.contains("20:114") ?? false, true)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.ending")?.sourceNote.contains("12:101") ?? false, true)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.travel")?.sourceNote.contains("43:13") ?? false, true)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.anxiety")?.sourceNote.contains("20:25") ?? false, true)
        XCTAssertEqual(DuaCatalog.dua(id: "personal.family")?.sourceNote.contains("25:74") ?? false, true)
    }

    func testPersonalEverydayDuasAreNotDumpedIntoRitualStages() {
        for stage in PerformStage.allCases {
            let stageDuas = DuaCatalog.duas(forStage: stage)
            XCTAssertFalse(
                stageDuas.contains(where: { $0.occasion.isPersonalEveryday }),
                "Personal / Everyday duas must stay out of \(stage.rawValue) unless a step names them"
            )
            XCTAssertTrue(stageDuas.allSatisfy { $0.occasion.performStage == stage })
        }

        let ritualIDs = Set(DuaCatalog.duas.filter { !$0.occasion.isPersonalEveryday }.map(\.id))
        XCTAssertTrue(ritualIDs.contains("talbiyah"))
        XCTAssertTrue(ritualIDs.contains("tawaf.rabbana"))
        XCTAssertFalse(ritualIDs.contains("personal.provision"))
        XCTAssertGreaterThanOrEqual(ritualIDs.count, 13)
    }

    func testIdentifiersAreUnique() {
        let ids = DuaCatalog.duas.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count)
    }

    func testFirstSightNoteDoesNotInventARequiredScript() {
        let dua = DuaCatalog.dua(id: "kaaba.accept")
        XCTAssertEqual(dua?.occasion, .firstSightKaaba)
        let note = (dua?.whenToSay ?? "") + (dua?.sourceNote ?? "")
        XCTAssertTrue(note.localizedCaseInsensitiveContains("no required"))
    }
}
