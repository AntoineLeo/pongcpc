# Déplacement de sprite, restitution
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Deplacement_de_sprite,_restitution.php)

## Déplacement
Pour déplacer un sprite, il suffit de changer son adresse d'affichage.
Si on utilise l'auto-modification, on peut modifier l'instruction `LD HL, #C020` directement en mémoire.
Pour aller à droite : `INC HL`.
Pour aller à gauche : `DEC HL`.
Pour monter/descendre : Ajouter/Soustraire la largeur d'écran (#50 ou autre).

```asm
droite 
    LD HL,(Coordonnee_ecran+1) ;on prend l'adresse contenue en Coordonnee_ecran+1 
    INC HL ;on incrémente l'adresse 
    LD (Coordonnee_ecran+1),HL ;on automodifie l'adresse
```

## Restitution du fond
Quand un sprite bouge, il laisse une trace. Il faut effacer l'ancienne position.
Solutions:
1.  **Effacer avec une couleur unie** : Avant d'afficher à la nouvelle position, on remplit l'ancienne zone avec 0.
2.  **Sauvegarder/Restituer** :
    -   Avant d'afficher : Copier le fond (sous le sprite) dans un buffer.
    -   Afficher le sprite.
    -   Au cycle suivant, avant de bouger : Recopier le buffer à l'écran (ce qui efface le sprite en remettant le décor original).
    -   Calculer nouvelle position.
    -   Sauvegarder nouveau fond.
    -   Afficher sprite.
