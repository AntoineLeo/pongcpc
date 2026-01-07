# Notion et evaluation du temps machine
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Notion_et_evaluation_du_temps_machine.php)

## Qu'est-ce qu'un raster
Un raster est un changement de couleur durant le balayage de l'écran par le canon à électron.
Cela permet d'avoir plus de couleurs à l'écran que la limite théorique, en changeant par exemple la palette toutes les lignes.

## Utilisation pour mesurer la performance
On peut utiliser les rasters (souvent dans le Border) pour visualiser le temps processeur pris par une routine.
**Principe** :
1.  Mettre le Border en Rouge juste avant d'appeler la routine.
2.  Mettre le Border en Noir juste après la routine.
3.  La hauteur de la bande rouge à l'écran représentera le temps d'exécution.

### Sélection de l'encre (Gate Array)
Le Port Gate Array est `#7F`.
-   Sélection Border : `OUT #7F, #10`.
-   Changement Couleur : `OUT #7F, #40 + ValeurCouleur`.

### Routine de Mesure
```asm
; ... Synchro VBL avant ...
HALT : HALT ; Attendre d'être dans l'écran visible

; DÉBUT MESURE
LD BC,#7F10 : OUT (C),C ; sélection du border 
LD A,76 : OUT (C),A ; sélection couleur rouge (#4C + #54 ?) -> 76 DEC

; VOTRE ROUTINE ICI
CALL MA_ROUTINE_A_TESTER

; FIN MESURE
LD BC,#7F10 : OUT (C),C ; sélection du border 
LD A,84 : OUT (C),A ; sélection couleur noir

JP FRAME
```
Plus la bande rouge est grande, plus votre routine est lente !
