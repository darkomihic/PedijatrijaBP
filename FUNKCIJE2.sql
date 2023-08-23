/*FUNKCIJE ovaj radi ali stvarno*/

CREATE FUNCTION ParametarStats(@ID_Dijagnoza int, @ID_Parametar int)
RETURNS @Results TABLE
(
	Dijagnoza nvarchar(50),
	Parametar nvarchar(50),
	MernaJedinica nvarchar(50),
	Min float,
	Avg float,
	Max float
)
AS
BEGIN
DECLARE @ID_Pregled int
DECLARE @MernaJed nvarchar(50)
DECLARE @Par nvarchar(50)
DECLARE @Dij nvarchar(50)
DECLARE @AVG float
DECLARE @MAX float
DECLARE @MIN float
DECLARE @parCounter int
SET @parCounter = 0
SET @MIN = 50
SET @MAX = 0
SET @AVG = 0
SET @MernaJed = (SELECT MernaJedinica from Projekat.Parametar WHERE ID_Parametar=@ID_Parametar)
SET @Par = (SELECT NazivParametra from Projekat.Parametar WHERE ID_Parametar=@ID_Parametar)
SET @Dij = (SELECT LatinskiNaziv from Projekat.Dijagnoza WHERE ID_Dijagnoza=@ID_Dijagnoza)
DECLARE ParametarStats CURSOR
FOR SELECT ID_Pregled from Projekat.Odredjuje WHERE ID_Dijagnoza=@ID_Dijagnoza
OPEN ParametarStats
FETCH NEXT FROM ParametarStats into @ID_Pregled

WHILE(@@FETCH_STATUS=0)
BEGIN
	DECLARE @help float
	SET @help = (SELECT VrednostParametra from Projekat.Obuhvata WHERE ID_Pregled=@ID_Pregled and ID_Parametar=@ID_Parametar)

	if(@help>@MAX)
		SET @max = @help

	if(@help<@min)
		SET @min = @help

	set @avg = @avg + @help	

	set @parCounter=@parCounter+1

	FETCH NEXT FROM ParametarStats into @ID_Pregled
END

CLOSE ParametarStats
DEALLOCATE ParametarStats

if(@avg>0)
BEGIN
	set @avg = @avg/@parCounter
	INSERT INTO @Results values (@Dij,@Par,@MernaJed,@min, @avg, @max)
END

RETURN

END
GO

DROP TABLE #TEmp
GO

CREATE TABLE #Temp (

	Dijagnoza nvarchar(50),
	Parametar nvarchar(50),
	MernaJedinica nvarchar(50),
    Min float,
	Avg float,
	Max float
);

INSERT INTO #Temp
SELECT *
FROM ParametarStats(2,4);

SELECT * FROM #TEMP
GO



DROP FUNCTION Pandemija

CREATE FUNCTION Pandemija()
RETURNS @Results TABLE
(
	Dijagnoza nvarchar(100),
	BrojZarazenih int,
	weekNumber int
)
AS
BEGIN
	DECLARE @Dijagnoza nvarchar(100)
	DECLARE @ukupanBrojZarazenih int
	DECLARE @help int
	set @help = -1;
	DECLARE @ID_Dijagnoza int
	DECLARE @helpDijagnoza int
	set @helpDijagnoza = -1
	DECLARE @brojnedelje int
	DECLARE @helpweek int
	set @helpweek = -1
	DECLARE PandemijaCursor CURSOR
	FOR SELECT o.ID_Dijagnoza, COUNT(o.ID_Dijagnoza) AS brojDijagnoza, DATEPART(WK, p.datum) as weekNumber
  FROM Projekat.Odredjuje o
  JOIN Projekat.Pregled p ON o.ID_Pregled = p.ID_Pregled
  where ID_Dijagnoza is not null
  GROUP BY o.ID_Dijagnoza, DATEPART(WK, p.datum)

	OPEN PandemijaCursor

	FETCH NEXT FROM PandemijaCursor into @ID_Dijagnoza,  @ukupanBrojZarazenih, @brojnedelje

	WHILE @@FETCH_STATUS=0 
	BEGIN
		
		DECLARE @helpBrZr int
		set @helpBrZr = (SELECT  avg(brojDijagnoza) as 'AvgZar' FROM
		(SELECT o.ID_Dijagnoza, COUNT(o.ID_Dijagnoza) AS brojDijagnoza, DATEPART(WK, p.datum) as weekNumber
		  FROM Projekat.Odredjuje o
		  JOIN Projekat.Pregled p ON o.ID_Pregled = p.ID_Pregled
		  join Projekat.Dijagnoza d on d.ID_Dijagnoza=o.ID_Dijagnoza
		  where o.ID_Dijagnoza is not null
		  GROUP BY o.ID_Dijagnoza, DATEPART(WK, p.datum)) sub
		  join Projekat.Dijagnoza d on d.ID_Dijagnoza=sub.ID_Dijagnoza
		  GROUP BY d.ID_Dijagnoza
		  HAVING d.ID_Dijagnoza=@ID_Dijagnoza)
		if(@ukupanBrojZarazenih>@helpBrZr)
		BEGIN
			DECLARE @naziv nvarchar(100)
			set @naziv = (select LatinskiNaziv from Projekat.Dijagnoza where ID_Dijagnoza=@ID_Dijagnoza)
			INSERT INTO @Results values (@naziv, @ukupanBrojZarazenih, @brojnedelje)
		END

		FETCH NEXT FROM PandemijaCursor into @ID_Dijagnoza,  @ukupanBrojZarazenih, @brojnedelje

	END

	RETURN
END

CREATE TABLE #Temp2 (

	Dijagnoza nvarchar(100),
	BrojZarazenih int,
	weekNumber int
);

INSERT INTO #Temp2
SELECT *
FROM Pandemija()

SELECT * FROM #TEMP2
GO

DROP TABLE #Temp2
GO


CREATE FUNCTION TipPregleda(@ID_Pregled int)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @NazivTP nvarchar(100)
	DECLARE @ID_TP int

	set @ID_TP = (select ID_TipPregleda from Projekat.Zakazan_Pregled where ID_Pregled=@ID_Pregled)
	set @NazivTP = (select NazivTP from Projekat.Tip_Pregleda where ID_TipPregleda=@ID_TP)

	RETURN @NazivTP

END
GO


select dbo.TipPregleda(8) as Rezultat
