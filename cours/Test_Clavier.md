# Test du clavier
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Test_du_clavier.php)

## Théorie
Tester le clavier sur CPC implique de lire le registre 14 du PSG (Programmable Sound Generator), piloté par le PPI 8255.
1.  **PPI Port A** (#F400): Connecté aux données du PSG.
2.  **PPI Port C** (#F600): Contrôle le PSG (Sélection Registre, Lecture, Écriture).

## Routine de Test
Voici une routine pour tester une ligne de la matrice clavier (0 à 9).
D doit contenir le numéro de la ligne à tester.
A retournera l'état de la ligne (Bit à 0 = Touche pressée).

```asm
; Test clavier de la ligne 
; dont le numéro est dans D 
; D doit contenir une valeur de 0 à 9 

LD BC,#F40E ; Valeur 14 sur le port A 
OUT (C),C 

LD BC,#F6C0 ; C'est un registre 
OUT (C),C 
LD BC,#F600 ; Validation 
OUT (C),C 

LD BC,#F792 ; Port A en entrée 
OUT (C),C 

LD A,D ; A=ligne clavier 
OR %01000000 
LD B,#F6 
OUT (C),A 

LD B,#F4 ; Lecture du port A 
IN A,(C) ; A=Reg 14 du PSG 

LD BC,#F782 ; Port A en sortie 
OUT (C),C 
LD BC,#F600 ; Validation 
OUT (C),C 
; Et A contient la ligne
```
Ce code:
1.  Sélectionne le registre 14 du PSG.
2.  Met le Port A du PPI en entrée.
3.  Envoie la ligne à tester sur le Port C.
4.  Lit la réponse sur le Port A.
5.  Remet le Port A du PPI en sortie (très important pour le son !).
