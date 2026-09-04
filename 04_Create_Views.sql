CREATE VIEW Theatre_Info AS
SELECT
    Theatre_ID,
    Name_of_Theatre,
    No_of_Screens
FROM Theatre
WHERE No_of_Screens = 1;


CREATE VIEW Screen_Info AS
SELECT
    Screen_ID,
    Gold_Seats,
    No_of_Seats_Silver
FROM Screen
WHERE Gold_Seats BETWEEN 80 AND 100;


CREATE VIEW Show_Info AS
SELECT
    Show_ID,
    Movie_Time,
    Show_Date,
    Class_Cost_Gold,
    Class_Cost_Silver,
    Screen_ID
FROM Show
WHERE Screen_ID = '001';


CREATE VIEW Booking_Info AS
SELECT
    Booking_ID,
    No_of_Tickets,
    Total_Cost,
    Name_on_card,
    User_ID,
    Show_ID
FROM Booking
WHERE Total_Cost < 70;


CREATE VIEW Employee_Info AS
SELECT
    Employee_ID,
    First_Name,
    Last_Name,
    Email_ID,
    Role,
    Salary
FROM Employee
WHERE Salary > 5000;


CREATE VIEW Riyadh_Theatres AS
SELECT *
FROM Theatre
WHERE Area LIKE '%Riyadh%';
