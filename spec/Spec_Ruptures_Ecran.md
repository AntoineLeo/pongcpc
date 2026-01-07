# Spec: Ruptures d'Écran (CRTC)

## Principe
Diviser l'écran en plusieurs zones horizontales indépendantes (Mode, Scrolling, Palette différents).
Repose sur la manipulation dynamique des registres CRTC pendant le balayage.

## Registres Clés
- **R4 (Hauteur Caractère -1)** : Nombre de lignes d'une "Range" de caractères.
- **R12/R13 (Offset)** : Adresse mémoire vidéo.
- **R7 (VBL Pos)** : Ligne où déclencher la VBL. Se compare au compteur interne C4 (qui compte jusqu'à R4+1).

## Algorithme
1.  Attendre le bon moment (compter Interruptions/HALT ou Rasterlines).
2.  Modifier **R4** pour forcer la fin de la zone courante.
3.  Modifier **R12/R13** pour pointer vers la nouvelle mémoire vidéo.
4.  Répéter.

## Règle de Somme
La somme totale des lignes (définies par la somme des `R4+1` de chaque zone) doit être égale à la hauteur standard frame (généralement **39** lignes caractères équivalentes, pour 312 lignes raster). Si la somme est incorrecte, l'image roule (perte synchro 50Hz).
