# InputBoxForGame
Inputting in some games, like war3, vrc, might be difficult sometimes so I decide to vibe code this ahk script.  
By pressing ctrl+alt+i, or any keys you want if you add a settings.ini file, a inputbox will be opened for typing, press enter to copy all text you've inputted.  
And it'll auto paste so you can first open your input box in game.  
I mean, you'd better do that, or this script will trigger "ctrl+v" and "enter".
And better run this in administrator.
That's all.  



BTW the settings.ini file should be like:  
```ini
[Hotkey]
Key = ^!i
GBKKey=+b
```

来点大家想看的东西  
众所周知war3不能粘贴中文，但实际上只要粘贴用GBK显示的UTF-8就可以粘贴了  
# 关于实操这一块
首先是犯下傲慢之罪的需要管理员运行（  
打开游戏里的对话框，然后按下GBK转换功能的热键（默认shift+b）就可以打开能实现这个功能的窗口，在里面打字之后按回车就能自动粘贴并发送了
非常感谢老资历望丶缺提供的思路  
以后可以愉快打界了