# Emmet Plugin

This plugin adds **Emmet-style abbreviation expansion** to Micro editor.

---

## Usage

Write an abbreviation such as:

```
ul>li.item$*3
```

Then execute:
```
> emmet
```
Or the default keybind `Alt-e`
The abbreviation will expand to:

```html
<ul>
    <li class="item1"></li>
    <li class="item2"></li>
    <li class="item3"></li>
</ul>
```

If text is selected, the expansion will replace the selection instead of the line under the cursor.

---

## Keybindings

You can override the default keybind or add your own bindings in `bindings.json`, for example:
```json
  "Alt-e": "command:emmet"
}
```

CSS mode examples:

| Example | Expands To |
|----------|-------------|
| `m10` | `margin: 10px;` |
| `p5-10` | `padding: 5px 10px;` |
| `bgc#333` | `background-color: #333;` |
| `c#fff` | `color: #fff;` |

---

## Mode Detection

Expansion mode is detected automatically based on the file type.
To override, prefix the abbreviation:

| Prefix | Mode |
|---------|------|
| `css:` or `cs:` or `c:` | Force CSS mode |
| *(none)* | Auto-detect by filetype |

Example:

```
css:m10
```

→ `margin: 10px;`

[Emmet Docs](https://docs.emmet.io/)
