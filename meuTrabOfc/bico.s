.globl set_motor
.globl set_handbreak
.globl read_camera
.globl read_sensor_distance
.globl get_position
.globl get_rotation
.globl get_time
.globl filter_1d_image
.globl display_image
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl sleep
.globl approx_sqrt

#Ordem padrao de argumentos: a0, a1, a2, a2, ...

set_motor:#//
    li a7, 10
    ecall
    ret

set_handbreak:#//
    li a7, 11
    li a3, 0
    li a4, 2

    #verific
    bge a0, a4, bad_arguments_handbreak
    blt a0, a3, bad_arguments_handbreak

    ecall
    ret

    bad_arguments_handbreak:
        ret

read_camera:#//
    li a7, 12
    ecall
    ret

read_sensor_distance:#//
    li a7, 13
    ecall
    ret

get_position:#//
    li a7, 15
    ecall
    ret

get_rotation:#//
    li a7, 16
    ecall
    ret

get_time:#//
    li a7, 20
    ecall
    ret

filter_1d_image:

    li t0, -1
    li t1, 256
    la s1, img
    mv s0, a0

    loop_clone_img:
        addi t0, t0, 1

        lb s2, (s0)
        sb s2, (s1)

        addi s0, s0, 1
        addi s1, s1, 1

        bne t0, t1, loop_clone_img

    li t0, 0      #nao e mais -1 
    li t1, 255    #nao e mais 256
    la s1, img
    mv s0, a0
    
    li s4, 0
    li s5, 255

    loop_filtro:
        addi t0, t0, 1
        li s6, 0

        lb s2, 0(a1) #esquerda
        lbu t2, -1(s1)
        mul t2, t2, s2
        add s6, s6, t2

        lb s2, 1(a1) #meio
        lbu t2, (s1)
        mul t2, t2, s2
        add s6, s6, t2

        lb s2, 2(a1) #direita
        lbu t2, 1(s1)
        mul t2, t2, s2
        add s6, s6, t2
        
        blt s6, s4, erro_min
        blt s5, s6, erro_max

        continua_filtro:

            sb s6, (s0)

            addi s0, s0, 1
            addi s1, s1, 1

            bne t0, t1, loop_filtro

    #deixando os pixeis 0 e 255 pretos
    sb s4, (a0)
    sb s4, 255(a0)

    j endfiltro
    #tratando erros
    erro_min:
        li s6, 0
        j continua_filtro

    erro_max:
        li s6, 255
        j continua_filtro
    #/filtro

    endfiltro:
        ret

/*#filtro
    li t0, -1
    li t1, 256
    la s0, img
    la s1, img_pre_filter

    loop_clone_img:
        addi t0, t0, 1

        lb s2, (s0)
        sb s2, (s1)

        addi s0, s0, 1
        addi s1, s1, 1

        bne t0, t1, loop_clone_img


    li t0, 0      #nao e mais -1 
    li t1, 255    #nao e mais 256
    la s0, img
    la s1, img_pre_filter
    li s2, -4
    li s3, 8
    
    li s4, 0
    li s5, 255

    loop_filtro:
        addi t0, t0, 1
        li s6, 0

        lb t2, -1(s1)
        mul t2, t2, s2
        add s6, s6, t2

        lb t2, (s1)
        mul t2, t2, s3
        add s6, s6, t2

        lb t2, 1(s1)
        mul t2, t2, s2
        add s6, s6, t2
        
        blt s6, s4, erro_min
        blt s5, s6, erro_max

        continua_filtro:

            sb s6, (s0)

            addi s0, s0, 1
            addi s1, s1, 1

            bne t0, t1, loop_filtro

    #deixando os pixeis 0 e 255 pretos
    la s0, img
    sb s4, (s0)
    sb s5, 255(s0)

    j endfiltro
    #tratando erros
    erro_min:
        li s6, 0
        j continua_filtro

    erro_max:
        li s6, 255
        j continua_filtro
    #/filtro

    endfiltro:
        li a7, 19
        ecall
        ret*/
display_image:#//
    li a7, 19
    ecall
    ret

puts:
    mv t1, a0 # move pelo buffer
	li t2, 0 # condicao de parada

	loop_puts:
		lbu t3, 0(t1)
		beq t3, t2, fim_loop_puts

		mv a1, t1
		li a2, 1
		li a7, 18
		ecall
		
		addi t1, t1, 1
		j loop_puts

	fim_loop_puts:

	addi sp, sp, -16

	li t3, '\n'
	sb t3, 12(sp)

	addi a1, sp, 12
	li a2, 1
	li a7, 18
	ecall

	addi sp, sp, 16

	li a0, 1

	ret

gets:
    li a7, 10
    ecall
    ret

atoi:
    li a7, 10
    ecall
    ret

itoa:
    li a7, 10
    ecall
    ret

sleep:
    mv t1, a0

    addi sp, sp, -16
    sw ra, 12(sp)
    sw fp, 8(sp)

    addi fp, sp, 16

    #jal time
    li a7, 20
    ecall

    mv t0, a0 # time0


    loop_sleep: #while time - time0 < tempo em ms
        #jal time
        li a7, 20
        ecall
        sub t2, a0, t0
        bge t1, t2, loop_sleep

    
    lw ra, 12(sp)
    lw fp, 8(sp)
    addi sp, sp, 16

    ret

approx_sqrt:
    li t0, 2
    li t1, 0
    li a3, 2
    #a0 = num
    #a1 = iterac
    div a3, a0, t0 #k1

    loop_babylonian:
        addi t1, t1, 1
        
        	div a4, a0, a3 #y/k
            add a5, a4, a3 #k+(y/k)
            div a3, a5, t0 #/2
        
        bge a1, t1, loop_babylonian

    mv a0, a3
ret



.data
.align 4
img: .skip 256