
.data
	arraySize: .word 10
	myArray: .word 4,5,2,2,1,6,7,9,5,10
	mid: .word 0
	sortedArr: .asciiz "\nThe sorted array is : "
	notSortedArr: .asciiz "\nThe unsorted array is : "
	
.text

	main:
		la $s0 0			#load loop counter
		la $s1 arraySize
		
		addi $sp $sp -16		#adjusting stack pointer before jump 	
		la $a0 notSortedArr 		#printing message
		
		addi $sp $sp -16
		jal print
		addi $sp $sp 16
		
		la $a0 myArray			#loading array to a0
		lw $a1 arraySize		#loading arraysizes value to a1
		jal printer			#jump to printLoop
		
		addu $sp $sp 16			#resetting stackpointer after jump
		
		#all of the above is for print array
		
		
		
		
		
		li $v0 10 
		syscall
		#la $a0 myArray
		#jal mergeSort
		
		
	
	
	#.include "mergeSort.s"	
	.include "print.s"
	.include "printLoop.s"
	#.include "merge.s"
