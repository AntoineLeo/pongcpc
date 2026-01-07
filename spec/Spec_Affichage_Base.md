# Spec: Affichage de Base

## Concepts Clés
- **Écriture Directe** : L'écran est une zone de RAM (#C000-#FFFF).
- **Instruction Clé** : `LD (Adresse), A` (Charge l'accumulateur A dans l'adresse RAM).
- **Visualisation Immédiate** : Pas de "flip" ou de "refresh" à appeler manuellement pour l'affichage statique.

## Modes Graphiques (Rappel)
- **Mode 0** : 16 couleurs, 160x200 (2 pixels/octet).
- **Mode 1** : 4 couleurs, 320x200 (4 pixels/octet).
- **Mode 2** : 2 couleurs, 640x200 (8 pixels/octet). 1 bit = 1 pixel.

## Exemple d'Affichage
```asm
LD A, %11111111  ; Pixel plein (Tous les bits à 1)
LD (#C000), A    ; Allume 8 pixels (Mode 2) au premier octet écran
```

## Pièges Fréquents
- **Écrasement Code** : Ne jamais stocker de code exécutable dans la zone écran (#C000-#FFFF) sauf techniques très avancées (effacement code).
- **Conflits Registres** : `LD (HL), A` modifie la RAM pointée par HL. Assurez-vous que HL pointe bien vers l'écran.
