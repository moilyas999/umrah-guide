#!/usr/bin/env python3
"""Generate a 1024x1024 App Store icon (no transparency, no text)."""

from pathlib import Path

from PIL import Image, ImageDraw


def lerp(a, b, t):
    return int(a + (b - a) * t)


def main() -> None:
    size = 1024
    img = Image.new("RGB", (size, size), (18, 56, 44))
    draw = ImageDraw.Draw(img)

    # Soft radial wash so the square does not look flat.
    cx = cy = size / 2
    max_r = (size**2 + size**2) ** 0.5 / 2
    pixels = img.load()
    for y in range(size):
        for x in range(size):
            d = ((x - cx) ** 2 + (y - cy) ** 2) ** 0.5 / max_r
            t = min(1.0, d)
            r = lerp(28, 12, t)
            g = lerp(78, 40, t)
            b = lerp(62, 34, t)
            pixels[x, y] = (r, g, b)

    # Front-facing Kaaba: dark cube with a gold band (kiswah motif).
    cube_w, cube_h = 430, 470
    left = (size - cube_w) // 2
    top = 230
    right = left + cube_w
    bottom = top + cube_h

    draw.rounded_rectangle(
        [left, top, right, bottom],
        radius=18,
        fill=(18, 18, 20),
    )

    band_top = top + 168
    band_h = 78
    draw.rectangle([left, band_top, right, band_top + band_h], fill=(196, 160, 78))

    # Subtle inner line on the band.
    inset = 22
    draw.rectangle(
        [left + inset, band_top + 18, right - inset, band_top + band_h - 18],
        outline=(232, 206, 130),
        width=4,
    )

    # Door suggestion, lower third.
    door_w, door_h = 92, 150
    door_l = size // 2 - door_w // 2
    door_t = bottom - door_h - 28
    draw.rounded_rectangle(
        [door_l, door_t, door_l + door_w, bottom - 18],
        radius=8,
        fill=(196, 160, 78),
    )

    out = Path(__file__).resolve().parents[1] / "UmrahGuide" / "Resources" / "Assets.xcassets" / "AppIcon.appiconset" / "AppIcon.png"
    out.parent.mkdir(parents=True, exist_ok=True)
    img.save(out, format="PNG")
    print(f"Wrote {out}")


if __name__ == "__main__":
    main()
