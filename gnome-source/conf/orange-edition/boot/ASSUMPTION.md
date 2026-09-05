# Ubuntu Orange Edition — OS Presentation Assumption

**Project:** Ubuntu Determinant / Ubuntu Orange Edition
**Scope:** Whole-OS visual presentation, power-on through desktop session
**Status:** DESIGNED / SPECIFIED (boot chain source present; activation is a build-host step)

## 1. The assumption

Ubuntu Orange Edition assumes, as a baseline OS property, that **the installed
operating system is an orange-skinned Ubuntu**. "Orange-skinned" here means the
Orange Edition visual system — predominantly Ubuntu-orange surfaces, near-white
text, warmer deeper-orange depth, and a dark high-contrast tone for insets and
focus — is the **default presentation of every stage the user sees**, not a theme
the user must discover and enable after installation.

This is a *default*, not a lock. The system remains fully Ubuntu: users and
administrators can change the session, theme, splash, or boot behavior. The
assumption governs the out-of-the-box state, specifically the state immediately
**after install, on first boot**.

## 2. Where the assumption must hold

The presentation must be continuous. There must be no stage at which stock Ubuntu,
vendor firmware branding, or an unstyled default interrupts the Orange Edition
identity between power-on and the desktop.

```text
Stage                     Assumption upheld by                          State
──────────────────────────────────────────────────────────────────────────────
1. Firmware / UEFI        (out of project scope — vendor firmware)      N/A
2. GRUB boot menu         boot/grub/theme + boot/grub/05_orange_edition ORANGE
3. Early boot / splash    boot/plymouth/orange-edition/                 ORANGE
4. Login greeter (GDM)    boot/gdm/10-orange-edition                    ORANGE
5. Session offering       boot/gdm/ubuntu-orange.desktop                "Ubuntu Orange"
6. Desktop session        ../db/local.d/00-orange-edition + ../theme/   ORANGE
──────────────────────────────────────────────────────────────────────────────
```

Stage 1 (firmware) is outside the OS: the project does not repaint vendor firmware.
Stages 2–6 are all Orange Edition responsibilities and are all supplied in this
repository.

## 3. The first-boot offering

The specific requirement in scope is: **the bootup after install presents the
orange-flavored Ubuntu offering.** Concretely, on the first boot of a freshly
installed system:

1. GRUB shows the Orange Edition menu (orange background, near-white entries,
   deep-orange highlight on the selected entry). "Ubuntu Orange Edition" is the
   default, top entry.
2. The boot splash is the Orange Edition Plymouth theme (orange field, centered
   mark, deep-orange progress), not the stock spinner.
3. The GDM greeter is orange-skinned, and the session chooser **offers a session
   named "Ubuntu Orange"** (`boot/gdm/ubuntu-orange.desktop`), selected as the
   default session.
4. Logging into that session lands in the Orange Edition GNOME desktop
   (`prefer-dark`, `Ubuntu-Orange` icon theme, Orange Edition CSS/lighting).

If any of stages 2–5 falls back to stock presentation, the assumption is considered
**violated** and the build audit should record it rather than shipping.

## 4. Ownership map

Each stage is owned by a specific mechanism; the Orange Edition layer only supplies
defaults/themes to that mechanism. This mirrors the ownership map in
`../README.md` ("Configuration ownership") and extends it to boot time:

| Stage | Upstream owner | Orange Edition input |
|---|---|---|
| GRUB menu | GRUB 2 | `grub/theme/theme.txt`, `grub/05_orange_edition` drop-in |
| Boot splash | Plymouth | `plymouth/orange-edition/` theme |
| Greeter | GDM + GSettings | `gdm/10-orange-edition` dconf defaults |
| Session list | XDG session `.desktop` + GNOME Shell | `gdm/ubuntu-orange.desktop` |
| Desktop | GNOME Shell / GTK / Mutter / dconf | `../db`, `../theme` (existing) |

## 5. What this assumption does NOT claim

- It does **not** claim Orange Edition owns or forks GRUB, Plymouth, or GDM. They
  remain upstream components; only theme/default overlays are added.
- It does **not** remove the user's ability to pick another session, theme, or
  disable the splash.
- It does **not** repaint firmware/UEFI vendor screens.
- It does **not** assert the boot chain is already *activated* — the source is
  present here; the build host must run `install-boot-presentation.sh` against the
  ISO target root and then run the target-root activation commands
  (`update-grub`, `update-initramfs -u`, `dconf update`) for the assumption to hold
  on a real image.

## 6. Verification checklist (build-host)

The boot presentation is upheld only after the build host demonstrates, on the
target image:

```text
[ ] GRUB uses the Orange Edition theme and lists "Ubuntu Orange Edition" as default
[ ] GRUB gfxmode/gfxpayload set so the theme renders (not text fallback)
[ ] Plymouth default theme = orange-edition (update-alternatives / plymouth-set-default-theme)
[ ] initramfs rebuilt so the Plymouth theme is present in early boot
[ ] GDM greeter shows Orange Edition presentation (prefer-dark, Ubuntu-Orange accents)
[ ] Session chooser offers "Ubuntu Orange" and it is the default session
[ ] First login lands in the Orange Edition GNOME desktop (prefer-dark + Ubuntu-Orange)
[ ] No stage falls back to stock Ubuntu presentation
[ ] Each installed file is recorded for reversibility/audit
```

---

**Max Rupplin — MEARVK LLC — 2026**
