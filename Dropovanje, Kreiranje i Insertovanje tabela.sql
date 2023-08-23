IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Projekat')
BEGIN
EXEC('CREATE SCHEMA Projekat')
END



/*Brisanje tabela*/
IF OBJECT_ID('Projekat.Biva_Odredjena', 'U') IS NOT NULL 
	DROP TABLE Projekat.Biva_Odredjena;

IF OBJECT_ID('Projekat.Obuhvata', 'U') IS NOT NULL 
	DROP TABLE Projekat.Obuhvata;

IF OBJECT_ID('Projekat.Je_Obavezni', 'U') IS NOT NULL 
	DROP TABLE Projekat.Je_Obavezni;

IF OBJECT_ID('Projekat.Je_Dodatni', 'U') IS NOT NULL 
	DROP TABLE Projekat.Je_Dodatni;

IF OBJECT_ID('Projekat.Odredjuje', 'U') IS NOT NULL 
	DROP TABLE Projekat.Odredjuje;

IF OBJECT_ID('Projekat.Prepisuje', 'U') IS NOT NULL 
	DROP TABLE Projekat.Prepisuje;

IF OBJECT_ID('Projekat.Zakazan_Pregled', 'U') IS NOT NULL 
	DROP TABLE Projekat.Zakazan_Pregled;

IF OBJECT_ID('Projekat.Je_Odredjena', 'U') IS NOT NULL 
	DROP TABLE Projekat.Je_Odredjena;

IF OBJECT_ID('Projekat.Hitan_Pregled', 'U') IS NOT NULL 
	DROP TABLE Projekat.Hitan_Pregled;

IF OBJECT_ID('Projekat.Terapija', 'U') IS NOT NULL 
	DROP TABLE Projekat.Terapija;

IF OBJECT_ID('Projekat.Parametar', 'U') IS NOT NULL 
	DROP TABLE Projekat.Parametar;

IF OBJECT_ID('Projekat.Tip_Pregleda', 'U') IS NOT NULL 
	DROP TABLE Projekat.Tip_Pregleda;

IF OBJECT_ID('Projekat.Lek', 'U') IS NOT NULL 
	DROP TABLE Projekat.Lek;

IF OBJECT_ID('Projekat.Pregled', 'U') IS NOT NULL 
	DROP TABLE Projekat.Pregled;

IF OBJECT_ID('Projekat.Dijagnoza', 'U') IS NOT NULL 
	DROP TABLE Projekat.Dijagnoza;

IF OBJECT_ID('Projekat.Usluga', 'U') IS NOT NULL 
	DROP TABLE Projekat.Usluga;



/*Kreiranje tabela*/

IF OBJECT_ID('Projekat.Usluga', 'U') IS NULL 
	CREATE TABLE Projekat.Usluga
(
	ID_Usluga int not null identity,
	NazivUsluge NVARCHAR(30) not null,
	VrstaUsluga NVARCHAR(30) not null,
	DuzinaTrajanjaUsluge NVARCHAR(10) not null,
	NapomenaUsluga NVARCHAR(100)
	CONSTRAINT PK_Usluga PRIMARY KEY (ID_Usluga)

);


IF OBJECT_ID('Projekat.Pregled', 'U') IS NULL 
	CREATE TABLE Projekat.Pregled
( 
	ID_Pregled int NOT NULL identity,
	Trajanje NVARCHAR(20),
	Datum DATE,
	BrojSobe INT NOT NULL,
	Simptomi NVARCHAR(500) NOT NULL
	CONSTRAINT PK_Pregled PRIMARY KEY (ID_Pregled)
);


IF OBJECT_ID('Projekat.Dijagnoza', 'U') IS NULL 
	CREATE TABLE Projekat.Dijagnoza
(
	ID_Dijagnoza INT not null identity,
	LatinskiNaziv NVARCHAR(30) not null,
	GrupaBolesti NVARCHAR(30) not null,
	OpisDijagnoze NVARCHAR(100)
	CONSTRAINT PK_Dijagnoza PRIMARY KEY (ID_Dijagnoza)
);

IF OBJECT_ID('Projekat.Terapija', 'U') IS NULL 
	CREATE TABLE Projekat.Terapija
(
	ID_Terapija int not null identity,
	VrstaTerapije NVARCHAR(50) not null,
	NazivTerapije NVARCHAR(50) not null,
	NapomenaTerapija NVARCHAR(300),
	DuzinaTrajanja NVARCHAR(50) not null
	CONSTRAINT PK_Terapija PRIMARY KEY (ID_Terapija)
);


IF OBJECT_ID('Projekat.Lek', 'U') IS NULL 
	CREATE TABLE Projekat.Lek
(
	ID_Lek int not null identity,
	NazivLek NVARCHAR(50) not null,
	HemijskiNaziv NVARCHAR(100) not null,
	ProizvodjaciLeka NVARCHAR(50) not null,
	GrupaLekova NVARCHAR(50),
	NacinKonzumacije NVARCHAR(50) not null,
	RezimIzdavanja NVARCHAR(100) not null
	CONSTRAINT PK_Lek PRIMARY KEY (ID_Lek)
);


IF OBJECT_ID('Projekat.Tip_Pregleda', 'U') IS NULL 
	CREATE TABLE Projekat.Tip_Pregleda
(
	ID_TipPregleda int not null identity,
	NazivTP nvarchar(50) not null
	CONSTRAINT PK_Tip_Pregleda PRIMARY KEY (ID_TipPregleda)
);


IF OBJECT_ID('Projekat.Parametar', 'U') IS NULL 
	CREATE TABLE Projekat.Parametar
(
	ID_Parametar int not null identity,
	NazivParametra nvarchar(80) not null,
	OpisParametra NVARCHAR(300),
	MernaJedinica NVARCHAR(50) not null
	CONSTRAINT PK_Parametar PRIMARY KEY (ID_Parametar)
);

IF OBJECT_ID('Projekat.Obuhvata', 'U') IS NULL 
	CREATE TABLE Projekat.Obuhvata
(
	ID_Pregled int not null,
	ID_Parametar int,
	VrednostParametra float
	CONSTRAINT FK_Obuhvata_Tip_Pregleda FOREIGN KEY (ID_Pregled)
	REFERENCES Projekat.Pregled,
	CONSTRAINT FK_Obuhvata_Parametar FOREIGN KEY (ID_Parametar)
	REFERENCES Projekat.Parametar
)
;


IF OBJECT_ID('Projekat.Je_Obavezni', 'U') IS NULL 
	create table Projekat.Je_Obavezni
(
	ID_Parametar int not null,
	ID_TipPregleda int not null,
	ID_Pregled int not null
	CONSTRAINT FK_Je_Obavezni_Parametar FOREIGN KEY (ID_Parametar)
	REFERENCES Projekat.Parametar,
	CONSTRAINT FK_Je_Obavezni_Tip_Pregleda FOREIGN KEY (ID_TipPregleda)
	REFERENCES Projekat.Tip_Pregleda,
	CONSTRAINT FK_Je_Obavezni_Zakazan_Pregled FOREIGN KEY (ID_Pregled)
	REFERENCES Projekat.Pregled
)
;

IF OBJECT_ID('Projekat.Je_Dodatni', 'U') IS NULL 
	create table Projekat.Je_Dodatni
(
	ID_Parametar int not null,
	ID_Pregled int not null
	CONSTRAINT FK_Je_Dodatni_Parametar FOREIGN KEY (ID_Parametar)
	REFERENCES Projekat.Parametar,
	CONSTRAINT FK_Je_Dodatni_Zakazan_Pregled FOREIGN KEY (ID_Pregled)
	REFERENCES Projekat.Pregled
);

IF OBJECT_ID('Projekat.Odredjuje', 'U') IS NULL 
	CREATE TABLE Projekat.Odredjuje
(
	ID_Pregled int not null,
	ID_Dijagnoza int
	CONSTRAINT FK_Odredjuje_Pregled FOREIGN KEY (ID_Pregled)
	REFERENCES Projekat.Pregled(ID_Pregled),
	CONSTRAINT FK_Odredjuje_Dijagnoza FOREIGN KEY (ID_Dijagnoza)
	REFERENCES Projekat.Dijagnoza(ID_Dijagnoza)
);

IF OBJECT_ID('Projekat.Biva_Odredjena', 'U') IS NULL 
	CREATE TABLE Projekat.Biva_Odredjena
(
	ID_Pregled int not null,
	ID_Dijagnoza int,
	Id_Usluga int,
	CONSTRAINT FK_Biva_Odredjena_Pregled FOREIGN KEY (ID_Pregled)
	REFERENCES Projekat.Pregled,
	CONSTRAINT FK_Biva_Odredjena_Dijagnoza FOREIGN KEY (ID_Dijagnoza)
	REFERENCES Projekat.Dijagnoza,
	CONSTRAINT FK_Biva_Odredjena_Usluga FOREIGN KEY (ID_Usluga)
	REFERENCES Projekat.Usluga

);


IF OBJECT_ID('Projekat.Prepisuje', 'U') IS NULL 
	CREATE TABLE Projekat.Prepisuje
(
	Doziranje NVARCHAR(10) not null,
	ID_Terapija int not null,
	ID_Lek int not null
	CONSTRAINT FK_Prepisuje_Terapija FOREIGN KEY (ID_Terapija)
	REFERENCES Projekat.Terapija,
	CONSTRAINT FK_Prepisuje_Lek FOREIGN KEY (ID_Lek)
	REFERENCES Projekat.Lek
)
;


IF OBJECT_ID('Projekat.Je_Odredjena', 'U') IS NULL 
	create table Projekat.Je_Odredjena
(
	ID_Terapija int not null,
	ID_Dijagnoza int not null,
	ID_Pregled int not null,
	ID_Lek int,
	Doziranje nvarchar(100)
	CONSTRAINT FK_Je_Odredjena_Pregled FOREIGN KEY (ID_Pregled)
	REFERENCES Projekat.Pregled,
	CONSTRAINT FK_Je_Odredjena_Dijagnoza FOREIGN KEY (ID_Dijagnoza)
	REFERENCES Projekat.Dijagnoza,
	CONSTRAINT FK_Je_Odredjena_Terapija FOREIGN KEY (ID_Terapija)
	REFERENCES Projekat.Terapija,
	CONSTRAINT FK_Je_Odredjena_Lek FOREIGN KEY (ID_Lek)
	REFERENCES Projekat.Lek

);



IF OBJECT_ID('Projekat.Hitan_Pregled', 'U') IS NULL 
	CREATE TABLE Projekat.Hitan_Pregled
(
	ID_Pregled int not null,
	RazlogHP NVARCHAR(300) not null
	CONSTRAINT FK_Hitan_Pregled_Pregled FOREIGN KEY (ID_Pregled)
	REFERENCES Projekat.Pregled

);


IF OBJECT_ID('Projekat.Zakazan_Pregled', 'U') IS NULL 
	CREATE TABLE Projekat.Zakazan_Pregled
(
	ID_Pregled int not null,
	ID_TipPregleda int not null
	CONSTRAINT FK_Zakazan_Pregled_Pregled FOREIGN KEY (ID_Pregled)
	REFERENCES Projekat.Pregled,
	CONSTRAINT FK_Zakazan_Pregled_Tip_Pregleda FOREIGN KEY (ID_TipPregleda)
	REFERENCES Projekat.Tip_Pregleda
);



/*Brisanje svih podataka iz tabela*/
DELETE FROM Projekat.Biva_Odredjena;
DELETE FROM Projekat.Prepisuje;
DELETE FROM Projekat.Je_Odredjena;
DELETE FROM Projekat.Odredjuje;
DELETE FROM Projekat.Hitan_Pregled;
DELETE FROM Projekat.Zakazan_Pregled;
DELETE FROM Projekat.Je_Obavezni;
DELETE FROM Projekat.Je_Dodatni;
DELETE FROM Projekat.Obuhvata;
DELETE FROM Projekat.Lek;
DELETE FROM Projekat.Terapija;
DELETE FROM Projekat.Pregled;
DELETE FROM Projekat.Parametar;
DELETE from Projekat.Usluga;
DELETE FROM Projekat.Tip_Pregleda;
DELETE FROM Projekat.Dijagnoza;

/*Insert za Lek*/
INSERT INTO Projekat.Lek values ('Panklav','Amoksicilin','Hemofarm','Film tableta','Oralno','Samo uz recept');
INSERT INTO Projekat.Lek values ('Hemomycin','Azitromicin','Hemofarm','Prasak za oralnu suspenziju','Oralno','Samo uz recept');
INSERT INTO Projekat.Lek values ('Brufen','Ibuprofen','ABBVIE','Sirup','Oralno','Samo uz recept');
INSERT INTO Projekat.Lek values ('Canesten','Klotrimazol','Bayer','Krem','Dermalno','Bez recepta');
INSERT INTO Projekat.Lek values ('Durogesic','Fentanil','JANSSEN PHARMACEUTICA','Flaster','Transdermalno','Samo uz recept');
INSERT INTO Projekat.Lek values ('Berodual','Ipratropijum-bromid','Boehringer Ingelheim Pharma','Rastvor za inhalaciju pod pritiskom','Inhalaciono','Samo uz recept');
INSERT INTO Projekat.Lek values ('Vimizim','Elosulfaza alfa','Biomarin International Limited','Koncentrat za rastvoj za infuziju','Intravenozno','Samo u zdravstvenoj ustanovi');
/*Insert za Pregled*/
INSERT INTO Projekat.Pregled values ('15 minuta','2023-05-02', '102', 'Pacijent ima telesnu temperaturu 38.2 i suv kasalj');
INSERT INTO Projekat.Pregled values ('10 minuta','2023-05-02', '101', 'Pacijent ima ucestalu glavobolju i vrtoglavicu');
INSERT INTO Projekat.Pregled values ('20 minuta','2023-05-02', '102', 'Pacijent ima osip na desnom stopalu');
INSERT INTO Projekat.Pregled values ('30 minuta','2023-05-03', '110', 'Pacijent ima prelom pete metatarzalne kosti');
INSERT INTO Projekat.Pregled values ('5 minuta','2023-05-03', '101', 'Pacijent nema nikakve simptome');
INSERT INTO Projekat.Pregled values ('30 minuta','2023-05-03', '105', 'Pacijent ima ucestale kosmare i pati od insomnije');
INSERT INTO Projekat.Pregled values ('15 minuta','2023-05-03', '101', 'Pacijent ima alergijsku reakciju koja mu izaziva otezano disanje');
INSERT INTO Projekat.Pregled VALUES ('15 minuta','2023-05-04', '103', 'Kašalj, povišena temperatura, umor.'),
       ('5 minuta','2023-05-04', '205', 'Nema simptoma.'),
       ('30 minuta','2023-05-04', '120', 'Osip po koži, svrab, blaga temperatura.'),
       ('10 minuta','2023-05-04', '105', 'Bol u uhu, gubitak sluha.'),
       ('20 minuta','2023-05-04', '103', 'Gubitak daha, kašalj.'),
       ('25 minuta','2023-05-05', '205', 'Bol u zglobovima, groznica.'),
       ('45 minuta','2023-05-05', '120', 'Povišen šećer u krvi, umor, žeđ.'),
       ('15 minuta','2023-05-05', '105', 'Osip, blaga groznica.');
INSERT INTO Projekat.Pregled values ('20 minuta','2023-05-05', '103', 'Pacijent je dosao na sistematski i nema nikakve simptome');
INSERT INTO Projekat.Pregled values ('15 minuta','2023-05-05', '102', 'Pacijent je dosao na sistematski i nema nikakve simptome');
INSERT INTO Projekat.Pregled values ('25 minuta','2023-05-06', '101', 'Pacijent je dosao na sistematski i pokazuje simptome skifoze');
INSERT INTO Projekat.Pregled values ('20 minuta','2023-05-07', '101', 'Pacijent je dosao na sistematski i nema nikakve simptome');
INSERT INTO Projekat.Pregled
VALUES 
('15 minuta', '2023-05-08', '103', 'Kašalj, povišena temperatura, umor'),
('20 minuta', '2023-05-09', '104', 'Bol u mišićima, curenje nosa'),
('10 minuta', '2023-05-10', '105', 'Kašalj, otežano disanje'),
('25 minuta', '2023-05-11', '106', 'Povišena temperatura, glavobolja'),
('12 minuta', '2023-05-12', '107', 'Bol u grlu, umor');

INSERT INTO Projekat.Pregled
VALUES 
('18 minuta', '2023-05-14', '108', 'Bol u grudima, kašalj'),
('22 minuta', '2023-05-15', '109', 'Povišena temperatura, malaksalost'),
('14 minuta', '2023-05-16', '110', 'Curenje nosa, glavobolja'),
('30 minuta', '2023-05-17', '111', 'Umor, kašalj, povišena temperatura'),
('30 minuta', '2023-05-17', '112', 'Umor, kašalj, povišena temperatura'),
('30 minuta', '2023-05-17', '113', 'Umor, kašalj, povišena temperatura'),
('30 minuta', '2023-05-17', '114', 'Umor, kašalj, povišena temperatura'),
('8 minuta', '2023-05-18', '112', 'Bol u mišićima, otežano disanje'),
('18 minuta', '2023-05-14', '108', 'Bol u grudima, kašalj'),
('18 minuta', '2023-05-14', '108', 'Bol u grudima, kašalj'),
('18 minuta', '2023-05-14', '108', 'Bol u grudima, kašalj'),
('18 minuta', '2023-05-14', '108', 'Bol u grudima, kašalj'),
('18 minuta', '2023-05-14', '108', 'Bol u grudima, kašalj'),
('18 minuta', '2023-05-14', '108', 'Bol u grudima, kašalj');





/*Insert za parametar*/

INSERT INTO Projekat.Parametar values('Telesna masa','Telesna masa pacijenta na dan pregleda','Kg');
INSERT INTO Projekat.Parametar values('Obim glave','Obim glave pacijenta na dan pregleda','Cm');
INSERT INTO Projekat.Parametar values('Otkucaji srca','Broj otkucaja srca pacijenta u trenutku merenja','Otkucaj srca po minutu');
INSERT INTO Projekat.Parametar values('Telesna temperatura','Telesna temperatura pacijenta na dan pregleda','Celzius');
INSERT INTO Projekat.Parametar values('Broj belih krvnih zrnca','Rezultat iz analize krvi','Broj krvnih zrnca po ml krvi');
INSERT INTO Projekat.Parametar values('Dioptrija levog oka','Dioptrija levog oka sa najskorijeg pregleda','Dsph');

/*Insert za Uslugu*/
INSERT INTO Projekat.Usluga (NazivUsluge, VrstaUsluga, DuzinaTrajanjaUsluge, NapomenaUsluga) VALUES ('Masaža', 'Fizioterapijska usluga', '60 minuta', 'Masaža pomaže u opuštanju mišića i smanjenju stresa.');
INSERT INTO Projekat.Usluga (NazivUsluge, VrstaUsluga, DuzinaTrajanjaUsluge, NapomenaUsluga) VALUES ('Davanje vakcine', 'Imunološka usluga', '15 minuta', 'Vakcine se daju kako bi se sprečilo dobijanje raznih bolesti.');
INSERT INTO Projekat.Usluga (NazivUsluge, VrstaUsluga, DuzinaTrajanjaUsluge, NapomenaUsluga) VALUES ('Merenje temperature', 'Dijagnostička usluga', '5 minuta', 'Merenje temperature je važno u dijagnostici i praćenju bolesti.');
INSERT INTO Projekat.Usluga (NazivUsluge, VrstaUsluga, DuzinaTrajanjaUsluge, NapomenaUsluga) VALUES ('EKG', 'Dijagnostička usluga', '10 minuta', 'Elektrokardiogram se koristi za merenje srčanih funkcija.');
INSERT INTO Projekat.Usluga (NazivUsluge, VrstaUsluga, DuzinaTrajanjaUsluge, NapomenaUsluga) VALUES ('Ultrazvuk', 'Dijagnostička usluga', '30 minuta', 'Ultrazvučni pregled se koristi za pregled unutrašnjih organa.');
INSERT INTO Projekat.Usluga (NazivUsluge, VrstaUsluga, DuzinaTrajanjaUsluge, NapomenaUsluga) VALUES ('Fizikalna terapija', 'Fizioterapijska usluga', '45 minuta', 'Fizikalna terapija se koristi za oporavak nakon povreda i operacija.');
INSERT INTO Projekat.Usluga (NazivUsluge, VrstaUsluga, DuzinaTrajanjaUsluge, NapomenaUsluga) VALUES ('Kontrolni pregled', 'Dijagnostička usluga', '20 minuta', 'Kontrolni pregledi se rade kako bi se pratilo stanje bolesti i određivalo dalje lečenje.');
INSERT INTO Projekat.Usluga (NazivUsluge, VrstaUsluga, DuzinaTrajanjaUsluge, NapomenaUsluga) VALUES ('Terapija kiseonikom', 'Fizioterapijska usluga', '60 minuta', 'Terapija kiseonikom se koristi za povećanje nivoa kiseonika u organizmu.');

/*Insert za Terapiju*/


INSERT INTO Projekat.Terapija (VrstaTerapije, NazivTerapije, NapomenaTerapija, DuzinaTrajanja) VALUES ('Fizikalna terapija', 'Terapija magnetima', 'Terapija magnetima se koristi za smanjenje bolova u mišićima i zglobovima.', '30 minuta');
INSERT INTO Projekat.Terapija (VrstaTerapije, NazivTerapije, NapomenaTerapija, DuzinaTrajanja) VALUES ('Fizikalna terapija', 'Krioterapija', 'Krioterapija se koristi za smanjenje otoka i upale, i poboljšanje cirkulacije krvi.', '20 minuta');
INSERT INTO Projekat.Terapija (VrstaTerapije, NazivTerapije, NapomenaTerapija, DuzinaTrajanja) VALUES ('Farmakoterapija', 'Antibiotici', 'Antibiotici se koriste za lečenje bakterijskih infekcija.', '7-14 dana');
INSERT INTO Projekat.Terapija (VrstaTerapije, NazivTerapije, NapomenaTerapija, DuzinaTrajanja) VALUES ('Fizikalna terapija', 'Terapija udarnim talasima', 'Terapija udarnim talasima se koristi za smanjenje bola u mišićima i zglobovima, i poboljšanje cirkulacije krvi.', '45 minuta');
INSERT INTO Projekat.Terapija (VrstaTerapije, NazivTerapije, NapomenaTerapija, DuzinaTrajanja) VALUES ('Farmakoterapija', 'Analgetici', 'Analgetici se koriste za ublažavanje bola.', 'Po potrebi');
INSERT INTO Projekat.Terapija (VrstaTerapije, NazivTerapije, NapomenaTerapija, DuzinaTrajanja) VALUES ('Psihoterapija', 'Kognitivno-bihejvioralna terapija', 'Kognitivno-bihejvioralna terapija se koristi za lečenje mentalnih poremećaja.', '60 minuta');
INSERT INTO Projekat.Terapija (VrstaTerapije, NazivTerapije, NapomenaTerapija, DuzinaTrajanja) VALUES ('Fizikalna terapija', 'Terapija ultrazvukom', 'Terapija ultrazvukom se koristi za smanjenje bola u mišićima i zglobovima, i poboljšanje cirkulacije krvi.', '20 minuta');
INSERT INTO Projekat.Terapija (VrstaTerapije, NazivTerapije, NapomenaTerapija, DuzinaTrajanja) VALUES ('Farmakoterapija', 'Antidepresivi', 'Antidepresivi se koriste za lečenje depresije.', '4-6 nedelja');

/*Insert za Tip pregleda*/

INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Prva poseta');
INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Kontrolna poseta');
INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Sistematski pregled odojceta');
INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Sistematski pregled deteta od 1-6 godina');
INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Sistematski pregled ucenika osnovnih skola');
INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Sistematski pregled ucenika srednjih skola');
INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Pregled rasta i razvoja');
INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Pregled imunizacije');
INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Pregled infekcija i bolesti');
INSERT INTO Projekat.Tip_Pregleda (NazivTP) VALUES ('Pregled alergija');


/*Insert za Dijagnozu*/

INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Varicella', 'Virusne bolesti', 'Dijagnoza vodenih kozica');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Bronchitis', 'Respiratorne bolesti', 'Dijagnoza upale bronhija');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Konjunktivitis', 'Infektivne bolesti', 'Dijagnoza upale konjuktive');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Rubeola', 'Virusne bolesti', 'Dijagnoza rubeole');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Upala uha', 'Infektivne bolesti', 'Dijagnoza upale uha kod dece');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Influenza', 'Virusne bolesti', 'Akutna respiratorna infekcija uzrokovana virusom influence.');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Angina pectoris', 'Kardiovaskularne bolesti', 'Bol u grudima koja se javlja kada srce ne dobija dovoljno kiseonika.');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Diabetes mellitus', 'Endokrine bolesti', 'Bolest koja se karakteriše visokim nivoom šećera u krvi.');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Alergijski rinitis', 'Alergijske bolesti', 'Upala sluznice nosa uzrokovana alergijom.');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Bronhitis', 'Bolesti disajnih puteva', 'Upala sluznice bronhija koja uzrokuje kašalj i poteškoće sa disanjem.');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Reumatoidni artritis', 'Bolesti zglobova', 'Autoimuna bolest koja uzrokuje upalu zglobova i bol.');
INSERT INTO Projekat.Dijagnoza (LatinskiNaziv, GrupaBolesti, OpisDijagnoze) VALUES ('Parkinsonova bolest', 'Neurološke bolesti', 'Bolest koja uzrokuje tremor, rigidnost i poteškoće sa kretanjem.');

/*Insert u tabelu Odredjuje*/

select * from Projekat.Pregled order by datum

INSERT INTO Projekat.Odredjuje values (1,2);
INSERT INTO Projekat.Odredjuje values (2,4);
INSERT INTO Projekat.Odredjuje values (3,4);
INSERT INTO Projekat.Odredjuje values (13,7);
INSERT INTO Projekat.Odredjuje values (5,null);
INSERT INTO Projekat.Odredjuje values (14,6);
INSERT INTO Projekat.Odredjuje values (15,3);
INSERT INTO Projekat.Odredjuje values (8,2); --bronhitis
INSERT INTO Projekat.Odredjuje values (9,3); -- konjuktivitis
INSERT INTO Projekat.Odredjuje values (10,4); -- rubeola 
INSERT INTO Projekat.Odredjuje values (11,5); -- upala uva
INSERT INTO Projekat.Odredjuje values (12,6); -- influenca 
INSERT INTO Projekat.Odredjuje values (13,7); --angina pectoris 
INSERT INTO Projekat.Odredjuje values (20,6); --
INSERT INTO Projekat.Odredjuje values (21,4); --
INSERT INTO Projekat.Odredjuje values (22,2); --
INSERT INTO Projekat.Odredjuje values (23,6); --
INSERT INTO Projekat.Odredjuje values (24,2); --
INSERT INTO Projekat.Odredjuje values (25,2); --
INSERT INTO Projekat.Odredjuje values (26,6); --
INSERT INTO Projekat.Odredjuje values (27,6); --
INSERT INTO Projekat.Odredjuje values (28,2); --
INSERT INTO Projekat.Odredjuje values (29,2); --
INSERT INTO Projekat.Odredjuje values (30,6);
INSERT INTO Projekat.Odredjuje values (31,6);
INSERT INTO Projekat.Odredjuje values (32,6);
INSERT INTO Projekat.Odredjuje values (33,6);
INSERT INTO Projekat.Odredjuje values (34,6);
INSERT INTO Projekat.Odredjuje values (35,6);
INSERT INTO Projekat.Odredjuje values (36,6);
INSERT INTO Projekat.Odredjuje values (37,6);
INSERT INTO Projekat.Odredjuje values (38,6);




/*INSERT u tabelu Je_Odredjena*/



INSERT INTO Projekat.Je_Odredjena values (3,2,8,1,'1x1'); --bronhitis
INSERT INTO Projekat.Je_Odredjena values (3,3,9,4,'3x1'); -- konjuktivitis
INSERT INTO Projekat.Je_Odredjena values (3,4,10,6,'1x1'); -- rubeola 
INSERT INTO Projekat.Je_Odredjena values (3,5,11,2,'2x1'); -- upala uva
INSERT INTO Projekat.Je_Odredjena values (4,5,11,3,'1 nedeljno'); -- upala uva
INSERT INTO Projekat.Je_Odredjena values (3,6,12,2,'2 puta nedeljno'); -- influenca 
INSERT INTO Projekat.Je_Odredjena values (3,6,12,7,'jednom'); --diabetes












/*Insert u tabelu Biva_Odredjena*/

INSERT INTO Projekat.Biva_Odredjena values (8,2,3);
INSERT INTO Projekat.Biva_Odredjena values (9,3,3); 
INSERT INTO Projekat.Biva_Odredjena values (10,4,5); 
INSERT INTO Projekat.Biva_Odredjena values (11,5,3); 
INSERT INTO Projekat.Biva_Odredjena values (12,6,3); 
INSERT INTO Projekat.Biva_Odredjena values (12,6,2); 
INSERT INTO Projekat.Biva_Odredjena values (13,7,3);
INSERT INTO Projekat.Biva_Odredjena values (13,7,2);
INSERT INTO Projekat.Biva_Odredjena values (12,6,4);
INSERT INTO Projekat.Biva_Odredjena values (12,6,2);

/*Insert u tabelu Hitan_Pregled*/


INSERT INTO Projekat.Hitan_Pregled values (4,'Pacijent je dosao na hitan pregled posle povrede na sportskoj utakmici gde je zadobio povredu stopala');
INSERT INTO Projekat.Hitan_Pregled values (12,'Pacijent je dosao na hitan pregled zato sto je osetio veoma otezano disanje');
INSERT INTO Projekat.Hitan_Pregled values (11,'Pacijent je dosao na hitan pregled zbog ogromnog bola u uvu');

/*Insert u tabelu Zakazan_Pregled*/

INSERT INTO Projekat.Zakazan_Pregled values (8,9);
INSERT INTO Projekat.Zakazan_Pregled values (9,2);
INSERT INTO Projekat.Zakazan_Pregled values (10,9);
INSERT INTO Projekat.Zakazan_Pregled values (11,9);
INSERT INTO Projekat.Zakazan_Pregled values (12,9);
INSERT INTO Projekat.Zakazan_Pregled values (13,9);
INSERT INTO Projekat.Zakazan_Pregled values (36,9);
INSERT INTO Projekat.Zakazan_Pregled values (35,2);
INSERT INTO Projekat.Zakazan_Pregled values (34,9);
INSERT INTO Projekat.Zakazan_Pregled values (33,9);
INSERT INTO Projekat.Zakazan_Pregled values (32,9);
INSERT INTO Projekat.Zakazan_Pregled values (31,9);
INSERT INTO Projekat.Zakazan_Pregled values (30,9);
INSERT INTO Projekat.Zakazan_Pregled values (29,2);
INSERT INTO Projekat.Zakazan_Pregled values (28,9);
INSERT INTO Projekat.Zakazan_Pregled values (27,9);
INSERT INTO Projekat.Zakazan_Pregled values (26,9);
INSERT INTO Projekat.Zakazan_Pregled values (25,9);
INSERT INTO Projekat.Zakazan_Pregled values (24,9);
INSERT INTO Projekat.Zakazan_Pregled values (23,9);
INSERT INTO Projekat.Zakazan_Pregled values (22,9);
INSERT INTO Projekat.Zakazan_Pregled values (21,9);

/*INSERT u tabelu OBUHVATA*/

INSERT INTO Projekat.Obuhvata values (1,4,38.2);
INSERT INTO Projekat.Obuhvata values (2,3,65);
INSERT INTO Projekat.Obuhvata values (3,5,438);
INSERT INTO Projekat.Obuhvata values (4,5,412);
INSERT INTO Projekat.Obuhvata values (7,5,341);
INSERT INTO Projekat.Obuhvata values (8,4,37.7);
INSERT INTO Projekat.Obuhvata values (10,1,60);
INSERT INTO Projekat.Obuhvata values (11,3,55);
INSERT INTO Projekat.Obuhvata values (31,4,38.2);
INSERT INTO Projekat.Obuhvata values (32,4,39.2);
INSERT INTO Projekat.Obuhvata values (33,4,38.0);
INSERT INTO Projekat.Obuhvata values (34,4,38.1);
INSERT INTO Projekat.Obuhvata values (35,4,37.9);
INSERT INTO Projekat.Obuhvata values (24,3,52);
INSERT INTO Projekat.Obuhvata values (25,3,61);
INSERT INTO Projekat.Obuhvata values (28,3,70);
INSERT INTO Projekat.Obuhvata values (29,3,69);




















