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
- An administrator restart button that requests Windows UAC elevation and relaunches the app with administrator rights.
- A prominent disclaimer at the top of the GUI.
- Automatic Unicode and GBK clipboard modes.
- Optional Japanese IME state preservation when the input window opens.
- A configurable delay, in milliseconds, between finishing the input and the automatic paste.

## Usage

1. Run `InputBoxForGame.exe` or `InputBoxForGame.ahk`.
2. Read the disclaimer shown at the top of the settings window.
3. Click a key field on the right, then press the key you want to use.
4. Select the modifier from the dropdown on the left.
5. Click Start / Apply.
6. Open the text input area in the game, then press the configured shortcut.
7. Type the text, press Enter, and the utility will return to the game and paste it.

Click Pause to unregister the global hotkeys immediately. The settings window can be resized by dragging its borders.

If the game or target window is running as administrator, click `Restart as administrator` in the settings window. Windows will show a UAC prompt, and the app will restart with elevated rights after confirmation. The button is disabled when the app already has administrator access.

## Paste delay

After you press Enter and the utility switches back to the game window, it waits for the configured number of milliseconds before sending `Ctrl+V`. Set that wait in the `Delay before auto-paste (ms)` field on the settings window, between `0` and `10000`; the default is `200`.

Use a larger value when the game takes a while to regain focus, for example on a heavily loaded machine or a game running at a low frame rate. Use `0` to paste as soon as the window is re-activated, which is faster but may paste into the wrong window if the game does not accept focus immediately.

The value is validated when you click Start / Apply; anything that is not an integer in range is rejected, and a broken value found in `settings.ini` falls back to the default.

## Japanese IME behavior

When `RememberIMEState=true`, the utility remembers the IME open state and conversion mode that were active when the input box was last submitted or closed. On the next opening, it restores that remembered state to the new input box.

This is useful when the first input box is manually switched to Japanese input and the desired input state is selected. After that first setup, the state is restored until the utility is closed. Set `RememberIMEState=false` to disable the behavior.

Older configuration files may still contain `AutoSwitchKana`, `KanaToggleKey`, or `IMEName`. `AutoSwitchKana` is read as a compatibility fallback when `RememberIMEState` is missing; the other two keys are ignored.

## GBK-compatible mode

Warcraft III cannot paste Chinese text normally, but it can display UTF-8 bytes when the clipboard is interpreted as GBK. The GBK-compatible mode writes the entered text as UTF-8 bytes into `CF_TEXT`, which produces the expected result in the game.

## Configuration

The GUI writes settings to `settings.ini` next to the executable. A typical file looks like this:

```ini
[Hotkey]
Key=^!i
GBKKey=+b

[IME]
RememberIMEState=true

[Input]
PasteDelay=200
```

The default Unicode shortcut is `Ctrl+Alt+I`. The default GBK-compatible shortcut is `Shift+B`. The default paste delay is `200` milliseconds.

If no `settings.ini` exists, these defaults are used. Existing shortcut values and the paste delay are loaded into the GUI when the program starts. `PasteDelay` must be an integer between `0` and `10000`; a missing, non-numeric, or out-of-range value is replaced by the default.

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

Keep `InputBoxForGame.ahk` saved as UTF-8 with BOM. AutoHotkey v1 reads a BOM-less file as ANSI, and the localized GUI strings then turn into syntax errors at compile time.

## Credits

Thanks to 望丶缺 for the original GBK clipboard idea.
