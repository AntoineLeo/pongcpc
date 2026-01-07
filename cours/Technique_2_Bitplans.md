# Technique 2 bitplans
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Technique_2_bitplans.php)

## Principe
Séparer les bits d'un pixel (Mode 0 : 4 bits) en deux groupes.
-   2 bits pour le décor (Bit 0 et 1).
-   2 bits pour les sprites (Bit 2 et 3).

### Configuration des Encres
En Mode 0, un pixel a 16 couleurs possibles (%0000 à %1111).
Si on utilise les bits 2 et 3 pour le sprite, on veut que peu importe la valeur du fond (bits 0 et 1), la couleur affichée soit celle du sprite.
Cela implique de définir plusieurs encres identiques.
Si le sprite a la valeur %11xx (bits 2 et 3 à 1), alors les encres 12 (%1100), 13 (%1101), 14 (%1110) et 15 (%1111) doivent avoir la MÊME couleur (ex: Rouge).
Ainsi, que le fond soit 0, 1, 2 ou 3, on verra du Rouge.

### Avantages
-   Priorité matérielle : Le sprite passe "devant" ou "derrière" le décor selon la palette.
-   Pas de masquage complexe nécessaire.
-   Effacement simple : on vide les bits du sprite sans toucher ceux du décor.

### Inconvénients
-   Réduit le nombre de couleurs affichables simultanément (4 couleurs pour le décor, 3 pour le sprite + transparent).
