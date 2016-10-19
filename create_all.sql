/* Combined SQL CREATE statements for INFO20003 project
	 Aaron Priestley, Heng Lin, Malcolm Karutz, Tessa Song
	 13 09 2014
*/
SET foreign_key_checks = 0;

DROP TABLE IF EXISTS Achievement;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS CrowdFundingViewer;
DROP TABLE IF EXISTS Equipment;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS InstanceRun;
DROP TABLE IF EXISTS InstanceRunPlayer;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS PlayerAddress;
DROP TABLE IF EXISTS PremiumViewer;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Venue;
DROP TABLE IF EXISTS VenueEquipment;
DROP TABLE IF EXISTS Video;
DROP TABLE IF EXISTS Viewer;
DROP TABLE IF EXISTS ViewerAddress;
DROP TABLE IF EXISTS ViewerOrder;
DROP TABLE IF EXISTS ViewerOrderLine;
DROP TABLE IF EXISTS ViewerType;

CREATE TABLE Game (
	GameID                  SMALLINT            NOT NULL AUTO_INCREMENT,
	GameTitle               VARCHAR(50),
	Genre                   VARCHAR(50),
	Review                  VARCHAR(256), /* changed from TEXT to VARCHAR(256) */
	StarRating              SMALLINT,
	ClassificationRating    VARCHAR(5),
	PlatformNotes           VARCHAR(256), /* changed from TEXT to VARCHAR(256) */
	PromotionLink           VARCHAR(50),
	Cost                    DECIMAL(5,2),
PRIMARY KEY (GameID)
) ENGINE=InnoDB;

CREATE TABLE Address (
	AddressID               SMALLINT            NOT NULL AUTO_INCREMENT,
	StreetAddressLine1      VARCHAR(50)         NOT NULL,
	StreetAddressLine2      VARCHAR(50),
	MinorMuniciplity        VARCHAR(50),
	MajorMuniciplity        VARCHAR(50)         NOT NULL,
	GoverningDistrict       VARCHAR(50)         NOT NULL,
	PostCode                VARCHAR(10)         NOT NULL,
	Country                 VARCHAR(50)         NOT NULL,
PRIMARY KEY(AddressID)
) ENGINE=InnoDB;

CREATE TABLE User (
	UserID                    SMALLINT         NOT NULL AUTO_INCREMENT,
	UserName                  VARCHAR(50)      NOT NULL,
	UserPassword              VARCHAR(30)      NOT NULL,
	UserType                  CHAR(1)          NOT NULL,
UNIQUE (UserName),
PRIMARY KEY(UserID)
) ENGINE=InnoDB;

CREATE TABLE Viewer (
	ViewerID                SMALLINT            NOT NULL,
	DateOfBirth             DATE                NOT NULL, /* assumed NOT NULL */
	Email                   VARCHAR(50)         NOT NULL, /* assumed NOT NULL */
PRIMARY KEY (ViewerID),
FOREIGN KEY(ViewerID) REFERENCES User(UserID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ViewerType (
	ViewerID                SMALLINT            NOT NULL,
	ViewerType              CHAR(1), /* 'P' = Premium Viewer, 'C' = Crowd Funding Viewer */
PRIMARY KEY (ViewerID, ViewerType),
FOREIGN KEY (ViewerID) REFERENCES Viewer(ViewerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE CrowdFundingViewer (
	ViewerID                SMALLINT            NOT NULL,
	FirstName               VARCHAR(45)         NOT NULL, /* assumed NOT NULL */
	LastName                VARCHAR(45)         NOT NULL, /* assumed NOT NULL */
	PerkCreditBalance       DECIMAL(10,2)       NOT NULL,
	TotalAmountDonated      DECIMAL(19,2)       NOT NULL, /* changed from VARCHAR(45) to DECIMAL(19,2) */
PRIMARY KEY (ViewerID),
FOREIGN KEY (ViewerID) REFERENCES Viewer(ViewerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PremiumViewer (
	ViewerID                SMALLINT            NOT NULL,
	RenewalDate             DATE                NOT NULL,
PRIMARY KEY (ViewerID),
FOREIGN KEY (ViewerID) REFERENCES Viewer(ViewerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Player (
	PlayerID                SMALLINT            NOT NULL,
	SupervisorID            SMALLINT,
	FirstName               VARCHAR(50)         NOT NULL,
	LastName                VARCHAR(50)         NOT NULL,
	Role                    VARCHAR(50)         NOT NULL,
	ProfileDescription      VARCHAR(256), /* changed from TEXT to VARCHAR(256) */
	Email                   VARCHAR(50)         NOT NULL,
	GameHandle              VARCHAR(50)         NOT NULL,
	Phone                   VARCHAR(14),
	VoIP                    VARCHAR(30)         NOT NULL,
PRIMARY KEY(PlayerID),
FOREIGN KEY(PlayerID) REFERENCES User(UserID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY(SupervisorID) REFERENCES Player(PlayerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Equipment (
	EquipmentID             SMALLINT            NOT NULL AUTO_INCREMENT,
	Make                    VARCHAR(45),
	Model                   VARCHAR(45),
	EquipmentReview         VARCHAR(256), /* changed from TEXT to VARCHAR(256) */
	ProcessorSpeed          VARCHAR(45),
PRIMARY KEY(EquipmentID)
) ENGINE=InnoDB;

CREATE TABLE Venue (
	VenueID                 SMALLINT            NOT NULL AUTO_INCREMENT,
	VenueName               VARCHAR(50)         NOT NULL,
	VenueDescription        VARCHAR(256), /* changed from TEXT to VARCHAR(256) */
	PowerOutlets            SMALLINT,
	LightingNotes           VARCHAR(256), /* changed from TEXT to VARCHAR(256) */
	VenueSupervisorID       SMALLINT            NOT NULL, /* changed column name from 'SupervisorID' to 'VenueSupervisorID'*/
PRIMARY KEY(VenueID),
FOREIGN KEY(VenueSupervisorID) REFERENCES Player(PlayerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE VenueEquipment (
	VenueID                     SMALLINT        NOT NULL,
	FinancialYearStartingDate   DATE            NOT NULL,
	EquipmentID                 SMALLINT        NOT NULL,
	SoftwareVersion             VARCHAR(45),
PRIMARY KEY(VenueID, FinancialYearStartingDate),
FOREIGN KEY(VenueID) REFERENCES Venue(VenueID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY(EquipmentID) REFERENCES Equipment(EquipmentID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE InstanceRun (
	InstanceRunID           SMALLINT            NOT NULL AUTO_INCREMENT,
	SupervisorID            SMALLINT            NOT NULL,
	InstanceRunName         VARCHAR(45)         NOT NULL, /* changed column name from 'Name' to 'InstanceRunName' */
	RecordedTime            DATETIME            NOT NULL,
	CategoryName            VARCHAR(50),
	GameID                  SMALLINT            NOT NULL,
	VenueID                 SMALLINT,
PRIMARY KEY (InstanceRunID),
FOREIGN KEY (SupervisorID) REFERENCES Player(PlayerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY (GameID) REFERENCES Game(GameID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY (VenueID) REFERENCES Venue(VenueID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE InstanceRunPlayer (
	PlayerID                SMALLINT            NOT NULL,
	InstanceRunID           SMALLINT            NOT NULL,
	EquipmentID             SMALLINT,
	PerformanceNotes        VARCHAR(256), /* changed from TEXT to VARCHAR(256) */
PRIMARY KEY (PlayerID, InstanceRunID),
FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY (InstanceRunID) REFERENCES InstanceRun(InstanceRunID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Achievement (
	AchievementID           SMALLINT            NOT NULL AUTO_INCREMENT,
	InstanceRunID           SMALLINT            NOT NULL,
	WhenAchieved            DATETIME,
	AchievementName         VARCHAR(45)         NOT NULL, /* assumed NOT NULL */
	RewardBody              VARCHAR(45),
PRIMARY KEY (AchievementID),
FOREIGN KEY (InstanceRunID) REFERENCES InstanceRun(InstanceRunID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ViewerAddress (
	ViewerID                SMALLINT            NOT NULL,
	AddressID               SMALLINT            NOT NULL,
	StartDate               DATE                NOT NULL,
	EndDate                 DATE,
PRIMARY KEY (ViewerID, AddressID, StartDate),
FOREIGN KEY (ViewerID) REFERENCES Viewer(ViewerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PlayerAddress (
	PlayerID                SMALLINT            NOT NULL,
	AddressID               SMALLINT            NOT NULL,
	StartDate               DATE                NOT NULL,
	EndDate                 DATE,
PRIMARY KEY (PlayerID, AddressID, StartDate),
FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Video (
	VideoID                 SMALLINT            NOT NULL AUTO_INCREMENT,
	URL                     VARCHAR(50)         NOT NULL,
	Price                   DECIMAL(5,2),
	VideoType               VARCHAR(45),
	InstanceRunID           SMALLINT            NOT NULL,
PRIMARY KEY(VideoID),
FOREIGN KEY(InstanceRunID) REFERENCES InstanceRun(InstanceRunID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ViewerOrder (
	ViewerOrderID           SMALLINT            NOT NULL AUTO_INCREMENT,
	OrderDate               DATE                NOT NULL,
	ViewerID                SMALLINT            NOT NULL,
PRIMARY KEY (ViewerOrderID),
FOREIGN KEY (ViewerID) REFERENCES Viewer(ViewerID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ViewerOrderLine (
	VideoID                 SMALLINT            NOT NULL,
	ViewerOrderID           SMALLINT            NOT NULL,
	FlagPerk                BOOLEAN             NOT NULL,
	ViewedStatus            CHAR(1)             NOT NULL DEFAULT 'P', /* 'P' = "Pending", 'V' = "Viewed" */
PRIMARY KEY (VideoID, ViewerOrderID),
FOREIGN KEY (VideoID) REFERENCES Video(VideoID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
FOREIGN KEY (ViewerOrderID) REFERENCES ViewerOrder(ViewerOrderID)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks = 1;

INSERT INTO User VALUES (DEFAULT, 'admin', 'admin', 'A');
INSERT INTO User VALUES (DEFAULT, 'peter', 'password', 'P');
	SET @UID=LAST_INSERT_ID();
	INSERT INTO Player VALUES (@UID, NULL, 'Peter', 'Chan', 'Captain', 'Peter is one of our administrators here at WWAG, managing much of our day-to-day operations. Peter is also a great in-game leader. His preferred game tyep is FPS and his forte is Battlefield.', 'peterchan@wwag.org', 'Captain Chan', NULL, 'pchan9000');
INSERT INTO User VALUES (DEFAULT, 'hannah', 'password', 'P');
	SET @UID=LAST_INSERT_ID();
	INSERT INTO Player VALUES (@UID, NULL, 'Hannah', 'Smith', 'Support', 'Hannah is one of our administrators here at WWAH, managing much of our day-to-day operations. In MOBA games such as Dota 2 and Leage of Legends, Hannah plays a critical support role - always doing all she can to ensure her teams success.', 'hannahsmith@wwag.org', 'handogg', NULL, 'handogg69');
INSERT INTO User VALUES (DEFAULT, 'george', 'password', 'P');
	SET @UID=LAST_INSERT_ID();
	INSERT INTO Player VALUES (@UID, 2, 'George', 'McCartney', 'Carry', 'George is our star Dota 2 and League of Legends player.', 'george@wwag.org', 'theIRISH', NULL, 'gmccartney1');

INSERT INTO Equipment VALUES (DEFAULT, 'Sony', 'Playstation 4', 'Next-gen graphics, wireless controllers featuring touchscreen and free online play make this platform a stand-out.','Semi-custom 8-core AMD x86-64 Jaguar CPU');
INSERT INTO Equipment VALUES (DEFAULT, 'Alienware', '17 HD', 'Power and portability - what more could you want?','4th Generation Intel® Core™ i7 Processor');
INSERT INTO Equipment VALUES (DEFAULT, 'Microsoft', 'Xbox One', 'It\'s not as powerful as the Playstation 4, and Xbox-live is  subscription based, but exclusive titles like Halo make the Xbox One an option to consider.','Custom 1.75 GHz AMD 8 core APU');



INSERT INTO Game VALUES (DEFAULT, 'Minecraft', 'Sandbox Indie', 'Very awesome game A+', '5', 'PG', 'Windows, OS X, Linux, Java platform, Java applet, Android, iOS, Windows Phone, Xbox 360, Xbox One, Raspberry Pi, PlayStation 3, PlayStation 4, PlayStation Vita', 'http://en.wikipedia.org/wiki/Minecraft', '26.95');
INSERT INTO Game VALUES (DEFAULT, 'World of Warcraft', 'MMORPG Fantasy', 'Very addictive game', '4', 'T', 'Microsoft Windows, OS X', 'http://us.battle.net/wow/en/', '14.99');
INSERT INTO Game VALUES (DEFAULT, 'Super Mario 64', 'Platforming', 'Combining the finest 3-D graphics ever developed for a video game and an explosive sound track, Super Mario 64 becomes a new standard for video games.', '5', 'E', 'Nintendo 64', 'http://www.metacritic.com/game/nintendo-64/super-mario-64', NULL);

INSERT INTO Venue VALUES (DEFAULT, 'The WWAG Tower', 'WWAG\'s biggest venue.', '30', 'Fluorescent lighting throughout.', 3);

INSERT INTO VenueEquipment VALUES (1, '2014-07-01', 2, "Windows 8.1"); 