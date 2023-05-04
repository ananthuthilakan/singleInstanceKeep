;{========[do not relaunch the script as another instance if its already running instead show existing gui]=========================================


;~ author: ananthuthilakan
;~ website: ananthuthilakan.com
;~ github: https://github.com/ananthuthilakan/singleInstanceKeep
;~ do not relaunch the script as another instance if its already running 

;~ use case 
;~ prevent data loss
;~ singleinstance force fails sometimes
;~ singleinstance off creates multiple instances

;~ how to use 
;~ Add #SingleInstance Off
;~ Call the function keep1stinstance() immediatly after gui, show , Hide ; optional variable is gui name e.g keep1stinstance("testgui")
;~ example script 

/*
#include keep1stinstance.ahk
#SingleInstance Off
gui,testgui: add, button ,, ok
gui,testgui: show , hide w400 h400 ,testtitle
keep1stinstance("testgui")
return

testguiguiClose:  ; dont forget to add this 
exitapp
*/

;==================================================================================================================================================




keep1stinstance(guiname:="1"){
iniRead,winid,windowid.ini,winid,winid
TargetScriptTitle := "ahk_id" . winid
StringToSend:="alreadyExist" ; just in case you want to send any data to 1st instance and do something based on that
result := Send_WM_COPYDATA(StringToSend, TargetScriptTitle)
if (result=1){
;~ msgbox, already exist  `n it will show the already existing instance 
exitapp
return
}
OnMessage(0x004A, "Receive_WM_COPYDATA")
showgui1stinstance(guiname)
Gui,%guiname% : +LastFound
WinGet,winid, ID, A
;~ msgbox, % winid
iniwrite,%winid%,windowid.ini,winid,winid
}

showgui1stinstance(guiname:=""){
static guiname1
if (guiname)
guiname1:= guiname
gui,%guiname1% : show
}

Receive_WM_COPYDATA(wParam, lParam)
{
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
   Global recieved_message := StrGet(StringAddress)  ; Copy the string out of the 
  showgui1stinstance()
    return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
}

Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)  ; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    TimeOutTime := 4000  ; Optional. Milliseconds to wait for response from receiver.ahk. Default is 5000
    ; Must use SendMessage not PostMessage.
    SendMessage, 0x004A, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, %TimeOutTime% ; 0x004A is WM_COPYDATA.
    DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
    SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
    return ErrorLevel  ; Return SendMessage's reply back to our caller.
}

;}===================================================================================================================================
