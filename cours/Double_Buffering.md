# Double buffering
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Double_buffering.php)

## Principe
Afficher sur un écran caché pendant que le moniteur affiche l'autre, puis inverser.
Évite le scintillement et le tearing.

## Changer la bank de l'écran (CRTC)
Le CRTC permet de changer l'adresse de départ de l'écran (Offset) via R12 et R13.
On peut alterner entre `#C000` et `#4000` (si on utilise le mode #C3).

## Mode #C3 (Gate Array)
Le problème du CRTC est qu'il voit la RAM de façon linéaire.
Le Gate Array permet de remapper les banks de RAM.
Le mode `#C3` (envoyer `#C3` au port `#7F`) remplace la RAM en `#4000-#7FFF` par la bank 3 (celle de l'écran `#C000`).
**Astuce Ultime** :
1.  On écrit TOUJOURS en `#4000` avec le Z80.
2.  Si on est en mode Standard (#C0), on écrit dans la vraie Bank 1 (#4000).
3.  Si on est en mode #C3, on écrit dans la Bank 3 (l'écran #C000) mais via l'adresse #4000 !
4.  Le CRTC, lui, affiche alternativement #4000 ou #C000.

Cela permet d'avoir une seule routine d'affichage qui écrit toujours en #4000, et c'est le matériel qui dirige ça vers l'écran visible ou l'écran caché.

### Commutation Rapide
Pour passer de l'état "Ecran en 4000" à "Ecran en C000" (et inversement pour le buffer), on peut utiliser un XOR sur les valeurs envoyées au GA et au CRTC, car les bits basculent proprement.
