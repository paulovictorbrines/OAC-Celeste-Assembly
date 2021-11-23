# ANIMAÇÕES

#ALIVE

# ASCII
.eqv um 49
.eqv a 97
.eqv c 99
.eqv d 100
.eqv e 101
.eqv g 103
.eqv q 113
.eqv w 119
.eqv x 120
.eqv z 122
.eqv s 115
.eqv W 87
.eqv E 69
.eqv A 65
.eqv C 67
.eqv Q 81
.eqv Z 90
.eqv X 88
.eqv D 68

# ------------------------- AÇÕES ----------------------------- #

.macro andar(%l, %c)
	refresh(s7,0)
	frame(1)
	print_sprite0(%l, %c, andar_1)
	li a0, 300
	syscall(SLEEP)
	refresh(s7,1)
	frame(0)
.end_macro

.macro acao(%char, %prev.column, %prev.line)
.data
.include "andar_1.data"
.include "andar_2.data"
.include "andar_3.data"
.include "pulo_1.data"
.include "pulo_2.data"
.include "pulo_4.data"

.text
# Executa o movimento de acordo com a tecla pressionada.
	li t0 a
	beq %char t0 J_ACAO_a
	li t0 q
	beq %char t0 J_ACAO_q
	li t0 w
	beq %char t0 J_ACAO_w
	li t0 e
	beq %char t0 J_ACAO_e
	li t0 d
	beq %char t0 J_ACAO_d
	li t0 W
	beq %char t0 J_ACAO_W
	li t0 E
	beq %char t0 J_ACAO_E
	li t0 A
	beq %char t0 J_ACAO_A
	li t0 Q
	beq %char t0 J_ACAO_Q
	li t0 D
	beq %char t0 J_ACAO_D	
	j EXIT

J_ACAO_a: j ACAO.a
J_ACAO_q: j ACAO.q
J_ACAO_w: j ACAO.w	
J_ACAO_e: j ACAO.e
J_ACAO_d: j ACAO.d
J_ACAO_W: j ACAO.W
J_ACAO_E: j ACAO.E
J_ACAO_A: j ACAO.A
J_ACAO_Q: j ACAO.Q
J_ACAO_D: j ACAO.D

	
			
ACAO.a:	# ANDAR ESQUERDA ------------------------------------------------- #
	refresh(s7,0)
	addi %prev.column %prev.column -4
	print_sprite0(%prev.column, %prev.line, andar_1)
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	refresh(s7,1)
	frame(0)
	addi %prev.column %prev.column -4
	print_sprite1(%prev.column, %prev.line, andar_2)

	refresh(s7,0)
	frame(1)
	addi %prev.column %prev.column -4
	print_sprite0(%prev.column, %prev.line, andar_3)

	refresh(s7,1)
	frame(0)
	addi %prev.column %prev.column -4
	print_sprite1(%prev.column, %prev.line, andar_2)
	refresh(s7,0)
	frame(1)

	j EXIT
	
ACAO.d: # ANDAR DIREITA --------------------------------------------------- #
	refresh(s7,0)
	addi %prev.column %prev.column 4
	print_sprite0(%prev.column, %prev.line, andar_1)
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	refresh(s7,0)
	addi %prev.column %prev.column 4
	print_sprite0(%prev.column, %prev.line, andar_2)
	
	refresh(s7,0)
	addi %prev.column %prev.column 4
	print_sprite0(%prev.column, %prev.line, andar_3)

	refresh(s7,0)
	addi %prev.column %prev.column 4
	print_sprite0(%prev.column, %prev.line, andar_2)
	
	j EXIT	
	
ACAO.w: # PULAR ------------------------------------------------------------ #
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_1)
	li a0, 125
	syscall(SLEEP)
	refresh(s7, 0)

	addi %prev.line, %prev.line, -30
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 77
	li a1, 500
	li a2, 0
	li a3, 100
	li a7, 31
	ecall
	li a0, 175
	syscall(SLEEP)
	refresh(s7, 0)

	print_sprite0(%prev.column, %prev.line, pulo_3)
	li a0, 50
	li a1, 1000
	li a2, 127
	li a3, 100
	li a7, 31
	ecall
	
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 150
	syscall(SLEEP)
	addi %prev.line, %prev.line, 30
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	j EXIT
	
ACAO.q: # PULAR ESQUERDA ---------------------------------------------- #
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_1)
	li a0, 125
	syscall(SLEEP)
	refresh(s7, 0)
	addi %prev.column, %prev.column, -36
	addi %prev.line, %prev.line, -30
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 77
	li a1, 500
	li a2, 0
	li a3, 100
	li a7, 31
	ecall
	li a0, 175
	syscall(SLEEP)
	refresh(s7, 0)
	addi %prev.column, %prev.column, -36
	print_sprite0(%prev.column, %prev.line, pulo_3)
	li a0, 50
	li a1, 1000
	li a2, 127
	li a3, 100
	li a7, 31
	ecall
	
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 150
	syscall(SLEEP)
	addi %prev.line, %prev.line, 30
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	j EXIT

ACAO.e: # PULAR DIREITA ------------------------------------------------------ #
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_1)
	li a0, 125
	syscall(SLEEP)
	refresh(s7, 0)
	addi %prev.column, %prev.column, 36
	addi %prev.line, %prev.line, -30
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 77
	li a1, 500
	li a2, 0
	li a3, 100
	li a7, 31
	ecall
	li a0, 175
	syscall(SLEEP)
	refresh(s7, 0)
	addi %prev.column, %prev.column, 36
	print_sprite0(%prev.column, %prev.line, pulo_3)
	li a0, 50
	li a1, 1000
	li a2, 127
	li a3, 100
	li a7, 31
	ecall
	
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 150
	syscall(SLEEP)
	addi %prev.line, %prev.line, 30
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	j EXIT

ACAO.W: # DASH CIMA ------------------------------------------------------ #
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_1)
	li a0, 125
	syscall(SLEEP)
	refresh(s7, 0)
	
	addi %prev.line, %prev.line, -120
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 77
	li a1, 500
	li a2, 0
	li a3, 100
	li a7, 31
	ecall
	li a0, 175
	syscall(SLEEP)
	refresh(s7, 0)

	print_sprite0(%prev.column, %prev.line, pulo_3)
	li a0, 50
	li a1, 1000
	li a2, 127
	li a3, 100
	li a7, 31
	ecall
	
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 150
	syscall(SLEEP)
	addi %prev.line, %prev.line, 120
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	j EXIT

ACAO.D: # DASH DIREITA ------------------------------------------------------- #
	refresh(s7,0)
	addi %prev.column %prev.column 16
	print_sprite0(%prev.column, %prev.line, andar_1)
	
	#check_collision(%prev.column, %prev.line, a5)
	
	refresh(s7,0)
	addi %prev.column %prev.column 16
	print_sprite0(%prev.column, %prev.line, andar_1)
	
	refresh(s7,0)
	addi %prev.column %prev.column 16
	print_sprite0(%prev.column, %prev.line, andar_1)
	
	refresh(s7,0)
	addi %prev.column %prev.column 16
	print_sprite0(%prev.column, %prev.line, andar_1)
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	j EXIT	

ACAO.E:	# DASH DIAGONAL DIREITA ---------------------------------------------- #
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_1)
	li a0, 125
	syscall(SLEEP)
	refresh(s7, 0)
	addi %prev.column, %prev.column, 60
	addi %prev.line, %prev.line, -120
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 77
	li a1, 500
	li a2, 0
	li a3, 100
	li a7, 31
	ecall
	li a0, 175
	syscall(SLEEP)
	refresh(s7, 0)
	addi %prev.column, %prev.column, 60
	print_sprite0(%prev.column, %prev.line, pulo_3)
	li a0, 50
	li a1, 1000
	li a2, 127
	li a3, 100
	li a7, 31
	ecall
	
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_2)
	li a0, 150
	syscall(SLEEP)
	addi %prev.line, %prev.line, 120
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	j EXIT

ACAO.A: # DASH ESQUERDA ------------------------------------------------------ #
	refresh(s7,0)
	addi %prev.column %prev.column -16
	print_sprite0(%prev.column, %prev.line, andar_1)

	refresh(s7,0)
	addi %prev.column %prev.column -16
	print_sprite0(%prev.column, %prev.line, andar_1)
	
	refresh(s7,0)
	addi %prev.column %prev.column -16
	print_sprite0(%prev.column, %prev.line, andar_1)
	
	refresh(s7,0)
	addi %prev.column %prev.column -16
	print_sprite0(%prev.column, %prev.line, andar_1)
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	j EXIT

ACAO.Q:	# DASH DIAGONAL ESQUERDA --------------------------------------------------- #
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_1)
	li a0, 125
	syscall(SLEEP)
	refresh(s7, 0)
	addi %prev.column, %prev.column, -32
	addi %prev.line, %prev.line, -120
	print_sprite0(%prev.column, %prev.line, pulo_1)
	li a0, 77
	li a1, 500
	li a2, 0
	li a3, 100
	li a7, 31
	ecall
	li a0, 175
	syscall(SLEEP)
	refresh(s7, 0)
	addi %prev.column, %prev.column, -32
	print_sprite0(%prev.column, %prev.line, pulo_1)
	li a0, 50
	li a1, 1000
	li a2, 127
	li a3, 100
	li a7, 31
	ecall

	li a0, 200
	syscall(SLEEP)
	refresh(s7, 0)
	print_sprite0(%prev.column, %prev.line, pulo_1)
	li a0, 150
	syscall(SLEEP)
	addi %prev.line, %prev.line, 120
	
	colisao_espinhos(%prev.column)
	colisao_buraco(%prev.column)
	final_tela(%prev.column)
	
	j EXIT

EXIT:
	refresh(s7,0)
	print_sprite0(%prev.column, %prev.line, andar_1)
	refresh(s7,1)
	frame(0)

.end_macro

