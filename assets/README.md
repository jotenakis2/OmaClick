# Media

Screenshots and demo media for OmaClick live here.

## Preview

The marketplace and README show `preview.png` **in the repository root** (next to
`manifest.json`), so the canonical copy lives there. A copy is not kept in this
folder to avoid two files drifting apart.

To refresh it after a UI change:

1. Right-click an empty desktop to open the menu.
2. Capture the menu together with the wallpaper behind it (region capture is
   fine — a tight crop around the card keeps the file small):

   ```sh
   omarchy-capture-region
   ```

3. Save/overwrite `preview.png` in the repository root.

Guidelines: PNG, roughly 16:9 if you capture the whole screen, under 1 MB, no
personal files or window titles visible.

## Demo

A short `assets/demo.gif` (or `.mp4` linked from the README) showing
right-click → menu → row click is welcome, but not required.
