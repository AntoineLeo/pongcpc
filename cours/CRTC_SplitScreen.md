# Splitscreen ou Rupture d'écran
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/CRTC_-_Splitscreen_(rupture_d_ecran).php)

## Principe
Changer les registres du CRTC (Offset, Mode, etc.) au milieu de l'image.
Le CRTC a un compteur de lignes interne (C4) qui boucle quand il atteint la valeur de R4 (Hauteur Caractère).
L'offset (R12/R13) n'est pris en compte QUE lorsque C4 boucle à 0.

## Méthode
Pour faire une rupture :
1.  Attendre que le faisceau soit à l'endroit voulu (Compter les VBL/HALT ou surveiller C4 ? Non, on surveille les INT ou on compte le temps).
2.  Au moment voulu, reprogrammer R4 avec une nouvelle hauteur pour forcer un bouclage anticipé ou retardé, et changer R12/R13 (Offset).
3.  Le CRTC finira sa ligne courante, verra que C4 > R4 (ou C4 boucle), et appliquera le nouvel offset pour la suite de l'image.

## Règle d'or
La somme des hauteurs définies par R4 (+1) sur tout l'écran doit rester égale à 39 (pour 312 lignes au total) afin de rester syncro à 50Hz.

## VBL (R7)
Attention, le registre R7 définit quand la VBL se déclenche (quand C4 == R7). Si on joue avec R4, on risque de déclencher des VBL multiples ou de la perdre. Il faut reprogrammer R7 dynamiquement pour qu'il ne matche C4 qu'une seule fois par image, à la fin.
