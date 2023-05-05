#SingleInstance Off
#NoEnv
#MaxMem 128
SetWorkingDir, %A_ScriptDir%
AutoTrim,Off
SetBatchLines,-1
SetControlDelay,-1
SetWinDelay,-1
ListLines, Off
DetectHiddenWindows, On
SetTitleMatchMode,2
SendMode, Input

#include keep1stinstance.ahk

message:="my message" ; to send an array. convert array into json using  https://github.com/G33kDude/cJson.ahk/releases
gui,testgui: add, button ,, ok
gui,testgui: show , hide w400 h400 ,testtitle
keep1stinstance("testgui",message) ; pass the guiname if it has or leave it blank
return


testguiguiClose:
exitapp



