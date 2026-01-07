# Masquage de sprite standard sans contrainte
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Masquage_de_sprite_standard_sans_contrainte.php)

## OR XOR AND
-   **AND** : Préserve les bits si 1, force à 0 si 0.
-   **OR** : Met à 1 si l'un des deux est 1. Force à 1 si 1.
-   **XOR** : Inverse si 1.

## Utilisation du masque
Le principe est d'utiliser un masque (forme du sprite en noir sur blanc) pour "trouer" le décor, puis d'afficher le sprite par dessus.

### Le Masque (AND)
Le masque doit avoir la silhouette du sprite à 0 (Encre 0) et l'extérieur à 1 (Encre 15 en Mode 0 pour avoir tous les bits à 1: %1111).
En faisant `FOND AND MASQUE`, la zone du sprite devient noire (0) sur le fond, et le reste du fond est préservé.

### Le Sprite (OR)
Le sprite doit avoir son dessin normal, mais l'extérieur (le rectangle autour) doit être à 0 (Encre 0).
En faisant `(FOND_TROUE) OR SPRITE`, le sprite se superpose au trou noir. Comme `0 OR X = X`, le sprite apparait proprement.

### Routine Type
```asm
LD A,(DE)   ; A = Masque (alterné ou séparé)
AND (HL)    ; On creuse le fond
LD C,A      ; On sauve le résultat
INC E       ; On passe au graphisme du sprite (si entrelacé)
LD A,(DE)   ; A = Sprite
OR C        ; On colle le sprite dans le trou
LD (HL),A   ; On affiche
```
Astuce : Entrelacer Masque et Sprite en mémoire pour simplifier la routine.
