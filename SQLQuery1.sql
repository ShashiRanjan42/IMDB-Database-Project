-- Solution of Assignment 2 
USE IMDB
GO

-- Write a query to get the age of the Actors in Days(Number of days).
SELECT Id, Name, DATEDIFF(DAY, DateOfBirth, GETDATE()) As AgeInDays
FROM Foundation.Actors;

-- Write a query to get the list of Actors who have worked with a given producer X.
SELECT DISTINCT A.Id, A.Name AS ActorName, P.Name AS ProducerName
FROM Foundation.Actors A
JOIN Foundation.Movie_Actors MA ON A.Id = MA.ActorId
JOIN Foundation.Movies M ON MA.MovieId = M.Id
JOIN Foundation.Producers P ON M.ProducerId = P.Id
WHERE P.Name = 'Karan Johar';

--Write a query to get the list of actors who have acted together in two or more movies.
SELECT A1.Id AS Actor1Id, A1.Name AS Actor1, A2.Id As Actor2Id, A2.Name AS Actor2, COUNT(*) AS MovieCount
FROM Foundation.Movie_Actors MA1
JOIN Foundation.Movie_Actors MA2 ON MA1.MovieId = MA2.MovieId AND MA1.ActorId < MA2.ActorId
JOIN Foundation.Actors A1 ON MA1.ActorId = A1.Id
JOIN Foundation.Actors A2 ON MA2.ActorId = A2.Id
GROUP BY A1.Id, A1.Name, A2.Id, A2.Name
HAVING COUNT(*) >= 2;

--Write a query to get the youngest actor.
SELECT TOP 1 A.Id, A.Name AS ActorName, A.DateOfBirth
FROM Foundation.Actors A
ORDER BY A.DateOfBirth DESC

--Write a query to get the actors who have never worked together.
SELECT A1.Id AS Actor1Id, A1.Name AS Actor1Name, 
       A2.Id AS Actor2Id, A2.Name AS Actor2Name
FROM Foundation.Actors A1
JOIN Foundation.Actors A2 ON A1.Id < A2.Id
WHERE NOT EXISTS (
    SELECT 1 
    FROM Foundation.Movie_Actors MA1
    JOIN Foundation.Movie_Actors MA2 ON MA1.MovieId = MA2.MovieId
    WHERE MA1.ActorId = A1.Id 
      AND MA2.ActorId = A2.Id
);


--Write a query to get the number of movies in each language.
SELECT Language, COUNT(*) AS MovieCount
FROM Foundation.Movies
GROUP BY Language;

--Write a query to get me the total profit of all the movies in each language separately.
SELECT Language,  SUM(CAST(Profit AS BIGINT)) AS TotalProfit
FROM Foundation.Movies
GROUP BY Language;

--Write a query to get the total profit of movies which have actor X in each language.
SELECT M.Language,  SUM(CAST(M.Profit AS BIGINT)) AS TotalProfit
FROM Foundation.Movies M
JOIN Foundation.Movie_Actors MA ON M.Id = MA.MovieId
JOIN Foundation.Actors A ON MA.ActorId = A.Id
WHERE A.Name = 'Ranbir Kapoor'
GROUP BY M.Language;

--Write a query to get the Total profit by year of release and language
SELECT YEAR(YearOfRelease) AS Year, Language,  SUM(CAST(Profit AS BIGINT)) AS TotalProfit
FROM Foundation.Movies
GROUP BY YEAR(YearOfRelease), Language;

--Write a query to get number of movies in each language produced by each producer
SELECT P.Id, P.Name AS ProducerName, M.Language, COUNT(*) AS MovieCount
FROM Foundation.Movies M
JOIN Foundation.Producers P ON M.ProducerID = P.Id
GROUP BY P.Id, P.Name, M.Language;


-- Stored Procedure to Insert a Movie
CREATE PROCEDURE spAddMovie
    @Name NVARCHAR(100),
    @YearOfRelease INT,
    @Plot NVARCHAR(500),
    @Poster NVARCHAR(500),
    @ProducerId INT,
    @ActorIds NVARCHAR(MAX),
    @Language VARCHAR(50),
    @Profit INT
AS
BEGIN
	INSERT INTO Foundation.Movies(Name, YearOfRelease, Plot, Poster, ProducerId, Language, Profit, CreatedAt, UpdatedAt)
    VALUES (@Name, @YearOfRelease, @Plot, @Poster, @ProducerId, @Language, @Profit, GETDATE(), GETDATE());

	DECLARE @MovieId INT = SCOPE_IDENTITY();

	INSERT INTO Foundation.Movie_Actors (MovieId, ActorId)
    SELECT @MovieId, CAST(value AS INT) FROM STRING_SPLIT(@ActorIds, ',');
END;


-- Stored Procedure to Delete a Movie
CREATE PROCEDURE spDeleteMovie
    @MovieId INT
AS
BEGIN
    DELETE FROM Foundation.Movie_Actors WHERE MovieId = @MovieId;
    DELETE FROM Foundation.Movies WHERE Id = @MovieId;
END;


-- Delete Producer
CREATE PROCEDURE spDeleteProducer
    @ProducerId INT
AS
BEGIN
    DELETE MA FROM Foundation.Movie_Actors MA 
	JOIN Foundation.Movies M ON MA.MovieId = M.Id
    WHERE ProducerId = @ProducerId;

    DELETE FROM Foundation.Movies WHERE ProducerId = @ProducerId;
    DELETE FROM Foundation.Producers WHERE Id = @ProducerId;
END;

-- Delete an Actor
CREATE PROCEDURE spDeleteActor
    @ActorId INT
AS
BEGIN
    DELETE FROM Foundation.Movie_Actors WHERE ActorId = @ActorId;
    DELETE FROM Foundation.Actors WHERE Id = @ActorId;
END;



EXEC spAddMovie 
    @Name = 'ABCD2',
    @YearOfRelease = 2015,
    @Plot = 'Hindi Movie',
    @Poster = 'ABCD_poster.jpg',
    @ProducerId = 1,
    @ActorIds = '1,4',
    @Language = 'Hindi',
    @Profit = 1000;

EXEC spDeleteMovie @MovieId = 13;

EXEC spDeleteProducer @ProducerId = 1;

EXEC spDeleteActor @ActorId = 101;

SELECT * FROM Foundation.Movies
SELECT * FROM Foundation.Actors
SELECT * FROM Foundation.Movie_Actors
SELECT * FROM Foundation.Producers
