# Spec: Synchronisation & Timing Vidéo

## Fréquence
- **Standard** : 50Hz (50 images / seconde).
- **Durée Frame** : 20ms.
- **Budget CPU** : Environ 19 968 NOPs par frame.

## Synchronisation VBL (Vertical Blanking)
Pour éviter le cisaillement (Tearing) et assurer une vitesse constante, il faut synchroniser l'affichage avec le retour du balayage vertical.

### Méthode 1 : PPI (#F5)
Le PPI (Port B, Adresse #F5xx) permet de lire l'état de la VBL via le **Bit 0**.
- **Bit 0 = 1** : VBL en cours.
- ** Routine de Synchro** :
```asm
FRAME
    LD B,#F5
WAIT_VBL
    IN A,(C)    ; Lecture PPI
    RRA         ; Rotation Bit 0 dans le Carry
    JR NC, WAIT_VBL ; Si Carry=0 (Pas de VBL), on attend
    RET
```

### Méthode 2 : Interruptions (HALT)
Utiliser l'instruction `HALT` qui attend la prochaine interruption processeur (générée par le Gate Array 6 fois par frame, dont une au début de la VBL).
Voir Spec Interruptions pour détails.

## Timing
Si votre boucle principale dure plus de 20ms, le jeu ralentira (33Hz, 25Hz...).
Pour un scroll fluide (50fps), le code doit s'exécuter "sous la frame".
