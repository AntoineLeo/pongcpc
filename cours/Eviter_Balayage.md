# Éviter le balayage
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Eviter_le_balayage.php)

## Les interruptions (IM 1)
Le CPC génère 6 interruptions (INT) par image (300Hz).
Le Z80 saute en `#0038` à chaque INT.
Par défaut, le système y fait plein de choses. On peut détourner cela.
`DI` -> Remplacer le saut en `#38` par `EI:RET` -> `EI`.
Cela permet de garder les INT actives sans perdre de temps CPU dans le système.

## Synchronisation fine
On peut se caler sur ces 6 INTs avec `HALT`.
Au lieu d'attendre la VBL (une seule fois par image), on peut découper l'affichage en tranches.
-   Afficher le Sprite 1 entre INT 1 et INT 2.
-   Afficher le Sprite 2 entre INT 3 et INT 4.
Cela permet de répartir la charge CPU et d'éviter que le faisceau ne rattrape l'affichage (racing the beam).

## Placer judicieusement les routines
Si votre routine tient dans un "bloc" de temps (couleur de raster), placez-la juste après un `HALT`.
Attention à l'ordre : Effacer le fond PUIS afficher le sprite. Si vous êtes mal synchronisé, le sprite peut disparaitre ou scintiller.
