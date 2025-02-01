clear macro p1,p2,p3,p4,
mov ah,6
mov al,0
mov ch,p1
mov cl,p2
mov dh,p3
mov dl,p4
mov bh,7
int 10h
endm
print macro p1,p2
mov al,p1
mov cx,p2
mov ah,9h
int 10h
endm
printsz macro p1,p2;set es
mov al,0
lea bp,p1
mov cx,p2
mov ah,13h
int 10h
endm
wcur macro p1,p2;set bh=0
mov dh,p1
mov dl,p2
mov ah,2h
int 10h
endm
rcur macro
mov ah,08h
int 10h
endm
.model small
.data

over_h dw 0
over_l dw 0
head_h dw 0
head_l dw 0
pt_h dw 0 ;?
pt_l dw 0
queue_len dw 0
tou_h db 0
tou_l db 0
wei_h db 0
wei_l db 0
food_h db 20,5 ,9 ,7 ,13,16,6 ,7 ,10,23,18,14,15,9,15,19
db 21,6,20,11,15,20,21,14,7 ,9 ,8 ,10,24,17,5 ,13
db 18,9 ,16,19,22,13,18,23,6 ,8 ,15,23,18,17,9 ,9
db 9 ,16,15,20,6 ,9,22,24,24,21,16,5 ,19,17,16,14
db 13,10,18,22,5 ,6 ,7 ,21,19,18,20,14,9,16,17,13,19,0ffh
ph_food db 0
food_l db 40,24,15,47,19,45,67,79,62,46,51,1 ,3 ,8,68,21
db 68,2,38,45,29,15,6 ,55,77,66,13,30,60,75,12,15
db 74,77,16,5 ,5 ,54,52,39,37,44,67,66,51,20,21,66
db 77,33,55,28,46,1,71,73,0 ,0 ,58,69,49,21,56,30
db 33,45,59,54,65,68,22,11,8 ,76,32,62,4,22,38,38,24,0ffh
pl_food db 0
nfood db 0
direct db 3
speed db 0
t_speed db 0
;
mar_top equ 5
mar_down equ 23
mar_left equ 0
mar_right equ 79
;
SUCCESS db 2 ; =0 ok,1 lose,2 yumen
yu_shap equ 07h
yu_color equ 0eh
szscore db ' You have got      ,thanks for playing anything exit !'
nscore equ $-szscore
szlose db 'You Lose !'
nlose equ $-szlose
szwin db 'Congratulations ! ~~~~~~You are the winner !'
nwin equ $-szwin
szgood db 'GOOD , Just go on ! -_-!!'
ngood equ $-szgood

;
queue_h db 200 dup(0);行藕
queue_l db 200 dup(0);辛藕
;

.code
yuyu proc far public

yuyu_start:
push ax
push bx
push cx
push dx
push di
push si
push ds
push es
mov ax,@data
mov ds,ax
mov es,ax
;cursor unvisible
mov ah,1
mov cx,1000h
int 10h
clear 0,0,23,79
clear mar_top,mar_left,mar_down,mar_right
;
mov bx,offset queue_h
mov byte ptr [bx],12
inc bx
mov byte ptr [bx],12
inc bx
mov byte ptr [bx],12
;
mov bx,offset queue_l
mov byte ptr [bx],30
inc bx
mov byte ptr [bx],28
inc bx
mov byte ptr [bx],29
;
;
;
mov ax,offset queue_h
mov head_h,ax
inc ax
mov over_h,ax
mov ax,offset queue_l
mov head_l,ax
inc ax
mov over_l,ax
mov bx,head_h
mov al,byte ptr [bx]
mov tou_h,al
mov bx,head_l
mov al,byte ptr [bx]
mov tou_l,al
mov bx,over_h
mov al,byte ptr [bx]
mov wei_h,al
mov bx,over_l
mov al,byte ptr [bx]
mov wei_l,al
mov bh,0
mov bl,yu_color
wcur wei_h,wei_l
print yu_shap,1
wcur [queue_h+2],[queue_l+2]
print yu_shap,1
wcur tou_h,tou_l
print yu_shap,1
mov queue_len,3
mov direct,3
mov speed,3
mov t_speed,3

mov SUCCESS,2

;;;;;;;;;;;;;;;;;;;;
mov ph_food,0
mov pl_food,0
mov nfood,0
call food
;
mov si,es
mov ax,351ch
int 21h
push es
push bx
mov es,si
push ds
mov dx,offset move
mov ax,seg move
mov ds,ax
mov ax,251ch
int 21h
pop ds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
in al,21h
and al,11111110b
out 21h,al
cli;;;;;;;;;; why cli unable ?
;
;
;
ctrl:
cmp SUCCESS,0
jz yu_win1
cmp SUCCESS,1
jz yu_lose1
cmp SUCCESS,2
jz nolose
cli
jmp yu_lose
nolose:
mov ah,0
int 16h
cmp ah,39h
jnz yu_up
cli
space:
mov ah,0
int 16h
cmp ah,39h
jnz space
sti
jmp ctrl
yu_up:
cmp ah,48h
jnz yu_left
cmp direct,2 ;is convert?
jz yu_up1
mov direct,0
yu_up1:
ctrl1:
jmp ctrl
yu_win1:
jmp yu_win
yu_lose1:
jmp yu_lose
yu_left:
cmp ah,4bh
jnz yu_down
cmp direct,3
jz yu_left1
mov direct,1
yu_left1:
jmp ctrl
yu_down:

cmp ah,50h
jnz yu_right
cmp direct,0
jz yu_down1
mov direct,2
yu_down1:
jmp ctrl
yu_right:
cmp ah,4dh
jnz yu_esc
cmp direct,1
jz yu_right1
mov direct,3
yu_right1:
jmp ctrl
yu_esc:
cmp ah,01h
jnz ctrl1;temp jmp
cli
yu_lose:
pop dx
pop ds
mov ax,251ch
int 21h
call score
mov bx,0ch
wcur 10,38
printsz szlose,nlose
jmp scor
yu_win:
pop dx
pop ds
mov ax,251ch
int 21h
call score
mov bx,0ch
wcur 10,38
printsz szwin,nwin
scor:
mov ah,7
int 21h
mov ah,1
mov ch,0
int 10h
pop es
pop ds
pop si
pop di
pop dx
pop cx
pop bx
pop ax
ret

yuyu endp
move proc near

push ax
push bx
push cx
push dx
push ds
mov ax,@data
mov ds,ax
mov es,ax
dec t_speed
jnz no_exit1
cmp SUCCESS,1
jz  no_exit1
mov bx,0005h
wcur ph_food,pl_food
print 03h,1
move_up:
cmp direct,0
jnz move_left
dec tou_h
cmp tou_h,mar_top
jnl up1 ;sign number cmp
mov tou_h,mar_down
up1:
;call score;
call step
jmp move_exit
move_left:
cmp direct,1
jnz move_down
dec tou_l
cmp tou_l,mar_left
jnl left1
mov tou_l,mar_right
left1:
call step
jmp move_exit
no_exit1:;temp jmp
jmp no_exit
move_down:
cmp direct,2
jnz move_right
inc tou_h
cmp tou_h,mar_down
jng down1
mov tou_h,mar_top
down1:
call step
jmp move_exit
move_right:
;cmp direct,3
;jnz move_exit

inc tou_l
cmp tou_l,mar_right
jng right1
mov tou_l,mar_left
right1:
call step
move_exit:
mov al,speed
mov t_speed,al
no_exit:
pop ds
pop dx
pop cx
pop bx
pop ax
iret

move endp
step proc near

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov cx,queue_len
mov al,tou_h
mov di,offset queue_h
cld
compar:
repne scasb
cmp cx,0
jng ok
mov bx,offset queue_l
add bx,queue_len
sub bx,cx
dec bx
mov dl,byte ptr [bx]
cmp dl,tou_l
jz lose1
jmp compar
ok:
mov al,ph_food
cmp tou_h,al
jnz nofood1
mov al,pl_food
cmp tou_l,al
jz isfood
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
nofood1:;temp jmp
jmp nofood
lose1:;temp jmp
jmp step_lose
isfood:
mov bx,0005h
wcur 4,20
printsz szgood,ngood
mov bh,0
mov bl,yu_color
wcur tou_h,tou_l
print yu_shap,1
inc nfood
call food
cmp si,0
jz step_win1
mov cx,offset queue_h
add cx,queue_len
sub cx,over_h
mov si,over_h
mov di,over_h+1
cld
rep movsb
mov cx,offset queue_l
add cx,queue_len
sub cx,over_l
mov si,over_l
mov di,over_l+1
cld
rep movsb
inc queue_len
mov SUCCESS,2
mov ax,over_h
mov head_h,ax
mov ax,over_l
mov head_l,ax
mov al,tou_h
mov bx,head_h
mov byte ptr [bx],al
mov al,tou_l
mov bx,head_l
mov byte ptr [bx],al
;mov ax,queue_len
;add ax,offset queue_h
;cmp over_h,ax
;jb plug2
;mov ax,offset queue_h
;mov over_h,ax
;mov ax,offset queue_l
;mov over_l,ax
;jmp step_exit
;plug2:
inc over_h
inc over_l
jmp step_exit
step_win1:
jmp step_win

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
nofood:
mov bx,0005h
wcur 4,0
print 0,78
mov bh,0
mov bl,yu_color
wcur tou_h,tou_l
print yu_shap,1
wcur wei_h,wei_l
print 0,1
mov SUCCESS,2
mov ax,over_h
mov head_h,ax
mov ax,over_l
mov head_l,ax
mov al,tou_h
mov bx,head_h
mov byte ptr [bx],al
mov al,tou_l
mov bx,head_l
mov byte ptr [bx],al
;
inc over_h
inc over_l
mov ax,offset queue_h
add ax,queue_len
cmp over_h,ax
jb plug1
mov bx,offset queue_h
mov over_h,bx
mov bx,offset queue_l
mov over_l,bx
plug1:
mov bx,over_h
mov al,byte ptr [bx]
mov wei_h,al
mov bx,over_l
mov al,byte ptr [bx]
mov wei_l,al
jmp step_exit
;;;;;;;;;;;;;;;;;;
step_win:
mov SUCCESS,0
jmp step_exit
step_lose:
mov SUCCESS,1
cli
step_exit:
ret

step endp
food proc near

cmp ph_food,0ffh
jz food_over
mov bx,offset food_h
mov al,nfood
mov ah,0
add bx,ax
mov al,byte ptr [bx]
mov ph_food,al
mov bx,offset food_l
mov al,nfood
mov ah,0
add bx,ax
mov al,byte ptr [bx]
mov pl_food,al
mov bx,0005h
wcur ph_food,pl_food
print 03h,1
mov si,1
ret
food_over:
mov si,0
ret

food endp
score proc near

clear mar_top,mar_left,mar_down,mar_right
mov bh,0
mov bl,7
wcur 13,15
printsz szscore,nscore
wcur 13,29
mov bx,queue_len
call far ptr bin2dec
ret

score endp
yu_byebye proc near

ret

yu_byebye endp
dec_div proc far public

mov ax,bx
mov dx,0
div cx
mov bx,dx
mov dl,al
add dl,30h
mov ah,2
int 21h
ret
dec_div endp
bin2dec proc far public

mov cx,10000d
call dec_div
mov cx,1000d
call dec_div
mov cx,100d
call dec_div
mov cx,10d
call dec_div
mov cx,1d
call dec_div
ret
bin2dec endp
end yuyu_start