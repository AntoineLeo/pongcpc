# Affichage d'un caractère à l'écran
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Affichage_d_un_caractere_a_l_ecran.php)

## Placer du code en RAM
Coder c'est bien, mais si c'est pour le faire sur papier ca va pas nous donner grand chose... Il faut bien mettre notre code quelque part afin que le Z80 l'execute. Et bien évidement on va le mettre en RAM !!!
Il faut donc choisir ou on va le mettre.
Bien évidement ca ne sera pas à l'écran (sauf si vous voulez voir plein de choses moches s'y afficher). Nous allons donc le mettre à un endroit ou il n'y a rien et ou il y a de la place. Pour commencer on va choisir de mettre notre code en #8000.
Pourquoi #8000 ? Parce que c'est comme ça, j'ai décidé que ca serait là... Plus sérieusement vu qu'on en est au début, sachez que la zone #4000/#7FFF est un peu particulière. On ne mettra donc pas notre code dedans pour le moment. De même placer notre code trop bas, c'est le risque de le voir se faire écraser par le BASIC, si par malheur on y met quelque chose. Donc #8000 c'est bien :)
Pour dire ou nous mettons notre code nous allons utiliser l'instruction ORG. ORG ca veut dire ORiGine.
En donnant ORG #8000, on va préciser à l'assembleur que notre code commence en #8000. Il sera donc stocké à partir de là. Petite précision: ORG n'est pas une instruction du Z80. C'est une instruction pour l'assembleur (le logiciel qui sert à assembler votre code). Aussi ORG n'apparait pas en RAM...

## Premier octet à l'écran
On y est, d'ici quelques minutes vous saurez faire en asm ce que vous avez fait en BASIC !!!
Je vais vous parler de l'instruction la plus importante certainement: l'instruction LD !!!
LD ca veut dire: LoaD. "Charger" en Français. Cette instruction permet donc de charger quelque chose. Il faut comprendre charger comme on pourrait dire "charger la voiture". En gros vous mettez quelque chose dedans.
En Z80, on chargera soit une adresse; soit un registre.
Une adresse vous savez déjà ce que c'est. Mais il faut savoir que lorsque vous voulez parler d'une adresse il faudra la mettre entre parenthèse.

### Exemple Pratique
On pourrait refaire par exemple la même chose que dans l'exercice suivant: envoyer un octet de valeur 255 à l'écran !!!
Commençons notre source:

```asm
ORG #8000 ;notre code sera stocké à partir de #8000 
LD A,255 ;A=255 
LD (#C000),A ;on envois à l'adresse #C000 ce que contient A 
;en gros on envois 255 en #C000 
RET
```

Tiens c'est quoi ce RET ???
RET signifie RETURN. Cela signifie que vous retournez la ou vous étiez.
Si vous étiez sous BASIC et que vous avez exécuté votre code, à la rencontre du RET vous retournerez au BASIC. En gros vous rendez la main. Il ne faudra donc pas oublier de le mettre à la fin de votre programme.
Vous avez tapé votre source et voulez maintenant l'essayer.
Il vous faut maintenant l'assembler. Sous winape vous pourrez faire soit control+F9; soit cliquer sur "assemble" puis "assemble". Retournez ensuite sur la fenêtre de l'émulateur courant (la fenêtre ou vous voyez l'écran du cpc). Il ne vous reste plus qu'à lancer votre programme en l'appelant. Et comment dit-on appeler en anglais ? CALL !!!
Entrez donc CALL puis l'adresse de votre code, soit &8000
Donc après avoir assemblé tapez sous BASIC:
CALL &8000
Miracle, votre octet est à l'écran :)

### The Ace Of Spades
Vous vous dites certainement: il est bien gentil Amaury (c'est moi) mais il s'est bien foutu de nous avec son exercice où il nous demandait de trouver l'adresse des 8 premières lignes... Ça nous a pris du temps et au final on n'a rien de nouveau...
Que néni, ça va nous servir et c'est maintenant !!!
On veut donc afficher notre joli as de pic à l'écran. Commençons déjà par le dessiner dans une grille:
C'est beau non ???
Notre but est donc d'afficher notre motif. Pour cela il va falloir transformer celui-ci en octet. Pour arranger la chose on va faire ça en Mode 2 (mode graphique. Si vous ne savez pas ce que c'est, je ne peux rien pour vous, il vous manque des bases, retournez au Basic). Donc pensez à vous mettre en mode 2 sous BASIC sinon ça sera moche...
Pourquoi en mode 2 ?
Et bien pour la simple raison qu'en mode 2, 1 bit=1 pixel.
Essayer en BASIC (encore): POKE &C000,&x10101010
Comme vous le voyez l'octet que vous avez envoyé apparait exactement tel que vous l'avez donné, a savoir 1 pixel sur 2 d'allumé. Notre mode 2 va donc nous arranger puisque pour recréer notre motif il suffira de considérer que les pixels noir sont des bits à 1 et les vides à 0:
Finalement c'était plutôt facile.
J'ai envie de vous dire: "vous savez tout, à vous de jouer !!!"... Mais je vais quand même vous montrer la démarche pour le premier octet.
Je précise tout de même qu'en asm, tout ce qui est après un ";" est considéré comme un commentaire !!! Aussi vous pouvez les laisser dans votre source. C'est même conseillé étant donné que cela vous permettra de vous y retrouver.
ex pour le premier octet donc:

```asm
ORG #8000 ;notre code sera assemblé à partir de l'adresse #8000 
LD A,%00010000 ;A contient notre premier octet 
LD (#C000),A ;on envois notre octet à l'adresse #C000 
RET
```

Normalement vous devriez comprendre tout ceci sans problème.
L'exercice consistera donc à envoyer le motif complet.
Pour le prochain cours, on passera à un dessins un peu plus grand histoire cette fois de faire une vraie routine de sprite !!!
Bonne chance à tous !!!
