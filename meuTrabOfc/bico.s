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

set_motor:
    li a7, 10
    ecall
    ret

set_handbreak:
    li a7, 11
    ecall
    ret

read_camera:
    li a7, 10
    ecall
    ret

read_sensor_distance:
    li a7, 10
    ecall
    ret

get_position:
    li a7, 10
    ecall
    ret

get_rotation:
    li a7, 10
    ecall
    ret

get_time:
    li a7, 10
    ecall
    ret

filter_1d_image:
    li a7, 10
    ecall
    ret

display_image:
    li a7, 10
    ecall
    ret

puts:
    li a7, 10
    ecall
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
    li a7, 10
    ecall
    ret

approx_sqrt:
    li a7, 10
    ecall
    ret


