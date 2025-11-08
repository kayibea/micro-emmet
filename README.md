# Emmet Plugin

Emmet — the essential toolkit for web-developers into micro.

---

## Installation

```bash
cd ~/.config/micro/plug
git clone https://github.com/kayibea/micro-emmet.git
cd micro-emmet
npm install
```

Then restart Micro.

---

## Example

Type:

```
ul>li.item$*3
```

Then run:

```
> emmet
```

Or use the default keybind: `Alt-e`

Result:

```html
<ul>
    <li class="item1"></li>
    <li class="item2"></li>
    <li class="item3"></li>
</ul>
```

![Demo GIF](demo.gif "Demo: Expanding Emmet abbreviations")

---

## Documentation

Inside Micro, run:

```
> help emmet
```

Or see [help/emmet.md](help/emmet.md) for:

- Usage and available commands
- Configuration options
- Keybindings and behavior details

## See also

[Emmet](https://github.com/emmetio/emmet)
[Emmet Docs](https://docs.emmet.io/)
