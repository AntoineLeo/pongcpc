# Lecture d'un texte et affichage
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Lecture_d_un_texte_et_affichage.php)

## Lire un texte
Dans ce cour, nous allons voir comment lire un texte et ensuite trouver quelles lettres de notre fonte correspondent à celui-ci.

### Stocker un texte
Pour stocker un texte l'assembleur vous permet de dire que vous voulez stocker les valeurs ASCII.
Nous allons donc utiliser l'instruction DEFM (où DM pour certains assembleur).
La syntaxe est simplement: `DEFM "Message texte"`
Essayons:
```asm
ORG #8000 
DEFM "HELLO WORLD"
```
On le verra en RAM sous forme de valeurs hexadécimales correspondant aux codes ASCII (ex: "H" = 48 (hexa) = 72 (dec)).

## Lire le texte
Il suffira de pointer sur l'adresse du texte (avec HL par exemple) et de lire l'octet `LD A, (HL)`.
Ensuite, pour trouver l'adresse du sprite correspondant dans la fonte, il faudra soustraire l'offset (ex: 65 pour 'A' si la fonte commence à 'A') et multiplier par la taille d'une lettre (ex: 64 octets). Voir cours suivant pour le calcul détaillé.
