SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Weekly_schedule;
DROP TABLE IF EXISTS Year;
DROP TABLE IF EXISTS Weekday;
DROP TABLE IF EXISTS Route;
DROP TABLE IF EXISTS Airport;
DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS Reservations;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Passenger;
DROP TABLE IF EXISTS Contact;
DROP TABLE IF EXISTS Reserved_on;

DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addContact;
DROP PROCEDURE IF EXISTS addPayment;
DROP PROCEDURE IF EXISTS createPassenger;

DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;
DROP FUNCTION IF EXISTS generateTicketNumber;

DROP VIEW IF EXISTS allFlights;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Weekly_schedule (
       id INT AUTO_INCREMENT,
       route INT NOT NULL,
       day VARCHAR(10),
       ToD TIME,
       CONSTRAINT pk_ws PRIMARY KEY(id));

CREATE TABLE Year (
       year INT NOT NULL,
       profit_factor DOUBLE,
       CONSTRAINT pk_year PRIMARY KEY(year));

CREATE TABLE Weekday (
       year INT,
       wd VARCHAR(10) NOT NULL,
       weekday_factor DOUBLE,
       CONSTRAINT pk_day PRIMARY KEY(wd));

CREATE TABLE Route (
       id INT AUTO_INCREMENT,
       arrival VARCHAR(3),
       departure VARCHAR(3),
       year INT,
       routeprice DOUBLE,
       CONSTRAINT pk_route PRIMARY KEY(id));

CREATE TABLE Airport (
       airport_code VARCHAR(3) NOT NULL,
       name VARCHAR(30),
       city VARCHAR(30),
       country VARCHAR(30),
       CONSTRAINT pk_airport PRIMARY KEY(airport_code));

CREATE TABLE Flight (
       flight_number INT DEFAULT (RAND()*1000000000) UNIQUE,
       weekly_flight INT,
       week INT,
       CONSTRAINT pk_flight PRIMARY KEY(flight_number));

CREATE TABLE Reservations (
       reservation_number INT DEFAULT (RAND()*1000000000) UNIQUE,
       flight INT,
       seats INT,
       CONSTRAINT pk_reservation PRIMARY KEY(reservation_number));

CREATE TABLE Booking (
       reservation INT NOT NULL,
       price INT,
       paid_by INT,
       contact INT,
       CONSTRAINT pk_booking PRIMARY KEY(reservation));

CREATE TABLE Payment (
       id INT AUTO_INCREMENT,
       cardholder VARCHAR(40),
       cardnumber BIGINT,
       CONSTRAINT pk_payment PRIMARY KEY(id));

CREATE TABLE Ticket (
       ticket_number INT DEFAULT (RAND()*1000000000),
       passenger INT,
       booking INT,
       CONSTRAINT pk_ticket PRIMARY KEY(ticket_number));

CREATE TABLE Passenger (
       passport_number INT NOT NULL,
       name VARCHAR(30),
       CONSTRAINT pk_passenger PRIMARY KEY(passport_number));

CREATE TABLE Contact (
       passenger INT NOT NULL,
       email VARCHAR(30),
       phone_number BIGINT,
       CONSTRAINT pk_contact PRIMARY KEY(passenger));

CREATE TABLE Reserved_on (
       reservation_number INT,
       passport_number INT,
       CONSTRAINT pk_reserved_on PRIMARY KEY(reservation_number, passport_number));

ALTER TABLE Weekly_schedule ADD CONSTRAINT fk_ws_route FOREIGN KEY(route) REFERENCES Route(id);

ALTER TABLE Weekly_schedule ADD CONSTRAINT fk_ws_day FOREIGN KEY(day) REFERENCES Weekday(wd);

ALTER TABLE Weekday ADD CONSTRAINT fk_wd_year FOREIGN KEY(year) REFERENCES Year(year);

ALTER TABLE Route ADD CONSTRAINT fk_route_to_airport FOREIGN KEY(arrival) REFERENCES Airport(airport_code);

ALTER TABLE Route ADD CONSTRAINT fk_route_from_airport FOREIGN KEY(departure) REFERENCES Airport(airport_code);

ALTER TABLE Route ADD CONSTRAINT fk_route_year FOREIGN KEY(year) REFERENCES Year(year);

ALTER TABLE Flight ADD CONSTRAINT fk_flight_ws FOREIGN KEY(weekly_flight) REFERENCES Weekly_schedule(id);

ALTER TABLE Reservations ADD CONSTRAINT fk_reservations_flight FOREIGN KEY(flight) REFERENCES Flight(flight_number);

ALTER TABLE Booking ADD CONSTRAINT fk_booking_reservation FOREIGN KEY(reservation) REFERENCES Reservations(reservation_number);

ALTER TABLE Booking ADD CONSTRAINT fk_booking_payment FOREIGN KEY(paid_by) REFERENCES Payment(id);

ALTER TABLE Booking ADD CONSTRAINT fk_booking_contact FOREIGN KEY(contact) REFERENCES Contact(passenger);

ALTER TABLE Ticket ADD CONSTRAINT fk_ticket_booking FOREIGN KEY(booking) REFERENCES Booking(reservation);

ALTER TABLE Ticket ADD CONSTRAINT fk_ticket_passenger FOREIGN KEY(passenger) REFERENCES Passenger(passport_number);

ALTER TABLE Contact ADD CONSTRAINT fk_contact_passenger FOREIGN KEY(passenger) REFERENCES Passenger(passport_number);

ALTER TABLE Reserved_on ADD CONSTRAINT fk_reserved_on_passenger FOREIGN KEY(passport_number) REFERENCES Passenger(passport_number);

ALTER TABLE Reserved_on ADD CONSTRAINT fk_reserved_on_reservations FOREIGN KEY(reservation_number) REFERENCES Reservations(reservation_number);

ALTER TABLE Route ADD UNIQUE unique_index(arrival, departure, year, routeprice);

ALTER TABLE Weekly_schedule ADD UNIQUE unique_index(route, day, ToD);

DELIMITER $$

CREATE PROCEDURE addYear(IN year INT, IN factor DOUBLE)
       BEGIN
       INSERT INTO Year VALUES(year, factor);
       END $$

CREATE PROCEDURE addDay(IN year INT, IN day VARCHAR(10), IN factor DOUBLE)
       BEGIN
       INSERT INTO Weekday VALUES(year, day, factor);
       END $$

CREATE PROCEDURE addDestination(IN airport_code VARCHAR(3), IN name VARCHAR(30), IN country VARCHAR(30))
       BEGIN
       INSERT INTO Airport(airport_code, name, country) VALUES(airport_code, name, country);
       END $$

CREATE PROCEDURE addRoute(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INT, IN routeprice DOUBLE)
       BEGIN
       INSERT INTO Route(arrival, departure, year, routeprice) VALUES(arrival_airport_code, departure_airport_code, year, routeprice);
       END $$

CREATE PROCEDURE addFlight(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INT, IN day VARCHAR(10), IN departure_time TIME)
       BEGIN
       DECLARE route_id INT;
       SELECT id INTO route_id FROM Route WHERE Route.arrival = arrival_airport_code AND Route.departure = departure_airport_code AND Route.year = year;
       INSERT INTO Weekly_schedule(route, day, ToD) VALUES(route_id, day, departure_time);
       END $$

CREATE FUNCTION calculateFreeSeats(flightnumber INT) RETURNS INT DETERMINISTIC
       BEGIN
       DECLARE reserved_seats INT;
       SELECT COUNT(Ticket.ticket_number) INTO reserved_seats FROM Ticket, Booking, Reservations WHERE Reservations.flight = flightnumber AND Booking.reservation = Reservations.reservation_number AND Ticket.booking = Booking.reservation;
       IF IFNULL(reserved_seats, false) THEN
      	   RETURN 40 - reserved_seats;
       ELSE
           RETURN 40;
       END IF;
       END $$

/* THIS MAKES TICKET NUMBER UNIQUE AND RANDOM */
CREATE FUNCTION generateTicketNumber() RETURNS INT DETERMINISTIC
       BEGIN
       DECLARE ticket INT;
       DECLARE ticket_number INT DEFAULT (RAND()*1000000000);
       SELECT Ticket.ticket_number INTO ticket FROM Ticket WHERE Ticket.ticket_number = ticket_number;
       IF IFNULL(ticket, false) THEN
         SET ticket_number = (RAND()*1000000000);
         SELECT Ticket.ticket_number INTO ticket FROM Ticket WHERE Ticket.ticket_number = ticket_number;
       END IF;
       RETURN ticket_number;
       END $$

CREATE FUNCTION calculatePrice(flightnumber INT) RETURNS DOUBLE DETERMINISTIC
       BEGIN
       DECLARE routeprice DOUBLE;
       DECLARE weekday_factor DOUBLE;
       DECLARE profit_factor DOUBLE;
       DECLARE booked_passengers INT;
       SELECT Route.routeprice INTO routeprice FROM Flight, Route, Weekly_schedule WHERE Weekly_schedule.id = Flight.weekly_flight AND Flight.flight_number = flightnumber AND Route.id = Weekly_schedule.route;
       SELECT Weekday.weekday_factor INTO weekday_factor FROM Flight, Weekday, Weekly_schedule WHERE Flight.flight_number = flightnumber AND Weekly_schedule.id = Flight.weekly_flight AND Weekday.wd = Weekly_schedule.day;
       SELECT Year.profit_factor INTO profit_factor FROM Flight, Year, Weekly_schedule, Route WHERE Flight.flight_number = flightnumber AND Weekly_schedule.id = Flight.weekly_flight AND Route.id = Weekly_schedule.route AND Year.year = Route.year;
       SELECT (40 - calculateFreeSeats(flightnumber)) INTO booked_passengers;
       RETURN (routeprice*weekday_factor*((booked_passengers + 1)/40)*profit_factor);
       END $$

CREATE TRIGGER ticket BEFORE INSERT ON Ticket FOR EACH ROW
       BEGIN
         SET new.ticket_number = generateTicketNumber();
       END $$

CREATE TRIGGER flight AFTER INSERT ON Weekly_schedule FOR EACH ROW
       BEGIN
              DECLARE i INT DEFAULT 1;
	      DECLARE weekly_flight INT;
       	      SET weekly_flight = NEW.id;
       	      WHILE i <= 52 DO
       	      	    INSERT INTO Flight(weekly_flight, week) VALUES(weekly_flight, i);
       	      SET i = i + 1;
       	      END WHILE;
	END $$

CREATE TRIGGER booking AFTER INSERT ON Booking FOR EACH ROW
       BEGIN
       INSERT INTO Ticket(passenger, booking) SELECT Passenger.passport_number, New.reservation FROM Passenger, Reservations, Reserved_on WHERE Reservations.reservation_number = NEW.reservation AND Reserved_on.reservation_number = Reservations.reservation_number AND Passenger.passport_number = Reserved_on.passport_number;
       END $$

CREATE PROCEDURE addReservation(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INT, IN week INT, IN day VARCHAR(10), IN time TIME, IN number_of_passengers INT, OUT output_reservation_number INT)
        BEGIN
		DECLARE flight_number INT;
		DECLARE free_seats INT;
		SELECT Flight.flight_number INTO flight_number FROM Flight, Weekly_schedule, Route WHERE Route.arrival = arrival_airport_code AND Route.departure = departure_airport_code AND Route.year = year AND Weekly_schedule.day = day AND Weekly_schedule.ToD = time AND Flight.week = week AND Flight.weekly_flight = Weekly_schedule.id;
		IF IFNULL(flight_number, false) THEN
		   SET free_seats = calculateFreeSeats(flight_number);
		   IF free_seats >= number_of_passengers THEN
   		      SET output_reservation_number = (RAND()*1000000000);
		      INSERT INTO Reservations VALUES(output_reservation_number, flight_number, number_of_passengers);
		   ELSE
			SELECT "There are not enough seats available on the chosen flight";
		   END IF;
		ELSE
			SELECT "There exist no flight for the given route, date and time" AS "MESSAGE";
		END IF;
	END $$

CREATE PROCEDURE createPassenger(IN passport_number INT, IN name VARCHAR(30))
       BEGIN
		INSERT IGNORE INTO Passenger VALUES(passport_number, name);
       END $$

CREATE PROCEDURE addPassenger(IN reservation_number INT, IN passport_number INT, IN name VARCHAR(30))
       BEGIN
		DECLARE res_number INT;
		DECLARE seats INT;
		DECLARE res_seats INT;
		DECLARE passenger INT;
		SELECT Reservations.reservation_number INTO res_number FROM Reservations WHERE Reservations.reservation_number = reservation_number;
		IF reservation_number NOT IN (SELECT Booking.reservation FROM Booking) THEN
		   IF IFNULL(res_number, false) THEN
		      CALL createPassenger(passport_number, name);
		      SELECT COUNT(passport_number) INTO seats FROM Passenger, Reserved_on WHERE Passenger.passport_number = Reserved_on.passport_number AND Reserved_on.reservation_number = reservation_number;
		      SELECT Reservations.seats INTO res_seats FROM Reservations WHERE Reservations.reservation_number = reservation_number;
		      INSERT INTO Reserved_on(reservation_number, passport_number) VALUES(reservation_number, passport_number);
		   ELSE
		      SELECT "The given reservation number does not exist" AS "MESSAGE";
		   END IF;
		ELSE
		   SELECT "The booking has already been payed and no futher passengers can be added" AS "MESSAGE";
		END IF;
       END $$

CREATE PROCEDURE addContact(IN reservation_number INT, IN passport_number INT, IN email VARCHAR(20), IN phone BIGINT)
       BEGIN
		DECLARE res_number INT;
		DECLARE passenger INT;
		SELECT Reservations.reservation_number INTO res_number FROM Reservations WHERE Reservations.reservation_number = reservation_number;
		SELECT Passenger.passport_number INTO passenger FROM Passenger WHERE Passenger.passport_number = passport_number;
		IF IFNULL(res_number, false) THEN
		   IF IFNULL(passenger, false) THEN
		      INSERT INTO Contact VALUES(passport_number, email, phone);
		   ELSE
			SELECT "The person is not a passenger of the reservation" AS "MESSAGE";
		   END IF;
		ELSE
			SELECT "The given reservation number does not exist" AS "MESSAGE";
		END IF;

       END $$

CREATE PROCEDURE addPayment(IN reservation_number INT, IN cardholder_name VARCHAR(30), IN credit_card_number BIGINT)
       BEGIN
		DECLARE contact INT;
		DECLARE flight_number INT;
		DECLARE free_seats INT;
		DECLARE seats INT;
		DECLARE price DOUBLE;
		DECLARE reservation INT;
		SELECT Reservations.flight INTO flight_number FROM Reservations WHERE Reservations.reservation_number = reservation_number;
    SELECT COUNT(Passenger.passport_number) INTO seats FROM Passenger, Reserved_on WHERE Passenger.passport_number = Reserved_on.passport_number AND Reserved_on.reservation_number = reservation_number;
    SET free_seats = calculateFreeSeats(flight_number);
		SELECT Contact.passenger INTO contact FROM Contact, Passenger, Reserved_on Where Reserved_on.reservation_number = reservation_number AND Passenger.passport_number = Reserved_on.passport_number AND Contact.passenger = Passenger.passport_number;
		IF reservation_number IN (SELECT Reservations.reservation_number FROM Reservations) THEN
		   IF IFNULL(contact, false) THEN
		      IF free_seats >= seats THEN
		      	 SET price = calculatePrice(flight_number);
		      	 INSERT INTO Payment(cardholder, cardnumber) VALUES(cardholder_name, credit_card_number);
		      	 INSERT INTO Booking VALUES(reservation_number, price, LAST_INSERT_ID(), contact);
		      ELSE
      			 SELECT "There are not enough seats available on the flight anymore, deleting reservation" AS "MESSAGE";
      			 DELETE FROM Contact WHERE Contact.passenger IN (SELECT Passenger.passport_number FROM Passenger, Reserved_on WHERE Passenger.passport_number = Reserved_on.passport_number AND Reserved_on.reservation_number = reservation_number);
      			 DELETE FROM Reserved_on WHERE Reserved_on.reservation_number = reservation_number;
      			 DELETE FROM Reservations WHERE Reservations.reservation_number = reservation_number;
          END IF;
		   ELSE
		      SELECT "The reservation has no contact yet" AS "MESSAGE";
		   END IF;
		ELSE
	        SELECT "The given reservation number does not exist" AS "MESSAGE";
		END IF;
       END $$


DELIMITER ;

CREATE VIEW allFlights AS
       SELECT a1.name AS "departure_city_name", a2.name AS "destination_city_name", Weekly_schedule.ToD AS "departure_time", Weekly_schedule.day AS "departure_day", Flight.week AS "departure_week", Route.year AS "departure_year", calculateFreeSeats(Flight.flight_number) AS "nr_of_free_seats", calculatePrice(Flight.flight_number) AS "current_price_per_seat" FROM Flight, Weekly_schedule, Route JOIN Airport a1 ON a1.airport_code = Route.departure JOIN Airport a2 ON a2.airport_code = Route.arrival WHERE Weekly_schedule.id = Flight.weekly_flight AND Route.id = Weekly_schedule.route GROUP BY Flight.flight_number;

/*SOURCE /home/carli625/Documents/TDDD37/database_technology/lab4/test3.sql;
SOURCE /home/carli625/Documents/TDDD37/database_technology/lab4/test6.sql;

SELECT * FROM allFlights;*/
