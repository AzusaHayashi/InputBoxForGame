#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%

;@Ahk2Exe-SetName InputBoxForGame
;@Ahk2Exe-SetDescription InputBoxForGame - quick text input utility for games
;@Ahk2Exe-SetVersion 1.2.0.0
;@Ahk2Exe-SetProductName InputBoxForGame
;@Ahk2Exe-SetCopyright Copyright (c) 2026 AzusaHayashi

; ========== Defaults and settings ==========
settingsFile := A_ScriptDir . "\settings.ini"
unicodeHotkey := "^!i"
gbkHotkey := "+b"
AutoSwitchKana := "true"
IMEName := "Microsoft IME"

IniRead, unicodeHotkey, %settingsFile%, Hotkey, Key, ^!i
IniRead, gbkHotkey, %settingsFile%, Hotkey, GBKKey, +b
IniRead, AutoSwitchKana, %settingsFile%, IME, AutoSwitchKana, true
IniRead, IMEName, %settingsFile%, IME, IMEName, Microsoft IME

ParseHotkey(unicodeHotkey, unicodeModifier, unicodeKey)
ParseHotkey(gbkHotkey, gbkModifier, gbkKey)
Running := false
BoundUnicodeHotkey := ""
BoundGBKHotkey := ""
MainHwnd := ""

; ========== Localized text ==========
if (A_Language = "0804") {
    UiTitle := "InputBoxForGame - 设置"
    UiDisclaimerTitle := "免责声明（使用前请务必阅读）"
    UiDisclaimer := "本软件仅供学习交流，使用者需自行承担全部风险。`n"
    . "部分游戏的反作弊系统可能将本软件识别为违规程序，可能导致账号封禁、功能限制或其他后果。`n"
    . "请先确认目标游戏允许使用此类工具；作者不对本软件造成的任何损失或后果负责。"
    UiHotkeyGroup := "输入功能快捷键"
    UiFunction := "功能"
    UiModifier := "修饰键"
    UiKey := "按键（点击后直接按）"
    UiUnicode := "Unicode 普通输入"
    UiGBK := "GBK 兼容输入"
    UiAutoIME := "打开输入框时保持当前日文 IME 状态"
    UiIMEName := "IME 名称匹配"
    UiCaptureHelp := "提示：点击右侧按键框后直接按键；若同时按 Shift/Ctrl/Alt，左侧会自动同步。点击“启动 / 应用”后设置才会生效。"
    UiStart := "启动 / 应用"
    UiPause := "暂停"
    UiExit := "退出"
    UiPaused := "状态：已暂停"
    UiRunning := "状态：运行中"
    UiDirty := "状态：运行中（设置尚未应用）"
    UiNeedHotkey := "请至少为 Unicode 或 GBK 输入设置一个按键。"
    UiDuplicate := "Unicode 普通输入和 GBK 兼容输入不能使用同一个快捷键。"
    UiBindFailed := "快捷键绑定失败，请更换按键后重试。"
    UiSettingsSaved := "设置已保存"
    CopyMsg := "已复制"
} else if (A_Language = "0411") {
    UiTitle := "InputBoxForGame - 設定"
    UiDisclaimerTitle := "免責事項（使用前に必ずお読みください）"
    UiDisclaimer := "本ソフトウェアは学習・交流目的のみで提供され、使用に伴うリスクは利用者自身が負うものとします。`n"
    . "一部のゲームではアンチチートシステムが本ソフトウェアを違反ツールと判定し、アカウント停止や機能制限などの結果を招く可能性があります。`n"
    . "対象ゲームでこの種のツールの使用が許可されていることを確認してください。作者は本ソフトウェアの使用により生じたいかなる損害・結果についても責任を負いません。"
    UiHotkeyGroup := "入力機能のホットキー"
    UiFunction := "機能"
    UiModifier := "修飾キー"
    UiKey := "キー（クリックして入力）"
    UiUnicode := "Unicode 通常入力"
    UiGBK := "GBK 互換入力"
    UiAutoIME := "入力欄を開いたとき、現在の日本語 IME 状態を維持する"
    UiIMEName := "IME 名の一致条件"
    UiCaptureHelp := "右側のキー欄をクリックして、そのまま使いたいキーを押してください。Shift/Ctrl/Alt を同時に押すと左側へ自動反映されます。「開始 / 適用」で設定が有効になります。"
    UiStart := "開始 / 適用"
    UiPause := "一時停止"
    UiExit := "終了"
    UiPaused := "状態：一時停止中"
    UiRunning := "状態：実行中"
    UiDirty := "状態：実行中（設定は未適用）"
    UiNeedHotkey := "Unicode または GBK 入力に少なくとも 1 つのキーを設定してください。"
    UiDuplicate := "Unicode 通常入力と GBK 互換入力に同じショートカットは使用できません。"
    UiBindFailed := "ホットキーを登録できませんでした。別のキーを設定してください。"
    UiSettingsSaved := "設定を保存しました"
    CopyMsg := "コピーしました"
} else {
    UiTitle := "InputBoxForGame - Settings"
    UiDisclaimerTitle := "Disclaimer (read before use)"
    UiDisclaimer := "This software is provided for educational and communication purposes only. Users assume all risks.`n"
    . "Anti-cheat systems in some games may classify this software as a prohibited tool, which could lead to account bans, feature restrictions, or other consequences.`n"
    . "Confirm that the target game allows this type of tool before use. The author is not responsible for any loss or consequence caused by using this software."
    UiHotkeyGroup := "Input hotkeys"
    UiFunction := "Function"
    UiModifier := "Modifier"
    UiKey := "Key (click, then press)"
    UiUnicode := "Unicode normal input"
    UiGBK := "GBK-compatible input"
    UiAutoIME := "Keep the current Japanese IME state when opening the input window"
    UiIMEName := "IME name match"
    UiCaptureHelp := "Click a key field on the right, then press the key you want. Shift/Ctrl/Alt is synchronized to the left automatically. Settings take effect after clicking Start / Apply."
    UiStart := "Start / Apply"
    UiPause := "Pause"
    UiExit := "Exit"
    UiPaused := "Status: paused"
    UiRunning := "Status: running"
    UiDirty := "Status: running (settings not applied)"
    UiNeedHotkey := "Set at least one key for Unicode or GBK input."
    UiDuplicate := "Unicode normal input and GBK-compatible input cannot use the same shortcut."
    UiBindFailed := "Failed to register the hotkey. Choose another key and try again."
    UiSettingsSaved := "Settings saved"
    CopyMsg := "Copied!"
}

; ========== Main GUI ==========
unicodeModifierIndex := GetModifierIndex(unicodeModifier)
gbkModifierIndex := GetModifierIndex(gbkModifier)
autoSwitchChecked := (AutoSwitchKana = "true") ? "Checked" : ""

Gui, Main:New, +Resize +MinSize720x600 -MaximizeBox, %UiTitle%
Gui, Main:Color, F7F8FA
Gui, Main:Font, s16 Bold, Microsoft YaHei UI
Gui, Main:Add, Text, xm ym, InputBoxForGame
Gui, Main:Font, s10 Bold cC00000, Microsoft YaHei UI
Gui, Main:Add, Text, xm y+18, %UiDisclaimerTitle%
Gui, Main:Font, s9 Norm c202020, Microsoft YaHei UI
Gui, Main:Add, Edit, xm y+6 w720 h96 ReadOnly -E0x200 BackgroundFFF4F4 vDisclaimerText, %UiDisclaimer%
Gui, Main:Font, s10 Bold c202020, Microsoft YaHei UI
Gui, Main:Add, GroupBox, xm y+16 w720 h205 Section vHotkeyGroupBox, %UiHotkeyGroup%
Gui, Main:Add, Text, xs+18 ys+32 w120, %UiFunction%
Gui, Main:Add, Text, xs+150 ys+32 w120, %UiModifier%
Gui, Main:Add, Text, xs+290 ys+32 w230, %UiKey%
Gui, Main:Font, s9 Norm c202020, Microsoft YaHei UI
Gui, Main:Add, Text, xs+18 ys+66 w120, %UiUnicode%
Gui, Main:Add, DropDownList, xs+150 ys+62 w120 vUnicodeModifier Choose%unicodeModifierIndex%, None|Shift|Ctrl|Alt
Gui, Main:Add, Hotkey, xs+290 ys+62 w230 vUnicodeKey gUnicodeHotkeyChanged, %unicodeKey%
Gui, Main:Add, Text, xs+18 ys+104 w120, %UiGBK%
Gui, Main:Add, DropDownList, xs+150 ys+100 w120 vGBKModifier Choose%gbkModifierIndex%, None|Shift|Ctrl|Alt
Gui, Main:Add, Hotkey, xs+290 ys+100 w230 vGBKKey gGBKHotkeyChanged, %gbkKey%
Gui, Main:Add, Checkbox, xs+18 ys+142 vAutoSwitchKana %autoSwitchChecked% gRunningOptionChanged, %UiAutoIME%
Gui, Main:Add, Text, xs+18 ys+176 w120, %UiIMEName%
Gui, Main:Add, Edit, xs+150 ys+172 w370 vIMEName, %IMEName%
Gui, Main:Font, s9 Norm c555555, Microsoft YaHei UI
Gui, Main:Add, Text, xm y+14 w720 vHelpText, %UiCaptureHelp%
Gui, Main:Font, s10 Norm c202020, Microsoft YaHei UI
Gui, Main:Add, Text, xm y+14 w250 vStatusText cA33A00, %UiPaused%
Gui, Main:Add, Button, x+10 yp-7 w150 h34 Default vStartButton gStartApp, %UiStart%
Gui, Main:Add, Button, x+10 yp w120 h34 vPauseButton gPauseApp Disabled, %UiPause%
Gui, Main:Add, Button, x+10 yp w90 h34 vExitButton gExitApplication, %UiExit%
Gui, Main:Show, w760 h700 Center, %UiTitle%
Gui, Main:+LastFound
MainHwnd := WinExist()
return

; ========== Main GUI events ==========
UnicodeHotkeyChanged:
    GuiControlGet, capturedHotkey,, UnicodeKey
    ParseHotkey(capturedHotkey, capturedModifier, capturedKey)
    if (capturedModifier != "None")
        GuiControl, Main:ChooseString, UnicodeModifier, %capturedModifier%
    if (capturedKey != "")
        GuiControl, Main:, UnicodeKey, %capturedKey%
    if (Running)
        GuiControl, Main:, StatusText, %UiDirty%
return

GBKHotkeyChanged:
    GuiControlGet, capturedHotkey,, GBKKey
    ParseHotkey(capturedHotkey, capturedModifier, capturedKey)
    if (capturedModifier != "None")
        GuiControl, Main:ChooseString, GBKModifier, %capturedModifier%
    if (capturedKey != "")
        GuiControl, Main:, GBKKey, %capturedKey%
    if (Running)
        GuiControl, Main:, StatusText, %UiDirty%
return

RunningOptionChanged:
    GuiControlGet, AutoSwitchKana,, AutoSwitchKana
    if (Running)
        GuiControl, Main:, StatusText, %UiDirty%
return

StartApp:
    Gui, Main:Submit, NoHide
    unicodeHotkeyCombined := BuildHotkey(UnicodeModifier, UnicodeKey)
    gbkHotkeyCombined := BuildHotkey(GBKModifier, GBKKey)

    if (unicodeHotkeyCombined = "" && gbkHotkeyCombined = "") {
        MsgBox, 48, %UiTitle%, %UiNeedHotkey%
        return
    }
    if (unicodeHotkeyCombined != "" && unicodeHotkeyCombined = gbkHotkeyCombined) {
        MsgBox, 48, %UiTitle%, %UiDuplicate%
        return
    }

    Gosub UnbindHotkeys
    if (unicodeHotkeyCombined != "") {
        ErrorLevel := 0
        Hotkey, %unicodeHotkeyCombined%, DoActionUnicode, UseErrorLevel
        if ErrorLevel {
            Gosub UnbindHotkeys
            MsgBox, 48, %UiTitle%, %UiBindFailed%
            return
        }
        BoundUnicodeHotkey := unicodeHotkeyCombined
    }
    if (gbkHotkeyCombined != "") {
        ErrorLevel := 0
        Hotkey, %gbkHotkeyCombined%, DoActionGBK, UseErrorLevel
        if ErrorLevel {
            Gosub UnbindHotkeys
            MsgBox, 48, %UiTitle%, %UiBindFailed%
            return
        }
        BoundGBKHotkey := gbkHotkeyCombined
    }

    Running := true
    Gosub SaveSettings
    GuiControl, Main:Disable, StartButton
    GuiControl, Main:Enable, PauseButton
    GuiControl, Main:, StatusText, %UiRunning%
    ToolTip, %UiSettingsSaved%
    SetTimer, ClearToolTip, -1200
return

PauseApp:
    Gosub UnbindHotkeys
    Running := false
    GuiControl, Main:Enable, StartButton
    GuiControl, Main:Disable, PauseButton
    GuiControl, Main:, StatusText, %UiPaused%
return

SaveSettings:
    Gui, Main:Submit, NoHide
    unicodeHotkeyCombined := BuildHotkey(UnicodeModifier, UnicodeKey)
    gbkHotkeyCombined := BuildHotkey(GBKModifier, GBKKey)
    autoSwitchValue := (AutoSwitchKana = 1 || AutoSwitchKana = "true") ? "true" : "false"

    IniWrite, %unicodeHotkeyCombined%, %settingsFile%, Hotkey, Key
    IniWrite, %gbkHotkeyCombined%, %settingsFile%, Hotkey, GBKKey
    IniWrite, %autoSwitchValue%, %settingsFile%, IME, AutoSwitchKana
    IniWrite, %IMEName%, %settingsFile%, IME, IMEName
return

UnbindHotkeys:
    if (BoundUnicodeHotkey != "") {
        ErrorLevel := 0
        Hotkey, %BoundUnicodeHotkey%, Off, UseErrorLevel
        BoundUnicodeHotkey := ""
    }
    if (BoundGBKHotkey != "") {
        ErrorLevel := 0
        Hotkey, %BoundGBKHotkey%, Off, UseErrorLevel
        BoundGBKHotkey := ""
    }
return

ClearToolTip:
    ToolTip
return

MainGuiSize:
    if (A_Gui != "Main")
        return
    contentWidth := A_GuiWidth - 40
    if (contentWidth < 680)
        contentWidth := 680
    GuiControl, Main:Move, DisclaimerText, w%contentWidth%
    GuiControlGet, groupPos, Pos, HotkeyGroupBox
    groupHeight := A_GuiHeight - groupPosY - 125
    if (groupHeight < 205)
        groupHeight := 205
    GuiControl, Main:Move, HotkeyGroupBox, w%contentWidth% h%groupHeight%
    keyWidth := contentWidth - 308
    if (keyWidth < 160)
        keyWidth := 160
    GuiControl, Main:Move, UnicodeKey, w%keyWidth%
    GuiControl, Main:Move, GBKKey, w%keyWidth%
    helpY := groupPosY + groupHeight + 10
    GuiControl, Main:Move, HelpText, x20 y%helpY% w%contentWidth%
    buttonY := A_GuiHeight - 55
    statusY := buttonY + 7
    startX := A_GuiWidth - 400
    if (startX < 280)
        startX := 280
    pauseX := startX + 160
    exitX := startX + 290
    GuiControl, Main:Move, StatusText, x20 y%statusY% w250
    GuiControl, Main:Move, StartButton, x%startX% y%buttonY% w150 h34
    GuiControl, Main:Move, PauseButton, x%pauseX% y%buttonY% w120 h34
    GuiControl, Main:Move, ExitButton, x%exitX% y%buttonY% w90 h34
return

MainGuiClose:
ExitApplication:
    Gosub UnbindHotkeys
    ExitApp
return

; ========== Input hotkey handlers ==========
DoActionUnicode:
    if (!Running)
        return
    if (MainHwnd != "" && WinActive("ahk_id " . MainHwnd))
        return
    CopyMode := "Unicode"
    Gosub DoAction
return

DoActionGBK:
    if (!Running)
        return
    if (MainHwnd != "" && WinActive("ahk_id " . MainHwnd))
        return
    CopyMode := "GBK"
    Gosub DoAction
return

; ========== Shared input window ==========
DoAction:
    hWnd := WinActive("A")
    targetIMEName := ""
    targetIMEStateValid := false
    targetOpenStatus := 0
    targetConversionMode := 0
    targetSentenceMode := 0
    if (AutoSwitchKana = "true" && hWnd) {
        targetIMEName := GetIMEName(hWnd)
        if (targetIMEName != "" && IMEName != "" && InStr(targetIMEName, IMEName) > 0)
            targetIMEStateValid := GetIMEContextState(hWnd, targetOpenStatus, targetConversionMode, targetSentenceMode)
    }

    Gui, Input:New, +AlwaysOnTop, InputText
    Gui, Input:Font, s11, Microsoft YaHei UI
    Gui, Input:Add, Edit, vInputText w420 h120 -WantReturn
    Gui, Input:Add, Button, Default Hidden, &Submit
    Gui, Input:Show, w450, InputText
    GuiControl, Input:Focus, InputText

    if (targetIMEStateValid) {
        WinWaitActive, InputText, , 2
        ControlGet, hEdit, Hwnd, , Edit1, InputText
        if (!hEdit)
            hEdit := WinExist("InputText")
        if (hEdit) {
            SetIMEContextState(hEdit, targetOpenStatus, targetConversionMode, targetSentenceMode)
            Sleep, 180
            SetIMEContextState(hEdit, targetOpenStatus, targetConversionMode, targetSentenceMode)
        }
    }
return

InputButtonSubmit:
    Gui, Input:Submit, NoHide
    if (CopyMode = "GBK") {
        SetGBKClipboard(InputText)
    } else {
        Clipboard := InputText
    }
    Gui, Input:Destroy

    if WinExist("ahk_id " . hWnd) {
        WinActivate, ahk_id %hWnd%
        WinWaitActive, ahk_id %hWnd%, , 2
        Sleep, 200
    }
    SendInput ^v
    Sleep, 50
    SendInput {Enter}

    ToolTip, %CopyMsg%
    Sleep 500
    ToolTip
return

InputGuiClose:
InputGuiEscape:
    Gui, Input:Destroy
    if WinExist("ahk_id " . hWnd)
        WinActivate, ahk_id %hWnd%
return

; ========== Helpers ==========
GetModifierIndex(modifier) {
    if (modifier = "Shift")
        return 2
    if (modifier = "Ctrl")
        return 3
    if (modifier = "Alt")
        return 4
    return 1
}

GetModifierPrefix(modifier) {
    if (modifier = "Shift")
        return "+"
    if (modifier = "Ctrl")
        return "^"
    if (modifier = "Alt")
        return "!"
    return ""
}

BuildHotkey(modifier, key) {
    key := Trim(key)
    if (key = "")
        return ""
    return GetModifierPrefix(modifier) . key
}

BuildSendKey(modifier, key) {
    key := Trim(key)
    if (key = "")
        return ""
    baseKey := (StrLen(key) = 1) ? key : "{" . key . "}"
    return GetModifierPrefix(modifier) . baseKey
}

ParseHotkey(hotkey, ByRef modifier, ByRef key) {
    modifier := "None"
    key := Trim(hotkey)
    if (key = "")
        return

    prefixes := ""
    while (StrLen(key) > 0) {
        firstChar := SubStr(key, 1, 1)
        if (firstChar != "^" && firstChar != "!" && firstChar != "+")
            break
        prefixes .= firstChar
        key := SubStr(key, 2)
    }

    if (InStr(prefixes, "^"))
        modifier := "Ctrl"
    else if (InStr(prefixes, "!"))
        modifier := "Alt"
    else if (InStr(prefixes, "+"))
        modifier := "Shift"

    key := Trim(key)
    if RegExMatch(key, "i)^(Ctrl|Control)\s*\+\s*(.+)$", match) {
        modifier := "Ctrl"
        key := Trim(match2)
    } else if RegExMatch(key, "i)^(Alt)\s*\+\s*(.+)$", match) {
        modifier := "Alt"
        key := Trim(match2)
    } else if RegExMatch(key, "i)^(Shift)\s*\+\s*(.+)$", match) {
        modifier := "Shift"
        key := Trim(match2)
    }

    if RegExMatch(key, "^\{(.+)\}$", match)
        key := match1
}

GetIMEContextState(hWnd, ByRef openStatus, ByRef conversionMode, ByRef sentenceMode) {
    hIMC := DllCall("ImmGetContext", "Ptr", hWnd, "Ptr")
    if (!hIMC)
        return false
    openStatus := DllCall("ImmGetOpenStatus", "Ptr", hIMC, "Int")
    conversionMode := 0
    sentenceMode := 0
    success := DllCall("ImmGetConversionStatus", "Ptr", hIMC, "UInt*", conversionMode, "UInt*", sentenceMode, "Int")
    DllCall("ImmReleaseContext", "Ptr", hWnd, "Ptr", hIMC)
    return success
}

SetIMEContextState(hWnd, openStatus, conversionMode, sentenceMode) {
    hIMC := DllCall("ImmGetContext", "Ptr", hWnd, "Ptr")
    if (!hIMC)
        return false
    DllCall("ImmSetOpenStatus", "Ptr", hIMC, "Int", openStatus ? 1 : 0)
    DllCall("ImmSetConversionStatus", "Ptr", hIMC, "UInt", conversionMode, "UInt", sentenceMode)
    DllCall("ImmReleaseContext", "Ptr", hWnd, "Ptr", hIMC)
    return true
}

GetIMEName(hWnd := "") {
    if (!hWnd)
        hWnd := WinExist("A")
    if (!hWnd)
        return ""
    hIMC := DllCall("ImmGetContext", "Ptr", hWnd, "Ptr")
    if (!hIMC)
        return ""
    nameLen := DllCall("ImmGetDescription", "Ptr", hIMC, "Ptr", 0, "UInt", 0)
    if (nameLen <= 0) {
        DllCall("ImmReleaseContext", "Ptr", hWnd, "Ptr", hIMC)
        return ""
    }
    VarSetCapacity(name, nameLen + 1)
    DllCall("ImmGetDescription", "Ptr", hIMC, "Str", name, "UInt", nameLen + 1)
    DllCall("ImmReleaseContext", "Ptr", hWnd, "Ptr", hIMC)
    return name
}

; Writes the text as UTF-8 bytes into CF_TEXT, producing the GBK-style
; mojibake expected by games such as Warcraft III.
SetGBKClipboard(text) {
    numBytes := StrPut(text, "UTF-8")
    if (numBytes <= 1)
        return
    VarSetCapacity(buf, numBytes)
    StrPut(text, &buf, numBytes, "UTF-8")

    hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", numBytes, "Ptr")
    if (!hMem)
        return
    pMem := DllCall("GlobalLock", "Ptr", hMem, "Ptr")
    DllCall("RtlMoveMemory", "Ptr", pMem, "Ptr", &buf, "UInt", numBytes)
    DllCall("GlobalUnlock", "Ptr", hMem)

    DllCall("OpenClipboard", "Ptr", 0)
    DllCall("EmptyClipboard")
    DllCall("SetClipboardData", "UInt", 1, "Ptr", hMem)
    DllCall("CloseClipboard")
}
