# Orange Edition Precision Theme

This directory defines the visual language for the Ubuntu Orange Edition GNOME desktop.

## Design objective

The desktop should read as a professional, predominantly **orange** physical surface
with controlled depth. Ubuntu Orange is the dominant surface. Near-white provides
readable text and controls. A deeper orange provides shadow, edge, and elevation
information. A dark, high-contrast tone is reserved for text on light insets and for
restrained focus separation.

Where White Edition treats orange as a sparse accent on white, Orange Edition inverts
that relationship: orange is the field, and depth is expressed through warmer, darker
oranges rather than neutral gray.

## Lighting model

`lighting.conf` defines a single stationary upper-left virtual key light. Desktop
objects receive different elevations and shadow softness according to their role:

1. Desktop surface — baseline.
2. Icons — low elevation and tight contact shadow.
3. Bottom taskbar/panel — modest elevation.
4. Normal windows — larger, softer separation.
5. Focused windows — slightly greater elevation and restrained deep-orange focus treatment.
6. Dialogs/menus — highest visual elevation.

During movement, the light remains stationary. The object changes elevation and its
shadow responds; the shadow must not appear attached as a decorative bitmap. Shadows
are warm (brown-toned, derived from deep orange) rather than neutral gray so they read
naturally against the orange field.

## Implementation boundary

`orange-edition.css` is a theme-layer specification. Actual GNOME Shell, GTK, and
compositor selectors/APIs must be implemented by the corresponding supported component.
`lighting.conf` is a design contract and is not itself a GNOME API.

Mutter is responsible for compositor-level window effects and transitions. GNOME Shell
is responsible for desktop/panel presentation. GTK is responsible for application widget
presentation. The Orange Edition icon package supplies the icon artwork.

## Quality rules

- No pure-black drop shadows (use the warm deep-orange-derived shadow tokens).
- No uncontrolled glow.
- No arbitrary per-widget light directions.
- Preserve text contrast and accessibility: near-white on orange for chrome, dark text
  on light insets, and never low-contrast orange-on-orange for body text.
- Prefer subtle physical depth over glossy decoration.
- Keep dark high-contrast accents intentional and sparse.
- Maintain consistent apparent light direction across icons, windows, menus, and panels.
