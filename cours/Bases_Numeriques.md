# L’octet décimal, binaire, hexadécimal
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/L_octet_decimal,_binaire,_hexadecimal.php)

## L’octet décimal, binaire, hexadécimal.
Dans l'article précédent, je vous parlais de la transformation de votre source assembleur (asm) en octet. Nous allons parler ici des différentes façon d'écrire la valeur d'un octet.
L'écriture normale d'un chiffre telle que vous l'utilisez tous les jours (1 2 3 4 5 6 7 8 9 10 11 ... 100 150 200 ...) c'est ce qu'on appelle du décimal. Si on écrit les octets sous forme de bits: %10100111 on appelle ça du binaire. Le caractère % avant signale qu'on parle en binaire.
Mais il existe une autre façon d'écrire un chiffre qu'on appelle l'hexadécimal.
L'hexadécimal c'est simple.
En décimal vous comptez de 0 à 9, puis 10,11 etc. En hexadécimal, nous comptons de 0 à 15 mais à partir de 10 on écrit avec des lettres. Cela donne: #0 #1 #2 #3 #4 #5 #6 #7 #8 #9 #A #B #C #D #E #F.
Quand on est à #F on passe à #10 puis #11; #12 ... arrivé à #19 on passe à #1A puis #1B ... Tout ca jusque #FF pour un octet. #FF=255 en décimal et c'est la valeur maximale d'un octet. Le caractère # devant une donnée signifie que c'est de l'hexadécimal.
Revenons à notre octet. L'octet a une valeur en fonction de ce qu'il y a dedans. Si vous y mettez %10010110 (en binaire donc), on peut dire que votre octet vaut en décimal: 150...
Pourquoi ? Regardez moi ce schéma:
Comme vous pouvez le voir on donne une valeur à chaque bit de notre octet. Ensuite il suffit de regarder les bits mis à 1 et d’additionner leur valeur pour obtenir la valeur décimal de notre octet.
Facile non ?

### Exercice 1
Essayez de trouver la valeur décimale des octets suivants:
Vous avez réussi ? Bravo, vous savez maintenant convertir le binaire en décimal.
Vous pouvez aussi faire le contraire. Pour cela c'est facile !!! Petit schéma:

### Exercice 2
Convertir en binaire les décimaux suivant: 255 : 128 : 29 : 175 : 0 :
Voyons maintenant comment donner le contenu de notre octet en hexadécimal histoire de finir en beauté pour ces conversions;
L'inverse marche également.
Comme on peut le voir, pour convertir du binaire en hexadécimal (on abrègera par "hexa"), il suffit de couper l'octet en deux.
Notez que si un octet a une valeur max de 255 (oubliez pas que 0 est une valeur), on peut quand même écrire des valeurs plus grandes en mettant bout à bout plusieurs octets.
On nommera "valeur 8 bits" une valeur entre 0 et 255 qui prend donc 1 octet. On nommera "valeur 16 bits" une valeur entre 0 et 65535 qui prend 2 octets. Pour une valeur supérieure à 255 considérez deux octets. Celui de gauche est ce qu'on appelle le poids fort et celui de droite le poids faible. Le poids faible c'est celui qui donne une valeur de 0 à 255. L'autre détermine un facteur de multiplication par 256.
Bon bref, je sens que cela commence à vous ennuyer... Passons à autre chose mais sachez qu'il est impératif de maitriser ces différentes méthodes d'écriture. Nous reviendrons dessus de temps en temps pour en démontrer les avantages dans certains cas précis.
