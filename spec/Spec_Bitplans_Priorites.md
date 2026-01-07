# Spec: Technique 2 Bitplans (Priorité)

## Concept
Utiliser les plans de bits du Mode 0 (4 bits par pixel) pour simuler des calques de priorité (Avant/Arrière plan) via la palette de couleurs.

## Configuration des Bits
- **Bits 0-1** : Réservés au DÉCOR (4 motifs possibles).
- **Bits 2-3** : Réservés au SPRITE (3 motifs possibles + Transparent).

## Configuration Palette
Pour que le Sprite passe DEVANT le décor, il faut que ses couleurs écrasent visuellement celles du décor.
- Si Bits 2-3 (Sprite) != 0, alors la couleur est celle du Sprite, peu importe Bits 0-1.
- Cela oblige à dupliquer les encres dans la palette (Gate Array).
    - Ex: Encres 4, 5, 6, 7 (où Bits 2-3 = 01) doivent toutes être ROUGE.
    - Ex: Encres 8, 9, 10, 11 (où Bits 2-3 = 10) doivent toutes être JAUNE.

## Avantage
- Gestion de priorité "Hardware" sans masque complexe.
- L'effacement du sprite se fait en mettant les bits 2-3 à 0 (Masque `%00000011` sur l'octet), ce qui révèle instantanément le décor stocké dans les bits 0-1.
