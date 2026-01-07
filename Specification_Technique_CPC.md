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

# Spec: Affichage de Base
## Concepts Clés
- **Écriture Directe** : L'écran est une zone de RAM (#C000-#FFFF).
- **Instruction Clé** : `LD (Adresse), A` (Charge l'accumulateur A dans l'adresse RAM).
- **Visualisation Immédiate** : Pas de "flip" ou de "refresh" à appeler manuellement pour l'affichage statique.

## Modes Graphiques (Rappel)
- **Mode 0** : 16 couleurs, 160x200 (2 pixels/octet).
- **Mode 1** : 4 couleurs, 320x200 (4 pixels/octet).
- **Mode 2** : 2 couleurs, 640x200 (8 pixels/octet). 1 bit = 1 pixel.

## Exemple d'Affichage
```asm
LD A, %11111111  ; Pixel plein (Tous les bits à 1)
LD (#C000), A    ; Allume 8 pixels (Mode 2) au premier octet écran
```

## Pièges Fréquents
- **Écrasement Code** : Ne jamais stocker de code exécutable dans la zone écran (#C000-#FFFF) sauf techniques très avancées (effacement code).
- **Conflits Registres** : `LD (HL), A` modifie la RAM pointée par HL. Assurez-vous que HL pointe bien vers l'écran.
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
# Spec: Scrolling Software

## Concept
Déplacer l'intégralité (ou une partie) de la mémoire vidéo pour simuler un mouvement.
Pour un scrolling vers la GAUCHE : Copier l'octet X vers X-1.

## Routine de Base (LDIR)
L'instruction `LDIR` est la plus simple pour cela.
```asm
LD HL, #C001  ; Source : 2ème octet de la ligne
LD DE, #C000  ; Dest : Début de la ligne
LD BC, #004F  ; Longueur : Largeur écran (80 octets) - 1
LDIR
```

## Performance & Coût CPU
- **Lourdeur** : Déplacer 16Ko (écran complet) avec LDIR prend trop de temps pour une seule frame (50Hz).
    - 16Ko = 16384 octets. 
    - LDIR = 21 cycles (5.25 µs) par octet.
    - Total : ~86ms. Une frame dure 20ms. Impossible plein écran en 1 frame.
- **Solution** : Scroller une petite fenêtre (quelques lignes, ex: bandeau de texte 8 ou 16 lignes).
- **Alternative** : Hardware Scrolling (Ruptures) pour le plein écran.

## Pièges
- **Bouclage** : Le dernier octet de la ligne doit être rafraîchi (par une nouvelle colonne de texte ou une couleur de fond), sinon il "bave" (répétition du pixel précédent).
# Spec: Synchronisation & Timing Vidéo

## Fréquence
- **Standard** : 50Hz (50 images / seconde).
- **Durée Frame** : 20ms.
- **Budget CPU** : Environ 19 968 NOPs par frame.

## Synchronisation VBL (Vertical Blanking)
Pour éviter le cisaillement (Tearing) et assurer une vitesse constante, il faut synchroniser l'affichage avec le retour du balayage vertical.

### Méthode 1 : PPI (#F5)
Le PPI (Port B, Adresse #F5xx) permet de lire l'état de la VBL via le **Bit 0**.
- **Bit 0 = 1** : VBL en cours.
- ** Routine de Synchro** :
```asm
FRAME
    LD B,#F5
WAIT_VBL
    IN A,(C)    ; Lecture PPI
    RRA         ; Rotation Bit 0 dans le Carry
    JR NC, WAIT_VBL ; Si Carry=0 (Pas de VBL), on attend
    RET
```

### Méthode 2 : Interruptions (HALT)
Utiliser l'instruction `HALT` qui attend la prochaine interruption processeur (générée par le Gate Array 6 fois par frame, dont une au début de la VBL).
Voir Spec Interruptions pour détails.

## Timing
Si votre boucle principale dure plus de 20ms, le jeu ralentira (33Hz, 25Hz...).
Pour un scroll fluide (50fps), le code doit s'exécuter "sous la frame".
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
# Spec: Affichage de Texte

## Code ASCII
- Instruction `DEFM "Texte"` permet de stocker des chaînes ASCII en mémoire.
- ASCII Standard : 'A' = 65 (#41).

## Algorithme d'Affichage
1.  **Lecture** : Lire octet du message (`LD A,(HL)`).
2.  **Conversion** : Soustraire code du premier caractère de la fonte (ex: `SUB 32` ou `SUB 65`).
3.  **Adresse Fonte** : Multiplier l'index par la taille en octets d'un caractère.
    - *Astuce* : Utiliser des additions (`ADD HL,HL`) est souvent plus rapide que `MUL` (qui n'existe pas nativement en Z80 simple sauf Z180/eZ80) ou des boucles.
4.  **Transfert** : Copier les données de la fonte vers l'écran (voir Spec Routine Sprite).

## Optimisation
- Pour un affichage fixe : Pré-calculer les adresses ou utiliser une "Look-up Table" (Tableau de pointeurs vers les graphismes de chaque lettre).
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
# Spec: Input Clavier (Hardware)

## Architecture
Le clavier CPC est lu via le **PPI 8255** et le **PSG AY-3-8912**.
- **PPI Port A (#F400)** : Connecté au port de données du PSG (Bidirectionnel).
- **PPI Port C (#F600)** : Contrôle le bus du PSG (BC1, BDIR).

## Matrice Clavier
- Le clavier est organisé en **10 lignes** (0 à 9).
- Chaque ligne retourne 8 bits (état de 8 touches). `0` = Pressé, `1` = Relâché.

## Algorithme de Lecture (Ligne par Ligne)
1.  **Sélectionner Registre 14 du PSG** (Port I/O A).
2.  **Configurer PPI Port A en Entrée** (Mode lecture).
3.  **Envoyer Index Ligne** sur le Port C (Bits 0-3).
4.  **Lire Données** depuis Port A (`IN A, (C)`).
5.  **Restaurer PPI Port A en Sortie** (Important pour le son).

## Note
- Pour tester une seule touche (ex: ESPACE), il faut connaître sa Ligne et son Bit.
- Voir documentation Matrice Clavier CPC pour le mapping Touche <-> Ligne/Bit.
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
# Spec: Mesure de Performance (Rasters)

## Principe
Utiliser le **Gate Array** pour changer la couleur de la bordure (Border) de l'écran pour visualiser le temps CPU consommé.
- Le processeur exécute le code ligne par ligne.
- L'écran est balayé de haut en bas en 20ms (50Hz).
- La position verticale du raster indique le moment où le changement de couleur a lieu.

## Routine
```asm
; Début Routine
LD BC,#7F10 : OUT (C),C ; Sélection Border
LD A, #4C   : OUT (C),A ; Couleur Rouge (ou autre)

CALL ROUTINE_A_TESTER

; Fin Routine
LD BC,#7F10 : OUT (C),C 
LD A, #54   : OUT (C),A ; Couleur Noir (Restauration)
```

## Interprétation
- **Bande Fine** : Routine rapide.
- **Bande Large** : Routine lente.
- **Bande qui sautille** : Temps d'exécution variable (boucles conditionnelles variables).
- **Bande qui "dépasse" l'écran** : La routine prend plus d'une VBL (> 20ms) -> Ralentissement du jeu (25fps).
# Spec: Masquage de Sprite (Standard)

## Principe
Afficher une forme non carrée sur un fond existant sans l'abimer ("Cookie Cutter").

## Méthode AND / OR
Nécessite deux bitmaps pour chaque frame de sprite :
1.  **Le Masque** :
    - Silhouette du sprite : Encre 0 (Bits à 0).
    - Extérieur : Encre 15 (Bits à 1).
    - Opération : `AND` avec le fond écran.
2.  **Le Sprite** :
    - Dessin : Couleurs normales.
    - Extérieur : Encre 0 (Bits à 0).
    - Opération : `OR` avec le résultat précédent.

## Routine
```asm
LD A,(DE)   ; Charger Masque
AND (HL)    ; "Trouer" le fond
LD C,A      ; Sauver fond troué
INC DE
LD A,(DE)   ; Charger Sprite
OR C        ; Fusionner
LD (HL),A   ; Afficher
```

## Optimisation
- **Entrelacement** : Stocker 1 octet Masque puis 1 octet Sprite en mémoire pour simplifier la routine (évite de gérer deux pointeurs sources).
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
# Spec: Technique 2 Bitplans (Priorité)

## Concept
Utiliser les plans de bits du Mode 0 (4 bits par pixel) pour simuler des calques de priorité (Avant/Arrière plan) via la palette de couleurs.

## Configuration des Bits
- **Bits 0-1** : Réservés au DÉCOR (4 motifs possibles).
- **Bits 2-3** : Réservés au SPRITE (3 motifs possibles + Transparent).

## Configuration Palette
Pour que le Sprite passe DEVANT le décor, il faut que ses couleurs écrasent visuellement celles du décor.
- Si Bits 2-3 (Sprite) != 0, alors la couleur est celle du Sprite, peu importe Bits 0-1.
- Cela oblige à dupliquer les encres dans la palette (Gate Array).
    - Ex: Encres 4, 5, 6, 7 (où Bits 2-3 = 01) doivent toutes être ROUGE.
    - Ex: Encres 8, 9, 10, 11 (où Bits 2-3 = 10) doivent toutes être JAUNE.

## Avantage
- Gestion de priorité "Hardware" sans masque complexe.
- L'effacement du sprite se fait en mettant les bits 2-3 à 0 (Masque `%00000011` sur l'octet), ce qui révèle instantanément le décor stocké dans les bits 0-1.
# Spec: Optimisation Avancée

## Code Généré (Speedcode)
- Remplacer les boucles et les lectures de données par une suite linéaire d'instructions immédiates.
- Ex: Au lieu de `LD A,(DE) : LD (HL),A`, écrire `LD (HL), #AA` (où #AA est la valeur de la donnée insérée lors de la génération).
- **Gain** : Plus de `INC DE`, plus de lecture mémoire source. Vitesse maximale.
- **Coût** : Taille mémoire énorme (1 octet graphique = plusieurs octets de code).

## Affichage à la Pile (Stack Blitting)
- Utiliser `PUSH` pour écrire à l'écran par paquets de 2 octets.
- Configurer SP (Stack Pointer) sur la fin de la zone écran.
- Remplir registres `HL`, `DE`, `BC` avec données.
- `PUSH HL` ; `PUSH DE` ; `PUSH BC`.
- **Vitesse** : `PUSH` est très rapide (11 cycles pour 2 octets).
- **Contrainte** : Écriture à l'envers (décrémentation). Interruption système doit être coupée (car elle utilise la pile).

## Astuces Registres
- Utiliser `INC L` au lieu de `INC HL` tant qu'on ne traverse pas une page de 256 octets (alignement des sprites).
- Utiliser des instructions `SET / RES` bit, H pour changer de ligne écran sans addition (si sprites alignés sur blocs spécifiques).
# Spec: Interruptions (IM1) & Raster Slicing

## Système d'Interruption CPC
- Le Gate Array génère une interruption 300 fois par seconde (300Hz), soit 6 fois par frame (50Hz).
- Le Z80 saute au vecteur **#0038**.

## Désactiver le Système
Par défaut, le Firmware CPC consomme du temps CPU aux interruptions #38.
Pour récupérer ce temps :
1.  `DI` (Disable Interrupts).
2.  Écrire `EI` (`#FB`) suivi de `RET` (`#C9`) à l'adresse `#0038`.
3.  `EI` (Enable Interrupts).

## Raster Slicing
Une fois le système coupé, on peut utiliser l'instruction `HALT`.
- `HALT` met le CPU en pause (NOPs basse conso) jusqu'à la prochaine interruption.
- Permet de diviser l'écran en 6 zones temporelles.
- Utile pour :
    - Changer la palette en cours de route (plus de couleurs).
    - Ruptures d'écran stables.
    - Exécuter du code (son, scroll) à fréquence élevée (300Hz).
# Spec: Double Buffering

## Objectif
Affichage sans clignotement ni tearing.
- Écran Visible : #C000.
- Écran de Travail (Caché) : #4000.

## Technique Hardware (Mode #C3)
Pour que le Z80 puisse écrire en #4000 (Bank 1 normale) et que cela atterrisse parfois dans l'écran visible (#C000 Bank 3) :
1.  Utiliser le **Gate Array Mode #C3** : Mappe la Bank 3 (Ecran) en adresse logiques #4000-#7FFF.
2.  Utiliser le **CRTC R12/R13** : Changer l'adresse de début d'affichage vidéo (#C000 ou #4000).

## Routine Loop
1.  Z80 écrit toujours en #4000.
2.  Attendre VBL.
3.  **Flip** :
    - Si Buffer = 0 : CRTC affiche #C000, GA Mode Standard (#C0). Z80 écrit en #4000 (vraie Bank 1).
    - Si Buffer = 1 : CRTC affiche #4000, GA Mode Swap (#C3). Z80 écrit en #4000 (qui est redirigé vers Bank 3 #C000).
4.  L'échange peut se faire avec un `XOR` sur les variables d'état.
# Spec: Ruptures d'Écran (CRTC)

## Principe
Diviser l'écran en plusieurs zones horizontales indépendantes (Mode, Scrolling, Palette différents).
Repose sur la manipulation dynamique des registres CRTC pendant le balayage.

## Registres Clés
- **R4 (Hauteur Caractère -1)** : Nombre de lignes d'une "Range" de caractères.
- **R12/R13 (Offset)** : Adresse mémoire vidéo.
- **R7 (VBL Pos)** : Ligne où déclencher la VBL. Se compare au compteur interne C4 (qui compte jusqu'à R4+1).

## Algorithme
1.  Attendre le bon moment (compter Interruptions/HALT ou Rasterlines).
2.  Modifier **R4** pour forcer la fin de la zone courante.
3.  Modifier **R12/R13** pour pointer vers la nouvelle mémoire vidéo.
4.  Répéter.

## Règle de Somme
La somme totale des lignes (définies par la somme des `R4+1` de chaque zone) doit être égale à la hauteur standard frame (généralement **39** lignes caractères équivalentes, pour 312 lignes raster). Si la somme est incorrecte, l'image roule (perte synchro 50Hz).
