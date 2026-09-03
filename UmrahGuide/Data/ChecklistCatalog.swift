import Foundation

enum ChecklistCatalog {
    static let items: [ChecklistItem] = ihram + packing

    static let ihram: [ChecklistItem] = [
        ChecklistItem(
            id: "ihram.men.cloths",
            category: .ihram,
            title: "Men: two unstitched white cloths",
            detail: "Izar and rida. Pack a spare set in case one is soiled."
        ),
        ChecklistItem(
            id: "ihram.men.belt",
            category: .ihram,
            title: "Men: belt or waist pouch",
            detail: "Holds the izar and keeps documents off the floor of the mosque."
        ),
        ChecklistItem(
            id: "ihram.pins",
            category: .ihram,
            title: "Safety pins",
            detail: "Useful for securing the rida. Keep a few extras."
        ),
        ChecklistItem(
            id: "ihram.women.clothes",
            category: .ihram,
            title: "Women: modest ihram clothing",
            detail: "Loose, opaque everyday garments. Not the two cloths. Pack a spare abaya or equivalent."
        ),
        ChecklistItem(
            id: "ihram.sandals",
            category: .ihram,
            title: "Comfortable sandals",
            detail: "Broken in before travel. Footwear rulings differ by school; confirm what you will wear in ihram."
        ),
        ChecklistItem(
            id: "ihram.unscented.soap",
            category: .ihram,
            title: "Unscented soap and shampoo",
            detail: "Scented products are avoided after ihram begins."
        ),
        ChecklistItem(
            id: "ihram.unscented.deodor",
            category: .ihram,
            title: "Unscented deodorant",
            detail: "Apply any scented product before ihram, not after."
        ),
        ChecklistItem(
            id: "ihram.unscented.lip",
            category: .ihram,
            title: "Unscented lip balm",
            detail: "Dry air and long walks make this easy to forget."
        )
    ]

    static let packing: [ChecklistItem] = [
        ChecklistItem(
            id: "pack.passport",
            category: .packing,
            title: "Passport, visa, and paper copies",
            detail: "Keep copies separate from the originals."
        ),
        ChecklistItem(
            id: "pack.bookings",
            category: .packing,
            title: "Travel and lodging confirmations",
            detail: "Printed or downloaded for offline use. This app does not store them."
        ),
        ChecklistItem(
            id: "pack.medicines",
            category: .packing,
            title: "Medicines and prescriptions",
            detail: "Include enough for delays. Label them clearly."
        ),
        ChecklistItem(
            id: "pack.water",
            category: .packing,
            title: "Reusable water bottle",
            detail: "Stay hydrated. Zamzam is a blessing, not a substitute for ordinary water on long walks."
        ),
        ChecklistItem(
            id: "pack.bag",
            category: .packing,
            title: "Small day bag",
            detail: "Hands stay freer in the mosque when your pouch is simple."
        ),
        ChecklistItem(
            id: "pack.shoe.bag",
            category: .packing,
            title: "Shoe bag",
            detail: "A light sack keeps sandals together when you enter the mosque."
        ),
        ChecklistItem(
            id: "pack.charger",
            category: .packing,
            title: "Charger and power bank",
            detail: "For travel logistics. The rites themselves do not require a phone."
        ),
        ChecklistItem(
            id: "pack.firstaid",
            category: .packing,
            title: "Simple first aid",
            detail: "Plasters, pain relief you already use, and any personal items your clinician advised."
        ),
        ChecklistItem(
            id: "pack.contacts",
            category: .packing,
            title: "Emergency contacts on paper",
            detail: "Hotel, group leader, and family. Do not rely on a locked phone."
        ),
        ChecklistItem(
            id: "pack.sunscreen",
            category: .packing,
            title: "Unscented sunscreen if you burn easily",
            detail: "Shade and water come first. Check the product has no perfume if you will use it in ihram."
        )
    ]
}
