# Création d'une fonte pour afficher vos textes
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Creation_d_une_fonte.php)

## Création d'une fonte
Afin de réaliser notre scrolling nous aurons besoin d'une fonte où chaque lettre sera un sprite.
Pour commencer, je vous conseille de faire une fonte pas trop haute. Un scrolling soft ça consomme du cpu. Plus votre fonte sera haute; plus vous aurez de lignes à scroller. Moins vous aurez de temps machine et plus vous risquez d'avoir un scroll moche.
Donc, 8 pixels de haut c'est bien; 16 pixels c'est bien aussi, mais pas plus !!!
Le logiciel Font Catcher permet de capturer une fonte depuis une image .SCR.
[Cliquez ici pour télécharger la fonte.](https://asmtradcpc.zilog.fr/cours/FILES/fonte.dsk)
[Cliquez ici pour télécharger Font catcher](https://asmtradcpc.zilog.fr/cours/FILES/Font%20Catcher.dsk)

## Structure en RAM
Une fois la fonte chargée (ex: en #4000), elle est stockée sous forme de colonnes.
La RAM est ici présentée de haut en bas. C'est à dire que pour la colonne de gauche, les octets se suivent de haut en bas puis on passe à la deuxième colonne. Notre fonte est donc bien découpée en colonnes.
1 octet de large pour 16 lignes de haut (par exemple).
