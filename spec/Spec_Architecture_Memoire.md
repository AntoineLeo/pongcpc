# Spec: Architecture Mémoire & RAM (CPC 6128)

## Cartographie RAM (64Ko)
- **Taille Totale** : 65536 octets (#0000 - #FFFF).
- **Division** : 4 blocs de 16Ko (Banks).

## Zones Mémoire Clés
| Plage d'Adresses | Usage Système / BASIC | Usage Recommandé (Assembleur) |
| :--- | :--- | :--- |
| **#0000 - #0170** | Vecteurs système, variables | À éviter (sauf techniques avancées). |
| **#0170 - #3FFF** | Zone BASIC, variables | Utilisable si BASIC écrasé/inutilisé. |
| **#4000 - #7FFF** | Mémoire "libre" (souvent Bank 1) | **Code & Données**. Zone idéale pour stocker le programme. |
| **#8000 - #BFFF** | Mémoire "libre" | **Code Principale**. Adresse `ORG #8000` très courante. |
| **#C000 - #FFFF** | **MÉMOIRE VIDÉO (ÉCRAN)** | Affichage graphique. Ne pas stocker de code ici (sera visible/corrompu). |

## Mémoire Vidéo
- **Adresse de base** : #C000 (Standard CPC).
- **Taille** : 16Ko (#C000 - #FFFF).
- **Organisation** : Linéaire (octets se suivent) mais entrelacée physiquement à l'écran (Ligne 0, Ligne 8...).
- **Ecriture** : Tout octet écrit dans cette zone est immédiatement affiché par le CRTC à l'image suivante.

## Interaction Système
- **POKE** (Basic) : Ecriture directe en RAM (`POKE &C000, 255`). Utile pour les tests rapides.
