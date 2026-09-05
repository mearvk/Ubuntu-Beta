# Ubuntu Orange Edition Panel

A GNOME Shell extension for the Ubuntu Orange Edition desktop. It adds a
Start button that stays fixed at the left of the panel and a Start menu popup
whose horizontal alignment is configurable.

This is the supported Shell extension/customization layer that the Orange Edition
GNOME configuration README calls for. It is additive and reversible: it does not
edit any vendored upstream GNOME source. It is the sibling of the White Edition
panel extension and behaves identically; only the palette and identifiers differ.

## Behavior

- The Start button is always placed at the left of the panel and never moves.
  It is inserted into the panel left box (the top-left on a stock GNOME panel)
  at position 0 unconditionally.
- Only the Start menu popup's horizontal anchoring changes, driven by the
  `start-menu-alignment` GSettings key:
  - `left` (default): popup opens near the button at the left edge.
  - `center`: popup opens over the center of the primary monitor work area.
  - `right`: popup opens against the right edge.
- The button glyph is selectable from three bundled Ubuntu-themed logos via the
  `start-button-logo` key: `circle-of-friends`, `mono-accent`, `focus-ring`.

Both settings are exposed through `prefs.js` so they appear in GNOME Extensions
and Control Center, and the extension connects to `changed::` signals to apply
changes live where the running Shell allows it.

## Selecting the alignment and logo

The two keys can be set from the preferences UI (GNOME Extensions or Control
Center, which opens `prefs.js`) or from the command line with `gsettings`.

Set the popup alignment:

```sh
gsettings set org.gnome.shell.extensions.orange-edition start-menu-alignment 'center'
```

Choose the Start button logo:

```sh
gsettings set org.gnome.shell.extensions.orange-edition start-button-logo 'mono-accent'
```

Read the current values:

```sh
gsettings get org.gnome.shell.extensions.orange-edition start-menu-alignment
gsettings get org.gnome.shell.extensions.orange-edition start-button-logo
```

`gsettings` must be able to find the schema. When the extension is installed its
schema lives in the extension's `schemas/` directory; point `gsettings` at that
directory with `GSETTINGS_SCHEMA_DIR` if the schema is not on the default system
path, for example:

```sh
GSETTINGS_SCHEMA_DIR=/usr/share/gnome-shell/extensions/orange-edition@mearvk/schemas \
  gsettings get org.gnome.shell.extensions.orange-edition start-menu-alignment
```

The three logo values map to the bundled artwork:

- `circle-of-friends`: an accent mark on a light chip, the default glyph.
- `mono-accent`: a restrained near-white glyph with a single dark accent dot.
- `focus-ring`: an outline mark inside a focus ring.

## Target

- GNOME Shell version: 46 (also declared compatible with 47 in `metadata.json`).
- Modern GJS ESM: imports from `gi://` and `resource:///org/gnome/shell/...`.
- Preferences use `ExtensionPreferences` with Adwaita and GTK 4.

## Files

```text
orange-edition@mearvk/
├── metadata.json
├── extension.js
├── prefs.js
├── stylesheet.css
├── install.sh
├── README.md
├── schemas/
│   └── org.gnome.shell.extensions.orange-edition.gschema.xml
└── logos/
    ├── circle-of-friends.svg
    ├── mono-accent.svg
    └── focus-ring.svg
```

## Install

```sh
./install.sh /path/to/iso/target/root
```

The installer requires an explicit absolute target root that contains `/etc`,
rejects symbolic links and special files in the source, copies the extension
into `usr/share/gnome-shell/extensions/orange-edition@mearvk/`, and compiles the
GSettings schema in place with `glib-compile-schemas`. The compiled schema cache
is generated at install time and is never committed to the repository.

After installation the extension must be enabled before it takes effect. On the
target system it can be enabled with `gnome-extensions enable orange-edition@mearvk`
once GNOME Shell has picked up the new extension directory.

## Restart and relogin caveats

- Enabling a newly installed extension generally requires GNOME Shell to reload
  the extension list. On Xorg this can be done with a Shell restart; on Wayland
  a log out and log back in is required, because the Shell cannot be restarted
  in place under Wayland.
- Compiling the schema (`glib-compile-schemas`) must complete before the
  extension or `gsettings` can resolve the two keys. A session that started
  before the schema was compiled may need to be restarted to see the keys.
- Alignment and logo changes made through `changed::` signals apply live only
  while the extension is running in an active Shell. If the Shell is not running
  the new value is stored and applied the next time the extension loads.

## Verification status

This layer was authored as a re-themed sibling of the validated White Edition
panel extension. In the build sandbox there is no live GNOME Shell and no
`gnome-extensions` CLI, so runtime behavior must be confirmed on a real Orange
Edition session:

- the popup actually anchoring left, center, and right on the primary monitor
  work area;
- the Start button staying fixed at the left of the panel while only the popup
  moves;
- the live GSettings binding updating the button glyph and popup alignment;
- the `prefs.js` preferences UI rendering under Adwaita and GTK 4.

Recommended static checks before packaging: `node --check extension.js prefs.js`;
`glib-compile-schemas --dry-run schemas`; validating the SVG logos and the gschema
as well-formed XML; `bash -n install.sh`; and confirming the metadata uuid, the
schema id, and the two key names are consistent across the files.

## Trademark note

The Ubuntu Circle of Friends is a trademark of Canonical Ltd. The three bundled
logos are deliberately original, Ubuntu-themed artwork and are not the Canonical
Circle of Friends mark or a reproduction of any proprietary Ubuntu artwork. This
is consistent with the project's position that it is an independent style
specification and not a claim of official Ubuntu branding. Any name such as
`circle-of-friends` refers only to the local artwork file, not to the trademarked
mark.
