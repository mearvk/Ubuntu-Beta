# Ubuntu Orange Edition — Boot-to-Desktop Presentation Chain

This directory holds the source configuration that guarantees the **orange-skinned
Ubuntu presentation is continuous from power-on through the first login and into
the desktop session**. It is the boot-time counterpart to the desktop dconf/theme
layer in `../` (`profile/`, `db/`, `theme/`).

The desktop layer (`../db/local.d/00-orange-edition`, `../theme/`) only takes effect
*after* a user session starts. Everything a user sees **before** that — firmware
handoff, the GRUB menu, the boot splash, and the login greeter — is defined here so
the Orange Edition identity is never interrupted by stock Ubuntu/vendor styling.

## The presentation stages

```text
firmware / UEFI
      ↓
GRUB menu            ← boot/grub/theme/        (orange menu, deep-orange highlight)
      ↓
Plymouth splash      ← boot/plymouth/orange-edition/   (orange splash during boot)
      ↓
GDM login greeter    ← boot/gdm/               (orange greeter, Orange Edition session)
      ↓
GNOME Shell session  ← ../db + ../theme        (prefer-dark, Ubuntu-Orange icons)
```

Each stage is a separately installable, separately reversible overlay. None of
them replace the upstream boot components; they supply Orange Edition **themes and
defaults** that the supported mechanisms (GRUB theme protocol, the Plymouth theme
system, and GDM/GSettings) load.

## Design tokens (shared with the desktop theme)

These match `../theme/orange-edition.css` and `../theme/lighting.conf` exactly so the
boot chain and the desktop are visually one system:

| Token | Value | Use |
|---|---|---|
| surface | `#e95420` | primary background |
| surface-raised | `#ec6b3e` | panels, selected rows |
| surface-soft | `#f08a63` | secondary fills |
| inset | `#fff3ee` | light menu/field surfaces |
| text | `#ffffff` | primary text on orange |
| text-strong | `#2b0f06` | text on light insets |
| text-muted | `#ffd9c9` | secondary text |
| edge | `#c7431a` | borders / separators |
| accent (deep orange) | `#a8371a` | selection, focus, progress |

Lighting stays consistent with `../theme/lighting.conf`: a single stationary
upper-left key light, restrained warm shadows, no pure-black shadow, no glow.

## Contents

```text
boot/
├── README.md                      ← this file
├── ASSUMPTION.md                  ← OS-wide "this is orange-skinned Ubuntu" contract
├── install-boot-presentation.sh   ← installs the whole chain into an ISO target root
├── grub/
│   ├── README.md
│   ├── 05_orange_edition           ← /etc/default/grub.d drop-in (theme + gfx defaults)
│   └── theme/theme.txt             ← GRUB theme definition
├── plymouth/
│   └── orange-edition/
│       ├── README.md
│       ├── orange-edition.plymouth ← Plymouth theme descriptor
│       └── orange-edition.script   ← script-module splash (orange bg, deep-orange progress)
└── gdm/
    ├── README.md
    ├── 10-orange-edition            ← GDM dconf defaults (greeter presentation)
    └── ubuntu-orange.desktop        ← Xsession/Wayland session "Ubuntu Orange" offering
```

## Policy

- These are **defaults and themes**, not locks. A user or administrator can still
  choose a different session, disable the splash, or change GRUB behavior.
- The source artwork of record remains `ubuntu-orange/icons/`; the boot chain refers
  to logo assets by install path rather than duplicating artwork here.
- Nothing here is compiled into the repository. The installer compiles/activates the
  themes inside the target root at build time (`dconf update`, `update-grub`,
  `update-initramfs -u`, `update-alternatives` for the Plymouth theme).
- Every stage records what it installed so it can be reverted and audited.

See `ASSUMPTION.md` for the OS-wide statement that Ubuntu Orange Edition is an
orange-skinned Ubuntu by default, and how each layer upholds that assumption.
