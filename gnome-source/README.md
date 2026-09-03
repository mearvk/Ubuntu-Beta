# GNOME Source

Structural staging area for the GNOME source tree being transferred from `Ubuntu.Determinant.Beta.Restricted/gnome-source`.

The repository currently contains the directory/module layout and transfer markers. Full source blobs will be added in subsequent transfer passes.

## Canonical module layout

Each module is intended to follow:

```text
<module>/
├── README.md
├── pull-source.sh
├── source/
├── build/
└── patches/
```

This commit establishes the destination structure without claiming that the full upstream source has already been copied.
