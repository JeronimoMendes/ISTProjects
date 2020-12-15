; #################################
; # AUTORES:				      #
; # - Alexandre Corte 99048       #
; # - Jeronimo Mendes 99086       #
; # - Joao Marques 99092	      #
; #################################

; Powered by PEPE 16

DEFINE_LINHA    EQU	600AH       ;endereço do comando para definir a linha
DEFINE_COLUNA   EQU 600CH       ;endereço do comando para definir a coluna
DEFINE_PIXEL    EQU 6012H       ;endereço do comando para escrever um pixel
APAGA_ECRA      EQU 6000H      	;endereço do comando para apagar todos os pixels de todos os ecrãs 
APAGA_ECRAS     EQU 6002H       ;endereço do comando para apagar todos os ecras
SEL_ECRAS       EQU 6004H       ;endereço do comando que seleciona o ecra especificado
PLAY            EQU 605CH       ;endereço do comando para reproduzir o video em loop
CENARIO 	    EQU 6046H       ;endereço do comando que seleciona o numero do ecra frontal a visualizar
SOM 		    EQU 605AH       ;endereço do comando que inicia a reproducao do som/video especificado
PAUSA_VIDEO     EQU 605EH       ;endereço do comando que pausa a reproducao do som/video especificado
TIRA_CENARIO    EQU 6044H       ;endereço do comando que apaga o cenario frontal
CONTINUA_VIDEO  EQU 6060H       ;endereço do comando que continua a reproducao do som/video especificado

TEC_LIN         EQU 0C000H    	;endereço das linhas do TECLADO (periférico POUT-2)
TEC_COL         EQU 0E000H    	;endereço das colunas do TECLADO (periférico PIN)
LINHA           EQU 8         	;linha a testar (4ª linha, 1000b)
DISPLAYS        EQU 0A000H      ;endereço do periférico que liga aos displays

COLUNA_NAVE     EQU 30          ;coluna em que a nave vai começar a ser desenhada
LINHA_NAVE      EQU 26          ;linha em que a nave vai começar a ser desenhada
COR_NAVE        EQU 0F0FFH      ;cor da nave

COLUNA_OVNI		EQU 32          ;coluna em que o ovni vai começar a ser desenhado
LINHA_OVNI		EQU	0           ;linha em que o ovni vai começar a ser desenhado
COR_OVNI		EQU 0FF0FH      ;cor do ovni(roxo)
OFFSET_OVNI 	EQU 4

COLUNA_MISSIL	EQU 80          ;coluna em que o missil vai começar a ser desenhado
LINHA_MISSIL	EQU 15          ;linha em que a missil vai começar a ser desenhado
COR_MISSIL		EQU 0F0F0H      ;cor do missil(verde)
MISSIL_LIMITE	EQU 15      

COLUNA_EXPLOSAO EQU 32          ;coluna em que a nave vai começar a ser desenhada
LINHA_EXPLOSAO  EQU 1           ;linha em que a explosao vai começar a ser desenhada
COR_EXPLOSAO    EQU 0FF80H      ;cor da explosao(laranja)
FRAMES_EXPLOSAO EQU 10

COLUNA_PAUSA	EQU 30
LINHA_PAUSA		EQU 15
COR_PAUSA		EQU 0FFFFH

COR_ASTEROIDE	EQU 0F0F0H      ;cor do asteroide(verde)
COR_NEUTRA		EQU 0F666H      ;cor do asteroide e do ovni no topo da tela(cinzento)

ENERGIA_START	EQU 0069H       ;energia com que o display começa (69H=105D)

PLACEHOLDER 	EQU 20

DELTA_IMAGEM	EQU	4
DELTA_TAM_OVNI	EQU 6
DELTA_ESTADO	EQU 8
DELTA_SENTIDO	EQU 10

ITERA_OVNIS		EQU 89
ITERA_ASTEROI	EQU 90

DECREMENTO_DISPLAY	EQU 5


PLACE       1000H

NAVE:
STRING COLUNA_NAVE, LINHA_NAVE 	; Coordenadas onde esta a nave
WORD COR_NAVE 					; cor da nave
WORD IMAGEM_NAVE    			; pixeis da nava

IMAGEM_NAVE:
WORD 0
WORD COR_NAVE 
STRING 05, 05 ; largura, altura
STRING 0, 0, 1, 0, 0
STRING 0, 1, 1, 1, 0
STRING 1, 1, 1, 1, 1
STRING 0, 0, 1, 0, 0
STRING 0, 1, 1, 1, 0
STRING 0

OVNI:
STRING COLUNA_OVNI, LINHA_OVNI
WORD COR_OVNI
WORD IMAGEM_OVNI
WORD 1 ; estado do ovni (tamanho) (1-pequeno, 2-medio, 3-grande)
WORD 1 ; estado do ovni (ativo) (0- inativo, 1- ativo)
WORD 1 ; sentido que vai tomar 

OVNI2:
STRING COLUNA_OVNI, LINHA_OVNI
WORD COR_OVNI
WORD IMAGEM_OVNI
WORD 1 ; estado do ovni (tamanho) (1-pequeno, 2-medio, 3-grande)
WORD 1 ; estado do ovni (ativo) (0- inativo, 1- ativo)
WORD 5 ; sentido que vai tomar 

OVNI3:
STRING COLUNA_OVNI, LINHA_OVNI
WORD COR_OVNI
WORD IMAGEM_OVNI
WORD 1 ; estado do ovni (tamanho) (1-pequeno, 2-medio, 3-grande)
WORD 1 ; estado do ovni (ativo) (0- inativo, 1- ativo)
WORD 11 ; sentido que vai tomar 

IMAGEM_OVNI:
WORD 1
WORD COR_NEUTRA
STRING 01, 01 ; largura, altura
STRING 1
STRING 0

IMAGEM_OVNI_2:
WORD 1
WORD COR_NEUTRA
STRING 03, 03 
STRING 0, 1, 0
STRING 1, 1, 1
STRING 0, 1, 0
STRING 0

IMAGEM_OVNI_3:
WORD 1
WORD COR_OVNI
STRING 05, 05
STRING 1, 0, 1, 0, 1
STRING 0, 1, 1, 1, 0
STRING 1, 1, 1, 1, 1
STRING 0, 1, 1, 1, 0
STRING 1, 0, 1, 0, 1
STRING 0

ASTEROIDE:
STRING COLUNA_OVNI, LINHA_OVNI
WORD COR_ASTEROIDE
WORD IMAGEM_ASTEROIDE
WORD 1 ; estado do asteroide (tamanho) (1-pequeno, 2-medio, 3-grande)
WORD 0 ; estado do asteroide (ativo) (0- inativo, 1- ativo)
WORD 11 ; sentido que vai tomar 

ASTEROIDE2:
STRING COLUNA_OVNI, LINHA_OVNI
WORD COR_ASTEROIDE
WORD IMAGEM_ASTEROIDE
WORD 1 ; estado do asteroide (tamanho) (1-pequeno, 2-medio, 3-grande)
WORD 0 ; estado do asteroide (ativo) (0- inativo, 1- ativo)
WORD 11 ; sentido que vai tomar 

ASTEROIDE3:
STRING COLUNA_OVNI, LINHA_OVNI
WORD COR_ASTEROIDE
WORD IMAGEM_ASTEROIDE
WORD 1 ; estado do asteroide (tamanho) (1-pequeno, 2-medio, 3-grande)
WORD 0 ; estado do asteroide (ativo) (0- inativo, 1- ativo)
WORD 11 ; sentido que vai tomar 

IMAGEM_ASTEROIDE:
WORD 1
WORD COR_ASTEROIDE
STRING 05, 05
STRING 0, 0, 1, 0, 0
STRING 0, 1, 1, 1, 0
STRING 1, 1, 1, 1, 1
STRING 0, 1, 1, 1, 0
STRING 0, 0, 1, 0, 0
STRING 0


EXPLOSAO:
STRING COLUNA_EXPLOSAO, LINHA_EXPLOSAO
WORD COR_EXPLOSAO
WORD IMAGEM_EXPLOSAO
WORD 0  ; estado da explosao e nr de frames restantes
		; entende-se por explosao ativa quando estado > 0

IMAGEM_EXPLOSAO:
WORD 3
WORD COR_EXPLOSAO
STRING 05, 05
STRING 0, 0, 1, 0, 0
STRING 0, 1, 1, 1, 0
STRING 1, 1, 0, 1, 1
STRING 0, 1, 1, 1, 0
STRING 0, 0, 1, 0, 0
STRING 0

MISSIL:
STRING COLUNA_MISSIL, LINHA_MISSIL
WORD COR_MISSIL
WORD IMAGEM_MISSIL
WORD 0 ; 0- inativo , 1- ativo

IMAGEM_MISSIL:
WORD 2
WORD COR_MISSIL
STRING 01, 02
STRING 1
STRING 1
STRING 0

pilha:
	TABLE 100H
 
SP_inicial:

RANDOM:
	WORD 0

COLISAO:
	WORD 0 	 				; 0 se nao ha colisao, 1 se ha

ESTADOS:
    WORD    0				; estado dos ovnis
    WORD    0				; estado do missil
    WORD    0				; estado do display

ROT_ESTADOS:
	WORD 	MOV_OBJETOS 	; Muda a coord dos ovnis
	WORD	MOV_MISSIL 		; Muda a coord do missil
	WORD	ALTERAR_DISPLAY

ROT_INT:
    WORD    ROT_INT0		; Endereco da rotina de int. 0
    WORD    ROT_INT1		; Endereco da rotina de int. 1
	WORD    ROT_INT2		; Endereco da rotina de int. 2

OBJETOS:
	WORD	OVNI			; Contem o endereco do objeto OVNI
	WORD	ASTEROIDE		; Contem o endereco do objeto ASTEROIDE
	WORD	OVNI2	
	WORD    ASTEROIDE2
	WORD	OVNI3
	WORD	ASTEROIDE3
	FIM_OBJETOS:

energia: 			WORD ENERGIA_START ; Comeca com 105 devido ao atendimento imediato da int. 2

coluna_carregada: 	WORD 0
TECLA_premida: 		WORD 0

ESTA_EM_PAUSE: 		WORD 0
TECLA_ANTERIOR: 	WORD 0FFFFH

ESTADO_JOGO:		WORD 0 ; 0 -> Parado, 1 -> A jogar

FATOR:              WORD 1000


PLACE   0	    

INICIO:
	MOV SP, SP_inicial
	MOV BTE, ROT_INT

	MOV R1, 4
	MOV R0, CENARIO
	MOV [R0], R1

	MOV R0, APAGA_ECRAS
	MOV [R0], R1

    EI0	; enable das int
    EI1
    EI2 
    EI

CICLO_DE_JOGO:	; ciclo principal do jogo

	CALL TECLADO
	CALL CHECK_GAME_STATUS
	CMP R1, 1
	JNZ CICLO_DE_JOGO
	
	MOV  R11, NAVE
	CALL PINTA_IMAGEM
	CALL DISPARA_MISSIL
	CALL CHECK_COLISOES
	CALL DESENHO_EXPLOSAO
	CALL MAKE_RANDOM
	
	CALL CICLO_ESTADOS

	JMP CICLO_DE_JOGO


;R1 - X
;R2 - Y
;R3 - COR
;R4 - imagem
;R5 - ecra
;##########################################################################;
; 							ROTINAS PINTAR ECRA							  #;
;##########################################################################;

;# Pinta uma imagem no ecran
;# INPUT: R11 - Objeto da pintar
PINTA_IMAGEM:
	PUSH R1 ; X
	PUSH R2 ; y
	PUSH R4 ; imagem
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R10
	PUSH R11

	MOVB R1, [R11] ; coluna
	ADD R11, 1

	MOVB R2, [R11] ; linha 
	ADD R11, 1

	MOV R10, [R11] ; cor
	ADD R11, 2

	MOV R8, [R11] ; imagem
	MOV R11, R8

	MOV R6, [R11] 
	MOV R7, SEL_ECRAS
	MOV [R7], R6 ; ecra do objeto
	ADD R11, 2

	MOV R10, [R11] ; nova cor
	ADD R11, 2

	MOVB R6, [R11]; largura
	ADD R11, 1

	MOVB R7, [R11]; altura
	ADD R11, 1

	PINTA_IMAGEM_LOOP_LINHAS:
		CALL PINTA_LINHA
		ADD R11, R6 ; nº de pixeis ja lidos
		ADD R2, 1 ; proxima linha
		SUB R7, 1 ; subtrai 1 à altura
		JNZ PINTA_IMAGEM_LOOP_LINHAS ; a altura já é 0? se sim termina

FIM_PINTA:
	POP R11
	POP R10
	POP R8
	POP R7
	POP R6
	POP R4
	POP R2
	POP R1
	RET


PINTA_LINHA:
	PUSH R0
	PUSH R1
	PUSH R6
	PUSH R11


	PINTA_LINHA_LOOP_PIXEL:
		MOVB R0, [R11] ; recebe o pixel
		CMP R0, 0 ; o pixel é 0?
		JEQ PINTA_LINHA_NAO_PINTA ; se é não pinta
		CALL PINTA_PIXEL ; se é 1, então pintamos o pixel

	PINTA_LINHA_NAO_PINTA:
		ADD R11, 1 ; proximo pixel
		ADD R1, 1 ; proxima coluna
		SUB R6, 1 ; subtrai 1 à largura
		JNZ PINTA_LINHA_LOOP_PIXEL ; a largura já é 0? se sim vamos para a proxima linha

	POP R11
	POP R6
	POP R1
	POP R0
	RET


PINTA_PIXEL:
 	PUSH R0

    MOV  R0, DEFINE_LINHA
    MOV  [R0], R2           ;linha
    
    MOV  R0, DEFINE_COLUNA
    MOV  [R0], R1          ; coluna
    
    MOV  R0, DEFINE_PIXEL
    MOV  [R0], R10			; cor do pixel na linha

    POP R0
    RET


;##########################################################################;
; 								TECLADO									  #;
;##########################################################################;

ROT_TECLADO:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R6

	MOV R5, PLACEHOLDER

	MOV R1, TEC_LIN
	MOV R2, TEC_COL
	
	RESET:
	MOV R3, LINHA			; voltar para a quarta linha (R3 = 8)
	TECLA:
		MOVB [R1], R3 			; R3 = Linha
		MOVB R4, [R2] 			; R4 = Coluna

		CMP R4, 0				; TECLA premida?
		JNZ CONVERTER_TECLA		; se sim entao jump para saber qual a TECLA

		SHR R3, 1 				; Testar proxima linha
		JZ FIM_ROT_TECLADO			; se chegou a primeira linha entao leva RESET
		JMP TECLA				
		
	CONVERTER_TECLA:
		MOV R5, 0               ; R5 = Valor da TECLA
		MOV R6, R3				; R6 = linha carregada

	; Conversao para o nr de TECLA entre 0 e FH
	CONVERTER_TECLA_LIN:
		SHR R3, 1 					; desloca os bits para a direita ate ficar a zero
		JZ  CONVERTER_TECLA_MUL		; Se zero entao vamos para a formula de conversao
		ADD R5, 1					; R5 vai tomar o valor hexadecimal da linha
		JMP CONVERTER_TECLA_LIN		; volta ao loop de converter a linha

	; Formula de conversao: 4 * linha + coluna
	CONVERTER_TECLA_MUL: 		
		MOV R3, 4					; 4 * linha
		MUL R5, R3 					; Calcular Offset linha

	CONVERTER_TECLA_COL:
		SHR R4, 1 					; desloca os bits para a direita ate ficar a zero
		JZ  FIM_ROT_TECLADO				; Se zero entao vai testar a TECLA em TECLA_0_ou_2
		ADD R5, 1					; (4 * linha(ja calculado)) + coluna
		JMP CONVERTER_TECLA_COL		; volta ao loop de converter a coluna
	
	FIM_ROT_TECLADO:
		POP R6
		POP R4
		POP R3
		POP R2
		POP R1
		RET

TECLADO:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10

	CALL ROT_TECLADO

TECLAC:
	CALL CHECK_GAME_STATUS
	CMP R1, 1 ; se for 1 o jogo está ativo
	JZ TECLAE ; Se o jogo esta ativo nao tem logica comecar outra vez

	MOV R10, 0CH
	CMP R5, R10 ; testa a TECLA C
	JNZ TECLAE ; caso não seja a TECLA C, testa a TECLA E

	MOV R0, PLAY  
	MOV R1, 0 ; vídeo principal do jogo
	MOV [R0], R1

	CALL RESET_GAME ; RESET a todos os objetos do jogo e energia.
	MOV R1, 1 
	CALL UPDATE_GAME_STATUS ; muda o estado do jogo para 1
	JMP sai_TECLADO

TECLAE:
	CALL CHECK_GAME_STATUS
	CMP R1, 0 ; se for 0 o jogo está inativo
	JZ sai_TECLADO ; Se o jogo esta inativo nao tem logica comecar outra vez

	MOV R10, 0EH 
	CMP R5, R10 ; testa a TECLA E
	JNZ TECLAD ; caso não seja a TECLA E, testa a TECLA D

	MOV R0, APAGA_ECRAS
	MOV [R0], R1 ; apagar os ecras

	MOV R0, PAUSA_VIDEO
	MOV R1, 0
	MOV [R0], R1

	MOV R1, 1
	MOV R0, CENARIO 
	MOV [R0], R1 ; cenario de desistencia do jogo

	MOV R1, 0
	CALL UPDATE_GAME_STATUS ; muda o estado do jogo para 0

	JMP sai_TECLADO


TECLAD:	
	MOV R10, 0DH 
	CMP R5, R10 ; testa a TECLA D
	JNZ TECLA_0_ou_2 ; caso não seja salta para o teste da TECLA 0 e 2

	MOV R0, TECLA_ANTERIOR 
	MOV R1, [R0] 
	MOV R0, 20 ; valor aleatório que representa a TECLA nada
	CMP R1, R0 ; havia TECLA premida antes?
	JNE sai_TECLADO ; se havia TECLA premida antes, não fazemos nada e saímos do TECLADO

	MOV R0, ESTA_EM_PAUSE 
	MOV R1, [R0]
	CMP R1, 0 ; verifica se o jogo já está em pausa
	JEQ por_em_pausa ; se estiver a 0 então vamos pausar o jogo
	MOV R1, 0 
	MOV [R0], R1 ; mudar o estado de pausa para 0
	MOV R0, PLAY
	MOV R1, 0
	MOV [R0], R1 ; vídeo principal do jogo a dar
	MOV R0, TIRA_CENARIO
	MOV R1, 0
	MOV [R0], R1 ; tira o cenario da pausa
	EI ; reinicia as interrupcoes
	JMP sai_TECLADO

	por_em_pausa:
	MOV R1, 1
	MOV [R0], R1 ; mudar o estado de pausa para 1
	DI ; para as rotinas de interrupcao
	MOV R0, PAUSA_VIDEO
	MOV R1, 0
	MOV [R0], R1 ; pausa o video principal do jogo
	MOV R0, CENARIO 
	MOV R1, 0
	MOV [R0], R1 ; meter o cenario de pausa
	JMP sai_TECLADO

TECLA_0_ou_2:	
	CMP R5, 0 ; TECLA é 0?
	JZ direcao ; se sim vamos para a direcao
	CMP R5, 2 ; TECLA é 2?
	JZ direcao ; se sim vamos para a direcao

TECLA1:
	CMP R5, 1 ; TECLA é 1?
	JNZ sai_TECLADO ; se não for saímos do TECLADO
	CALL ATIVA_MISSIL ; a TECLA 1 foi premida, logo vamos disparar o missil
	JMP sai_TECLADO

direcao:
	MOV R0, ESTA_EM_PAUSE
	MOV R1, [R0]
	CMP R1, 0 ; se estiver em pausa a nave não mexe
	JNE sai_TECLADO

	MOV R1, 0
	CALL DELETE_SCREEN ; apagar o ecrã da nave
	MOV R9, TECLA_premida
	MOV [R9], R5

	MOV R4, [R9]
	CMP R4, 0 ; se a TECLA é 0 a nave anda para a esquerda

	JZ esquerda
	CMP R4, 2 ; se a TECLA é 2 a nave anda para a direita
	JZ direita

	esquerda:	
		MOV R7, NAVE
		MOVB R4, [R7] ; coluna da nave

		SUB R4, 1 ; subtrai 1 para andar para a esquerda
		MOV R8, 0FFFFh
		CMP R4, R8 ; já chegou à coluna final? se sim para de andar
		JZ sai_TECLADO 

		MOVB [R7], R4 ; atualiza o valor da coluna
		MOV R11, NAVE 
		CALL PINTA_IMAGEM ; desenha a nova nave

		JMP sai_TECLADO

	direita:
		MOV R7, NAVE
		MOVB R4, [R7] ; coluna da nave

		ADD R4, 1 ; adiciona 1 para andar para a direita
		MOV R8, 60
		CMP R4, R8 ; já chegou à coluna final? se sim para de andar
		JZ sai_TECLADO 
		MOVB [R7], R4 ; atualiza o valor da coluna
		MOV R11, NAVE 
		CALL PINTA_IMAGEM ; desenha a nova nave


sai_TECLADO:
	MOV R0, TECLA_ANTERIOR
	MOV [R0], R5 ; guarda a TECLA pressionada na memória 
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET


;##########################################################################;
; 								APAGA ECRA								  #;
;##########################################################################;
CHECK_SCREEN: ; R0- OBJETO
	PUSH R2

	ADD R0, 4
	MOV R2, [R0]

	MOV R1, [R2]

	POP R2
	RET

;# Apaga o ecra dado como input
;# INPUT: R1 - valor do ecra a apagar
DELETE_SCREEN:
	PUSH R0
	MOV  R0, APAGA_ECRA
	MOV  [R0], R1 ; apaga o ecra do valor de R1
	POP  R0
	RET


;##########################################################################;
; 						ROTINAS DE CONTROLO DE JOGO						  #;
;##########################################################################;
GAME_OVER_ENERGIA:
	PUSH R1

	MOV R0, APAGA_ECRAS 
	MOV [R0], R1 ; apaga todos os ecrãs

	MOV R0, PAUSA_VIDEO
	MOV R1, 0
	MOV [R0], R1

	MOV R1, 2
	MOV R0, CENARIO 
	MOV [R0], R1 ; mete o cenário 2 - derrota por energia

	MOV R1, 0
	CALL UPDATE_GAME_STATUS ; atualiza o estado do jogo para 0

	POP R1
	RET

GAME_OVER_EMBATE:
	PUSH R1

	MOV R0, APAGA_ECRAS
	MOV [R0], R1 ; apaga todos os ecrãs

	MOV R0, PAUSA_VIDEO
	MOV R1, 0
	MOV [R0], R1

	MOV R1, 3
	MOV R0, CENARIO
	MOV [R0], R1 ; mete o cenário 3 - derrota por embate

	MOV R1, 0
	CALL UPDATE_GAME_STATUS ; atualiza o estado do jogo para 0

	POP R1
	RET
;# Muda o estado do jogo 
;# INPUT: R1 - novo estado (0 ou 1)
UPDATE_GAME_STATUS:
	PUSH R0

	MOV R0, ESTADO_JOGO
	MOV [R0], R1 ; atualiza o estado do jogo

	POP R0
	RET

;# Devolve o estado do jogo
;# OUTPUT: R1 - Estado do jogo
CHECK_GAME_STATUS:
	PUSH R0

		MOV R0, ESTADO_JOGO

		MOV R1, [R0] ; verifica qual é o estado do jogo neste momento

	FIM_CHECK_GAME_STATUS:
	POP R0
	RET

CHECK_ENERGY:
	PUSH R0
	PUSH R1

	MOV R0, energia
	MOV R1, [R0]

	CMP R1, 0 ; a energia já é 0?
	JGT FIM_CHECK_ENERGY ; se não sai

	CALL GAME_OVER_ENERGIA ; a energia é 0, logo vamos terminar o jogo

	FIM_CHECK_ENERGY:
	POP R1
	POP R0
	RET


RESET_GAME:
	PUSH R0
	PUSH R1
	PUSH R10

	MOV R10, RESET_GAME_OBJETO
	CALL ITERA_OBJETOS ; RESET aos objetos

	MOV R0, NAVE 
	MOV R1, COLUNA_NAVE ; RESET da coluna da nave
	MOVB [R0], R1

	ADD R0, 1
	MOV R1, LINHA_NAVE ; RESET da linha da nave
	MOVB [R0], R1

	MOV R0, energia
	MOV R1, ENERGIA_START
	MOV [R0], R1 ; RESET a energia

	POP R10
	POP R1
	POP R0
	RET

;##########################################################################;
; 						ROTINAS DE INTERRUPCOES							  #;
;##########################################################################;

;# Rotina de int. 0 serve para atualizar a posicao dos ovnis 
ROT_INT0: ; Muda o estado dos ovnis
	PUSH R0
	PUSH R1

	MOV R1, 1

	MOV R0, ESTADOS ; estado da rotina de interrupcao 0 - ovni
	MOV [R0], R1 ; atualiza o estado para 1

	POP R1
	POP R0
	RFE

;# Rotina de int. 1 serve para atualizar a posicao do missil
ROT_INT1: 
	PUSH R0
	PUSH R1

	MOV R1, 1

	MOV R0, ESTADOS
	ADD R0, 2 ; estado da rotina de interrupcao 1 - missil

	MOV [R0], R1 ; atualiza o estado para 1

	POP R1
	POP R0
	RFE

;# Rotina de int. 2 serve para decrementar o display constantemente
ROT_INT2: 
	PUSH R0
	PUSH R1

	MOV R1, 1

	MOV R0, ESTADOS

	ADD R0, 4 ; estado da rotina de interrupcao 2 - display
	MOV [R0], R1 ; atualiza o estado para 1

	POP R1
	POP R0
	RFE


;##########################################################################;
; 						ROTINAS OBJETOS									  #;
;##########################################################################;

;# Itera todos os objetos, aplicando rotina sobre cada um (estilo map() python)
;# INPUT: R10 - Rotina a aplicar aos objetos, R9 - 0 ou 1 -> 0 Itera apenas objetos ativos, 1 itera todos
;# INPUT OPCIONAL: R8 - 89 ou 90 -> 89 itera apenas ovnis, 90 apenas asteroides
ITERA_OBJETOS:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R11

		MOV R5, FIM_OBJETOS
		SUB R5, 2
		MOV R0, OBJETOS
		SUB R0, 2

		JMP CICLO_ITERA_OBJETOS

		CICLO_ITERA_OBJETOS:
			CMP R0, R5
			JZ FIM_ITERA_OBJETOS ; Se chegou a R5 (fim dos objetos) acaba a iteracao

			INCREMENTA_2:
				ADD R0, 2 ; delta de cada endereco de objeto para com outro
			
			STEP_INCREMENTA:
			MOV R11, [R0]

			CMP R9, 1
			JZ STEP_ALL ; se R9 = 1 entao itera todos os elementos
			CALL CHECK_ESTADO
			CMP R1, 1
			JNZ STEP_ITERA_OBJETOS ; se objeto estiver inativo salta chamada de rotina

			STEP_ALL:
			CALL R10 ; Chama a rotina de input

		STEP_ITERA_OBJETOS:
			JMP CICLO_ITERA_OBJETOS

	FIM_ITERA_OBJETOS:
	POP R11
	POP R2
	POP R1
	POP R0
	RET

;# Faz RESET aos estados do objeto para o inicio do jogo
;# INPUT: R11 - Objeto
RESET_GAME_OBJETO:
	PUSH R0
	PUSH R10
	PUSH R11

		MOV R0, COLUNA_OVNI
		MOVB [R11], R0

		ADD R11, 1
		MOV R0, LINHA_OVNI
		MOVB [R11], R0

		SUB R11, 1

		MOV R0, DELTA_ESTADO
		ADD R11, R0

		CALL CHECK_IF_ASTEROIDE
		CMP R10, 1
		JZ OBJETO_ASTEROIDE

		MOV R0, 1
		MOV [R11], R0
		
		JMP FIM_RESET_GAME_OBJETO

		OBJETO_ASTEROIDE:
		MOV R0, 0
		MOV [R11], R0


	FIM_RESET_GAME_OBJETO:
	POP R11
	POP R10
	POP R0
	RET


;# Ve se um objeto de input é asteroide
;# INPUT: R11 - Objeto a testar
;# RETURN: R10 - 1 ou 0 (SE FOR ASTEROIDE 1, 0 SENAO)
CHECK_IF_ASTEROIDE:
	PUSH R0

		MOV R10, 0
		
		MOV R0, ASTEROIDE
		CMP R11, R0
		JZ CHECK_EH_ASTEROIDE

		MOV R0, ASTEROIDE2
		CMP R11, R0
		JZ CHECK_EH_ASTEROIDE

		MOV R0, ASTEROIDE3
		CMP R11, R0
		JZ CHECK_EH_ASTEROIDE

		JMP FIM_CHECK_IF_ASTEROIDE

		CHECK_EH_ASTEROIDE:
		MOV R10, 1

	FIM_CHECK_IF_ASTEROIDE:
	POP R0
	RET

;# RESETa a posicao de um objeto de input e gera um novo (podendo ser ovni ou asteroide)
;# INPUT: R11 - OBJETO 
RENEW:; R11 OBJETO 
	PUSH R0
	PUSH R1
	PUSH R10
	PUSH R11

	CALL GERADOR_OVNI_ASTEROIDE ; Devolve objeto em R10

	MOV R0, COLUNA_OVNI
	MOVB [R11], R0

	MOV R1, LINHA_OVNI
	ADD R11, 1
	MOVB [R11], R1

	MOVB [R10], R0

	ADD R10, 1
	MOVB [R10], R1

	POP R11
	POP R10
	POP R1
	POP R0
	RET

;# Ve o estado de um objeto 
;# INPUT: R11 - Objeto a testar
;# OUTPUT: R1 - (0 ou 1) Estado do objeto
CHECK_ESTADO:
	PUSH R11

	MOV R1, 8
	ADD R11, R1 ; vai para o endereco de estado

	MOV R1, [R11]

	POP R11
	RET

;# Gera um novo objeto, com um determinado tipo (ovni ou asteroide) e sentido
;# INPUT: R11 - Objeto que morreu
;# OUTPUT: R10 - Novo objeto
GERADOR_OVNI_ASTEROIDE:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5

	MOV R4, 8
	; Determinar se vai ser asteroide:
	CALL GET_RANDOM ; R1 E [0, 11]

	CMP R1, 3 ; se random for menor que tres entao e asteroide
	JGT PASSA_OVNI

	PASSA_ASTEROIDE:
		CALL CHECK_IF_ASTEROIDE
		CMP R10, 1
		JNZ EH_OVNI

		MOV R10, R11
		JMP FIM_GERADOR_OA

		EH_OVNI:
			MOV R3, OBJETOS

			CICLO_ITERAR_OBJETOS:
			MOV R2, [R3]
			ADD R3, 2

			CMP R2, R11
			JNZ CICLO_ITERAR_OBJETOS

			MOV R2, [R3] ; Asteroide correspondente

			ADD R2, R4

			MOV R3, 1
			MOV [R2], R3 ; asteroide passa a ativo
			
			ADD R2, 2
			MOV [R2], R1; Guarda a direcao que o asteroide vai tomar

			CALL DESATIVA_OBJETO

			JMP FIM_GERADOR_OA
	
	PASSA_OVNI:

		CALL CHECK_IF_ASTEROIDE
		CMP R10, 1
		JZ EH_ASTEROIDE

		MOV R10, R11 ; RETURNO DO MESMO OBJETO PQ JA E UM OVNI 
		JMP FIM_GERADOR_OA

		EH_ASTEROIDE:
			MOV R3, OBJETOS

			CICLO_ITERAR_OBJETOS2:

			MOV R2, [R3]
			ADD R3, 2
			CMP R2, R11
			JNZ CICLO_ITERAR_OBJETOS2

			SUB R3, 4
			MOV R2, [R3] ; OVNI correspondente
			MOV R10, R2

			ADD R2, R4

			MOV R3, 1
			MOV [R2], R3 ; OVNI passa a ativo
			
			ADD R2, 2
			MOV [R2], R1; Guarda a direcao que o asteroide vai tomar

			CALL DESATIVA_OBJETO

			JMP FIM_GERADOR_OA	
	
	FIM_GERADOR_OA:
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET

;# Movimenta os objetos
MOV_OBJETOS:
	PUSH R10
	PUSH R9

		MOV R1, 1
		CALL DELETE_SCREEN


		MOV R9, 0
		MOV R10, MOV_OBJETO
		CALL ITERA_OBJETOS

	POP R9
	POP R10
	RET


;# Movimenta um objeto dependendo do seu tipo e muda a sua imagem ao longo do trajeto
;# INPUT: R11 - Objeto a movimentar
MOV_OBJETO:
	PUSH R0 
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R8
	PUSH R9
	PUSH R10
	PUSH R11

	; ver o estado do ovni
	CALL CHECK_ESTADO
	CMP R1, 1 ; Testa o estado do ovni
	JNZ FIM_MOV_OBJETO

	MOV R0, R11
	
	ADD R0, 1
	MOVB R1, [R0]

	MOV R2, 5

	CMP R1, R2
	JGT MUDA2
	MOV R3, 3
	CALL MUDA_IMAGEM_OBJETO

	MUDA2:
	CMP R1, R2
	JNZ MUDA_OVNI2

	MOV R9, 1
	MOV R10, 0
	CALL CHANGE_X_OBJETO 

	MOV R3, 1
	CALL MUDA_IMAGEM_OBJETO

	MUDA_OVNI2:
		MOV R2, 10
		CMP R1, R2
		JNZ INCREMENTA_OBJETO

		MOV R9, 1
		MOV R10, 0
		CALL CHANGE_X_OBJETO 

		CALL CHECK_IF_ASTEROIDE
		CMP R10, 1
		JZ MUDA_IMAGEM_ASTEROIDE ; Se objeto for asteroide entao muda para essa imagem

		MOV R3, 2
		CALL MUDA_IMAGEM_OBJETO
		JMP INCREMENTA_OBJETO

		MUDA_IMAGEM_ASTEROIDE:
		MOV R3, 4
		CALL MUDA_IMAGEM_OBJETO

	INCREMENTA_OBJETO:
		MOV R2, 31
		CMP R1, R2 ; se passou do limite de ecra entao morre
		JNZ STEP_INCREMENTO
		;CALL GERADOR_OVNI_ASTEROIDE
		;CALL ATIVA_OBJETO
		CALL RENEW
		JMP FIM_MOV_OBJETO
		STEP_INCREMENTO:
			ADD R1, 1
			MOVB [R0], R1

			SUB R0, 1
			MOVB R2, [R0]

			MOV R9, R11
			MOV R8, 10
			ADD R9, R8
			MOV R10, [R9]

			MOV R9, 3
			CMP R10, R9
			JGT DESVIA_DIREITA

			SUB R2, 1
			MOVB [R0], R2
			JMP CENTRO
			DESVIA_DIREITA:
				MOV R9, 9
				CMP R10, R9
				JGT CENTRO

				ADD R2, 1
				MOVB [R0], R2

			CENTRO:
			MOV R2, ESTADOS
			MOV R1, 0
			MOV [R2], R1 ; Da RESET ao estado, pedido atentido


	CALL DESENHA_OBJETO
	JMP FIM_MOV_OBJETO

FIM_MOV_OBJETO:
	POP R11
	POP R10
	POP R9
	POP R8
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;# Muda a imagem de um objeto
;# INPUT: R11 - objeto 
MUDA_IMAGEM_OBJETO:;RECEBE R11 - OBJETO
	PUSH R0
	PUSH R1

	MOV R0, R11
	ADD R0, DELTA_IMAGEM

	CMP R3, 1
	JNZ ALTER_2
		MOV R1, IMAGEM_OVNI_2
		MOV [R0], R1

		JMP FIM_MUDA_OBJETO

	ALTER_2:
		CMP R3,2
		JNZ ALTER_3
		MOV R1, IMAGEM_OVNI_3
		MOV [R0], R1

		MOV R1, [R11]
		SUB R1, 2
		MOV [R11], R1

		JMP FIM_MUDA_OBJETO

	ALTER_3:
		CMP R3, 3
		JNZ ALTER_4
		MOV R1, IMAGEM_OVNI
		MOV [R0], R1
		JMP FIM_MUDA_OBJETO

	ALTER_4:

		MOV R1, [R11]
		SUB R1, 2
		MOV [R11], R1

		MOV R1, IMAGEM_ASTEROIDE
		MOV [R0], R1

FIM_MUDA_OBJETO:
	POP R1
	POP R0
	RET

;# Altera o X de um objeto
;# INPUT: R11 - Objeto, R9- valor, R10 - 1 incrementa, 0 decrementa
CHANGE_X_OBJETO:
	PUSH R0

		MOVB R0, [R11]

		CMP R10, 1
		JNZ DECREMENTA_X

		ADD R0, R9

		JMP FIM_CHANGE_X

		DECREMENTA_X:
		SUB R0, R9

		FIM_CHANGE_X:

		MOVB [R11], R0

	POP R0
	RET


;# Desativa um objeto
;# INPUT: R11 - Objeto a desativar
DESATIVA_OBJETO:
	PUSH R0
	PUSH R1
	PUSH R2

		MOV R1, 8 		; delta de endereco de objeto ao seu estado 
		MOV R2, 0

		MOV R0, R11
		ADD R0, R1

		MOV [R0], R2

		MOV R1, 1 		; estado = 1

	POP R2
	POP R1
	POP R0
	RET

;# Ativa um objeto
;# INPUT: R11 - Objeto a ativar
ATIVA_OBJETO:
	PUSH R0
	PUSH R1
	PUSH R2

		MOV R2, 8		; delta de endereco de objeto ao seu estado 
		MOV R1, 1

		MOV R0, R11
		ADD R0, R2		; endereco de estado de ovni

		MOV [R0], R1 	; ativa o ovni

	POP R2
	POP R1
	POP R0
	RET

;# Desenha um objeto 
;# INPUT: R11 - Objeto
DESENHA_OBJETO:
	PUSH R0
	PUSH R1

		MOV R0, R11
		MOV R1, 8
		ADD R0, R1

		MOV R1, [R0]
		MOV R0, 1
		CMP R1, 1
		JNZ FIM_DESENHA_OBJETO


		CALL PINTA_IMAGEM

FIM_DESENHA_OBJETO:
	POP R1
	POP R0
	RET

;##########################################################################;
; 						ROTINAS MISSIL								      #;
;##########################################################################;

;# Ativa o missil
ATIVA_MISSIL:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R9

		MOV R0, MISSIL

		ADD R0, 6
		MOV R1, [R0]
		CMP R1, 1 ; Verifica se o missil ja esta ativo
		JZ FIM_ATIVA_MISSIL

		MOV R3, 5
		MOV R9, 0
		CALL ALTERAR_DISPLAY ; Diminui o display em 5 valores quando dispara

		MOV R0, SOM
		MOV R1, 1
		MOV [R0], R1

		MOV R0, MISSIL
		MOV R1, NAVE	

		MOVB R2, [R1] ; Vai buscar o X da nave
		ADD R2, 2 ; ajusta o missil ao centro da nave
		MOVB [R0], R2 ; novo X do missil

		ADD R1, 1
		ADD R0, 1

		MOVB R2, [R1] ; Vai buscar o Y da nave
		SUB R2, 2 ; ajusta o missil a ponta da nave
		MOVB [R0], R2 ; novo Y do missil

		ADD R0, 5
		MOV R2, 1
		MOV [R0], R2 ; muda o estado do missel para ativo

FIM_ATIVA_MISSIL:
	POP R9
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;# Desativa o missil
DESATIVA_MISSIL:
	PUSH R0
	PUSH R1

	MOV R0, MISSIL

	MOV  R1, COLUNA_MISSIL 
	MOVB [R0], R1 ; RESET a coluna do missil
	ADD R0, 1

	MOV R1, LINHA_MISSIL
	MOVB [R0], R1 ; RESET a coluna do missil

	ADD R0, 5 ; Movimenta para o endereco de estado do missil

	MOV R1, 0
	MOV [R0], R1 ; Estado do missil = 0

	MOV R1, 2
	CALL DELETE_SCREEN ; Apaga o missil do ecra

	POP R1
	POP R0
	RET

;# Movimenta o missil
MOV_MISSIL:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3

		MOV R2, MISSIL
		ADD R2, 6
		MOV R3, [R2] ; endereco do estado do missil

		CMP R3, 1 ; testa se o missel esta ativo
		JNZ FIM_MOV_MISSIL ; se nao estiver nao muda a posicao

		MOV R1, 2
		CALL DELETE_SCREEN

			MOV R0, MISSIL
			ADD R0, 1
			MOVB R1, [R0]


			MOV R2, MISSIL_LIMITE ; Limite Y do missil
			CMP R1, R2
			JNZ INCREMENTA_MISSIL

			LIMITE_MISSIL:
				MOV R2, MISSIL
				ADD R2, 6
				MOV R3, [R2] ; endereco do estado do missil

				CALL DESATIVA_MISSIL ; desativa o missil
				JMP FIM_MOV_MISSIL

			INCREMENTA_MISSIL:
				SUB R1, 1
				MOVB [R0], R1 ; incrementa o Y do missil

			CALL DISPARA_MISSIL

	FIM_MOV_MISSIL:
		MOV R2, ESTADOS
		ADD R2, 2
		MOV R1, 0
		MOV [R2], R1 ; Da RESET ao estado, pedido atentido

	POP R3
	POP R2
	POP R1
	POP R0
	RET

;# Dispara o missil
DISPARA_MISSIL:
	PUSH R11
	PUSH R0
	PUSH R1 ; estado do missil

		MOV R11, MISSIL
		MOV R0, R11
		ADD R0, 6 ; Endereco de estado do missil

		MOV R1, [R0] ; estado do missil

		CMP R1, 1
		JNZ FIM_DISPARA_MISSIL ; se o missil nao tiver estado = 1 entao nao é pintado

		CALL PINTA_IMAGEM

FIM_DISPARA_MISSIL:
	POP R1
	POP R0
	POP R11
	RET



;##########################################################################;
; 						ROTINA ESTADOS									  #;
;##########################################################################;

;# itera sobre os estados 
CICLO_ESTADOS:
	PUSH R0 ; endereco ESTADOS
	PUSH R1	; variavel estado
	PUSH R2	; serve para percorrer os enderecos
	PUSH R3

	MOV R0, ESTADOS
	MOV R2, 0

	CICLO1:
		MOV R1, [R0]
		CMP R1, 1 ; o estado é 1?
		JNZ	UPDATE_CICLO ; se não for passamos ao próximo
		CALL CHAMA_ROT_ESTADOS 
		MOV R3, 0 
		MOV [R0], R3 ; atualiza o estado para 0, porque a rotina já aconteceu

	UPDATE_CICLO:
		ADD R0, 2 ; passa a ler o próximo estado da rotina seguinte
		ADD R2, 1 
		CMP R2, 3 ; já lemos o estado das 3 rotinas?
		JNZ CICLO1 ; se sim terminamos, se não voltamos a fazer o ciclo pelos estados	
	
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;# Chama a rotina de um estado
;# INPUT: R2 - estado
CHAMA_ROT_ESTADOS:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R9

		MOV R0, ROT_ESTADOS
		SHL R2, 1 ; multiplica R2 por 2 para lermos as rotinas
		ADD R0, R2 ; R2 indica qual a rotina que deve ser lida. Primeiro 0, depois 2, depois 4

		MOV R1, [R0]

		MOV R0, ALTERAR_DISPLAY
		CMP R1, R0
		JNZ CHAMA_ROT

		MOV R3, 5
		MOV R9, 0

		CHAMA_ROT:
		CALL R1 ; chama a rotina que tem o estado a 1

	POP R9
	POP R3
	POP R2
	POP R1
	POP R0
	RET


;##########################################################################;
; 						ROTINAS COLISOES								  #;
;##########################################################################;

;# Verifica se ha colisoes entre objetos
CHECK_COLISOES:
	PUSH R0
	PUSH R1
	PUSH R11
	PUSH R10

		MOV R10, COLISAO_MISSIL_OBJETO
		MOV R9, 0
		CALL ITERA_OBJETOS

		MOV R10, COLISAO_OBJETO_NAVE
		CALL ITERA_OBJETOS

	FIM_CHECK_COLISOES:
	POP R10
	POP R11
	POP R1
	POP R0
	RET

;# Verifica se ha colisao entre dois objetos, muda o estado de colisao
;# INPUT: R0, R1 - Objetos. R6 - Off-set entre os dois objetos
HA_COLISAO:; Recebe 2 objetos (R0 e R1), um off-set(R6)
	PUSH R2 ; X de R0
	PUSH R3 ; Y de R0
	PUSH R4 ; X de R1
	PUSH R5 ; Y de R1
	PUSH R7
	PUSH R8

	MOVB R2, [R0] ; Vai buscar o X de R0

	ADD R0, 1
	MOVB R3, [R0] ; Vai buscar o Y de R0

	MOVB R4, [R1] ; Vai buscar o X de R1

	ADD R1, 1
	MOVB R5, [R1] ; Vai buscar o Y de R1

	MOV R8, R4
	ADD R4, R6 ; adiciona o off-set ao X de R1
	SUB R8, R6

	CMP R2, R4 ; testa de X(R0) = X(R1)
	JGT FIM_HA_COLISAO


		MOV R7, MISSIL
		SUB R0, 1
		CMP R0, R7 ; Ve se R0 e missil ou nao
		JNZ STEP_COLISAO

		SUB R1, 1	

		MOVB R4, [R1]
		CMP R2, R4	; se for missil o off-set nao se aplica para a esquerda do outro objeto
		JLT FIM_HA_COLISAO
		JMP STEP_COLISAO2
	STEP_COLISAO:

		CMP R2, R8
		JLT FIM_HA_COLISAO
		
		STEP_COLISAO2:
			ADD R5, 4
			CMP R3, R5 ; testa de Y(R0) = Y(R1)
			JGT FIM_HA_COLISAO
		
			; Se chegou aqui entao ha colisao!

			MOV R3 , 1
			MOV R2, COLISAO ; Atualiza o estado da colisao
			MOV [R2], R3

	FIM_HA_COLISAO:
	POP R8
	POP R7
	POP R5
	POP R4
	POP R3
	POP R2
	RET

;# Muda o estado de colisao para 0
RESET_ESTADO_COLISAO:
	PUSH R0
	PUSH R1

		MOV R0, COLISAO
		MOV R1, 0
		MOV [R0], R1 ; Muda o estado da colisao para 0

	POP R1
	POP R0
	RET

;# Verifica se ha colisao entre missil e objeto
;# INPUT: R11 - Objeto
COLISAO_MISSIL_OBJETO:
	PUSH R0
	PUSH R1
	PUSH R6
	PUSH R7

		;check do estado do ovni
		CALL CHECK_ESTADO
		CMP R1, 1
		JNZ FIM_COLISAO_MISSIL_OBJETO ; se ovni n estiver ativo entao nao pode haver colisoes

		MOV R7, R11
		MOV R0, MISSIL
		MOV R1, R11

		CALL RESET_ESTADO_COLISAO
		MOV R6, OFFSET_OVNI
		CALL HA_COLISAO

		MOV R0, COLISAO
		MOV R1, [R0] ; Obtem o estado da colisao

		MOV R0, 1
		CMP R1, R0
		JNZ FIM_COLISAO_MISSIL_OBJETO ; Se nao houver colisao salta para o fim da rotina

		; Desativa o missil e atualiza explosao
		MOV R0, ASTEROIDE
		CMP R0, R11
		JZ STEP_COLISAO_M_O

		MOV R9, 1
		MOV R3, 5
		CALL ALTERAR_DISPLAY

		STEP_COLISAO_M_O:
		CALL HA_EXPLOSAO
		CALL UPDATE_EXPLOSAO
		CALL RENEW
		CALL DESATIVA_MISSIL
		CALL RESET_ESTADO_COLISAO

	FIM_COLISAO_MISSIL_OBJETO:
	POP R7
	POP R6
	POP R1
	POP R0
	RET

;# Verifica se ha colisao entre nave e objeto
;# INPUT: R11 - Objeto
COLISAO_OBJETO_NAVE:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R6
	PUSH R7
	PUSH R10

		;check do estado do ovni
		CALL CHECK_ESTADO
		CMP R1, 1
		JNZ FIM_COLISAO_OBJETO_NAVE ; se ovni n estiver ativo entao nao pode haver colisoes

		MOV R0, NAVE
		MOV R1, R11

		CALL RESET_ESTADO_COLISAO
		MOV R6, OFFSET_OVNI ; off-set de 4
		CALL HA_COLISAO

		MOV R0, COLISAO
		MOV R1, [R0]
		MOV R0, 1
		CMP R1, R0
		JNZ FIM_COLISAO_OBJETO_NAVE

		CALL CHECK_IF_ASTEROIDE
		MOV R2, 1
		CMP R10, R2
		JZ COLISAO_COM_ASTEROIDE

		; Acaba o jogo
		CALL RESET_ESTADO_COLISAO
		CALL GAME_OVER_EMBATE
		JMP FIM_COLISAO_OBJETO_NAVE

		COLISAO_COM_ASTEROIDE:
		; Aumentar energia
		CALL RESET_ESTADO_COLISAO
		CALL RENEW
		MOV R0, SOM
		MOV R1, 3
		MOV [R0], R1
		MOV R3, 10
		MOV R9, 1 ; Vai aumentar energia
		CALL ALTERAR_DISPLAY
	
	FIM_COLISAO_OBJETO_NAVE:
	POP R10
	POP R7
	POP R6
	POP R2
	POP R1
	POP R0
	RET

;##########################################################################;
; 						    ROTINA EXPLOSAO						          #;
;##########################################################################;

;# Cria uma explosao nas coord de um objeto
;# R11 - Objeto
HA_EXPLOSAO:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3

		MOV R0, R11
		MOV R1, EXPLOSAO

		MOVB R2, [R0]  ; X do míssil
		MOVB [R1], R2  ; novo X da explosao

		ADD R0, 1
		ADD R1, 1
		MOVB R3, [R0]  ; Y do míssil
		MOVB [R1], R3  ; novo Y da explosao

		MOV R0, SOM
		MOV R1, 2
		MOV [R0], R1

		CALL UPDATE_EXPLOSAO

	POP R3
	POP R2
	POP R1
	POP R0
	RET

;# Atualiza o estado da explosao que serve simultaneamente 
;# para indicar o numero de frames que resta a uma explosao
UPDATE_EXPLOSAO:
	PUSH R0
	PUSH R1
	PUSH R2

		MOV R2, FRAMES_EXPLOSAO

		MOV R0, EXPLOSAO
		ADD R0, 6 ; endereco de estado/frames da explosao (frames em que mostra a explosao)

		MOV R1, [R0]
		ADD R1, R2

		MOV [R0], R1

	POP R2
	POP R1
	POP R0
	RET
	
;# Desenha a explosao
DESENHO_EXPLOSAO:
	PUSH R0
	PUSH R1
	PUSH R11

		MOV R0, EXPLOSAO
		ADD R0, 6

		MOV R1, [R0]

		CMP R1, 0
		JNZ PINTA_EXPLOSAO ; Se a explosao nao estiver ativa entao salta para o final da rotina

		MOV R1, 3
		CALL DELETE_SCREEN
		JMP FIM_DESENHO_EXPLOSAO

		PINTA_EXPLOSAO:
		MOV R11, EXPLOSAO
		CALL PINTA_IMAGEM

		SUB R1, 1 
		MOV [R0], R1 ; decrementa o estado da explosao

	FIM_DESENHO_EXPLOSAO:
	POP R11
	POP R1
	POP R0
	RET

;##########################################################################;
; 						    ROTINAS DISPLAY						          #;
;##########################################################################;

;# Converte um numero hexadecimal em decimal para o display
CONVERSOR_HEXA_DEC:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV R0, energia
	MOV R1, [R0]
	CMP R1, 0 ; a energia já chegou a 0?
	JLE DISPLAY_A_ZERO ; se sim saímos

	MOV R0, 100
	CMP R1, R0 ; já atingimos 100% de energia?
	JLE	VALORES_DIVISAO ; se não continuamos a dar update ao display

	MOV R1, 100

	VALORES_DIVISAO:
	MOV R3, FATOR
	MOV R6, [R3] ; valor do Fator (1000)
	MOV R5, 10 ; número que vai dividir pelo fator
	MOV R2, 0

	CONVERTE:
	MOD R1, R6 ; obtém o número sem o primeiro algarismo
	DIV R6, R5 ; divide o fator da divisão por 10
	MOV R4, R1 ; cópia do número
	DIV R4, R6 ; obtém o primeiro dígito do número
	SHL R2, 4 ; 4 bits para a esquerda para começar a formar o número
	OR  R2, R4 ; resultado
	CMP R6, 1 ; o fator já chegou a 1?
	JNZ CONVERTE ; se não continuamos a converter
	JMP ATUALIZA_DISPLAY; se sim atualizamos o display

	DISPLAY_A_ZERO:
	MOV R2, 0
	; atualiza os displays

	ATUALIZA_DISPLAY:
	MOV R0, DISPLAYS	
	MOV [R0], R2 ; mete o valor decimal no display	 
	
	FIM_CONVERSOR:
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

;# Muda o valor do display
;# INPUT: R3 - valor, R9 - 1 para incrementar, 0 para decrementar
ALTERAR_DISPLAY:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3

		MOV R0, energia
		MOV R1, [R0] ; energia atual 

		CMP R9, 0
		JNZ AUMENTAR_DISPLAY ; se R9 = 1 entao incrementa

		SUB R1, R3 ; decrementa o valor de input na energia
		JMP APLICAR_ALTER 

		AUMENTAR_DISPLAY:
		ADD R1, R3 ; incrementa o valor de input na energia

		MOV R2, 100
		CMP R1, R2
		JLE APLICAR_ALTER ; Se R1 for maior que 100 entao fica a 100

		MOV R1, 100 

		APLICAR_ALTER:
		MOV [R0], R1 ; aplica a alteracao e tem-se um novo valor de energia

		CALL CONVERSOR_HEXA_DEC

		CALL CHECK_ENERGY ; verifica se a energia já é 0, para não diminuir mais


	POP R3
	POP R2
	POP R1
	POP R0
	RET

;##########################################################################;
; 						    ROTINAS RNG						              #;
;##########################################################################;

;# Ciclo de numeros entre 0 e 11 que aumenta quando chamado
;# Serve para calcular probabilidades de 1/3 e 1/4 ja que 12 é o minimo multiplo comum entre 3 e 4
MAKE_RANDOM:
	PUSH R0
	PUSH R1
	PUSH R2

		MOV R0, RANDOM
		MOV R1, [R0] ; obtem o valor do nr random atual
		
		MOV R2, 11
		CMP R1, R2
		JNZ STEP_RANDOM ; se ja for 11 entao leva RESET para 0

		MOV R1, 0

		MOV [R0], R1
		JMP FIM_MAKE_RANDOM

		STEP_RANDOM:
			ADD R1, 1
			
			MOV [R0], R1 ; adiciona 1 ao nr random

	FIM_MAKE_RANDOM:
	POP R2
	POP R1
	POP R0
	RET

;# Devolve um nr random 
;# OUTPUT: R1 - nr random
GET_RANDOM: 
	PUSH R0

	MOV R0, RANDOM ; Acede a nr random
	MOV R1, [R0] ; devolve o nr

	POP R0
	RET

; ############## Game Launch Date To Be Announced ##############