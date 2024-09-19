.data
	myArray: .space 36
	prompt: .asciiz "\nPlease entere the number you are searching for : "
	answer: .asciiz "\nThe position of the number is %d. \n"
	nrmissing: .asciiz "\nThe number is missing\n"
	
.text

	main:
		#loading the values for to be put into array
		addi $t1 $0 5
		addi $t2 $0 7
		addi $t3 $0 1
		addi $t4 $0 9
		addi $t5 $0 2
		addi $t6 $0 4
		addi $t7 $0 8
		addi $t8 $0 3
		addi $t9 $0 6
		li $s1 0			#preppar arraycounter
		li $s2 9 			#array size		
		li $s3 4			#division constant
		addi $t0 $0 0 #index för position in array
		

		sw $t1 myArray($t0)		#loading array with value at t1
			addi $t0 $t0 4 		#incrementing memory addres by 4 bytes
		sw $t2 myArray($t0)
			addi $t0 $t0 4
		sw $t3 myArray($t0)
			addi $t0 $t0 4
		sw $t4 myArray($t0)
			addi $t0 $t0 4	
		sw $t5 myArray($t0)
			addi $t0 $t0 4
		sw $t6 myArray($t0)
			addi $t0 $t0 4
		sw $t7 myArray($t0)
			addi $t0 $t0 4			
		sw $t8 myArray($t0)
			addi $t0 $t0 4
		sw $t9 myArray($t0)
		
		li $v0 4			#skriver ut prompt för user input
		la $a0 prompt 
		syscall
		
		li $v0 5			#scanf %d
		syscall
		addi $t0 $t0 -36 		#börjar t0 på minnesadress för första platsen i arrayen

	loop:
		lw $s0 myArray($t0)		#laddar värdet på adress för t0(??)
		beq $s0 $v0 match		#branchar till match om värdet på addressen t0 är like med input 
		addi $t0 $t0 4			#increment t0 med fyra bytes för nästa position
		bge $s1 $s2 notFound		#if array size = array counter branch to not found
		addi $s1 $s1 1			#array counter++	
		j loop
	match: 
		div $t0 $s3			#dividerar positionens offset med 4 för att få fram vilken position som värdet har 
		mflo $t0			#flyttar kvoten till t0
		addi $t0 $t0 1			#adderar 1 till kvoten för att få den "korrekta" positionen 
		la $a0 answer			#laddar answer till a0 inför print
		la $a1 ($t0)			#laddar positionen till a1 inför print
		jal print			#hoppar och länkar till print
		j exit

	notFound:
		la $a0 nrmissing		#laddar nrmissing till a0 inför print
		jal print 		
		j exit
	exit: 
		li $v0 10			#return 0
		syscall	
.include "print.s"		