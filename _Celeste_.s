##########################################################################
# � [x] Movimenta��o
#	� [x] Andar esquerda (a)
#	� [x] Andar direita (d)
#	� [x] Pular (w)
#	� [x] Pular esquerda (q)
#	� [x] Pular direita (e)
#	� [x] Dash cima (W ou Shift + w)
#	� [x] Dash direita (A ou Shift + a)
#	� [x] Dash diagonal direita (Q ou Shift + q)
#	� [x] Dash esquerda (D ou Shift + d)
#	� [x] Dash diagonal esquerda (Q ou Shift + q)
#
##########################################################################
# o jogo come�a com uma tela de loading que toca um trecho de m�sica
# na tela de menu aperte "f" para come�ar o jogo e logo em seguida
# aperte "f" para prosseguir os di�logos.
##########################################################################

# ============================= INLCUDES =============================== # 
.include "MACROSv21.s"
.include "_game_lib.s"
.include "_movement.s"
# ====================================================================== #

.data
.include "andar_0.data"

.text
MAIN:	
	frame(0)
	loading()

# MENU --------------------------------------------------------------------------- #
	menu()			# Printa o menu.
	li s0, MMIO_ctrl		# s0 recebe o endere�o onde o bit de controle do teclado est� armazenado.
	sw zero, 0(s0)		# Limpa o bit de controle, evitando que qualquer tecla pressionada antes da execu��o seja interpretada.
	li t2, 0x66		# t2 recebe o valor ASCII de 'f'.

MENU_LOOP:			
	lb t1, 0(s0)		# t1 recebe o bit de controle (1 = teclado quer mandar um dado, 0 = teclado n�o quer mandar um dado).
	beqz t1, MENU_LOOP	# Reinicia o loop caso t1 = 0 (caso o teclado n�o queira mandar nenhum dado).
	li a0, MMIO_buf		# a0 recebe o endere�o onde o valor ASCII da tecla pressionada est� guardado.
	lw a0, 0(a0)		# Instru��o necess�ria para que o dado n�o se perca.
				# a0 cont�m o valor ASCII do caractere agora.
	beq a0, t2, FIM_MENU	# Caso o caractere seja igual a 'f', sai do menu.
	j MENU_LOOP		# Loop infinito at� que 'f' seja pressionado.
FIM_MENU:

# CENA1 --------------------------------------------------------------------------- #
	cena1()			# Printa a cena 1.
	li s0, MMIO_ctrl		# s0 recebe o endere�o onde o bit de controle do teclado est� armazenado.
	sw zero, 0(s0)		# Limpa o bit de controle, evitando que qualquer tecla pressionada antes da execu��o seja interpretada.
	li t2, 0x66		# t2 recebe o valor ASCII de 'f'.

CENA1_LOOP:			
	lb t1, 0(s0)		# t1 recebe o bit de controle (1 = teclado quer mandar um dado, 0 = teclado n�o quer mandar um dado).
	beqz t1, CENA1_LOOP	# Reinicia o loop caso t1 = 0 (caso o teclado n�o queira mandar nenhum dado).
	li a0, MMIO_buf		# a0 recebe o endere�o onde o valor ASCII da tecla pressionada est� guardado.
	lw a0, 0(a0)		# Instru��o necess�ria para que o dado n�o se perca.
				# a0 cont�m o valor ASCII do caractere agora.
	beq a0, t2, FIM_CENA1	# Caso o caractere seja igual a 'f', sai da cena 1.
	j CENA1_LOOP		# Loop infinito at� que 'f' seja pressionado.
FIM_CENA1:

# CENA2 --------------------------------------------------------------------------- #
	cena2()			# Printa a cena 2.
	li s0, MMIO_ctrl		# s0 recebe o endere�o onde o bit de controle do teclado est� armazenado.
	sw zero, 0(s0)		# Limpa o bit de controle, evitando que qualquer tecla pressionada antes da execu��o seja interpretada.
	li t2, 0x66		# t2 recebe o valor ASCII de 'f'.

CENA2_LOOP:			
	lb t1, 0(s0)		# t1 recebe o bit de controle (1 = teclado quer mandar um dado, 0 = teclado n�o quer mandar um dado).
	beqz t1, CENA2_LOOP	# Reinicia o loop caso t1 = 0 (caso o teclado n�o queira mandar nenhum dado).
	li a0, MMIO_buf		# a0 recebe o endere�o onde o valor ASCII da tecla pressionada est� guardado.
	lw a0, 0(a0)		# Instru��o necess�ria para que o dado n�o se perca.
				# a0 cont�m o valor ASCII do caractere agora.
	beq a0, t2, FIM_CENA2	# Caso o caractere seja igual a 'f', sai do cena 2.
	j CENA2_LOOP		# Loop infinito at� que 'f' seja pressionado.
FIM_CENA2:

# JOGO COME�A ---------------------------------------------------------------------------- #
	li s10 12		# s10 recebe o valor da coluna onde se quer imprimir.
	li s11 130		# s11 recebe o valor da linha onde se quer imprimir.
	li s7 2
	andar(s10, s11)		# Chama a anima��o incial de andar.
	li a7 30
	ecall
	mv s5 a0
	li s4 1			#In�cio do tempo
POOL_LOOP:
	get_time(s5)
	lb t1, 0(s0)		# t1 recebe o bit de controle (1 = teclado quer mandar um dado, 0 = teclado n�o quer mandar um dado).
	beqz s4 J_VITORIA
	beqz s7 J_DERROTA
	j PULEI
J_VITORIA: j VITORIA
	 j PULEI
J_DERROTA: j DERROTA
PULEI:	beqz t1, POOL_LOOP	# Reinicia o loop caso t1 = 0 (caso o teclado n�o queira mandar nenhum dado).
	li a0, MMIO_buf		# a0 recebe o endere�o onde o valor ASCII da tecla pressionada est� guardado.
	lw a0, 0(a0)		# Instru��o necess�ria para que o dado n�o se perca.
				#a0 cont�m o valor ASCII do caractere agora.
	acao(a0,s10,s11)		# Chama o macro que executa a anima��o de acordo com a tecla pressionada.
	j POOL_LOOP		# Loop infinito do teclado.

VITORIA:
	vitoria()
	j EXIT
DERROTA:
	derrota()
EXIT:
	syscall(EXIT1)		# Finaliza a execu��o do programa.

.include "SYSTEMv21.s"
