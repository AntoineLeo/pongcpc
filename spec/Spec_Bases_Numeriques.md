# Spec: Bases Numériques & Données Z80

## Formats de Données
- **Décimal** : Base 10 standard (0-255).
- **Binaire** : Base 2. Préfixe `%` (Ex: `%10100111`). Correspondance directe avec les pixels (Mode 2 : 1 bit = 1 pixel).
- **Hexadécimal** : Base 16. Préfixe `#` ou `&` (Ex: `#FF`).
    - Chiffres : 0-9, A-F (où A=10 ... F=15).
    - Conversion Binaire -> Hexa : Couper l'octet en deux (4 bits + 4 bits).

## Types de Valeurs
- **Byte (8 bits / 1 octet)** :
    - Plage : 0 à 255 (#00 à #FF).
- **Word (16 bits / 2 octets)** :
    - Plage : 0 à 65535 (#0000 à #FFFF).
    - Composition : [Poids Fort (High Byte)] [Poids Faible (Low Byte)].
    - Note : Le Poids Faible est stocké en premier en mémoire (Little Endian), mais manipulé logiquement (High/Low) dans les registres 16 bits.

## Bonnes Pratiques
- Utiliser l'**Hexadécimal** pour les adresses mémoire (#C000).
- Utiliser le **Binaire** pour les masques de bits et les graphismes (compréhension visuelle des pixels).
