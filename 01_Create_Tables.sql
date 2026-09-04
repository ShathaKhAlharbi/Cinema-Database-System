CREATE TABLE Web_User (
    Web_User_ID VARCHAR2(5) PRIMARY KEY,
    First_Name VARCHAR2(15),
    Last_Name VARCHAR2(20),
    Email_ID VARCHAR2(30),
    Age INT,
    Phone_Number VARCHAR2(10) NOT NULL
);

CREATE TABLE Area (
    Area_Name VARCHAR2(30) PRIMARY KEY,
    Location VARCHAR2(100) NOT NULL
);

CREATE TABLE Theatre (
    Theatre_ID VARCHAR2(5) PRIMARY KEY,
    Name_of_Theatre VARCHAR2(30) NOT NULL,
    No_of_Screens INT,
    Area VARCHAR2(30)
);

CREATE TABLE Screen (
    Screen_ID VARCHAR2(5) PRIMARY KEY,
    No_of_Seats_Gold INT NOT NULL,
    No_of_Seats_Silver INT NOT NULL,
    Theatre_ID VARCHAR2(5),
    FOREIGN KEY (Theatre_ID)
        REFERENCES Theatre(Theatre_ID)
        ON DELETE CASCADE
);

CREATE TABLE Movie (
    Movie_ID VARCHAR2(5) PRIMARY KEY,
    Name VARCHAR2(30) NOT NULL,
    Language VARCHAR2(10),
    Genre VARCHAR2(20),
    Target_Audience VARCHAR2(5)
);

CREATE TABLE Show (
    Show_ID VARCHAR2(10) PRIMARY KEY,
    Show_Time TIMESTAMP NOT NULL,
    Show_Date DATE NOT NULL,
    Seats_Remaining_Gold INT NOT NULL
        CHECK (Seats_Remaining_Gold >= 0),
    Seats_Remaining_Silver INT NOT NULL
        CHECK (Seats_Remaining_Silver >= 0),
    Class_Cost_Gold DECIMAL(10,2) NOT NULL,
    Class_Cost_Silver DECIMAL(10,2) NOT NULL,
    Screen_ID VARCHAR2(5) NOT NULL,
    Movie_ID VARCHAR2(5) NOT NULL,

    FOREIGN KEY (Screen_ID)
        REFERENCES Screen(Screen_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Movie_ID)
        REFERENCES Movie(Movie_ID)
        ON DELETE CASCADE
);

CREATE TABLE Booking (
    Booking_ID VARCHAR2(10) PRIMARY KEY,
    No_of_Tickets INT NOT NULL,
    Total_Cost DECIMAL(10,2) NOT NULL,
    Card_Number VARCHAR2(19),
    Name_on_card VARCHAR2(21),
    User_ID VARCHAR2(5),
    Show_ID VARCHAR2(10),

    FOREIGN KEY (User_ID)
        REFERENCES Web_User(Web_User_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Show_ID)
        REFERENCES Show(Show_ID)
        ON DELETE CASCADE
);

CREATE TABLE Ticket (
    Ticket_ID VARCHAR2(20) PRIMARY KEY,
    Booking_ID VARCHAR2(10),
    Class VARCHAR2(3) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (Booking_ID)
        REFERENCES Booking(Booking_ID)
        ON DELETE CASCADE
);

CREATE TABLE Discount (
    Discount_ID VARCHAR2(5) PRIMARY KEY,
    Discount_Percentage INT NOT NULL
        CHECK (Discount_Percentage >= 0
               AND Discount_Percentage <= 100),
    Movie_ID VARCHAR2(5) NOT NULL,

    FOREIGN KEY (Movie_ID)
        REFERENCES Movie(Movie_ID)
        ON DELETE CASCADE
);

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR2(50),
    Last_Name VARCHAR2(50),
    Email_ID VARCHAR2(100),
    Phone_Number VARCHAR2(15),
    Role VARCHAR2(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY,
    Booking_ID VARCHAR2(10),
    Payment_Method VARCHAR2(50),
    Amount DECIMAL(10,2),
    Payment_Date DATE,

    FOREIGN KEY (Booking_ID)
        REFERENCES Booking(Booking_ID)
);
