# Spec: Input Clavier (Hardware)

## Architecture
Le clavier CPC est lu via le **PPI 8255** et le **PSG AY-3-8912**.
- **PPI Port A (#F400)** : Connecté au port de données du PSG (Bidirectionnel).
- **PPI Port C (#F600)** : Contrôle le bus du PSG (BC1, BDIR).

## Matrice Clavier
- Le clavier est organisé en **10 lignes** (0 à 9).
- Chaque ligne retourne 8 bits (état de 8 touches). `0` = Pressé, `1` = Relâché.

## Algorithme de Lecture (Ligne par Ligne)
1.  **Sélectionner Registre 14 du PSG** (Port I/O A).
2.  **Configurer PPI Port A en Entrée** (Mode lecture).
3.  **Envoyer Index Ligne** sur le Port C (Bits 0-3).
4.  **Lire Données** depuis Port A (`IN A, (C)`).
5.  **Restaurer PPI Port A en Sortie** (Important pour le son).

## Note
- Pour tester une seule touche (ex: ESPACE), il faut connaître sa Ligne et son Bit.
- Voir documentation Matrice Clavier CPC pour le mapping Touche <-> Ligne/Bit.
