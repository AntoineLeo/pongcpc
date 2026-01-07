# Scrolling texte soft
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Scrolling_texte_soft.php)

## Principe Global
1.  **Lire le texte** : `LD A,(HL)`.
2.  **Calculer l'adresse Fonte** :
    -   `SUB 65` (Si fonte commence à 'A').
    -   Multiplier par taille lettre (ex: 64 octets).
    -   Passer en 16 bits (`LD L,A` / `LD H,0`).
    -   Multiplier par additions successives (`ADD HL,HL` x 6 pour *64).
    -   Ajouter base fonte (`LD DE,#4000` / `ADD HL,DE`).
3.  **Afficher une colonne** :
    -   Copier une colonne de la lettre vers l'extrême droite de l'écran (`LDI` ou `LD`).
4.  **Scroller** :
    -   Décaler tout l'écran vers la gauche (`LDIR`).
5.  **Boucler** :
    -   Afficher colonne suivante.
    -   Si lettre finie, passer lettre suivante.

### Routine Exemple (Logique)
```asm
Etape 1:
- Scroll
- Lecture du texte
- Calcul de la lettre dans la fonte
- Affichage d'une colonne

Etape 2 (Avec compteur de colonnes):
- Scroll
Compteur_lettre ; si lettre pas finie alors on saute au label AFFICHAGE
- Lecture du texte
- Calcul de la lettre dans la fonte
AFFICHAGE
- Affichage d'une colonne
- JP Compteur_lettre
```
Suggestion: Il vaut mieux scroller avant d'afficher afin d'éviter une double colonne à droite !!!
N'oubliez pas après avoir affiché une colonne de sauvegarder HL pour la colonne suivante !!!
