.data
	bienvenida2: .asciiz "Para jugar, ingrese el número en el tablero que está distribuido de la siguiente manera.\n"
	
	fila1: .asciiz "  X | 2 | 3 \n"
	fila2: .asciiz "  4 | 5 | 6 \n"
	fila3: .asciiz "  7 | 8 | 9 \n"
	divisor: .asciiz "|-----------|\n"
	numeros: .asciiz " 123456789"
	
	turno: 	.asciiz "-> Es el turno del jugador O.\n" 		
	finalAnalisis: 	.asciiz "Final del analisis\n" 				
	turnoComputador: 	.asciiz "-> Es el turno de la computadora . . .\n" 					
	perdedor: .asciiz "-> El jugador   ganó el juego !!!\n" 				# modificar posición 14.
	_posicionOcupada: .asciiz "[!] Error: La posicion   está ocupada...\n" 			# modificar posición 23.
	_posicionInvalida: .asciiz "[!] Error: Posición inválida [1-9] ...\n"
        _empate: .asciiz "-> Juego terminado - Empate.\n"
        _preguntarNuevoJuego: .asciiz "¿Quiere volver a jugar? 1 para volver a jugar - Cualquier otro numero para no\n"

	borrar: .byte '-'
	computadorX: .asciiz "X"
	computador: .byte 'X'
	jugador: .byte 'O'
	
	turnoActual: .asciiz "O" # empieza el jugador O siempre haciendo ref. a que X es la máquina

.text
.globl main


main:
		# Cargando las cadenas de caracteres en registros, para luego poder imprimirlas. Es como un apuntador que "apunta" hacia una cadena de caraceteres, son 7:

		la $s0, turno # en el registro $s0 carga lo que está en "turno"
		la $s1, fila1 # en el registro $s1 carga lo que está en "fila1"
		la $s2, fila2 # en el registro $s2 carga lo que está en "fila2"
		la $s3, fila3 # en el registro $s3 carga lo que está en "fila3"
		la $s5, turnoActual # en el registro $s5 carga lo que está en "turnoactual"
		la $s6, computadorX # en el registro $s6 carga lo que está en "computadorX"
		la $s7, numeros # en el registro $s7 carga lo que está en "numeros"
		
		li $t1, 0 	# $t1 es la variable de TURNO: Cuando está en 0, es el turno del jugador X (computador) y cuando está en 1 es del jugador O (Persona).

		lb $a1, jugador
		sb $a1, 27($s0) # en el registro $a1 guarda lo que hay en la posición $27 de la cadena de caraceteres $s0.
				# la cadena de caracteres $s0, es un apuntador a Turno. y la posición 27 de esta cadena, hace referencia a la 'X' o a la 'O' según corresponda el jugador
				# entonces, cuando cambie el turno de un jugador, lo que se debe hacer es cambiar la posición 27 de esta cadena, para así cuando se imprima
				# se sabe cuál es el jugador que tiene el turno.

		li $v0, 4
		la $a0, bienvenida2 # imprimiendo la bienvenida al juego.
		syscall
		
		li $t9, 1 # registro $t9: en este registro (variable) se almacenará el número de veces que han jugado. Si llega a 9, significa empate.
		li $t2, 3 # registro $t2: puntos para el jugador X
		li $t3, 5 # registro $t3: puntos para el jugador O
		li $t4, 0 # registro $t4: es una variable temporal donde se irá comprobando el ganador por fila / columna / diagonal 
		
		# explicación de cómo se comprueba si alguien gano, esto se hace mediante puntos.
		# Se irá recorriendo cada fila / columna / diagonal, y cada vez que se encuentre una 'X' en el tablero, a la variable temporal $t4 se sumará lo que esté en $t2.
		# en $t2 estarán los puntos correspondientes para el jugador X, que para este caso es 5 (línea 54).
		
		# y en $t3, estarán los puntos que corresponden para el jugador O, que para este caso es 3 (línea 55).
		# entonces: mientras se recorren cada línea / columna / diagonal, si se encuntra una 'X' se va sumando 5, y si se encuentra una 'O' se va sumando 3.
		# esto quiere decir, que si encuentra que hay tres 'X' en una fila, es decir, si variable al final tiene un valor de 9, significa que ganó el jugador X
		# y si tiene tres 'O' (que la variable valga 15) significa que ganó el jugador 'O'.
		
		li $t7, 1
		li $t5, 0 # bandera de juegoAzar
		
		j imprimirTablero

limpiarFilas: # lo que hace esta función es limpiar todas las filas.
		lb $a1, 2($s7)
		sb $a1, 6($s1)
		
		lb $a1, 3($s7)
		sb $a1, 10($s1)
		
		lb $a1, 4($s7)
		sb $a1, 2($s2)
		
		lb $a1, 5($s7)
		sb $a1, 6($s2)
		
		lb $a1, 6($s7)
		sb $a1, 10($s2)
		
		lb $a1, 7($s7)
		sb $a1, 2($s3)
		
		lb $a1, 8($s7)
		sb $a1, 6($s3)
		
		lb $a1, 9($s7)
		sb $a1, 10($s3)
		
		j main # luego de limpiar las filas, llama a la función main.
		
imprimirTablero: # esta función imprime el tablero.

		li $v0, 4
		la $a0, divisor # imprime la fila de divisor
		syscall
		
		li $v0, 4
		la $a0, fila1 # imprime la fila 1
		syscall
		
		li $v0, 4
		la $a0, fila2 # imprime la fila 2
		syscall
		
		li $v0, 4
		la $a0, fila3 # imprime la fila 3
		syscall
		
		li $v0, 4
		la $a0, divisor # imprime el divisor
		syscall
		
		j comprobarGanador # acá luego de imprimir el tablero, llama a la función de comprobar el ganador.
		
posicionOcupada: # función de posicionOcupada: 

		sb $s4, 23($s6) # carga en el registro $s4 lo que hay en la posición 23 del registro $s6.
		li $v0, 4
		la $a0, _posicionOcupada # imprime que hay una posición ocupada.
		syscall
		
		beq $t7, 2, jugarAzar # acá compara si el registro $t7 es igual a 2, lo que hará es llamar a la función jugarAzar.
		beq $t7, 4, jugarAzar
		beq $t7, 6, jugarAzar
		beq $t7, 8, jugarAzar
		
		j jugar

posicionInvalida: # si la posición es inválida, es decir, que cuando el jugador ingrese una posición menor a 1 o mayor a 9, imprime que es inválida y llama a la función jugar.
		li $v0, 4
		la $a0, _posicionInvalida
		syscall
		j jugar

jugar1:	# de acá en adelante, hay 9 funciones iguales. esta función, jugar1, hace referencia a que el jugador indicó que quería poner su ficha en la posición 1.
	# y así será igual para las 9 posiciones y por eso hay 9 funciones. solamente voy a comentarles esta para que vean cómo funciona, de acá en adelante
	# son iguales las sig 9.
	
		lb $a1, 2($s1) # en el registro $a1, guardará lo que hay en la posición 2 del registro $s1. El registro $s1, es la cadena de caracteres que tiene la fila1.
		lb $a2, computador # en el registro $a2, se va a guardar la 'X' que corresponde al turno del computador.
		
		beq $a1, $a2, posicionOcupada # acá comprueba, si lo que hay en el registro $a1 (es decir, la primera posición de la fila) es igual a X, quiere decir que está ocupada.
		lb $a2, jugador # ahora, en $s2 carga la 'O' del jugador.
		beq $a1, $a2, posicionOcupada # vuelve a comprobar, pero ahora valida si en la fila hay una 'O', en caso de que la haya, llamará la función de posición ocupada.
		
		lb $a1, 0($s5) # en el registro $a1 se va a cargar el turno actual (que es $s5).
		sb $a1, 2($s1) # y acá lo que hará, es que en la fila 1 posición 1, se va a guardar el turno del jugador actual. Es decir, va a marcar el "movimiento" que acaba de hcaer el jugador o computador.
		
		add $t7, $t7, 1 # se añade un UNO a la variable $t1.
		
		lb $a1, turnoActual
		#sb $a1, 27($s0)
		
		j imprimirTablero # se imprime el tablero.
		
# función igual a la de jugar1....
jugar2:		
		lb $a1, 6($s1)
		lb $a2, computador
		
		beq $a1, $a2, posicionOcupada
		lb $a2, jugador
		beq $a1, $a2, posicionOcupada
		
		lb $a1, 0($s5)
		sb $a1, 6($s1)
		
		add $t7, $t7, 1
		
		lb $a1, turnoActual
		#sb $a1, 27($s0)
		
		j imprimirTablero
jugar3:		
		lb $a1, 10($s1)
		lb $a2, computador
		
		beq $a1, $a2, posicionOcupada
		lb $a2, jugador
		beq $a1, $a2, posicionOcupada
		
		lb $a1, 0($s5)
		sb $a1, 10($s1)
		
		add $t7, $t7, 1

		lb $a1, turnoActual
		#sb $a1, 27($s0)
		
		j imprimirTablero

jugar4:		
		lb $a1, 2($s2)
		lb $a2, computador
		
		beq $a1, $a2, posicionOcupada
		lb $a2, jugador
		beq $a1, $a2, posicionOcupada
		
		lb $a1, 0($s5)
		sb $a1, 2($s2)
		
		add $t7, $t7, 1

		lb $a1, turnoActual
		#sb $a1, 27($s0)
		
		j imprimirTablero
jugar5:		
		lb $a1, 6($s2)
		lb $a2, computador
		
		beq $a1, $a2, posicionOcupada
		lb $a2, jugador
		beq $a1, $a2, posicionOcupada
		
		lb $a1, 0($s5)
		sb $a1, 6($s2)
		
		add $t7, $t7, 1
		
		lb $a1, turnoActual
		#sb $a1, 27($s0)
		
		j imprimirTablero
		
jugar6:		
		lb $a1, 10($s2)
		lb $a2, computador
		
		beq $a1, $a2, posicionOcupada
		lb $a2, jugador
		beq $a1, $a2, posicionOcupada
		
		lb $a1, 0($s5)
		sb $a1, 10($s2)
		
		add $t7, $t7, 1
		
		lb $a1, turnoActual
		#sb $a1, 27($s0)
		
		j imprimirTablero
		
jugar7:		
		lb $a1, 2($s3)
		lb $a2, computador
		
		beq $a1, $a2, posicionOcupada
		lb $a2, jugador
		beq $a1, $a2, posicionOcupada
		
		lb $a1, 0($s5)
		sb $a1, 2($s3)
		
		add $t7, $t7, 1
		
		lb $a1, turnoActual
		#sb $a1, 27($s0)
		
		j imprimirTablero
		
jugar8:		
		lb $a1, 6($s3)
		lb $a2, computador
		
		beq $a1, $a2, posicionOcupada
		lb $a2, jugador
		beq $a1, $a2, posicionOcupada
		
		lb $a1, 0($s5)
		sb $a1, 6($s3)
		
		add $t7, $t7, 1
		
		lb $a1, turnoActual
		#sb $a1, 27($s0)
		
		j imprimirTablero
		
jugar9:		
		lb $a1, 10($s3)
		lb $a2, computador
		
		beq $a1, $a2, posicionOcupada
		lb $a2, jugador
		beq $a1, $a2, posicionOcupada
		
		lb $a1, 0($s5)
		sb $a1, 10($s3)
		
		add $t7, $t7, 1
		
		lb $a1, turnoActual
		#sb $a1, 27($s0)
		
		j imprimirTablero
		
jugar: # esta es la funcion principal. cada que un jugador hace un movimiento, se llama esta función.
	# PARA EL JUGADOR.
		lb $a0, jugador
		sb $a0, 0($s5)
		beq $t7, 9, empate
		li $v0, 4
		la $a0, turno
		syscall

		li $v0, 5
		syscall
		move $s4, $v0 # en $s4 se guarda la posición en la que el jugador (la persona) quiere poner la 'O'.
		
		beq $s4, 1, jugar1
		beq $s4, 2, jugar2
		beq $s4, 3, jugar3
		beq $s4, 4, jugar4
		beq $s4, 5, jugar5
		beq $s4, 6, jugar6
		beq $s4, 7, jugar7
		beq $s4, 8, jugar8
		beq $s4, 9, jugar9
		
		j posicionInvalida
		
comprobarGanador: # esta es la función que comprueba el ganador.
		li $v0, 0 # booleano

		# aquí toca siempre comprobar diagonal, antidiagonal
		# filas y columnas
		# son todas las posibles combinaciones para ganador
		
		# filas
				
		lb $a1, 2($s1) # posición 1 de la fila
		lb $a2, 6($s1) # posición 2 de la fila 
		lb $a3, 10($s1) # posición 3 de la fila
		
		seq $v0, $a1, $a2
		seq $t0, $a2, $a3
		add $v0, $v0, $t0
		beq $v0, 2, juegoTerminado
		
		lb $a1, 2($s2)
		lb $a2, 6($s2)
		lb $a3, 10($s2)
		
		seq $v0, $a1, $a2
		seq $t0, $a2, $a3
		add $v0, $v0, $t0
		beq $v0, 2, juegoTerminado
		
		lb $a1, 2($s3)
		lb $a2, 6($s3)
		lb $a3, 10($s3)
		
		seq $v0, $a1, $a2
		seq $t0, $a2, $a3
		add $v0, $v0, $t0
		beq $v0, 2, juegoTerminado
		
		# columnas
		
		lb $a1, 2($s1)
		lb $a2, 2($s2)
		lb $a3, 2($s3)
		
		seq $v0, $a1, $a2
		seq $t0, $a2, $a3
		add $v0, $v0, $t0
		beq $v0, 2, juegoTerminado
		
		lb $a1, 6($s1)
		lb $a2, 6($s2)
		lb $a3, 6($s3)
		
		seq $v0, $a1, $a2
		seq $t0, $a2, $a3
		add $v0, $v0, $t0
		beq $v0, 2, juegoTerminado
		
		lb $a1, 10($s1)
		lb $a2, 10($s2)
		lb $a3, 10($s3)
		
		seq $v0, $a1, $a2
		seq $t0, $a2, $a3
		add $v0, $v0, $t0
		beq $v0, 2, juegoTerminado

		# diag
		
		lb $a1, 2($s1)
		lb $a2, 6($s2)
		lb $a3, 10($s3)
		
		seq $v0, $a1, $a2
		seq $t0, $a2, $a3
		add $v0, $v0, $t0
		beq $v0, 2, juegoTerminado
		
		# antidiag
		
		lb $a1, 10($s1)
		lb $a2, 6($s2)
		lb $a3, 2($s3)
		
		seq $v0, $a1, $a2
		seq $t0, $a2, $a3
		add $v0, $v0, $t0
		beq $v0, 2, juegoTerminado
				
		beq $t7, 2, jugarComputador
		beq $t7, 4, jugarComputador
		beq $t7, 6, jugarComputador
		beq $t7, 8, jugarComputador
		
		j jugar
		
jugarFila1:
		lb $a1, 2($s1)
		lb $a2, 6($s1)
		lb $a3, 10($s1)
		
		lb $a0, 1($s7)
		beq $a1, $a0, jugar1
		lb $a0, 2($s7)
		beq $a2, $a0, jugar2
		lb $a0, 3($s7)
		beq $a3, $a0, jugar3

jugarFila2:
		lb $a1, 2($s2)
		lb $a2, 6($s2)
		lb $a3, 10($s2)
		
		lb $a0, 4($s7)
		beq $a1, $a0, jugar4
		lb $a0, 5($s7)
		beq $a2, $a0, jugar5
		lb $a0, 6($s7)
		beq $a3, $a0, jugar6

jugarFila3:
		lb $a1, 2($s3)
		lb $a2, 6($s3)
		lb $a3, 10($s3)
		
		lb $a0, 7($s7)
		beq $a1, $a0, jugar7
		lb $a0, 8($s7)
		beq $a2, $a0, jugar8
		lb $a0, 9($s7)
		beq $a3, $a0, jugar9
		
jugarColumna1:
		lb $a1, 2($s1)
		lb $a2, 2($s2)
		lb $a3, 2($s3)
		
		lb $a0, 1($s7)
		beq $a1, $a0, jugar1
		lb $a0, 4($s7)
		beq $a2, $a0, jugar4
		lb $a0, 7($s7)
		beq $a3, $a0, jugar7

jugarColumna2:
		lb $a1, 6($s1)
		lb $a2, 6($s2)
		lb $a3, 6($s3)
		
		lb $a0, 2($s7)
		beq $a1, $a0, jugar2
		lb $a0, 5($s7)
		beq $a2, $a0, jugar5
		lb $a0, 8($s7)
		beq $a3, $a0, jugar8
		
jugarColumna3:
		lb $a1, 10($s1)
		lb $a2, 10($s2)
		lb $a3, 10($s3)
		
		lb $a0, 3($s7)
		beq $a1, $a0, jugar3
		lb $a0, 6($s7)
		beq $a2, $a0, jugar6
		lb $a0, 9($s7)
		beq $a3, $a0, jugar9
		
jugarDiagonal:
		lb $a1, 2($s1)
		lb $a2, 6($s2)
		lb $a3, 10($s3)
		
		lb $a0, 1($s7)
		beq $a1, $a0, jugar1
		lb $a0, 5($s7)
		beq $a2, $a0, jugar5
		lb $a0, 9($s7)
		beq $a3, $a0, jugar9
		
jugarAntiDiagonal:
		lb $a1, 10($s1)
		lb $a2, 6($s2)
		lb $a3, 2($s3)
		
		lb $a0, 3($s7)
		beq $a1, $a0, jugar3
		lb $a0, 5($s7)
		beq $a2, $a0, jugar5
		lb $a0, 7($s7)
		beq $a3, $a0, jugar7
		
jugarAzar:
		j jugarAzar2
		
jugarAzar2:
		lb $a0, 6($s1)
		lb $a1, 2($s7)
		
		bne $a0, $a1, jugarAzar4
		j jugar2

jugarAzar4:
		lb $a0, 2($s2)
		lb $a1, 4($s7)
		
		bne $a0, $a1, jugarAzar5
		j jugar4

jugarAzar5:
		lb $a0, 6($s2)
		lb $a1, 5($s7)
		
		bne $a0, $a1, jugarAzar3
		j jugar5

jugarAzar3:
		lb $a0, 10($s1)
		lb $a1, 3($s7)
		
		bne $a0, $a1, jugarAzar7
		j jugar3

jugarAzar7:
		lb $a0, 2($s1)
		lb $a1, 7($s7)
		
		bne $a0, $a1, jugarAzar9
		j jugar7

jugarAzar9:
		lb $a0, 10($s3)
		lb $a1, 9($s7)
		
		bne $a0, $a1, jugarAzar6
		j jugar9
		
jugarAzar6:
		lb $a0, 10($s2)
		lb $a1, 6($s7)
		
		bne $a0, $a1, jugarAzar8
		j jugar6
		
jugarAzar8:
		lb $a0, 6($s3)
		lb $a1, 8($s7)
		
#		bne $a0, $a1, jugarAzar2
		j jugar8
		
jugarComputador:
		lb $a0, computador
		sb $a0, 0($s5)
		
		li $v0, 4
		la $a0, turnoComputador
		syscall
		
		
analizarJugada:
		# almacenando en t4 la suma temporal de cada fila o columna o diag
		li $t4, 0

analizarFila1:
		lb $a0, 0($s6)
		li $v0, 0 # BOOLEANO
		
		li $t0, 0 # para X - 5
		li $t1, 0 # para O - 3
		
		lb $a1, 2($s1)
		lb $a2, 6($s1)
		lb $a3, 10($s1)
		
		seq $v0, $a1, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a2, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a3, $a0
		add $t0, $t0, $v0
		
		mul $t0, $t0, 5
		
		lb $a0, jugador
		
		lb $a1, 2($s1)
		lb $a2, 6($s1)
		lb $a3, 10($s1)
		
		seq $v0, $a1, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a2, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a3, $a0
		add $t1, $t1, $v0
		
		mul $t1, $t1, 3
		
		add $v0, $t0, $t1
		
		beq $v0, 10, jugarFila1
		beq $v0, 6, jugarFila1
		
analizarFila2:
		
		lb $a0, 0($s6)
		li $v0, 0
		
		li $t0, 0 # para X
		li $t1, 0 # para O
		
		lb $a1, 2($s2)
		lb $a2, 6($s2)
		lb $a3, 10($s2)
		
		seq $v0, $a1, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a2, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a3, $a0
		add $t0, $t0, $v0
		
		mul $t0, $t0, 5
		
		lb $a0, jugador
		
		lb $a1, 2($s2)
		lb $a2, 6($s2)
		lb $a3, 10($s2)
		
		seq $v0, $a1, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a2, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a3, $a0
		add $t1, $t1, $v0
		
		mul $t1, $t1, 3
		
		add $v0, $t0, $t1
		
		beq $v0, 10, jugarFila2
		beq $v0, 6, jugarFila2

analizarFila3:
		
		lb $a0, 0($s6)
		li $v0, 0
		
		li $t0, 0 # para X
		li $t1, 0 # para O
		
		lb $a1, 2($s3)
		lb $a2, 6($s3)
		lb $a3, 10($s3)
		
		seq $v0, $a1, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a2, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a3, $a0
		add $t0, $t0, $v0
		
		mul $t0, $t0, 5
		
		lb $a0, jugador
		
		lb $a1, 2($s3)
		lb $a2, 6($s3)
		lb $a3, 10($s3)
		
		seq $v0, $a1, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a2, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a3, $a0
		add $t1, $t1, $v0
		
		mul $t1, $t1, 3
		
		add $v0, $t0, $t1
		
		beq $v0, 10, jugarFila3
		beq $v0, 6, jugarFila3
		
analizarColumna1:		
		lb $a0, 0($s6)
		li $v0, 0
		
		li $t0, 0 # para X
		li $t1, 0 # para O
		
		lb $a1, 2($s1)
		lb $a2, 2($s2)
		lb $a3, 2($s3)
		
		seq $v0, $a1, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a2, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a3, $a0
		add $t0, $t0, $v0
		
		mul $t0, $t0, 5
		
		lb $a0, jugador
		
		lb $a1, 2($s1)
		lb $a2, 2($s2)
		lb $a3, 2($s3)
		
		seq $v0, $a1, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a2, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a3, $a0
		add $t1, $t1, $v0
		
		mul $t1, $t1, 3
		
		add $v0, $t0, $t1
		
		beq $v0, 10, jugarColumna1
		beq $v0, 6, jugarColumna1
		
analizarColumna2:		
		lb $a0, 0($s6)
		li $v0, 0
		
		li $t0, 0 # para X
		li $t1, 0 # para O
		
		lb $a1, 6($s1)
		lb $a2, 6($s2)
		lb $a3, 6($s3)
		
		seq $v0, $a1, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a2, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a3, $a0
		add $t0, $t0, $v0
		
		mul $t0, $t0, 5
		
		lb $a0, jugador
		
		lb $a1, 6($s1)
		lb $a2, 6($s2)
		lb $a3, 6($s3)
		
		seq $v0, $a1, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a2, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a3, $a0
		add $t1, $t1, $v0
		
		mul $t1, $t1, 3
		
		add $v0, $t0, $t1
		
		beq $v0, 10, jugarColumna2
		beq $v0, 6, jugarColumna2
		
		
analizarColumna3:		
		lb $a0, 0($s6)
		li $v0, 0
		
		li $t0, 0 # para X
		li $t1, 0 # para O
		
		lb $a1, 10($s1)
		lb $a2, 10($s2)
		lb $a3, 10($s3)
		
		seq $v0, $a1, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a2, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a3, $a0
		add $t0, $t0, $v0
		
		mul $t0, $t0, 5
		
		lb $a0, jugador
		
		lb $a1, 10($s1)
		lb $a2, 10($s2)
		lb $a3, 10($s3)
		
		seq $v0, $a1, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a2, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a3, $a0
		add $t1, $t1, $v0
		
		mul $t1, $t1, 3
		
		add $v0, $t0, $t1
		
		beq $v0, 10, jugarColumna3
		beq $v0, 6, jugarColumna3
		
		
analizarDiagonal:		
		lb $a0, 0($s6)
		li $v0, 0
		
		li $t0, 0 # para X
		li $t1, 0 # para O
		
		lb $a1, 2($s1)
		lb $a2, 6($s2)
		lb $a3, 10($s3)
		
		seq $v0, $a1, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a2, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a3, $a0
		add $t0, $t0, $v0
		
		mul $t0, $t0, 5
		
		lb $a0, jugador
		
		lb $a1, 2($s1)
		lb $a2, 6($s2)
		lb $a3, 10($s3)
		
		seq $v0, $a1, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a2, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a3, $a0
		add $t1, $t1, $v0
		
		mul $t1, $t1, 3
		
		add $v0, $t0, $t1
		
		beq $v0, 10, jugarDiagonal
		beq $v0, 6, jugarDiagonal
		
		
analizarAntiDiagonal:		
		lb $a0, 0($s6)
		li $v0, 0
		
		li $t0, 0 # para X
		li $t1, 0 # para O
		
		lb $a1, 10($s1)
		lb $a2, 6($s2)
		lb $a3, 2($s3)
		
		seq $v0, $a1, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a2, $a0
		add $t0, $t0, $v0
		
		seq $v0, $a3, $a0
		add $t0, $t0, $v0
		
		mul $t0, $t0, 5
		
		lb $a0, jugador
		
		lb $a1, 10($s1)
		lb $a2, 6($s2)
		lb $a3, 2($s3)
		
		seq $v0, $a1, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a2, $a0
		add $t1, $t1, $v0
		
		seq $v0, $a3, $a0
		add $t1, $t1, $v0
		
		mul $t1, $t1, 3
		
		add $v0, $t0, $t1
		
		beq $v0, 10, jugarAntiDiagonal
		beq $v0, 6, jugarAntiDiagonal
		
		j jugarAzar
		
		
empate:
		li $v0, 4
		la $a0, _empate
		syscall
		
		li $v0, 4
		la $a0, _preguntarNuevoJuego
		syscall
		
		li $v0, 5
		syscall
		move $s4, $v0
		
		beq $s4, 1, limpiarFilas
		
		li $v0, 10
		syscall
		
		
		
juegoTerminado:

		li $v0, 4
		la $a0, divisor
		syscall
		
		li $v0, 4
		la $a0, fila1
		syscall
		
		li $v0, 4
		la $a0, fila2
		syscall
		
		li $v0, 4
		la $a0, fila3
		syscall
		
		li $v0, 4
		la $a0, divisor
		syscall	
		
		la $s6, perdedor
		lb $a1, turnoActual
		sb $a1, 14($s6)
		
		li $v0, 4
		la $a0, perdedor
		syscall
		
		li $v0, 4
		la $a0, _preguntarNuevoJuego
		syscall
		
		li $v0, 5
		syscall
		move $s4, $v0
		
		beq $s4, 1, limpiarFilas
		
		li $v0, 10
		syscall
