org 0x7e00
jmp 0x0000:start

data:
    mensagem1 db 'Desvende o enigma para ajudar o Mario a encontrar seu cogumelo!',0
    mensagem2 db 'Aqui estao as pistas (escreva em minusculo):',0
    songp1 db 'Hier kommt die Sonne "do hm do do"',0
    songp2 db 'Hier kommt die Sonne',0
    songp3 db 'Und ich sage, es ist in Ordnung!',0
    morse db '-- --- ...- .. . / ... --- ..- -. -.. - .-. .- -.-. -.-',0
    mell db 'Luisa Mell',0
    answer db 'Resposta: ',0
    answer1 db '[Tente novamente] Resposta: ',0
    respostauser times 50 db 0
    resposta db 'abelha', 0
    bee db 'bee', 0
    aviso db 'tente em portugues!', 0
    mensagemfinal db 'PARABENS!',0

putchar:
  mov ah, 0x0e
  int 10h
  ret
    
getchar:
  mov ah, 0x00
  int 16h
  ret

delchar:
  mov al, 0x08
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08
  call putchar
  ret
  
endl:       ;Pula uma linha, printando na tela o caractere que representa o /n
  mov al, 0x0a          ; line feed
  call putchar
  mov al, 0x0d          ; carriage return
  call putchar
  ret

reverse:              ; mov si, string , pega a string apontada por si e a reverte 
  mov di, si
  xor cx, cx          ; zerar contador
  .loop1:             ; botar string na stack
    lodsb
    cmp al, 0
    je .endloop1
    inc cl
    push ax
    jmp .loop1
  .endloop1:
  .loop2:             ; remover string da stack        
    pop ax
    stosb
    loop .loop2
  ret

gets:                 ; mov di, string, salva na string apontada por di, cada caractere lido na linha
  xor cx, cx          ; zerar contador
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    cmp cl, 20        ; string limit checker
    je .loop1
    
    stosb
    inc cl
    call putchar
    
    jmp .loop1
    .backspace:
      cmp cl, 0       ; is empty?
      je .loop1
      dec di
      dec cl
      mov byte[di], 0
      call delchar
    jmp .loop1
  .done:
  mov al, 0
  stosb
  call endl
  ret

strcmp:              ; mov si, string1, mov di, string2, compara as strings apontadas por si e di
  .loop1:
    lodsb
    cmp al, byte[di]
    jne .notequal
    cmp al, 0
    je .equal
    inc di
    jmp .loop1
  .notequal:
    clc
    ret
  .equal:
    stc
    ret

  prints:             ; mov si, string
    .loop:
        lodsb           ; bota character apontado por si em al 
        cmp al, 0       ; 0 é o valor atribuido ao final de uma string
        je .endloop     ; Se for o final da string, acaba o loop
        call putchar    ; printa o caractere
        jmp .loop       ; volta para o inicio do loop
    .endloop:
    ret

clear:                   ; mov bl, color
  ; set the cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10

  ; print 2000 blank chars to clean  
  mov cx, 2000 
  mov bh, 0
  mov al, 0x20 ; blank char
  mov ah, 0x9
  int 0x10
  
  ; reset cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10
  ret
  
tab:
    mov al, 32
    call putchar
    inc bl
    cmp bl, cl
    jne tab

space:
  mov ah, 0x0e
  mov al, 32
  int 10h
  ret

start:
    
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    mov bl, 15 
    call clear
    
    xor bx, bx
    mov cl, 8
    
    call tab
            
    mov si, mensagem1
    call prints
    call endl
    call endl
    call endl

    xor bx, bx
    mov cl, 20
    call tab

    mov si, mensagem2
    call prints
    call endl
    call endl
    call endl
    
    xor bx, bx
    mov cl, 25
    call tab
   
    mov si, songp1
    call prints
    call endl
    
    xor bx, bx
    mov cl, 25
    call tab
   
    mov si, songp2
    call prints
    call endl
    
    xor bx, bx
    mov cl, 25
    call tab
   
    mov si, songp3
    call prints
    call endl
    call endl
    
    xor bx, bx
    mov cl, 13
    call tab
   
    mov si, morse
    call prints
    call endl
    call endl
    
    xor bx, bx
    mov cl, 35
    call tab
   
    mov si, mell
    call prints
    call endl
    call endl
    call endl
    call endl
    
    xor bx, bx
    mov cl, 30
    call tab
    mov si, answer
    call prints
    mov di, respostauser
    call gets
    mov cl, 65
    mov si, bee
    mov di, respostauser
    call strcmp
    je .ingles
    mov si, resposta
    mov di, respostauser
    call strcmp
    je .end
    call strcmp
    jne .loop
    
    .ingles:
    	xor bx, bx
	mov cl, 27
	call tab
	mov si, aviso
	call prints
	call endl
	jmp .loop
   
   .loop:
    xor bx, bx
    mov cl, 12
    call tab
    mov si, answer1
    call prints
    mov di, respostauser
    call gets
    mov cl, 45
    mov si, bee
    mov di, respostauser
    call strcmp
    je .ingles
    mov si, resposta
    mov di, respostauser
    call strcmp
    je .end
    call strcmp
    jne .loop
    
    xor bx, bx
    .end:
        mov al, 32
    	call putchar
    	inc bl
    	cmp bl, cl
	jne .end
    mov si, mensagemfinal
    call prints
    call endl
    jmp done

done:
    jmp $
