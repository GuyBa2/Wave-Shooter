
.486;for extra instructions like pusha and popa - push all registers and pop all registers
IDEAL
MODEL compact
STACK 500h

SCREEN_WIDTH = 320  
; survivor
SURWIDTH = 1f0h
SURHEIGHT = 1f0h
SURWIDTHNODEC = 31
SURHEIGHTNODEC = 31
SURSPEED = 18h
; Zombies
ZOMWIDTH = 120h
ZOMHEIGHT = 0f0h
ZOMWIDTHNODEC=18
ZOMHEIGHTNODEC=15
ZOMSPEED = 20h
ZOMARRLENGTH=16
;Wave cooldown cycles
WAVECOOL = 80
;background 
BgHeight = 200
BgLength = 320
BgHeightDec=0c80h
BgLengthDec=1400h
;bullet
BULLETLENGTH = 20h;Fixed decimal point
BULLETHEIGHT = 20h;shot is a cube
BulletSpeed = 50h; speed of bullet vector
BulletArrayLength = 16
;
KeyboardInterruptPosition = 9 * 4; in the VIT the keyboard is the 9th and each one is 4 bytes.
;
segment Buffer1
	buffer db BgHeight*BgLength dup(?)
ends Buffer1
DATASEG
BuffToScreenBool db 1
;Cooldowns
	bulletsCoolDown db 0
	ZombiesCoolDown db 0
	WavesCoolDown dw WAVECOOL
;wave text
	WaveFileName db "images\Wave.bmp",0

;waves counter
	WaveNum db ?;six waves: 4 zombies 1 health, 4 zombies 2 health, 8 zombies 1 health, 8 zombies 2 health, 16 zombies 1 health, 16 zombies 2 health.
;background
	BGFileName db "images\bgImg.bmp",0
;win screen&lose screen
	LostFileName db "images\Lost.bmp",0
	WonFileName db "images\Won.bmp",0
;Starting image
	StartFileName db "images\Start.bmp",0

;survivor 
	SurX dw ?
	SurY dw ?
	SurLastX dw ?
	SurLastY dw ?
	;survivor direction 0-31
	SurAngle dw 8
	SurNeedDraw db ?
	SurFileName db "images\surImgs\sur00.bmp",0
	Sur00Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur01Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur02Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur03Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur04Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur05Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur06Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur07Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur08Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur09Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur10Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur11Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur12Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur13Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur14Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur15Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur16Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur17Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur18Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur19Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur20Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur21Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur22Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur23Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur24Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur25Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur26Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur27Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur28Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur29Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur30Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
	Sur31Matrix db SURHEIGHTNODEC*SURWIDTHNODEC dup(?)
;----------------------------Zombies------------------------------
	ZomFileName db "images\ZomImgs\zom0.bmp",0
	Zom00Matrix db ZOMHEIGHTNODEC*ZOMWIDTHNODEC dup(?)
	Zom01Matrix db ZOMHEIGHTNODEC*ZOMWIDTHNODEC dup(?)
	ZomAngleChange db ?;(0-1) after calculating the x&y to add to zombie we also update the angle
	ZombiesCount db ?
	;a byte for activated or not(1/0)
	;a byte for health(0-2)
	;a word for X position 
	;a word for Y position 
	;a byte for angle(0-1)
	Zom1 db 1, 6 dup(?)
	Zom2 db 1, 6 dup(?)
	Zom3 db 1, 6 dup(?)
	Zom4 db 1, 6 dup(?)
	Zom5 db 1, 6 dup(?)
	Zom6 db 1, 6 dup(?)
	Zom7 db 1, 6 dup(?)
	Zom8 db 1, 6 dup(?)
	Zom9 db 1, 6 dup(?)
	Zom10 db 1, 6 dup(?)
	Zom11 db 1, 6 dup(?)
	Zom12 db 1, 6 dup(?)
	Zom13 db 1, 6 dup(?)
	Zom14 db 1, 6 dup(?)
	Zom15 db 1, 6 dup(?)
	Zom16 db 1, 6 dup(?)
;-------Bullets----------
	BulletDrawArray db 0fbh,0fbh
					db 0fbh,0fbh
					
					
					
	;Bullet Array
	
	;bulletsNeedDraw db 1; bool if need to draw bullets to screen 1=false 0=true
;first byte is a bool if the bullet is active, 1 = false, 0 = true
;a word for x position
;a word for y position
;a word for x to add to the bullet each time 
;a word for y to add to the bullet each time 
	Bullet1 db 1, 8 dup(?)
	Bullet2 db 1, 8 dup(?)
	Bullet3 db 1, 8 dup(?)
	Bullet4 db 1, 8 dup(?)
	Bullet5 db 1, 8 dup(?)
	Bullet6 db 1, 8 dup(?)
	Bullet7 db 1, 8 dup(?)
	Bullet8 db 1, 8 dup(?)
	Bullet9 db 1, 8 dup(?)
	Bullet10 db 1, 8 dup(?)
	Bullet11 db 1, 8 dup(?)
	Bullet12 db 1, 8 dup(?)
	Bullet13 db 1, 8 dup(?)
	Bullet14 db 1, 8 dup(?)
	Bullet15 db 1, 8 dup(?)
	Bullet16 db 1, 8 dup(?)
	
	BulletsCount db 0
;relative starting position of bullet depends on suvivor Angle
;a word for how much x to add and a word for how much y to add
	ang00 dw 210h,0bh
	ang01 dw 22h,0e0h
	ang02 dw 23h,?
	ang03 dw ?,?
	ang04 dw ?,?
	ang05 dw ?,?
	ang06 dw ?,?
	ang07 dw ?,?
	ang08 dw ?,?
	ang09 dw ?,?
	ang10 dw ?,?
	ang11 dw ?,?
	ang12 dw ?,?
	ang13 dw ?,?
	ang14 dw ?,?
	ang15 dw ?,?
	ang16 dw ?,?
	ang17 dw ?,?
	ang18 dw ?,?
	ang19 dw ?,?
	ang20 dw ?,?
	ang21 dw ?,?
	ang22 dw ?,?
	ang23 dw ?,?
	ang24 dw ?,?
	ang25 dw ?,?
	ang26 dw ?,?
	ang27 dw ?,?
	ang28 dw ?,?
	ang29 dw ?,?
	ang30 dw ?,?
	ang31 dw ?,?
;mouse shape----------------------------
; Will and screen with first matrix and xor afterwards. 
	MouseShape dw 1111111111111111b
			  dw 1111111111111111b
			  dw 1111111111111111b
			  dw 1111111111111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111000110001111b
			  dw 1111000110001111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111001111111b
			  dw 1111111111111111b
			  dw 1111111111111111b
			  dw 1111111111111111b
			  dw 1111111111111111b
			  
			  
			  dw 0000000000000000b
			  dw 0000000000000000b
			  dw 0000000000000000b
			  dw 0000000000000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000111001110000b
			  dw 0000111001110000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000110000000b
			  dw 0000000000000000b
			  dw 0000000000000000b
			  dw 0000000000000000b
			  dw 0000000000000000b
	
;images-----------------------------------------------------------------------------
	ScrLine 	db SCREEN_WIDTH dup (0)  ; One Color line read buffer
	;BMP File data
	FileHandle	dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	BmpLeft dw ?
	BmpTop dw ?
	BmpWidth dw ?
	BmpHeight dw ?
	BmpFileErrorMsg db 'Error At Opening Bmp File',0dh, 0ah,'$'
	ErrorFile db 0
	;matrix
	matrix dw ?
;---Random----
RndCurrentPos dw ,0
;Keyboard---------------------------------------------------------------------
	;Async Keyboard Variables
	SaveKeyBoardoffset dw ?
	SaveKeyBoardSegment dw ?
	key db ?
	
;bools to represent if each key was pressed
	WPressed db 1;0 when pressed; 1 when released
	SPressed db 1;0 when pressed; 1 when released
	APressed db 1;0 when pressed; 1 when released
	DPressed db 1;0 when pressed; 1 when released

	SpacePressed db 1;0 when pressed; 1 when not pressing
	
	GameOn db 0
CODESEG

    
start: 
	mov ax, @data
	mov ds,ax
	
	call SetGraphic
	call ConvertAllBMPToMatrix
	call SetAsyncMouse
	call SetMouseShape
PlayAgain:
	mov [DPressed],1
	mov [APressed],1
	mov [SPressed],1
	mov [WPressed],1
	mov [byte ptr GameOn],0
	mov [byte ptr WaveNum],6
	
	mov dx,offset StartFileName
	call PrintBackground
	call WaitForSpace
	
	call SetAsyncKeyboard
	
	call ShowCurser
	

	mov dx,offset BGFileName
	call PrintBackground
	mov [word ptr SurX],(BgLengthDec/2)+(SURWIDTH/2)
	mov [word ptr SurY],(BgHeightDec/2)+(SURHEIGHT/2)
	call DrawSur
	mov dx, offset WaveFileName
	mov [word BmpLeft], 0
	mov [word BmpTop], 0
	mov [word BmpWidth], 103
	mov [word BmpHeight], 16
	call OpenShowBmp
	call BuffToScreen
GameLoop:
	cmp [byte ptr GameOn],0
	jnz endGameLose
	cmp [byte ptr ZombiesCount],0
	jnz waveStillGoing
	cmp [WaveNum],0;if all 6 waves are done go to end game win screen
	jz endGameWin
	call startWave
waveStillGoing:
	cmp [ZombiesCoolDown],0
	jnz zombiesOnCooldown
	mov [ZombiesCoolDown],2
	call UpdateActivatedZombies
zombiesOnCooldown:

	call UpdateActivatedBullets
	call CheckAllBulletHitZombies
	call CheckAllZombiesHitSur
	call SurvivorUpdate
	
	cmp [BuffToScreenBool],0
	jnz BuffDosntNeedUpdate
	call BuffToScreen
	mov [BuffToScreenBool],1
BuffDosntNeedUpdate:

	call updateCooldown
	call EqualDelay
jmp GameLoop
endGameLose:
	mov dx,offset LostFileName
	call PrintBackground
	jmp GameEnd
endGameWin:
	mov dx,offset WonFileName
	call PrintBackground
GameEnd:
	call ClearZombies
	call ClearBullets
	call RestoreKeyboardInt
	mov ah, 0
	int 16h
	cmp ah, 39h
	call WaitForSpace
	jz PlayAgain

	call ClearScreen

	mov ah,0
	int 16h
	
	mov ax,2
	int 10h

    mov ax, 4c00h
    int 21h
proc updateCooldown
	cmp [bulletsCoolDown],0
	jz canShoot
	dec [bulletsCoolDown]
canShoot:
	cmp [ZombiesCoolDown],0
	jz canUpdateZombies
	dec [ZombiesCoolDown]
canUpdateZombies:
	ret
endp updateCooldown
;showSurviver- get surviver x and y width and height and angle.
proc DrawSur
	pusha
	mov ax,[SurAngle]
	mov cx,SURWIDTHNODEC*SURHEIGHTNODEC
	mul cx
	mov [matrix],offset Sur00Matrix
	add [matrix],ax
	sub sp, 2
	push SURWIDTH
	call RoundDecPoint
	pop dx
	
	sub sp, 2
	push SURHEIGHT
	call RoundDecPoint
	pop cx
	mov ax,[SurX]
	mov [SurLastX],ax
	mov ax,[SurY]
	mov [SurLastY],ax
	sub sp, 2
	push [word SurX]
	push [word SurY]
	call CalculatePixelPosition
	pop di
	call HideCurser
	call putMatrixInBuffer
	call ShowCurser
	popa
	ret
endp DrawSur

proc UnDrawSur


	push [SurLastX]
	push [SurLastY]
	push SURWIDTH
	push SURHEIGHT
	call BackgroundByPositionAndSize
	ret
endp UnDrawSur
;gets position of Survivor and mouse and return in al which quarter is the mouse is in relation to the survivor.
;input:   Stack: 1.SurX[bp+10] 2.SurY[bp+8] 3.mouseX[bp+6]  4.MouseY[bp+4]
;output: quarter 1-4 in *AL*. 1=right above 2= left above 3= left below 4=right below
proc CalcQuarter
	push bp
	mov bp, sp
	push di
	push Si
	push cx
	push dx

	mov dx,[bp + 10];dx= X survivor
	mov di,[bp + 8];di= Y survivor
	mov cx,[bp + 6];cx= X mouse
	mov si,[bp + 4];si= Y mouse
	
	cmp di, si
	ja @@TargetIsAbove
;TargetIsBleow
	cmp cx, dx
	ja @@TargetIsRight1
;Target Is Left Below
	mov al,3
	jmp @@endproc
@@TargetIsRight1:
;Target Is Right Below
	mov al,4
	jmp @@endproc
@@TargetIsAbove:
	cmp cx, dx
	ja @@TargetIsRightAbove
;Target Is Left Above
	mov al,2
	jmp @@endproc
@@TargetIsRightAbove:
;Target Is Right Above
	mov al,1
	jmp @@endproc
@@endproc:

	
	pop DX
	pop cx
	pop si
	pop di
	pop bp
	ret 8
endp CalcQuarter
;--------move  buffer to screen---------
proc BuffToScreen
	cli
	pusha
	push ds
	call HideCurser
	mov ax,seg buffer
	mov ds,ax
	mov ax,0A000h
	mov es,ax
	mov cx,BgHeight*BgLength
	shr cx,2
	xor si,si
	xor di,di
	rep movsd
	call ShowCurser
	pop ds
	popa
	sti
endp BuffToScreen
;Check keys, update x&y and draw survivor-----------------------------------------------------------------
proc SurvivorUpdate
	push ax
	push dx
	push cx
	push di
	
		
	cmp [APressed], 0
	jnz @@ANotpressed
	mov [SurNeedDraw], 0
	
	call SurMoveLeft
@@ANotpressed:
	
	
	cmp [DPressed], 0
	jnz @@DNotpressed
	mov [SurNeedDraw], 0
	call SurMoveRight
@@DNotpressed:


	cmp [SPressed], 0
	jnz @@SNotpressed
	mov [SurNeedDraw], 0
	
	call SurMoveDown
@@SNotpressed:

	cmp [WPressed], 0
	jnz @@WNotpressed
	mov [SurNeedDraw], 0

	call SurMoveUp
@@WNotpressed:
	cmp [SurNeedDraw], 0
	jz @@draw
	jnz @@NoDraw
@@draw:
	call UnDrawSur
	call DrawSur
	mov [BuffToScreenBool],0
@@NoDraw:
	mov [SurNeedDraw], 1
mov ax,3
	int 33h
	shl cx,3
	shl dx,4
	push [SurX]
	push [SurY]
	push cx
	push dx
	call CalcQuarter
	cmp al,1
	jnz @@NotRightAbove
	mov [SurAngle],28
	jmp @@endproc
@@NotRightAbove:
	cmp al,2
	jnz @@NotLeftAbove
	mov [SurAngle],20
	jmp @@endproc
@@NotLeftAbove:
	cmp al,3
	jnz @@NotLeftBelow
	mov [SurAngle],12
	jmp @@endproc
@@NotLeftBelow:
	cmp al,4
	jnz @@NotRightBelow
	mov [SurAngle],4
	jmp @@endproc
@@NotRightBelow:
@@endproc:
	pop di
	pop cx
	pop dx
	pop ax
	ret
endp SurvivorUpdate
;Mov survivor-----------------------------------------------------------------
;Description: Moves Survivor Up
proc SurMoveUp
	push ax
	mov ax, [SurY]
	sub ax, SURSPEED
	jnc @@Move
	jmp @@endproc
@@Move:
	mov [SurY], ax
@@endproc:
	pop ax
	ret
endp SurMoveUp

proc SurMoveDown
	push ax
	mov ax,[SurY]
	add ax, SURSPEED
	cmp ax, BgHeightDec-SURHEIGHT
	jna @@Move
	jmp @@endproc
@@Move:
	mov [SurY], ax
@@endproc:
	pop ax
	ret
endp SurMoveDown

proc SurMoveRight
	push ax
	mov ax, [SurX]
	add ax, SURSPEED
	cmp ax, BgLengthDec-SURWIDTH
	jb @@Move
	jmp @@endproc
@@Move:
	mov [SurX], ax
@@endproc:
	pop ax
	ret
endp SurMoveRight

proc SurMoveLeft
	push ax
	mov ax,[SurX]
	sub ax, SURSPEED
	jnc @@Move
	jmp @@endproc
@@Move:
	mov [SurX], ax
@@endproc:
	pop ax
	ret
endp SurMoveLeft
;----------------------------------Keyboard- Async---------------------------------------------------------------
;Description:Makes Keyboard Async
;Input: none
;Output: none
proc SetAsyncKeyboard
	push es
	push cx
	push dx
	push ax
	push si
	
	; es=0 the address of the IVT
	xor ax, ax
	mov es, ax
	
	; si point to the address of the Keyboard Interrupt in the IVT
	mov si, KeyboardInterruptPosition
	
	;dx hold the offset of the original interrupt
	mov dx, [es:si]
	;cx hold the segment of the original interrupt
	mov cx, [es:si+2]
	; save the original address
	mov [SaveKeyBoardoffset], dx
	mov [SaveKeyBoardSegment], cx
	
	cli; to prevent problems because we change the IVT
	;change the IVT adress of the interrupt to ours.
	mov ax, offset Keyboard_handler
	mov [word es:si], ax
	mov ax, cs
	mov [word es:si + 2], ax
	sti; set back the interupt flag
	
	pop si
	pop ax
	pop dx
	pop cx
	pop es
	ret
endp SetAsyncKeyboard

;Description: Makes Keyboard interrupt (int 9h) back to defult
proc RestoreKeyboardInt
	push es
	push cx
	push dx
	push ax
	push si
	
	xor ax, ax
	mov es, ax
	
	mov si, KeyboardInterruptPosition
	
	mov dx, [SaveKeyBoardoffset]
	mov cx, [SaveKeyBoardSegment]
	
	cli
	mov [word es:si], dx
	mov [word es:si + 2], cx
	sti
	
	pop si
	pop ax
	pop dx
	pop cx
	pop es
	ret
endp RestoreKeyboardInt


;Description: This procedure is the procedure that happens when key is pressed (int 9h)
;Input: a key from the port
;Output: calls the relevant procedure based on key
proc Keyboard_handler near
	pusha
    ; Gets the pressed key and stores it in [key], 60h is the port of the keyboard, "in" takes the value of the port given
    in al, 60h         
    mov [byte key], al
	
	;send 20h to the port 20h- PIC port, the port that manage interrupts. the value 20h means that the PIC can move to other interrupts
    mov al, 20h
    out 20h, al
	; check W pressed 
	cmp [byte key], 11h
	jnz @@NotW
	mov [WPressed], 0
	jmp @@endproc
@@NotW:
	;check W released
	cmp [byte key], 91h
	jnz @@NotWR
	mov [WPressed], 1
	jmp @@endproc
@@NotWR:
	;check S pressed
	cmp [byte key], 01fh
	jnz @@NotS
	mov [SPressed], 0
	jmp @@endproc
@@NotS:
	;check S released
	cmp [byte key], 09fh
	jnz @@NotSR
	mov [SPressed], 1
	jmp @@endproc
@@NotSR:
	;check A pressed
	cmp [byte key], 1eh
	jnz @@NotA
	mov [APressed], 0
	jmp @@endproc
@@NotA:
	;check A released
	cmp [byte key], 9eh
	jnz @@NotAR
	mov [APressed], 1
	jmp @@endproc
@@NotAR:
	;check D pressed
	cmp [byte key], 20h
	jnz @@NotD
	mov [DPressed], 0
	jmp @@endproc
@@NotD:
	;check D released
	cmp [byte key], 0a0h
	jnz @@NotDR
	mov [DPressed], 1
	jmp @@endproc
@@NotDR:
	;check ESC pressed
	cmp [byte key], 1
	jnz @@NotESC
	mov [GameOn],1
@@NotESC:
	
@@endproc:
	popa
    IRET
endp Keyboard_handler
;----------------------------------Mouse- Async---------------------------------------------------------------
proc SetMouseShape
	pusha
	
	push ds
	pop es
	
	mov dx, offset MouseShape
	mov bx, 8
	mov cx, 8
	mov ax, 9
	int 33h
	
	popa
	ret
endp SetMouseShape
proc ShowCurser
	pusha
	mov ax, 1
	int 33h
	popa
	ret
endp ShowCurser

proc HideCurser
	pusha
	mov ax, 2
	int 33h
	popa
	ret
endp HideCurser

proc SetAsyncMouse
	pusha
	mov ax, seg MouseHandle 
	mov es, ax
	mov dx, offset MouseHandle   ; ES:DX = mouse handle address
    mov ax,0Ch ; set mouse async
    mov cx,03h 
    int 33h
	popa
	ret
endp SetAsyncMouse
proc MouseHandle far
	pusha
	test bx,1
	jz @@UpdateSurAngle
	cmp [bulletsCoolDown],0
	jnz @@endproc
	mov [bulletsCoolDown],7
	mov cx, BulletArrayLength
	mov bx, offset Bullet1
@@FindAndActivate:
	cmp [byte bx], 1
	
	jnz @@ActivatedAlready
	mov si, bx
	
	mov ax, 3
	int 33h
	
	shl cx, 3;fixed decimal
	shl dx, 4;fixed decimal
	
	
	mov ax, [SurX]
	add ax, SURWIDTH / 2
	sub ax, 20h
	push ax
	
	mov ax, [SurY]
	add ax, SURWIDTH / 2
	sub ax, 20h
	push ax
	
	push cx
	
	push dx
	
	push si
	
	call ActivateBullet
	jmp @@endproc
@@ActivatedAlready:
	add bx,9
	loop @@FindAndActivate
	jmp @@endproc

@@UpdateSurAngle:
	
	mov ax,3
	int 33h
	shl cx,3
	shl dx,4
	push [SurX]
	push [SurY]
	push cx
	push dx
	call CalcQuarter
	cmp al,1
	jnz @@NotRightAbove
	mov [SurAngle],28
	jmp @@endproc
@@NotRightAbove:
	cmp al,2
	jnz @@NotLeftAbove
	mov [SurAngle],20
	jmp @@endproc
@@NotLeftAbove:
	cmp al,3
	jnz @@NotLeftBelow
	mov [SurAngle],12
	jmp @@endproc
@@NotLeftBelow:
	cmp al,4
	jnz @@NotRightBelow
	mov [SurAngle],4
	jmp @@endproc
@@NotRightBelow:
@@endproc:
	mov [SurNeedDraw], 0
	popa
	retf
endp MouseHandle

;--------------------print background proc and print a specific part of the background procs----------------------
;input: dx= file name offset
proc PrintBackground
	push dx
	
	mov [word BmpLeft], 0
	mov [word BmpTop], 0
	mov [word BmpWidth], 320
	mov [word BmpHeight], 200
	call OpenShowBmp
	call BuffToScreen
	pop dx
	ret
endp PrintBackground
;Description: Takes a part of the background and puts it on the matching spot in the screen
;Input: Stack: 1.X 2.Y 3.Length 4.Height
;Output: On srceen
proc BackgroundByPositionAndSize
	push bp
	mov bp, sp
	sub sp, 2
	;make room for padding variable
	;[bp - 2] -> Padding
	pusha
	
	sub sp, 2
	push [word bp + 8]
	call RoundDecPoint
	pop [word bp + 8]
	
	sub sp, 2
	push [word bp + 10]
	call RoundDecPoint
	pop [word bp + 10]
	
	
	
	sub sp, 2
	push [word bp + 4]
	call RoundDecPoint
	pop [word bp + 4]
	
	sub sp, 2
	push [word bp + 6]
	call RoundDecPoint
	pop [word bp + 6]
	mov dx, offset BGFileName
	call OpenBmpFile
	;
	mov dx, offset BGFileName
	call ReadBmpHeader
	
	mov dx, offset BGFileName
	call ReadBmpPalette
	
	mov ax,seg buffer
	mov es, ax
	
	
	
	mov ax,BgLength ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov [word bp-2], 0
	jz @@row_ok
	mov [word bp - 2],4
	sub [word bp - 2],dx

@@row_ok:
	mov cx, BgHeight
	sub cx, [bp + 8]
	sub cx, [bp + 4]

	
	
;get to relevent row in file
	mov ax, BgLength
	add ax,[bp - 2]  ; extra  bytes to each row must be divided by 4
	mul cx
	
	mov cx, dx
	mov dx, ax
	
	mov ah,42h
	mov al, 1
	
	
	mov bx, [FileHandle]
	
	int 21h
	
	
@@RowNumberOK:
	
	mov cx, [bp + 4]
	mov dx, [bp + 10]
	
@@NextLine:
	push cx
	push dx
	
	mov di, cx
	add di, [bp + 8]
	
	mov cx, di
	shl cx, 6
	shl di, 8
	add di, cx
	add di, dx
	
	sub di, 320
	
	mov ah,3fh
	mov cx,	BgLength
	add cx, [bp - 2]  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx, [bp + 6]  
	mov si,offset ScrLine
	add si, [bp + 10]
	
	rep movsb ; Copy line to the screen
	
	pop dx
	pop cx
	
	loop @@NextLine
	
	call CloseBmpFile
	
	popa
	add sp, 2
	pop bp
	ret 8
endp BackgroundByPositionAndSize
;------------graphicAndBmp------------------
proc OpenShowBmp  
	mov [ErrorFile],0
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call ShowBMP
	
	 
	call CloseBmpFile

@@ExitProc:
	ret
endp OpenShowBmp
 
 
 
 
; input dx filename to open
proc OpenBmpFile	 near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile
 
 
 



proc CloseBmpFile  near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile




; Read 54 bytes the Header
proc ReadBmpHeader	 near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader



proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette


; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette	 near						
										
	push cx
	push dx
	
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette



proc  SetGraphic near
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp 	SetGraphic

 

 
 
proc ShowBMP  near
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpHeight lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax,seg buffer
	mov es, ax
	
 
	mov ax,[BmpWidth] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	mov bp, 0
	and ax, 3
	jz @@row_ok
	mov bp,4
	sub bp,ax
	
	
@@row_ok:	
	mov cx,[BmpHeight]
    dec cx
	add cx,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di,[BmpLeft]
	cld ; Clear direction flag, for movsb forward
	; rep movsb  = mov [es:di++/--], [ds:si ++/--]
	mov cx, [BmpHeight]
@@NextLine:
	push cx
 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpWidth]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory es:di
	
	mov cx,[BmpWidth]  
	mov si,offset ScrLine
	
;	rep movsb ; Copy line to the screen   mov cx times [es:di], [ds:si] di++ si++
nextPixle:
	cmp [byte ptr ds:si],0fdh
	jz invisible
	movsb
loop nextPixle
	jmp @@finish 
invisible:
	inc si
	inc di
loop nextPixle
@@finish:
	
	sub di,[BmpWidth]            ; return to left bmp
	sub di,SCREEN_WIDTH  ; jump one screen line up
	pop cx
loop @@NextLine
	
	pop cx
	ret
endp ShowBMP
;Description: Clears Screen
proc ClearScreen
	pusha
	
	mov ax, 3h
	int 10h
	
	call SetGraphic
	
	popa
	ret
endp ClearScreen
;----------------------------make bmps matrix----------------------
;Description: Converts all bmp to matrix
proc ConvertAllBMPToMatrix
	pusha
	mov cx,32
	xor ax,ax
	mov bx,offset Sur00Matrix
	add al,'0'
	add ah,'0'
loopSurMatrix:
	push ax
	push cx
	push bx
	mov [SurFileName+18],ah
	mov [SurFileName+19],al
	push offset SurFileName
	push SURWIDTH
	push SURHEIGHT
	push bx
	call ConvertBMPtoMatrix
	pop bx
	pop cx
	pop ax
	add bx,SURWIDTHNODEC*SURHEIGHTNODEC;38*38-survivor matrix length
	cmp al,'9'
	jz increaseAh
	inc al
	jmp @@skip
increaseAh:
	mov al,'0'
	inc ah
@@skip:
loop loopSurMatrix

	mov [byte ZomFileName+18],'1'
	push offset ZomFileName
	push ZOMWIDTH
	push ZOMHEIGHT
	push offset Zom00Matrix
	call ConvertBMPtoMatrix
	mov [byte ZomFileName+18],'3'
	push offset ZomFileName
	push ZOMWIDTH
	push ZOMHEIGHT
	push offset Zom01Matrix
	call ConvertBMPtoMatrix
	popa
	ret
endp ConvertAllBMPToMatrix
;Description: Copies A bmp into a Matrix
;Input: stack: 1. BMP Name offset 2. BMP Length 3. BMP Height 4. Matrix offset
proc ConvertBMPtoMatrix
	push bp
	mov bp, sp
	sub sp, 2
	pusha
		sub sp, 2
	push [word bp + 8]
	call RoundDecPoint
	pop [word bp + 8]
	
	sub sp, 2
	push [word bp + 6]
	call RoundDecPoint
	pop [word bp + 6]
	
	
	
	mov dx, [bp + 10]
	call OpenBmpFile
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	
	mov ax, ds
	mov es, ax
	
	mov ax, [word bp + 8];padding
	xor dx, dx
	mov si, 4
	div si
	cmp dx, 0
	mov [word bp - 2], 0
	jz @@row_ok
	mov [word bp - 2], 4
	sub [word bp - 2], dx
	
@@row_ok:
	
	mov cx, [bp + 6]
	
@@NextRow:
	push cx
	
	
	mov ah, 3fh
	mov cx, [bp + 8]
	add cx, [bp - 2]
	mov dx, offset ScrLine
	int 21h
	
	
	
	
	mov di, [bp + 4]
	
	mov ax, [bp + 6]
	
	mul [word bp + 8]
	
	sub ax, [bp + 8]
	
	add di, ax; di -> start of row
	
	mov si, offset ScrLine
	
	mov cx, [bp + 8]
	rep movsb
	
	dec [word bp + 6]
	pop cx
	loop @@NextRow
	
	
	
	call CloseBmpFile
	
	add sp, 2
	popa
	pop bp
	ret 8
endp ConvertBMPtoMatrix
; in dx how many cols 
; in cx how many rows
; in matrix - the bytes
; in di start byte in screen (0 64000 -1)

proc putMatrixInBuffer
	push es
	push ax
	push si
	
	mov ax,seg buffer
	mov es, ax
	cld
	
	push dx
	mov ax,cx
	mul dx
	mov bp,ax
	pop dx
	
	
	mov si,[matrix]
	
NextRow:	
 	push cx
	
	mov cx, dx
	;rep movsb ; Copy line to the screen
	@@nextPixle:
	cmp [byte ptr ds:si],0fdh
	jz @@invisible
	movsb
loop @@nextPixle
	jmp @@finish 
@@invisible:
	inc si
	inc di
loop @@nextPixle
@@finish:
	sub di,dx
	add di, 320
	
	
	pop cx
	loop NextRow
	
	
endProc:	
	
	pop si
	pop ax
	pop es
    ret
endp putMatrixInBuffer
;----------------Bullets---------------------
;Description: Activates an unactivated bullet
;Input: 1.XStart[bp + 12] 2.YStart[bp + 10] 3.XTarget[bp + 8] 4.YTarget[bp + 6] 5.Bullet offset[bp + 4]
;Output: Changes Bullets attributes
proc ActivateBullet
	push bp
	mov bp, sp
	
	push bx
	push cx
	push dx
	push di
	push si
	
	mov bx, [bp + 4];Bx -> offset Bullet
	
	mov [byte bx], 0
	
	mov cx, [bp + 12]
	mov [word bx + 1], cx
	
	mov si, [bp + 10]
	mov [word bx + 3], si
	
	sub sp, 4
	push [word bx + 1]
	push [word bx + 3]
	push [word bp + 8]
	push [word bp + 6]
	push BulletSpeed
	call XYtoAdd2DotsWithNeg
	inc [BulletsCount]
	
	pop [word bx + 5]
	pop [word bx + 7]
	
	
	
	push bx
	call MoveBullet

@@BulletDead:	
	

	
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop bp
	ret 10
endp ActivateBullet
;Disable all Bullets
proc ClearBullets
	push bx
	push cx
	mov [BulletsCount],0
	mov bx,offset Bullet1
	mov cx,BulletArrayLength
DisNextBullet:
	push Bx
	call UndrawBullet
	mov [byte ptr bx],1
	add bx,9
loop DisNextBullet
	mov [BuffToScreenBool],0
	pop cx
	pop bx
	ret
endp ClearBullets
proc UpdateActivatedBullets
	push bx
	push cx
	push si
	
	mov cx, BulletArrayLength
	mov bx, offset Bullet1
@@UpdateIfActivated:

	cmp [byte bx], 0
	jnz @@NotActive
	push bx
	call UndrawBullet
	push bx
	call MoveBullet
	push bx
	call DrawBullet
	mov [BuffToScreenBool],0
@@NotActive:
	add bx, 9
	loop @@UpdateIfActivated
@@endproc:
	pop si
	pop cx
	pop bx
	ret
endp UpdateActivatedBullets
;update bullet position and check boundries
;Input: offset bullet
;output Bullet X and Bullet Y
proc MoveBullet
	push bp
	mov bp, sp
	push bx
	push cx
	
	
	mov bx, [word bp + 4]
	
	mov cx, [word bx + 5]
	add [word bx + 1], cx;add x
	cmp [word bx + 1], 0h
	jnle @@NotHitLeftWall
	mov [byte bx], 1;bullet hit left wall
	
	mov [word bx + 1], 0
	
	push bx
	call UndrawBullet
	dec [BulletsCount]
	jmp @@EndProc
@@NotHitLeftWall:

	mov cx, [word bx + 1]
	add cx, BULLETHEIGHT
	
	cmp cx, BgLengthDec
	jnae @@NotHitRightWall
	
	mov [byte bx], 1;bullet hit right wall
	mov [word bx + 1], BgLengthDec - BULLETLENGTH
	
	push bx
	call UndrawBullet
	dec [BulletsCount]
	jmp @@EndProc
@@NotHitRightWall:

	
	
	mov cx, [word bx + 7]
	add [bx + 3], cx;add y
	
	cmp [word bx + 3], 0
	jnle @@NotHitUpperWall
	mov [byte bx], 1;bullet hit upper wall
	mov [word bx + 3], 0
	push bx
	call UndrawBullet
	dec [BulletsCount]
	jmp @@EndProc
@@NotHitUpperWall:
	
	mov cx, [word bx + 3]
	add cx, BULLETHEIGHT
	cmp cx, BgHeightDec
	jnae @@NotHitLowerWall
	
	mov [byte bx], 1;bullet hit lower wall
	mov [word bx + 3], BgHeightDec - BULLETHEIGHT
	
	push bx
	call UndrawBullet
	dec [BulletsCount]
	jmp @@EndProc
@@NotHitLowerWall:


@@EndProc:
	
	pop cx
	pop bx
	pop bp
	ret 2
endp MoveBullet
;Input:1.Offset Bullet
proc DrawBullet
	push bp
	mov bp, sp
	pusha
	
	mov bx, [bp + 4]
	cmp [byte bx], 0
	jnz @@endproc
	
	sub sp, 2
	push [Word bx + 1]
	push [Word bx + 3]
	call CalculatePixelPosition
	
	pop di
	
	mov [word matrix], offset BulletDrawArray
	mov dx, BULLETLENGTH
	shr dx, 4
	mov cx, BULLETHEIGHT
	shr cx, 4
	
	call putMatrixInBuffer
	
	;1. DX = Line Length, CX = Amount of Lines, Variable matrix = Offset of the matrix you want to print, DI = Location to Print on screen(0 - 64,000)
@@endproc:
	popa
	pop bp
	ret 2
endp DrawBullet

;input stack 1. offset bullet
proc UndrawBullet
	push bp
	mov bp, sp
	push bx
	
	
	
	mov bx, [bp + 4]
	push [word bx + 1]
	push [word bx + 3]
	push BULLETLENGTH
	push BULLETHEIGHT
	call BackgroundByPositionAndSize
	
	
	pop bx
	pop bp
	ret 2
endp UndrawBullet
proc CheckAllBulletHitZombies
	push bx
	push cx
	push si
	
	mov cx, BulletArrayLength
	mov bx, offset Bullet1
@@checkHit:
	cmp [byte ptr bx], 0
	jnz @@NotActive
	push bx
	call UndrawBullet
	
	push bx 
	call CheckBulletHitZombies
	
	push bx
	call DrawBullet
@@NotActive:
	add bx,9
	loop @@checkHit
@@endproc:
	pop si
	pop cx
	pop bx
	ret
endp CheckAllBulletHitZombies
;input stack offset bullet
proc CheckBulletHitZombies
	push bp
	mov bp,sp
	pusha
	
	mov bx,[bp+4]
	
	mov di,[word bx+1]

	mov dx, [word bx+3]
	
	mov bx,offset Zom1;BX= offset of zombies
	mov di,[bp+4]; di = offset of the bullet
	mov cx,ZOMARRLENGTH
CheckNextZombie:
	cmp [byte ptr bx],0
	jnz @@NextZom
	sub sp, 2;Check Colision
	push [word di + 1]
	push [word di + 3]
	push BULLETLENGTH
	push BULLETHEIGHT
	push [word bx+2]
	push [word bx+4]
	push ZOMWIDTH
	push ZOMHEIGHT
	call CheckCollision
	pop ax
	cmp ax,1
	jz @@NextZom
	push di
	call UndrawBullet
	mov [byte ptr di],1;Deactivate bullet 
	dec [BulletsCount]
	dec [byte ptr bx+1];decrease zombie life by 1
	cmp [byte ptr bx+1],0;check if health=0
	jnz @@endproc
	push bx
	call UnDrawZom
	mov [byte ptr bx],1; Deactivate Zombie
	dec [ZombiesCount]
	jmp @@endproc
@@NextZom:
	add bx,7
loop CheckNextZombie
@@endproc:
	popa
	pop bp
	ret 2
endp CheckBulletHitZombies
;----------------------------------------Zombies---------------------------------------------
proc UpdateActivatedZombies
	pusha
	mov bx,offset Zom1
	mov cx,ZOMARRLENGTH
updateNextZom:
	cmp [byte bx],1
	jz @@notActivated
	push bx
	call UnDrawZom
	sub sp,4
	push [word bx+2]
	push [word bx+4]
	push [word SurX]
	push [word SurY]
	push ZOMSPEED
	call XYtoAdd2DotsWithNeg
	pop ax;x to add to Zombie
	pop dx;y to add to Zombie
	add [bx+2],ax
	add [bx+4],dx
	mov al,[ZomAngleChange]
	mov [bx+6],al
@@notActivated:
	add bx,7
loop updateNextZom
	call drawAllActivatedZombies
	cmp al,0
	jnz @@endproc
	mov [BuffToScreenBool],0
@@endproc:
	popa
	ret
endp UpdateActivatedZombies
;intput [WaveNum]- the number of the current wave
proc startWave
;check if first wave
	cmp[WavesCoolDown],0
	jnz waveOnCool
	cmp[WaveNum],6
	jnz notFirstWave
	push 4
	push 1
	call ZombieWave
	jmp foundWave
notFirstWave:
;check if second wave
	cmp[WaveNum],5
	jnz notSecondWave
	push 4
	push 2
	call ZombieWave
	jmp foundWave
notSecondWave:
;check if third wave
	cmp[WaveNum],4
	jnz notThirdWave
	push 8
	push 1
	call ZombieWave
	jmp foundWave
notThirdWave:
;check if forth wave
	cmp[WaveNum],3
	jnz notForthWave
	push 8
	push 2
	call ZombieWave
	jmp foundWave
notForthWave:
;check if fifth wave
	cmp[WaveNum],2
	jnz notFifthWave
	push 16
	push 1
	call ZombieWave
	jmp foundWave
notFifthWave:
;check if sixth wave
	cmp[WaveNum],1
	jnz @@endproc
	push 16
	push 2
	call ZombieWave	
	jmp foundWave
foundWave:
	dec [WaveNum]
	mov [BuffToScreenBool],0
	mov [WavesCoolDown],WAVECOOL
	push 0
	push 0
	push 670h
	push 100h
	call BackgroundByPositionAndSize
	call BuffToScreen
	jmp @@endproc
waveOnCool:
	cmp [WavesCoolDown],WAVECOOL
	jnz AlreadyDrawWarnImage
	mov dx, offset WaveFileName
	mov [word BmpLeft], 0
	mov [word BmpTop], 0
	mov [word BmpWidth], 103
	mov [word BmpHeight], 16
	call OpenShowBmp
	call BuffToScreen
AlreadyDrawWarnImage:
	dec [WavesCoolDown]

@@endproc:
	ret
endp startWave
;Disable all zombies
proc ClearZombies
	push bx
	push cx
	mov [ZombiesCount],0
	mov bx,offset Zom1
	mov cx,ZOMARRLENGTH
DisNextZom:
	mov [byte ptr bx],1
	add bx,7
loop DisNextZom

	pop cx
	pop bx
	ret
endp ClearZombies
proc CheckAllZombiesHitSur
	pusha
	
	mov bx,offset Zom1;BX= offset of zombies
	mov cx,ZOMARRLENGTH
@@CheckNextZombie:
	cmp [byte ptr bx],0
	jnz @@NextZom
	sub sp, 2
	push [word SurX]
	push [word SurY]
	push SURWIDTH
	push SURHEIGHT
	push [word bx+2]
	push [word bx+4]
	push ZOMWIDTH
	push ZOMHEIGHT
	call CheckCollision
	pop ax
	cmp ax,1
	jz @@NextZom
	mov [GameOn],1
	call UnDrawSur
	jmp @@endproc
@@NextZom:
	add bx,7
loop @@CheckNextZombie
@@endproc:
	popa
	ret 
endp CheckAllZombiesHitSur

;input: 1.number of zombies[bp+6](first wave 4,second wave 8 and last wave 16) 2.Zombies health[bp+4].
proc ZombieWave
	push bp
	mov bp,sp
	pusha
	
	mov bx, offset Zom1
	mov cx,[bp+6];cl = number of zombies
	mov [ZombiesCount],cl
	shr cx,2;every loop 4 zombies, 1 zombie each wall
ActivateNextZombies:
;A zombie on the left wall on a random position
	mov [byte ptr bx],0
	mov ax,[bp+4]; *al* = health of each zombie
	mov [byte ptr bx+1],al
	mov [word ptr bx+2],0
	push bx
	mov bl,0
	mov bh,200-ZOMHEIGHTNODEC
	call RandomByCs
	pop bx
	shl ax,4;add decimal point
	mov [bx+4],ax
	mov [byte ptr bx+6],0;zombie looking right
	
	add bx, 7
	
;A zombie on the right wall on a random position
	mov [byte ptr bx],0
	mov ax,[bp+4]; *al* = health of each zombie
	mov [byte ptr bx+1],al
	mov [word ptr bx+2],BgLengthDec-ZOMWIDTH
	push bx
	mov bl,0
	mov bh,200-ZOMHEIGHTNODEC
	;xor ax,ax
	call RandomByCs
	pop bx
	shl ax,4;add decimal point
	mov [bx+4],ax
	mov [byte ptr bx+6],0
	
	add bx, 7
jmp @@skipjmp
RelativeJumpInRange:
	jmp ActivateNextZombies
@@skipjmp:
;A zombie on the top wall on a random position
	mov [byte ptr bx],0
	mov ax,[bp+4]; *al* = health of each zombie
	mov [byte ptr bx+1],al
	mov [word ptr bx+4],0
	push bx
	mov bl,0
	mov bh,160-ZOMWIDTHNODEC
	;xor ax,ax
	call RandomByCs
	pop bx
	shl ax,5;add decimal point + multiply by 2 so the x position will be up to 320
	mov [bx+2],ax
	mov [byte ptr bx+6],0;zombie looking down
	
	add bx, 7
	
;A zombie on the bottom wall on a random position
	mov [byte ptr bx],0
	mov ax,[bp+4]; *al* = health of each zombie
	mov [byte ptr bx+1],al
	mov [word ptr bx+4],BgHeightDec-ZOMHEIGHT
	push bx
	mov bl,0
	mov bh,160-ZOMWIDTHNODEC
	;xor ax,ax
	call RandomByCs
	pop bx
	shl ax,4;add decimal point + multiply by 2 so the x position will be up to 320
	mov [bx+2],ax
	mov [byte ptr bx+6],1;zombie looking up
	
	add bx, 7
loop RelativeJumpInRange
	popa
	pop bp
	ret 4
endp ZombieWave
;draw all the activaed zombies 
;output: if buffer need update(if there was at least 1 activated zombie) al =0. else al=1
proc drawAllActivatedZombies
	push bx
	push cx
	
	mov al,1
	mov bx,offset Zom1
	mov cx,ZOMARRLENGTH
drawNextZom:
	cmp [byte bx],1
	jz @@notActivated
	xor al,al;buffer need update
	push bx
	call DrawZom
@@notActivated:
	add bx,7
loop drawNextZom

	pop cx
	pop bx
	ret
endp drawAllActivatedZombies
;input: Stack: zombie offset
;output draw a zombi to the buffer
proc DrawZom
	push bp
	mov bp,sp
	pusha
	
;ax = offset of the right zombie matrix angle.
	xor ax,ax
	mov bx, offset Zom00Matrix
	mov di,[bp+4] 
	cmp [byte ptr di],0
	jnz @@endproc
	mov al,[di+6];al = zombie Angle
	mov dx,ZOMWIDTHNODEC*ZOMHEIGHTNODEC
	mul dx
	add bx, ax
	mov [matrix],bx
;di = pixel position (y*320+x]
	sub sp,2
	push [word di+2]
	push [word di+4]
	call CalculatePixelPosition
	pop di
;dx = colums
;cx = rows
	mov dx, ZOMWIDTHNODEC
	mov cx, ZOMHEIGHTNODEC
	
	call HideCurser
	call putMatrixInBuffer
	call ShowCurser
@@endproc:
	popa
	pop bp
	ret 2
endp DrawZom
;input: Stack: zombie offset
;output undraw a zombi on the buffer
proc UnDrawZom
	push bp
	mov bp,sp
	push bx
	mov bx,[bp+4]
	push [word bx+2]
	push [word bx+4]
	push ZOMWIDTH
	push ZOMHEIGHT
	call BackgroundByPositionAndSize
	pop bx
	pop bp
	ret 2
endp UnDrawZom
;-----------Mathematical operations-----------

;Description: Finds the x and y need to add to get to a target point
;Input: Through Stack: 1.XStart [bp + 12]  2. YStart [bp + 10] 3. XTagrget[bp + 8] 4. YTarget[bp + 6] 5. speed[bp + 4]
;Output: Through Stack: 1.X 2.Y
;Requirements: 1.Make room in stack before (sub sp, 4)
proc XYtoAdd2Dots
	push bp
	mov bp, sp
	push ax
	push bx
	push dx
	push cx
	push di
	push si
	
	mov bx, [bp + 8]
	sub bx, [bp + 12]
	;bx -> XTarget - XStart
	
	
	mov di, [bp + 6]
	sub di, [bp + 10]
	;di -> YTarget - YStart
	
	mov ax, bx
	mul ax
;Fixed Decimal point Correction
	mov cx, 4
@@loopToShiftRight1:
	shr ax, 1
	shr dx, 1
	jnc @@NoCarryInDX1
	or ax, 1000000000000000b
@@NoCarryInDX1:
	loop @@loopToShiftRight1
	push dx;save answer
	push ax;save answer
	
	mov ax, di
	mul ax
;Fixed Decimal point Correction
	mov cx, 4
@@loopToShiftRight2:
	shr ax, 1
	shr dx, 1
	jnc @@NoCarryInDX2
	or ax, 1000000000000000b
@@NoCarryInDX2:
	loop @@loopToShiftRight2
	
	pop si
	add ax, si
	jnc @@NoCarry1
	inc dx
@@NoCarry1:
	pop cx
	add dx, cx
	
	sub sp, 2
	push dx
	push ax
	call Sqrt
	pop cx
	shl cx, 2
	
	cmp cx, 0
	jnz @@DenominatorIsNotZero;If the Denominator is zero i just make a recursive call to a target with and x bigger by 1
	;1.XStart [bp + 12]  2. YStart [bp + 10] 3. XTagrget[bp + 8] 4. YTarget[bp + 6] 5. speed[bp + 4]
	sub sp, 4
	push [word bp + 12]
	push [word bp + 10]
	mov ax, [bp + 8]
	inc ax
	push ax
	push [word bp + 6]
	push [word bp + 4]
	call XYtoAdd2Dots
	pop [word bp + 14]
	pop [word bp + 16]
	jmp @@EndProc
	
@@DenominatorIsNotZero:
	
	mov ax, [bp + 4]
	mul bx
	push cx
	mov cx, 4
	@@loopToShiftRight3:
	shr ax, 1
	shr dx, 1
	jnc @@NoCarryInDX3
	or ax, 1000000000000000b
@@NoCarryInDX3:
	loop @@loopToShiftRight3
	pop cx
	div cx
	
	shl ax, 4;Fixed Decimal Point
	push ax;save
	
	Shl dx, 4;Sheerit
	mov ax, dx
	xor dx, dx
	div cx
	pop dx
	add ax, dx
	mov [bp + 14], ax
	
	mov ax, [bp + 4]
	mul di
	push cx
	mov cx, 4
	@@loopToShiftRight4:
	shr ax, 1
	shr dx, 1
	jnc @@NoCarryInDX4
	or ax, 1000000000000000b
@@NoCarryInDX4:
	loop @@loopToShiftRight4
	pop cx
	div cx
	
	shl ax, 4;Fixed Decimal Point
	push ax;save
	
	Shl dx, 4;Sheerit
	mov ax, dx
	xor dx, dx
	div cx
	pop dx
	add ax, dx
	mov [bp + 16], ax
@@EndProc:
	
	pop si
	pop di
	pop cx
	pop dx
	pop bx
	pop ax
	pop bp
	ret 10
endp XYtoAdd2Dots
;Description; this procedure activates XYtoAdd2Dots and includes the case that the X or Y target are smaller
;Input: Through stack: 1. Make room in stack for Output (sub sp, 4)(x- bp + 14 y - bp + 16) 2.XStart(bp + 12) 3.YStart(bp + 10) 4.XTarget(bp + 8) 5.YTarget(bp + 6) 6.Speed (bp + 4)
;Output: Through stack: 1. XToAdd 2.YToAdd
;Requirements; make room in stack before (sub sp, 4)
proc XYtoAdd2DotsWithNeg
	push bp
	mov bp, sp
	pusha
	mov [SurNeedDraw], 0

	mov dx, [bp + 12];dx -> X start
	
	mov di, [bp + 10];di -> Y start
	
	mov cx, [bp + 8];cx -> X Target
	
	mov si, [bp + 6];si -> Y Target
	
	cmp di, si
	ja @@TargetIsAbove
;TargetIsBleow
	mov [ZomAngleChange],0
	cmp cx, dx
	ja @@TargetIsRight1
;Target Is Left Below
	sub sp, 4
	push cx
	push di
	push dx
	push si
	push [word bp + 4]
	
	call XYtoAdd2Dots
	
	pop dx
	neg dx
	pop di
	
	jmp @@XYAreSet
	
@@TargetIsRight1:
;Target Is Right Below
	;mov [SurAngle],4
	sub sp, 4
	push dx
	push di
	push cx
	push si
	push [word bp + 4]
	
	call XYtoAdd2Dots
	
	pop dx
	pop di

	jmp @@XYAreSet
@@TargetIsAbove:
	mov [ZomAngleChange],1
	cmp cx, dx
	ja @@TargetIsRight2
;Target Is Left Above
	;mov [SurAngle],20
	sub sp, 4
	push cx
	push si
	push dx
	push di
	push [word bp + 4]
	
	call XYtoAdd2Dots
	
	pop dx
	neg dx
;inc dx
	pop di
	neg di
	
	jmp @@XYAreSet
@@TargetIsRight2:
;Target Is Right Above
	;mov [SurAngle],28
	sub sp, 4
	push dx
	push si
	push cx
	push di
	push [word bp + 4]
	
	call XYtoAdd2Dots
	
	pop dx
	pop di
	neg di
	
	
	jmp @@XYAreSet
@@XYAreSet:

	mov [bp + 14], dx
	
	mov [bp + 16], di
	
	popa
	pop bp
	ret 10
endp XYtoAdd2DotsWithNeg
;Description: Calculate pixel position on the screen (y*320+x)
;Input: 2  stack: X[bp+6] Y[bp+4]
;Output: in stack
;Requirements: make room in stack (sub sp,2)
proc CalculatePixelPosition
	push bp
	mov bp, sp
	push ax
	push bx
	push dx
	

	add [word bp + 4], 1000b

	add [word bp + 6], 1000b

	
	SHR [word bp + 4], 4
	
	SHR [word bp + 6], 4

	xor dx, dx
	mov bx, 320
	mov ax, [bp + 4]
	mul bx
	add ax, [bp + 6]
	mov [bp + 8], ax
	pop dx
	pop bx
	pop ax
	pop bp
	ret 4
endp CalculatePixelPosition
;Description: Calculates the square root of a 32 - bit number
;Input: through Stack in this order: 1.High Order word 2.Low Order word
;Output: 16 bit through Stack
;Requirements: Make room for returning value in stack (sub sp, 2)
proc Sqrt
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push di
	push si
	push dx
	
	cmp [word bp + 4], 1
	ja @@Not1
	cmp [word bp + 6], 0
	jnz @@Not1
	mov ax, [bp + 4]
	mov [bp + 8], ax
	jmp @@EndOfProc
@@Not1:
	mov bx, [bp + 4]
	mov si, [bp + 6]
	shr bx, 1
	shr si, 1
	jnc @@NoCarry1
	or bx, 1000000000000000b
@@NoCarry1:
	mov ax, [bp + 4]
	mov dx, [bp + 6]
	div bx
	mov di, si
	add ax, bx
	jnc @@NoCarry2
	inc di
@@NoCarry2:
	shr ax, 1
	shr di, 1
	jnc @@NoCarry3
	or ax, 1000000000000000b
@@NoCarry3:
	mov cx, ax
	
	
	@@WhileLoop:
	cmp di, si
	ja @@EndOfLoop
	jb @@NoEndOfLoop
	cmp cx, bx
	jae @@EndOfLoop
@@NoEndOfLoop:
	mov bx, cx
	mov si, di
	mov ax, [bp + 4]
	mov dx, [bp + 6]
	div bx
	mov di, si
	add ax, bx
	jnc @@NoCarry4
	inc di
@@NoCarry4:
	shr ax, 1
	shr di, 1
	jnc @@NoCarry5
	or ax, 1000000000000000b
@@NoCarry5:
	mov cx, ax
	jmp @@WhileLoop

@@EndOfLoop:
	mov [bp + 8], bx
@@EndOfProc:
	pop dx
	pop si
	pop di
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
endp Sqrt
;Description:returns the rounded number of a decimal point number
;Input: Through stack rounded num
;output: Through stack rounded num
;Requirements: make room in stack for output (sub sp, 2)
proc RoundDecPoint
	push bp
	mov bp, sp
	push bx
	
	mov bx, [word bp + 4]
	add bx, 1000b
	shr bx, 4
	mov [word bp + 6], bx
	
	pop bx
	pop bp
	ret 2
endp RoundDecPoint
;Description: checks if 2 rectangles are in collision
;Input: Through stack: 1.sub sp, 2 (make room for returning value)(bp + 20) 2.X1 (bp + 18) 3.Y1(bp + 16) 4. 1Length (bp + 14) 5.1Height (bp + 12) 6.X2 (bp + 10) 7.Y2 (bp + 8) 8.2Length (bp + 6) 9.2Height (bp + 4]
;Output: Through stack 1.bool - are coliding
proc CheckCollision
	push bp
	mov bp, sp
	pusha
	
	mov cx, [bp+ 18]; cx -> x1
	mov si, [bp + 16]; si -> y1 
	mov dx, [bp + 10]; dx -> x2
	mov di, [bp + 8]; di -> y2
	
	add cx, [bp + 14]; cx -> x1end
	
	cmp cx, dx
	jb @@NotColide
	
	sub cx, [bp + 14]; cx -> x1
	
	add dx, [bp + 6]; dx -> x2end
	
	cmp cx, dx
	ja @@NotColide
	
	add si, [bp + 12] ; si -> y1end
	
	cmp si, di
	
	jb @@NotColide
	
	sub si, [bp + 12] ; si -> y1
	
	add di, [bp + 4] ; di -> y2end
	
	cmp si, di
	ja @@NotColide
	
;The rectangels colide
	
	mov [word bp + 20], 0
	
	jmp @@endproc
	
@@NotColide:
	
	mov [word bp + 20], 1
	
	jmp @@endproc

@@endproc:
	popa
	pop bp
	ret 16
endp CheckCollision
; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	push bx
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
	xor ah,ah
@@ExitP:
	pop bx
	pop di
	pop si
	pop es
	ret
endp RandomByCs
; make mask acording to bh size 
; output Si = mask put 1 in all bh range
; example  if bh 4 or 5 or 6 or 7 si will be 7
; 		   if Bh 64 till 127 si will be 127
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask
;Description: wait for input in an infinite loop until the input is space
proc WaitForSpace
	pusha
	
@@WaitForSpace:
	mov ah, 0
	int 16h
	
	cmp ah, 39h
	jz @@SpaceWasEntered
	jmp @@WaitForSpace
	
@@SpaceWasEntered:
	
	
	popa
	ret
endp WaitForSpace
;Description: Delays by the amount of zombies and bullets activated so there will always be the almost same amount of delay no matter what
;Input: ZombiesCount, BulletsCount
proc EqualDelay
	pusha
	
	mov cx, ZOMARRLENGTH
	sub cl, [ZombiesCount]
	cmp cx, 0
	jz @@NoDelay1
@@Delay1:
    push BgLengthDec-ZOMWIDTH
	push BgHeightDec-ZOMHEIGHT
	push ZOMWIDTH
	push ZOMHEIGHT
	call BackgroundByPositionAndSize
	loop @@Delay1
@@NoDelay1:

	mov cx, BulletArrayLength
	sub cl, [BulletsCount]
	cmp cx, 0
	jle @@NoDelay2
@@Delay2:
	push 0h
	push 0h
	push BULLETLENGTH
	push BULLETHEIGHT
	call BackgroundByPositionAndSize
	loop @@Delay2
@@NoDelay2:

	popa
	ret
endp EqualDelay
EndOfCsLbl:
END start