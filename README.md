# PedijatrijaBP
SQL skripte namenjene za kreiranje tabela jednog dela baze podataka pedijatrije.

Prva funkcija vraca tabelu koja sadrzi prosecne vrednosti odredjenog parametra za odredjenu dijagnozu.
Druga funkcija vraca tabelu koja sadrzi naziv dijagnoze, sa brojem zarazenih i brojem nedelje u kojoj se nalazi veci broj zarazenih nego prosecno za tu dijagnozu.

Prva procedura vraca sve merene parametre za odredjen tip pregleda, u slucaju da ih ima
Druga procedura vraca naziv svih lekova koji su bili prepisani za odredjenu dijagnozu

Prvi triger obezbedjuje da se ne moze prepisati pacijentu vakcina ako je bolestan
Drugi triger obezbedjuje da se ne moze prepisati lek ako nije prepisana adekvatna terapija
