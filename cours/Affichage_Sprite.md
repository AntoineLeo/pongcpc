# Affichage de sprite
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Affichage_de_sprite.php)

## LA PILE !!! Ou: Comment ranger la vaisselle vous apprend à coder...
Qui n'a jamais pesté quand madame votre mère vous demandait de participer aux taches ménagères, en rangeant la vaisselle ou en mettant la table...
Ou peut être un autre specimen du genre, partageant votre couche aujourd'hui en font peut être de même...
Et bien allez les remercier !!! Ce faisant elles vous ont appris le fonctionnement d'une chose très utile: la Pile !!!
La pile c'est un moyen de sauvegarde. Tellement pratique que le système (votre BASIC adoré entre autre) lui même s'en sert, c'est peu dire !!!
Imaginez une pile d'assiettes. Prenez la première assiette. Cette assiette est la dernière a avoir été posée !!! Si vous prenez la suivante, c'est donc l'avant dernière à avoir été posée...
La pile fonctionne de cette façon: La dernière valeur sauvegardée est la première que vous récupèrerez !!!
Pour poser une assiette, il y a l'instruction PUSH. Pour la reprendre il y a l'instruction POP.
La pile fonctionne avec des registres 16 bits UNIQUEMENT (soulignez moi ca au marqueur fluo !!!) Nous pouvons donc faire des PUSH HL / PUSH DE / PUSH BC et autres (mais comme je ne vous ai pas parlé des autres registres...).
Plus un autre: AF. AF ???? "A", vous le connaissez c'est l'accu (accumulateur). Mais F c'est quoi ???
F c'est le registre des flags !!! Vous vous souvenez les petits drapeaux !!! Débordement; Zéro... C'est dans celui la que ca se passe.
Sauf que F, vous ne pouvez pas écrire dedans et vous ne pouvez pas le lire directement !!! Seules les instructions qui testent les flags peuvent s'en servir !!! Enfin presque... puisque si vous le sauvegardez avec un PUSH AF, vous pourrez donc voir le contenu de F même si cela n'a aucun interet/
Vous pouvez sauvegarder A avec la pile en faisant un PUSH AF, c'est ce qu'il faut retenir...

### Exemple Pile
```asm
LD HL,#4591 
LD DE,#5032 
LD BC,#2154 
PUSH HL 
PUSH DE 
PUSH BC
; ...
POP BC 
POP DE 
POP HL
```
Dans cet ordre là, donc dans le sens inverse qu'ils ont été sauvegardés (LIFO).

## Votre routine d'affichage de sprite
Vous savez déjà presque tout pour faire votre routine de sprite.
Reste juste une instruction qui vous servira: `DJNZ adr`
DJNZ adr c'est une instruction de saut. C'est comme un JP mais un peut spécial.
DJNZ est un saut relatif, c'est à dire qu'il saute de l'adresse ou est l'instruction. Soit en arrière, soit en avant, et, d'un certain nombre d'octets maximum (-128; +127). Avec ce type d'instruction pas question donc de sauter à l'autre bout de la RAM.
Mais DJNZ adr a un avantage non négligeable: il utilise B comme compteur !!!
Imaginons:
```asm
LD B,10 
LABEL 
NOP ;un NOP ca fait rien pendant 1 microseconde 
DJNZ LABEL
```
La première fois que le Z80 va rencontrer votre DJNZ, B sera égal à 10. Si ce n'est pas égal à 0 il va décrémenter B (-1) et sauter à LABEL. La boucle suivante, il fera la même chose (sauf que B=9) et ainsi de suite jusqu'à ce que B=0. Quand B sera égal à 0, il ira voir ce qu'il y a après le DJNZ adr.

### La marche à suivre pour réaliser votre routine:
1. Commencez par afficher 1 ligne avec LDIR (ou LDI si vous voulez, peu importe.).
2. Ajoutez ensuite le calcul de la ligne inférieure.
3. Faites une boucle pour que tout ceci se répète le nombre de ligne qu'il faut !!!
N'oubliez pas le RET en fin de routine.
Faites attentions à vos registres. DJNZ utilise B mais LDIR le modifie... LDIR incrémente certains registres, faites y attention, vous avez besoin d'un en particulier à sauvegarder avant le LDIR.
