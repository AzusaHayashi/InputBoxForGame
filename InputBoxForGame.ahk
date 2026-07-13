#SingleInstance, Force

; ========== Customize ==========
; 读取 Unicode 复制热键（默认 Ctrl+Alt+i）
IniRead, hotkeyKey, settings.ini, Hotkey, Key, ^!i
; 读取 “UTF-8当作GBK解码” 复制热键（默认 Shift+b）
IniRead, gbkHotkey, settings.ini, Hotkey, GBKKey, +b

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

; 为两种复制模式分别绑定热键（使用读取到的变量）
Hotkey, %hotkeyKey%, DoActionUnicode
Hotkey, %gbkHotkey%, DoActionGBK
return

; ---------- 热键处理 ----------
DoActionUnicode:
    CopyMode := "Unicode"
    Gosub DoAction
return

DoActionGBK:
    CopyMode := "GBK"
    Gosub DoAction
return

; ---------- 共用输入框 ----------
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
    if (CopyMode = "GBK") {
        ; 将输入文本转为 UTF-8 字节，再按 GBK 解码为乱码字符串
        Clipboard := UTF8toGBKString(InputText)
    } else {
        Clipboard := InputText
    }
    Gui, Destroy
    ToolTip, %CopyMsg%
    Sleep 500
    ToolTip
    if WinExist("ahk_id " . hWnd)
        WinActivate, ahk_id %hWnd%
    Send ^v
    Sleep 100
    Send Enter
return

GuiClose:
GuiEscape:
    Gui, Destroy
    if WinExist("ahk_id " . hWnd)
        WinActivate, ahk_id %hWnd%
return

; ---------- 辅助函数：将文本先转 UTF-8 字节，再按 GBK(CP936) 解码成字符串 ----------
UTF8toGBKString(text) {
    ; 1. 将文本转换为 UTF-8 字节（含终止符）
    numBytes := StrPut(text, "UTF-8")
    if (numBytes <= 1) {
        return ""   ; 空文本直接返回
    }
    VarSetCapacity(buf, numBytes)
    StrPut(text, &buf, numBytes, "UTF-8")
    
    ; 2. 将这些字节按 CP936(GBK) 解码为字符串
    ;    如果字节数为奇数，StrGet 会自动处理（可能丢弃最后一个不完整字符）
    ;    对于纯中文（每个汉字3字节，偶数个汉字即为偶数字节）不会丢字
    return StrGet(&buf, "CP936")
}