;------------------------------------------------------------------------
;	TRABALHO PRATICO - TECNOLOGIAS e ARQUITECTURAS de COMPUTADORES
;
;	ANO LECTIVO 2020/2021
;--------------------------------------------------------------

.8086
.model small
.stack 2048

dseg	segment para public 'data'

;TIME
		STR12	 							db 		"            "					; String para 12 digitos

		Horas								dw		0									; Vai guardar a HORA actual
		Minutos								dw		0									; Vai guardar os minutos actuais
		Segundos							dw		0									; Vai guardar os segundos actuais
		adreess     						dw      0
		Old_seg								dw		0									; Guarda os ultimos segundos que foram lidos
		current_time						dw		0									; Guarda O Tempo que decorre o  jogo

;GAME
		game_type                db       0
		file_is_open                        dw      0
		check_level_game_string           db      0
		print_current_time					db		"    /099$"

		player_nickname                 	db      10 dup('$')
    player_nickname_temp				db	    "                    $"

		print_score    						db      "  $"
		print_score_AH           			db      ?
		print_score_Al           			db      ?
		score     	    					dw      0

		print_letters 						db 		"          $"
    current_word  						db	  "LUA       $"
		level_2         					db		"CAOS      $"
		level_3         					db		"MARIO     $"
		level_4         					db		"MEXICO    $"
		level_5         					db		"PORTUGAL  $"
		next_level       					dw     0

		time_level2_copy  							db	  "  $"        
		time_level3_copy								db	  "  $"   
		time_level4_copy								db	  "  $"   
		time_level5_copy								db	  "  $"   

		POSy								db		3									; a linha pode ir de [1 .. 25]
		POSx								db		3									; POSx pode ir [1..80]
		POSya								db		3									; Posicao anterior de y
		POSxa								db		3									; Posicao anterior de x

;GAMEVAR2
    save_current_letter       		dw 				?
    si_curret_letter          		dw 				0
		flag													dw        0
		file_level_1         			db      		"LABI1.TXT$"
    file_level_2         			db      		"LABI2.TXT$"
    file_level_3         			db      		"LABI3.TXT$"
    file_level_4         			db      		"LABI4.TXT$"
    file_level_5         			db      		"LABI5.TXT$"

; MENUS
		TituloPrincipal						db		"Menu Principal$"
		COMECAR								db		"1.Jogar var1$"
		COMECAR_2                           db      "2.Jogar var2$"
		TOP10								db 		"3.TOP10$"
		create_lab                          db      "4.Criar Labirinto$"
		SAIR								db		"5.Sair$"
;TOP 10
		TOP10PAGE							db 		"OS 10 MELHORES CLASSIFICADOS$"
		TOP10PAGE_SAIR						db      "PARA VOLTAR PARA TRAS PRIMA 'e'$"
		TOP10PAGE_FIM						db      "PARA FECHAR O JOGO PRIMA 'e'$"

		PROXLEVEL 							db		"Para ir para o proximo nivel prima 'p'$"
		FIMJOGO      						db		"Chegou ao fim do jogo para sair prima 'e'$"

		fname								db	    'top10.txt',0
		fhandle 							dw	     0
		msgErrorCreate						db	    "Ocorreu um erro na criacao do ficheiro!$"
		msgErrorWrite						db		"Ocorreu um erro na escrita para ficheiro!$"
		msgErrorClose						db	    "Ocorreu um erro no fecho do ficheiro!$"
    Erro_Open       					db      'Erro ao tentar abrir o ficheiro$'
    Erro_Ler_Msg    					db      'Erro ao tentar ler do ficheiro$'
    Erro_Close      					db      'Erro ao tentar fechar o ficheiro$'
    Fich         						db      'labi.txt               ',0
        HandleFich      					dw      0
		Handle          					dw      0
        car_fich        					db      ?

		i               					dw      0
		j               					dw      0

;create_lab

		buffer_lab        db	'                          score:                   Tempo:                     ',13,10
											db	' ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±',13,10
											db	' palavra:                                                                     ',13,10
											db	' game   :                                                                     ',13,10
											db	'$                                                                             ',13,10
											db	'                                                                              ',13,10
											db	'                                                                              ',13,10
											db	'                                                                              ',13,10
											db	'                                                                              ',13,10

		 buffer_lab_copy  db	'                          score:                   Tempo:                     ',13,10
											db	' ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±                                                                           ±',13,10
											db	' ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±',13,10
											db	' palavra:                                                                     ',13,10
											db	' game   :                                                                     ',13,10
											db	'$                                                                             ',13,10
											db	'                                                                              ',13,10
											db	'                                                                              ',13,10
											db	'                                                                              ',13,10
											db	'                                                                              ',13,10
	
			namefile          				db 		15 dup('$')
			file_lab         				db      '             ',0
			switch_barrier   				dw 		0
			active_letter_mode      		dw 		0
			next_letter       				dw 		0
			letra           				db 		'A'
			print_mode                      db      "MODE:$"
			print_mode_add_barrier          db      "Add barrier   $"
			print_mode_remove_barrier       db      "Remove barrier$"
			print_mode_free_mode       			db      "Free mode     $"
			print_mode_letter_mode       		db      "Letter mode   $"
			print_save_game                 db      "'e' para salvar o jogo$"
			print_mode_options              db      "'u - FreeMode'  'i - Add'  'o - Remove'  'y - LetterMode'  'p- addletter'$"
			posbuffery						dw      3
			posbufferx						dw      3
			posbufferya                     dw      ?
			posbufferxa                     dw      ?
			msgMENU_lab						db		"Bem-vindo ao Menu de criacao de labirintos$"
			msgMENU_lab2					db		"Para editar um labirinto existente prima 0$"
			msgMENU_lab3					db		"Para criar um labirinto de raiz prima 1$"
			msgMENU_labname					db		"Insira o nome do ficheiro que contem o labirinto$"
			msgMENU_lab4					db		"Quando clicar numa das opcoes ira poder criar um labirinto. funcionalidades:$"
			msgMENU_lab5					db		"'u' - FreeMode (Navegacao livre) permite navegar livremente pelo labirinto$"
			msgMENU_lab6					db		"'o' - Add permite adicionar uma barreira$"
			msgMENU_lab7					db		"'y' - Ativa o Modo 'COLOCAR LETRAS' , no instante que e clicado nao e possivel voltar adicionar ou remover barreira$"
			msgMENU_lab8					db		"'p' - Adiciona letra quando chegar a 'Z' a edicao do labirinto termina$"
			msgMENU_lab9					db		"'e' - Exit permite sair da edicao do labirinto a qualquer momento$"
			guardarlabirinto			db		"Insira um nome para guardar num ficheiro .txt$"
			word_for_level2       db    "Palavra para o nivel 2$"
			word_for_level3       db    "Palavra para o nivel 3$"
			word_for_level4       db    "Palavra para o nivel 4$"
			word_for_level5       db    "Palavra para o nivel 5$"
			word_level2               db 		15 dup('$')
			word_level3               db 		15 dup('$')
			word_level4               db 		15 dup('$')
			word_level5               db 		15 dup('$')
			time_for_level2       db    "tempo para o nivel  2$"
			time_for_level3       db    "tempo para o nivel  3$"
			time_for_level4       db    "tempo para o nivel  4$"
			time_for_level5       db    "tempo para o nivel  5$"
			time_level2               db 		15 dup('$')
			time_level3               db 		15 dup('$')
			time_level4               db 		15 dup('$')
			time_level5               db 		15 dup('$')

;TOP 10
		buffer								db	'  20       Pedro                              ',13,10
											db 	'  11       Joao                               ',13,10
											db	'  10       Jhon                               ',13,10
											db 	'  08       Peter                              ',13,10
											db	'  05       Paulo                              ',13,10
											db	'  02       Mariana                            ',13,10
											db	'  01       Mario                              ',13,10
											db	'  01       Rui                                ',13,10
											db	'  00       Luis                               ',13,10
											db	'  00       Lucas                              ',13,10
											db	'  $$                                          ',13,10
											db	'______________________________________________',13,10


		msgTOP10	           				db	   "A sua pontuacao esta entra o top10$"
		msgNOME	               				db	   "Digite o seu NickName para aparecer na tabela$"
		guardasi               				dw      0
		guardavalor            				dw      0
		Car									db	    32	; Guarda um caracter do Ecran
		Cor									db		7	; Guarda os atributos de cor do caracter
		TEMP								db      32
	;calc aleatorio
		ultimo_num_aleat dw 0
		str_num db 5 dup(?),'$'
dseg	ends


cseg	segment para public 'code'
assume		cs:cseg, ds:dseg


; MACROS
; goto_xy -  GO TO POSITION X,Y
goto_xy	macro		POSx,POSy
	mov		ah,02h
	mov		bh,0		; numero da pagina
	mov		dl,POSx
	mov		dh,POSy
	int		10h
endm

; MOSTRA - DISPLAYS STRING THAT ENDS WITH $
MOSTRA MACRO STR
		mov AH,09H
		lea DX,STR
		int 21H
ENDM
; ENDMACROS


;ROTINA PARA APAGAR ECRAN

apaga_ecran	proc
		mov		ax,0B800h
		mov		es,ax
		xor		bx,bx
		mov		cx,25*80

apaga:
		mov		byte ptr es:[bx],' '
		mov		byte ptr es:[bx+1],7
		inc		bx
		inc 	bx
		loop	apaga

			ret
apaga_ecran	endp
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
; CALC - ALEATORIO
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
CalcAleat proc near

	sub	sp,2
	push	bp
	mov	bp,sp
	push	ax
	push	cx
	push	dx	
	mov	ax,[bp+4]
	mov	[bp+2],ax

	mov	ah,00h
	int	1ah

	add	dx,ultimo_num_aleat
	add	cx,dx	
	mov	ax,65521
	push	dx
	mul	cx
	pop	dx
	xchg	dl,dh
	add	dx,32749
	add	dx,ax

	mov	ultimo_num_aleat,dx

	mov	[BP+4],dx

	pop	dx
	pop	cx
	pop	ax
	pop	bp
	ret
CalcAleat endp
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
; Ler_TEMPO - READS TIME - H/M/S
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
Ler_TEMPO PROC

		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX

		PUSHF

		MOV AH, 2CH             ; Buscar a hORAS
		INT 21H

		XOR AX,AX
		MOV AL, DH              ; segundos para al
		mov Segundos, AX		; guarda segundos na variavel correspondente

		XOR AX,AX
		MOV AL, CL              ; Minutos para al
		mov Minutos, AX         ; guarda MINUTOS na variavel correspondente

		XOR AX,AX
		MOV AL, CH              ; Horas para al
		mov Horas,AX			; guarda HORAS na variavel correspondente

		POPF
		POP DX
		POP CX
		POP BX
		POP AX

			ret
Ler_TEMPO   ENDP
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
; Trata_Horas - PRINTS TIME / TIME LEFT / SCORE
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
Trata_Horas PROC

		PUSHF
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX

		CALL 	Ler_TEMPO				; Horas MINUTOS e segundos do Sistema

		MOV		AX, Segundos
		cmp		AX, Old_seg				; VErifica se os segundos mudaram desde a ultima leitura
		je		fim_horas				; Se a hora nao mudou desde a ultima leitura sai.

		mov		Old_seg, AX				; Se segundos sao diferentes actualiza informacao do tempo

		mov 	ax,Horas
		MOV		bl, 10
		div 	bl
		add 	al, 30h					; Caracter Correspondente as dezenas
		add		ah,	30h					; Caracter Correspondente as unidades
		MOV 	STR12[0],al
		MOV 	STR12[1],ah
		MOV 	STR12[2],'h'
		MOV 	STR12[3],'$'
		GOTO_XY 2,0
		MOSTRA STR12

		mov 	ax,Minutos
		MOV 	bl, 10
		div 	bl
		add 	al, 30h					; Caracter Correspondente as dezenas
		add		ah,	30h					; Caracter Correspondente as unidades
		MOV 	STR12[0],al
		MOV 	STR12[1],ah
		MOV 	STR12[2],'m'
		MOV 	STR12[3],'$'
		GOTO_XY	6,0
		MOSTRA	STR12

		mov 	ax,Segundos
		MOV 	bl, 10
		div 	bl
		add 	al, 30h				   	; Caracter Correspondente as dezenas
		add	ah,	30h						; Caracter Correspondente as unidades
		MOV 	STR12[0],al				;
		MOV 	STR12[1],ah
		MOV 	STR12[2],'s'
		MOV 	STR12[3],'$'
		GOTO_XY	10,0
		MOSTRA	STR12

;PRINTS SCORE
		mov		ax,score
		MOV		bl,10
		div		bl
		add		al,30h
		add		ah,30h
		MOV		print_score[0],al
		MOV		print_score[1],ah
		GOTO_XY 32,0
		MOSTRA  print_score

;PRINTS TIME LEFT
		inc		current_time
		mov		ax,current_time
		MOV		bl,10
		div		bl
		add		al,30h
		add		ah,30h
		MOV		print_current_time[0],'0'
		MOV		print_current_time[1],al
		MOV		print_current_time[2],ah
;COMPARS CURRENT TIME WITH MAX TIME
		mov al,print_current_time[6]
		mov ah,print_current_time[7]
		cmp print_current_time[2], ah
		JNE checkcurrentime
		cmp print_current_time[1], al
		JNE checkcurrentime
;IF TIME HAS PASSED CALL PROC
	call 		LEFICH
checkcurrentime:
	GOTO_XY 	58,0
	MOSTRA		print_current_time

;PRINTS WORD
	GOTO_XY		9,20
	MOSTRA  	current_word
;PRINTS LETTERS THAT WERE COLLECTED
	GOTO_XY		9,21
	MOSTRA  	print_letters

fim_horas:
	goto_xy		POSx,POSy			; Volta a colocar o cursor onde estava antes de actualizar as horas

	POPF
	POP 		DX
	POP 		CX
	POP 		BX
	POP 		AX

				RET
Trata_Horas ENDP
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
; IMP_FICH - PRINTS LAB - LABI.TXT
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
IMP_FICH	PROC
	cmp file_is_open,1
	JE printlab
	JNE ask_again
	ask_again:
	xor si,si
;SE ENTROU NO ASK AGAIN SIGNIFICA QUE O UTILIZADOR ESTA NA VAR1

;COLOCA A STRING FITCH COM ESPAÇOS 
	lea bx,Fich
	call restarts_string

	call apaga_ecran
	goto_xy		1,1
	MOSTRA guardarlabirinto
	goto_xy		1,2
	mov si,offset namefile 
	call ask_string 	
	lea bx,Fich
	call copy_string_to_string

printlab:
	mov		ah, 3dh				; Abrir o ficheiro para escrita
	mov		al, 00H				; Define o tipo de ficheiro  00 - L? APENAS 02- L?/ESCREVE (!!!!MAS NAO DA OVERWRITE)
	lea		dx,offset Fich			; DX aponta para o nome do ficheiro
	int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)	
	mov Handle,ax
	cmp Handle,2h
	JE 	ask_again
	cmp Handle,3h
	JE 	ask_again
	cmp Handle,4h
	JE 	ask_again
	jnc	escreve				; Se n?o existir erro escreve no ficheiro

escreve:
;COLOCA NO BUFFER_LAB O CONTIUDO DO FICHEIRO
		mov cx,2131
		mov bx,ax
		mov dx, offset buffer_lab
		mov ah,3fh
		int 21h

		cmp buffer_lab[1840],' '
		JE print_lab
		lea bx,level_2
		call restarts_string
		lea si,buffer_lab[1840]
		lea bx,level_2
		call copy_string_to_string
		lea bx,level_3
		call restarts_string
    lea si,buffer_lab[1920]
		lea bx,level_3
		call copy_string_to_string
		
    lea si,buffer_lab[2000]
		lea bx,level_4
		call restarts_string
		lea bx,level_4		
    call copy_string_to_string

    lea si,buffer_lab[2080]
		lea bx,level_5
		call restarts_string
		lea bx,level_5	
        call copy_string_to_string

print_lab:
        lea si,buffer_lab[2095]
        lea bx,time_level2_copy
        call copy_string_to_string  

        lea si,buffer_lab[2100]
        lea bx,time_level3_copy
        call copy_string_to_string  

        lea si,buffer_lab[2105]
        lea bx,time_level4_copy
        call copy_string_to_string 

        lea si,buffer_lab[2110]
        lea bx,time_level5_copy
        call copy_string_to_string   

call apaga_ecran
goto_xy 0,0
MOSTRA buffer_lab
sai_f:
				RET
IMP_FICH	endp
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
;LE_TECLA - CHECKS KEYBOARDS
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
LE_TECLA	PROC
sem_tecla:
	call 		Trata_Horas
	MOV			AH,0BH
	INT 		21h
	cmp 		AL,0
	je	sem_tecla

	je			sem_tecla
	MOV			AH,08H
	INT			21H
	MOV			AH,0
	CMP			AL,0
	JNE			SAI_TECLA
	MOV			AH, 08H
	INT			21H
	MOV			AH,1
SAI_TECLA:
				RET
LE_TECLA	ENDP
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
;LE_TECLA_LAB - FOR LAB CREATION
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
LE_TECLA_LAB	PROC
		goto_xy 1,0
		MOSTRA print_save_game
		goto_xy 4,22
		MOSTRA print_mode_options
		goto_xy 30,23
		MOSTRA  print_mode
		cmp active_letter_mode,1
		JNE check_rest
		JE	print_mode_letter
check_rest:
		cmp switch_barrier,1
		JE print_mode_add
		cmp switch_barrier,3
		JE prima_mode_remove
		cmp switch_barrier,0
		JE prima_mode_free
		goto_xy POSx,POSy
		JNE check_current_mode
print_mode_add:
		MOSTRA  print_mode_add_barrier
		JMP check_current_mode
prima_mode_remove:
		MOSTRA  print_mode_remove_barrier
		JMP check_current_mode
prima_mode_free:
		MOSTRA  print_mode_free_mode
		JMP check_current_mode
print_mode_letter:
		MOSTRA  print_mode_letter_mode
		JMP check_current_mode

check_current_mode:
		goto_xy 	POSx,POSy
		mov		ah,08h
		int		21h
		mov		ah,0
		cmp al,'p'
		JE add_letter
		cmp al,'y'
		JE active_letter
		cmp al,'e'          ; PARA TERMINAR
		JE FIM
		cmp al,'i'         ; PARA DESATIVAR BARREIRA
		JE barrier_on
		cmp al,'u'         ; PARA ATIVAR BARREIRA
		JE barrier_off
		cmp al,'o'
		JE	remv_barrier
		JNE continue

remv_barrier:
			mov switch_barrier,3
			JMP SAI_TECLA

add_letter:
			mov next_letter,1
			JMP SAI_TECLA

active_letter:
			cmp active_letter_mode,1
			JE POR0
			mov active_letter_mode,	1
			JMP	SAI_TECLA
POR0:
		mov active_letter_mode,	0
			JMP	SAI_TECLA
barrier_on:
			mov switch_barrier,1
			JMP SAI_TECLA

FIM:
			call save_lab
barrier_off:
			mov switch_barrier,0
			JMP SAI_TECLA

continue:
		cmp		al,0
		jne		SAI_TECLA
		mov		ah, 08h
		int		21h
		mov		ah,1

SAI_TECLA:	RET
LE_TECLA_LAB	endp
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
;GAME_VAR1 - GAME
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
GAME_VAR1	PROC
	mov			ax,0B800h
	mov			es,ax

	goto_xy	POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h		; Guarda o Caracter que est? na posi??o do Cursor
	mov			bh,0			; numero da p?gina
	int			10h
	mov			Car, al			; Guarda o Caracter que est? na posi??o do Cursor

CICLO:

	goto_xy	POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0			; numero da p?gina
	int			10h

	cmp 		al, '±'
	;Se posi?o atual por barreira jump
	JE  		barrierblock
	cmp 		al , ' '
	;Se posi?o atual por vazio  jump	
	JE  		default
	;Caso nao se verifique nenhuma dos cmp anteriores signfica que ?uma letra
	xor 		si,0
	mov 		si,0
	lea 		bx,current_word




;Entra num loop para verficar se a letra faz parte da palavra
checkletter:
	mov			ah, [bx]
	cmp 		ah,al
	;Se letra for igual a uma das letras da palavra jump put_letter
	JE 			put_letter
	inc			bx
	inc 		si
	;Se letra nao for igual faz default
	cmp 		ah, '$'
	JE 			default
	JNE 		checkletter

barrierblock:
	goto_xy		POSxa,POSya
	mov			al, POSxa
	mov			POSx, al
	mov			al, POSya
	mov 		POSy, al
	JE 			LER_SETA

put_letter:
	GOTO_XY		9,21
	dec si
	dec bx
	
LOOPER:
	inc si
	inc bx
	mov ah,[bx]
	cmp ah,'$'
	mov check_level_game_string,ah
	JE printletter
	cmp ah,al
	JNE LOOPER
	mov print_letters[si],al
	inc score
	JMP LOOPER
printletter:
		MOSTRA 		print_letters
 		goto_xy        POSxa,POSya        ; Vai para a posi??o anterior do cursor
    mov            ah, 02h
    mov            dl, Car            ; Repoe Caracter guardado
    int            21H
		goto_xy        POSx,POSy        ; Vai para nova possi??o
    mov         ah, 08h
    mov            bh,0            ; numero da p?gina
    int            10h
    mov            Car, al            ; Guarda o Caracter que est? na posi??o do Cursor	

	;Verifica se palavra current_word tem todas as letras 
		lea 		si,current_word
		lea			di,print_letters
		cmp check_level_game_string,'$'
		JNE checkletter

check_end_level:
	mov 		al,[si]
	mov 		ah, [di]
	cmp 		al,ah
	;Se letra nao for igual a letra da palavra IMPRIME
	JNE 		IMPRIME
	inc 		si
	inc 		di
	CMP 		al ,'$'
	JNE 		check_end_level
;RESTART GAME VARIABLES
	INC 		next_level
	mov 		POSy ,3
	mov 		POSx, 3
	xor			si,si

restart_print_letters:
;REMOVES WHATs INSIDE OF STRING PRINT_LETTERS
	mov 		print_letters[si], ' '
	inc 		si
	cmp 		print_letters[si], '$'
	JNE		 	restart_print_letters

	xor 		si,si
	mov 		si,0

restart_current_word:
	CMP 		next_level,1
	JE 			level_two
	CMP			next_level,2
	JE 			level_three
	CMP 		next_level,3
	JE 			leve_four
	CMP 		next_level,4
	JE 			level_five

level_two:
	mov 		al, level_2[si]

;MOVES TO THE STRING NEW TIME
	mov     ah,time_level2_copy[0]
	mov 		print_current_time[5],'0'
	mov 		print_current_time[6] , ah
	mov     ah,time_level2_copy[1]
	mov 		print_current_time[7] , ah
	JE 			current_word_block

level_three:
	mov 		al, level_3[si]

;MOVES TO THE STRING NEW TIME
	mov     ah,time_level3_copy[0]
	mov 		print_current_time[5],'0'
	mov 		print_current_time[6],ah
	mov     ah,time_level3_copy[1]
	mov 		print_current_time[7],ah
	JE 			current_word_block

leve_four:
	mov			al, level_4[si]

;MOVES TO THE STRING NEW TIME
	mov     ah,time_level4_copy[0]
	mov 		print_current_time[5],'0'
	mov 		print_current_time[6], ah
	mov     ah,time_level4_copy[1]
	mov 		print_current_time[7],ah
	JE 			current_word_block

level_five:
	mov 		al, level_5[si]

;MOVES TO THE STRING NEW TIME
	mov     ah,time_level5_copy[0]
	mov 		print_current_time[5],'0'
	mov 		print_current_time[6], ah
	mov     ah,time_level5_copy[1]
	mov 		print_current_time[7],ah
	JE 			current_word_block

current_word_block:
	mov  		current_word[si] , al
	inc 		si
	cmp 		al, '$'
	JNE 		restart_current_word

	mov			ax,score
	MOV			bl,10
	div			bl
	add			al,30h
	add			ah,30h
	MOV			print_score[0],al
	MOV			print_score[1],ah

	cmp 		next_level,5
	JE 			end_game
	call 		next_level_proc                ; Line 575

end_game:
	call 		LEFICH

default:
	xor 		al,0
	xor 		ah,0
	xor 		si,0
	xor 		bx,0
	goto_xy		POSxa,POSya		; Vai para a posi??o anterior do cursor
	mov			ah, 02h
	mov			dl, Car			; Repoe Caracter guardado
	int			21H

	goto_xy		POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0			; numero da p?gina
	int			10h
	mov			Car, al			; Guarda o Caracter que est? na posi??o do Cursor

IMPRIME:
	goto_xy		POSx,POSy		; Vai para posi??o do cursor
	mov			ah, 02h
	mov			dl, 190	; Coloca AVATAR
	int			21H
	goto_xy		POSx,POSy	; Vai para posi??o do cursor

	mov			al, POSx	; Guarda a posi??o do cursor
	mov			POSxa, al
	mov			al, POSy	; Guarda a posi??o do cursor
	mov 		POSya, al

LER_SETA:
	call 		LE_TECLA
	cmp			ah, 1
	je			ESTEND
	CMP 		AL, 27	; ESCAPE
	JE			FIM
	jmp			LER_SETA

ESTEND:
	cmp 		al,48h
	jne			BAIXO
	dec			POSy		;cima
	jmp			CICLO

BAIXO:
	cmp			al,50h
	jne			ESQUERDA
	inc 		POSy		;Baixo
	jmp			CICLO

ESQUERDA:
	cmp			al,4Bh
	jne			DIREITA
	dec			POSx		;Esquerda
	jmp			CICLO

DIREITA:
	cmp			al,4Dh
	jne			LER_SETA
	inc			POSx		;Direita
	jmp			CICLO

fim:

				RET
GAME_VAR1		endp

; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
;GAME_VAR2 - GAME
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
GAME_VAR2	PROC
	mov			ax,0B800h
	mov			es,ax

	goto_xy	POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h		; Guarda o Caracter que est? na posi??o do Cursor
	mov			bh,0			; numero da p?gina
	int			10h
	mov			Car, al			; Guarda o Caracter que est? na posi??o do Cursor

CICLO:
	goto_xy	POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0			; numero da p?gina
	int			10h
	cmp 		al,  '±'
	JE  		barrierblock
	cmp 		al , ' '
	JE  		default
	mov si,si_curret_letter
	
  mov     bx,save_current_letter
	mov			ah, [bx]
	cmp 		ah,al
	JE 			put_letter
  JNE     restart
	cmp 		ah, '$'
	JE 			default

restart:
	mov flag,0
	mov POSx,3
	mov POSy,3
	mov score,0
	call IMP_FICH
	lea bx ,current_word
	mov save_current_letter,bx
	lea bx,print_letters
	call restarts_string
	JMP default

barrierblock:
	goto_xy		POSxa,POSya
	mov			al, POSxa
	mov			POSx, al
	mov			al, POSya
	mov 		POSy, al
	JE 			LER_SETA

put_letter:
	mov 		print_letters[si],al
  inc     si_curret_letter
  inc save_current_letter 
	GOTO_XY		9,21
	MOSTRA 		print_letters
	inc 		score

	goto_xy		POSxa,POSya		; Vai para a posi??o anterior do cursor
	mov			ah, 02h
	mov			dl, ' '			; Repoe Caracter guardado
	int			21H

	goto_xy		POSx,POSy		; Vai para a posi??o anterior do cursor
	mov			ah, 02h
	mov			dl, ' '			; Repoe Caracter guardado
	int			21H

	mov Car,0

	lea 		si,current_word
	lea			di,print_letters
	je 			check_end_level

check_end_level:
	mov 		al,[si]
	mov 		ah, [di]
	cmp 		al,ah
	JNE 		IMPRIME
	inc 		si
	inc 		di
	CMP 		al ,'$'
	JNE 		check_end_level
;RESTART GAME VARIABLES
	INC 		next_level
	mov 		POSy ,3
	mov 		POSx, 3
  mov     si_curret_letter,0
	lea 		bx,current_word
	mov     save_current_letter,bx


	xor 		si,si
	mov 		si,0
restart_print_letters:
;REMOVES WHATs INSIDE OF STRING PRINT_LETTERS
	mov 		print_letters[si], ' '
	inc 		si
	cmp 		print_letters[si], '$'
	JNE		 	restart_print_letters

	xor 		si,si
	mov 		si,0

restart_restart_lab:
	CMP 		next_level,1
	JE 			level_two
	CMP			next_level,2
	JE 			level_three
	CMP 		next_level,3
	JE 			leve_four
	CMP 		next_level,4
	JE 			level_five

level_two:
	mov 		al, file_level_2[si]

;MOVES TO THE STRING NEW TIME
	mov 		print_current_time[5],'0'
	mov 		print_current_time[6],'9'
	mov 		print_current_time[7],'5'
	JE 			current_file_block

level_three:
	mov 		al, file_level_3[si]

;MOVES TO THE STRING NEW TIME
	mov 		print_current_time[5],'0'
	mov 		print_current_time[6],'9'
	mov 		print_current_time[7],'0'
	JE 			current_file_block

leve_four:
	mov			al, file_level_4[si]

;MOVES TO THE STRING NEW TIME
	mov 		print_current_time[5],'0'
	mov 		print_current_time[6],'8'
	mov 		print_current_time[7],'5'
	JE 			current_file_block

level_five:
	mov 		al, file_level_5[si]

;MOVES TO THE STRING NEW TIME
	mov 		print_current_time[5],'0'
	mov 		print_current_time[6],'8'
	mov 		print_current_time[7],'0'
	JE 			current_file_block

current_file_block:
	mov  		fich[si] , al
	inc 		si
	cmp 		al, '$'
	JNE 		restart_restart_lab

	mov			ax,score
	MOV			bl,10
	div			bl
	add			al,30h
	add			ah,30h
	MOV			print_score[0],al
	MOV			print_score[1],ah

	cmp 		next_level,5
	JE 			end_game
	call 		next_level_proc                ; Line 575

end_game:
	call 		LEFICH

default:
	xor 		al,0
	xor 		ah,0
	xor 		si,0
	xor 		bx,0
	goto_xy		POSxa,POSya		; Vai para a posi??o anterior do cursor
	mov			ah, 02h
	mov			dl, Car			; Repoe Caracter guardado
	int			21H

	goto_xy		POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0			; numero da p?gina
	int			10h
	mov			Car, al			; Guarda o Caracter que est? na posi??o do Cursor


	goto_xy		78,0			; Mostra o caractr que estava na posi??o do AVATAR
	mov			ah, 02h			; IMPRIME caracter da posi??o no canto
	mov			dl, Car
	int			21H

IMPRIME:
	goto_xy		POSx,POSy		; Vai para posi??o do cursor
	mov			ah, 02h
	mov			dl, 190	; Coloca AVATAR
	int			21H
	goto_xy		POSx,POSy	; Vai para posi??o do cursor

	mov			al, POSx	; Guarda a posi??o do cursor
	mov			POSxa, al
	mov			al, POSy	; Guarda a posi??o do cursor
	mov 		POSya, al

LER_SETA:
	call 		LE_TECLA
	cmp			ah, 1
	je			ESTEND
	CMP 		AL, 27	; ESCAPE
	JE			FIM
	jmp			LER_SETA

ESTEND:
	cmp 		al,48h
	jne			BAIXO
	dec			POSy		;cima
	jmp			CICLO

BAIXO:
	cmp			al,50h
	jne			ESQUERDA
	inc 		POSy		;Baixo
	jmp			CICLO

ESQUERDA:
	cmp			al,4Bh
	jne			DIREITA
	dec			POSx		;Esquerda
	jmp			CICLO

DIREITA:
	cmp			al,4Dh
	jne			LER_SETA
	inc			POSx		;Direita
	jmp			CICLO

fim:

				RET
GAME_VAR2		endp
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
;NEXT_LEVEL_PROC - MENU FOR NEXT LEVEL
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
next_level_proc PROC

	call		apaga_ecran
	goto_xy		2,2
	MOV 		AH,09h
	LEA 		DX,PROXLEVEL
	int 		21h

waitsforkey:
	MOV 		ah,00h
	int 		16h
	cmp 		AL,'p'
	JNE  		waitsforkey
	mov 		current_time , 0
	goto_xy		0,0
	mov			file_is_open,1
	call 		IMP_FICH
	cmp     game_type,1
	JE 			GAMEVAR2
	JNE    	GAMEVAR1
GAMEVAR2:

CALLAGAIN2:
	call CalcAleat
	pop ax
	cmp al,2
	JB CALLAGAIN2
	cmp al,19
	JA CALLAGAIN2

	mov POSx,al
	mov POSy,al

	goto_xy	POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0			; numero da p?gina
	int			10h

	cmp  al,' '
	JNE CALLAGAIN2
	call 		GAME_VAR2
GAMEVAR1:
CALLAGAIN:
	call CalcAleat
	pop ax
	cmp al,2
	JB CALLAGAIN
	cmp al,19
	JA CALLAGAIN

	mov POSx,al
	mov POSy,al

	goto_xy	POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0			; numero da p?gina
	int			10h

	cmp  al,' '
	JNE CALLAGAIN

call 		GAME_VAR1


				RET
next_level_proc endp
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
;LEFICH - READS/WRITES FILE
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
LEFICH proc

;APENAS ABRE O FICHEIRO
	mov			ah, 3dh					; Abrir o ficheiro para escrita
	mov			al, 02H					; Define o tipo de ficheiro  01 - L? APENAS 02- L?/ESCREVE (!!!!MAS NAO DA OVERWRITE)
	lea			dx,offset fname			; DX aponta para o nome do ficheiro
	int			21h						; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
	cmp         ax,01
	cmp         ax,03h
	JE			create_file
	mov 		Handle,ax
	JNC			file_no_error_found				; Se n?o existir erro escreve no ficheiro
	
create_file:
	mov			ah, 3ch				
	mov			al, 00H				; Define o tipo de ficheiro  00 - L? APENAS 02- L?/ESCREVE (!!!!MAS NAO DA OVERWRITE)
	lea			dx,offset fname			
	int			21h		
	mov 		Handle,ax
	
file_no_error_found:
; COLOCA NO BUFFER O QUE ESTA NO FICHEIRO TOP10.txt
	mov 		cx,528
	mov 		bx,ax
	mov 		dx, offset buffer
	mov 		ah,3fh 						;  read from the opened file (its handler in bx)
	int 		21h

	mov 		si,0
	mov 		bx,score

; COMPARES THE SCORE WITH THE TOP 10 SCORES
check_score:
	mov 		ah,buffer[2+si]
	mov 		al,buffer[3+si]
	mov     bh,print_score[0]
	mov     bl,print_score[1]
;VAI BUSCAR O SCORE DE CADA PESSOA E TRANFORMA EM HEX

;SE CHEGOU AO FINAL DO FICHEIRO E O SCORE NAO E SUPERIOR A 
;NENHUM DOS SCORES DO FICHEIRO SIMPLESMENTE MOSTRA O TOP 10 SEM PEDIR UM NICKNAME
	cmp 		buffer[2+si],'$'
; IF buffer[2+si] = '$' SCORE IS > TOP10
	JE 			print_to_file
; COMPARA O SCORE AO SCORE DO FICHEIRO
	cmp 		bh,ah
	JB   		LOOPAGAIN
	cmp     bl,al
;SE FOR MAIOR QUE O SCORE DO FICHEIRO COLOCA NESSA POSICAO
	JGE 		print_score_to_file
;SE NAO FOR VAO PARA O PROXIMO SCORE E VERICA
LOOPAGAIN:
	add 		si,48
	JMP 		check_score

print_score_to_file:
;MOVE PARA O BX O SCORE
	mov 		bh, print_score[0]
	mov 		bl , print_score[1]
;MOVE PARA O AX O SCORE DO FICHEIRO
	mov 		ah, buffer[2+si]
	mov 		al , buffer[3+si]
;COLOCA NO BUFFER/FICHEIRO O SCORE DO JOGADOR
	mov 		buffer[2+si],bh
	mov 		buffer[3+si],bl
;INCREMENTO UMA LINHA
	add 		si ,48

;GUARDA NUMA VARIAVEL TEMPORARIO O VAI SER SUBTITUIDO NA POSICAO
	mov 		bh,buffer[2+si]
	mov 		print_score_AH,bh
	mov 		bl,buffer[3+si]
	mov 		print_score_Al,bl

	mov 		buffer[2+si],ah
	mov 		buffer[3+si],al

;GUARDA A LINHA ATUAL DO SCORE
	mov 		guardasi,si

;ASKS NAME OF THE PLAYER
	call 		apaga_ecran

	GOTO_XY 	10,10
	MOSTRA  	msgTOP10
	GOTO_XY 	10,12
	MOSTRA		msgNOME
	GOTO_XY 	10,13

;GUARDAR NUMA STRING DE NOME PLAYER_NICKNAME O NOME DO JOGADOR~

	mov 		si,offset player_nickname
	call 		ask_string
;////////////////////////////////////////////////////////

end_scanf:
; COLOCAR DI A 0 PARA PERCURRER A STRING QUE CONTEM O NOME DO JOGADOR
	mov 		di,0
	mov 		si,guardasi
; VOLTO UMA LINHA ATRAS PARA SUBTITUIR O NOME DO JOGADOR
	add 		si,-48


;MOVER NOME JOGADOR UMA POSI??O ABAIXO 
move_nickname_temp:
;MOVER PARA AL AS LETRAS DO JOGADOR ATUAL
	mov 		al, buffer[11+si]
;GUARDO NUMA VARIVEL TEMPORIA O NOME DO JOGADOR ATUAL
	mov 		player_nickname_temp[di],al
	inc 		si
	inc 		di
	cmp 		buffer[11+si],' '
	JNE 		move_nickname_temp

	mov 		di,0
	mov 		si,guardasi
	add 		si,-48

put_player_nickname:                             
; ALTERA O NOME DO JOGADOR NA POSI??O ATUAL
	mov 		al,player_nickname[di]
	mov 		buffer[11+si],al
	inc 		di
	inc 		si
	cmp 		player_nickname[di],'$'
	JNE 		put_player_nickname
	JE 			clears_previous_nickanme

clears_previous_nickanme:
; SE O TAMANHO DO NOME PLAYER QUE ESTAVA NESTA POSI??O FOR SUPERIOR A DO QUE VAI SER SUBITUIDO TEM DE SER APAGADO
	cmp 		buffer[11+si], ' '
	JE 			end_clear
	mov 		buffer[11+si], ' '
	inc 		si
	JNE 		clears_previous_nickanme

end_clear:
;MOVE SCORES TO THE NEXT LINE
	mov 		si,guardasi
	add 		si ,48

move_other_scores:
; MOVER O SCORE PARA A PROXIMA POSI??O
	mov 		ah, buffer[2+si]
	mov 		al , buffer[3+si]
	cmp 		buffer[2+si],'$'
	JE 			end_move_scores
	mov 		bh,print_score_AH
	mov 		bl,print_score_Al
	mov 		buffer[2+si],bh
	mov 		buffer[3+si],bl
	add 		si ,48
	mov 		print_score_AH,ah
	mov 		print_score_Al,al
	JNE 		move_other_scores

end_move_scores:
; LOOP PARA MOVER O RESTO DOS NOMES PARA BAIXO
	mov 		si,guardasi
	sub 		si,48
	mov 		guardasi,si

next_line_print:
	mov 		si,	guardasi
	add 		si ,48
	mov 		guardasi,si
	mov 		di,0
	cmp 		buffer[2+si],'$'
	JE 			print_to_file
	JNE 		next_letter_print

next_letter_print:
	mov 		al,buffer[si+11]
	mov 		ah,player_nickname_temp[di]
	cmp 		player_nickname_temp[di],'$'
	JE 			next_line_print
	mov 		buffer[si+11],ah
	mov 		player_nickname_temp[di],al
	inc 		si
	inc 		di
	JNE 		next_letter_print

print_to_file:
; MOVE O PONTEIRO DO FICHEIRO PARA A POSI??O INCIAL (OVERWRITE)
	mov  		ah, 42h          ;SERVICE FOR SEEK.
	mov  		al, 0
	mov  		bx, Handle  		;FILE.
	mov  		cx, 0
	mov  		dx, 0
	int  		21h

	mov			bx, Handle				; Coloca em BX o Handle
    mov			ah, 40h				; indica que ? para escrever

	lea			dx, buffer			; DX aponta para a infroma??o a escrever
    mov			cx, 528			; CX fica com o numero de bytes a escrever
	int			21h					; Chama a rotina de escrita
	jnc			close				; Se n?o existir erro na escrita fecha o ficheiro

	mov			ah, 09h
	lea			dx, msgErrorWrite
	int			21h
close:
	mov			ah,3eh				; fecha o ficheiro
	int			21h
	jnc			end_game

	mov			ah, 09h
	lea			dx, msgErrorClose
	int			21h
end_game:
	CALL 		game_over

LEFICH endp
;/////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////
; CRIA LAB
;/////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////
cria_lab	PROC
	mov			ax,0B800h
	mov			es,ax
;///////////////////////////////////////
;incializa variaveis
	mov POSy,3
	mov POSx,3
	mov posbufferx,3
	mov posbuffery,3
	mov switch_barrier,0
;////////////////////////////////////////////
	goto_xy		POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h		; Guarda o Caracter que est? na posi??o do Cursor
	mov			bh,0			; numero da p?gina
	int			10h
	mov			Cor, ah			; Guarda a cor que est? na posi??o do Cursor


CICLO:

	goto_xy		POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h		; Guarda o Caracter que est? na posi??o do Cursor
	mov			bh,0			; numero da p?gina
	int			10h

	cmp 		POSy,19
	JE 			barrierblock
	cmp 		POSy,1
	JE 			barrierblock
	cmp 		POSx,77
	JE 			barrierblock
	cmp 		POSx,1
	JE 			barrierblock

	cmp     switch_barrier,3
	JE 			check_if_barrier
	JNE     check_else
check_if_barrier:
		cmp 		al,  '±'
		JE 			barrier_remove
check_else:
		cmp 		al,  '±'
		JE 			barrierblock
		JNE  		default


	cmp	    al,  '±'
	je      barrierblock
	cmp 		active_letter_mode,1
	JE			letter_active
	cmp 		switch_barrier,0
	JE      barrier_off

default:

	cmp 		active_letter_mode,1
	JNE 		check_barrier
letter_active:
	cmp 		next_letter,1
	JE 			put_letter
	JNE 		barrier_off


put_letter:
	goto_xy		POSxa,POSya		; Vai para a posi??o anterior do cursor
	mov			ah, 02h
	mov			dl, letra
	int			21H

	mov 		al,letra
	mov 		car,al

	goto_xy		POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0		; numero da p?gina
	int			10h
	mov			Car, al			; Guarda o Caracter que est? na posi??o do Cursor

	mov 		next_letter,0


	xor			si,si
	xor		 	di,di
	mov 		di,posbufferya
	mov 		si,posbufferxa

find_position4:
	cmp 		di,0
	add 		si,80
	dec 		di
	JNE 		find_position4
	mov 		al, letra
	mov 		buffer_lab[si],al


	cmp 		letra,'['
	inc 		letra
	JA 			FIM2
	JNE 		IMPRIME

FIM2: mov active_letter_mode,0
check_barrier:

	cmp 		switch_barrier,1
	JE 			barrier_on
	JNE 		barrier_off

barrier_on:
	cmp      al, 'A'
	JAE      check_interval_letter
	JB			 add_barrier
check_interval_letter:
	cmp      al, 'Z'
	JA       add_barrier
	JBE			 barrierblock
add_barrier:
	goto_xy		POSxa,POSya		; Vai para a posi??o anterior do cursor
	mov			ah, 02h
	mov			dl,  '±'
	int			21H

	xor			si,si
	xor		 	di,di
	mov 		di,posbufferya
	mov 		si,posbufferxa

find_position:
	cmp 		di,0
	add 		si,80
	dec 		di
	JNE 		find_position
	mov 		buffer_lab[si], '±'
	JMP 		save_car

barrier_off:
	goto_xy		POSxa,POSya		; Vai para a posi??o anterior do cursor
	mov			ah, 02h
	mov			dl, Car
	int			21H

	xor 		si,si
	xor 		di,di
	mov 		di,posbuffery
	mov 		si,posbufferx

find_position2:
	cmp 		di,0
	add			si,80
	dec 		di
	JNE 		find_position2
	mov 		al,Car
	mov 		buffer_lab[si],al

save_car:
	goto_xy		POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0		; numero da p?gina
	int			10h
	mov			Car, al			; Guarda o Caracter que est? na posi??o do Cursor


	JMP IMPRIME

barrier_remove:

	goto_xy		POSxa,POSya		; Vai para a posi??o anterior do cursor
	mov			ah, 02h
	mov			dl, ' '
	int			21H

	xor			si,si
	xor		 	di,di
	mov 		di,posbuffery
	mov 		si,posbufferx


find_position3:
	cmp 		di,0
	add 		si,80
	dec 		di
	JNE 		find_position3
	mov 		buffer_lab[si],' '

	xor			si,si
	xor		 	di,di
	mov 		di,posbufferya
	mov 		si,posbufferxa


find_position0:
	cmp 		di,0
	add 		si,80
	dec 		di
	JNE 		find_position0
	mov 		buffer_lab[si],' '





	JMP 		IMPRIME

barrierblock:
	goto_xy	POSxa,POSya ; Vai para a posi??o anterior do cursor
	mov			al, POSxa
	mov			POSx, al	; Coloca as posi??es anteriores na posi??o atual
	mov			al, POSya
	mov 		POSy, al        ; Coloca as posi??es anteriores na posi??o atual

	mov         si,posbufferxa
	mov         posbufferx,si
	mov         si,posbufferya
	mov         posbuffery,si
	JE 			LER_SETA




IMPRIME:

			Goto_xy	POSx,POSy		; Vai para posi??o do cursor
			mov		ah, 02h
			mov		dl, 190	; Coloca AVATAR
			int		21H

			goto_xy	POSx,POSy	; Vai para posi??o do cursor

			mov		al, POSx	; Guarda a posi??o do cursor
			mov		POSxa, al
			mov		al, POSy	; Guarda a posi??o do cursor
			mov 	POSya, al

			mov 	si,posbufferx
			mov     posbufferxa,si
			mov 	si,posbuffery
			mov     posbufferya,si


LER_SETA:	call 	LE_TECLA_LAB
			cmp		ah, 1
			je		ESTEND
			CMP 	AL, 27	; ESCAPE
			JE		FIM
			jmp		LER_SETA

ESTEND:		cmp 	al,48h
			jne		BAIXO
			dec		POSy		;cima
			dec     posbuffery
			jmp		CICLO

BAIXO:		cmp		al,50h
			jne		ESQUERDA
			inc 	POSy		;Baixo
			inc     posbuffery
			jmp		CICLO

ESQUERDA:
			cmp		al,4Bh
			jne		DIREITA
			dec		POSx		;Esquerda
			dec		posbufferx
			jmp		CICLO

DIREITA:
			cmp		al,4Dh
			jne		LER_SETA
			inc		POSx		;Direita
			inc		posbufferx
			jmp		CICLO

fim:
			goto_xy	0,0		; Vai para a posi??o anterior do cursor
			mov		ah, 09h
			mov		dl, buffer_lab
			int		21H
			RET
cria_lab		endp



ask_string PROC
	push si
input:
	mov ah,1
    int 21h
    cmp al,13
    je SAI
	cmp al, 08h
	je remove_letter_name_file
    mov [si],al
    inc si
    jmp input
;////////////////////////////////////////
remove_letter_name_file:
	mov al,00
	mov [si] ,al
	dec si
	jmp input
SAI:
	pop si
			RET
ask_string ENDP

copy_string_to_string PROC

LOOPER:
	mov al,[si]
	cmp al,'$'
	JE SAI
	JNE space
space:
	cmp al,' '
	JE SAI
	mov [bx],al
	inc si
	inc bx
	JNE LOOPER
SAI:
				RET
copy_string_to_string ENDP


;//////////////////////////////////////////////////
;PROC QUE COLOCA TODA A STRING COM ESPAÇOS
;///////////////////////////////////////////////////
restarts_string PROC

LOOPER:
	mov al,[bx]
	cmp al,'$'
	JE SAI
	JNE  check_space
check_space: 
	cmp al,' '
	JE SAI
	JNE	restarting_string

restarting_string:
	mov al,' '
	mov [bx],al
	inc bx
	JMP LOOPER
SAI:
				RET
restarts_string ENDP


; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
; SAVE_LAB - PRINT LAB TO FILE
; ////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////
save_lab PROC

;////////////////////////////////////
;PEDE O NOME DO FICHEIRO 
;////////////////////////////////////

	call apaga_ecran

	goto_xy		1,1
	MOSTRA guardarlabirinto
	goto_xy		1,2
	mov si,offset namefile                    
	call ask_string
	lea bx,fname
	call copy_string_to_string
	call apaga_ecran

;////////////////////////////////////
;ABRE O FICHEIRO 
;////////////////////////////////////
	mov		ah, 3ch							
	mov		cx, 00H				; LER-ONLY
	lea		dx, fname			; DX aponta para o nome do ficheiro
	int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
	mov Handle,ax

;////////////////////////////////////
;PEDE O NOME DA SEGUNDA PALAVRA
;////////////////////////////////////
	goto_xy		1,1
	MOSTRA word_for_level2
	goto_xy		1,2
	mov si,offset word_level2 
	call ask_string	
	lea bx, buffer_lab[1840]
	call copy_string_to_string
	call apaga_ecran

;////////////////////////////////////
;PEDE O NOME DA TERCEIRA PALAVRA
;////////////////////////////////////
	goto_xy		1,1
	MOSTRA word_for_level3
	goto_xy		1,2
	mov si,offset word_level3  
	call ask_string	
	lea bx, buffer_lab[1920]
	call copy_string_to_string
	call apaga_ecran

;////////////////////////////////////
;PEDE O NOME DA QUARTA PALAVRA
;////////////////////////////////////
	goto_xy		1,1
	MOSTRA word_for_level4
	goto_xy		1,2
	mov si,offset word_level4 
	call ask_string	
	lea bx, buffer_lab[2000]
	call copy_string_to_string
	call apaga_ecran	
	
;////////////////////////////////////
;PEDE O NOME DA QUINTA PALAVRA
;////////////////////////////////////
	goto_xy		1,1
	MOSTRA word_for_level5
	goto_xy		1,2
	mov si,offset word_level5   
	call ask_string	
	lea bx, buffer_lab[2080]
	call copy_string_to_string
	call apaga_ecran	

;////////////////////////////////////
;PEDE O TEMPO DO NIVEL 2
;////////////////////////////////////
	goto_xy		1,1
	MOSTRA time_for_level2
	goto_xy		1,2
	mov si,offset time_level2  
	call ask_string	
	lea bx, buffer_lab[2095]
	call copy_string_to_string
	call apaga_ecran	

;////////////////////////////////////
;PEDE O TEMPO DO NIVEL 3
;////////////////////////////////////
	goto_xy		1,1
	MOSTRA time_for_level3
	goto_xy		1,2
	mov si,offset time_level3 
	call ask_string
	lea bx, buffer_lab[2100]
	call copy_string_to_string
	call apaga_ecran	

;////////////////////////////////////
;PEDE O TEMPO DO NIVEL 4
;////////////////////////////////////
	goto_xy		1,1
	MOSTRA time_for_level4
	goto_xy		1,2
	mov si,offset time_level4 
	call ask_string	
	lea bx, buffer_lab[2105]
	call copy_string_to_string
	call apaga_ecran		

;////////////////////////////////////
;PEDE O TEMPO DO NIVEL 4
;////////////////////////////////////
	goto_xy		1,1
	MOSTRA time_for_level5
	goto_xy		1,2
	mov si,offset time_level5
	call ask_string	
	lea bx, buffer_lab[2110]
	call copy_string_to_string
	call apaga_ecran		


;////////////////////////////////////
;LETRA QUE FICOU
;////////////////////////////////////

	mov al,letra
	mov buffer_lab[2115],al

;////////////////////////////////////////////////////////////////
;ESCRE NO BUFFER/FICHEIRO TODA A INFORMACAO PEDIDA AO UTILIZAR
;///////////////////////////////////////////////////////////////
	mov		bx, Handle				; Coloca em BX o Handle
    mov		ah, 40h				; indica que ? para escrever
	lea		dx, buffer_lab			; DX aponta para a infroma??o a escrever
    mov		cx, 2160				; CX fica com o numero de bytes a escrever
	int		21h					; Chama a rotina de escrita

	mov		ah,3eh				; fecha o ficheiro
	int		21h

;///////////////////////////////////////////////////////////////////////
;RENICIA VARIAVEIS PARA CASO O UTILIZADOR QUEIRA CRIAR OUTRO LARIBRINTO
;//////////////////////////////////////////////////////////////////////
	mov si, offset buffer_lab_copy[0]
	mov bx, offset buffer_lab[0]
	call copy_string_to_string

	mov POSy,3
	mov POSx,3
	mov posbufferx,3
	mov posbuffery,3
	mov switch_barrier,0

;///////////////////////////////////////////////////////////////////////
;VOLTA PARA O MENU PRINCIPAL
;//////////////////////////////////////////////////////////////////////

	call   MainMenu

		RET
		
save_lab endp


MainMenu proc

go_back:
	call		apaga_ecran
;///////////////////////////////////////////////////////////////////////
;MOSTRA MENUS
;//////////////////////////////////////////////////////////////////////
	goto_xy		2,2
	MOSTRA 		TituloPrincipal
	goto_xy		2,3
	MOSTRA  	COMECAR
	goto_xy		2,4
	MOSTRA 		COMECAR_2
	goto_xy		2,5
	MOSTRA		TOP10
	goto_xy		2,6
	MOSTRA 		create_lab
	goto_xy 	2,7
	MOSTRA		SAIR

;///////////////////////////////////////////////////////////////////////
;ESPERA PELA RESPOSTA DO UTILIZADOR
;//////////////////////////////////////////////////////////////////////
waitsforkey:
	MOV 		ah,00h
	int 		16h
	cmp 		AL,'1'
	JE 			start_game
	cmp 		AL,'2'
	JE 			start_game_2
	cmp 		AL,'3'
	JE 			top_10_menu
	cmp      	AL,'4'
	JE       	createlab
	cmp 		AL,'5'
	JE 			close_game
	JNE  		waitsforkey


;///////////////////////////////////////////////////////////////////////
;TECLA 5 FECHA O JOGO
;//////////////////////////////////////////////////////////////////////
close_game:
	mov			ah,4CH
	INT			21H

;///////////////////////////////////////////////////////////////////////
;TECLA 3 MOSTRA O TOP10
;//////////////////////////////////////////////////////////////////////
top_10_menu:
	call 		apaga_ecran
; ABRE O FICHEIRO PARA IR COLOCAR NO BUFFER
	mov			ah, 3dh				
	mov			al, 00H				; Define o tipo de ficheiro  00 - L? APENAS 02- L?/ESCREVE (!!!!MAS NAO DA OVERWRITE)
	lea			dx,offset fname			
	int			21h		
;SE O FICHEIRO NAO EXISTE CRIA UM	
	cmp         ax,03h
	JE			create_file
	mov 		Handle,ax
	JNC			escreve				; Se n?o existir erro escreve no ficheiro
	
create_file:
	mov			ah, 3ch				
	mov			al, 00H				; Define o tipo de ficheiro  00 - L? APENAS 02- L?/ESCREVE (!!!!MAS NAO DA OVERWRITE)
	lea			dx,offset fname			
	int			21h		
	mov 		Handle,ax

escreve:
;ESCREVE NO FICHEIRO O QUE ESTA NO BUFFER
	mov 		cx,528
	mov 		bx,ax
	mov 		dx, offset buffer
	mov 		ah,3fh
	int 		21h
;FECHA FICHEIRO
	mov ah, 3Eh 
	mov bx,Handle
	int 21h
;MOSTRA MENUS DO TOP 10	
	GOTO_XY	 	25,2
	MOSTRA  	TOP10PAGE
	GOTO_XY 	25,4
	MOSTRA 		TOP10PAGE_SAIR
	GOTO_XY 	0,5
	MOSTRA 		buffer
;ESPERA QUE O UTILIZADOR CLICK NA TECLA E PARA VOLTAR
	MOV 		ah,00h
	int 		16h
	cmp 		AL,'e'
	JE 			go_back
	JNE 		top_10_menu
	
;///////////////////////////////////////////////////////////////////////
;TECLA 4 VAI PARA O MENU DE LABIRINTO
;//////////////////////////////////////////////////////////////////////
createlab:
	call apaga_ecran
	call Menucriarlabirinto

;///////////////////////////////////////////////////////////////////////
;TECLA 1 COMECA O JOGO VAR1
;//////////////////////////////////////////////////////////////////////
start_game:
	goto_xy 	0,0
	call 		apaga_ecran
	call		IMP_FICH
CALLAGAIN:
	call CalcAleat
	pop ax
	cmp al,2
	JB CALLAGAIN
	cmp al,19
	JA CALLAGAIN

	mov POSx,al
	mov POSy,al

	goto_xy	POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0			; numero da p?gina
	int			10h

	cmp  al,' '
	JNE CALLAGAIN

	call    GAME_VAR1
	
;///////////////////////////////////////////////////////////////////////
;TECLA 2 COMECA O JOGO VAR2
;////////////////////////////////////////////////////////////////////// 
start_game_2:

;FILE IS OPEN SERVA PARA SE ELE TIVER A 1 NAO PEDIR O NOME DE UM LABIRINTO 
  mov 	file_is_open,1
  mov 	game_type,1
  lea 	bx,current_word
  mov   save_current_letter,bx
  goto_xy 	0,0
  call 		apaga_ecran
	lea si,file_level_1
	lea bx,fich
	call copy_string_to_string
  call		IMP_FICH
  mov     si,0
  mov     si_curret_letter,si
  

CALLAGAIN2:
	call CalcAleat
	pop ax
	cmp al,2
	JB CALLAGAIN2
	cmp al,19
	JA CALLAGAIN2

	mov POSx,al
	mov POSy,al

	goto_xy	POSx,POSy		; Vai para nova possi??o
	mov 		ah, 08h
	mov			bh,0			; numero da p?gina
	int			10h

	cmp  al,' '
	JNE CALLAGAIN2


  call    GAME_VAR2   

end_menu:
				RET
MainMenu endp

Menucriarlabirinto PROC

call apaga_ecran


	goto_xy		1,1        ; MOSTRA A STRING
	MOV AH,09H
	LEA DX,msgMENU_lab
	int 21h

	goto_xy		1,2        ; MOSTRA A STRING
	MOV AH,09H
	LEA DX,msgMENU_lab2
	int 21h

	goto_xy		1,3        ; MOSTRA A STRING
	MOV AH,09H
	LEA DX,msgMENU_lab3
	int 21h

	goto_xy   1,8
	MOSTRA msgMENU_lab4
	goto_xy   1,10
	MOSTRA msgMENU_lab5
	goto_xy   1,12
	MOSTRA msgMENU_lab6
	goto_xy   1,14
	MOSTRA msgMENU_lab7
	goto_xy   1,17
	MOSTRA msgMENU_lab8
		goto_xy   1,19
	MOSTRA msgMENU_lab9

waitsforkey:
	MOV ah,00h            ; ESPERA POR UMA TECLA
	int 16h
	cmp AL,'1'
	JE SAI
	cmp AL,'0'
	JE ins_buffer
	JNE waitsforkey

ins_buffer:

	call insert_buffer

SAI:
	call apaga_ecran
	goto_xy 0,0
	MOSTRA buffer_lab
	call cria_lab
				RET
Menucriarlabirinto endp

insert_buffer PROC


ask_gain:
	call apaga_ecran
	goto_xy 1,1
	MOSTRA msgMENU_labname
	goto_xy 1,2
	mov  si,offset namefile
	call ask_string
	mov bx ,offset file_lab
	call copy_string_to_string
	mov		ah, 3dh				; Abrir o ficheiro para escrita
	mov		al, 00H				; Define o tipo de ficheiro  00 - L? APENAS 02- L?/ESCREVE (!!!!MAS NAO DA OVERWRITE)
	lea		dx,offset file_lab			; DX aponta para o nome do ficheiro
	int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
	mov Handle,ax
	jnc		escreve				; Se n?o existir erro escreve no ficheiro

	mov		ah, 09h
	lea		dx, msgErrorCreate
	int		21h

	jmp		ask_gain

escreve:

		mov cx,2160
		mov bx,ax
		mov dx, offset buffer_lab
		mov ah,3fh
		int 21h
		JMP fim2


fim:
		mov			ah,4CH
		INT			21H

fim2:
call apaga_ecran
goto_xy 0,0
MOSTRA buffer_lab

	cmp buffer_lab[2115], ' '
	JNE putletter
	mov letra,'['
	JMP inicialize
putletter:
	mov al , buffer_lab[2115]
	mov letra,al
inicialize:
	mov POSy,3
	mov POSx,3
	mov posbufferx,3
	mov posbuffery,3
	mov switch_barrier,0
call 	cria_lab

			RET
insert_buffer ENDP

game_over PROC
	call			apaga_ecran

	GOTO_XY 		25,2
	MOSTRA  		TOP10PAGE
	GOTO_XY 		25,4
	MOSTRA 			TOP10PAGE_FIM
	GOTO_XY 		0,5
;TERMINA QUANDO CHEGA AO '$'
	MOSTRA 			buffer

waitsforkey:
	MOV 			ah,00h
	int 			16h
	cmp 			AL,'e'
	JE 				end_game
	JNE 			waitsforkey

end_game:
	call			apaga_ecran
;TERMINA JOGO
	mov				ah,4CH
	INT				21H

					RET
game_over endp  ;GAME_OVER END PROC


Main  proc
	mov				ax, dseg
	mov				ds,ax

	mov				ax,0B800h
	mov				es,ax

	call 			MainMenu
	goto_xy			0,0
	call 			GAME_VAR1
	goto_xy			0,22

	mov				ah,4CH
	INT				21H

					RET
Main	endp ;MAIN END PROC
Cseg	ends
end	Main



