/*TRIGERI*/
IF OBJECT_ID('VakcinaTriger','TR') is not null
	DROP TRIGGER VakcinaTriger
GO

CREATE TRIGGER VakcinaTriger
ON Projekat.Biva_Odredjena
INSTEAD OF Insert
AS
BEGIN
	
	
	if(2 in (select Id_Usluga from inserted) and (select ID_Dijagnoza from inserted) is not null)
	BEGIN
		PRINT 'Ne moze se dati vakcina pacijentu koji je bolestan'
		RETURN
	END
	else
	BEGIN
		DECLARE @preg int
		DECLARE @dij int
		DECLARE @usl int
			
		set @preg = (select ID_Pregled from inserted)
		set @dij = (select ID_Dijagnoza from inserted)
		set @usl = (select Id_Usluga from inserted)
		INSERT INTO Projekat.Biva_Odredjena values (@preg,@dij,@usl)
		
	END


END

INSERT INTO Projekat.Biva_Odredjena values (2,null,2)

GO

CREATE TRIGGER ProveraFarmakoterapije
ON Projekat.Je_Odredjena
AFTER Insert
AS
BEGIN
	DECLARE @ID_Pregled int
	DECLARE @ID_Dijagnoza int
	set @ID_Pregled = (select ID_Pregled from inserted)
	set @ID_Dijagnoza = (select ID_Dijagnoza from inserted)

	IF((select ID_Terapija from inserted)!=3  and (select ID_Lek from inserted) is not null)
	BEGIN
		PRINT 'Ne moze lek biti prepisan, a da terapija nije Farmakoterapija'

		DELETE FROM Projekat.Je_Odredjena where ID_Pregled=@ID_Pregled and ID_Dijagnoza=@ID_Dijagnoza
	END
	else if((select ID_Terapija from inserted)=3  and (select ID_Lek from inserted) is null)
	BEGIN
		PRINT 'Ne moze biti odredjena Farmakoterapija bez leka'

		DELETE FROM Projekat.Je_Odredjena where ID_Pregled=@ID_Pregled and ID_Dijagnoza=@ID_Dijagnoza		
	END

END

insert into Projekat.Je_Odredjena values (2,8,2,5,'1x1')

select * from Projekat.Tip_Pregleda
select * from Projekat.Parametar
select * from Projekat.Terapija
select * from Projekat.Je_Odredjena