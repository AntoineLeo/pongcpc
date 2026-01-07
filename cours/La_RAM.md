# La RAM
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/La_RAM.php)

## La RAM
On en a parlé rapidement, les octets de notre code sont stockés en mémoire. Pour l'instant je n'ai parlé que de la RAM mais sachez que ce n'est pas l'unique possibilité. En effet, le Z80 peut aller lire dans la RAM, mais aussi dans la ROM. Mais que sont ces deux noms étranges ?
La RAM c'est un endroit ou on peut stocker dans la machine des données. La RAM on peut la lire et écrire dedans. La RAM on y mettra nos données (gfx pour le moment) et notre code.
La RAM est composée d'octets (voir le chapitre précédent).
Notre RAM centrale (centrale car c'est la principale, mais il y a aussi la RAM secondaire qui est sous forme de Banks) fait 64Ko.
Sur un 464 sans extension mémoire il n'y a que de la RAM centrale. C'est pour cela qu'il s'appelle 4-64 (4 pour lecteur K7 et 64 pour 64Ko de RAM)
1Ko c'est 1024 octets.
64Ko c'est donc 64*1024 octets...
Nous avons donc 65536 octets. En hexadécimal, on écrira #FFFF (il faut compter le 0).
Chaque octet de la RAM a une adresse. Le premier octet est l'octet numéro #0000. (je donne les adresses en hexa car c'est bien plus pratique et que je ne parlerai qu'en hexa par la suite pour les adresses) Le dernier octet est l'octet numéro #FFFF.
Voici donc la RAM (sans artifice et sans grande précision).
Pour plus d'informations sur la RAM allez faire un tour dans les documents du site ou un plan plus détaillé y est présent
On découpe la RAM traditionnellement en blocs de 16Ko (16384 octets: 16384/1024=16Ko). Ces blocs on les appellent des banks.
Au démarrage du CPC sous BASIC:
Entre #0000/#3FFF c'est quasi vide, mais il y a quand même quelques trucs au tout début. De même si vous tapez un programme BASIC il sera stocké en RAM à partir de #0170. Entre #4000 et #7FFF c'est vide normalement. Entre #8000 et #BFFF c'est quasi vide sauf vers la fin donc on évitera d'aller trop haut et on restera sous #A000. Entre #C000 et #FFFF sera visible à l'écran !!!
Eh oui l'écran se situe à cette adresse la. Faites un essai en BASIC:
L'instruction POKE du BASIC permet d'envoyer un octet à une adresse. La syntaxe de cette instruction est: POKE adresse,valeur
Essayons: POKE &C000,255
En BASIC on écrit "&" pour dire que c'est de l'hexa et "&x" pour dire que c'est du binaire...
Vous voyez en haut de l'écran tout à gauche quelques pixels qui viennent d'apparaitre.
Si vous entrez: POKE &C001,255 Vous aurez alors un autre octet à l'écran. Preuve que tout ce qui est envoyé entre #C000 et #FFFF est visible à l'écran.
A contrario: POKE &4000,255 N'affichera rien à l'écran... Normal nous ne sommes pas dedans.
Voici donc un dernier exercice histoire de rigoler un peu (chacun son humour, moi ca m'amuse de vous imaginer en train de le faire comme j'ai pu le faire il y a déjà bien longtemps avant vous :) )
Exercice donc: Essayez d'envoyer l'un en dessous de l'autre un octet de valeur 255 sur les 8 premières lignes de l'écran !!! Le premier octet sera envoyé en #C000. Il devra donc y en avoir 8 les uns en dessous des autres... Notez bien chaque adresse ou vous enverrez un octet !!!
Cela va vous servir pour le prochain cours !!!
