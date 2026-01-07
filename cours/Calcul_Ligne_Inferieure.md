# Calculer la ligne inférieure
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Calculer_la_ligne_inferieure.php)

## Calculons l'adresse inférieure
Quand vous avez cherché sous BASIC les adresses des différentes lignes vous avez trouvé les lignes suivantes:
`#C000`, `#C800`, `#D000`...
On remarque que pour passer d'une ligne à l'autre (dans le même bloc de 8), on ajoute `#0800`.

## Un débordement qu'est-ce que c'est ?
Comme nous l'avons vu, pour un registre 16 bits sa valeur maximale est #FFFF. Il ne peut donc aller plus loin que cette valeur !!! Si nous faisons ne serait-ce qu'un +1, ce registre va boucler et revenir à 0.
Heureusement, on peut détecter ce débordement.
Le Z80 possède ce qu'on appelle des FLAGS. Flag en Anglais ca veut dire drapeau.
Imaginez donc qu'à chaque fois ou quelque chose de spécial se produit, notre Z80 lève un drapeau pour nous dire: Eh les gars, il s'est passé un truc !!! Bein justement c'est ce que fait le Z80... Et il a pour cela plusieurs drapeaux.
Il en existe un pour nous dire si une valeur est à Zéro: le flag Z. Un autre pour nous dire s'il y a un débordement le flag C (C comme Carry: There is a Carry=il y a eut un report). Et quelques autres que nous verrons plus tard.
Ce qui nous intéresse dans le cas présent c'est le flag C parce que justement, nous avons un débordement et que le flag C est mis dès que cela arrive !!!

### Comment tester un Flag ?
Pour tester un flag il n'y a pas 36 solutions. Notre Z80 n'en a que quelques-unes et elles passent toutes par une instruction de saut.
Une instruction de saut comme son nom l'indique c'est une instruction qui permet de sauter à une adresse. Il en existe plusieurs type dont les JP (jump=sauter); CALL (appeler); DJNZ (on verra ca très bientôt) et JR (pareil que JP mais en relatif et on verra cela plus tard aussi...). Mais ce n'est pas tout !!!
On peut tester les flags avec une instruction que nous connaissons déjà: l'instruction RET !!! En effet nous pouvons ajouter des conditions à un RET. Et cette condition passe par le test des flags ce qui va nous arranger.
Ainsi nous pouvons dire: RET C: cela signifie que l'instruction RET sera exécutée si et seulement si le flag C est mis !!!
Nous pouvons aussi tester si le flag n'est pas mis (donc pas de débordement): RET NC (NC pour Non Carry). Et c'est justement ce qui va nous arranger :)

### Les sauts
- **JP (Jump)** : Saut définitif. `JP adresse`.
- **CALL** : Saut avec retour. `CALL adresse`. Nécessite un `RET` à la fin de la routine appelée pour revenir.

## Routine de Calcul Complète
```asm
CALCUL 
    LD A,D        ; on recopie D dans A 
    ADD A,#08     ; on ajoute #08 à A 
    LD D,A        ; on recopie A dans D 
    ; DE contient la nouvelle adresse potentielle
    RET NC        ; Si pas de débordement (NC), on a fini, on retourne.
    
    ; Si on est ici, c'est qu'il y a eu débordement (Carry = 1).
    ; Il faut donc corriger l'adresse pour passer à la ligne de caractère suivante.
    ; La correction complète est d'ajouter #C050.
    
    LD HL, #C050
    ADD HL, DE
    EX DE, HL     ; On remet le résultat dans DE
    RET
```
*Note: Le cours original explique l'addition de `#C050` (ou `#C850` moins les `#0800` déjà ajoutés).*
