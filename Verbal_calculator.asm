
CR equ 13d     
LF equ 10d

dane segment
wejscie db 80 dup<?>              
powitanie db " wprowadz slowny opis dzialania",'$'   
operator db ?
skladnik1 db ?
skladnik2 db ? 
A0 db "zero",'$'
A1 db "jeden",'$'
A2 db "dwa",'$'
A3 db "trzy",'$'
A4 db "cztery",'$'
A5 db "piec",'$'
A6 db "szesc",'$'
A7 db "siedem",'$'
A8 db "osiem",'$'
A9 db "dziewiec",'$'
I0 db "dziesiec",'$'
I1 db "jedenascie",'$'
I2 db "dwanascie",'$'
I3 db "trzynascie",'$'
I4 db "czternascie",'$'
I5 db "pietnascie",'$'
I6 db "szesnascie",'$'
I7 db "siedemnascie",'$'
I8 db "osiemnascie",'$'
I9 db "dziewietnascie",'$'
DWA db "dwadziescia",'$'
TR db "trzydziesci",'$'
CZ db "czterdziesci",'$'
PI db "piecdziesiat",'$'
SZ db "szescdziedziat",'$'
SIE db "siedemdziesiat",'$'
OS  db "osiemdziesiat",'$'
DZ  db "dziewiecdziesiat",'$'
znak_minus db "minus",'$'
blad db "bledne dane!",'$'  
wynik db ?
jednosc db ?
dziesietnosc db ?
      
                
                
                
                
                
dane ends


kod segment
    
start:     
	mov ax,seg w_stosu
	mov ss,ax
	mov sp,offset w_stosu
    
    mov ax, dane 
    mov ds, ax
    
    mov dx, offset powitanie
    call wypisz
    call nowa_linia    
                
               
    call program            
  
     
    call koniec   





program:
    call gets_dekoduj
    call nowa_linia
    mov bx, offset wejscie
    call pomin_spacje
    call petla_liczba
    mov skladnik1, dl
    inc bx
    call pomin_spacje
    call petla_operator
    mov operator, dl
    inc bx
    call pomin_spacje
    call petla_liczba
    mov skladnik2, dl
    inc bx
    call szukaj_konca
  
    
    cmp operator, 0
    je plus
    cmp operator, 1
    je minus
    cmp operator, 2
    je razy
    
   



;;Funkcje podstawowe
koniec:
	mov al,0 ;zwrocimy 0 do systemu
	mov ah,04ch ;numer programu wracajacego do systemu
	int 021h ;wykonac    


wypisz:
    mov ax, dane
	mov ds,ax
	mov ah,9 ;wypisz string zakonczony $
	int 21h ;wykonac
	ret
getc: ;bierze znak z klawiatury i wpisuje do al
	mov ah,1h
	int 21h;
	ret
putc: ;wypisuje znak z dl na ekran
	mov ah,2h
	int 21h
	ret
	spacja: ;wypisuje spacje
	mov dl,' '
	call putc
	ret
putc_spacja: ;putc i spacja
	call putc
	call spacja
	ret

nowa_linia: ;wypisuje nowa linie
	mov dl,CR
	call putc
	mov dl,LF
	call putc
	ret
	
gets_dekoduj: 
		mov bx,offset wejscie ;wskaznik na poczatek tablicy
		mov cl,0d ;licznik znakow wpisanych
		
bierz_nastepny_dekoduj:
		call getc ;wczytujemy znak do al i sprawdzamy go:
		;;warunki konca -OR
		cmp al,CR	;czy juz koniec ciagu znakow (wcisniety ENTER)?
		je koniec_gets_dekoduj
		cmp cl,100d ;Czy juz wpisano 100 znakow?
		je koniec_gets_dekoduj		
		mov byte ptr [bx],al ;wpisujemy znak do talicy
		inc bx	;zwiekszamy wskaznik i licznik
		inc cl
		
		jmp bierz_nastepny_dekoduj
		

koniec_gets_dekoduj:
        mov byte ptr [bx], ' '
        inc bx
		mov byte ptr [bx],'$' ;Koncze ciag znakow '$'
		ret                                             
		
		
		
		
	
dekoduj_i_wypisz:
		call nowa_linia	;dla estetyki
		
	
		mov bx, offset wejscie

		;;sprawdzamy, czy input nie zaczyna sie od spacjii i pomijamy je:
	pomin_spacje:
		;;najpierw szczgolny przypadek- w ogole nie ma znakow
		cmp byte ptr [bx],'$' 
		je NO	;koniec!
		
		cmp byte ptr [bx],' ' 		;jesli bx wskazuje na spacje, to bx++
		je dalej
		cmp byte ptr [bx],9
		je dalej
		ret
		dalej:
		inc bx
		jmp pomin_spacje
		
		
	szukaj_konca:  
	;;najpierw szczgolny przypadek- w ogole nie ma znakow
		cmp byte ptr [bx],'$' 
		jne dalejj
		ret 
		
		dalejj:
		cmp byte ptr [bx],' ' 		
		je dalejjj
		cmp byte ptr [bx], 9
		je dalejjj
		call NO
		dalejjj:
		inc bx
		jmp szukaj_konca
		
	petla_liczba:
	    
		mov cx,bx ;zapisuje na boku adres przetwazanego znaku morse'aa 
		
		;;sprawdzamy, czy juz koniec
		
		
	
	NZE:
		cmp byte ptr [bx],'z'
		jne NJE
		inc bx
		cmp byte ptr [bx],'e'
		jne NJE
		inc bx
		cmp byte ptr [bx],'r' 
		jne NJE
		inc bx  
		cmp byte ptr [bx],'o' 
		jne NJE
	    mov dl, 0
		ret
		
	NJE:
		mov bx,cx			
		cmp byte ptr [bx],'j'
		jne NDW
		inc bx
		cmp byte ptr [bx],'e'
		jne NDW
		inc bx
		cmp byte ptr [bx],'d'
		jne NDW
		inc bx
		cmp byte ptr [bx],'e'
		jne NDW
		inc bx
		cmp byte ptr [bx],'n'
		jne NDW				
		mov dl,1
		ret
	
	NDW:
		mov bx, cx			
		cmp byte ptr [bx],'d'
		jne NTR
		inc bx
		cmp byte ptr [bx],'w'
		jne NTR
		inc bx
		cmp byte ptr [bx],'a'
		jne NTR
		mov dl,2
		ret 
		
	NTR:
		mov bx, cx			
		cmp byte ptr [bx],'t'
		jne NCZ
		inc bx
		cmp byte ptr [bx],'r'
		jne NCZ
		inc bx
		cmp byte ptr [bx],'z'
		jne NCZ
		inc bx
		cmp byte ptr [bx],'y'
		jne NCZ
		mov dl,3
		ret
	NCZ:
		mov bx, cx			
		cmp byte ptr [bx],'c'
		jne NPI
		inc bx
		cmp byte ptr [bx],'z'
		jne NPI
		inc bx
		cmp byte ptr [bx],'t'
		jne NPI
		inc bx
		cmp byte ptr [bx],'e'
		jne NPI
		inc bx
		cmp byte ptr [bx],'r'
		jne NPI 
		inc bx
		cmp byte ptr [bx],'y'
		jne NPI
		mov dl,4
		ret
	NPI:
		mov bx, cx			
		cmp byte ptr [bx],'p'
		jne NSZ
		inc bx
		cmp byte ptr [bx],'i'
		jne NSZ
		inc bx
		cmp byte ptr [bx],'e'
		jne NSZ
		inc bx
		cmp byte ptr [bx],'c'
		jne NSZ
		mov dl,5
		ret
	NSZ:
		mov bx, cx			
		cmp byte ptr [bx],'s'
		jne NSI
		inc bx
		cmp byte ptr [bx],'z'
		jne NSI
		inc bx
		cmp byte ptr [bx],'e'
		jne NSI
		inc bx
		cmp byte ptr [bx],'s'
		jne NSI
		inc bx
		cmp byte ptr [bx],'c'
		jne NSI
		mov dl,6
		ret
	NSI:
		mov bx, cx			
		cmp byte ptr [bx],'s'
		jne NOS
		inc bx
		cmp byte ptr [bx],'i'
		jne NOS
		inc bx
		cmp byte ptr [bx],'e'
		jne NOS
		inc bx
		cmp byte ptr [bx],'d'
		jne NOS
		inc bx 
		cmp byte ptr [bx],'e'
		jne NOS
		inc bx
		cmp byte ptr [bx],'m'
		jne NOS
		mov dl,7
		ret
	NOS:
		mov bx, cx			
		cmp byte ptr [bx],'o'
		jne NDZ
		inc bx
		cmp byte ptr [bx],'s'
		jne NDZ
		inc bx
		cmp byte ptr [bx],'i'
		jne NDZ
		inc bx
		cmp byte ptr [bx],'e'
		jne NDZ
		inc bx 
		cmp byte ptr [bx],'m'
		jne NDZ
		mov dl,8
		ret
	NDZ:
		mov bx, cx			
		cmp byte ptr [bx],'d'
		jne NO
		inc bx
		cmp byte ptr [bx],'z'
		jne NO
		inc bx
		cmp byte ptr [bx],'i'
		jne NO
		inc bx
		cmp byte ptr [bx],'e'
		jne NO
		inc bx 
		cmp byte ptr [bx],'w'
		jne NO
		inc bx
		cmp byte ptr [bx],'i'
		jne NO
		inc bx
		cmp byte ptr [bx],'e'
		jne NO
		inc bx
		cmp byte ptr [bx],'c'
		jne NO
		mov dl,9
		ret
		
		NO:
		mov dx, offset blad
		call wypisz 
		call koniec 
			   
   
   
   
petla_operator:  
		mov cx,bx 
		

		
		
		
	dodac:
		cmp byte ptr [bx],'p'
		jne odjac
		inc bx
		cmp byte ptr [bx],'l'
		jne odjac
		inc bx
		cmp byte ptr [bx],'u' 
		jne odjac
		inc bx  
		cmp byte ptr [bx],'s' 
		jne odjac
	    mov dl, 0
		ret
		
	odjac:
		mov bx,cx			
		cmp byte ptr [bx],'m'
		jne mnoz
		inc bx
		cmp byte ptr [bx],'i'
		jne mnoz
		inc bx
		cmp byte ptr [bx],'n'
		jne mnoz
		inc bx
		cmp byte ptr [bx],'u'
		jne mnoz
		inc bx
		cmp byte ptr [bx],'s'
		jne mnoz			
		mov dl,1
		ret
		
	mnoz:
		cmp byte ptr [bx],'r'
		jne NO
		inc bx
		cmp byte ptr [bx],'a'
		jne NO
		inc bx
		cmp byte ptr [bx],'z' 
		jne NO
		inc bx  
		cmp byte ptr [bx],'y' 
		jne NO
	    mov dl, 2
		ret
		  









   
   
   
wynik_koncowy:
    czy_jedna_cyfra:
        mov dl, 10
        mov ah, 0
        mov al,wynik
        div dl 
        cmp al, 1
        mov jednosc, ah
        je wypisz_nascie
        cmp al, 0 
        jne dwie_cyfry
        mov jednosc, ah
        call wypisz_jednosc
        ret
    dwie_cyfry:
        cmp jednosc, 0
        jne cale
         mov dziesietnosc, al
        call wypisz_dziesietnosc
        ret
        
        cale:
        mov jednosc, ah
        mov dziesietnosc, al
        call wypisz_dziesietnosc 
        call spacja
        call wypisz_jednosc
        ret 
                       
wypisz_nascie: 
    mov al, jednosc   
    Dzero:
    cmp al,0
    jne Djeden
    mov dx,offset I0
    call wypisz    
    ret
    Djeden:
    cmp al,1
    jne Ddwaa
    mov dx,offset I1
    call wypisz 
    ret
    Ddwaa:
    cmp al,2
    jne Dtrzyy
    mov dx,offset I2
    call wypisz  
    ret
    Dtrzyy:
    cmp al,3
    jne Dcztery
    mov dx,offset I3
    call wypisz
    ret
    Dcztery:
    cmp al,4
    jne Dpiec
    mov dx,offset I4
    call wypisz
    ret
    Dpiec:
    cmp al,5
    jne Dszesc
    mov dx,offset I5
    call wypisz 
    ret
    Dszesc:
    cmp al,6
    jne Dsiedem
    mov dx,offset I6
    call wypisz 
    ret
    Dsiedem:
    cmp al,7
    jne Dosiem
    mov dx,offset I7
    call wypisz
    ret
    Dosiem:
    cmp al,8
    jne Ddziewiec
    mov dx,offset I8
    call wypisz
    ret
    Ddziewiec:
    mov dx,offset I9
    call wypisz
    ret
                           
     
wypisz_jednosc:
    mov al, jednosc   
    zero:
    cmp al,0
    jne jeden
    mov dx,offset A0
    call wypisz
    ret 
    jeden:
    cmp al,1
    jne dwaa
    mov dx,offset A1
    call wypisz
    ret
    dwaa:
    cmp al,2
    jne trzyy
    mov dx,offset A2
    call wypisz
    ret
    trzyy:
    cmp al,3
    jne cztery
    mov dx,offset A3
    call wypisz
    ret
    cztery:
    cmp al,4
    jne piec
    mov dx,offset A4
    call wypisz
    ret
    piec:
    cmp al,5
    jne szesc
    mov dx,offset A5
    call wypisz
    ret
    szesc:
    cmp al,6
    jne siedem
    mov dx,offset A6
    call wypisz
    ret
    siedem:
    cmp al,7
    jne osiem
    mov dx,offset A7
    call wypisz
    ret
    osiem:
    cmp al,8
    jne dziewiec
    mov dx,offset A8
    call wypisz
    ret
    dziewiec:
    mov dx,offset A9
    call wypisz
    ret
    

wypisz_dziesietnosc:
 mov al, dziesietnosc   
   
    DDdwaa:
    cmp al,2
    jne DDtrzyy
    mov dx,offset DWA
    call wypisz  
    ret
    DDtrzyy:
    cmp al,3
    jne DDcztery
    mov dx,offset TR
    call wypisz
    ret
    DDcztery:
    cmp al,4
    jne DDpiec
    mov dx,offset CZ
    call wypisz
    ret
    DDpiec:
    cmp al,5
    jne DDszesc
    mov dx,offset PI
    call wypisz
    ret
    DDszesc:
    cmp al,6
    jne DDsiedem
    mov dx,offset SZ
    call wypisz
    ret
    DDsiedem:
    cmp al,7
    jne DDosiem
    mov dx,offset SIE
    call wypisz
    ret
    DDosiem:
    cmp al,8
    jne DDdziewiec
    mov dx,offset OS
    call wypisz
    ret
    DDdziewiec:
    mov dx,offset DZ
    call wypisz
    ret  
    
    
plus:
     mov al, skladnik2
    add al, skladnik1
    mov wynik, al
    call wynik_koncowy
    ret           
                
                
                
minus: 
    mov al, skladnik1  
    cmp al, skladnik2   
    jnb odejmij
    mov al, skladnik1
    xchg al, skladnik2
    mov skladnik1, al
    mov dx, offset znak_minus
    call wypisz
    call spacja
    call odejmij
    ret

odejmij:
    mov al, skladnik1
    sub al, skladnik2
    mov wynik, al
    call wynik_koncowy
    ret    
    
   




razy:
    mov al, skladnik1
    mul skladnik2
    mov wynik,al
    call wynik_koncowy
    ret




  
kod ends      

stos1 segment stack
		dw	250 dup(?)
w_stosu	dw 	? 	;wierzcholek stosu
stos1 ends

end start ; set entry point and stop the assembler.
