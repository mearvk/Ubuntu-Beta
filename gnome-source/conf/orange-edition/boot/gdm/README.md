# Ubuntu Orange Edition — GDM greeter and session offering

This directory makes the **login greeter** orange-skinned and makes the greeter's
session chooser **offer "Ubuntu Orange"** as the default session. This is the
stage the first-boot requirement calls "the orange flavored Ubuntu offering."

## Files

```text
gdm/
├── README.md                ← this file
├── 10-orange-edition        ← GDM dconf defaults (styles the greeter itself)
├── ubuntu-orange.desktop    ← the session entry shown in the greeter chooser
└── ubuntu-orange.session    ← the gnome-session definition it launches
```

## What each file does

- **`10-orange-edition`** — greeter presentation. GDM runs under its own dconf
  profile, so these keys (`prefer-dark`, `Ubuntu-Orange` icons, solid orange
  background, "Ubuntu Orange Edition" banner) style the login screen only, not user
  sessions. Installed to `/etc/dconf/db/gdm.d/` and compiled with `dconf update`.
- **`ubuntu-orange.desktop`** — the selectable session. Installed to
  `/usr/share/wayland-sessions/ubuntu-orange.desktop` (and/or `xsessions/`). Its
  `Name=Ubuntu Orange` is what the greeter's gear/session menu lists.
- **`ubuntu-orange.session`** — the gnome-session component list that
  `gnome-session --session=ubuntu-orange` runs. It reuses upstream GNOME Shell and
  the standard settings daemons; the Orange Edition look comes from the desktop
  dconf/theme layer in `../../db` and `../../theme`, not from a forked session.

## Notes

- These are defaults, not locks. A user can still choose a different session at the
  greeter, and administrators can change the greeter defaults.
- The session reuses upstream GNOME; only defaults and theme overlays are added, so
  the offering stays a maintainable overlay rather than a fork.
- Nothing here is compiled into the repository. The installer compiles the GDM dconf
  defaults inside the target root with `dconf update`.
