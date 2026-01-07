# Scrolling soft
Source : [asmtradcpc.zilog.fr](https://asmtradcpc.zilog.fr/cours/Scrolling_soft.php)

## Scrolling soft
Vous avez réussi à afficher votre premier sprite. Félicitation !!!
Maintenant qu'on sait afficher quelque chose, nous allons voir plein de petits trucs afin de réaliser un scrolling texte tel qu'on le faisait dans les premières démos du cpc.
Avant de parler d'afficher quelque lettre que ce soit, nous allons commencer par faire un scrolling soft tout simplement. Ca ne va pas nous prendre 3 ans vu qu'une seule instruction est utile et que vous la connaissez déjà. Cette instruction c'est le LDIR !!!
Comme nous l'avons déjà vu, le LDIR permet de recopier une chaine d'octets d'un endroit de la RAM (ou de la ROM) vers la RAM. HL contient l'adresse du premier octet à copier. DE contient l'adresse de destination. BC contient la longueur.
Jusque la tout va bien. Mais regardez le schémas suivant:
On fait un LDIR avec pour valeurs:
`HL=#C001 DE=#C000 BC=#4F`
Le schéma parle de lui même, on décale ainsi tous les octets sur une largeur de ligne (#4F) vers la gauche puisque l'octet en #C001 est recopié en #C000, donc juste à sa gauche.
Ce n'est pas plus compliqué que cela.
Petit exercice: Faites-moi un scrolling des 16 premières lignes de l'écran.
Afin que cela scroll à l'infini, vous pourrez intégrer cela dans une boucle infinie avec un JP vers le tout début. Ne vous embêtez pas à utiliser une routine de calcul de ligne inférieure pour réaliser ce scroll... Donnez vous même toutes les adresses afin de gagner un peu de CPU.
Votre scrolling devrait vous amener à une réaction attendue et qui entrainera le cours suivant.
