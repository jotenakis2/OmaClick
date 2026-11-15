---
name: Bug report
about: Something about the context menu does not work
title: "[Bug]: "
labels: bug
assignees: ""
---

## What happens

<!-- A clear description of the problem. -->

## Steps to reproduce

1.
2.
3.

## Expected behaviour

<!-- What you expected instead. -->

## Environment

- Omarchy version (`cat /usr/share/omarchy/version`):
- OmaClick version (`jq -r .version ~/.config/omarchy/plugins/io.github.shayanshahravi.omaclick/manifest.json`):
- Hyprland version (`hyprctl version | head -1`):
- Monitors (`hyprctl monitors -j | jq '[.[] | {name, width, height, scale}]'`):
- Other plugins enabled that draw on the desktop or overlay layer:
- HiDPI scale, if not 1:

## Logs

<!-- Lines from the shell log around the problem: -->
<!-- qs log -p /usr/share/omarchy/shell --tail 100 -->

```
paste here
```

## Anything else

<!-- Screenshots, recordings, or guesses about the cause. -->
