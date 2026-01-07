# Spec: Scrolling Software

## Concept
Déplacer l'intégralité (ou une partie) de la mémoire vidéo pour simuler un mouvement.
Pour un scrolling vers la GAUCHE : Copier l'octet X vers X-1.

## Routine de Base (LDIR)
L'instruction `LDIR` est la plus simple pour cela.
```asm
LD HL, #C001  ; Source : 2ème octet de la ligne
LD DE, #C000  ; Dest : Début de la ligne
LD BC, #004F  ; Longueur : Largeur écran (80 octets) - 1
LDIR
```

## Performance & Coût CPU
- **Lourdeur** : Déplacer 16Ko (écran complet) avec LDIR prend trop de temps pour une seule frame (50Hz).
    - 16Ko = 16384 octets. 
    - LDIR = 21 cycles (5.25 µs) par octet.
    - Total : ~86ms. Une frame dure 20ms. Impossible plein écran en 1 frame.
- **Solution** : Scroller une petite fenêtre (quelques lignes, ex: bandeau de texte 8 ou 16 lignes).
- **Alternative** : Hardware Scrolling (Ruptures) pour le plein écran.

## Pièges
- **Bouclage** : Le dernier octet de la ligne doit être rafraîchi (par une nouvelle colonne de texte ou une couleur de fond), sinon il "bave" (répétition du pixel précédent).
