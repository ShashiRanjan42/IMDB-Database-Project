CREATE DATABASE IMDB;

USE IMDB;
GO

CREATE SCHEMA Foundation;
GO

CREATE TABLE Foundation.Actors (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Sex VARCHAR(10) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Bio NVARCHAR(MAX) NOT NULL,
);

CREATE TABLE Foundation.Producers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Sex VARCHAR(10) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Bio NVARCHAR(MAX) NOT NULL,
);


CREATE TABLE Foundation.Movies (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    YearOfRelease INT NOT NULL,
    Plot NVARCHAR(MAX),
    Poster NVARCHAR(500),
    ProducerId INT NOT NULL,
	CONSTRAINT FK_Movies_Producers FOREIGN KEY (ProducerId) 
		REFERENCES Foundation.Producers(Id) ON DELETE CASCADE,
);

CREATE TABLE Foundation.Movie_Actors (
    Id INT PRIMARY KEY IDENTITY(1,1),
    MovieId INT NOT NULL,
    ActorId INT NOT NULL,
    CONSTRAINT FK_MovieActors_Movies FOREIGN KEY (MovieId)
        REFERENCES Foundation.Movies(Id) ON DELETE CASCADE,
    CONSTRAINT FK_MovieActors_Actors FOREIGN KEY (ActorId)
        REFERENCES Foundation.Actors(Id) ON DELETE CASCADE,
);

ALTER TABLE Foundation.Actors
ADD CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE();

ALTER TABLE Foundation.Producers
ADD CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE();

ALTER TABLE Foundation.Movies
ADD CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE();

ALTER TABLE Foundation.Movie_Actors
ADD CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE();

ALTER TABLE Foundation.Movies
ADD Language VARCHAR(50) NOT NULL 
CONSTRAINT DF_Movies_Language DEFAULT 'Hindi';

ALTER TABLE Foundation.Movies
ADD Profit INT NOT NULL CONSTRAINT DF_Movies_Profit DEFAULT 0;

INSERT INTO Foundation.Actors (Name,Sex, DateOfBirth, Bio) VALUES 
('Ranbir Kapoor', 'Male', '1982-09-28', 'Works in Hindi Movies'),
('Allu Arjun', 'Male', '1983-04-08', 'Works in South Indian Movies'),
('Deepika Padukone', 'Female', '1986-01-05', 'Leading actress in Bollywood'),
('Shah Rukh Khan', 'Male', '1965-11-02', 'King of Bollywood'),
('Priyanka Chopra', 'Female', '1982-07-18', 'Indian actress and singer');

INSERT INTO Foundation.Producers (Name,Sex, DateOfBirth, Bio) VALUES 
('Karan Johar', 'Male', '1972-05-25', 'Famous Bollywood producer'),
('Allu Aravind', 'Male', '1949-01-10', 'South Indian film producer'),
('Rakesh Roshan', 'Male', '1949-09-06', 'Indian director and producer');

INSERT INTO Foundation.Movies(Name, YearOfRelease, Plot, Poster, ProducerId, Language, Profit) VALUES 
('Jai Ho', 2014, 'A man fights against corruption.', 'https://example.com/jaiho.jpg', 1, 'Hindi', 450),
('Baahubali', 2015, 'A historical epic movie.', 'https://example.com/baahubali.jpg', 2, 'Telugu', 1500),
('Chennai Express', 2013, 'A comedy-action film.', 'https://example.com/chennai.jpg', 1, 'Hindi', 800),
('Raees', 2017, 'Crime thriller based on real events.', 'https://example.com/raees.jpg', 3, 'Hindi', 900),
('Zindagi Na Milegi Dobara', 2011, 'A road trip movie.', 'https://example.com/znmd.jpg', 1, 'Hindi', 700),
('Kabhi Khushi Kabhie Gham', 2001, 'A family drama.', 'https://example.com/k3g.jpg', 1, 'Hindi', 850);


INSERT INTO Foundation.Movie_Actors(MovieId, ActorId) VALUES 
(1, 1), (1, 3), (1, 4),
(2, 2), (2, 3),
(3, 4), (3, 3),
(4, 4), (4, 3),
(5, 3), (5, 1), (5, 4),
(6, 1), (6, 3), (6, 4);

SELECT * FROM Foundation.Actors;
SELECT * FROM Foundation.Producers;
SELECT * FROM Foundation.Movies;
SELECT * FROM Foundation.Movie_Actors;