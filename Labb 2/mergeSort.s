	.globl mergeSort
	
.data
	test: .asciiz "\nit works!!\n"
	myArray: .word 4,5,2,2,1,6,7,9,5,10
.text
	mergeSort:
			
		#li $s2 10			#TEMPORARY TESTING PURPOSE
		#la $s1 myArray			#TEMPORARY TESTING PURPOSE	
		
		#move $s1 $a0
		#move $s2 $a1
		ble $s2 $s3 return		#if (size > 1 ){} BASE CASE
		
		addi $sp $sp -32
		sw $ra 0 ($sp)			#saving return address on the stack
		sw $a0 4 ($sp) 			#saving myArray on the stack
		sw $a1 8 ($sp)			#saving arraysize on the stack
		sw $s0 12 ($sp)			#saving s-registers on the stack
		sw $s1 16 ($sp)			#s1 = myArray
		sw $s2 20 ($sp)			#s2 = arraySize
		sw $s3 24 ($sp)			#comparer
		sw $s4 28 ($sp)			#original size
		
		li $s0 0			#setting loop-counter
		li $s3 1			#setting comparer
		


		
		#la $s1 4($sp) 			#loading myArray from the stack
		#lw $s2 8($sp)			#load array size 
		#lw $s4 8($sp)			#saving original array size for later use
		#la $s1 $a0			#loading address for array into s1
		

		
		divu $s2 $s2 2			#int half =  size / 2
		
		lw $t0 4($s1)			#load value at current position from array to t0
	#leftside merge
		addi $s1 $s1 4 			#increment array address
		la $a0 ($s1) 			#loading array address as inparameter
		move $a1 $s2			#loading new size as inparameter
					
		jal mergeSort			#repeat mergeSort
		
	mergeSortRight:
		 
	
	return:
		la $a0 test
		li $v0 4
		syscall
		
		