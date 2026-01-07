# Spec: Masquage de Sprite (Standard)

## Principe
Afficher une forme non carrée sur un fond existant sans l'abimer ("Cookie Cutter").

## Méthode AND / OR
Nécessite deux bitmaps pour chaque frame de sprite :
1.  **Le Masque** :
    - Silhouette du sprite : Encre 0 (Bits à 0).
    - Extérieur : Encre 15 (Bits à 1).
    - Opération : `AND` avec le fond écran.
2.  **Le Sprite** :
    - Dessin : Couleurs normales.
    - Extérieur : Encre 0 (Bits à 0).
    - Opération : `OR` avec le résultat précédent.

## Routine
```asm
LD A,(DE)   ; Charger Masque
AND (HL)    ; "Trouer" le fond
LD C,A      ; Sauver fond troué
INC DE
LD A,(DE)   ; Charger Sprite
OR C        ; Fusionner
LD (HL),A   ; Afficher
```

## Optimisation
- **Entrelacement** : Stocker 1 octet Masque puis 1 octet Sprite en mémoire pour simplifier la routine (évite de gérer deux pointeurs sources).
