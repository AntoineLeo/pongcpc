# Spec: Gestion des Fontes

## Structure Mémoire
Les fontes bitmap sont généralement stockées caractère par caractère.
- **Caractère** : Bloc de W x H pixels.
- **Stockage Optimisé** : Colonne par colonne pour faciliter l'affichage incrémental (Surtout pour les Scrolls 1 pixel).
    - Exemple (8x8) : Colonne 1 (lignes 0-7), Colonne 2...

## Outils
- **Font Catcher** : Permet d'extraire des fontes depuis des images.

## Convention ASCII
- Stocker les caractères dans l'ordre ASCII permet de calculer l'adresse facilement.
- `Adresse = Adresse_Base + (Code_ASCII - Offset_Depart) * Taille_Caractere`.
- Exemple : Si Fonte commence à 'A' (65) et taille = 16 octets.
  Adresse 'C' (67) = Base + (67-65)*16 = Base + 32.
