# Méthodologie : Gestion Efficace des Sprites sur Amstrad CPC

Cette synthèse combine les enseignements de deux cours fondamentaux pour établir la meilleure stratégie d'affichage pour notre Pong.

## 1. Les Bases : Comprendre l'Affichage et la Mémoire (Cours : "Afficher un caractère")

Avant d'optimiser, il est crucial de maîtriser les fondamentaux de l'accès mémoire sur CPC.

### Principes Clés
*   **Mode 2 = Mapping Direct** : En Mode 2, la correspondance est simple : **1 bit = 1 pixel**. Un octet `#FF` (allumé) affiche 8 pixels allumés, `#00` affiche 8 pixels éteints. C'est le mode le plus rapide à gérer car il ne nécessite pas de conversion complexe de couleurs.
*   **L'Instruction Reine : `LD`** :
    *   Le Z80 déteste les calculs complexes durant l'affichage.
    *   La méthode la plus rapide pour afficher un octet n'est pas une boucle, mais une instruction de transfert direct : `LD (Adresse), Valeur`.
    *   Pour un petit motif (comme un caractère 8x8 ou notre balle), il est souvent plus efficace d'écrire une suite d'instructions `LD` linéaires plutôt que de gérer une boucle.

---

## 2. La Verticalité : Calculer la Ligne Suivante (Cours : "Calculer la ligne inférieure")

Une fois qu'on sait afficher un octet, il faut afficher le suivant en dessous. C'est là que la mémoire du CPC se complique.

### Le Piège de l'Adressage
*   L'écran CPC n'est pas linéaire. L'adresse située visuellement "juste en dessous" d'un pixel n'est pas simplement `Adresse + Largeur`.
*   **La Règle des 8 blocs** : Pour descendre d'un pixel (scanline) à l'intérieur d'un bloc de caractères, il faut ajouter `#0800` à l'adresse (soit ajouter 8 au registre `H`).
    *   Ex: Ligne 0 = `#C000` -> Ligne 1 = `#C800`.
*   **Le Débordement** : Si l'addition de `#08` au poids fort provoque un débordement (Carry Flag), cela signifie qu'on a fini le bloc de 8 lignes (Scanlines) et qu'il faut sauter à la ligne de caractères suivante.
*   **La Correction** : Le cours explique qu'il faut alors effectuer une correction complexe (ajouter une valeur spécifique comme `#C050`) pour "retomber" sur la bonne adresse mémoire de la ligne suivante.
*   *Note pour Pong* : Pour notre balle (6 ou 8 pixels de haut), si elle est alignée sur une ligne de caractère, on reste dans le cas simple (`ADD #0800`). Si elle est à cheval, il faut gérer ce saut complexe... OU utiliser l'optimisation ci-dessous.

---

## 3. Déplacements de Masse (Cours : "Scrolling soft")

Ce cours introduit le concept de déplacement de blocs mémoire (comme pour un scrolling), ce qui s'applique aussi à l'effacement ou au déplacement de gros sprites (raquettes).
*   **L'outil de base** : `LDIR` (Load Increment Repeat). Il copie `BC` octets de `HL` vers `DE`.
*   **La limite** : Bien que pratique, `LDIR` coûte **21 cycles (NOPs)** par octet copié.
*   **L'Optimisation (Vue dans le cours précédent)** : Remplacer un `LDIR` de 10 octets par **10 instructions `LDI`** successives coûte moins cher (16 cycles par octet vs 21).
*   **Leçon pour Pong** : Le cours "Scrolling" préconise de "Donner soi-même toutes les adresses" (Déroulage/Unrolling) pour gagner du CPU. C'est exactement ce que nous allons faire pour nos raquettes : ne pas faire de boucle, mais écrire le code pour chaque ligne.
*   Cette méthode est exactement celle que nous allons utiliser pour "compiler" nos sprites : transformer les données graphiques en instructions immédiates (`LD HL, addr; LD (HL), val`).

### Annexe 2 : Évaluation du Temps Machine (Cours : "Notion et évaluation du temps machine")
Ce cours propose une méthode visuelle très efficace pour mesurer la performance de nos routines sans compter les cycles un par un : **Les Rasters**.
*   **Principe** : Changer la couleur du BORDER (ou du fond) juste avant d'appeler une routine, et la remettre à noir juste après.
*   **Résultat** : Une barre de couleur apparaîtra à l'écran. La hauteur de cette barre est directement proportionnelle au temps CPU consommé par la routine.
*   **Utilité pour Pong** : Si nous avons un doute sur la lourdeur de la routine d'affichage des raquettes, nous utiliserons cette technique (Border Rouge = début dessin, Border Noir = fin dessin). Si la zone rouge est trop grande, il faudra optimiser.

### Annexe 3 : La Gestion des Masques (Cours : "Masquage de sprite standard")
Ce cours donne la méthode canonique pour afficher un sprite non carré (avec transparence) par-dessus un fond complexe.
*   **Les Outils** :
    *   `AND` (Et Logique) : Préserve les bits si le masque est à 1, force à 0 sinon.
    *   `OR` (Ou Logique) : Fusionne les bits à 1.
*   **L'Algorithme** :
    1.  **Préparer le fond** : Appliquer un masque (`AND`) pour "trouer" le fond (mettre à noir la silhouette du sprite). Le masque doit avoir des `1` partout sauf à l'endroit de la silhouette (qui doit être à `0`).
    2.  **Dessiner le sprite** : Appliquer le sprite (`OR`) dans le trou. Les zones transparentes du sprite doivent être à `0`.
*   **Note pour Pong** : Notre fond est NOIR (0).
    *   Donc l'étape `AND` (faire un trou noir) est implicitement faite par le fond lui-même !
    *   Nous n'avons besoin que de l'étape `OR` (fusionner).
    *   C'est ce qui rend notre affichage actuel (`LD A, (HL); OR val; LD (HL), A`) valide et performant. Si nous avions un fond décoré, il faudrait ajouter l'étape du masque.

### Annexe 4 : La Vitesse Pure : Masquage au XOR (Cours : "Masquage au XOR")
Cette technique, utilisée dans les jeux cultes comme *Sorcery* ou *Cauldron*, est une alternative "rapide mais risquée" au masquage standard.
*   **Principe** : Utiliser l'instruction `XOR` au lieu de `OR`.
*   **Magie** : Faire `XOR` deux fois avec la même valeur **annule l'opération**.
    *   Afficher le sprite : `XOR Sprite`.
    *   Effacer le sprite : `XOR Sprite` (exactement la même routine !).
    *   Plus besoin de sauvegarder le fond ou d'avoir une routine d'effacement séparée.
*   **Gain** : Routine d'affichage et d'effacement unifiées (gain de mémoire) et très rapides.
*   **Inconvénient** : Si le sprite passe devant un autre objet, les couleurs s'inversent (effet "négatif" ou mélange bizarre).
*   **Décision Pong** :
    *   Pour la balle : Le risque de collision visuelle avec la raquette existe. Si on `XOR`, la balle changera de couleur en passant sur la raquette.
    *   Pour les raquettes : Elles ne croisent rien (sauf la balle).
    *   *Conclusion* : Bien que séduisant pour la vitesse, le rendu visuel dégradé lors des collisions (inversion de couleurs) me fait préférer la méthode `OR` (fusion propre) pour l'instant, car notre méthode "Compiled Sprite" est déjà assez rapide pour ne pas avoir besoin du gain marginal du XOR.

### Annexe 5 : Éviter le Balayage (Cours : "Éviter le balayage")
Ce cours propose une technique avancée pour dessiner *pendant* l'affichage de l'image (et pas seulement pendant la VBL) sans que ça clignote.
*   **Les Fréquences** : Le CPC génère 6 interruptions (INT) par image (300Hz).
*   **La Technique** :
    1.  Désactiver les interruptions système (`DI`), installer un handler vide (`EI:RET`) en `#38`.
    2.  Utiliser `HALT` pour attendre précisément l'une des 6 interruptions.
    3.  Placer le code de dessin dans la zone de l'écran où le balayage *n'est pas encore* (ou vient de passer).
*   **Application Pong** : C'est la technique ultime ("Beam Chasing").
    *   Si nous avons trop de choses à afficher pour tenir dans la VBL seule, nous pourrons répartir l'affichage des raquettes et du score entre les interruptions 1, 2, 3...
    *   Pour l'instant, Pong est assez simple pour tenir dans la VBL. Mais si on ajoute beaucoup d'effets plus tard, on passera en mode Interruptions.

### Annexe 6 : Le Double Buffering (Cours : "Double buffering")
C'est la technique ultime pour une fluidité sans faille, même si le dessin est lent.
*   **Principe** :
    1.  Dessiner la prochaine image sur un écran caché (Buffer) pendant que l'écran actuel est affiché.
    2.  À la VBL, basculer instantanément l'affichage (CRTC) sur l'écran caché.
*   **L'Astuce CPC (Mode #C3)** :
    *   Normalement, cela obligerait à avoir 2 routines de dessin (une pour l'adresse `#C000`, une pour `#4000`).
    *   Mais grâce au Gate Array, on peut re-mapper la mémoire (Mode `#C3`).
    *   On s'arrange pour **toujours écrire à l'adresse `#4000`**, mais en changeant la configuration RAM, le CPC écrit physiquement soit dans la Banque 1, soit dans la Banque 3.
*   **Application Pong** :
    *   C'est lourd à mettre en place (gestion mémoire, CRTC R12/R13).
    *   Pour un Pong simple, le **Beam Chasing** (Annexe 5) ou une simple **VBL Stricte** (notre méthode actuelle) suffit largement. Le Double Buffering consomme 16KB de RAM supplémentaire, ce qui est beaucoup, mais garantit zéro clignotement quoi qu'il arrive.

### Annexe 7 : Le Split Screen / Rupture (Cours : "Splitscreen")
Cette technique de "Demomaker" permet de diviser l'écran en plusieurs zones ayant chacune son propre contenu mémoire (Offset).
*   **Le Secret** : Manipuler les registres du CRTC (Contrôleur Vidéo) à la volée.
    *   **R4 (Vertical Total)** : Nombre de lignes de caractères per "frame". En le changeant en cours de route, on force le CRTC à redémarrer un cycle d'affichage (C4 restart).
    *   **R12/R13 (Offset)** : Au moment où le cycle redémarre, le CRTC lit le nouvel offset mémoire.
*   **La Recette** :
    1.  Calculer des blocs de hauteur (R4) dont la somme fait 312 lignes (Frame 50Hz).
    2.  Compter les lignes (Interrupts ou attentes calibrées).
    3.  Changer l'Offset (R12/R13) et la hauteur (R4) entre chaque bloc.
*   **Application Pong** :
    *   Idéal pour avoir une **Barre de Score Fixe** en haut (offset mémoire A) et un **Terrain de Jeu** en dessous (offset mémoire B).
    *   Cela évite de redessiner/effacer le score ou les murs s'ils sont dans une zone mémoire séparée !
    *   C'est une optimisation majeure si le jeu devient complexe (scrolling du terrain par exemple), mais pour un écran fixe noir, c'est du luxe.

---

## Conclusion Finale de la Synthèse

Nous disposons maintenant d'une connaissance encyclopédique de l'affichage CPC :
1.  **Méthode de Dessin** : Sprite Compilé (LD HL, val) + Unrolled Loops. (Validé pour la Balle).
2.  **Méthode d'Effacement** : Stack PUSH/POP ou Unrolled LD (HL), 0.
3.  **Synchronisation** :
    *   **Niveau 1** : VBL Simple (Suffisant pour Balle seule).
    *   **Niveau 2** : Beam Chasing (Interruptions) pour Balle + Raquettes.
4.  **Affichage Avancé** :
    *   **Split Screen (Rupture)** : Pour isoler le Score.
    *   **Double Buffering** : Pour une fluidité absolue (si nécessaire).
    *   **Masquage XOR** : Rejeté (qualité visuelle).

**Prochaine Étape Recommandée** :
Implémenter les **raquettes** avec la méthode **"Sprite Compilé"** (comme la balle) et vérifier si la VBL simple suffit. Si ça ralentit, on passera au Beam Chasing (Rasters pour mesurer).






---

## 4. Maitriser le Temps (Cours : "Synchronisation avec le moniteur")

Pour éviter les clignotements et "déchirements" de l'image (tearing), il faut dessiner au bon moment.
*   **Les Limites** : Une image à 50Hz dure environ 20 000 NOPs (cycles). Si votre code de dessin prend plus de temps, le framerate chute et l'affichage saccade.
*   **La VBL (Vertical Blanking Line)** : C'est le moment où le canon à électrons remonte en haut de l'écran. C'est le SEUL moment où on peut modifier la mémoire vidéo sans que cela ne se voie (pas de flickering).
*   **Détection** : On peut détecter ce moment via le PPI (Port B, Bit 0).
    *   L'instruction classique est de lire le port `#F5` (Port B PPI) et de tester le bit 0.
    *   `IN A, (C)` + `RRA` permet de mettre ce bit dans le Carry Flag pour le tester (`JR NC, Wait`).
*   **Application Pong** : Ma routine `WAIT_VBL` actuelle faisait déjà cela mais peut être améliorée. Le cours suggère une attente active simple. L'important est de placer toute la logique de dessin **immédiatement après** cette détection.

---

## 5. Techniques Avancées (Cours : "Optimisation de l'affichage des sprites")

Une fois les bases posées, pour aller vite (50 FPS constant) avec de gros objets ou beaucoup d'objets, il faut ruser pour économiser chaque cycle CPU (NOP).

### A. Les Sprites Compilés (Code Généré)
C'est l'évolution directe du principe de base vu plus haut.
*   **Principe** : Le sprite n'est plus stocké comme des données (`DB #F0...`) qu'une routine générique va lire et afficher. Le sprite **devient le code lui-même**.
*   **Pourquoi ?** : Une routine générique perd du temps à lire la donnée (`LD A,(DE)`), gérer le compteur (`DEC B`, `JR NZ`) et calculer les adresses.
*   **La Solution** : On transforme le sprite en une liste d'instructions `LD (HL), constante`.
    *   *Exemple* : Pour afficher une balle blanche, le code sera juste : `LD (HL), #FF`. C'est l'exécution la plus rapide possible sur Z80.

### B. Optimisation du Masquage
*   Si un octet du sprite est vide (0), ne faites rien ! (`INC L` suffit).
*   Si un octet est plein (255), écrasez sans scrupule (`LD (HL), 255`).
*   Ne faites les calculs coûteux (`AND mask / OR sprite`) que pour les bords réels du sprite.

### C. La Méthode "Zig-Zag"
*   Dessiner une ligne de Gauche à Droite, puis la suivante de Droite à Gauche.
*   **Gain** : Cela évite de devoir "rembobiner" le pointeur écran (soustraction coûteuse) pour revenir en début de ligne.

### D. La Pile (Stack) comme Turbo
*   Utiliser `PUSH` et `POP` permet de transférer 2 octets d'un coup. C'est l'instruction de transfert mémoire la plus rapide du Z80. Utile pour effacer ou copier de gros blocs.

---

## 3. Application Concrète au Projet Pong

Sur la base de ces deux cours, voici la stratégie validée :

1.  **Pour la Balle (Petit Sprite, Rapide)** :
    *   Application du **Principe de Base** (Cours 1) poussé à l'extrême (**Sprite Compilé** du Cours 2).
    *   Nous allons écrire une routine dédiée qui ne contient *que* des `LD (HL), val` et des ajustements d'adresse simples. Plus de boucles, plus de lectures de données. Vitesse maximale.

2.  **Pour les Raquettes (Grands Sprites Verticaux)** :
    *   Application des **Techniques Avancées**.
    *   Utilisation possible de la **Pile (Stack)** pour l'effacement rapide (vu leur hauteur).
    *   Utilisation du **Grey Code** (ordonnancement des lignes) pour le calcul d'adresse verticale rapide sur toute la hauteur de la raquette.

L'objectif "Fluidité" sera atteint en réduisant le temps CPU passé à dessiner, laissant ainsi tout le temps nécessaire à la logique de jeu dans la VBL.
