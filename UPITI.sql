/*UPITI*/

SELECT zp.ID_Pregled as 'ID pregleda', LatinskiNaziv as 'Latinski naziv dijagnoze', NazivParametra as 'Naziv parametra', concat(VrednostParametra,' ',MernaJedinica) as 'Vrednost parametra'
FROM Projekat.Odredjuje o join Projekat.Dijagnoza d on o.ID_Dijagnoza=d.ID_Dijagnoza
join Projekat.Zakazan_Pregled zp on zp.ID_Pregled=o.ID_Pregled
join Projekat.Obuhvata ob on ob.ID_Pregled=o.ID_Pregled
join Projekat.Parametar par on par.ID_Parametar=ob.ID_Parametar
WHERE par.ID_Parametar=4 and ob.VrednostParametra>37.5
GO 



select zp.ID_Pregled, tp.NazivTP, IIF(NazivParametra is null, 'Nema parametra',NazivParametra) as 'Naziv parametra', IIF(NazivParametra is null, 'Nema parametra',concat(VrednostParametra, ' ', MernaJedinica)) as 'Vrednost parametra', pre.Datum as 'Datum'
from Projekat.Zakazan_Pregled zp join Projekat.Tip_Pregleda tp on zp.ID_TipPregleda=tp.ID_TipPregleda
full OUTER join Projekat.Obuhvata o on o.ID_Pregled=zp.ID_Pregled
full outer join Projekat.Parametar p on p.ID_Parametar=o.ID_Parametar
join Projekat.Pregled pre on pre.ID_Pregled=zp.ID_Pregled
where zp.ID_Pregled is not null
ORDER BY Datum
GO

select  tp.NazivTP,  count(o.ID_Parametar) as 'Broj izmerenih parametara u nedelji', DATEPART(WK, pre.datum) as 'Broj nedelje'
from Projekat.Zakazan_Pregled zp join Projekat.Tip_Pregleda tp on zp.ID_TipPregleda=tp.ID_TipPregleda
full OUTER join Projekat.Obuhvata o on o.ID_Pregled=zp.ID_Pregled
full outer join Projekat.Parametar p on p.ID_Parametar=o.ID_Parametar
join Projekat.Pregled pre on pre.ID_Pregled=zp.ID_Pregled
where zp.ID_Pregled is not null
GROUP BY  tp.NazivTP,  DATEPART(WK, pre.datum)
ORDER BY  DATEPART(WK, pre.datum)
GO

SELECT NazivParametra as 'Naziv parametra', OpisParametra as 'Opis parametra', concat(avg(VrednostParametra),' ',MernaJedinica  ) as 'Prosecna vrednost'
FROM Projekat.Parametar p
join Projekat.Obuhvata o on o.ID_Parametar=p.ID_Parametar
join Projekat.Zakazan_Pregled zp on zp.ID_Pregled=o.ID_Pregled
join Projekat.Tip_Pregleda tp on tp.ID_TipPregleda=zp.ID_TipPregleda
where tp.ID_TipPregleda=9
group by NazivParametra, OpisParametra, MernaJedinica
GO


SELECT IIF((o.ID_Dijagnoza is null),'Pacijent nema dijagnozu',LatinskiNaziv) as 'Naziv dijagnoze', count(o.ID_Pregled) as 'Broj zaraza'
FROM Projekat.Odredjuje o join Projekat.Dijagnoza d on o.ID_Dijagnoza=d.ID_Dijagnoza
join Projekat.Pregled p on p.ID_Pregled=o.ID_Pregled
GROUP BY o.ID_Dijagnoza, LatinskiNaziv
HAVING count(o.ID_Pregled) > 0
ORDER BY 'Broj zaraza' desc

SELECT  IIF(d.ID_Dijagnoza is null,'Pacijent nema dijagnozu',d.LatinskiNaziv) as 'Dijagnoza', avg(brojDijagnoza) as 'Prosecan broj zarazenih u nedelju dana' 
FROM (SELECT o.ID_Dijagnoza, COUNT(o.ID_Dijagnoza) AS brojDijagnoza, DATEPART(WK, p.datum) as weekNumber
		  FROM Projekat.Odredjuje o
		  JOIN Projekat.Pregled p ON o.ID_Pregled = p.ID_Pregled
		  join Projekat.Dijagnoza d on d.ID_Dijagnoza=o.ID_Dijagnoza
		  GROUP BY o.ID_Dijagnoza, DATEPART(WK, p.datum)) sub
join Projekat.Dijagnoza d on d.ID_Dijagnoza=sub.ID_Dijagnoza
GROUP BY d.ID_Dijagnoza,d.LatinskiNaziv
ORDER BY 'Prosecan broj zarazenih u nedelju dana'desc
