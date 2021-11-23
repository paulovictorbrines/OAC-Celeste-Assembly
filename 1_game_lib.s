# ------------------------------------------------------------------------------------------- #
#  Biblioteca com todos os macros e constantes/equivalências necessárias utilizadas no game!  #
# ------------------------------------------------------------------------------------------- #

#============================================================================== #
# 			CONSTANTES / EQUIVALÊNCIAS			 	#
#============================================================================== #

# Boolean
.eqv TRUE 1
.eqv FALSE 0

# Ecall Codes
.eqv PRINT_INT 1
.eqv PRINT_FLOAT 2
.eqv PRINT_STRING 4
.eqv PRINT_CHAR 11
.eqv EXIT1 10
.eqv EXIT2 93
.eqv OPEN_FILE 1024
.eqv READ_FILE 63
.eqv CLOSE_FILE 57
.eqv SLEEP 32
.eqv TIME 30
.eqv MIDI 33

# Keybord MMIO
.eqv MMIO_buf 0xff200004 	# Data (Endereço do Buffer, onde o valor ASCII da tecla pressionada está)
.eqv MMIO_ctrl 0xff200000 	# Control (valor Booleano, indica se houve tecla pressionada)


#============================================================================== #
# 				MACROS		        		 	#
#============================================================================== #

# SYSCALL ----------------------------------------------------- #
# Chama a syscall de acordo com a operação.
.macro syscall(%operation)
	li a7, %operation
	ecall
.end_macro
# ------------------------------------------------------------- #

# PRINT FULL IMG ---------------------------------------------- #
# Printa uma imagem completa no display.
.macro print_full_img0(%file_name)
.data
FILE:	.string %file_name

.text
# Abre o arquivo
	la a0, FILE		# Passa a label com o nome do arquivo a ser aberto.
	li a1,0			# Indica a leitura de um arquivo.
	li a2,0			# Indica um arquivo binário.
	syscall(OPEN_FILE)	# Chama a syscall e a0 recebe o descritor do arquivo.
	
	mv t0, a0		# Salva o descritor em t0.

# Le o arquivos para a memoria VGA
	li a1, 0xFF000000	# Endereço onde os bytes lidos do arquivo serão escritos.
	li a2, 76800		# Quantidade de bytes a serem lidos.
	syscall(READ_FILE)	# Lê o arquivo e retorna em a0 o comprimento.
	
#Fecha o arquivo
	mv a0, t0		# a0 recebe novamente o descritor.
	syscall(CLOSE_FILE)	# Fecha o arquivo.
.end_macro
# ------------------------------------------------------------- #

.macro print_full_img1(%file_name)
.data
FILE:	.string %file_name

.text
# Abre o arquivo
	la a0, FILE		# Passa a label com o nome do arquivo a ser aberto.
	li a1,0			# Indica a leitura de um arquivo.
	li a2,0			# Indica um arquivo binário.
	syscall(OPEN_FILE)	# Chama a syscall e a0 recebe o descritor do arquivo.
	
	mv t0, a0		# Salva o descritor em t0.

# Le o arquivos para a memoria VGA
	li a1, 0xFF100000	# Endereço onde os bytes lidos do arquivo serão escritos.
	li a2, 76800		# Quantidade de bytes a serem lidos.
	syscall(READ_FILE)	# Lê o arquivo e retorna em a0 o comprimento.
	
#Fecha o arquivo
	mv a0, t0		# a0 recebe novamente o descritor.
	syscall(CLOSE_FILE)	# Fecha o arquivo.
.end_macro


# PRINT_SPRITE ------------------------------------------------ #
# Printa uma sprite na posição desejada.
.macro print_sprite0(%coluna,%linha,%file_adress)
.data

.text
	la a0 %file_adress	#a0 endereço da imagem
	lw t0 0(a0)		#numero de colunas
	lw t1 4(a0)		#numero de linhas
	mul a2 t0 t1		#tamanho imagem
	li t1 0x140
	mul t1 t1 %linha		#multiplica 0x140 por linha
	add t1 t1 %coluna	#soma coluna ao valor de cima
	li a1 0xff000000
	add a1 t1 a1		#soma o valor de cima ao endereço da tela, endereço onde será printado sprite
	li t1 0			#contador 1
	li t2 0			#contador 2
	addi a0 a0 8
LOOP:
	beq t1 a2 DONE		#se o contador 1 for igual ao tamanho da img vai para DONE
	lw t3 0(a0)		#carrega a word da imagem
	sw t3 0(a1)		#coloca word no endereço calculado acima
	addi a0 a0 4
	addi a1 a1 4
	addi t1 t1 4
	addi t2 t2 4
	blt t2 t0 LOOP		#verifica se t2 esta do tamanho da largura da img
	li t2 0x140		#0x140 equivale a uma linha no bitmap display
	sub t2 t2 t0		#subtrai 0x140-colunas para alinhamento
	add a1 a1 t2		#soma t2 ao endereço do bitmap
	li t2 0			#zera o contador2
	j LOOP

DONE:
.end_macro

.macro print_sprite1(%coluna,%linha,%file_adress)
.data

.text
	la a0 %file_adress	#a0 endereço da imagem
	lw t0 0(a0)		#numero de colunas
	mv a5 t0
	lw t1 4(a0)		#numero de linhas
	mul a2 t0 t1		#tamanho imagem
	li t1 0x140
	mul t1 t1 %linha		#multiplica 0x140 por linha
	add t1 t1 %coluna	#soma coluna ao valor de cima
	li a1 0xff100000
	add a1 t1 a1		#soma o valor de cima ao endereço da tela, endereço onde será printado sprite
	li t1 0			#contador 1
	li t2 0			#contador 2
	addi a0 a0 8
LOOP:
	beq t1 a2 DONE		#se o contador 1 for igual ao tamanho da img vai para DONE
	lw t3 0(a0)		#carrega a word da imagem
	sw t3 0(a1)		#coloca word no endereço calculado acima
	addi a0 a0 4
	addi a1 a1 4
	addi t1 t1 4
	addi t2 t2 4
	blt t2 t0 LOOP		#verifica se t2 esta do tamanho da largura da img
	li t2 0x140		#0x140 equivale a uma linha no bitmap display
	sub t2 t2 t0		#subtrai 0x140-colunas para alinhamento
	add a1 a1 t2		#soma t2 ao endereço do bitmap
	li t2 0			#zera o contador2
	j LOOP

DONE:
.end_macro

.eqv frame_selec 0xff200604

.macro frame(%int)
	li t0 %int
	li t1 frame_selec
	sw t0 0(t1)
	
.end_macro


# posiçãoI
#.eqv colunaI 272#
#.eqv linhaI 174
# PRINT ALL --------------------------------------------------- #
.macro refresh(%alive,%frame)
.data
.include "_teste.data"
.text
	li t0 %frame
	beqz t0 FRAME0
	print_full_img1("cenario_1.bin")
	beqz %alive DEAD
	li t5 colunaI
	li t6 linhaI
	#print_sprite1(t5, t6, _teste)
	#addi t5 t5 -16
	#print_sprite1(t5, t6, _teste)
	j DEAD
	
FRAME0:	print_full_img0("cenario_1.bin")
	beqz %alive DEAD
	#print_sprite0(t5, t6, _teste)
DEAD:
.end_macro


# ------------------------------------------------------------- #
.macro get_time(%prev_time)
.data
QUEBRA: .string "\n"
.text
	syscall(TIME)
	mv t0 a0
	sub t1 t0 %prev_time
	add s6 s6 t1
	li t2 1000
	mv s5 a0
	blt s6 t2 EXIT
	mv s6 zero
	addi s4 s4 +1
	mv a0 s4
	li a1, 140
	li a2, 10
	li a3, 0x000000FF
	li a4, 0
	syscall(101)
EXIT:
	
.end_macro 


# MENU -------------------------------------------------------- #
# Exibe o menu na tela e lê uma tecla para dar inicio ao game.

.macro loading()
.data
NOTAS: .word 72,612,74,612,76,612,81,612,73,612,79,306,77,306,76,612,72,612,69,612,77,306,76,306,74,612,69,612,67,612,79,306,77,306,76,612,72,306,73,306,72,612,74,612,76,612,81,612,71,612,79,306,77,306,76,612,72,612,69,612,77,306,76,306,74,612,69,612,67,612,79,306,77,306,76,612,72,306,73,306
.text
	print_full_img0("loading.bin")
	li s1 30
	la s0 NOTAS
	li t0 0
	li a2,45		
	li a3,127
LOOP:	beq t0 s1 EXIT
	lw a0 0(s0)
	lw a1 4(s0)
	syscall(MIDI)
	addi s0 s0 8
	addi t0 t0 1
	j LOOP
EXIT:
.end_macro
.text
	la s0,NUM		# define o endereço do número de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,NOTAS		# define o endereço das notas
	li t0,0			# zera o contador de notas
	li a2,68			# define o instrumento
	li a3,127		# define o volume

LOOP:	beq t0,s1, FIM		# contador chegou no final? então  vá para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31			# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a duração da nota para a pausa
	li a7,32			# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endereço da próxima nota
	addi t0,t0,1		# incrementa o contador de notas
	j LOOP			# volta ao loop

# MENU ------------------------------------------------------------ #
.macro menu()
	print_full_img0("menu.bin")
.end_macro

# CENA2 ------------------------------------------------------------ #
.macro menu1()
	print_full_img0("menu.bin")
.end_macro	

# CENA2 ------------------------------------------------------------ #
.macro menu1()
	print_full_img0("menu.bin")
.end_macro	



# VITÓRIA ------------------------------------------------------------ #
.macro vitoria()
.data
#Tamanho:41
NOTAS: .word 67,270,71,270,67,270,72,811,76,811,74,1893,67,270,71,270,67,270,76,811,74,811,71,1893,67,270,71,270,67,270,60,817,60,272,60,545,59,272,60,272,60,545,60,272,60,272,60,545,62,545,59,545,59,272,60,272,60,545,59,272,60,272,60,545,60,272,60,272,60,545,59,545,60,545,60,272,60,272,60,545,59,545,60,545,60,272,60,272,60,545,62,545,59,545,60,272,60,272,60,545,59,545,60,545,60,272,60,272,60,545,59,545
.text
	frame(0)
	print_full_img0("morte_rocklee.bin")
	li s1 41
	la s0 NOTAS
	li t0 0
	li a2,68
	li a3,127
LOOP:	beq t0 s1 EXIT
	#print_full_img0("morte_rocklee.bin")
	lw a0 0(s0)
	lw a1 4(s0)
	syscall(MIDI)
	addi s0 s0 8
	addi t0 t0 1
	j LOOP
EXIT:
.end_macro

# DERROTA ------------------------------------------------------------ #
.macro derrota()
.data
#Tamanho:41
NOTAS: .word 67,270,71,270,67,270,72,811,76,811,74,1893,67,270,71,270,67,270,76,811,74,811,71,1893,67,270,71,270,67,270,60,817,60,272,60,545,59,272,60,272,60,545,60,272,60,272,60,545,62,545,59,545,59,272,60,272,60,545,59,272,60,272,60,545,60,272,60,272,60,545,59,545,60,545,60,272,60,272,60,545,59,545,60,545,60,272,60,272,60,545,62,545,59,545,60,272,60,272,60,545,59,545,60,545,60,272,60,272,60,545,59,545
.text
	frame(0)
	print_full_img0("derrota_1.bin")
	li s1 41
	la s0 NOTAS
	li t0 0
	li a2,68
	li a3,127
LOOP:	beq t0 s1 EXIT
	print_full_img1("derrota_1.bin")
	lw a0 0(s0)
	lw a1 4(s0)
	syscall(MIDI)
	addi s0 s0 8
	addi t0 t0 1
	j LOOP
EXIT:
.end_macro
	
	

# ESPINHOS ------------------------------------------------------------ #
# posição espinhos
.eqv coluna_espinhos1 138 #184-42
.eqv coluna_espinhos2 184

.macro colisao_espinhos(%char_column)
	mv t2 %char_column
#CONDICAO1:
	li t0 coluna_espinhos1
	bge t2 t0 CONDICAO2
	j EXIT
	
CONDICAO2:
	li t0 coluna_espinhos2
	ble t2 t0 COLISAO
	j EXIT
COLISAO:
	addi s7 s7 -1
EXIT:
.end_macro

# BURACO ------------------------------------------------------------ #
# posição buraco
.eqv coluna_buraco1 230 #272-42
.eqv coluna_buraco2 272 

.macro colisao_buraco(%char_column)
	mv t2 %char_column
#CONDICAO1:
	li t0 coluna_buraco1
	bge t2 t0 CONDICAO2
	j EXIT
	
CONDICAO2:
	li t0 coluna_buraco2
	ble t2 t0 COLISAO
	j EXIT
COLISAO:
	addi s7 s7 -1
EXIT:
.end_macro

# CHEGOU NO FINAL DA TELA? ------------------------------------------------------------ #
.macro final_tela(%char_column)
	li t3 280 #248 + 32
	mv t4 %char_column
	bge t4 t3 FINAL
	j EXIT
FINAL:
	li s4 -1
EXIT:
.end_macro
