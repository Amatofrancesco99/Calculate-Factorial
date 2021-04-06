# Made by: AMATO FRANCESCO	Matricola: 468497	Data: 19/05/2020	Ingegneria Elettronica & Informatica UNIPV
#Corso: CALCOLATORI ELETTRONICI (Docente: Giovanni Danese)
#---------------------------------------------------------------------------------------------------------------------------------------
# PROGRAMMA che si occupa di calcolare il FATTORIALE DI UN NUMERO
#---------------------------------------------------------------------------------------------------------------------------------------
# Ricordiamo che il NUMERO su cui si vuole calcolare il fattoriale deve essere MAGGIORE O al più UGUALE a 0.
# Ricordiamo inoltre la PROPRIETA' che 0! = 1
# Se si dovesse inserire un NUMERO NEGAITIVO NON HA SENSO calcolare il FATTORIALE
# Qualora dovesse essere inserito un NUMERO SUPERIORE, o UGUALE, a 13, il calcolo del fattoriale genererebbe un numero più grande rispetto
# al massimo numero che si potrebbe ottenere avendo a disposizione registri da 32 bit, come nel caso del processore MIPS. 
# Si verificherebbe dunque la condizione di OVERFLOW.


#CREAZIONE del DATA SEGMENT, in cui inseriremo delle stringhe che ci torneranno utili nel corso dell'esecuzione del MAIN PROGRAM
.data
	messaggio: .asciiz "CALCOLO DEL FATTORIALE DI UN NUMERO (N)\nInserisci N: "
	visris:    .asciiz "N! = "
	acapo:	   .asciiz "\n"

#CREAZIONE del TEXT SEGMENT, in cui troveremo tutte le istruzioni del nostro programma
.text
.globl	main


#PROGRAMMA PRINCIPALE
main:

#Stampa intestazione
	la $a0, messaggio
	addi $v0, $0, 4
	syscall
	
#Leggo n (valore in $v0)
	add $v0, $0, 5		#se viene inserito un numero non intero/carattere il programma termina, dando errore (in $v0 numero intero)
	syscall
	
#Controllo possibile overflow e che il numero sia positivo
# Osservazione: Avremmo potuto usare addu, anziché add? La risposta è certamente si. Avremmo avuto un numero massimo rappresentabile di
# 4 miliardi (circa), anzichè 2 (circa). Ciò però non cambia la nostra implementazione, dove 13! (6 miliardi circa) sforerebbe anche 
# il massimo numero rappresentabile su un registro a 32 bit unsigned. L'unica differenza starebbe nel numero massimo inseribile nella
# syscall, senza che il programma termini l'esecuzione per Overflow del numero inserito.
	#bge $v0, 13 , Exit	#se il numero inserito è superiore o uguale a: 13, allora il calcolo del fattoriale causerebbe overflow (su 32 bit)
	blt $v0, 0, Exit	#se il numero che inserisco è un numero negativo calcolare il fattoriale non ha alcun senso

#Calcolo del fattoriale
	move $a0, $v0		#salvo il numero inserito in a0
	addi $t1, $0, 1		#qualsiasi che sia il numero (positivo) inserito parto dall'inserire 1 all'interno di t1 (t1 è il registro che contiene il risultato del fattoriale)
	ble $a0, 1, Fine	#il numero inserito è minore o uguale a 1? Se si, il mio fattoriale darà come risultato 1
Fact:	mul $t1, $a0, $t1	#moltiplico t1 per a0
	addi $a0, $a0, -1	#decremento di 1 a0
	bgt $a0, 1, Fact 	#a0 > 1 ? Se si ritorna a Fact, altrimenti continua, andando alla prossima istruzione 
Fine:	move $s0, $t1		#copio il risultato del fattoriale (contenuto in t1) in s0

#Stampo messaggio per il risultato
	la $a0, visris
	addi $v0, $0, 4
	syscall

#Stampo n!
	add $a0, $s0, $0
	addi $v0, $0, 1
	syscall

#Stampo dell'invio a capo \n
	la $a0, acapo
	addi $v0, $0, 4
	syscall

#Termino il programma
Exit:
	addi $v0, $0, 10
	syscall
