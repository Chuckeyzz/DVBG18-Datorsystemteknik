    .globl merge
    .text

merge:
    # Save caller's registers
    subu $sp, $sp, 36            # Allocate stack space for saved registers
    sw $s0, 0($sp)               # Save $s0
    sw $s1, 4($sp)               # Save $s1
    sw $s2, 8($sp)               # Save $s2
    sw $s3, 12($sp)              # Save $s3
    sw $s5, 16($sp)              # Save $s5 (we'll use $s5 for base address of a[])
    sw $s6, 20($sp)              # Save $s6
    sw $ra, 24($sp)              # Save return address

    # Store base address of a[] in $s5 (preserve $a0)
    move $s5, $a0                # $s5 will store base address of a[]

    # Step 1: Compute half = size / 2
    srl $s0, $a1, 1              # s0 = size / 2 (half)

    # Step 2: Initialize i, j, k
    li $s1, 0                    # i = 0
    move $s2, $s0                # j = half
    li $s3, 0                    # k = 0

    # Step 3: Allocate memory on the stack for b[]
    sll $t0, $a1, 2              # t0 = size * 4 (byte size of array)
    subu $sp, $sp, $t0           # Move stack pointer for b[] allocation
    move $s6, $sp                # s6 = base address of temp array b[]

    #### COPY a[] TO TEMP ARRAY b[] ####
copy_loop:
    bge $s3, $a1, merge_loop     # if k >= size, stop copying

    sll $t1, $s3, 2              # t1 = k * 4 (byte offset for a[k])
    add $t2, $s5, $t1            # t2 = address of a[k] (use $s5 for base address)
    lw $t3, 0($t2)               # Load a[k] into t3

    add $t4, $s6, $t1            # Address of b[k]
    sw $t3, 0($t4)               # b[k] = a[k]

    addi $s3, $s3, 1             # k++
    j copy_loop                  # Jump back to the beginning of the loop

#### MERGE TWO HALVES ####
merge_loop:
    # while (i < half && j < size)
merge_while:
    bge $s1, $s0, merge_leftover_right   # if i >= half, go to remaining right half
    bge $s2, $a1, merge_leftover_left    # if j >= size, go to remaining left half

    # if (b[i] <= b[j])
    sll $t1, $s1, 2                      # t1 = i * 4 (byte offset for b[i])
    add $t2, $s6, $t1                    # t2 = address of b[i]
    lw $t3, 0($t2)                       # Load b[i]

    sll $t4, $s2, 2                      # t4 = j * 4 (byte offset for b[j])
    add $t5, $s6, $t4                    # t5 = address of b[j]
    lw $t6, 0($t5)                       # Load b[j]

    ble $t3, $t6, select_left            # if b[i] <= b[j], go to select_left

    #### SELECT FROM RIGHT HALF ####
select_right:
    sll $t7, $s3, 2                      # t7 = k * 4 (byte offset for a[k])
    add $t8, $s5, $t7                    # t8 = address of a[k]
    sw $t6, 0($t8)                       # a[k] = b[j]
    addi $s2, $s2, 1                     # j++
    j merge_increment_k                  # jump to increment k

    #### SELECT FROM LEFT HALF ####
select_left:
    sll $t7, $s3, 2                      # t7 = k * 4 (byte offset for a[k])
    add $t8, $s5, $t7                    # t8 = address of a[k]
    sw $t3, 0($t8)                       # a[k] = b[i]
    addi $s1, $s1, 1                     # i++

merge_increment_k:
    addi $s3, $s3, 1                     # k++
    j merge_while                        # Repeat the merge loop

#### MERGE REMAINING LEFT HALF ####
merge_leftover_left:
    blt $s1, $s0, copy_leftover_left      # if i < half, continue copying
    j merge_done                         # If left is done, we're finished

copy_leftover_left:
    sll $t1, $s1, 2                      # t1 = i * 4 (byte offset for b[i])
    add $t2, $s6, $t1                    # t2 = address of b[i]
    lw $t3, 0($t2)                       # Load b[i]

    sll $t4, $s3, 2                      # t4 = k * 4 (byte offset for a[k])
    add $t5, $s5, $t4                    # t5 = address of a[k]
    sw $t3, 0($t5)                       # a[k] = b[i]
    addi $s1, $s1, 1                     # i++
    addi $s3, $s3, 1                     # k++
    j merge_leftover_left                # Repeat for remaining left half

#### MERGE REMAINING RIGHT HALF ####
merge_leftover_right:
    blt $s2, $a1, copy_leftover_right     # if j < size, continue copying
    j merge_done                         # If right is done, we're finished

copy_leftover_right:
    sll $t1, $s2, 2                      # t1 = j * 4 (byte offset for b[j])
    add $t2, $s6, $t1                    # t2 = address of b[j]
    lw $t3, 0($t2)                       # Load b[j]

    sll $t4, $s3, 2                      # t4 = k * 4 (byte offset for a[k])
    add $t5, $s5, $t4                    # t5 = address of a[k]
    sw $t3, 0($t5)                       # a[k] = b[j]
    addi $s2, $s2, 1                     # j++
    addi $s3, $s3, 1                     # k++
    j merge_leftover_right               # Repeat for remaining right half

merge_done:
    # Restore stack space for b[] and return
    sll $t0, $a1, 2                      # t0 = size * 4
    addu $sp, $sp, $t0                   # Restore stack pointer after b[] usage
    lw $s0, 0($sp)                       # Restore registers
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s5, 16($sp)
    lw $s6, 20($sp)
    lw $ra, 24($sp)
    addu $sp, $sp, 36                    # Restore original stack frame
    jr $ra                               # Return to caller
