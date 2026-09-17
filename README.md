# InputBoxForGame

A small AutoHotkey v1 utility for games where typing or inputting text is difficult, such as Warcraft III and VRChat. It opens a dedicated input window, copies the entered text, returns to the game, pastes it, and sends Enter.

Run the game and this utility as administrator when required by the game or Windows permissions.

## Disclaimer

This software is provided for educational and communication purposes only. Users assume all risks.

Anti-cheat systems in some games may classify this software as a prohibited tool, which could lead to account bans, feature restrictions, or other consequences. Confirm that the target game allows this type of tool before use. The author is not responsible for any loss or consequence caused by using this software.

## Features

- A resizable settings GUI.
- Custom shortcuts for Unicode normal input and GBK-compatible input.
- Each shortcut has a modifier dropdown with `None`, `Shift`, `Ctrl`, and `Alt`, followed by a key capture field.
- Start and Pause controls. Hotkeys are registered only after clicking Start / Apply.
- A prominent disclaimer at the top of the GUI.
- Automatic Unicode and GBK clipboard modes.
- Optional Japanese IME state preservation when the input window opens.

## Usage

1. Run `InputBoxForGame.exe` or `InputBoxForGame.ahk`.
2. Read the disclaimer shown at the top of the settings window.
3. Click a key field on the right, then press the key you want to use.
4. Select the modifier from the dropdown on the left.
5. Click Start / Apply.
6. Open the text input area in the game, then press the configured shortcut.
7. Type the text, press Enter, and the utility will return to the game and paste it.

Click Pause to unregister the global hotkeys immediately. The settings window can be resized by dragging its borders.

## Japanese IME behavior

When `AutoSwitchKana=true`, the utility reads the current IME open state and conversion mode from the window that was active before the input box opened. It then applies that state to the input box instead of sending a Kana toggle key.

This means the input box should follow whether Japanese input was already enabled, rather than forcing a fixed mode. Set `AutoSwitchKana=false` to disable this behavior. `IMEName` is used for a partial name match and defaults to `Microsoft IME`.

Older configuration files may still contain `KanaToggleKey`. It is no longer used.

## GBK-compatible mode

Warcraft III cannot paste Chinese text normally, but it can display UTF-8 bytes when the clipboard is interpreted as GBK. The GBK-compatible mode writes the entered text as UTF-8 bytes into `CF_TEXT`, which produces the expected result in the game.

## Configuration

The GUI writes settings to `settings.ini` next to the executable. A typical file looks like this:

```ini
[Hotkey]
Key=^!i
GBKKey=+b

[IME]
AutoSwitchKana=true
IMEName=Microsoft IME
```

The default Unicode shortcut is `Ctrl+Alt+I`. The default GBK-compatible shortcut is `Shift+B`.

If no `settings.ini` exists, these defaults are used. Existing shortcut values are loaded into the GUI when the program starts.

## Build

The project is written for AutoHotkey v1.1. Use the official `Ahk2Exe` compiler with the Unicode 64-bit base:

```powershell
D:\AHK\Compiler\Ahk2Exe.exe `
  /in InputBoxForGame.ahk `
  /out InputBoxForGame.exe `
  /base "D:\AHK\Compiler\Unicode 64-bit.bin" `
  /silent verbose
```

`InputBoxForGame.exe` and `settings.ini` are ignored by Git. Release builds are published separately.

## Credits

Thanks to 望丶缺 for the original GBK clipboard idea.
