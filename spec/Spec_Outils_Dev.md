# Spec: Outils de Développement & Environnement CPC

## Concepts Clés
- **Assembleur** : Langage bas niveau traduit en langage machine (Binaire) par un compilateur (Ex: Winape Assembler, MAXAM).
- **Opcode** : Instruction machine exécutable par le Z80 (Ex: `NOP` = 0).
- **Instruction ORG** : Directive assembleur définissant l'adresse de départ du code en RAM (Ex: `ORG #8000`). N'est pas une instruction Z80 et ne prend pas de place en mémoire.

## Outils Recommandés
- **Winape** : Émulateur avec assembleur intégré.
    - Accès : `F3` ou Menu `Assembleur > Show Assembler`.
    - Compilation : `CTRL+F9` ou `Assemble > Assemble`.
- **MAXAM / DAMS** : Assembleurs natifs CPC (ROM/Disc).

## Performance
- **NOP** : L'instruction de référence pour le temps machine.
    - Durée : 1 µs (microseconde).
    - Usage : Attente, synchronisation fine.

## Hardware & Registres
- **Z80** : Processeur central.
- **RAM** : Lieu de stockage du code et des données compilées.
