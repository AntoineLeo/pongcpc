# Spec: Interruptions (IM1) & Raster Slicing

## Système d'Interruption CPC
- Le Gate Array génère une interruption 300 fois par seconde (300Hz), soit 6 fois par frame (50Hz).
- Le Z80 saute au vecteur **#0038**.

## Désactiver le Système
Par défaut, le Firmware CPC consomme du temps CPU aux interruptions #38.
Pour récupérer ce temps :
1.  `DI` (Disable Interrupts).
2.  Écrire `EI` (`#FB`) suivi de `RET` (`#C9`) à l'adresse `#0038`.
3.  `EI` (Enable Interrupts).

## Raster Slicing
Une fois le système coupé, on peut utiliser l'instruction `HALT`.
- `HALT` met le CPU en pause (NOPs basse conso) jusqu'à la prochaine interruption.
- Permet de diviser l'écran en 6 zones temporelles.
- Utile pour :
    - Changer la palette en cours de route (plus de couleurs).
    - Ruptures d'écran stables.
    - Exécuter du code (son, scroll) à fréquence élevée (300Hz).
