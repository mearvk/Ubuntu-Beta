# Ubuntu Orange Edition — Plymouth boot splash

The splash shown during early boot (after GRUB, while the kernel and initramfs
bring the system up). This theme replaces the stock Ubuntu spinner with the Orange
Edition presentation so the orange identity is unbroken from the GRUB menu into the
login greeter.

## Files

```text
plymouth/orange-edition/
├── README.md                 ← this file
├── orange-edition.plymouth   ← theme descriptor (ModuleName=script)
└── orange-edition.script     ← the splash: orange field, centered mark, near-white/deep-orange progress
```

An optional `logo.png` (the Orange Edition mark) is placed next to the script at
install time. If it is absent, the script draws a typographic "Ubuntu Orange
Edition" mark instead, so the splash always renders.

## What it does

- Fills the screen orange (`#e95420`).
- Centers the Orange Edition mark, near-white (`#ffffff`).
- Draws a thin deep-orange (`#a8371a`) progress bar on an edge-orange (`#c7431a`)
  track.
- Shows boot stage messages in muted (`#ffd9c9`).
- Keeps the encrypted-disk password prompt orange-skinned.
- Honors the single stationary upper-left key light — nothing animates a light
  source; only the progress fill moves.

## Install (done by ../../install-boot-presentation.sh)

1. Copy this directory to `<root>/usr/share/plymouth/themes/orange-edition/`.
2. Place the Orange Edition logo as `logo.png` in that directory (optional).
3. Inside the target root, make it the default theme. On Ubuntu this is done via
   the alternatives system and the plymouth helper:

   ```sh
   update-alternatives --install \
     /usr/share/plymouth/themes/default.plymouth default.plymouth \
     /usr/share/plymouth/themes/orange-edition/orange-edition.plymouth 200
   plymouth-set-default-theme orange-edition
   update-initramfs -u
   ```

   The `update-initramfs -u` step is required so the theme is embedded in the
   initramfs and appears during real early boot.

## Notes

- This is the `script` Plymouth module, which is present in Ubuntu's
  `plymouth-theme-*` packages. It does not require compiling a custom C module.
- The theme is reversible: `plymouth-set-default-theme <other>` +
  `update-initramfs -u` restores any prior theme.
- Colors are the Orange Edition tokens shared with `../../../theme/orange-edition.css`.
