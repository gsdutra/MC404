.set CANVAS_ADRESS, 0xFFFF0700
.set SERIAL_ADRESS, 0xFFFF0500
.set CAR_ADRESS, 0xFFFF0300
.set GPT_ADRESS, 0xFFFF0100

Syscall_set_motor:
	li s6, CAR_ADRESS

	#verificacoes
	li s0, -1
	li s1, 2
	li s2, -127
	li s3, 128
	
	blt a0, s0, bad_arguments
	blt a1, s2, bad_arguments
	bge a0, s1, bad_arguments
	bge a1, s3, bad_arguments

	#fim das verific

	sb a0, 0x21(s6)
	sb a1, 0x20(s6)
	li a0, 0
	j end

	bad_arguments:
		li a0, -1
		j end

Syscall_set_handbreak:
	li s6, CAR_ADRESS
	
	beq a0, zero, end
	sb a0, 0x22(s6)
	
	j end
	
Syscall_read_sensors:
	li s6, CAR_ADRESS
	li s0, 1
	sb s0, 0x01(s6)
	
	loop_waiting_sen:
		lb s1, 0x01(s6)
		bne s1, zero, loop_waiting_sen

	addi s2, s6, 0x24
	li s3, 0
	li s4, 256
	mv a4, a0

	loop_image:
		lb s5, (s2)
		sb s5, (a4)

		addi a4, a4, 1
		addi s2, s2, 1
		addi s3, s3, 1

		bne s3, s4, loop_image

	j end

Syscall_read_sensor_distance:
	li s6, CAR_ADRESS
	li s0, 1
	sb s0, 0x02(s6)
	
	loop_waiting_dis:
		lb s1, 0x02(s6)
		bne s1, zero, loop_waiting_dis

	lw a0, 0x1c(s6)

	j end
	
Syscall_get_position:
	li s6, CAR_ADRESS
	li s0, 1
	sb s0, 0x00(s6)

	loop_waiting_pos:
		lb s1, 0x00(s6)
		bne s1, zero, loop_waiting_pos

	lw s2, 0x10(s6)
	lw s3, 0x14(s6)
	lw s4, 0x18(s6)

	sw s2, (a0)
	sw s3, (a1)
	sw s4, (a2)

	j end
	
Syscall_get_rotation:
	li s6, CAR_ADRESS
	li s0, 1
	sb s0, 0x00(s6)

	loop_waiting_rot:
		lb s1, 0x00(s6)
		bne s1, zero, loop_waiting_rot

	lw s2, 0x04(s6)
	lw s3, 0x08(s6)
	lw s4, 0x0c(s6)

	sw s2, (a0)
	sw s3, (a1)
	sw s4, (a2)

	j end
	
Syscall_read:
	li s6, SERIAL_ADRESS
	#a1 = buffer
	#a2 = size
	li s0, 0
	mv s5, a1
	li a5, 10

	reading:

		li s1, 1
		sb s1, 0x02(s6)

		read_inner:
			lb s2, 0x02(s6)
			bne s2, zero, read_inner

		lb s4, 0x03(s6)
		beq s4, zero, endrd
		beq s4, a5, endrd
		sb s4, (s5)

		addi s5, s5, 1
		addi s0, s0, 1
		
		beq s0, a2, endrd

		j reading

	endrd:
		sb zero, (s5)
		j end
	
Syscall_write:
	li s6, SERIAL_ADRESS
	#a1 = buffer
	#a2 = size
	li s0, 0
	mv s5, a1

	writing:
		lb s4, (s5)	#salva o byte do buffer
		sb s4, 0x01(s6) #no 0x01 da serial port

		li s1, 1
		sb s1, 0x00(s6)

		write_inner:
			lb s2, 0x00(s6)
			bne s2, zero, write_inner

		addi s5, s5, 1
		addi s0, s0, 1
		
		beq s0, a2, end
		j writing

Syscall_draw_line:
	li s6, CANVAS_ADRESS

	li s0, 256
	sb s0, 0x02(s6)

	addi s2, s6, 0x08
	li s3, 0
	li s4, 256
	mv a4, a0

	#salvando o array na memoria do canvas
	loop_canvas:
		lb s5, (s2)
		sb s5, (a4)

		addi a4, a4, 1
		addi s2, s2, 1
		addi s3, s3, 1

		bne s3, s4, loop_canvas

	j end
	
Syscall_get_systime:
	li s6, GPT_ADRESS

	li s0, 1
	sb s0, (s6)

	loop_waiting_gpt:
		lb s1, (s6)
		bne s1, zero, loop_waiting_gpt

	lw a0, 0x08(s6)

	j end
	
###############################################################

int_handler:
	csrrw sp, mscratch, sp
	li sp, -80

	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	sw a4, 16(sp)
	sw a5, 20(sp)
	sw a6, 24(sp)
	sw a7, 28(sp)
	sw s0, 32(sp)
	sw s1, 36(sp)
	sw s2, 40(sp)
	sw s3, 44(sp)
	sw s4, 48(sp)
	sw s5, 52(sp)
	sw s6, 56(sp)
	sw s7, 60(sp)
	sw s8, 64(sp)
	sw s9, 68(sp)
	sw s10, 72(sp)
	sw s11, 76(sp)


	li s4, 10
    beq a7, s4, Syscall_set_motor

    li s4, 11
    beq a7, s4, Syscall_set_handbreak

    li s4, 12
    beq a7, s4, Syscall_read_sensors

    li s4, 13
    beq a7, s4, Syscall_read_sensor_distance

    li s4, 15
    beq a7, s4, Syscall_get_position

    li s4, 16
    beq a7, s4, Syscall_get_rotation  

    li s4, 17
    beq a7, s4, Syscall_read

    li s4, 18
    beq a7, s4, Syscall_write

    li s4, 19
    beq a7, s4, Syscall_draw_line

    li s4, 20
    beq a7, s4, Syscall_get_systime


	end:
		csrr t0, mepc
		addi t0, t0, 4
		csrw mepc, t0

		#lw a0, 0(sp)
		#lw a1, 4(sp)
		lw a2, 8(sp)
		lw a3, 12(sp)
		lw a4, 16(sp)
		lw a5, 20(sp)
		lw a6, 24(sp)
		lw a7, 28(sp)
		lw s0, 32(sp)
		lw s1, 36(sp)
		lw s2, 40(sp)
		lw s3, 44(sp)
		lw s4, 48(sp)
		lw s5, 52(sp)
		lw s6, 56(sp)
		lw s7, 60(sp)
		lw s8, 64(sp)
		lw s9, 68(sp)
		lw s10, 72(sp)
		lw s11, 76(sp)

		li sp, 0

		csrrw sp, mscratch, sp
		mret



.globl _start
_start:

la t0, int_handler  # Carregar o endereço da rotina que tratará as interrupções
csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar
					# o vetor de interrupções.

	# Habilita Interrupções Global
	csrr t1, mstatus     # Seta o bit 3 (MIE) 
	ori t1, t1, 0x8      # do registrador mstatus
	csrw mstatus, t1

	# Habilita Interrupções Externas
	csrr s6, mie # Seta o bit 11 (MEIE)
	li s3, 0x800 # do registrador mie
	or s6, s6, s3
	csrw mie, s6

	# Configura mscratch com o topo da pilha das ISRs.
	la s6, isr_buffer # s6 <= base da pilha
	csrw mscratch, s6 # mscratch <= t0

	la sp, pilha
	li s1, 48000
	add sp, sp, s1

	# Muda para o Modo de usuário
	csrr s6, mstatus # Update the mstatus.MPP
	li s3, ~0x1800 #  field (bits 11 and 12)
	and s6, s6, s3 #  with value 00 (U-mode)
	csrw mstatus, s6
	la s1, main # Loads the user software
	csrw mepc, s1 # entry point into mepc 
	mret

.data
.align 4
	pilha: .skip 2000

.bss
.align 4
	isr_buffer: .skip 2000