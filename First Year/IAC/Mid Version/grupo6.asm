; **********************************************************************
; * AUTORES:
; * - Alexandre Corte 99048
; * - Jeronimo Mendes 99086
; * - Joao Marques 99092
; **********************************************************************
;
; **********************************************************************
; * INSTRUCOES
; **********************************************************************
;
;	Tecla 1 sobe o valor no display a cada click
;	Tecla 2 desce o valor no display a cada click
;	Tecla 3 sobe o valor no display continuamente enquanto estiver premida
;	Tecla 4 desce o valor no display continuamente enquanto estiver premida
;
; **********************************************************************
; * Constantes
; **********************************************************************

DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 8       ; linha a testar (4ª linha, 1000b)


; **********************************************************************


PLACE 2000H
TABLE 200H		; Reserva o espaco para a pilha	
sp_start:

CONTADOR: WORD 0	; Variavel que vai servir para delay da acao dos botoes premidos
PONTOS: WORD 0		; Valor em hexa do display



PLACE 0000H
MOV SP, sp_start			; inicializa o SP

MOV R0, DISPLAYS 			; endereco do periferico do display
MOV R1, TEC_LIN				; endereco do periferico das linhas
MOV R2, TEC_COL				; endereco do periferico das colunas

MOV R7, 0      				; inicar o contador

MOV R5, 0					; endereco para limpar o display
MOV [R0], R5				; limpa o display ao iniciar o programa

reset:
	MOV R3, LINHA			; voltar para a quarta linha (R3 = 8)
	MOV R4, CONTADOR		; aceder ao endereco do delay	


ciclo:
	MOVB [R1], R3 			; R3 = Linha
	MOVB R4, [R2] 			; R4 = Coluna

	CMP R4, 0				; tecla premida?
	JNZ converter_tecla		; se sim entao jump para saber qual a tecla

	SHR R3, 1 				; Testar proxima linha
	JZ reset				; se chegou a primeira linha entao leva reset
	JMP ciclo				
	
converter_tecla:
	MOV R5, 0               ; R5 = Valor da tecla
	MOV R6, R3				; R6 = linha carregada

; Conversao para o nr de tecla entre 0 e FH
converter_tecla_lin:
	SHR R3, 1 					; desloca os bits para a direita ate ficar a zero
	JZ  converter_tecla_mul		; Se zero entao vamos para a formula de conversao
	ADD R5, 1					; R5 vai tomar o valor hexadecimal da linha
	JMP converter_tecla_lin		; volta ao loop de converter a linha

; Formula de conversao: 4 * linha + coluna
converter_tecla_mul: 		
	MOV R3, 4					; 4 * linha
	MUL R5, R3 					; Calcular Offset linha

converter_tecla_col:
	SHR R4, 1 					; desloca os bits para a direita ate ficar a zero
	JZ  tecla_1					; Se zero entao vai testar a tecla em tecla_1
	ADD R5, 1					; (4 * linha(ja calculado)) + coluna
	JMP converter_tecla_col		; volta ao loop de converter a coluna

tecla_1:
	CMP R5, 1					; tecla premida equivale a 1?
	JNE tecla_2					; senao salta para tecla_2 e testa\

	; Limitador de Pontos (0 <= PONTOS <= 100)
	MOV R9, 100					; R9 vai ser o nosso limitador (0 ou 100)
	MOV R4, PONTOS				; R4 fica com o endereco de PONTOS
	MOV R8, [R4]				; Le os PONTOS e guarda em r8
	CMP R8, R9					; PONTOS atingiu o limite?
	JZ  ha_tecla				; Se sim entao nao aumento nem os pontos nem o display


	MOV R4, PONTOS				; R4 = endereco de pontos
	MOV R7, [R4]				; R7 valor temporario para incrementar os pontos
	ADD R7, 1					; incrementacao de R7
	MOV [R4], R7				; escrever a subida de valor na memoria de PONTOS
	JMP update_display			; faz update ao display

tecla_2:
	CMP R5,2					; tecla premida equivale a 2?	
	JNE tecla_3					; senao salta para tecla_3 e testa

	; Limitador de Pontos (0 <= PONTOS <= 100)	
	MOV R9, 0
	MOV R4, PONTOS
	MOV R8, [R4]
	CMP R8, R9
	JZ  ha_tecla

	MOV R4, PONTOS				; R4 = endereco de pontos
	MOV R7, [R4]				; R7 valor temporario para decrementar os pontos
	SUB R7, 1					; decrementacao de R7
	MOV [R4], R7				; escrever a descida de valor na memoria de PONTOS
	JMP update_display			; faz update ao display

tecla_3:
	
	CMP R5, 3					; tecla premida equivale a 3?	
	JNE tecla_4					; senao salta para tecla_4 e testa

	; Limitador de Pontos (0 <= PONTOS <= 100)	
	MOV R9, 100
	MOV R4, PONTOS
	MOV R8, [R4]
	CMP R8, R9
	JZ  ha_tecla

	; Inicio do delay
	MOV R4, CONTADOR			; R4 = endereco de contador	
	MOV R8, [R4]				; R8 assume o valor do contador
	ADD R8, 1					; incrementa R8 em 1
	MOV [R4], R8				; Escreve o valor de R8 em contador
	MOV R10, 500				; endereco que vai servir para verificar se o contador chegou ao final(500)
	CMP R8, R10					; R8 chegou ao final?
	JNE ha_tecla				; Senao salta para ha_tecla
	MOV R10, 0					; R10 vai servir para dar reset ao contador
	MOV [R4], R10				; Mudar contador para 0 (reset)
	
	MOV R4, PONTOS
	MOV R7, [R4]				; R7 valor temporario para incrementar os pontos
	ADD R7, 1					; incrementacao de R7
	MOV [R4], R7				; escrever a subida de valor na memoria de PONTOS
	JMP update_display			; faz update ao display

tecla_4:
	
	CMP R5, 4					; tecla premida equivale a 3?
	JNE ha_tecla				; senao salta para o ha_tecla
	
	; Limitador de Pontos (0 <= PONTOS <= 100)
	MOV R9, 0
	MOV R4, PONTOS
	MOV R8, [R4]
	CMP R8, R9
	JZ  ha_tecla

	; delay igual ao de tecla_3
	MOV R4, CONTADOR
	MOV R8, [R4]
	ADD R8, 1
	MOV [R4], R8
	MOV R10, 500
	CMP R8, R10
	JNE ha_tecla
	MOV R10, 0
	MOV [R4], R10
		
	MOV R4, PONTOS				; 
	MOV R7, [R4]				; R7 valor temporario para decrementar os pontos
	SUB R7, 1					; decrementacao de R7
	MOV [R4], R7				; escrever a descida de valor na memoria de PONTOS
	JMP update_display			; faz update ao display

update_display:
	CALL conversor_hexa_dec		; chama rotina conversor_hexa_dec
	JMP ha_tecla

ha_tecla:						; neste ciclo espera-se ate nenhuma tecla estar premida
	MOVB [R1], R6				; escrever no periferico de saida (linhas)
	MOVB R4, [R2]				; ler do periferico de entrada (colunas)

	CMP R4, 0 					; Nenhuma tecla a ser premida?
	JZ reset					; Se sim salta para o reset
	CMP R5, 3					; tecla 3 continua premida?
	JZ tecla_3					; se sim volta para o ciclo de 3 ja que queremos um update continuo do display
	CMP R5, 4					; tecla 4 continua premida?
	JZ tecla_4					; se sim volta para o ciclo de 4 ja que queremos um update continuo do display 
	JMP ha_tecla				; se ainda houver uma tecla premida, espera ate nao haver

; **************************************************************************
; * conversor_hexa_dec
; * Descrição: Atualiza display com nr decimais, convertendo de hexadecimal
; *	Entradas: PONTOS 
; *	Saidas:	Nao tem
; **************************************************************************

conversor_hexa_dec:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	
	MOV R0, PONTOS	; R0 = endereco de pontos
	MOV R1, [R0]	; R1 = valor hexaadecimal de pontos
	
	MOV R3, R1		; R3 serve como copia de R1 para calcular unidades
	MOV R2, 10		; R2 = 10 que vai servir para dividir os valores
	
	MOD R3, R2		; Guarda o algarismo das unidades em R3
	DIV R1, R2		; Remove o ultimo algarismo de R1
	
	MOV R4, R1		; R4 serve como copia de R1 para calcular dezenas 
	MOD R4, R2		; Guarda o algarismo das dezenas em R4
	
	DIV R1, R2		; Guarda o algarismo das centenas em R1	
	
	; Formacao do numero -> Fica no registo R4
	SHL R4, 4		; Transforma o algarismo de R4 num valor de dezenas
	SHL R1, 8		; Transforma o algarismo de R1 num valor de centenas
	OR R4, R1		; |
	OR R4, R3		; --> R4 ganha forma do decimal em hexadecimal (123h --> 123 no display)
	
	; atualiza os displays
	MOV R0, DISPLAYS	
	MOV [R0], R4		 
	
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

