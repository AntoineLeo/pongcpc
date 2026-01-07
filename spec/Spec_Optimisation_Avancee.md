# Spec: Optimisation Avancée

## Code Généré (Speedcode)
- Remplacer les boucles et les lectures de données par une suite linéaire d'instructions immédiates.
- Ex: Au lieu de `LD A,(DE) : LD (HL),A`, écrire `LD (HL), #AA` (où #AA est la valeur de la donnée insérée lors de la génération).
- **Gain** : Plus de `INC DE`, plus de lecture mémoire source. Vitesse maximale.
- **Coût** : Taille mémoire énorme (1 octet graphique = plusieurs octets de code).

## Affichage à la Pile (Stack Blitting)
- Utiliser `PUSH` pour écrire à l'écran par paquets de 2 octets.
- Configurer SP (Stack Pointer) sur la fin de la zone écran.
- Remplir registres `HL`, `DE`, `BC` avec données.
- `PUSH HL` ; `PUSH DE` ; `PUSH BC`.
- **Vitesse** : `PUSH` est très rapide (11 cycles pour 2 octets).
- **Contrainte** : Écriture à l'envers (décrémentation). Interruption système doit être coupée (car elle utilise la pile).

## Astuces Registres
- Utiliser `INC L` au lieu de `INC HL` tant qu'on ne traverse pas une page de 256 octets (alignement des sprites).
- Utiliser des instructions `SET / RES` bit, H pour changer de ligne écran sans addition (si sprites alignés sur blocs spécifiques).
