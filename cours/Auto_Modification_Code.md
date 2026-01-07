# Stockage du code en RAM et Auto-modification
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Stockage_du_code_en_RAM_et_Auto-modification.php)

## Stockage en RAM
Les instructions sont stockées les unes à la suite des autres, à partir de l'adresse de notre ORG.
Si on connait l'adresse d'une instruction en RAM on peut aussi la modifier !!!

## Auto-modification
L'auto-modification c'est justement modifier le code que l'on a en RAM. L'utilisation peut par exemple d'être de gérer un compteur.
Imaginons un compteur:
```asm
ORG #8000 
COMPTEUR LD A,#15
```
Le label "COMPTEUR" correspond à l'adresse en RAM ou est stockée l'instruction `LD A,#15`.
Si nous voulons modifier la valeur de A (qui est au 2ème octet, donc COMPTEUR+1), nous pouvons faire:
```asm
LD A,#16 
LD (Compteur+1),A
```
Exemple de compteur avec décrémentation:
```asm
COMPTEUR LD A,12 
DEC A 
LD (COMPTEUR+1),A ; On sauvegarde la nouvelle valeur DANS l'instruction LD A, n
CP 0 
JP NZ,machin 
LD A,12 ; Si 0, on remet à 12
LD (COMPTEUR+1),A
```
Note: `LD (ADR), A` prend 4 NOPs. C'est parfois plus rapide de ne pas utiliser de variable séparée mais de modifier l'instruction de chargement immédiat.
