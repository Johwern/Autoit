#include <C:\Program Files (x86)\AutoIt3\Include\Misc.au3>
#include <C:\Program Files (x86)\AutoIt3\Include\MsgBoxConstants.au3>
#include <C:\Program Files (x86)\AutoIt3\Include\AutoItConstants.au3>
Local $hDLL = DllOpen("user32.dll")

$toggle = 0
$thekey = 0

SplashTextOn("Information", "Press the key you want to use for activation", -1, -1, -1, -1, $DLG_TEXTLEFT, "")
Sleep(500)

While $thekey = 0
    Sleep(50)
    For $iX = 1 To 254
        If _IsPressed(Hex($iX), $hDLL) and not _IsPressed("01", $hDLL) Then
            ConsoleWrite("0x" & Hex($iX, 2) & @LF)
			$thekey = Hex($iX, 2)
        EndIf
	 Next
	  if Not $thekey = 0 Then
		 SplashOff ()
		 MsgBox(0,"","Slected key is 0x" & $thekey)
		 ExitLoop
	  EndIf
 WEnd
       Local $sAnswer = _MLInputBox("Type Text", "", "", "", - 1, -1, 0, 0)

while 1

   Sleep(50)
 ;  Sleep(Random(0,100))
   If _IsPressed($thekey, $hDLL) Then

	  if  $toggle = 1 Then
		 $toggle = 0
		 $sAnswer = _MLInputBox("Type Text", "", "", "", - 1, -1, 0, 0)
		 MsgBox(0,"","Prepared",0.5)
	  Else
		  $toggle = 1
		  send($sAnswer)
		  MsgBox(0,"","Sent",1)

	   EndIf
	   ConsoleWrite($toggle)
	   Sleep(500)
   EndIf
wEnd

Func _MLInputBox($title, $prompt, $Default = "", $width = 0, $height = 0, $left = Default, $top = Default, $timeOut = 0, $hWnd = 0)
    Local $OnEventMode = Opt('GUIOnEventMode', 0)
    Local $text = ""
    If $width < 400 Then $width = 400
    If $height < 330 Then $height = 330
    Local $widthAddition = $width-400
    Local $heightAddition = $height-330
    Local $error = 0
    Local $hGui = GUICreate($title, $width, $height, $left, $top, 0x00C00000+0x00080000,0,$hWnd)
    If @error Then
        $error = 3
    Else
        GUICtrlCreateLabel($prompt, 5, 5, 390, 90)
        If @error Then $error = 3
        Local $Edit = GUICtrlCreateEdit($Default, 5, 105, 390+$widthAddition, 190+$heightAddition)
        If @error Then $error = 3
        Local $hOK = GUICtrlCreateButton('&OK', 70, 300+$heightAddition, 80, 25)
        If @error Then $error = 3
        Local $htime = GUICtrlCreateLabel('', 170, 305+$heightAddition, 50, 20)
        If @error Then $error = 3
        Local $hCancel = GUICtrlCreateButton('&Cancel', 230, 300+$heightAddition, 80, 25)
        If @error Then $error = 3
        GUISetState(@SW_SHOW, $hGui)
        If @error Then $error = 3
        Local $timer = TimerInit(), $s1, $s2, $msg
        Do
            $msg = GUIGetMsg(1)
            If $msg[1] = $hGui Then
            Switch $msg[0]
                Case 0xFFFFFFFD, $hCancel ; 0xFFFFFFFD = $GUI_EVENT_CLOSE
                    $error = 1
                    ExitLoop
                Case $hOK
                    ExitLoop
            EndSwitch
            EndIf


            If $timeOut > 0 And TimerDiff($timer) >= $timeOut Then $error = 2
            $s1 = Round(($timeOut - TimerDiff($timer)) / 1000)
            If $timeOut And $s1 <> $s2 Then
                GUICtrlSetData($htime, $s1 & "s")
                $s2 = $s1
            EndIf
        Until $error

        If Not $error Then $text = GUICtrlRead($Edit)
        GUIDelete($hGui)
        Opt('GUIOnEventMode', $OnEventMode)
    EndIf
    SetError($error)
    Return $text
EndFunc   ;==>_MLInputBox