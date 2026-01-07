# Spec: Scrolling Texte

## Workflow "Ticker" (Bandeau Défilant)
Pour optimiser, ne pas redessiner tout le texte à chaque frame.
1.  **Synchro** : Attendre VBL.
2.  **Scroll** : Décaler la zone écran de N pixels vers la gauche (Note: sur CPC octet par octet = 2, 4 ou 8 pixels selon mode).
3.  **Nouvelle Donnée** : Dessiner *uniquement* la nouvelle colonne verticale à l'extrême droite.
4.  **Gestion État** :
    - Garder un pointeur sur le caractère courant du message.
    - Garder un compteur de colonne interne au caractère (ex: colonne 0 à 7).

## Ordre des Opérations
- Préférer **Scroll PUIS Affichage Colonne**.
- Si on Affiche puis Scroll, la nouvelle colonne sera décalée et on risque un artefact visuel.

## Structure Données
- Message : `DEFM "TEXTE", 0` (0 pour fin).
- Fonte : Stockée par colonnes (facilite l'extraction d'une colonne verticale simple).
