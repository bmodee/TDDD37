/*
Lab 1 report <Student_names and liu_id>
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS jbitem2 CASCADE;
DROP TABLE IF EXISTS jbdebit CASCADE;

DROP VIEW IF EXISTS Cheapitems CASCADE;
DROP VIEW IF EXISTS Debitcost CASCADE;
DROP VIEW IF EXISTS Debitcost2 CASCADE;
DROP VIEW IF EXISTS jbsale_supply CASCADE;

/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE ../lab1/company_schema.sql;
SOURCE ../lab1/company_data.sql;

SET FOREIGN_KEY_CHECKS = 1;

/*
Lab 1 report Björn Modée bjomo323  &  Carl Lidman carli625
*/


/*---1---*/

SELECT * FROM jbemployee;
/*
+------+--------------------+--------+---------+-----------+-----------+
| id   | name               | salary | manager | birthyear | startyear |
+------+--------------------+--------+---------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |
+------+--------------------+--------+---------+-----------+-----------+
*/

/*---2---*/

SELECT name FROM jbdept ORDER BY name;
/*
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
| Women's          |
| Women's          |
+------------------+
*/




/*---3---*/
SELECT * FROM jbparts WHERE qoh=0;

/*
+----+-------------------+-------+--------+------+
| id | name              | color | weight | qoh  |
+----+-------------------+-------+--------+------+
| 11 | card reader       | gray  |    327 |    0 |
| 12 | card punch        | gray  |    427 |    0 |
| 13 | paper tape reader | black |    107 |    0 |
| 14 | paper tape punch  | black |    147 |    0 |
+----+-------------------+-------+--------+------+
*/



/*---4---*/

SELECT name FROM jbemployee WHERE salary BETWEEN 9000 AND 10000;

/*
+----------------+
| name           |
+----------------+
| Edwards, Peter |
| Smythe, Carol  |
| Williams, Judy |
| Thomas, Tom    |
+----------------+
*/

/*---5---*/

SELECT name, birthyear, startyear, startyear-birthyear AS Difference FROM jbemployee;


/*
+--------------------+-----------+-----------+------------+
| name               | birthyear | startyear | Difference |
+--------------------+-----------+-----------+------------+
| Ross, Stanley      |      1927 |      1945 |         18 |
| Ross, Stuart       |      1931 |      1932 |          1 |
| Edwards, Peter     |      1928 |      1958 |         30 |
| Thompson, Bob      |      1930 |      1970 |         40 |
| Smythe, Carol      |      1929 |      1967 |         38 |
| Hayes, Evelyn      |      1931 |      1963 |         32 |
| Evans, Michael     |      1952 |      1974 |         22 |
| Raveen, Lemont     |      1950 |      1974 |         24 |
| James, Mary        |      1920 |      1969 |         49 |
| Williams, Judy     |      1935 |      1969 |         34 |
| Thomas, Tom        |      1941 |      1962 |         21 |
| Jones, Tim         |      1940 |      1960 |         20 |
| Bullock, J.D.      |      1920 |      1920 |          0 |
| Collins, Joanne    |      1950 |      1971 |         21 |
| Brunet, Paul C.    |      1938 |      1959 |         21 |
| Schmidt, Herman    |      1936 |      1956 |         20 |
| Iwano, Masahiro    |      1944 |      1970 |         26 |
| Smith, Paul        |      1952 |      1973 |         21 |
| Onstad, Richard    |      1952 |      1971 |         19 |
| Zugnoni, Arthur A. |      1928 |      1949 |         21 |
| Choy, Wanda        |      1947 |      1970 |         23 |
| Wallace, Maggie J. |      1940 |      1959 |         19 |
| Bailey, Chas M.    |      1956 |      1975 |         19 |
| Bono, Sonny        |      1939 |      1963 |         24 |
| Schwarz, Jason B.  |      1944 |      1959 |         15 |
+--------------------+-----------+-----------+------------+
*/

/*---6---*/

SELECT * FROM jbemployee WHERE name like '%son,%';


/*
+----+---------------+--------+---------+-----------+-----------+
| id | name          | salary | manager | birthyear | startyear |
+----+---------------+--------+---------+-----------+-----------+
| 26 | Thompson, Bob |  13000 |     199 |      1930 |      1970 |
+----+---------------+--------+---------+-----------+-----------+
*/

/*---7---*/

SELECT name FROM jbitem WHERE supplier IN (SELECT id FROM jbsupplier WHERE name = 'Fisher-Price');

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
*/

/*---8---*/

SELECT jbitem.name FROM jbitem, jbsupplier WHERE jbitem.supplier=jbsupplier.id AND jbsupplier.name = "Fisher-Price";

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0.00 sec)
*/

/*---9---*/

SELECT name FROM jbcity where id in (SELECT city FROM jbsupplier);

/*
+----------------+
| name           |
+----------------+
| Amherst        |
| Boston         |
| New York       |
| White Plains   |
| Hickville      |
| Atlanta        |
| Madison        |
| Paxton         |
| Dallas         |
| Denver         |
| Salt Lake City |
| Los Angeles    |
| San Diego      |
| San Francisco  |
| Seattle        |
+----------------+
15 rows in set (0.02 sec)
*/


/*---10---*/

SELECT name, color FROM jbparts WHERE weight > (SELECT weight FROM jbparts WHERE name like "card reader");

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)
*/

/*---11---*/

SELECT parts_a.name, parts_a.color FROM jbparts parts_a, jbparts parts_b WHERE parts_a.weight > parts_b.weight AND parts_b.name = "Card reader";

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)
*/

/*---12---*/

SELECT AVG(weight) FROM jbparts WHERE color = "black";

/*
+-------------+
| AVG(weight) |
+-------------+
|    347.2500 |
+-------------+
1 row in set (0.00 sec)
*/

/*---13---*/

SELECT jbsupplier.name, SUM(jbsupply.quan*jbparts.weight) as "Total weight" FROM jbsupplier, jbcity, jbparts,
        jbsupply WHERE jbparts.id = jbsupply.part AND jbsupply.supplier = jbsupplier.id AND jbsupplier.city = jbcity.id
        AND jbcity.state = "Mass" GROUP BY jbsupplier.name;

/*
+--------------+--------------+
| name         | Total weight |
+--------------+--------------+
| DEC          |         3120 |
| Fisher-Price |      1135000 |
+--------------+--------------+
2 rows in set (0.01 sec)
*/


/*---14---*/

CREATE TABLE jbitem2 (id INT, name VARCHAR(20), dept INT NOT NULL, price INT, qoh INT UNSIGNED, supplier INT NOT NULL, CONSTRAINT pk_item PRIMARY KEY(id));
/*Query OK, 0 rows affected (0.06 sec)*/

ALTER TABLE jbitem2 ADD CONSTRAINT fk_item2_dept FOREIGN KEY (dept) REFERENCES jbdept(id);
/*Query OK, 0 rows affected (0.12 sec)
Records: 0  Duplicates: 0  Warnings: 0 */

ALTER TABLE jbitem2 ADD CONSTRAINT fk_item2_supplier FOREIGN KEY (supplier) REFERENCES jbsupplier(id);
/*Query OK, 0 rows affected (0.12 sec)
Records: 0  Duplicates: 0  Warnings: 0*/

INSERT INTO jbitem2 (id, name, dept, price, qoh, supplier) SELECT * FROM jbitem WHERE price < (SELECT AVG(price) FROM jbitem);
/*Query OK, 14 rows affected (0.01 sec)
Records: 14  Duplicates: 0  Warnings: 0*/

/*---15---*/

CREATE VIEW Cheapitems AS SELECT name, price FROM jbitem WHERE price < (SELECT AVG(price) FROM jbitem);
/*Query OK, 0 rows affected (0.04 sec)*/

/*---16---*/

/*A view is a saved select statement which will be updated automatically if the queried tables are updated. there for the view is dynamic.
 A table is static because it only change when we manually update it.*/

/*---17---*/

CREATE VIEW Debitcost AS SELECT jbdebit.id, SUM(jbitem.price*jbsale.quantity) as Price FROM jbdebit, jbitem, jbsale WHERE jbitem.id = jbsale.item AND jbsale.debit = jbdebit.id GROUP BY jbdebit.id;
/*Query OK, 0 rows affected (0.04 sec)*/

/*---18---*/

CREATE VIEW Debitcost2 AS SELECT jbdebit.id, SUM(jbitem.price*jbsale.quantity) AS Price
FROM jbitem
  INNER JOIN jbsale
    ON jbitem.id = jbsale.item
    INNER JOIN jbdebit
      ON jbsale.debit = jbdebit.id
GROUP BY jbdebit.id;

/*
+--------+-------+
| id     | Price |
+--------+-------+
| 100581 |  2050 |
| 100586 | 13446 |
| 100592 |   650 |
| 100593 |   430 |
| 100594 |  3295 |
+--------+-------+
5 rows in set (0.00 sec
*/

/*---19---*/
DELETE FROM jbsale WHERE item IN (SELECT id FROM jbitem WHERE supplier IN (SELECT id FROM jbsupplier WHERE city IN (SELECT id FROM jbcity WHERE name like "Los Angeles")));
    /*Query OK, 1 row affected (0.01 sec)*/
DELETE FROM jbitem WHERE supplier IN (SELECT id FROM jbsupplier WHERE city IN (SELECT id FROM jbcity WHERE name like "Los Angeles"));
    /*Query OK, 2 rows affected (0.01 sec)*/
DELETE FROM jbitem2 WHERE supplier IN (SELECT id FROM jbsupplier WHERE city IN (SELECT id FROM jbcity WHERE name like "Los Angeles"));
    /*Query OK, 1 row affected (0.01 sec)*/
DELETE FROM jbsupplier WHERE city IN (SELECT id FROM jbcity WHERE name like "Los Angeles");
    /*Query OK, 1 row affected (0.01 sec)*/


/*
We deleted the innermost rows at first so the we wouldn't get an error with the foreigm key for tables higher in the hierarchy. We didn't need to delete the debit since we had two sales
with the debit number we needed to delete of which one didn't need to be deleted. Then we could delete rows from there on up in the order jbsale -> jbitem -> jbsupplier.
*/

/*---20---*/

CREATE VIEW jbsale_supply(supplier, item, quantity) AS SELECT jbsupplier.name, jbitem.name, jbsale.quantity FROM jbsupplier, jbitem LEFT JOIN jbsale ON jbsale.item = jbitem.id WHERE jbsupplier.id = jbitem.supplier;

SELECT supplier, SUM(quantity) AS sum FROM jbsale_supply GROUP BY supplier;

/*
+--------------+------+
| supplier     | sum  |
+--------------+------+
| Cannon       |    6 |
| Fisher-Price | NULL |
| Levi-Strauss |    1 |
| Playskool    |    2 |
| White Stag   |    4 |
| Whitman's    |    2 |
+--------------+------+
*/
