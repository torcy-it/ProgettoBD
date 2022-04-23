CREATE TYPE FasciaOraria AS ENUM ('Mattina','Pomeriggio','Sera','Notte');
CREATE TYPE TipoUtente AS ENUM ('Ascoltatore','Autore');
CREATE TYPE TipoTraccia AS ENUM ('Originale','Remastering','Cover','Live','Remix');


CREATE TABLE UTENTE
(
	UtenteID VARCHAR (255) PRIMARY KEY,
	nome VARCHAR ( 255 ) ,
	cognome VARCHAR ( 255 ) ,
	DataNascita DATE NOT NULL,
	DataIscrizione DATE DEFAULT CURRENT_TIMESTAMP,
	Email VARCHAR ( 255 ) UNIQUE NOT NULL ,
	T_Utente TipoUtente DEFAULT 'Ascoltatore',

 	CONSTRAINT Vincolo_email_Utente 
		CHECK (Email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
	CONSTRAINT Vincolo_DateSubcrition_dateBirth
		CHECK ( DataNascita < current_date )
);

CREATE TABLE ALBUM
(
	AlbumID SERIAL PRIMARY KEY,
	TitoloAlbum VARCHAR ( 255 )  NOT NULL,
	ColoreCopertina VARCHAR(255),
	EtichettaDiscografica VARCHAR ( 255 ),
	DataUscita DATE NOT NULL,
	ArtistaID VARCHAR ( 255 ) ,

	CONSTRAINT "ArtistaID_fk" FOREIGN KEY (ArtistaID )
 		REFERENCES Utente (UtenteID) MATCH SIMPLE
 			ON UPDATE CASCADE
 			ON DELETE CASCADE

);



CREATE TABLE TRACCIA
(
	TracciaID SERIAL PRIMARY KEY,
	TitoloTraccia VARCHAR ( 255 ) NOT NULL,
	Durata TIME NOT NULL,
	Genere VARCHAR ( 255 ),
	T_Traccia TipoTraccia NOT NULL,
	CodTracciaOriginale INT ( 255 ),
	AlbumID INT (255),

 	CONSTRAINT "AlbumID_fk" FOREIGN KEY (AlbumID)
 		REFERENCES album (AlbumID) MATCH SIMPLE
 			ON UPDATE CASCADE
 			ON DELETE CASCADE
);

CREATE TABLE SEGUITO
(
	segue VARCHAR(255),
	seguito_da VARCHAR(255),

 	CONSTRAINT "QuestoUtente_Segue_fk" FOREIGN KEY (segue )
 		REFERENCES Utente (UtenteID) MATCH SIMPLE
 			ON UPDATE CASCADE
 			ON DELETE CASCADE
 	CONSTRAINT "QuestoUtente_VieneSeguito_fk" FOREIGN KEY (segue )
 		REFERENCES Utente (UtenteID) MATCH SIMPLE
 			ON UPDATE CASCADE
 			ON DELETE CASCADE

);


CREATE TABLE ASCOLTI
(	
	AscoltatoreID VARCHAR ( 255 ) NOT NULL,
	TracciaID INT ( 255 ) NOT NULL,
	ora FasciaOraria NOT NULL,
	FOREIGN KEY (TracciaID ) REFERENCES TRACCIA(Codtraccia),
	FOREIGN KEY (AscoltatoreID ) REFERENCES UTENTE(UtenteID)
);


// popoling the database


INSERT INTO ALBUM ( AlbumID, TitoloAlbum , ColoreCopertina,	EtichettaDiscografica, ArtistaID, DataUscita )
VALUES 
 ('00001', 'Mutando','Grigia','EastWest Italy','Squallor','01/01/1981'),
 ('00002', 'THE SCOTTS','Verde','Sony Music','THESCOTTS','24/04/2020'),
 ('00003', 'ASTROWORLD','Nero','Sony Music','Travis Scott','13/08/2018'),
 ('00004', 'Man of The Moon','Arancione','Columbia Records','Kid Cudi','15/08/2009'),
 ('00005', 'The Essential Bob Dylan','Bianco','Columbia Records','Bob Dylan','30/09/2000'),
 ('00006', 'De gregorio Canta Bob Dylan - Amore e Odio','Rosso','Sony Music','Francesco De Gregorio','30/09/2015'),
 ('00007', 'Use Your illusion II','Blue','Geffen Records','Guns N Roses','17/08/1991'),  
 ('00008', 'American IV: The Man Comes Around','Nero','American Recordings','Johnny Cash','01/01/2002'),
 ('00009', 'Violator(Deluxe)','Nero', 'Akuma Records','Depeche Mode','19/03/1990'), 
 ('00010', 'Due anni Dopo','Bianco','Columbia Records','Francesco Guccini','01/01/1970'),
 ('00011', 'The Platinum Collection','Grigio','EMI','Francesco Guccini','10/10/2006'),
 ('00012', 'Via Paolo Fabbri 43','Marrone','EMI','Francesco Guccini','01/01/1976'),
 ('00013', 'Ma noi no','Giallo','EastWest Italy','Nomadi','15/05/1992'),
 ('00014', 'I grandi successi originali','Rosso','RCA Records','Gino Paoli','01/01/2001'),
 ('00015', 'Il Cielo In Una Stanza','Blue','Italdisc','Mina','01/06/1960'),
 ('00016', 'I Primi Anni Vol.II','Bianco','Italdisc','Mina','01/01/1997'),
 ('00017', 'Mina Celentano','Giallo','PDU','MinaCelentano','14/05/1998'),
 ('00018', 'Unicamentecelentano','Rosa','Clan Celentano','Adriano Celentano','10/11/2006'),
 ('00019', 'Basta chiudere gli occhi', 'Verde','RCA Records','Gino Paoli','01/01/1964');



INSERT INTO UTENTE ( UtenteID, nome, Cognome, DataNascita, DataIscrizione, Email, T_Utente )
VALUES 
 ('Squallor','','','01/01/1969','20/04/2022','Squallor@gmail.com','Autore'),
 ('THESCOTTS','','','24/04/2020','20/04/2022','TheSCOOTS@gmail.com','Autore'),
 ('Travis Scott','Jack','Cactus','30/04/1991','10/07/2010','Travi.Scott@outlook.com','Autore'),
 ('Kid Cudi','Scott','Ramon','30/01/1984','11/07/2010','Kid.Cudi@live.it','Autore'),
 ('Bob Dylan','Robert','Zimmerman','24/05/1941','15/09/2017','RobertZimmer@virgilio.com','Autore'),
 ('Francesco De Gregorio','Francesco','De Gregorio','04/04/1951','12/12/2020','DeGrego@hotmail.com','Autore'),
 ('Guns N Roses','','','01/01/1985','30/12/2012','RockNeverDie@hotmail.com','Autore'),  
 ('Johnny Cash','J.R.','Cash','26/02/1932','30/10/2019','RngOFfire@virgilio.com','Autore'),
 ('Depeche Mode','','','01/01/1980','01/01/2022','RockModeon@live.it','Autore'), 
 ('Francesco Guccini','Francesco','Guccini','14/06/1940','03/12/2022','Avvelenato@live.it','Autore'),
 ('Nomadi','','','01/01/1963','03/12/2021','vagabondi@gmail.com','Autore'),
 ('Gino Paoli','Gino','Paoli','23/08/1934','01/01/2015','SaleGrosso@live.it','Autore'),
 ('Mina','Anna Maria','Mazzini','25/03/1940','26/08/2002','DrinDrin@outlook.com','Autore'),
 ('MinaCelentano','','','14/05/1998','26/08/2002','CooolTogheter@live.it','Autore'),
 ('Adriano Celentano','Adriano','Celentano','06/01/1938','20/04/2022','Gluck17@hotmail.com','Autore'),
 ('Francesca_pgl','Francesca', 'Pugliese','01/01/1996','20/04/2022','F.pugliese@studenti.unina.it','Ascoltatore'),
 ('Torci','Adolfo', 'Torcicollo','13/03/1999','20/04/2022','a.torcicollo@studenti.unina.it','Ascoltatore');


INSERT INTO traccia ( codtraccia, titolotraccia, durata, genere, t_traccia, codtracciaoriginale, albumid )
VALUES 
	('t0000','Squallor in concerto','00:01:33','Non-Music','Originale','','00001'),
	('t0001','Damme e denare','00:06:01','Non-Music','Originale','','00001'),
	('t0002','Madonina','00:04:05','Non-Music','Originale','','00001'),
	('t0003','Cornutone','00:04:13','Non-Music','Originale','','00001'),
	('t0004','Torna a casa Mexico','00:05:17','Non-Music','Originale','','00001'),
	('t0005','Pret-a-porter','00:05:45','Non-Music','Originale','','00001'),
	('t0006','Pierpaolo n3','00:05:59','Non-Music','Originale','','00001'),
	('t0007','Tombeado','00:05:34','Non-Music','Originale','','00001'),
	('t0008','tango 13','00:06:17','Non-Music','Originale','','00001'),
	('t0009','THESCOTS','00:02:45','Hip-hop/Rap','Originale','','00002'),
	('t0010','STARGAZING','00:04:31','Hip-Hop/Trap','Originale','','00003'),
	('t0011','SICKO MODE','00:04:13','Hip-Hop/Trap','Originale','','00003'),
	('t0012','STOP CRYING','00:05:39','Hip-Hop/Trap','Originale','','00003'),
	('t0013','SKELETONS','00:02:26','Hip-Hop/Trap','Originale','','00003'),
	('t0014','5% TINT','00:03:16','Hip-Hop/Trap','Originale','','00003'),
	('t0015','BUTTERFLY EFFECT','00:03:11','Hip-Hop/Trap','Originale','','00003'),
	('t0016','CAROUSEL','00:03:00','Hip-Hop/Trap','Originale','','00003'),
	('t0017','WAKE UP','00:03:52','Hip-Hop/Trap','Originale','','00003'),
	('t0018','In My Dreams','00:03:19','Hip-Hop/Alternative Rock','Originale','','00004'),
	('t0019','Simple As...','00:02:31','Hip-Hop/Alternative Rock','Originale','','00004'),
	('t0020','Day N Nite','00:03:41','Hip-Hop/Alternative Rock','Originale','','00004'),
	('t0021','Day N Nite(Crookers Remix)','00:04:42','Hip-Hop/Alternative Rock','Remix','t0020','00004'),
	('t0022','Pursuit of Happines','04:04:55','Hip-Hop/Alternative Rock','Originale','','00004'),
	('t0023','Solo Dolo','00:04:26','Hip-Hop/Alternative Rock','Originale','','00004'),
	('t0024','Blowin in the wind','00:02:48','Rock/Folk Music','Originale','','00005'),
	('t0025','The tymes they are a-changing','00:03:14','Rock/Folk Music','Originale','','00005'),
	('t0026','Dont think Twice, its all right','00:03:40','Rock/Folk Music','Originale','','00005'),
	('t0027','Mr. Tambourine Man','00:05:29','Rock/Folk Music','Originale','','00005'),
	('t0028','Like a Rolling Stone','00:06:10','Rock/Folk Music','Originale','','00005'),
	('t0029','Subterranean Homesick blues','00:02:20','Rock/Folk Music','Originale','','00005'),
	('t0030','Lay Lady Lay','00:03:19','Rock/Folk Music','Originale','','00005'),
	('t0031','I shall Be released','00:03:04','Rock/Folk Music','Originale','','00005'),
	('t0032','Knockin on heavens door','00:02:31','Rock/Folk Music','Originale','','00005'),
	('t0033','Hurricane','00:08:33','Rock/Folk Music','Originale','','00005'),
	('t0034','Un angioletto come te','00:04:33','Pop','Cover','','00006'),
	('t0081','Come il giorno','00:03:58','Pop','Cover','t0031','00006'),
	('t0035','Acido Seminterrato','00:02:08','Pop','Cover','t0029','00006'),
	('t0036','Civil War','00:07:42','Hard Rock/Rock Clasico','Originale','','00007'),
	('t0037','Knockin on heavens door','00:05:36','Hard Rock/Rock Clasico','Cover','t0032','00007'),
	('t0038','Shotgun Blues','00:03:23','Hard Rock/Rock Clasico','Originale','','00007'),
	('t0039','Personal Jesus','00:04:55','Rock elettronico','Originale','','00009'),
	('t0040','Enjoy the Silence','00:06:13','Rock elettronico','Originale','','00009'),
	('t0041','Waiting for the night','00:06:07','Rock elettronico','Originale','','00009'),
	('t0042','Personal Jesus','00:03:20','Country','Cover','t0039','00008'),
	('t0043','Hurt','00:03:39','Country','Cover','','00008'),
	('t0044','Big Iron','00:03:59','Country','Cover','','00008'),
	('t0045','Lui e Lei','00:03:13','indie/Folk','Originale','','00010'),
	('t0046','Vedi Cara','00:04:58','indie/Folk','Originale','','00010'),
	('t0047','Primavera di Praga','00:03:38','indie/Folk','Originale','','00010'),
	('t0048','Il Compleanno','00:03:31','indie/Folk','Originale','','00010'),
	('t0049','Giorno d estate','00:03:48','indie/Folk','Originale','','00010'),
	('t0055','L avvelenata','00:04:35','indie/Folk','Originale','','00012'),
	('t0056','Canzone di notte n.2','00:04:53','indie/Folk','Originale','','00012'),
	('t0057','Canzone Quasi d amore','00:04:10','indie/Folk','Originale','','00012'),
	('t0050','L avvelenata','00:04:36','indie/Folk','Remastering','t0055','00011'),
	('t0051','Eskimo','00:08:14','indie/Folk','Remastering','','00011'),
	('t0052','Farewell','00:05:15','indie/Folk','Remastering','','00011'),
	('t0053','Vedi Cara','00:04:51','indie/Folk','Remastering','t0046','00011'),
	('t0054','Bologna','00:04:42','indie/Folk','Remastering','','00011'),
	('t0058','Canzone di notte n.2','00:04:53','indie/Folk','Remastering','t0056','00011'),
	('t0060','Canzone per un amica','00:03:20','Rock/Pop','Cover','','00013'),
	('t0061','Io Vagabondo','00:03:25','Rock/Pop','Remastering','','00013'),
	('t0059','Dio è morto','00:02:54','Rock/Pop','Cover','','00013'),
	('t0062','Il cielo in una stanza','00:02:52','Musica D autore','Originale','','00014'),
	('t0063','Sapore Di sale','00:03:33','Musica D autore','Remastering','t0078','00014'),
	('t0064','Senza Fine','00:02:47','Musica D autore','Remastering','','00014'),
	('t0065','Il cielo in una stanza','00:01:59','Pop','Cover','t0062','00015'),
	('t0066','Pesci Rossi','00:02:20','Pop','Cover','','00015'),
	('t0067','La Nonna Magdalena','00:03:20','Pop','Cover','','00015'),
	('t0068','Il cielo in una stanza','00:02:59','Pop','Remastering','t0065','00016'),
	('t0069','Pesci Rossi','00:02:22','Pop','Remastering','t0066','00016'),
	('t0070','La Nonna Magdalena','00:02:10','Pop','Remastering','t0067','00016'),
	('t0071','Tintarella di Luna','00:03:06','Pop','Remastering','','00016'),
	('t0072','Acqua e sale','00:04:42','Folk/Pop','Originale','','00017'),
	('t0073','Brivido Felino','00:03:44','Folk/Pop','Originale','','00017'),
	('t0074','Si è spento il sole','00:02:56','Rock/Pop Rock','Cover','','00018'),
	('t0075','Azzurro','00:03:43','Rock/Pop Rock','Remastering','','00018'),
	('t0076','Il tempo se ne va','00:04:55','Rock/Pop Rock','Remastering','','00018'),
	('t0077','24 mila baci','00:02:14','Rock/Pop Rock','Cover','','00018'),
	('t0078','Sapore Di sale','00:03:33','Musica D autore','Originale','','00019'),
	('t0079','Che cosa c è','00:02:38','Musica D autore','Remastering','t0080','00014'),
	('t0080','Che cosa c è','00:02:38','Musica D autore','Originale','','00019');


insert into ascolti ( ascoltatoreID , tracciaid , ora)
values 
	('Francesca_pgl','t0053','Mattina'),
	('Francesca_pgl','t0060','Sera'),
	('Francesca_pgl','t0000','Mattina'),
	('Francesca_pgl','t0003','Sera'),
	('Francesca_pgl','t0078','Pomeriggio'),
	('Francesca_pgl','t0032','Mattina'),
	('Francesca_pgl','t0031','Pomeriggio'),
	('Francesca_pgl','t0068','Pomeriggio'),
	('Francesca_pgl','t0020','Sera'),
	('Francesca_pgl','t0081','Sera'),
	('Francesca_pgl','t0078','Pomeriggio'),
	('Francesca_pgl','t0081','Sera'),
	('Francesca_pgl','t0031','Pomeriggio'),
	('Torci','t0068','Pomeriggio'),
	('Torci','t0031','Notte'),
	('Torci','t0003','Pomeriggio'),
	('Torci','t0032','Pomeriggio'),
	('Torci','t0078','Notte'),
	('Torci','t0078','Notte'),
	('Torci','t0000','Pomeriggio'),
	('Torci','t0053','Pomeriggio'),
	('Torci','t0053','Notte'),
	('Torci','t0060','Mattina'),
	('Torci','t0068','Mattina'),
	('Torci','t0020','Mattina'),
	('Torci','t0020','Pomeriggio'),
	('Torci','t0020','Notte'),
	('Torci','t0068','Notte');


insert into seguito ( segue , seguito_da ) 
values 
	('Torci','Kid Cudi'),
	('Torci','Travis Scott'),
	('Torci','THESCOTTS'),
	('Torci','Squallor'),
	('Torci','Francesco De Gregorio'),
	('Torci','Bob Dylan'),
	('Torci','Gino Paoli'),
	('Torci','Francesca_pgl'),
	('Francesca_pgl','Torci'),
	('Francesca_pgl','Gino Paoli'),
	('Francesca_pgl','Mina'),
	('Francesca_pgl','MinaCelentano'),
	('Francesca_pgl','Adriano Celentano'),
	('Francesca_pgl','Nomadi'),
	('Francesca_pgl','Depeche Mode'),
	('Kid Cudi','Torci'),
	('Travis Scott','Torci'),
	('THESCOTTS','Torci'),
	('Squallor','Torci'),
	('Francesco De Gregorio','Torci'),
	('Bob Dylan','Torci'),
	('Gino Paoli','Francesca_pgl'),
	('Mina','Francesca_pgl'),
	('MinaCelentano','Francesca_pgl'),
	('Adriano Celentano','Francesca_pgl'),
	('Nomadi','Francesca_pgl'),
	('Depeche Mode','Francesca_pgl');

