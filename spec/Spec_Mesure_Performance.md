# Spec: Mesure de Performance (Rasters)

## Principe
Utiliser le **Gate Array** pour changer la couleur de la bordure (Border) de l'écran pour visualiser le temps CPU consommé.
- Le processeur exécute le code ligne par ligne.
- L'écran est balayé de haut en bas en 20ms (50Hz).
- La position verticale du raster indique le moment où le changement de couleur a lieu.

## Routine
```asm
; Début Routine
LD BC,#7F10 : OUT (C),C ; Sélection Border
LD A, #4C   : OUT (C),A ; Couleur Rouge (ou autre)

CALL ROUTINE_A_TESTER

; Fin Routine
LD BC,#7F10 : OUT (C),C 
LD A, #54   : OUT (C),A ; Couleur Noir (Restauration)
```

## Interprétation
- **Bande Fine** : Routine rapide.
- **Bande Large** : Routine lente.
- **Bande qui sautille** : Temps d'exécution variable (boucles conditionnelles variables).
- **Bande qui "dépasse" l'écran** : La routine prend plus d'une VBL (> 20ms) -> Ralentissement du jeu (25fps).
