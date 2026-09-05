# Ubuntu Orange Edition GNOME Configuration

This directory is the configuration layer for the assumed Ubuntu Orange Edition GNOME desktop.

## Configuration model

GNOME configuration is primarily expressed through **GSettings schemas** and a settings backend such as **dconf**. GNOME's system-administration model uses `/etc/dconf/profile/` for profiles and `/etc/dconf/db/<name>.d/` keyfiles for system-wide defaults. The compiled `/etc/dconf/db/<name>` databases are generated with `dconf update` and are not hand-edited.

This repository therefore keeps the human-readable Orange Edition policy here and lets the ISO build install/compile it into the target filesystem.

## Layout

```text
config/orange-edition/
├── README.md
├── profile/
│   └── user
├── db/
│   └── local.d/
│       └── 00-orange-edition
└── install-config.sh
```

## Initial policy

The initial policy is intentionally conservative:

- Prefer the dark GNOME color scheme so chrome reads against the orange surface.
- Select the `Ubuntu-Orange` icon theme when it is installed by the image build.
- Keep user settings writable unless a specific policy requires a lock.
- Establish Orange Edition defaults through dconf rather than modifying GNOME source.
- Keep module-specific settings in the module's GSettings schemas and use this layer only for distribution defaults.

The icon-theme value may be changed if the final installed icon theme receives a different package name.

## Modules and configuration ownership

- **Mutter:** display/compositor/window-management settings exposed through its GSettings schemas.
- **GNOME Shell:** shell behavior, favorites, extensions, and shell UI settings.
- **GTK/GDK:** toolkit behavior and interface/theme settings; the desktop interface schema provides common theme settings.
- **GLib/GSettings:** schema definitions and configuration API; this is not itself the desktop policy store.
- **GVfs:** virtual filesystem behavior and backend-specific settings.
- **GNOME Control Center:** presents configuration panels; most settings are owned by the underlying schemas rather than by the control-center UI.
- **GNOME Software:** application/software-management preferences owned by its installed schemas and application data.
- **GNOME Terminal:** terminal application/profile settings owned by its GSettings schemas.
- **Orca:** accessibility settings and preferences owned by Orca and related accessibility schemas.
- **glib-networking:** network/TLS integration settings exposed through GLib/GIO and its installed schemas where applicable.
- **Cairo/GDK-Pixbuf:** rendering/image libraries; they generally do not define the central desktop policy and should not receive Orange Edition policy through dconf unless a specific schema exists.
- **Vala:** build-time language/compiler tooling; no desktop runtime policy.
- **Gala:** separate optional compositor/window-manager project; no Orange Edition default is enabled merely by having its source present.

## Ubuntu baseline

We do not copy Ubuntu's compiled dconf databases into this repository. Ubuntu's `ubuntu-settings` and `gsettings-desktop-schemas` packages are the appropriate baseline references; Orange Edition policy is represented as source keyfiles so the ISO build can reproduce it and review every customization.

## Security and reproducibility

Do not add passwords, tokens, machine-specific paths, or user-private dconf databases here. System defaults belong in keyfiles. A lock should only be added deliberately and documented because dconf locks prevent users from changing the affected setting.
