# Spec: Affichage de Texte

## Code ASCII
- Instruction `DEFM "Texte"` permet de stocker des chaînes ASCII en mémoire.
- ASCII Standard : 'A' = 65 (#41).

## Algorithme d'Affichage
1.  **Lecture** : Lire octet du message (`LD A,(HL)`).
2.  **Conversion** : Soustraire code du premier caractère de la fonte (ex: `SUB 32` ou `SUB 65`).
3.  **Adresse Fonte** : Multiplier l'index par la taille en octets d'un caractère.
    - *Astuce* : Utiliser des additions (`ADD HL,HL`) est souvent plus rapide que `MUL` (qui n'existe pas nativement en Z80 simple sauf Z180/eZ80) ou des boucles.
4.  **Transfert** : Copier les données de la fonte vers l'écran (voir Spec Routine Sprite).

## Optimisation
- Pour un affichage fixe : Pré-calculer les adresses ou utiliser une "Look-up Table" (Tableau de pointeurs vers les graphismes de chaque lettre).
