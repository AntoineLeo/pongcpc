# Spec: Double Buffering

## Objectif
Affichage sans clignotement ni tearing.
- Écran Visible : #C000.
- Écran de Travail (Caché) : #4000.

## Technique Hardware (Mode #C3)
Pour que le Z80 puisse écrire en #4000 (Bank 1 normale) et que cela atterrisse parfois dans l'écran visible (#C000 Bank 3) :
1.  Utiliser le **Gate Array Mode #C3** : Mappe la Bank 3 (Ecran) en adresse logiques #4000-#7FFF.
2.  Utiliser le **CRTC R12/R13** : Changer l'adresse de début d'affichage vidéo (#C000 ou #4000).

## Routine Loop
1.  Z80 écrit toujours en #4000.
2.  Attendre VBL.
3.  **Flip** :
    - Si Buffer = 0 : CRTC affiche #C000, GA Mode Standard (#C0). Z80 écrit en #4000 (vraie Bank 1).
    - Si Buffer = 1 : CRTC affiche #4000, GA Mode Swap (#C3). Z80 écrit en #4000 (qui est redirigé vers Bank 3 #C000).
4.  L'échange peut se faire avec un `XOR` sur les variables d'état.
