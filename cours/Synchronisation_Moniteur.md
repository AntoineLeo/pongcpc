# Synchronisation avec le moniteur
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Synchronisation_avec_le_moniteur.php)

## Le temps machine
Le temps machine correspond au temps pris par les instructions par le Z80.
L'instruction la plus rapide est l'instruction NOP (1µs). On donnera le temps pris par les autres instructions en donnant le nombre de NOPs qu'elles prennent.
Par exemple:
```asm
LD HL,#C001 ;3 NOPs 
LD DE,#C000 ;3 NOPs 
LD BC,#4F ;3 NOPS 
LDIR ;6*#4e + 5 = 473 NOPs
```
On voit tout de suite que le LDIR consomme beaucoup de CPU.

## 50Hz
50 Hz c'est la fréquence de l'écran d'un CPC. 50Hz cela signifie qu'il y a 50 images par secondes.
Notre limite c'est justement celle du temps pris par l'affichage d'une image.
Une ligne prend 64 NOPs. Nous avons 312 lignes par ecran. Nous avons donc 64*312 NOPs par écran, soit 19968 NOPs par écran.
Si on reprend notre routine de scroll, nous avons 16*473 NOPs pour faire les 16 lignes. Soit 7568 NOPs de pris. On peut en déduire que le temps d'un écran notre routine a le temps de s'executer: 19968/7568=2.63 fois... Hors justement si vous réfléchissez, vous vous rendrez compte que vous ne verrez pas 1 décalage mais 2.63 de votre scroll le temps que le prochain écran soit affiché par le moniteur...
Et c'est pour cela que c'est rapide !!!

## Synchronisation avec le moniteur
Notre moniteur a besoin de savoir quand un nouvel écran commence. Pour cela il repère deux signaux: la VBL et la HBL.
La VBL (Vertical Blanking) sert au moniteur pour se caler verticalement. Pour le moniteur, quand le signal VBL est détecté, il commence l'affichage de l'image.
Si nous dépassons l'écart entre 2 VBL, alors nous ne serons plus synchronisé et on se mangera le balayage (tearing / sprites coupés).

### Détecter la VBL
Le signal VBL c'est le CRTC qui l'envoie. Mais nous ne pouvons pas passer par lui pour le détecter...
Heureusement pour nous, lorsqu'une VBL est en court, 1 bit est mis à 1 dans le port B du PPI (#F5).
Seul le bit 0 nous intéresse.
Pour tester la VBL nous pouvons donc faire:
```asm
LD B,#F5 ;adresse du port B du PPI 
FRAME 
    IN A,(C) ;On récupère l'octet contenu sur le port dans A 
    RRA ;On fait une rotation afin de récupérer le bit 0 dans le flag carry 
    JR NC,FRM ;tant que le flag carry n'est pas à 1 on boucle au label frm
```
Vous n'avez plus qu'à ajouter ceci dans vote routine de scroll au début.
Votre scrolling n'aura maintenant lieu qu'une fois par image affichée. Par extension on dit souvent: "une fois par VBL".
