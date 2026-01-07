# Spec: Masquage XOR

## Principe
Utiliser la propriété réversible du `XOR` exclusif.
- `(Fond XOR Sprite) XOR Sprite = Fond`

## Avantages
- **Vitesse** : Pas de masque stocké, pas de tampon de fond.
- **Mémoire** : Moitié moins de RAM graphique (pas de masque).
- **Effacement** : Ré-afficher le sprite au même endroit l'efface.

## Inconvénients
- **Couleurs** : Les couleurs du sprite se mélangent au fond (Inversion).
    - Contrainte : Fond Noir (Encre 0) ou couleurs choisies spécifiquement pour que le résultat soit lisible.
- **Collisions** : Deux sprites qui se touchent inversent leurs couleurs mutuellement (artefact visuel).
