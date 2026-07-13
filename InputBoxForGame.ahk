#SingleInstance, Force

; ========== Customize ==========
; Default: Ctrl+Alt+I:
hotkeyKey := "^!i"
; Win+F1:
; hotkeyKey := "#F1"

; Shift+Ctrl+Space:
; hotkeyKey := "+^Space"

; F2:
; hotkeyKey := "F2"

if (A_Language = "0804") {
    Disclaimer := "请仔细阅读以下免责声明：`n`n"
    . "本脚本仅供学习交流使用，用户需自行承担使用风险。`n"
    . "有些游戏的反作弊可能会被该脚本触发。`n"
    . "作者不对任何因使用本脚本导致的后果负责。"

} else if (A_Language = "0411") {
    Disclaimer := "免責事項をよくお読みください：`n`n"
    . "このスクリプトは学習・交流目的のみで提供され、使用に伴うリスクはユーザー自身が負うものとします。`n"
    . "このスクリプトは一部のゲームにおいて、アンチチートシステムが作動する原因となる可能性があります。`n"
    . "作者は本スクリプトの使用により生じたいかなる結果に対しても責任を負いません。"
    
} else {
    Disclaimer := "Please read the following disclaimer carefully:`n`n"
    . "This script is provided for educational and communication purposes only.`n"
    . "Please note that this script may be detected or trigger anti-cheat measures in certain games.`n"
    . "Users assume all risks associated with its use.`n"
    . "The author is not responsible for any consequences arising from the use of this script."
}

CopyMsg := "Copied!"
; =========================================================

MsgBox, %Disclaimer%

Hotkey, %hotkeyKey%, DoAction
return

DoAction:
    hWnd := WinActive("A")
    Gui, New, +AlwaysOnTop, InputText
    Gui, Add, Edit, vInputText w300 h100 -WantReturn
    Gui, Add, Button, Default Hidden, &Submit
    Gui, Show
    GuiControl, Focus, InputText
return

ButtonSubmit:
    Gui, Submit, NoHide
    Clipboard := InputText
    Gui, Destroy
    ToolTip, %CopyMsg%
    Sleep 500
    ToolTip
    if WinExist("ahk_id " . hWnd)
        WinActivate, ahk_id %hWnd%
return

GuiClose:
GuiEscape:
    Gui, Destroy
    if WinExist("ahk_id " . hWnd)
        WinActivate, ahk_id %hWnd%
return