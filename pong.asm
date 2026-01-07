; Pong CPC MVP - Mode 2
; Assembleur: RASM

    ORG #4000

START:
    di
    ld sp, #C000        
    call INIT_TABLES

    ; Initialiser le Mode 2
    ld bc, #7F8E        ; Gate Array Port + Mode 2 command
    out (c), c

    ; Initialiser les couleurs
    ld bc, #7F10        
    out (c), c
    ld bc, #7F54        ; Noir
    out (c), c
    
    ; Pen 0 (Fond) -> Noir
    ld bc, #7F00        
    out (c), c
    ld bc, #7F54        ; Noir
    out (c), c

    ; Pen 1 (Encre) -> Blanc Brillant
    ld bc, #7F01        
    out (c), c
    ld bc, #7F4B        ; Blanc
    out (c), c

    ; --- Initialisation Jeu ---
    call CLS            ; Effacer la VRAM (Important !)
    call DRAW_BOUNDARIES
    call DRAW_BALL      ; Dessine la balle initiale

MAIN_LOOP:
    ; --- VBL ---
    ld b, #F5
.wait_vbl:
    in a, (c)
    rra
    jr nc, .wait_vbl

    ; --- Logique ---
    call ERASE_BALL
    call UPDATE_POSITION
    call DRAW_BALL

    jp MAIN_LOOP


; -------------------------------------------
; ROUTINES
; -------------------------------------------

CLS:
    ld hl, #C000
    ld de, #C001
    ld bc, #3FFF    ; Taille VRAM - 1 (16KB)
    ld (hl), 0
    ldir
    ret

DRAW_BOUNDARIES:
    ; Safe Area (24,24) to (616,176)
    
    ; --- Lignes Haut (Double) ---
    ld hl, 24   ; X start
    ld de, 24   ; Y start
    ld b, 74    ; Largeur octets
.loop_top:
    push bc
    push hl
    push de     ; Save Y original (24)
    
    push hl     ; Save X pour 2eme ligne
    call PLOT_FULL_BYTE
    pop hl      ; Restore X pour 2eme ligne
    
    ; Dessine ligne Y+1
    inc e
    call PLOT_FULL_BYTE
    
    pop de      ; Restore Y original (24)
    pop hl
    ld bc, 8
    add hl, bc
    pop bc
    djnz .loop_top

    ; --- Lignes Bas (Double) ---
    ld hl, 24
    ld de, 175
    ld b, 74
.loop_bottom:
    push bc
    push hl
    push de     ; Save Y original (175)
    
    push hl     ; Save X pour 2eme ligne
    call PLOT_FULL_BYTE
    pop hl      ; Restore X pour 2eme ligne
    
    ; Dessine ligne Y+1
    inc e
    call PLOT_FULL_BYTE
    
    pop de      ; Restore Y original
    pop hl
    ld bc, 8
    add hl, bc
    pop bc
    djnz .loop_bottom

    ; --- Ligne Gauche (Double) ---
    ld de, 24    ; Y Start
    ld b, 152    ; Hauteur
.loop_left:
    push bc
    push de
    ld hl, 24
    call PLOT_PIXEL_XOR
    ld hl, 25
    call PLOT_PIXEL_XOR
    pop de
    inc e
    pop bc
    djnz .loop_left

    ; --- Ligne Droite (Double) ---
    ld de, 24
    ld b, 152
.loop_right:
    push bc
    push de
    ld hl, 615
    call PLOT_PIXEL_XOR
    ld hl, 616
    call PLOT_PIXEL_XOR
    pop de
    inc e
    pop bc
    djnz .loop_right
    
    ret

PLOT_FULL_BYTE:
    ; HL = X (aligné sur 8), DE = Y
    push hl         ; Save X
    
    ; Calcul adresse Y dans HL
    ld a, e
    ld ix, TABLE_Y_L
    ld c, a
    ld b, 0
    add ix, bc
    ld l, (ix+0)
    ld ix, TABLE_Y_H
    add ix, bc
    ld h, (ix+0)    ; HL = Adresse début de ligne
    
    pop bc          ; Récupère X dans BC car HL est occupé
    
    ; Divise X par 8 pour offset octet
    srl b
    rr c
    srl b
    rr c
    srl b
    rr c            ; BC = Offset
    
    add hl, bc      ; HL = Adresse finale
    
    ld (hl), #FF 
    ret

ERASE_BALL:
    ld hl, (OldX)
    ld de, (OldY)
    call PLOT_PIXEL_XOR
    ret

DRAW_BALL:
    ld hl, (BallX)
    ld de, (BallY)
    ld (OldX), hl
    ld (OldY), de
    call PLOT_PIXEL_XOR
    ret

UPDATE_POSITION:
    ; X
    ld hl, (BallX)
    ld de, (VelX)
    add hl, de
    ld (BallX), hl

    ; Check X Max (Mur à 615)
    ld bc, 615
    or a
    sbc hl, bc
    jr c, .test_left

    ; Rebond Droite
    call NEGATE_VEL_X
    ld hl, 614
    ld (BallX), hl
    jr .update_y

.test_left:
    ; Check X Min (Mur à 25)
    ld hl, (BallX)
    bit 7, h        
    jr nz, .do_bounce_left
    
    ld bc, 26
    or a
    sbc hl, bc
    jr nc, .update_y 

.do_bounce_left:
    ; Rebond Gauche
    call NEGATE_VEL_X
    ld hl, 26
    ld (BallX), hl

.update_y:
    ; Y
    ld hl, (BallY)
    ld de, (VelY)
    add hl, de
    ld (BallY), hl

    ; Check Y Max (Mur à 175)
    ld bc, 175
    or a
    sbc hl, bc
    jr c, .test_top

    ; Rebond Bas
    call NEGATE_VEL_Y
    ld hl, 174
    ld (BallY), hl
    jr .end_update

.test_top:
    ; Check Y Min (Mur à 25)
    ld hl, (BallY)
    ld bc, 26
    or a
    sbc hl, bc
    jr nc, .end_update

    ; Rebond Haut
    call NEGATE_VEL_Y
    ld hl, 26
    ld (BallY), hl

.end_update:
    ret

NEGATE_VEL_X:
    ld hl, (VelX)
    call NEG_HL
    ld (VelX), hl
    ret

NEGATE_VEL_Y:
    ld hl, (VelY)
    call NEG_HL
    ld (VelY), hl
    ret

NEG_HL:
    xor a
    sub l
    ld l, a
    ld a, 0
    sbc a, h
    ld h, a
    ret

; -------------------------------------------
; PLOT_PIXEL_XOR
; HL = X (0-639), DE = Y (0-199)
; -------------------------------------------
PLOT_PIXEL_XOR:
    push hl         ; Save X
    
    ; Calcul adresse Y
    ld a, e
    ld hl, TABLE_Y_L
    ld c, a
    ld b, 0
    add hl, bc
    ld a, (hl)
    ld (CALC_ADR_L+1), a
    
    ld hl, TABLE_Y_H
    add hl, bc
    ld a, (hl)
    ld (CALC_ADR_H+1), a
    
    ; Calcul adresse X
    pop hl          ; Restore X
    push hl         
    ld b, h
    ld c, l         
    
    ; X / 8 pour offset octet
    srl b
    rr c
    srl b
    rr c
    srl b
    rr c            
    
CALC_ADR_H:
    ld h, 0         ; Self-modified
CALC_ADR_L:
    ld l, 0         ; Self-modified
    add hl, bc      
    
    ; Calcul pixel mask
    pop bc          
    ld a, c
    and 7           
    
    ld de, TABLE_PIXEL_MASK
    ld c, a
    ld b, 0
    ex de, hl       
    add hl, bc
    ld a, (hl)      
    
    ex de, hl       
    
    xor (hl)
    ld (hl), a
    ret

INIT_TABLES:
    ld ix, TABLE_Y_L
    ld iy, TABLE_Y_H
    ld de, #C000
    ld b, 200
    ld c, 0
    
.loop_tables:
    ld a, e
    ld (ix+0), a
    ld a, d
    ld (iy+0), a
    
    inc ix
    inc iy
    
    ; Next Line Calc
    ld a, d
    add a, 8
    ld d, a
    
    inc c
    ld a, c
    and 7
    jr nz, .next_iter
    
    ld a, d
    sub #40
    ld d, a
    
    ld a, e
    add a, #50
    ld e, a
    jr nc, .no_carry
    inc d
.no_carry:
    
.next_iter:
    djnz .loop_tables
    ret

; -------------------------------------------
; DATA
; -------------------------------------------

BallX:  dw 320
BallY:  dw 100
OldX:   dw 320
OldY:   dw 100
VelX:   dw 2
VelY:   dw 1

    ALIGN 256
TABLE_Y_L:  defs 200
TABLE_Y_H:  defs 200

TABLE_PIXEL_MASK:
    db #80, #40, #20, #10, #08, #04, #02, #01

    ; Generation DSK
    SAVE "PONG.BIN", START, $-START, DSK, "pong.dsk"
