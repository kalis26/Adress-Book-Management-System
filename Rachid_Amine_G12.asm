

; ******************* Definition du segment stack *********************;

stack segment stack
    
    db 64 dup(?)
    
stack ends


    
;******************** Definition du segment data **********************;

data segment
    
    buffer db 11
           db ?
           db 11 dup(?)
           
    contacts db 352 dup(?)
    
    choice db 0
    
    mess1 db 'Enter the name of the contact: $'
    mess2 db 'Enter the phone number of the contact: $'
    mess12 db 'Contact deleted successfuly.$'
    mess13 db 'Phone number modified successfully.$'
    
    mess14 db '----- TP realise par : Rachid Mustapha Amine G12 -----$'
    mess3 db '----- Address Book Managment -----$'
    mess4 db ' 1. Add a contact$'
    mess5 db ' 2. View contacts$'
    mess6 db ' 3. Search a contact$'
    mess7 db ' 4. Modify a contact$'
    mess8 db ' 5. Delete a contact$'
    mess18 db ' 6. Display contacts with a criteria$'
    mess9 db ' 7. Exit$'
    mess10 db 'Choose an option : $'
    
    mess11 db 'Press enter to continue ...$'
    
    mess15 db '1. Display all contacts whose names start with a given prefix$'
    mess16 db '2. Display all contacts whose phone number contains the given sequence$'
    mess17 db 'Enter the prefix: $'
    mess19 db 'Enter the sequence of numbers: $'
    
    
    namemess db 'Name : $' 
    phonemess db ' / Phone number : $'
    
    error1 db 'You cannot enter a new contact. Address book is full.$'
    error2 db 'Contact not found.$'
    error3 db 'Choose a correct option.$'
    error4 db 'No contacts. Address book is empty.$'
    
    count db 0
    
    newline db 13, 10, '$'
    
    two db 22
    
    choice2 db 0                                           
    
data ends



;************************** Debut du code *****************************;

code segment 
    
    assume DS:data,CS:code,SS:stack
    
    
    
    
    ;********* Programme principal **********;
    
    start:  mov ax, data
            mov DS, ax
            mov ax, stack
            mov SS, ax
            mov SP, 64
    
            mov si, 0
    
    menuloop:   call showmenu
                cmp al, 7
                je endprogram    
                jmp menuloop
    
    
    endprogram: mov ah, 4Ch
                int 21h 
                
    ;****************************************;
    
                
                
                        

;*********** Macro pour ecrire un string dans l'ecran ***********;                       
      
write macro text
    
    lea dx, text
    mov ah, 9
    int 21h
    
endm




;********* Macro pour lire un string depuis le clavier **********;

read macro text
    
    lea dx, text
    mov ah, 0Ah
    int 21h
    
endm





;******* Montrer le message 'Press enter to continue...' ********;
;________ apres avoir vide le buffer s'il n'est pas vide ________;

flush_and_wait_enter proc near

    flush_loop: mov ah, 01h
                int 16h
                jz done_flush

                mov ah, 00h
                int 16h
                jmp flush_loop

    done_flush: write newline
                write newline
                write mess11

    wait_loop:  mov ah, 00h
                int 16h
                cmp al, 13
                jne wait_loop

                ret

flush_and_wait_enter endp





;********************* Compter les contacts *********************;
        
countcon proc near
    
            mov si, 21
            mov count, 0
    
    begin:  cmp contacts[si], '$'
            je next
            jmp done
    next:   add si, 22
            inc count
            jmp begin
    
    done:   cmp si, 21
            jne norm
            sub si, 21
            jmp endcount
            
    norm:   sub si, 22
    
    endcount:   ret
    
countcon endp





;********* Ajouter un contact dans l'ordre alphabetique *********;

addcontact proc near 
                                                           
                call countcon
                cmp si, 0
                jne si_zero
                inc si
                jmp fin_si
    si_zero:    inc si                                                         
    fin_si:     mov bl, count
                cmp bl, 16
                je error

                mov al, count
                cbw
                mov bl, 22
                mul bl             
                mov si, ax        

                write newline
                write newline
                write mess1
                read buffer
                
                mov si, 0
                mov di, 2
                
                cmp count, byte ptr 0
                je beforeaddname
                
                mov al, count
                cbw
                mov cx, ax
                
                mov bx, 0
                
    findpos:    mov al, buffer[di]
                sub al, 20h
                cmp al, 41h
                jge toupperC
                add al, 20h
    toupperC:   mov dl, contacts[si]
                sub dl, 20h
                cmp dl, 41h
                jge finTU
                add dl, 20h
    finTU:      cmp al, dl
                jg skiptonext
                jne decidedpos
                inc si
                inc di
                inc bx
                jmp findpos
                
    decidedpos: sub si, bx
                mov al, count
                cbw
                mul byte ptr two
                mov cx, ax
                sub cx, si
                
                jmp shiftcontacts
                
    skiptonext: sub si, bx
                sub di, bx
                mov bx, 0
                add si, 22
                dec cx
                cmp cx, 0
                jne findpos
                jmp beforeaddname            
                
    shiftcontacts:  push si
                    mov al, count
                    cbw
                    mul byte ptr two
                    mov di, ax
                    add ax, 22
                    mov si, ax
                    inc cx
    shiftloop:      mov al, contacts[di]
                    mov contacts[si], al
                    dec si
                    dec di
                    loop shiftloop
                    
                pop si
                push si
                mov cx, 22 
                
    spaceloop:  mov contacts[si], byte ptr 0
                inc si
                loop spaceloop
                
                pop si                
                                  
                
    beforeaddname:  mov di, 2
                    mov al, buffer[1]
                    cbw
                    mov cx, ax
             
    addname:    mov bl, buffer[di]
                mov contacts[si], bl
                inc di
                inc si
                loop addname

                mov al, 10
                sub al, buffer[1]
                cbw
                mov cx, ax

    padname:    cmp cx, 0
                je padname_d
                inc si
                dec cx
                jmp padname
                
    padname_d:  mov contacts[si], '$'
                inc si

                write newline
                write mess2
                read buffer

                mov di, 2
                mov al, buffer[1]
                cbw
                mov cx, ax
    
    addphone:   mov bl, buffer[di]
                mov contacts[si], bl
                inc di
                inc si
                loop addphone

                mov al, 10
                sub al, buffer[1]
                cbw
                mov cx, ax

    padphone:   cmp cx, 0
                je padphone_done
                inc si
                dec cx
                jmp padphone
    
    padphone_done:  mov contacts[si], '$'
                    inc si

                jmp doneCONT

    error:      write newline
                write error1

    doneCONT:   ret

addcontact endp

    
    
    
;******************** Afficher les contacts *********************;  

viewcontact proc near
    
                pusha
    
                call countcon
                mov al, count
                cbw
                inc ax
                mov cx, ax
                dec cx
                cmp cx, 0
                je errorview
                mov si, 0
                
                write newline
    
    viewloop:   write newline
    
                write namemess 
                write contacts[si]
                
                
                add si, 11
                
                write phonemess
                write contacts[si]
                
                add si, 11
                
                write newline
                 
                loop viewloop
                
                jmp endview
    
    errorview:  write newline
                write newline 
                write error4
    
    endview:    popa
                ret 
    
viewcontact endp

      
      
           
      
;********************* Chercher un contact **********************;     

searchcontact proc near
             
                write newline
                write newline
                write mess1
                read buffer
                
                call countcon
                
                mov al, count
                cbw
                mul byte ptr two
                mov cx, ax
                
                mov si, 0
                mov di, 2
            
    compare:    cmp cx, 0
                je searcherr
                mov al, buffer[1]
                inc al
                cbw
                cmp ax, di
                jl found 
                mov al, contacts[si]
                cmp al, '$'
                jne continue
                mov di, 2
                inc si
                dec cx
                jmp compare
    continue:   cmp al, buffer[di]
                jne not_equal
    equal:      inc si
                inc di
                dec cx
                jmp compare
    not_equal:  mov di, 2
                inc si
                dec cx
                jmp compare
                
    searcherr:  write newline
                write newline
                write error2
                jmp endsearch
    
    found:      dec si
                cmp si, 0
                je next_step
                mov al, contacts[si]
                cmp al, '$'
                jne found
                inc si
    
    next_step:  write newline
                write newline 
                write namemess
                write contacts[si]
                add si, 11
                write phonemess
                write contacts[si]
    
    endsearch:  ret
    
searchcontact endp

     
     


;********************* Modifier un contact **********************;

modifycontact proc near
    
    search_loop1:    call searchcontact
                    cmp si, 352
                    jge search_loop1
                    
                    write newline
                    write newline
                    write mess2
                    read buffer
                    mov di, 2
                    mov al, buffer[1]
                    cbw
                    mov cx, ax
                    
    modify_loop:    mov bl, buffer[di]
                    mov contacts[si], bl
                    inc si
                    inc di
                    loop modify_loop
                    
      padphoneM:    mov al, contacts[si]
                    cmp al, '$'
                    je donemodify
                    mov contacts[si], byte ptr 0
                    inc si
                    jmp padphoneM
                    
     donemodify:    write newline
                    write newline
                    write mess13
                    
                    ret
                    
modifycontact endp 
                    


     
     
;******************** Supprimer un contact *********************;    

deletecontact proc near
    
                    call countcon
                    mov al, count
                    cbw
                    mul byte ptr two
                    mov bx, ax
    
    search_loop2:   call searchcontact
                    cmp si, 352
                    jge search_loop2
                    sub si, 11
                    mov di, si
                    add di, 22
    
    delete_loop:    cmp di, bx
                    jge fillspace
                    mov al, contacts[di]
                    mov contacts[si], al
                    inc si
                    inc di
                    jmp delete_loop
                    
    fillspace:      cmp si, bx
                    jge end_dloop
                    mov al, '.'
                    mov contacts[si], al
                    inc si
                    jmp fillspace
                    
    end_dloop:      write newline
                    write newline
                    write mess12
                    ret
                                 

    
deletecontact endp 




;************ Afficher un contact selon un critere *************;

displaycontactprefix proc near
    
                    write newline
                    write newline          
                    write mess15
                    write newline
                    write mess16          
                              
        beginop2:   write newline
                    write newline
                    write mess10
    
 
                    mov ah, 1
                    int 21h
       
                    sub al, '0'
                    mov choice2, al
       
                    cmp al, 1
                    jne opd2
                    
                    write newline
                    write newline
                    write mess17
                    read buffer
        
                    call countcon
                    mov al, count
                    cbw
                    mov cx, ax
                    cmp cx, 0
                    je errorview2
                    mov si, 0
                    mov di, 2
        
        startdisplay1:  push si 
    
        compare2:   mov al, buffer[di]
                    cmp al, 0Dh
                    je wasfound2
                    
                    sub al, 20h
                    cmp al, 41h
                    jge toupperC2
                    add al, 20h
                    
        toupperC2:  mov dl, contacts[si]
                    cmp al, '$'
                    je beforeend2
                    
                    sub dl, 20h
                    cmp dl, 41h
                    jge finTU2
                    add dl, 20h
                
        finTU2:     cmp dl, al
                    jne beforeend2
                
                    inc si
                    inc di
                    jmp compare2
            
            
        endmess2:   cmp contacts[si], byte ptr '$'
                    je wasfound2
                    pop si
                    jmp end2
                
            
        wasfound2:  pop si
                    push si
                    write newline
                    write newline
                    write namemess
                    write contacts[si]
                    add si, 11
                    write phonemess
                    write contacts[si]
                    pop si
                    jmp end2
                    
        beforeend2: pop si
               
        end2:   add si, 22
                mov di, 2

                loop startdisplay1
                jmp endop2
                
                
                
                
          
       
        opd2:   cmp al, 2
                jne errorop2
                
                write newline
                write newline
                write mess19
                read buffer
        
                call countcon
                mov al, count
                cbw
                mov cx, ax
                cmp cx, 0
                je errorview2
                mov si, 11
                mov di, 2
                
                
                
        startdisplay2:  push si
        
        
        begincomp3: mov bx, si
        
        compare3:   mov al, contacts[bx]
                    cmp al, '$'
                    je endmess3
                    
                    mov al, buffer[di]
                    cmp al, 0Dh
                    je wasfound3
                    
                    cmp al, contacts[bx]
                    jne next3
                    
                    inc di
                    inc bx
                    jmp compare3
                    
        next3:  inc si
                jmp begincomp3
                
        endmess3:   cmp buffer[di], 0Dh
                    je wasfound3
                    jmp beforeend3
                    
                
        wasfound3:  pop si
                    push si
                    write newline
                    write newline
                    sub si, 11
                    write namemess
                    write contacts[si]
                    add si, 11
                    write phonemess
                    write contacts[si]
                    pop si
                    jmp end3
                    
        beforeend3: pop si
                   
        end3:   add si, 22
                mov di, 2
                loop startdisplay2
                jmp endop2 
        
       
       
        errorop2:   write newline
                    write error3
                    jmp beginop2
        
        errorview2: write newline
                    write newline 
                    write error4
    
        endop2: ret
        
displaycontactprefix endp
    
       
    
             
     
;************************* Clear Screen *************************;    
  
clearscreen proc near 
    
    mov ah, 06h
    mov al, 0
    mov bh, 07h
    mov cx, 0
    mov dx, 184Fh
    int 10h 
    
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h
    
    ret
    
clearscreen endp  
  
         
         
         
         
;*********************** Afficher le menu ***********************;        
         
showmenu proc near
    
    call clearscreen
    
    write mess14
    write newline         
    write mess3
    write newline
    write newline
    write mess4
    write newline
    write mess5
    write newline
    write mess6
    write newline
    write mess7
    write newline
    write mess8
    write newline
    write mess18
    write newline
    write mess9
    write newline
    
    call chooseoption
    
    call flush_and_wait_enter
    
    mov al, choice
    
    ret
    
showmenu endp
    
    
    
    
    
;*************** Choisir une option dans le menu ****************;   
    
chooseoption proc near
    
    beginop: write newline
    write mess10
    
    mov ah, 1
    int 21h
    
    sub al, '0'
    mov choice, al
    
    cmp al, 1
    jne op2
    call addcontact
    jmp endop
    
    op2: cmp al, 2
    jne op3
    call viewcontact
    jmp endop
    
    op3: cmp al, 3
    jne op4
    call searchcontact
    jmp endop
    
    op4: cmp al, 4
    jne op5
    call modifycontact
    jmp endop
    
    op5: cmp al, 5
    jne op6
    call deletecontact
    jmp endop
    
    op6: cmp al, 6
    jne op7
    call displaycontactprefix    
    jmp endop
    
    op7: cmp al, 7
    jne errorop
    jmp endop
    
    errorop: write newline
    write error3
    jmp beginop
    
    
    endop: mov al, choice
    ret
    
chooseoption endp




;****************************************************************;

    
code ends
    end start 