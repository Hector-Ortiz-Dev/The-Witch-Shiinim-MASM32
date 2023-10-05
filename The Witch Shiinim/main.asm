.386
.model flat, stdcall
.stack 10448576
option casemap:none

; ========== LIBRERIAS =============
include masm32\include\windows.inc 
include masm32\include\kernel32.inc
include masm32\include\user32.inc
includelib masm32\lib\kernel32.lib
includelib masm32\lib\user32.lib
include masm32\include\gdi32.inc
includelib masm32\lib\Gdi32.lib
include masm32\include\msimg32.inc
includelib masm32\lib\msimg32.lib
include masm32\include\winmm.inc
includelib masm32\lib\winmm.lib
include masm32\include\masm32.inc
includelib masm32\lib\masm32.lib
include masm32\include\msvcrt.inc ;rand
includelib masm32\lib\msvcrt.lib


; ================ PROTOTIPOS ======================================
; Delcaramos los prototipos que no están declarados en las librerias
; (Son funciones que nosotros hicimos)
main				proto
credits				proto	:DWORD
playMusic			proto
;joystickError		proto
WinMain				proto	:DWORD, :DWORD, :DWORD, :DWORD

witchAnimation		proto
goToUp				proto
goToDown			proto
goToRight			proto
goToLeft			proto
colisionMuro		proto	:SWORD, :SWORD, :SWORD, :SWORD, :WORD, :WORD
moverDisparo		proto
saleDisparo			proto
dibujarSlug			proto
dibujarGhost		proto
dibujarFood			proto
golpearSlug			proto
golpearGhost		proto
moverSlug			proto
moverGhost			proto
atacar				proto
posicionRand		proto
posicionRandGhost	proto
comer				proto

; =========================================== DECLARACION DE VARIABLES =====================================================
.data
; ==========================================================================================================================
; =============================== VARIABLES QUE NORMALMENTE NO VAN A TENER QUE CAMBIAR =====================================
; ==========================================================================================================================
className				db			"ProyectoEnsamblador",0		; Se usa para declarar el nombre del "estilo" de la ventana.
windowHandler			dword		?							; Un HWND auxiliar
windowClass				WNDCLASSEX	<>							; Aqui es en donde registramos la "clase" de la ventana.
windowMessage			MSG			<>							; Sirve pare el ciclo de mensajes (los del WHILE infinito)
clientRect				RECT		<>							; Un RECT auxilar, representa el área usable de la ventana
windowContext			HDC			?							; El contexto de la ventana
layer					HBITMAP		?							; El lienzo, donde dibujaremos cosas
layerContext			HDC			?							; El contexto del lienzo
auxiliarLayer			HBITMAP		?							; Un lienzo auxiliar
auxiliarLayerContext	HBITMAP		?							; El contexto del lienzo auxiliar
clearColor				HBRUSH		?							; El color de limpiado de pantalla
windowPaintstruct		PAINTSTRUCT	<>							; El paintstruct de la ventana.
joystickInfo			JOYINFO		<>							; Información sobre el joystick
; Mensajes de error:
errorTitle				byte		'Error',0
joystickErrorText		byte		'No se pudo inicializar el joystick',0


; ==========================================================================================================================
; ========================================== VARIABLES QUE PROBABLEMENTE QUIERAN CAMBIAR ===================================
; ==========================================================================================================================
; El título de la ventana
windowTitle				db			"The Witch Shiinim",0
; El ancho de la venata CON TODO Y LA BARRA DE TITULO Y LOS MARGENES
windowWidth				DWORD		1280	
; El alto de la ventana CON TODO Y LA BARRA DE TITULO Y LOS MARGENES
windowHeight			DWORD		720							
; Un string, se usa como título del messagebox NOTESE QUE TRAS ESCRIBIR EL STRING, SE LE CONCATENA UN 0
messageBoxTitle			byte		'The Witch Shiinim',0	
; Se usa como texto de un mensaje, el 10 es para hacer un salto de linea
; (Ya que 10 es el valor ascii de \n)
messageBoxText			byte		'Programación: Héctor Javier Ortiz Muñiz', 10, 'Developer: MiinishBat', 10, 'LMAD', 0

; El nombre de la música a reproducir.
; Asegúrense de que sea .wav
musicFilename			byte		'Recursos//El_frondoso_bosque_Tanuki.wav', 0

; El manejador de la imagen a manipular, pueden agregar tantos como necesiten.
spriteMap					HBITMAP		?
spriteWitch					HBITMAP		?
spriteHeartFull				HBITMAP		?
spriteHeartEmpty			HBITMAP		?
spriteSlug					HBITMAP		?
spriteShoot					HBITMAP		?
spriteGameOver				HBITMAP		?
spriteGhost					HBITMAP		?
spriteClear					HBITMAP		?
spriteFood					HBITMAP		?
spriteTitle					HBITMAP		?
spriteControls				HBITMAP		?
spriteScore					HBITMAP		?
sprite0						HBITMAP		?
sprite1						HBITMAP		?
sprite2						HBITMAP		?
sprite3						HBITMAP		?
sprite4						HBITMAP		?
sprite5						HBITMAP		?
sprite6						HBITMAP		?
sprite7						HBITMAP		?
sprite8						HBITMAP		?
sprite9						HBITMAP		?
sprite10					HBITMAP		?
sprite11					HBITMAP		?
spriteTonafro				HBITMAP		?

; El nombre de la imagen a cargar
spriteFileMap				byte		'Recursos//Bosque_Tanuki.bmp',0
; Cargar sprite del jugador
spriteFileWitch				byte		'Recursos//witch.bmp',0
; Barras de corazones
spriteFileHeart				byte		'Recursos//barHeart.bmp',0
; Sprite de Slug Enemigo
spriteFileSlug				byte		'Recursos//slugs.bmp',0
; Sprite Disparo
spriteFileShoot				byte		'Recursos//energy.bmp',0
; Sprite GameOver
spriteFileGameOver			byte		'Recursos//gameover.bmp',0
; Sprite Ghost
spriteFileGhost				byte		'Recursos//ghost.bmp',0
; Sprite Clear
spriteFileClear				byte		'Recursos//clear.bmp',0
; Sprite Food
spriteFileFood				byte		'Recursos//food.bmp',0
; Sprite Tonafro
spriteFileTonafro			byte		'Recursos//tonafro.bmp',0
; Sprite Titulo
spriteFileTitle				byte		'Recursos//title.bmp',0
; Sprite Controles
spriteFileControls			byte		'Recursos//controls.bmp',0
; Sprite Score
spriteFileScore				byte		'Recursos//score.bmp',0
spriteFile0					byte		'Recursos//0.bmp',0
spriteFile1					byte		'Recursos//1.bmp',0
spriteFile2					byte		'Recursos//2.bmp',0
spriteFile3					byte		'Recursos//3.bmp',0
spriteFile4					byte		'Recursos//4.bmp',0
spriteFile5					byte		'Recursos//5.bmp',0
spriteFile6					byte		'Recursos//6.bmp',0
spriteFile7					byte		'Recursos//7.bmp',0
spriteFile8					byte		'Recursos//8.bmp',0
spriteFile9					byte		'Recursos//9.bmp',0
spriteFile10				byte		'Recursos//10.bmp',0
spriteFile11				byte		'Recursos//11.bmp',0

;Variable para inicializar vars.
iniVar		byte	1
buffo		byte	1
semilla		sword	0

;Estructura EasterEgg
egg struct
	xPos		sword	2342
	yPos		sword	-1000
	totalX		sword	0
	totalY		sword	0
egg ends

tonafro egg {}

;Estructura del jugador
witch struct
	life		word	316
	direction	byte	0	;Variable direccion del jugador 0 abajo, 1 izquierda, 2 arriba, 3 derecha
	drawX		word	0
	drawY		word	0
	score		byte	0
witch ends

player1 witch {}

food struct
	xPos		sword	720
	yPos		sword	-1728
	totalX		sword	0
	totalY		sword	0
	activo		byte	1
food ends

comida food {}

shoot struct
	xPos		sword	586
	yPos		sword	300
	totalX		sword	0
	totalY		sword	0
	active		byte	0	;0 no existe, 1 existe
	direction	byte	0	;Variable direccion del disparo 0 abajo, 1 izquierda, 2 arriba, 3 derecha
shoot ends

disparo shoot {}

;Estructura de los enemigos Slugs
slug struct
	xPos		sword	 0   ;posicion en pantalla x -> random
	yPos		sword	 0   ;posicion en pantalla y -> random
	totalX		sword	 0	 ;posicion con off
	totalY		sword	 0	 ;posicion con off
	xSize		word	 80  ;tamano en pantalla
	ySize		word	 80  ;tamano en pantalla
	xDraw		word	 80  ;coordenada punto de dibujado
	yDraw		word	 0   ;coordenada punto de dibujado
	xDrawP		word	 80  ;pixeles que toma en x
	yDrawP		word	 80  ;pixeles que toma en y
	velocidad	byte	 2  ;1 normal // +++ rapido
	direction	byte	 0	 ;Variable direccion del disparo 0 abajo, 1 izquierda, 2 arriba, 3 derecha
	vivo		byte	 1   ;0 muerto // 1 vivo
slug ends ;slug struct mide 23

;Esctructura ghost
ghost struct
	xPos			sword		0
	yPos			sword		0
	totalX			sword		720
	totalY			sword		300
	xDraw			word		0
	yDraw			word		0
	velocidad		byte		4
	direction		byte		0
	vivo			byte		1  ;0 muerto // 1 vivo
ghost ends

fantasma ghost {}

;Declarar arreglo de tipo struct Slugs
arrSlug slug 10 dup ({})

;Variables coordenadas del jugador
mapX				word			1712
mapY				word			4160
;Variable de contador para animacion
aniTimer			byte			0

;ajuste para colisiones
offX				sword			0
offY				sword			0

;ajuste de disparo
offShootX			sword			0
offShootY			sword			0

;Pantalla de titulo
varTitle			byte			1

; =============== MACROS ===================
RGB MACRO red, green, blue
	exitm % blue shl 16 + green shl 8 + red
endm 

.code

main proc
	; El programa comienza aquí.
	; Le pedimos a un hilo que reprodusca la música
	invoke	CreateThread, 0, 0, playMusic, 0, 0, 0
	; Obtenemos nuestro HINSTANCE.
	; NOTA IMPORTANTE: Las funciones de WinAPI normalmente ponen el resultado de sus funciones en el registro EAX
	invoke	GetModuleHandleA, NULL   
	; Mandamos a llamar a WinMain
	; Noten que, como GetModuleHandleA nos regresa nuestro HINSTANCE y los resultados de las funciones de WinAPI
	; suelen estar en EAX, entonces puedo pasar a EAX como el HINSTANCE
	invoke	WinMain, eax, NULL, NULL, SW_SHOWDEFAULT
	; Cierra el programa
	invoke ExitProcess,0
main endp

; Este es el WinMain, donde se crea la ventana y se hace el ciclo de mensajes.
WinMain proc hInstance:dword, hPrevInst:dword, cmdLine:dword, cmdShow:DWORD
	; ============== INICIALIZACION DE LA CLASE ====================
	; Establecemos nuestro callback procedure, que en este caso se llama WindowCallback
	mov		windowClass.lpfnWndProc, OFFSET WindowCallback
	; Tenemos que decir el tamaño de nuestra estructura, si no se lo dicen no se podrá crear la ventana.
	mov		windowClass.cbSize, SIZEOF WNDCLASSEX
	; Le asignamos nuestro HINSTANCE
	mov		eax, hInstance
	mov		windowClass.hInstance, eax
	; Asignamos el nombre de nuestra "clase"
	mov		windowClass.lpszClassName, OFFSET className
	; Registramos la clase
	invoke RegisterClassExA, addr windowClass                      
    
	; ========== CREACIÓN DE LA VENATANA =============
	; Creamos la ventana.
	; Le asignamos los estilos para que se pueda crear pero que NO se pueda alterar su tamaño, maximizar ni minimizar
	xor		ebx, ebx
	mov		ebx, WS_OVERLAPPED
	or		ebx, WS_CAPTION
	or		ebx, WS_SYSMENU
	invoke CreateWindowExA, NULL, ADDR className, ADDR windowTitle, ebx, CW_USEDEFAULT, CW_USEDEFAULT, windowWidth, windowHeight, NULL, NULL, hInstance, NULL
    ; Guardamos el resultado en una variable auxilar y mostramos la ventana.
	mov		windowHandler, eax
    invoke ShowWindow, windowHandler,cmdShow               
    invoke UpdateWindow, windowHandler                    

	; ============= EL CICLO DE MENSAJES =======================
    invoke	GetMessageA, ADDR windowMessage, NULL, 0, 0
	.WHILE eax != 0                                  
        invoke	TranslateMessage, ADDR windowMessage
        invoke	DispatchMessageA, ADDR windowMessage
		invoke	GetMessageA, ADDR windowMessage, NULL, 0, 0
   .ENDW
    mov eax, windowMessage.wParam
	ret
WinMain endp


; El callback de la ventana.
; La mayoria de la lógica de su proyecto se encontrará aquí.
; (O desde aquí se mandarán a llamar a otras funciones)
WindowCallback proc handler:dword, message:dword, wParam:dword, lParam:dword

.IF iniVar == 1
xor ecx, ecx
xor edi, edi
mov edi, 0
mov ecx, 10
slugR:
	push ecx
	invoke posicionRand
	add edi, 23
	pop ecx
loop slugR
invoke posicionRandGhost
dec iniVar
.ENDIF

	.IF message == WM_CREATE
		; Lo que sucede al crearse la ventana.
		; Normalmente se usa para inicializar variables.
		; Obtiene las dimenciones del área de trabajo de la ventana.
		invoke	GetClientRect, handler, addr clientRect
		; Obtenemos el contexto de la ventana.
		invoke	GetDC, handler
		mov		windowContext, eax
		; Creamos un bitmap del tamaño del área de trabajo de nuestra ventana.
		invoke	CreateCompatibleBitmap, windowContext, clientRect.right, clientRect.bottom
		mov		layer, eax
		; Y le creamos un contexto
		invoke	CreateCompatibleDC, windowContext
		mov		layerContext, eax
		; Liberamos windowContext para poder trabajar con lo demás
		invoke	ReleaseDC, handler, windowContext
		; Le decimos que el contexto layerContext le pertenece a layer
		invoke	SelectObject, layerContext, layer
		invoke	DeleteObject, layer

		; Asignamos un color de limpiado de pantalla
		invoke	CreateSolidBrush, RGB(0,0,0)
		mov		clearColor, eax

		;-------------------------------------------CargarImagenes----------------------------------------------------
		; TITLE
		invoke	LoadImage, NULL, addr spriteFileTitle, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteTitle, eax

		;GAMEOVER
		invoke	LoadImage, NULL, addr spriteFileGameOver, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteGameOver, eax

		;Cargar Map
		invoke	LoadImage, NULL, addr spriteFileMap, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteMap, eax

		;Cargar Clear
		invoke	LoadImage, NULL, addr spriteFileClear, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteClear, eax

		;Cargar Witch
		invoke	LoadImage, NULL, addr spriteFileWitch, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteWitch, eax

		;Cargar Food
		invoke	LoadImage, NULL, addr spriteFileFood, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteFood, eax

		;Cargar barras de corazones
		invoke	LoadImage, NULL, addr spriteFileHeart, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteHeartFull, eax
		invoke	LoadImage, NULL, addr spriteFileHeart, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteHeartEmpty, eax

		;Cargar tremendo slug
		invoke	LoadImage, NULL, addr spriteFileSlug, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteSlug, eax

		;Cargar Ghost
		invoke  LoadImage, NULL, addr spriteFileGhost, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteGhost, eax

		;Cargar Disparo
		invoke	LoadImage, NULL, addr spriteFileShoot, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteShoot, eax

		;Cargar Tonafro
		invoke	LoadImage, NULL, addr spriteFileTonafro, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteTonafro, eax

		;Cargar Controles
		invoke	LoadImage, NULL, addr spriteFileControls, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteControls, eax

		;Cargar Score
		invoke	LoadImage, NULL, addr spriteFileScore, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		spriteScore, eax

		invoke	LoadImage, NULL, addr spriteFile0, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite0, eax
		invoke	LoadImage, NULL, addr spriteFile1, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite1, eax
		invoke	LoadImage, NULL, addr spriteFile2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite2, eax
		invoke	LoadImage, NULL, addr spriteFile3, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite3, eax
		invoke	LoadImage, NULL, addr spriteFile4, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite4, eax
		invoke	LoadImage, NULL, addr spriteFile5, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite5, eax
		invoke	LoadImage, NULL, addr spriteFile6, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite6, eax
		invoke	LoadImage, NULL, addr spriteFile7, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite7, eax
		invoke	LoadImage, NULL, addr spriteFile8, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite8, eax
		invoke	LoadImage, NULL, addr spriteFile9, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite9, eax
		invoke	LoadImage, NULL, addr spriteFile10, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite10, eax
		invoke	LoadImage, NULL, addr spriteFile11, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
		mov		sprite11, eax

		; Habilitamos el joystick
		;invoke	joyGetNumDevs
		;.IF eax == 0
		;	invoke joystickError	
		;.ELSE
		;	invoke	joyGetPos, JOYSTICKID1, addr joystickInfo
		;	.IF eax != JOYERR_NOERROR
		;		invoke joystickError
		;	.ELSE
		;		invoke	joySetCapture, handler, JOYSTICKID1, NULL, FALSE
		;		.IF eax != 0
		;			invoke joystickError
		;		.ENDIF
		;	.ENDIF
		;.ENDIF

		; Habilita el timer
		invoke	SetTimer, handler, 100, 10, NULL
	.ELSEIF message == WM_PAINT
		; El proceso de dibujado
		; Iniciamos nuestro windowContext
		invoke	BeginPaint, handler, addr windowPaintstruct
		mov		windowContext, eax
		; Creamos un bitmap auxilar. Esto es, para evitar el efecto de parpadeo
		invoke	CreateCompatibleBitmap, layerContext, clientRect.right, clientRect.bottom
		mov		auxiliarLayer, eax
		; Le creamos su contetxo
		invoke	CreateCompatibleDC, layerContext
		mov		auxiliarLayerContext, eax
		; Lo asociamos
		invoke	SelectObject, auxiliarLayerContext, auxiliarLayer
		invoke	DeleteObject, auxiliarLayer
		; Llenamos nuestro auxiliar con nuestro color de borrado, sirve para limpiar la pantalla
		invoke	FillRect, auxiliarLayerContext, addr clientRect, clearColor

		;-------------------------------------------------Dibujar objetos--------------------------------------------------------			
		.IF varTitle == 0
			;Dibujar Mapa
			invoke	SelectObject, layerContext, spriteMap
			invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, mapX, mapY, 1280, 720, 00000ffffh

			;Dibujar disparo
			.IF disparo.active == 1
				; Elegir y dibujar el Disparo
				invoke	SelectObject, layerContext, spriteShoot
				xor eax, eax
				xor ebx, ebx
				mov ax, offShootX
				mov bx, offShootY
				add ax, disparo.xPos
				add bx, disparo.yPos
				mov disparo.totalX, ax
				mov disparo.totalY, bx
				invoke	TransparentBlt, auxiliarLayerContext, disparo.totalX, disparo.totalY, 36, 30, layerContext, 0, 0, 49, 41, 00000ff00h
			.ENDIF
		
			; Elegir sprite del jugador 1
			invoke	SelectObject, layerContext, spriteWitch
			; Dibujar Witch
			invoke	TransparentBlt, auxiliarLayerContext, 568, 270, 72, 90, layerContext, player1.drawX, player1.drawY, 24, 30, 000000000h

			;Dibujar StageClear
			.IF player1.score == 11
				invoke	SelectObject, layerContext, spriteClear
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
				invoke KillTimer, handler, 100
			.ENDIF
		
			;Dibujar Ghost
			.IF fantasma.vivo == 1
				invoke  SelectObject, layerContext, spriteGhost
				invoke  golpearGhost
				invoke  dibujarGhost
				invoke  moverGhost
			.ENDIF

			;Dibujar Comida
			.IF comida.activo == 1
				invoke SelectObject, layerContext, spriteFood
				invoke dibujarFood
				invoke comer
			.ENDIF

			;Elegimos img de slug
			invoke	SelectObject, layerContext, spriteSlug
			;Loop de dibujado Slug
			xor edi, edi
			xor ecx, ecx
			xor eax, eax
			xor ebx, ebx
			mov ecx, 10
			slugD:
				push ecx
				.IF arrSlug[edi].vivo == 1
					invoke golpearSlug
					invoke moverSlug
					invoke dibujarSlug
					invoke atacar
				.ENDIF
				add edi, 23
				pop ecx
			loop slugD
		
			;Dibujar la barra de corazon
			invoke	SelectObject, layerContext, spriteHeartEmpty
			invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 316, 79, layerContext, 0, 79, 316, 79, 00000ff00h

			invoke	SelectObject, layerContext, spriteHeartFull
			invoke	TransparentBlt, auxiliarLayerContext, 0, 0, player1.life, 79, layerContext, 0, 0, player1.life, 79, 00000ff00h

			;Dibujar Tonafro
			mov ax, offX
			mov bx, offY
			add ax, tonafro.xPos
			add bx, tonafro.yPos
			mov tonafro.totalX, ax
			mov tonafro.totalY, bx
			invoke	SelectObject, layerContext, spriteTonafro
			invoke	TransparentBlt, auxiliarLayerContext, tonafro.totalX, tonafro.totalY, 68, 68, layerContext, 0, 0, 68, 68, 00000ff00h

			;Dibujar Controles
			invoke	SelectObject, layerContext, spriteControls
			invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h

			;Dibujar Score
			invoke	SelectObject, layerContext, spriteScore
			invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h

			.IF player1.score == 0
				invoke	SelectObject, layerContext, sprite11
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 1
				invoke	SelectObject, layerContext, sprite10
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 2
				invoke	SelectObject, layerContext, sprite9
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 3
				invoke	SelectObject, layerContext, sprite8
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 4
				invoke	SelectObject, layerContext, sprite7
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 5
				invoke	SelectObject, layerContext, sprite6
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 6
				invoke	SelectObject, layerContext, sprite5
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 7
				invoke	SelectObject, layerContext, sprite4
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 8
				invoke	SelectObject, layerContext, sprite3
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 9
				invoke	SelectObject, layerContext, sprite2
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 10
				invoke	SelectObject, layerContext, sprite1
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ELSEIF player1.score == 11
				invoke	SelectObject, layerContext, sprite0
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
			.ENDIF

			
			;Dibujar Game Over
			.IF player1.life == 0
				invoke	SelectObject, layerContext, spriteGameOver
				invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 0000000ffh
				invoke KillTimer, handler, 100
			.ENDIF	
		.ENDIF
		
		;Dibujar Title
		.IF varTitle == 1
			invoke	SelectObject, layerContext, spriteTitle
			invoke	TransparentBlt, auxiliarLayerContext, 0, 0, 1280, 720, layerContext, 0, 0, 1280, 720, 00000ff00h
		.ENDIF

		; Ya que terminamos de dibujarlas, las mostramos en pantalla
		invoke	BitBlt, windowContext, 0, 0, clientRect.right, clientRect.bottom, auxiliarLayerContext, 0, 0, SRCCOPY
		invoke  EndPaint, handler, addr windowPaintstruct
		; Es MUY importante liberar los recursos al terminar de usuarlos, si no se liberan la aplicación se quedará trabada con el tiempo
		invoke	DeleteDC, windowContext
		invoke	DeleteDC, auxiliarLayerContext

	.ELSEIF message == WM_KEYDOWN
		; Lo que hace cuando una tecla se presiona
		; Deben especificar las teclas de acuerdo a su código ASCII
		; Pueden consultarlo aquí: https://elcodigoascii.com.ar/
		; Movemos wParam a EAX para que AL contenga el valor ASCII de la tecla presionada.
		mov	eax, wParam
		; Esto es un ejemplo: Si presionamos la tecla P mostrará los créditos
		.IF al == 80
			invoke	credits, handler

		.ELSEIF al == 13 ;ENTER
			mov varTitle, 0
		
		.ELSEIF al == 87 ;w
			.IF varTitle == 0
				mov player1.direction, 2
				invoke witchAnimation
				sub mapY, 15
				add offY, 15
				.IF disparo.active == 1
					add offShootY, 15
				.ENDIF
			.ENDIF

		.ELSEIF al == 65 ;a
			.IF varTitle == 0
				mov player1.direction, 1
				invoke witchAnimation
				sub mapX, 15
				add offX, 15
				.IF disparo.active == 1
					add offShootX, 15
				.ENDIF
			.ENDIF

		.ELSEIF al == 83 ;s
			.IF varTitle == 0
				mov player1.direction, 0
				invoke witchAnimation
				add mapY, 15
				sub offY, 15
				.IF disparo.active == 1
					sub offShootY, 15
				.ENDIF
			.ENDIF

		.ELSEIF al == 68 ;d
			.IF varTitle == 0
				mov player1.direction, 3
				invoke witchAnimation
				add mapX, 15
				sub offX, 15
				.IF disparo.active == 1
					sub offShootX, 15
				.ENDIF
			.ENDIF

		.ELSEIF al == 32 ;espacio -> disparo
			.IF varTitle == 0
				.IF disparo.active == 0
					mov disparo.active, 1
					xor eax, eax
					mov al, player1.direction
					mov disparo.direction, al
				.ENDIF
			.ENDIF
		.ENDIF

	.ELSEIF message == WM_KEYUP
		mov player1.drawX, 0

	.ELSEIF message == MM_JOY1MOVE
		; Lo que pasa cuando mueves la palanca del joystick
		xor	ebx, ebx
		xor edx, edx
		mov	edx, lParam
		mov bx, dx
		and	dx, 0
		ror edx, 16
		; En este punto, BX contiene la coordenada de la palanca en x
		; Y DX la coordenada y
		; Las coordenadas se dan relativas al la esquina superior izquierda de la palanca.
		; En escala del 0 a 0FFFFh
		; Lo que significa que si la palanca está en medio, la coordenada en X será 07FFFh
		; Y la coordenada Y también.
		; Lo máximo hacia arriba es 0 en Y
		; Lo máximo hacia abajo en FFFF en Y
		; Lo máximo hacia la derecha es FFFF en X
		; Lo máximo hacia la izquierda es 0 en X
		; Si la palanca no está en ningún extremo, será un valor intermedio
		; Este es un ejemplo: Si la palanca está al máximo a la derecha, mostrará los créditos
		.IF bx == 0FFFFh
			invoke credits, handler
		.ENDIF 

	.ELSEIF message == MM_JOY1BUTTONDOWN
		; Lo que hace cuando presionas un botón del joystick
		; Pueden comparar que botón se presionó haciendo un AND
		xor	ebx, ebx
		mov	ebx, wParam
		and	ebx, JOY_BUTTON1
		; Esto es un ejemplo, si presionamos el botón 1 del joystick, mostrará los créditos
		.IF	ebx != 0
			invoke credits, handler
		.ENDIF

	.ELSEIF message == WM_TIMER
		.IF varTitle == 0
			.IF disparo.active == 1
			xor eax, eax
			xor ebx, ebx
			mov ax, offShootX
			mov bx, offShootY
			add ax, disparo.xPos
			add bx, disparo.yPos
			mov disparo.totalX, ax
			mov disparo.totalY, bx
			invoke saleDisparo
			.ENDIF

			;---------------------------------------------Colisiones------------------------------------------------------
			;minX	minY	 maxX	 maxY
			invoke colisionMuro, -1712, 0, 0, 720, 604, 315
			invoke colisionMuro, 1152, 0, 5888, 720, 604, 315
			invoke colisionMuro, 0, 675, 1152, 2000, 604, 315
			invoke colisionMuro, -432, -909, 432, 45, 604, 315
			invoke colisionMuro, 720, -909, 1728, 45, 604, 315
			invoke colisionMuro, -432, -2880, 3024, -2016, 604, 315
			invoke colisionMuro, -2880, -4160, -432, -864, 604, 315
			invoke colisionMuro, 1728, -1773, 3024, -864, 604, 315
			invoke colisionMuro, 3024, -909, 4608, 0, 604, 315
			invoke colisionMuro, 3024, -4160, 4608, -2835, 604, 315
			invoke colisionMuro, 4608, -2880, 5888, -864, 604, 315

			.IF disparo.active == 1
				invoke moverDisparo
			.ENDIF
		.ENDIF

		; Lo que hace cada tick (cada vez que se ejecute el timer)
		invoke	InvalidateRect, handler, NULL, FALSE
	.ELSEIF message == WM_DESTROY
		; Lo que debe suceder al intentar cerrar la ventana.   
        invoke PostQuitMessage, NULL
    .ENDIF
	; Este es un fallback.
	; NOTA IMPORTANTE: Normalmente WinAPI espera que se le regrese ciertos valores dependiendo del mensaje que se esté procesando.
	; Como varia mucho entre mensaje y mensaje, entonces DefWindowProcA se encarga de regresar el mensaje predeterminado como si las cosas
	; fueran con normalidad. Pero en realidad pueden devolver otras cosas y el comportamiento de WinAPI cambiará.
	; (Por ejemplo, si regresan -1 en EAX al procesar WM_CREATE, la ventana no se creará)
    invoke DefWindowProcA, handler, message, wParam, lParam      
    ret
WindowCallback endp

; Reproduce la música
playMusic proc
	xor		ebx, ebx
	mov		ebx, SND_FILENAME
	or		ebx, SND_LOOP
	or		ebx, SND_ASYNC
	invoke	PlaySound, addr musicFilename, NULL, ebx
	ret
playMusic endp

; Witch Animation
witchAnimation proc
	.IF player1.direction == 0
		mov player1.drawY, 0
		.IF aniTimer == 4
			.IF player1.drawX == 72
				mov player1.drawX, 0
			.ELSE
				add player1.drawX, 24
			.ENDIF
			mov aniTimer, 0
		.ENDIF

	.ELSEIF player1.direction == 1
		mov player1.drawY, 60
		.IF aniTimer == 4
			.IF player1.drawX == 72
				mov player1.drawX, 0
			.ELSE
				add player1.drawX, 24
			.ENDIF
			mov aniTimer, 0
		.ENDIF

	.ELSEIF player1.direction == 2
		mov player1.drawY, 120
		.IF aniTimer == 4
			.IF player1.drawX == 72
				mov player1.drawX, 0
			.ELSE
				add player1.drawX, 24
			.ENDIF
			mov aniTimer, 0
		.ENDIF

	.ELSEIF player1.direction == 3
		mov player1.drawY, 642
		.IF aniTimer == 4
			.IF player1.drawX == 72
				mov player1.drawX, 0
			.ELSE
				add player1.drawX, 24
			.ENDIF
			mov aniTimer, 0
		.ENDIF
	.ENDIF
	INC aniTimer
ret
witchAnimation endp

posicionRand proc
	mov buffo, 1
	.IF edi == 0				;0
		mov semilla, 200
	.ELSEIF edi == 23			;1
		mov semilla, 230
	.ELSEIF edi == 46			;2
		mov semilla, 172
	.ELSEIF edi == 69			;3
		mov semilla, 30
	.ELSEIF edi == 92			;4
		mov semilla, 122
	.ELSEIF edi == 115			;5
		mov semilla, 92
	.ELSEIF edi == 138			;6
		mov semilla, 111
	.ELSEIF edi == 161			;7
		mov semilla, 282
	.ELSEIF edi == 184			;8
		mov semilla, 77
	.ELSEIF edi == 207			;9
		mov semilla, 1
	.ENDIF
	xor eax, eax
	xor ebx, ebx
	xor edx, edx

	.IF edi <= 92
	;ZONA C
	;asignar X
		invoke crt_time, 0
		invoke crt_srand, ax
		invoke crt_rand
		mov bx, 1648
		div bx
		sub dx, semilla
		mov ax, dx
		mov arrSlug[edi].xPos, ax
		mov arrSlug[edi].totalX, ax
	;asignar Y
		invoke crt_time, 0
		invoke crt_srand, ax
		invoke crt_rand
		mov bx, 1926
		div bx
		add dx, semilla
		mov ax, dx
		xor bx, bx
		mov bx, -1
		mul bx
		mov arrSlug[edi].yPos, ax
		mov arrSlug[edi].totalY, ax
		
		.WHILE arrSlug[edi].xPos < -432 || arrSlug[edi].xPos > 1648
			.IF arrSlug[edi].xPos < -432
				add arrSlug[edi].xPos, 400
			.ELSEIF arrSlug[edi].xPos > 1648
				sub arrSlug[edi].xPos, 400
			.ENDIF
		.ENDW
		.WHILE arrSlug[edi].yPos < -2016 || arrSlug[edi].yPos > -944
			.IF arrSlug[edi].yPos < -2016
				add arrSlug[edi].yPos, 400
			.ELSEIF arrSlug[edi].yPos > -944
				sub arrSlug[edi].yPos, 400
			.ENDIF
		.ENDW

	.ELSEIF edi > 92
	;ZONA E
	;asignar X
		invoke crt_time, 0
		invoke crt_srand, ax
		invoke crt_rand
		mov bx, 4528
		div bx
		add dx, semilla
		add dx, 2000
		mov ax, dx
		mov arrSlug[edi].xPos, ax
		mov arrSlug[edi].totalX, ax
	;asignar Y
		invoke crt_time, 0
		invoke crt_srand, ax
		invoke crt_rand
		mov bx, 2880
		div bx
		add dx, semilla
		add dx, 500
		mov ax, dx
		xor bx, bx
		mov bx, -1
		mul bx
		mov arrSlug[edi].yPos, ax
		mov arrSlug[edi].totalY, ax

		.WHILE arrSlug[edi].xPos < 3024 || arrSlug[edi].xPos > 4528
			.IF arrSlug[edi].xPos < 3024
				add arrSlug[edi].xPos, 400
			.ELSEIF	arrSlug[edi].xPos > 4528
				sub arrSlug[edi].xPos, 400
			.ENDIF
		.ENDW
		.WHILE arrSlug[edi].yPos < -2880 || arrSlug[edi].yPos > -944
			.IF arrSlug[edi].yPos < -2880
				add arrSlug[edi].yPos, 400
			.ELSEIF	arrSlug[edi].yPos > -944
				sub arrSlug[edi].yPos, 400
			.ENDIF	
		.ENDW
	.ENDIF
ret
posicionRand endp

posicionRandGhost proc
;ASIGNAR X
	invoke crt_time, 0
	invoke crt_srand, ax
	invoke crt_rand
	mov bx, 5888
	div bx
	mov ax, dx
	mov fantasma.xPos, ax
	mov fantasma.totalX, ax
;ASIGNAR Y
	invoke crt_time, 0
	invoke crt_srand, ax
	invoke crt_rand
	mov bx, 4160
	div bx
	mov ax, dx
	xor bx, bx
	mov bx, -1
	mul bx
	mov fantasma.yPos, ax
	mov fantasma.totalY, ax
ret
posicionRandGhost endp

dibujarSlug	proc
	mov ax, offX
	mov bx, offY
	add ax, arrSlug[edi].xPos
	add bx, arrSlug[edi].yPos
	mov arrSlug[edi].totalX, ax
	mov arrSlug[edi].totalY, bx
	invoke	TransparentBlt, auxiliarLayerContext, arrSlug[edi].totalX, arrSlug[edi].totalY, arrSlug[edi].xSize, arrSlug[edi].ySize, layerContext, arrSlug[edi].xDraw, arrSlug[edi].yDraw, arrSlug[edi].xDrawP, arrSlug[edi].yDrawP, 000ffffffh
ret
dibujarSlug endp

dibujarGhost proc
	mov ax, offX
	mov bx, offY
	add ax, fantasma.xPos
	add bx, fantasma.yPos
	mov fantasma.totalX, ax
	mov fantasma.totalY, bx
	invoke	TransparentBlt, auxiliarLayerContext, fantasma.totalX, fantasma.totalY, 80, 80, layerContext, fantasma.xDraw, fantasma.yDraw, 17, 20, 00000ff00h
ret
dibujarGhost endp

dibujarFood proc
	mov ax, offX
	mov bx, offY
	add ax, comida.xPos
	add bx, comida.yPos
	mov comida.totalX, ax
	mov comida.totalY, bx
	invoke	TransparentBlt, auxiliarLayerContext, comida.totalX, comida.totalY, 40, 40, layerContext, 0, 0, 14, 14, 000ffffffh
ret
dibujarFood endp

saleDisparo proc
xor eax, eax
xor ebx, ebx
mov ax, disparo.totalX
mov bx, disparo.totalY
	.IF ax < 0 || ax > 1280 || bx < 0 || bx > 720
		mov disparo.xPos, 586
		mov disparo.yPos, 300
		mov offShootX, 0
		mov offShootY, 0
		mov disparo.active, 0
	.ENDIF
ret
saleDisparo endp

golpearSlug proc
	.IF disparo.active == 1
		mov ax, disparo.totalX
		mov bx, arrSlug[edi].totalX
		add ax, 18
		.IF ax > bx
			add bx, 80
			.IF ax < bx
				mov ax, disparo.totalY
				mov bx, arrSlug[edi].totalY
				add ax, 15
				.IF ax > bx
					add bx, 80
					.IF ax < bx
						mov arrSlug[edi].vivo, 0
						mov disparo.active, 0
						mov disparo.xPos, 586
						mov disparo.yPos, 300
						mov offShootX, 0
						mov offShootY, 0
						inc player1.score
					.ENDIF
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF
ret
golpearSlug endp

golpearGhost proc
	.IF disparo.active == 1
		mov ax, disparo.totalX
		mov bx, fantasma.totalX
		add ax, 18
		.IF ax > bx
			add bx, 80
			.IF ax < bx
				mov ax, disparo.totalY
				mov bx, fantasma.totalY
				add ax, 15
				.IF ax > bx
					add bx, 80
					.IF ax < bx
						mov fantasma.vivo, 0
						mov disparo.active, 0
						mov disparo.xPos, 586
						mov disparo.yPos, 300
						mov offShootX, 0
						mov offShootY, 0
						inc player1.score
					.ENDIF
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF
ret
golpearGhost endp

moverSlug proc
	;Va hacia el jugador
	xor eax, eax
	mov al, arrSlug[edi].velocidad
	.IF arrSlug[edi].totalX < 567
		add arrSlug[edi].xPos, ax
		mov arrSlug[edi].direction, 3
	.ELSEIF arrSlug[edi].totalX > 571
		sub arrSlug[edi].xPos, ax
		mov arrSlug[edi].direction, 1		
	.ELSEIF arrSlug[edi].totalY < 270
		add arrSlug[edi].yPos, ax
		mov arrSlug[edi].direction, 0
	.ELSEIF arrSlug[edi].totalY > 270
		sub arrSlug[edi].yPos, ax
		mov arrSlug[edi].direction, 2
	.ENDIF

	;Hacia donde mira el Slug
	.IF arrSlug[edi].direction == 0
		mov arrSlug[edi].xDraw, 0
	.ELSEIF arrSlug[edi].direction == 1
		mov arrSlug[edi].xDraw, 80
	.ELSEIF arrSlug[edi].direction == 2
		mov arrSlug[edi].xDraw, 160
	.ELSEIF arrSlug[edi].direction == 3
		mov arrSlug[edi].xDraw, 240
	.ENDIF
ret
moverSlug endp

moverGhost proc
	;Va hacia el jugador
	xor eax, eax
	mov al, fantasma.velocidad
	.IF fantasma.totalX < 567
		add fantasma.xPos, ax
		mov fantasma.direction, 3
	.ELSEIF fantasma.totalX > 571
		sub fantasma.xPos, ax
		mov fantasma.direction, 1		
	.ELSEIF fantasma.totalY < 270
		add fantasma.yPos, ax
		mov fantasma.direction, 0
	.ELSEIF fantasma.totalY > 270
		sub fantasma.yPos, ax
		mov fantasma.direction, 2
	.ENDIF

	;Hacia donde mira el Ghost
	.IF fantasma.direction == 0
		mov fantasma.xDraw, 0
	.ELSEIF fantasma.direction == 1
		mov fantasma.xDraw, 17
	.ELSEIF fantasma.direction == 2
		mov fantasma.xDraw, 34
	.ELSEIF fantasma.direction == 3
		mov fantasma.xDraw, 51
	.ENDIF
ret
moverGhost endp

; Colision jugador
colisionMuro proc minX:SWORD, minY:SWORD, maxX:SWORD, maxY:SWORD, playerX:WORD, playerY:WORD
xor eax, eax
xor ebx, ebx

mov ax, offX
add minX, ax
add maxX, ax
mov ax, offY
add minY, ax
add maxY, ax

;COLISIONES DEL JUGADOR
mov ax, playerX
.IF ax > minX && ax < maxX
	mov ax, playerY
	.IF ax > minY && ax < maxY
		.IF(player1.direction == 0) ;viene de arriba
			sub mapY, 15
			add offY, 15
		.ELSEIF	(player1.direction == 2) ;viene de abajo
		add mapY, 15
			sub offY, 15
		.ELSEIF (player1.direction == 1) ;viene de la derecha
			add mapX, 15
			sub offX, 15
		.ELSEIF (player1.direction == 3) ;viene de la izquierda
			sub mapX, 15
			add offX, 15
		.ENDIF
	.ENDIF
.ENDIF

xor ecx, ecx
xor edi, edi
mov ecx, 10
sub minX, 80
sub minY, 30
xor ebx, ebx
mov bl, arrSlug[edi].velocidad
slugC: ;Omite colisiones con los muros si aparecen afuera del escenario
	mov ax, arrSlug[edi].totalX
	.IF ax > minX && ax < maxX
		mov ax, arrSlug[edi].totalY
		.IF ax > minY && ax < maxY
			.IF(arrSlug[edi].direction == 0) ;viene de arriba
				sub arrSlug[edi].yPos, bx
			.ELSEIF	(arrSlug[edi].direction == 2) ;viene de abajo
				add arrSlug[edi].yPos, bx
			.ELSEIF (arrSlug[edi].direction == 1) ;viene de la derecha
				add arrSlug[edi].xPos, bx
			.ELSEIF (arrSlug[edi].direction == 3) ;viene de la izquierda
				sub arrSlug[edi].xPos, bx
			.ENDIF
		.ENDIF
	.ENDIF
	add edi, 23
loop slugC

.IF disparo.active == 1
	xor eax, eax
	xor ebx, ebx
	mov ax, disparo.totalX
	mov bx, disparo.totalY
	.IF ax > minX && ax < maxX
		.IF bx > minY && bx < maxY
			mov disparo.xPos, 586
			mov disparo.yPos, 300
			mov offShootX, 0
			mov offShootY, 0
			mov disparo.active, 0
		.ENDIF
	.ENDIF
.ENDIF

ret
colisionMuro endp

atacar proc
	.IF arrSlug[edi].totalX > 488 && arrSlug[edi].totalX < 640
		.IF arrSlug[edi].totalY > 190 && arrSlug[edi].totalY < 360
			.IF(arrSlug[edi].direction == 0) ;viene de arriba
				sub arrSlug[edi].yPos, 80
			.ELSEIF	(arrSlug[edi].direction == 2) ;viene de abajo
				add arrSlug[edi].yPos, 80
			.ELSEIF (arrSlug[edi].direction == 1) ;viene de la derecha
				add arrSlug[edi].xPos, 80
			.ELSEIF (arrSlug[edi].direction == 3) ;viene de la izquierda
				sub arrSlug[edi].xPos, 80
			.ENDIF
			.IF player1.life > 0
				sub player1.life, 158
			.ENDIF
		.ENDIF
	.ENDIF

	.IF fantasma.totalX > 488 && fantasma.totalX < 640
		.IF fantasma.totalY > 190 && fantasma.totalY < 360
			.IF(fantasma.direction == 0) ;viene de arriba
				sub fantasma.yPos, 80
			.ELSEIF	(fantasma.direction == 2) ;viene de abajo
				add fantasma.yPos, 80
			.ELSEIF (fantasma.direction == 1) ;viene de la derecha
				add fantasma.xPos, 80
			.ELSEIF (fantasma.direction == 3) ;viene de la izquierda
				sub fantasma.xPos, 80
			.ENDIF
			mov player1.life, 0
		.ENDIF
	.ENDIF
ret
atacar endp

comer proc
	.IF comida.totalX > 528 && comida.totalX < 640
		.IF comida.totalY > 230 && comida.totalY < 360
			mov player1.life, 316
			mov comida.activo, 0
		.ENDIF
	.ENDIF
ret
comer endp

moverDisparo proc
xor eax, eax
.IF disparo.direction == 0
	add disparo.yPos, 5
.ELSEIF disparo.direction == 1
	sub disparo.xPos, 5
.ELSEIF disparo.direction == 2
	sub disparo.yPos, 5
.ELSEIF disparo.direction == 3
	add disparo.xPos, 5
.ENDIF	
moverDisparo endp

; Muestra el error del joystick
;joystickError proc
;	xor		ebx, ebx
;	mov		ebx, MB_OK
;	or		ebx, MB_ICONERROR
;	invoke	MessageBoxA, NULL, addr joystickErrorText, addr errorTitle, ebx
;	ret
;joystickError endp

; Muestra los créditos
credits	proc handler:DWORD
	; Estoy matando al timer para que no haya problemas al mostrar el Messagebox.
	; Veanlo como un sistema de pausa
	invoke KillTimer, handler, 100
	xor ebx, ebx
	mov ebx, MB_OK
	or	ebx, MB_ICONINFORMATION
	invoke	MessageBoxA, handler, addr messageBoxText, addr messageBoxTitle, ebx
	; Volvemos a habilitar el timer
	invoke SetTimer, handler, 100, 10, NULL
	ret
credits endp

end main