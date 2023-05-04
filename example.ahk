#SingleInstance Off
#NoEnv
#NoTrayIcon
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


gui,testgui: add, button ,, ok
gui,testgui: show , hide w400 h400 ,testtitle
keep1stinstance("testgui") ; pass the guiname if it has or leave it blank
return


testguiguiClose:
exitapp



