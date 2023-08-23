/* PROCEDURE */
IF OBJECT_ID('IzlistajParametreZaTipPregleda','P') is not null
	DROP PROC IzlistajParametreZaTipPregleda
GO

CREATE PROC IzlistajParametreZaTipPregleda
	@IDTipPregleda int,
	@StartDate date,
	@EndDate date
AS
BEGIN
	DECLARE @NazivParametra as nvarchar(100)
	DECLARE @IDParametra as int
	DECLARE @VrednostParametra as float
	DECLARE @MernaJedinica nvarchar(50)
	DECLARE @ID_Pregled as int
	DECLARE @help int
	SET @help = 1

	DECLARE ParametarCursor CURSOR
	FOR SELECT ID_Pregled FROM Projekat.Zakazan_Pregled WHERE ID_TipPregleda=@IDTipPregleda
	OPEN ParametarCursor
	FETCH NEXT FROM ParametarCursor INTO @ID_Pregled



	IF @@FETCH_STATUS=-1
		BEGIN
		PRINT 'Nema Pregleda za dat Tip Pregleda'
		CLOSE ParametarCursor
		DEALLOCATE ParametarCursor
		RETURN
		END


	WHILE @@FETCH_STATUS=0
		BEGIN		
		IF((SELECT Datum FROM Projekat.Pregled WHERE ID_Pregled=@ID_Pregled) between @StartDate and @EndDate)
			BEGIN
				DECLARE ParametarCursor2 CURSOR
				FOR SELECT ID_Parametar FROM Projekat.Obuhvata WHERE ID_Pregled=@ID_Pregled
				OPEN ParametarCursor2
				FETCH NEXT FROM ParametarCursor2 into @IDParametra

				WHILE @@FETCH_STATUS=0
					BEGIN
						SET @VrednostParametra = (SELECT VrednostParametra from Projekat.Obuhvata WHERE ID_Pregled=@ID_Pregled and ID_Parametar=@IDParametra)
						SET @MernaJedinica = (SELECT MernaJedinica from Projekat.Parametar WHERE ID_Parametar=@IDParametra)
						SET @NazivParametra = (SELECT NazivParametra from Projekat.Parametar WHERE ID_Parametar=@IDParametra)

						PRINT concat('Na pregledu sa ID-em ',@ID_pregled,' je izmeren parametar ',@NazivParametra,' sa vrednosti ',@VrednostParametra,' ',@MernaJedinica)
						set @help = 0

						FETCH NEXT FROM ParametarCursor2 into @IDParametra
					END			
				CLOSE ParametarCursor2
				DEALLOCATE ParametarCursor2
			END
			
						
		FETCH NEXT FROM ParametarCursor INTO @ID_Pregled

		END

	CLOSE ParametarCursor
	DEALLOCATE ParametarCursor

	IF(@help=1)
		PRINT 'Nema parametara, ali postoji pregled sa datim tipom pregleda'

END


EXEC IzlistajParametreZaTipPregleda 9, '2023-05-02','2023-05-05' --Izlistava sve izmerene parametre za Pregled infekcija i bolesti izmedju datih datuma

EXEC IzlistajParametreZaTipPregleda 9, '2023-05-02','2023-05-18' --Izlistava sve izmerene parametre za Pregled infekcija i bolesti izmedju datih datuma

EXEC IzlistajParametreZaTipPregleda 2, '2023-05-1','2023-05-18' --Izlistava sve izmerene parametre za Tip pregleda Kontrola poseta izmedju datih datuma

EXEC IzlistajParametreZaTipPregleda 1, '2023-05-1','2023-05-18' --Izlistava sve izmerene parametre za Tip pregleda Prva poseta izmedju datih datuma, (nema podataka)
 
select * from Projekat.Tip_Pregleda





IF OBJECT_ID('LekoviZaDijagnozu','P') is not null
	DROP PROC LekoviZaDijagnozu
GO

CREATE PROC LekoviZaDijagnozu
	@ID_Dijagnoza int
AS
BEGIN
	DECLARE @ID_Lek as int
	DECLARE @NazivDijagnoze nvarchar(100)
	DECLARE @NazivLeka nvarchar(100)
	DECLARE @Doziranje nvarchar(100)
	DECLARE @ID_Pregled int

	SET @NazivDijagnoze = (SELECT LatinskiNaziv from Projekat.Dijagnoza WHERE ID_Dijagnoza=@ID_Dijagnoza)

	DECLARE LekoviCursor CURSOR
	FOR SELECT ID_Lek from Projekat.Je_Odredjena WHERE ID_Dijagnoza=@ID_Dijagnoza
	OPEN LekoviCursor
	FETCH NEXT FROM LekoviCursor into @ID_Lek

	IF(@@FETCH_STATUS=-1)
	BEGIN
		PRINT 'Nema prepisanih lekova za datu dijagnozu'
		CLOSE LekoviCursor
		DEALLOCATE LekoviCursor
		RETURN
	END

	PRINT concat('Za dijagnozu bolesti ',@NazivDijagnoze,' su prepisani sledeci lekovi:')

	WHILE(@@FETCH_STATUS=0)
	BEGIN
		SET @NazivLeka = (SELECT NazivLek from Projekat.Lek where ID_Lek=@ID_Lek)
		SET @ID_Pregled = (SELECT ID_Pregled from Projekat.Je_Odredjena where ID_Lek=@ID_Lek and ID_Dijagnoza=@ID_Dijagnoza)
		SET @Doziranje = (SELECT Doziranje from Projekat.Je_Odredjena where ID_Lek=@ID_Lek and ID_Dijagnoza=@ID_Dijagnoza and ID_Pregled=@ID_Pregled)

		PRINT concat(@Nazivleka,' je prepisan na pregledu sa ID-em ',@ID_Pregled,' i dozira se ',@Doziranje)

		FETCH NEXT FROM LekoviCursor into @ID_Lek
	END

	CLOSE LekoviCursor
	DEALLOCATE LekoviCursor
END

EXEC LekoviZaDijagnozu 2

EXEC LekoviZaDijagnozu 5

EXEC LekoviZaDijagnozu 6


EXEC LekoviZaDijagnozu 15





