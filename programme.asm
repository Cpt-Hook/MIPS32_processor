# programme that sorts array
# On address 0x0C - address of the array
# On address 0x08 - length of the array
# output: sorted array in memory
# algoritmh: insert sort

beq $0,$0,main         # jump to main

#------------------------------------------------------------
# find_min: finds min value in the given array
# Inputs: a0 - address, a1 - number of items
# Outputs: v0 - minimum, v1 - minimum address
find_min:
addi $t8, $zero, 0      # initialization instruction of for cycle: i=0, where i=s1

lw $v0,0($a0)           # set initial minimum value to v0
addi $v1, $a0, 0	# set inital minimum value address
for:
  beq  $t8, $a1, done_find_min   # if t8 == a1, go to label done and break the cycle
  lw   $t7, 0x0($a0)    # load value from the array to t7
  slt  $t6, $t7, $v0    # t6 = v0 > t7;
  beq  $t6, $0, skip    # Do not skip very next instruction if t0==1
    addi $v0, $t7, 0    # update v0 with new min value
    addi $v1, $a0, 0	# update v1 with address of the new min value
  skip:
  addi $a0, $a0, 0x4    # increment offset and move to the other value in the array
  addi $t8, $t8, 0x1    # increment number of passes through the cycle (i++).
  beq $0, $0, for              # jump to  **for** label
done_find_min:
nop
jr $31
nop
#---------------------------------------------------------

# sort: sorts the given array
# Inputs: a0 - address, a1 - number of items
# Outputs: void
#---
sort:
  addi $t9, $31, 0		# hack to save address of the caller
  addi $t1, $a0, 0      	# load array address ### change <--------------
  addi $t2, $a1, 0    		# number of elements in array
  
  addi $t3, $t2, -1  		# number of elements - 1 for the loop
  addi $t4, $0, 0    		# i for the loop
  addi $t5, $t1, 0    		# addres of array[i]
  
sort_for:
  beq $t4, $t3 done
  	addi $a0, $t5, 0	# address to search min from
  	addi $a1, $t2, 0	# elements to search
  	sub $a1, $a1, $t4
  	nop
  	jal find_min		# gets address of min value in given array
  	nop
  	
  	lw $t0, 0($t5) 		# tmp = array[i]
  	sw $v0, 0($t5) 		# array[i] = min
  	sw $t0, 0($v1) 		# *find_min = tmp
  	 
  addi $t4, $t4, 1  		# i++
  addi $t5, $t5, 4  		# increment address pointer
  beq $0, $0, sort_for
done:
  addi $31, $9, 0		# hack to restore address of the caller
  nop
  jr $31
  nop
 #------------------------------------------------------------
 
main:
  addi $t0, $0, 0xC
  lw $a0, 0($t0)      # load array address ### change <--------------
  addi $t0, $0, 0x8
  lw $a1, 0($t0)    # number of elements in array
  nop
  jal sort
  nop
  
  
  
  
  
  
  
