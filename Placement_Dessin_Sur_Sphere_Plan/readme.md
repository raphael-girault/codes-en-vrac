Test pour simuler le placement d'un dessin (en png) autour d'une sphère.

La "sphère" n'est en soit qu'un cercle qui a pour but de représenter la projection orthogonale d'une sphère.

L'idée est que l'on calcule la courbure de l'enveloppe du dessin (via le rayon du cercle et les formules de trigonométries de 
base), que l'on positionne ensuite sur le dessin via la position de son centre sur la sphère (coordonnées sphériques).
Pour éviter un effet de "pointe" sur les pôles de la sphère (dû aux coordonnées sphèriques), il a été choisis de faire un calcul
de la courbure basé sur deux cylindres perpendiculaires, mais qui ne donne évidemment pas la bonne courbure pour certain angle.
