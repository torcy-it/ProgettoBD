
/* DEFINIZIONI TABELLE*/
CREATE TYPE FasciaOraria AS ENUM ('Mattina','Pomeriggio','Sera','Notte');
CREATE TYPE TipoUtente AS ENUM ('Ascoltatore','Artista');
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

	CONSTRAINT ArtistaID_fk FOREIGN KEY (ArtistaID )
 		REFERENCES Utente (UtenteID) MATCH SIMPLE
 			ON UPDATE CASCADE
 			ON DELETE CASCADE,

   	CONSTRAINT CheckifArtista
    CHECK (ifArtistInsertAlbum (artistaID) = 'True')
);


CREATE TABLE TRACCIA
(
	TracciaID SERIAL PRIMARY KEY,
	TitoloTraccia VARCHAR ( 255 ) NOT NULL,
	Durata TIME NOT NULL,
	Genere VARCHAR ( 255 ),
	T_Traccia TipoTraccia NOT NULL,
	CodTracciaOriginale INT DEFAULT 0,
	AlbumID int NOT NULL,

 	CONSTRAINT AlbumID_fk FOREIGN KEY (AlbumID)
 		REFERENCES album (AlbumID) MATCH SIMPLE
 			ON UPDATE CASCADE
 			ON DELETE CASCADE,
	
	CONSTRAINT MaxDurataTraccia 
		CHECK ( Durata < '01:00:00' AND Durata > '00:00:05' )	
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

/*FUNZIONI*/

CREATE OR REPLACE FUNCTION ifArtistInsertAlbum ( artistaid VARCHAR(255) ) 
	RETURNS VARCHAR(5) 
AS 
$$
BEGIN
    IF ( SELECT UTENTEID FROM UTENTE WHERE utenteid = artistaid AND T_UTENTE <> 'Artista')
    then return 'False';
	else
    return 'True';
    end if;
END;
$$ LANGUAGE plpgsql;

/*POPOLAMENTO DATABASE*/

/* da aggiungere artista id*/
INSERT INTO ALBUM (TitoloAlbum , ColoreCopertina,	EtichettaDiscografica, ArtistaID, DataUscita )
VALUES 
 ('Mutando','Grigia','EastWest Italy','Squallor','01/01/1981'),
 ('THE SCOTTS','Verde','Sony Music','THESCOTTS','24/04/2020'),
 ('ASTROWORLD','Nero','Sony Music','Travis Scott','13/08/2018'),
 ('Man of The Moon','Arancione','Columbia Records','Kid Cudi','15/08/2009'),
 ('The Essential Bob Dylan','Bianco','Columbia Records','Bob Dylan','30/09/2000'),
 ('De gregorio Canta Bob Dylan - Amore e Odio','Rosso','Sony Music','Francesco De Gregorio','30/09/2015'),
 ('Use Your illusion II','Blue','Geffen Records','Guns N Roses','17/08/1991'),  
 ('American IV: The Man Comes Around','Nero','American Recordings','Johnny Cash','01/01/2002'),
 ('Violator(Deluxe)','Nero', 'Akuma Records','Depeche Mode','19/03/1990'), 
 ('Due anni Dopo','Bianco','Columbia Records','Francesco Guccini','01/01/1970'),
 ('The Platinum Collection','Grigio','EMI','Francesco Guccini','10/10/2006'),
 ('Via Paolo Fabbri 43','Marrone','EMI','Francesco Guccini','01/01/1976'),
 ('Ma noi no','Giallo','EastWest Italy','Nomadi','15/05/1992'),
 ('I grandi successi originali','Rosso','RCA Records','Gino Paoli','01/01/2001'),
 ('Il Cielo In Una Stanza','Blue','Italdisc','Mina','01/06/1960'),
 ('I Primi Anni Vol.II','Bianco','Italdisc','Mina','01/01/1997'),
 ('Mina Celentano','Giallo','PDU','MinaCelentano','14/05/1998'),
 ('Unicamentecelentano','Rosa','Clan Celentano','Adriano Celentano','10/11/2006'),
 ('Basta chiudere gli occhi', 'Verde','RCA Records','Gino Paoli','01/01/1964');



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


/* da aggiungere album id*/
INSERT INTO traccia ( codtraccia, titolotraccia, durata, genere, t_traccia, codtracciaoriginale, albumid )
VALUES 
	('Squallor in concerto','00:01:33','Non-Music','Originale','',)
	('Damme e denare','00:06:01','Non-Music','Originale','',)
	('Madonina','00:04:05','Non-Music','Originale','',)
	('Cornutone','00:04:13','Non-Music','Originale','',)
	('Torna a casa Mexico','00:05:17','Non-Music','Originale','',)
	('Pret-a-porter','00:05:45','Non-Music','Originale','',)
	('Pierpaolo n3','00:05:59','Non-Music','Originale','',)
	('Tombeado','00:05:34','Non-Music','Originale','',)
	('tango 13','00:06:17','Non-Music','Originale','',)
	('THESCOTS','00:02:45','Hip-hop/Rap','Originale','',)
	('STARGAZING','00:04:31','Hip-Hop/Trap','Originale','',)
	('SICKO MODE','00:04:13','Hip-Hop/Trap','Originale','',)
	('STOP CRYING','00:05:39','Hip-Hop/Trap','Originale','',)
	('SKELETONS','00:02:26','Hip-Hop/Trap','Originale','',)
	('5% TINT','00:03:16','Hip-Hop/Trap','Originale','',)
	('BUTTERFLY EFFECT','00:03:11','Hip-Hop/Trap','Originale','',)
	('CAROUSEL','00:03:00','Hip-Hop/Trap','Originale','',)
	('WAKE UP','00:03:52','Hip-Hop/Trap','Originale','',)
	('In My Dreams','00:03:19','Hip-Hop/Alternative Rock','Originale','',)
	('Simple As...','00:02:31','Hip-Hop/Alternative Rock','Originale','',)
	('Day N Nite','00:03:41','Hip-Hop/Alternative Rock','Originale','',)
	('Day N Nite(Crookers Remix)','00:04:42','Hip-Hop/Alternative Rock','Remix',)
	('Pursuit of Happines','04:04:55','Hip-Hop/Alternative Rock','Originale','',)
	('Solo Dolo','00:04:26','Hip-Hop/Alternative Rock','Originale','',)
	('Blowin in the wind','00:02:48','Rock/Folk Music','Originale','',)
	('The tymes they are a-changing','00:03:14','Rock/Folk Music','Originale','',)
	('Dont think Twice, its all right','00:03:40','Rock/Folk Music','Originale','',)
	('Mr. Tambourine Man','00:05:29','Rock/Folk Music','Originale','',)
	('Like a Rolling Stone','00:06:10','Rock/Folk Music','Originale','',)
	('Subterranean Homesick blues','00:02:20','Rock/Folk Music','Originale','',)
	('Lay Lady Lay','00:03:19','Rock/Folk Music','Originale','',)
	('I shall Be released','00:03:04','Rock/Folk Music','Originale','',)
	('Knockin on heavens door','00:02:31','Rock/Folk Music','Originale','',)
	('Hurricane','00:08:33','Rock/Folk Music','Originale','',)
	('Un angioletto come te','00:04:33','Pop','Cover','',)
	('Come il giorno','00:03:58','Pop','Cover',)
	('Acido Seminterrato','00:02:08','Pop','Cover',)
	('Civil War','00:07:42','Hard Rock/Rock Clasico','Originale','',)
	('Knockin on heavens door','00:05:36','Hard Rock/Rock Clasico','Cover',)
	('Shotgun Blues','00:03:23','Hard Rock/Rock Clasico','Originale','',)
	('Personal Jesus','00:04:55','Rock elettronico','Originale','',)
	('Enjoy the Silence','00:06:13','Rock elettronico','Originale','',)
	('Waiting for the night','00:06:07','Rock elettronico','Originale','',)
	('Personal Jesus','00:03:20','Country','Cover',)
	('Hurt','00:03:39','Country','Cover','',)
	('Big Iron','00:03:59','Country','Cover','',)
	('Lui e Lei','00:03:13','indie/Folk','Originale','',)
	('Vedi Cara','00:04:58','indie/Folk','Originale','',)
	('Primavera di Praga','00:03:38','indie/Folk','Originale','',)
	('Il Compleanno','00:03:31','indie/Folk','Originale','',)
	('Giorno d estate','00:03:48','indie/Folk','Originale','',)
	('L avvelenata','00:04:35','indie/Folk','Originale','',)
	('Canzone di notte n.2','00:04:53','indie/Folk','Originale','',)
	('Canzone Quasi d amore','00:04:10','indie/Folk','Originale','',)
	('L avvelenata','00:04:36','indie/Folk','Remastering',)
	('Eskimo','00:08:14','indie/Folk','Remastering','',)
	('Farewell','00:05:15','indie/Folk','Remastering','',)
	('Vedi Cara','00:04:51','indie/Folk','Remastering',)
	('Bologna','00:04:42','indie/Folk','Remastering','',)
	('Canzone di notte n.2','00:04:53','indie/Folk','Remastering',)
	('Canzone per un amica','00:03:20','Rock/Pop','Cover','',)
	('Io Vagabondo','00:03:25','Rock/Pop','Remastering','',)
	('Dio è morto','00:02:54','Rock/Pop','Cover','',)
	('Il cielo in una stanza','00:02:52','Musica D autore','Originale','',)
	('Sapore Di sale','00:03:33','Musica D autore','Remastering',)
	('Senza Fine','00:02:47','Musica D autore','Remastering','',)
	('Il cielo in una stanza','00:01:59','Pop','Cover',)
	('Pesci Rossi','00:02:20','Pop','Cover','',)
	('La Nonna Magdalena','00:03:20','Pop','Cover','',)
	('Il cielo in una stanza','00:02:59','Pop','Remastering',)
	('Pesci Rossi','00:02:22','Pop','Remastering',)
	('La Nonna Magdalena','00:02:10','Pop','Remastering',)
	('Tintarella di Luna','00:03:06','Pop','Remastering','',)
	('Acqua e sale','00:04:42','Folk/Pop','Originale','',)
	('Brivido Felino','00:03:44','Folk/Pop','Originale','',)
	('Si è spento il sole','00:02:56','Rock/Pop Rock','Cover','',)
	('Azzurro','00:03:43','Rock/Pop Rock','Remastering','',)
	('Il tempo se ne va','00:04:55','Rock/Pop Rock','Remastering','',)
	('24 mila baci','00:02:14','Rock/Pop Rock','Cover','',)
	('Sapore Di sale','00:03:33','Musica D autore','Originale','',)
	('Che cosa c è','00:02:38','Musica D autore','Remastering',)
	('Che cosa c è','00:02:38','Musica D autore','Originale','',)

/* da aggiungere traccia id*/
insert into ascolti ( ascoltatoreID , tracciaid , ora)
values 
	('Francesca_pgl','Mattina'),
	('Francesca_pgl','Sera'),
	('Francesca_pgl','Mattina'),
	('Francesca_pgl','Sera'),
	('Francesca_pgl','Pomeriggio'),
	('Francesca_pgl','Mattina'),
	('Francesca_pgl','Pomeriggio'),
	('Francesca_pgl','Pomeriggio'),
	('Francesca_pgl','Sera'),
	('Francesca_pgl','Sera'),
	('Francesca_pgl','Pomeriggio'),
	('Francesca_pgl','Sera'),
	('Francesca_pgl','Pomeriggio'),
	('Torci','Pomeriggio'),
	('Torci','Notte'),
	('Torci','Pomeriggio'),
	('Torci','Pomeriggio'),
	('Torci','Notte'),
	('Torci','Notte'),
	('Torci','Pomeriggio'),
	('Torci','Pomeriggio'),
	('Torci','Notte'),
	('Torci','Mattina'),
	('Torci','Mattina'),
	('Torci','Mattina'),
	('Torci','Pomeriggio'),
	('Torci','Notte'),
	('Torci','Notte');


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

