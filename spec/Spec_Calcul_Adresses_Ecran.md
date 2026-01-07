# Spec: Calcul Ligne Inférieure (Adresse Écran)

## Problème de l'Entrelacement
L'écran CPC n'est pas linéaire pixel par pixel.
- Ligne 0 : #C000
- Ligne 1 : #C800 ( et non #C050 ! )
- ...
- Ligne 7 : #F800
- Ligne 8 : #C050 (Retour au début de la RAM écran + largeur ligne)

## Algorithme de Calcul
Pour descendre d'une ligne pixel (Y+1) :
1.  **Ajouter #0800** à l'adresse courante (Passage Ligne N à N+1 dans un bloc caractère).
2.  **Vérifier le Débordement** : Si l'adresse dépasse la limite du bloc de 16Ko virtuel (bit overflow lors de l'addition sur le poids fort), on doit corriger.
3.  **Correction** : Ajouter `#C050` si débordement.

## Routine Standard (Optimisée Taille)
```asm
CALCUL_LIGNE_INFERIEURE
    LD A,D        ; On travaille sur le poids fort (D)
    ADD A,#08     ; On ajoute #08 (Saut de 2Ko)
    LD D,A
    RET NC        ; Si pas de débordement, c'est fini.

    ; Si débordement (On était à #F8xx -> #00xx + Carry)
    ; Il faut reculer pour retomber au début de la mémoire vidéo + 1 ligne caractère (#50)
    LD HL,#C050
    ADD HL,DE     ; Ajoute correction
    EX DE,HL      ; Remet résultat dans DE
    RET
```

## Performance
- **Coût** : Variable (rapide si pas de changement de ligne caractère, plus lent si correction).
- **Alternative** : Pré-calculer les adresses ou utiliser des tableaux de pointeurs (Lookup Tables) pour plus de vitesse (voir Spec Optimisation).
