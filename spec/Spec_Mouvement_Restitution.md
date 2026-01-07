# Spec: Mouvement & Restitution

## Mouvement
Déplacer un objet revient à changer son adresse d'affichage en mémoire vidéo.
- **X+1** : `INC HL` (Déplacement de 2 à 8 pixels selon le mode).
- **Y+1** : Appel routine `CALCUL_LIGNE_INFERIEURE` (Voir Spec).

## Restitution (Effacement)
Avant d'afficher le sprite à la nouvelle position (Frame N), il faut effacer celui de la position précédente (Frame N-1).
Trois méthodes principales :
1.  **Effacement Simple** : Redessiner un rectangle noir (Encre 0) à l'ancienne position. (Uniquement si fond noir).
2.  **Sauvegarde/Restauration (Back buffer partiel)** :
    - *Avant* d'afficher le sprite : Copier la zone de l'écran (fond) vers un tampon RAM.
    - *Avant* de bouger le sprite (Frame suivante) : Recopier le tampon RAM vers l'écran (écrase le sprite avec l'ancien fond).
3.  **Redessiner Tout** : Tout effacer et tout redessiner (trop lent sur CPC sans Double Buffering).
