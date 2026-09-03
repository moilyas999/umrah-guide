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
            "general.gratitude": ("الْحَمْدُ", "Alhamdu")
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
