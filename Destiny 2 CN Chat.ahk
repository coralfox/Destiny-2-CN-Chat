screenWidth=1920
screenHeight=1080

/*
- Windows 10 with high DPI display mast get the value of 'Change the size of text, apps, and other items', you can find it in above:
    1. Right-click anywhere on the Desktop
    1. Select __Display Settings__ from the menu, You will see it
    1. Edit Initialization.ahk to change the value after TAOsize= to the corresponding number (without the % sign)

    拥有高 DPI 显示设备的 Windows 10 系统需要获得 “更改文本、应用和其他项目的大小” 的值，你可以在这里找到它：
    1. 在桌面空白地方点击桌面
    1. 从菜单中选择"显示设置“，你会在界面中看到这个选项
    1. 编辑 Initialization.ahk，将 TAOsize= 后面的值改为对应数字（不带 % 号）
*/
TAOsize=120

; Do not change the following
; 不要改变以下内容
; Chat word limit 聊天字数限制
chatboxMaxLength=100

Gosub, SetDefaultState


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force

; #Include, Initialization.ahk
ResolutionAdaptation("screenWidth","screenHeight")

Menu, tray, NoStandard
Menu, tray, add, 重置 | Reload, ReloadScrit
Menu, tray, add, 暂停 | Pause, PauseScrit
Menu, tray, add
Menu, tray, add, 帮助 | Help, Help
Menu, tray, add, 更新 | Ver %ver%, UpdateScrit
Menu, tray, add, 退出 | Exit, ExitScrit

Gui, +ToolWindow -Caption +AlwaysOnTop -DPIScale
Gui, Color, %bGColor%
gui, font, s12 cffffff
Gui, Color, ,000000
Gui, Add, Edit, x0 y0 w%chatboxW% h25 vchatBox Limit140
gui, font

;SetTimer, battleModeCheck, 200

Return
/*
battleModeCheck:
	If WinActive("ahk_exe destiny2.exe")
    {
        DllCall("SendMessage", "UInt", (WinActive("ahk_exe destiny2.exe")), "UInt", "80", "UInt", "1", "UInt", (DllCall("LoadKeyboardLayout", "Str", "00000804", "UInt", "257")))
	}
	
	If WinExist("ChatBoxTitle") && !WinActive("ChatBoxTitle")
	{
		WinActive("ChatBoxTitle")
		Gui Cancel
	}

	If !WinActive("ahk_exe destiny2.exe") && (rDown=1)
	{
		Send, {RButton Up}
		rDown=0
	}
Return
*/
#IfWinActive, ahk_exe destiny2.exe
    Enter::
        inputState:=inputState=1?0:1
        inBattle:=0
        ;Send, {Enter}
        If (inputState=1) && (consoleMode=0)
        {
            Gui, Show, w%chatBoxW% h25 x%chatBoxX% y%chatBoxY%, %title%
            WinSet, TransColor, %bGColor% %transparency%, %title%
        }
    Return

    /::
        inputState:=inputState=1?0:1
        inBattle:=0
        ;Send, {Enter}
        If (inputState=1) && (consoleMode=0)
        {
            Gui, Show, w%chatBoxW% h25 x%chatBoxX% y%chatBoxY%, %title%
            WinSet, TransColor, %bGColor% %transparency%, %title%
            Send, {text}/
        }
    Return

    Esc::
        normalButton("Esc")
        inputState:=0
        consoleMode:=0
        gameUI:=0
        heroUI:=0
        mapsUI:=0
        itemUI:=0
        ;inBattle:=0
    Return
/*
    f1::
    FastWord("f1","救救我_(:з」/_")
    Return
*/
    f2::
    FastWord("f2","233")
    Return

    f3::
    FastWord("f3","谢谢 (*^з^*)")
    Return

    f4::
    FastWord("f4","你们看我NB吗-_,-")
    Return

    f5::
    FastWord("f5","膨胀了膨胀了，快回来")
    Return

    f6::
    FastWord("f6","666")
    Return

    f11::
        normalButton("f2")
        consoleMode:=consoleMode=1?0:1
        inputState:=1
    Return
#IfWinActive

#IfWinActive, ChatBoxTitle
    Enter::
    Gui Submit
    ;Gui, Show, Hide
    WinWaitActive, ahk_exe destiny2.exe

    If (chatBox!="")
    {
        ;ReplaceMissingText("chatBox")
        chatBoxLength:= StrLen(chatBox)
        chatBoxCutOff:=chatBoxLength/chatboxMaxLength
        If (chatBoxCutOff>1)
        {
            chatBoxCutOff:= Ceil(chatBoxCutOff)
            
            chatBoxStartPos=1
            Loop, %chatBoxCutOff%
            {
                chatBox%A_Index%:= SubStr(chatBox, chatBoxStartPos, chatboxMaxLength)
                chatBoxStartPos:=chatBoxStartPos+chatboxMaxLength
                chatText=% chatBox%A_Index%
                WinWaitActive, ahk_exe destiny2.exe
				Send, {Enter}
				Sleep, 50
                Send, {Text}%chatText%
                Sleep, 50
                Send, {Enter}
                If (A_Index<chatBoxCutOff)
                {
                    Sleep, 50
                    Send, {Enter}
                }
            }
        }
        Else
        {   
            Send, {Enter}
			Sleep, 50
            Send, {Text}%chatBox%
            Sleep, 50
            Send, {Enter}
        }
     GuiControl, Text, chatBox,
    }
    Else
        ;Send, {Enter}
    GuiControl, Text, chatBox,
    inputState:=0
    Return

    Esc::
        Gui Cancel
        WinWaitActive, ahk_exe destiny2.exe

        ;Send, {Enter}
        ;GuiControl, Text, chatBox,
        inputState:=0
    Return
#IfWinActive

ReloadScrit:
Reload
Return

PauseScrit:
Pause, Toggle, 1
Return

UpdateScrit:
Run, https://github.com/coralfox/Destiny-2-CN-Chat/releases
Return

Help:
Run, https://github.com/coralfox/Destiny-2-CN-Chat
Return

ExitScrit:
ExitApp
Return

normalButton(key)
{
    global
    ;inBattle:=0
    If (item!=1)
        preWeapon:=weapon
    ;weapon:=0
    send, {RButton Up}
    rDown:=0
    Send, {%key% Down}
    KeyWait, %key%
    Send, {%key% Up}
}

/*
ReplaceMissingText(vName)
{
    %vName%:=StrReplace(%vName%, "/time" , A_Hour A_Min)
	%vName%:=StrReplace(%vName%, "," , "`,")
	%vName%:=StrReplace(%vName%, ";" , "`;")
	%vName%:=StrReplace(%vName%, "." , "`.")
    %vName%:=StrReplace(%vName%, "霞" , "侠")
    %vName%:=StrReplace(%vName%, "贤" , "闲")
    %vName%:=StrReplace(%vName%, "腼" , "勉")
    %vName%:=StrReplace(%vName%, "棉" , "绵")
    %vName%:=StrReplace(%vName%, "腆" , "填")
	%vName%:=StrReplace(%vName%, "屌" , "吊")
    %vName%:=StrReplace(%vName%, "艹" , "槽")
    %vName%:=StrReplace(%vName%, "凹" , "奥")
    %vName%:=StrReplace(%vName%, "凸" , "突")
    %vName%:=StrReplace(%vName%, "卧" , "喔")
    %vName%:=StrReplace(%vName%, "桃" , "陶")
}
*/
FastWord(keyName,String)
{
	global
    If (voteUI=0)
    {
        if (A_PriorHotkey <> keyName or A_TimeSincePriorHotkey > 1000)
        {
            inputState:=1
            fastWordStr=%String%
            ;ReplaceMissingText("fastWordStr")
            Send, {Enter}
            Sleep, 100
            Send, {Text}%fastWordStr%
            Sleep, 100
            Send, {Enter}
            inputState:=0
        }
    }
    Else
        Send, {%keyName%}
}

ResolutionAdaptation(width,height)
{
    global

    dpiRatio:=A_ScreenDPI/96
    chatBoxX:=A_ScreenWidth*0.80
    chatBoxY:=A_ScreenHeight*0.805
    chatBoxW:=A_ScreenWidth/dpiRatio*0.2

  
    If (width=1920)
        chatBoxX:=70*dpiRatio*100/TAOsize

    If (height=1080)
    {
        chatBoxW:=480/TAOsize*100
        chatBoxY:=850*dpiRatio*100/TAOsize
    }

    If (width=1366) && (height=768)
    {
        chatBoxW=340
        chatBoxX=50
        chatBoxY=600
    }
    If (width=1360) && (height=768)
    {
        chatBoxW=340
        chatBoxX=50
        chatBoxY=600
    }
    ;ToolTip,%width% %height% %chatBoxW% %chatBoxX% %chatBoxY%
}

SetDefaultState:
ver:=1.0.0
inBattle:=0
item:=0
inputState:=0
gameUI:=0
voteUI:=0
consoleMode:=0
bGColor:="FF00FF"
transparency:=200
title:="ChatBoxTitle"
Return