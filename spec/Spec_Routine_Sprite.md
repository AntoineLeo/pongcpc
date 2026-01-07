# Spec: Routine Sprite & Gestion Données

## Instructions de Transfert de Données
- **LDI** (Load Increment) : Copie (HL) vers (DE), incrémente HL et DE, décrémente BC.
    - Coût : 5 µs (ou 16 T-states).
- **LDIR** (Load Increment Repeat) : Répète LDI jusqu'à BC=0.
    - Coût : 5 µs par octet (si BC=1) / 21 T-states par itération.
    - Attention : Instruction lente pour de petits blocs répétés, bloque le CPU.

## Boucles
- **DJNZ** (Decrement Jump Non-Zero) : Décrémente B et saute si B != 0.
    - Coût : 3 µs (saut pris), 2 µs (saut non pris).
    - Usage : Boucles verticales (nombre de lignes).

## Utilisation de la Pile (Stack)
- **Principe** : LIFO (Last In First Out).
- **Registres** : 16 bits uniquement (`AF`, `BC`, `DE`, `HL`, `IX`, `IY`).
- **Sauvegarde** : `PUSH HL` (Met HL sur la pile, SP diminue de 2).
- **Restauration** : `POP HL` (Récupère la valeur dans HL, SP augmente de 2).
- **Danger** : Toujours faire autant de `POP` que de `PUSH` avant un `RET`, sinon le processeur retourne à une adresse invalide = Crash.

## Structure Type d'une Routine Sprite
1.  **Sauvegarde Contexte** : `PUSH` des registres modifiés par la routine (si nécessaire pour le programme principal).
2.  **Initialisation** : Charger adresse source (HL), destination (DE), dimensions (B/C).
3.  **Boucle Lignes** :
    - Sauvegarder Registres de Boucle (ex: `PUSH BC` pour le compteur lignes, `PUSH DE` pour le début de ligne écran).
    - **Transfert Ligne** : `LDIR` ou suite de `LDI`.
    - **Calcul Ligne Suivante** : Récupérer `DE` (`POP DE`), appeler `CALCUL_LIGNE_INFERIEURE`.
    - **Bouclage** : Récupérer compteur (`POP BC`), `DJNZ`.
4.  **Restauration Contexte** : `POP`.
