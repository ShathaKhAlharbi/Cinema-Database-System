-- ============================================================
-- Cinema Database System
-- 03_DML_Queries.sql
-- DML, DQL, ALTER TABLE, Joins, Subqueries and Aggregations
-- ============================================================


-- ============================================================
-- 1. BASIC SELECT QUERIES
-- ============================================================

SELECT *
FROM Area;


SELECT *
FROM Web_User;


SELECT *
FROM Theatre;


SELECT *
FROM Screen;


SELECT *
FROM Movie;


SELECT *
FROM Show;


SELECT *
FROM Booking;


SELECT *
FROM Ticket;


SELECT *
FROM Discount;


SELECT *
FROM Employee;


SELECT *
FROM Payment;


-- ============================================================
-- 2. ALTER TABLE
-- ============================================================

-- Rename the Gold seats column
ALTER TABLE Screen
RENAME COLUMN No_of_Seats_Gold TO Gold_Seats;


-- Rename the Web User email column
ALTER TABLE Web_User
RENAME COLUMN Email_ID TO User_Email;


-- Rename the Movie language column
ALTER TABLE Movie
RENAME COLUMN Language TO Original_Language;


-- Add release year to Movie
ALTER TABLE Movie
ADD Release_Year INT;


-- Add Employee_ID to Booking
ALTER TABLE Booking
ADD (
    Employee_ID INT,
    CONSTRAINT FK_Employee_Booking
    FOREIGN KEY (Employee_ID)
    REFERENCES Employee(Employee_ID)
);


-- ============================================================
-- 3. SCREEN QUERIES
-- ============================================================

-- Count the number of screens in each theatre
SELECT
    Theatre_ID,
    COUNT(Screen_ID) AS Num_Screens
FROM Screen
GROUP BY Theatre_ID;


-- Display screens ordered by Gold seat capacity
SELECT *
FROM Screen
ORDER BY Gold_Seats DESC;


-- Find screens with more than 150 Silver seats
SELECT *
FROM Screen
WHERE No_of_Seats_Silver > 150;


-- Calculate the average number of Gold seats
SELECT
    AVG(Gold_Seats) AS Avg_Gold_Seats
FROM Screen;


-- Calculate total seats for each theatre
SELECT
    T.Theatre_ID,
    T.Name_of_Theatre,
    SUM(S.Gold_Seats + S.No_of_Seats_Silver) AS Total_Seats
FROM Theatre T
INNER JOIN Screen S
    ON T.Theatre_ID = S.Theatre_ID
GROUP BY
    T.Theatre_ID,
    T.Name_of_Theatre;


-- ============================================================
-- 4. THEATRE QUERIES
-- ============================================================

-- Join theatres with their screens
SELECT
    T.Theatre_ID,
    T.Name_of_Theatre,
    T.No_of_Screens,
    S.Screen_ID,
    S.Gold_Seats,
    S.No_of_Seats_Silver
FROM Theatre T
INNER JOIN Screen S
    ON T.Theatre_ID = S.Theatre_ID;


-- Full join between Theatre and Screen
SELECT *
FROM Theatre
FULL JOIN Screen
    ON Theatre.Theatre_ID = Screen.Theatre_ID;


-- Find theatres that have a screen with more than 100 Gold seats
SELECT *
FROM Theatre
WHERE Theatre_ID IN (
    SELECT Theatre_ID
    FROM Screen
    WHERE Gold_Seats > 100
);


-- Find theatres whose name starts with "Muvic"
SELECT *
FROM Theatre
WHERE Name_of_Theatre LIKE 'Muvic%';


-- ============================================================
-- 5. WEB USER QUERIES
-- ============================================================

-- Find users whose first name starts with A
SELECT *
FROM Web_User
WHERE First_Name LIKE 'A%';


-- Update Ahmed's age
UPDATE Web_User
SET Age = 29
WHERE Web_User_ID = 'SA001';


-- Display users with their email addresses
SELECT
    Web_User_ID,
    First_Name,
    Last_Name,
    User_Email
FROM Web_User;


-- ============================================================
-- 6. EMPLOYEE QUERIES
-- ============================================================

-- Display employees ordered by salary
SELECT *
FROM Employee
ORDER BY Salary DESC;


-- Delete employee with Employee_ID 555
DELETE FROM Employee
WHERE Employee_ID = 555;


-- Calculate average salary for each role
SELECT
    Role,
    AVG(Salary) AS AvgSalary
FROM Employee
GROUP BY Role;


-- Find roles with an average salary greater than 6000
SELECT
    Role,
    AVG(Salary) AS AvgSalary
FROM Employee
GROUP BY Role
HAVING AVG(Salary) > 6000;


-- ============================================================
-- 7. PAYMENT QUERIES
-- ============================================================

-- Find payments between 100 and 200
SELECT *
FROM Payment
WHERE Amount BETWEEN 100 AND 200;


-- ============================================================
-- 8. MOVIE QUERIES
-- ============================================================

-- Display movies ordered alphabetically
SELECT *
FROM Movie
ORDER BY Name;


-- Find Sci-Fi movies
SELECT *
FROM Movie
WHERE Genre LIKE '%Sci-fi%';


-- Display all movies with their release years
SELECT *
FROM Movie;


-- Update release years
UPDATE Movie
SET Release_Year =
    CASE
        WHEN Movie_ID = 'M001' THEN 2010
        WHEN Movie_ID = 'M002' THEN 1997
        WHEN Movie_ID = 'M003' THEN 2014
        WHEN Movie_ID = 'M004' THEN 2021
        WHEN Movie_ID = 'M005' THEN 2006
    END;


-- Display movies after updating release years
SELECT *
FROM Movie;


-- Update the genre of The Game
UPDATE Movie
SET Genre = 'Drama/Suspense'
WHERE Movie_ID = 'M002';


-- Display Movie ID and Genre
SELECT
    Movie_ID,
    Genre
FROM Movie;


-- Identify whether each movie is Sci-Fi
SELECT
    Name,
    CASE
        WHEN Genre LIKE '%Sci-fi%' THEN 'Yes'
        ELSE 'No'
    END AS Is_Sci_Fi
FROM Movie
ORDER BY Name DESC;


-- ============================================================
-- 9. TICKET QUERIES
-- ============================================================

-- Update ticket prices for movie M003
UPDATE Ticket
SET Price = 80
WHERE Booking_ID IN (
    SELECT Booking_ID
    FROM Booking
    WHERE Show_ID IN (
        SELECT Show_ID
        FROM Show
        WHERE Movie_ID = 'M003'
    )
);


-- Display tickets from T001 to T006
SELECT *
FROM Ticket
WHERE Ticket_ID BETWEEN 'T001' AND 'T006';


-- Calculate total and maximum ticket price for each class
SELECT
    Class,
    SUM(Price) AS Total_Price,
    MAX(Price) AS Maximum_Price
FROM Ticket
GROUP BY Class;


-- ============================================================
-- 10. MOVIE AND TICKET JOIN
-- ============================================================

-- Display tickets with their corresponding Movie ID
SELECT
    Ticket.*,
    Movie.Movie_ID
FROM Ticket
INNER JOIN Booking
    ON Ticket.Booking_ID = Booking.Booking_ID
INNER JOIN Show
    ON Booking.Show_ID = Show.Show_ID
INNER JOIN Movie
    ON Show.Movie_ID = Movie.Movie_ID;


-- Count total tickets sold for each movie
SELECT
    Movie.Name,
    COUNT(Ticket.Ticket_ID) AS Total_Tickets
FROM Movie
LEFT JOIN Show
    ON Movie.Movie_ID = Show.Movie_ID
LEFT JOIN Booking
    ON Show.Show_ID = Booking.Show_ID
LEFT JOIN Ticket
    ON Booking.Booking_ID = Ticket.Booking_ID
GROUP BY Movie.Name
ORDER BY Movie.Name;


-- Calculate average ticket price for movies
-- with more than two tickets/bookings
SELECT
    Movie.Movie_ID,
    Movie.Genre,
    AVG(Ticket.Price) AS Avg_Price
FROM Movie
LEFT JOIN Show
    ON Movie.Movie_ID = Show.Movie_ID
LEFT JOIN Booking
    ON Show.Show_ID = Booking.Show_ID
LEFT JOIN Ticket
    ON Booking.Booking_ID = Ticket.Booking_ID
GROUP BY
    Movie.Movie_ID,
    Movie.Genre
HAVING COUNT(Ticket.Booking_ID) > 2;


-- ============================================================
-- 11. BOOKING AND USER QUERIES
-- ============================================================

-- Display Ahmed's booking cost
SELECT
    u.First_Name,
    u.Last_Name,
    b.Total_Cost
FROM Web_User u
INNER JOIN Booking b
    ON u.Web_User_ID = b.User_ID
WHERE u.Web_User_ID = 'SA001';


-- Display all bookings with user names
SELECT
    b.Booking_ID,
    u.First_Name,
    u.Last_Name
FROM Booking b
INNER JOIN Web_User u
    ON b.User_ID = u.Web_User_ID;


-- Find a booking using card number
SELECT *
FROM Booking
WHERE Card_Number = '1234567890123456';


-- Find the booking for Show SHW003
SELECT
    b.Booking_ID,
    u.First_Name,
    u.Last_Name
FROM Booking b
INNER JOIN Web_User u
    ON b.User_ID = u.Web_User_ID
WHERE b.Show_ID = 'SHW003';


-- Update the number of tickets for booking BK123
UPDATE Booking
SET No_of_Tickets = 3
WHERE Booking_ID = 'BK123';


-- Display booking category
SELECT
    Booking_ID,
    CASE
        WHEN No_of_Tickets > 1 THEN 'Group'
        ELSE 'Individual'
    END AS Booking_Category
FROM Booking;


-- Display complete booking and user information
SELECT
    b.Booking_ID,
    u.Web_User_ID,
    b.Card_Number,
    u.First_Name,
    u.Last_Name,
    u.User_Email,
    b.Show_ID,
    b.No_of_Tickets,
    b.Total_Cost
FROM Booking b
INNER JOIN Web_User u
    ON b.User_ID = u.Web_User_ID;


-- Display bookings made by users older than 18
SELECT
    b.*
FROM Booking b
INNER JOIN Web_User u
    ON b.User_ID = u.Web_User_ID
WHERE u.Age > 18;


-- ============================================================
-- 12. SHOW AND BOOKING QUERIES
-- ============================================================

-- Display total purchases for each show
SELECT
    s.Show_ID,
    s.Show_Date,
    SUM(b.No_of_Tickets) AS Total_Purchases
FROM Show s
INNER JOIN Booking b
    ON s.Show_ID = b.Show_ID
GROUP BY
    s.Show_ID,
    s.Show_Date;


-- Display bookings for shows on March 17, 2024
SELECT
    b.Booking_ID,
    b.No_of_Tickets,
    b.Total_Cost,
    b.Name_on_card,
    s.Show_ID,
    s.Show_Date
FROM Booking b
INNER JOIN Show s
    ON b.Show_ID = s.Show_ID
WHERE s.Show_Date = TO_DATE(
    '2024-03-17',
    'YYYY-MM-DD'
);


-- Count the total number of shows
SELECT COUNT(*) AS Total_Shows
FROM Show;


-- Display all shows ordered by Show ID
SELECT *
FROM Show
ORDER BY Show_ID;


-- Display shows ordered by date
SELECT *
FROM Show
ORDER BY Show_Date;


-- Find shows where Gold ticket cost is between 20 and 25
SELECT *
FROM Show
WHERE Class_Cost_Gold BETWEEN 20 AND 25;


-- Find all shows taking place on Screen 001
SELECT *
FROM Show
WHERE Screen_ID = '001';


-- ============================================================
-- 13. SHOW ALTERATION
-- ============================================================

-- Rename Show_Time to Movie_Time
ALTER TABLE Show
RENAME COLUMN Show_Time TO Movie_Time;


-- Update the movie time for SHW005
UPDATE Show
SET Movie_Time = TO_TIMESTAMP(
    '2024-04-08 20:00:00',
    'YYYY-MM-DD HH24:MI:SS'
)
WHERE Show_ID = 'SHW005';


-- Display shows with their movies
SELECT
    s.Show_ID,
    s.Movie_Time,
    s.Show_Date,
    m.Movie_ID,
    m.Name,
    m.Original_Language,
    m.Genre
FROM Show s
INNER JOIN Movie m
    ON s.Movie_ID = m.Movie_ID;


-- ============================================================
-- 14. SHOW FILTERING QUERIES
-- ============================================================

-- Display shows with Gold ticket cost between 20 and 25
SELECT *
FROM Show
WHERE Class_Cost_Gold BETWEEN 20 AND 25;


-- Display all shows after updating Movie_Time
SELECT *
FROM Show
ORDER BY Show_Date;


-- ============================================================
-- END OF 03_DML_Queries.sql
-- ============================================================
