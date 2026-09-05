# Ubuntu Orange Edition — GRUB boot menu theme

The first thing shown by the OS itself (after firmware) is the GRUB menu. This
directory makes that menu orange-skinned and makes "Ubuntu Orange Edition" the
default entry.

## Files

```text
grub/
├── README.md             ← this file
├── 05_orange_edition     ← /etc/default/grub.d drop-in (theme + graphics + default entry)
└── theme/
    └── theme.txt         ← GRUB theme definition (colors, layout, fonts)
```

## What it does

- Paints the GRUB desktop orange (`#e95420`) with near-white (`#ffffff`) entries.
- Highlights the selected entry with a deep-orange (`#a8371a`) background.
- Sets `GRUB_DEFAULT=0` so the Orange Edition entry boots by default.
- Sets `GRUB_GFXMODE=auto` + `GRUB_GFXPAYLOAD_LINUX=keep` so the graphical theme
  renders and the framebuffer carries into the Plymouth splash without a flicker
  to a text console.
- Uses `quiet splash` so early boot goes straight into the Orange Edition Plymouth
  theme.

## Install (done by ../install-boot-presentation.sh)

1. Copy `theme/` to `<root>/boot/grub/themes/orange-edition/`.
2. Copy `05_orange_edition` to `<root>/etc/default/grub.d/05_orange_edition`.
3. Generate the theme's 9-slice pixmaps (orange row, deep-orange selected row,
   deep-orange progress) from the token colors if they are not already present.
4. Inside the target root: run `update-grub`.

## Colors

Match `../../theme/orange-edition.css`:

| Element | Color |
|---|---|
| menu background | `#e95420` |
| entry text | `#ffffff` |
| selected entry text | `#ffffff` on `#a8371a` |
| title | `#ffffff` |
| subtitle / footer | `#ffd9c9` |
| progress track | `#c7431a` |
| progress fill | `#a8371a` |

## Notes

- Fonts must be `.pf2`; the installer converts a system TTF with `grub-mkfont` at
  build time. If a face other than DejaVu Sans is used, update the font names in
  `theme.txt` to match the converted font's internal name.
- This is an overlay. It does not modify the main `/etc/default/grub`; it only
  drops a file into the supported `grub.d` directory, so it is independently
  removable.
