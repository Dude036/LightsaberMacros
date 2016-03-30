#SingleInstance Force
#UseHook On
#NoEnv  
SendMode Input  

Recording=0
Menu, Tray, Icon, %A_WorkingDir%\stop-blue.ico,0
Menu, Tray, Tip, ScrollLock:Toggle Recording | Pause:Playback | Win+Pause:PlaybackNumtimes | Win+ScrollLock:ExitApp

;ScrollLock::
F1::
	If(Recording=0) {
	Goto, RecordingOn
} Else {
	Goto, RecordingOff
}
Return

RecordingOff:
	Recording=0
	Menu, Tray, Icon, %A_WorkingDir%\stop-blue.ico,0
	UnhookWindowsHookEx(hHookKeybd)
	Exit
Return

RecordingOn:
	Recording=1
	Menu, Tray, Icon, %A_WorkingDir%\recording.ico,0
	Keystrokes=
	LastKey=
	hHookKeybd := SetWindowsHookEx(WH_KEYBOARD_LL:=13, RegisterCallback("Keyboard", "Fast"))
	Exit
Return

				;;;;; Lightsaber KeyInputs ;;;;;;;;
									


F2::
If(Recording=1) {
	Goto, RecordingOff
}
SendInput %Keystrokes%
Return

#Pause::
If(Recording=1) {
	Goto, RecordingOff
}
InputBox, NumRepetitions, Repetitions, Number of Times to Repeat
Loop, %NumRepetitions% {
	SendInput %Keystrokes%
}
Return

F3::												
{
	SendInput 030116				;due date
	Send {Enter}
	SendInput 020916				;bill date
	Send {Enter}
	SendInput 010716				;start date
	Send {Enter}
	SendInput 020616				;end date
	Send {Enter}
		
}
Return

LAlt & F3::												
{
	SendInput 031016				;due date
	Send {Enter}
	SendInput 022216				;bill date
	Send {Enter}
	;Send {Tab}
	;SendInput 31
	SendInput 011516				;start date
	Send {Enter}
	SendInput 021616				;end date
	Send {Enter}
		
}
Return

F7::
{
	SendInput Username
	Send {TAB}
	SendInput password
	Send {Enter}
}
Return

LAlt & F7::
{
	SendInput Username
	Send {TAB}
	SendInput password
	Send {TAB 2}
	Send {Down}
	Send {Enter}
}
Return

F9::
{
	Send {Right 15}
}
Return

First := true

FirstYoda: 
	First := false
	WinActivate, Yoda
	SendInput ^+s
	Send {Down 21}
	Send {Delete}
	SendInput ^v
	Send {down}
	SendInput {Delete}
	SendInput ^v
	SendInput !s
Return

Yoda: 
	WinActivate, Yoda
	Send {Escape 2}
	SendInput ^+s
	Send {Down 21}
	Send {Delete}
	SendInput ^v
	Send {down}
	SendInput {Delete}
	SendInput ^v
	SendInput !s
Return

F10::
{
	if WinExist ("ahk_exe C:\Conservice\Conservice.exe") {
		if (First != false) {
			Goto FirstYoda
		} else {
			Goto Yoda
		}
	} else {
		Run C:\Conservice\Conservice.exe
	}
}
Return

F11::
{
	SendInput 8675309
	send {Enter}
}
Return

F12::
{
	SendInput 198914.99
	send {Enter}
}
Return

RControl & NumpadDiv::
{
	SendInput 2846
	Send {Enter}
}
Return

	
RControl & NumpadMult::
{
	SendInput 1234
	Send {Enter}
}

	;;;;;;;;	ERROR MESSAGES		;;;;;;;;


RControl & NumpadAdd::
{
	Send {Tab 11}
	Send {Enter}
}
Return

RControl & Numpad0::
{
	SendInput ^a
	SendInput [DUPLICATE] -
	Send {Space}
	SendInput ^v
}
Return

RControl & Numpad1::
{
	SendInput ^a
	SendInput [SETUP]
}
Return

RControl & Numpad2::
{
	SendInput ^a
	SendInput [FIX] Address on Bill does not Match Address in YODA
}
Return

RControl & Numpad3::
{
	SendInput ^a
	SendInput [FIX] Add Sewer, Trash
}
Return

RControl & Numpad4::
{
	SendInput ^a
	SendInput [FIX] Blank Vacant Screen
}
Return

RControl & Numpad5::
{
	SendInput ^a
	SendInput [FIX] No Vacant Utilities
}
Return

RControl & Numpad6::
{
	SendInput ^a
	SendInput [FIX] Account Blocked
}
Return

RControl & Numpad7::
{
	SendInput ^a
	SendInput [FIX] Tenant Moved In
}
Return

RControl & Numpad8::
{
	SendInput ^a
	SendInput [FIX] Meter Update
}
Return


RControl & Numpad9::
{
	SendInput ^a
	SendInput [ACTIVATIONS] 
}
Return



#ScrollLock::
ExitApp
Return

; Function called on each keyboard event during macro recording
Keyboard(nCode, wParam, lParam)
{
   Global Keystrokes
   Global LastKey

   ; 
   If !nCode
   {
       ; Get the virtual key code and the scan code from the key event.
       vk:=NumGet(lParam+0,0)
       ; 27 <=> 1B <=> Escape
	   ; 222 <=> DE <=>²
       If ( (vk != 145) && (vk != 19) )  ;Ignore, 145 is ScrollLock and 19 is Pause
       {
           vk0:=HexDigit(vk,0)
           vk1:=HexDigit(vk,1)

           sc:=NumGet(lParam+0,4)
           sc0:=HexDigit(sc,0)
           sc1:=HexDigit(sc,1)
           sc2:=HexDigit(sc,2)

           ext:=NumGet(lParam+0,8)
           If ext & 128
               upDown=Up
           Else
               upDown=Down

           key={vk%vk1%%vk0%sc%sc2%%sc1%%sc0% %upDown%}
           If ( LastKey != key )
           {
               Keystrokes=%Keystrokes%%key%
               LastKey:=key
           }
       }
   }
   Return CallNextHookEx(nCode, wParam, lParam)
}

; Extract an hexadecimal digit from a number
HexDigit( number, position )
{
    If position=0
        number := Mod(number,16)
    Else If position=1
        number := Mod(number//16,16)
    Else If position=2
        number := Mod(number//256,16)

    If number<10
        Return Chr(48+number)

    Return Chr(55+number)
}

SetWindowsHookEx(idHook, pfn)
{
   Return DllCall("SetWindowsHookEx", "int", idHook, "Uint", pfn, "Uint", DllCall("GetModuleHandle", "Uint", 0), "Uint", 0)
}

UnhookWindowsHookEx(hHook)
{
   Return DllCall("UnhookWindowsHookEx", "Uint", hHook)
}

CallNextHookEx(nCode, wParam, lParam, hHook = 0)
{
   Return DllCall("CallNextHookEx", "Uint", hHook, "int", nCode, "Uint", wParam, "Uint", lParam)
}

Unhook:
If Recording=1
    UnhookWindowsHookEx(hHookKeybd)
ExitApp
