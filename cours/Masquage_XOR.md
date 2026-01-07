# Masquage au XOR
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Masquage_au_XOR.php)

## Le XOR
Utilisé dans les premiers jeux CPC (Sorcery, Cauldron). Rapide mais avec contraintes de couleurs.
Propriété du XOR : `(A XOR B) XOR B = A`.
Si on affiche un sprite avec XOR, les couleurs s'inversent sur le fond. Si on le réaffiche au même endroit avec XOR, il s'efface et le fond est restauré !

### Avantages
-   Pas besoin de sauvegarder le fond.
-   Pas besoin de masque.
-   Très rapide.

### Inconvénients
-   Les couleurs du sprite changent en fonction du fond (superposition).
-   Contrainte forte : Fond souvent noir (Encre 0) pour que les couleurs du sprite soient correctes (`X XOR 0 = X`).
-   Si deux sprites se chevauchent, leurs couleurs se mélangent.

### Routine Type
```asm
LD A,(DE) ; Sprite
XOR (HL)  ; XOR avec l'écran
LD (HL),A ; Affiche (et efface si répété)
```
