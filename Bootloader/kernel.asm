org 0x7e00
jmp 0x0000:start

data:

    ; Dados da primeira parte(Marcelo)
    mensagem1 db 'Desvende o enigma para ajudar o Mario a encontrar seu cogumelo!',0
    mensagem2 db 'Aqui estao as pistas (escreva em minusculo):',0
    songp1 db 'Hier kommt die Sonne "do hm do do"',0
    songp2 db 'Hier kommt die Sonne',0
    songp3 db 'Und ich sage, es ist in Ordnung!',0
    morse db '-- --- ...- .. . / ... --- ..- -. -.. - .-. .- -.-. -.-',0
    mell db 'Luisa MELL',0
    answer db 'Resposta: ',0
    answer1 db '[Tente novamente] Resposta: ',0
    respostauser times 50 db 0
    resposta db 'abelha', 0
    bee db 'bee', 0
    aviso db 'tente em portugues!', 0
    mensagemfinal db 'PARABENS!',0
    acertouf1 db 'Muito esperto, passaria em md... Mas duvido passar da segunda fase!'
    
    ; Dados da segunda parte (Cleber)
    inputo times 100 db 0
    
    correti db 'A proxima fase te aguarda!',0
    nomes db 'Cleber Victor da Silva Junior - cvsj    Fabio Willian Andrade Silva- fwas       Hugo Alves Cardoso-hac                  Marcelo Cristian da Silva Brito-mcsb',0
    opcaoa db 'Fase II',0
    alta db 'PRESSIONE A -> Jogar                    PRESSIONE B -> Extras ',0
    string db 'Insira seu palpite: ',0
    errou db 'Resposta Errada',0
    
    ; Dados da terceira parte (Hugo)
    mensagem_inicial db ' Desvende o caca-palavra abaixo!',10, 13, 0
    mensagem_resposta db 'Resposta: ',0
    caca_palavra db  '    M V R T M E',10,13,'    S B C E O P',10,13,'    A E O N B A',10,13,'    R M C O W U',10,13,'    K I P E T S', 10, 13,'    E Y I O P E', 10, 13, 0
    boot_ans db 'boot',0
    sao_iguais db 'Voce acertou!',10, 13, 0
    sao_diferentes db 'Voce Errou!',10,13,0
    string_var times 20 db 0

    ; Dados da quarta parte (Fabio)
    mensagem1F db 'Resolva a charada',0
    stringF times 20 db 0
    x times 10 db 0
    valor times 10 db 0
    respostaF db '3', 0
	  mensagem2F db 'Sem sair do seu cantinho, e capaz de viajar ao redor do mundo',0
	  mensagem3 db '1 - vento',0
	  mensagem4 db '2 - passaro',0
	  mensagem5 db '3 - selo',0
	  mensagem6 db '4 - nuvem',0	
	  mensagem7 db 'acerto',0
    mensagem8 db 'Errou,Respota : selo',0

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

delay_300ms:
xor bx,bx
loop:
cmp bx, 300
je cabou
mov ah ,86h
int 15h
inc bx
call loop

cabou:
ret

stoi:							; mov si, string
	xor cx, cx
	xor ax, ax
	.loop1:
		push ax
		lodsb
		mov cl, al
		pop ax
		cmp cl, 0				; check EOF(NULL)
		je .endloop1
		sub cl, 48				; '9'-'0' = 9
		mov bx, 10
		mul bx					; 999*10 = 9990
		add ax, cx				; 9990+9 = 9999
		jmp .loop1
	.endloop1:
	ret

comparar:
    .loopi:
        xor ax, ax
        mov bx, ax
        mov si, dx
        lodsb
        mov bx, ax
        inc dx
        xor ax, ax
        mov si, cx
        lodsb
        inc cx
        cmp ax, bx
        jne .diff
        cmp ax, 0
        je .done
        jmp .loopi
        .diff:
            mov dx, 0
            jmp .end
    .done:
        mov dx, 1
    .end:
ret

igual:
	mov si, mensagem7
	call prints
	call endl
  jmp done
  

fase4:
    
    xor ax, ax
    mov ds, ax
    mov es, ax  
    mov ah, 00h  ; setando video mode 00 
    mov al, 00h
    int 10h  



   ;print charadas
    mov si, mensagem1F   
    call prints         
    call endl
	  mov si, mensagem2F  
    call prints         
    call endl
	  mov si, mensagem3    
    call prints         
    call endl
	  mov si, mensagem4    
    call prints         
    call endl
	  mov si, mensagem5    
    call prints         
    call endl
  	mov si, mensagem6    
    call prints         
    call endl


	  ;get x
    mov di, x           
    call gets


  	;compara x = 3
    mov si, x
    mov cx, si 
    mov si, resposta 
    mov dx, si 
    call comparar


    cmp dx, 1
  	je igual
  	mov si, mensagem8    
    call prints         
    call endl
    jmp fase4



fase3:

    mov bl, 15
    call clear

    mov si, mensagem_inicial
    call prints
    
    call endl

    mov si, caca_palavra
    call prints
    call endl
  
    .resposta:
      mov si, mensagem_resposta
      call prints
    
      mov di, string_var
      call gets
      call endl
      mov si, string_var
      mov cx, si
      mov si, boot_ans
      mov dx, si
      call comparar
      cmp dx, 1
        je .acertou
      cmp dx, 0
         je .errou
      .acertou:
       mov si, sao_iguais
        call prints
        call endl
          jmp .pulafase
      .errou:
        mov si, sao_diferentes
        call prints
          jmp .resposta
     .pulafase:
        call clear
          jmp fase4



fase2:
    
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    ;Código do projeto...


    
    mov ah, 00h  ; setando video mode 00 
    mov al, 00h
    int 10h


  
    mov si, opcaoa
    call prints


    mov ah, 02h
    mov bh, 00h
    mov dh, 03h
    mov dl, 10h
    int 10h

    mov ah, 09h
    mov al, 'M'
    mov bh, 00h
    mov bl, 02
    mov cx, 01
    int 10h
   
   
    mov ah, 02h
    mov bh, 00h
    mov dh, 03h
    mov dl, 11h
    int 10h

    mov ah, 09h
    mov al, 'E'
    mov bh, 00h
    mov bl, 0Ch
    mov cx, 01
    int 10h

    mov ah, 02h
    mov bh, 00h
    mov dh, 03h
    mov dl, 12h
    int 10h


    mov ah, 09h
    mov al, 'D'
    mov bh, 00h
    mov bl, 0Fh
    mov cx, 01
    int 10h


    mov ah, 02h
    mov bh, 00h
    mov dh, 03h
    mov dl, 13h
    int 10h


    mov ah, 09h
    mov al, 'I'
    mov bh, 00h
    mov bl, 01h
    mov cx, 01
    int 10h


    mov ah, 02h
    mov bh, 00h
    mov dh, 03h
    mov dl, 14h
    int 10h


    mov ah, 09h
    mov al, 'A'
    mov bh, 00h
    mov bl, 03h
    mov cx, 01
    int 10h


    mov ah, 02h
    mov bh, 00h
    mov dh, 03h
    mov dl, 16h
    int 10h


    mov ah, 09h
    mov al, 'C'
    mov bh, 00h
    mov bl, 02
    mov cx, 01
    int 10h

    mov ah, 02h
    mov bh, 00h
    mov dh, 03h
    mov dl, 17h
    int 10h


    mov ah, 09h
    mov al, 'O'
    mov bh, 00h
    mov bl, 01h
    mov cx, 01
    int 10h


    mov ah, 02h
    mov bh, 00h
    mov dh, 03h
    mov dl, 18h
    int 10h


    mov ah, 09h
    mov al, 'R'
    mov bh, 00h
    mov bl, 04h
    mov cx, 01
    int 10h


    mov ah, 02h
    mov bh, 00h
    mov dh, 09h
    mov dl, 09h
    int 10h


    xor ax, ax



    mov si, string
    call prints

     
    mov di, inputo
    call gets
    
    mov si, inputo
    call stoi   ;convertendo para int e guardando em al

    
    mov ah, 02h   ;movendo o cursor
    mov bh, 00h
    mov dh, 10h
    mov dl, 09h
    int 10h

    xor si, si
    mov si, correti
    cmp al, 5   ; vendo se a resposra ta certa
    je .courreto
    cmp al, 5   ; vendo se a resposra ta certa
    jne .erraudo
    
    .courreto:
        call prints
        call delay_300ms
        call clear
        jmp fase3

    
    .erraudo:
    mov si, errou
    call prints
    
    call delay_300ms

    call clear

    mov ah, 00h
    mov al, 00h
    int 10h

    jmp fase2

    ret
    
tab:
    mov al, 32
    call putchar
    inc bl
    cmp bl, cl
    jne tab
    cmp bl, cl
    je cabou

fase1:
    
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
    je .acertou1
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
    je .acertou1
    call strcmp
    jne .loop
    
    .acertou1:
        xor bx, bx
        mov cl, 7
        call tab
        mov si, acertouf1
        call prints
        xor bx, bx
        .loope:
            mov ah, 86h
            int 15h
            inc bl
            cmp bl, 10
            jne .loope
        call clear
        jmp fase2
    
opcao_a:
    call clear
    jmp fase1
    ret


opcao_b:
    call clear
    mov ah, 00h  ; setando video mode 00 
    mov al, 00h
    int 10h
    mov si, nomes
    call prints
    ret

getmenu:
    loop1:
        call getchar
        cmp al, 41h
        je opcao_a
        cmp al, 61h
        je opcao_a
        cmp al, 42h
        je opcao_b
        cmp al, 62h
        je opcao_b
    call loop1
    ret

main_menu:
    mov si, alta 
    call prints

    mov di, inputo
    call getmenu
    ret

start:
    
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    ;Código do projeto...
    

    call main_menu

done:
    jmp $
