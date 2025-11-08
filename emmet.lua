VERSION = "0.0.1"


local micro   = import("micro")
local config  = import("micro/config")
local buffer  = import("micro/buffer")
local shell   = import("micro/shell")
local path    = import("path")
local strings = import("strings")


local PLUG_NAME   = "micro-emmet"
local PLUG_PATH   = path.Join(config.ConfigDir, "plug", PLUG_NAME)
local NODE_SCRIPT = path.Join(PLUG_PATH, "emmet.js")

local function detectLanguage(abbr, filetype)
    local lowerAbbr = abbr:lower()

    -- Explicit prefix wins
    -- if lowerAbbr:match("^css:") or lowerAbbr:match("^cs:") or lowerAbbr:match("^c:") then
    -- return "css", (abbr:gsub("^%w+:", "")) -- strip prefix
    -- end

    local prefix = lowerAbbr:match("^(c?s?s?):")
    if prefix then
        return "css", (abbr:gsub("^%w+:", ""))
    end

    -- Filetype hint
    if filetype and filetype:match("css") then
        return "css", abbr
    end

    -- Default
    return "html", abbr
end

local function getSelectionBounds()
    local view = micro.CurPane()
    local cursor = view.Cursor

    if cursor:HasSelection() then
        local startSel, endSel = cursor.CurSelection[1], cursor.CurSelection[2]
        if startSel:GreaterThan(-endSel) then
            return buffer.Loc(endSel.X, endSel.Y), buffer.Loc(startSel.X, startSel.Y)
        else
            return buffer.Loc(startSel.X, startSel.Y), buffer.Loc(endSel.X, endSel.Y)
        end
    end

    local line = view.Buf:Line(cursor.Loc.Y)
    local lineLen = #line

    if cursor.Loc.X >= lineLen then
        return buffer.Loc(0, cursor.Loc.Y), buffer.Loc(lineLen, cursor.Loc.Y)
    end

    return buffer.Loc(cursor.Loc.X, cursor.Loc.Y), buffer.Loc(lineLen, cursor.Loc.Y)
end

local function getSelectedText(startPos, endPos)
    local buf = micro.CurPane().Buf
    if startPos.Y == endPos.Y then
        local lineText = buf:Line(startPos.Y)
        if startPos.X >= #lineText then return lineText end
        return lineText:sub(startPos.X + 1, endPos.X)
    end

    local lines = { buf:Line(startPos.Y):sub(startPos.X + 1) }
    for lineIndex = startPos.Y + 1, endPos.Y - 1 do
        table.insert(lines, buf:Line(lineIndex))
    end
    table.insert(lines, buf:Line(endPos.Y):sub(1, endPos.X))
    return table.concat(lines, "\n")
end

-- Run Emmet Node script with --stylesheet flag when needed
local function expandAbbreviation(abbr, lang)
    local stylesheetFlag = (lang == "css") and "--stylesheet" or ""
    local command = string.format('node %q %s %q', NODE_SCRIPT, stylesheetFlag, abbr)
    local stdout, stderr = shell.RunCommand(command)

    if stderr then
        micro.Log(stderr)
        micro.InfoBar():Error(stderr)
        return nil
    end

    return stdout
end

local function runEmmetExpansion(bufPane)
    local filetype = bufPane.Buf:FileType()
    local startPos, endPos = getSelectionBounds()
    local sourceText = strings.Trim(getSelectedText(startPos, endPos), " ")

    local lang, cleanAbbr = detectLanguage(sourceText, filetype)
    local expanded = expandAbbreviation(cleanAbbr, lang)

    if expanded then
        bufPane.Buf:Replace(startPos, endPos, expanded)
    end
end

function init()
    config.TryBindKey("Alt-e", "command:emmet", false)
    config.MakeCommand("emmet", runEmmetExpansion, config.NoComplete)
    config.AddRuntimeFile("emmet", config.RTHelp, "help/emmet.md")
end
