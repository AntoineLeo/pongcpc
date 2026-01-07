# Optimisation de l’affichage des sprites
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Optimisation_de_l_affichage_des_sprites.php)

## Entrelacer les données
Entrelacer octets de masque et octets de sprite pour simplifier la boucle : `LD A,(DE) AND (HL) INC HL OR (HL) ...`.

## Diverses astuces
-   Utiliser `INC L` au lieu de `INC HL` si le sprite ne traverse pas une page de 256 octets (alignement).
-   Dérouler les boucles (Unrolled Loops). Supprimer les `DJNZ`.
-   Préférer `LDI` à `LDIR` pour les petites largeurs.

## Suppression du calcul de ligne inférieure
Trier les lignes du sprite en mémoire pour qu'elles suivent l'ordre des sauts de bits d'adresse écran.
Ex: L0 (#C000), L1 (#C800)...
On peut passer d'une ligne à l'autre avec `SET` et `RES` sur le registre H, ce qui est très rapide, au lieu d'ajouter #0800.

## Auto-générer l'affichage (Code Généré)
Transformer les données graphiques en code Z80.
Au lieu de lire une donnée puis de l'afficher, le code EST l'affichage.
Ex: `LD (HL), #FE` (met l'octet #FE directement).
Gain : Pas de lecture de donnée (LD A,(DE)), pas d'incrémentation de pointeur source.
Économie massive de NOPs.

## Affichage à la pile (Stack)
Utiliser `PUSH` pour écrire à l'écran.
`PUSH` écrit 2 octets en 4 NOPs (très rapide).
Nécessite de positionner SP sur l'écran (`LD SP, #C000`).
Attention : SP décrémente, donc il faut écrire de la fin vers le début (ou gérer l'inversion). Très utile pour effacer l'écran ou afficher des motifs répétitifs.
