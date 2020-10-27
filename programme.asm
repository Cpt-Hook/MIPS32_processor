.data                  # directive indicating start of the data segment
.align  2              # set data alignment to 4 bytes

array:                 # label - name of the memory block
.word  3, 7, 3, 5, 1, 9, 5   # values in the array to search...


.text                  # beginning of the text segment (or code segment)
beq $0,$0,main         # jump to main
#------------------------------------------------------------
# find_min: finds min value in the given array
# Inputs: a0 - address, a1 - number of items
# Outputs: v0 - minimum, v1 - minimum address
find_min:
addi $t3, $zero, 0      # initialization instruction of for cycle: i=0, where i=s1

lw $v0,0($a0)           # set initial minimum value to v0
addi $v1, $a0, 0	# set inital minimum value address
for:
  beq  $t3, $a1, done_find_min   # if t3 == a1, go to label done and break the cycle
  lw   $t2, 0x0($a0)    # load value from the array to t2
  slt  $t0, $t2, $v0    # t0 = v0 > t2;
  beq  $t0, $0, skip    # Do not skip very next instruction if t0==1
    addi $v0, $t2, 0    # update v0 with new min value
    addi $v1, $a0, 0	# update v1 with address of the new min value
  skip:
  addi $a0, $a0, 0x4    # increment offset and move to the other value in the array
  addi $t3, $t3, 0x1    # increment number of passes through the cycle (i++).
  beq $0, $0, for              # jump to  **for** label
done_find_min:
jr $31
#------------------------------------------------------------
# sort: sorts the given array
# Inputs: a0 - address, a1 - number of items
# Outputs: void
#------------------------------------------------------------

main:
  la $s1, array      # load array address ### change <--------------
  addi $s2, $0, 7    # number of elements in array
  
  addi $s3, $s2, -1  # number of elements - 1 for the loop
  addi $s4, $0, 0    # i for the loop
  addi $s5, $s1, 0    # addres of array[i]
  
main_for:
  beq $s4, $s3 done
  	addi $a0, $s5, 0	# address to search min from
  	addi $a1, $s2, 0	# elements to search
  	sub $a1, $a1, $s4
  	jal find_min
  	
  	lw $s0, 0($s5) # tmp = array[i]
  	sw $v0, 0($s5) # array[i] = min
  	sw $s0, 0($v1) # array[min] = tmp
  	 
  addi $s4, $s4, 1  # i++
  addi $s5, $s5, 4  # increment address pointer
  beq $0, $0, main_for
done:
  nop
  
  
  
  
  
  
  
  
  
  
