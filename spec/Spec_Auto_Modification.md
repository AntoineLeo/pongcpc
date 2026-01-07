# Spec: Auto-Modification de Code

## Concept
Le Z80 ne fait pas de différence entre DONNÉES et INSTRUCTIONS. On peut écrire par-dessus son propre code en cours d'exécution.

## Cas d'Usage
- **Compteurs Rapides** : Modifier directement la valeur immédiate d'un `LD A, n`.
    ```asm
    COMPTEUR
        LD A, 00    ; L'octet '00' est à l'adresse COMPTEUR+1
    ; ...
    ; Incrémenter le compteur :
    LD HL, COMPTEUR+1
    INC (HL)
    ```
    - *Gain* : Évite d'allouer une variable séparée + `LD A, (Var)`.
- **Modification d'Adresses** : Modifier l'opérande d'un `LD (nn), A` ou `CALL nn`.
    - Utile pour parcourir des tables sans utiliser `HL` ou `IX`.

## Précautions
- **ROM** : Impossible en ROM.
- **Lisibilité** : Rend le code difficile à déboguer.
- **Réentrance** : Le code n'est plus réentrant (ne peut pas être interrompu et rappelé).
- **Reset** : Il faut penser à réinitialiser les valeurs modifiées au début du programme si on le relance.
