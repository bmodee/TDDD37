/*
*  Carl Lidman: carli625
*  Björn Modée: bjomo323
*/

/* PART 3 */

SOURCE ../lab1/lab1.sql;

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS jbmanager CASCADE;
DROP TABLE IF EXISTS jbcustomer CASCADE;
DROP TABLE IF EXISTS jbaccount CASCADE;
DROP TABLE IF EXISTS jbtransaction CASCADE;
DROP TABLE IF EXISTS jbdeposit CASCADE;
DROP TABLE IF EXISTS jbwithdrawal CASCADE;

ALTER TABLE jbemployee DROP FOREIGN KEY fk_emp_mgr;

SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE jbmanager
       (id INT,
       bonus INT DEFAULT 0,
       CONSTRAINT pk_manager PRIMARY KEY(id)) ENGINE=InnoDB;
/*Query OK, 0 rows affected (0.05 sec)*/

/*
Question 3) "Do you have to initialize the bonus attribute to a value? Why?"

We initialize bonus attribute to Zero because otherwise it would be a null
value which is bad since we can't add a bonus to a null value in the bonus
attribute later on.

*/


INSERT INTO jbmanager (id) SELECT id FROM jbemployee WHERE id IN (SELECT manager FROM jbemployee);
/*Query OK, 8 rows affected (0.01 sec)
Records: 8  Duplicates: 0  Warnings: 0*/


INSERT INTO jbmanager (id) SELECT manager FROM jbdept WHERE manager NOT IN (SELECT id FROM jbmanager) GROUP BY manager;
/*Query OK, 4 rows affected (0.00 sec)
Records: 4  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbdept DROP FOREIGN KEY fk_dept_mgr;
/*Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbemployee ADD CONSTRAINT fk_emp_mgr FOREIGN KEY (manager) REFERENCES jbmanager(id);
/*Query OK, 25 rows affected (0.12 sec)
Records: 25  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbmanager ADD CONSTRAINT fk_mgr_emp FOREIGN KEY (id) REFERENCES jbemployee(id);
/*Query OK, 8 rows affected (0.12 sec)
Records: 8  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbdept ADD CONSTRAINT fk_dept_mgr FOREIGN KEY (manager) REFERENCES jbmanager(id) ON DELETE SET NULL;
/*Query OK, 19 rows affected (0.14 sec)
Records: 19  Duplicates: 0  Warnings: 0*/

/* PART 4 */

UPDATE jbmanager SET bonus = bonus + 10000 WHERE id IN (SELECT manager FROM jbdept GROUP BY manager);
/*Query OK, 11 rows affected (0.00 sec)
Rows matched: 11  Changed: 11  Warnings: 0*/


/* PART 5 */

CREATE TABLE jbcustomer
       (id INT,
       name VARCHAR(20),
       adress VARCHAR(20),
       city INT,
       CONSTRAINT pk_customer PRIMARY KEY(id)) ENGINE=InnoDB;
/*Query OK, 0 rows affected (0.05 sec)*/

CREATE TABLE jbaccount
       (accountnumber INT,
       balance INT,
       owner INT,
       CONSTRAINT pk_account PRIMARY KEY(accountnumber)) ENGINE=InnoDB;
/*Query OK, 0 rows affected (0.15 sec)*/

CREATE TABLE jbtransaction
       (id INT,
       sdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       affects INT,
       employee INT,
       CONSTRAINT pk_transaction PRIMARY KEY(id)) ENGINE=InnoDB;
/*Query OK, 0 rows affected (0.05 sec)*/

CREATE TABLE jbwithdrawal
       (id INT,
       amount INT,
       CONSTRAINT pk_withdrawal PRIMARY KEY(id)) ENGINE=InnoDB;
/*Query OK, 0 rows affected (0.05 sec)*/

CREATE TABLE jbdeposit
       (id INT,
       amount INT,
       CONSTRAINT pk_deposit PRIMARY KEY(id)) ENGINE=InnoDB;
/*Query OK, 0 rows affected (0.05 sec)*/

ALTER TABLE jbcustomer ADD CONSTRAINT fk_cus_city FOREIGN KEY (city) REFERENCES jbcity(id);
/*Query OK, 0 rows affected (0.17 sec)
Records: 0  Duplicates: 0  Warnings: 0*/

INSERT INTO jbtransaction (id, sdate, affects, employee) SELECT id, sdate, account, employee FROM jbdebit;
/*Query OK, 6 rows affected (0.02 sec)
Records: 6  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbdebit DROP FOREIGN KEY fk_debit_employee;
/*Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbdebit DROP COLUMN account;
/*Query OK, 0 rows affected (0.15 sec)
Records: 0  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbdebit DROP COLUMN sdate;
/*Query OK, 0 rows affected (0.12 sec)
Records: 0  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbdebit DROP COLUMN employee;
/*Query OK, 0 rows affected (0.11 sec)
Records: 0  Duplicates: 0  Warnings: 0*/

INSERT INTO jbaccount (accountnumber, balance, owner) SELECT affects, 1000, 1 FROM jbtransaction GROUP BY affects;
/*Query OK, 5 rows affected (0.00 sec)
Records: 5  Duplicates: 0  Warnings: 0*/

INSERT INTO jbcustomer (id, name, adress, city) SELECT owner, "Bert", "Victory road 2", 946 FROM jbaccount GROUP BY owner;
/*Query OK, 1 row affected (0.01 sec)
Records: 1  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbaccount ADD CONSTRAINT fk_acc_cus FOREIGN KEY (owner) REFERENCES jbcustomer(id);
/*Query OK, 5 rows affected (0.09 sec)
Records: 5  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbtransaction ADD CONSTRAINT fk_tr_acc FOREIGN KEY (affects) REFERENCES jbaccount(accountnumber);
/*Query OK, 6 rows affected (0.11 sec)
Records: 6  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbwithdrawal ADD CONSTRAINT fk_wd_tr FOREIGN KEY (id) REFERENCES jbtransaction(id);
/*Query OK, 0 rows affected (0.14 sec)
Records: 0  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbdeposit ADD CONSTRAINT fk_dp_tr FOREIGN KEY (id) REFERENCES jbtransaction(id);
/*Query OK, 0 rows affected (0.12 sec)
Records: 0  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbdebit ADD CONSTRAINT fk_debit_tr FOREIGN KEY (id) REFERENCES jbtransaction(id);
/*Query OK, 6 rows affected (0.11 sec)
Records: 6  Duplicates: 0  Warnings: 0*/

ALTER TABLE jbtransaction ADD CONSTRAINT fk_tr_employee FOREIGN KEY (employee) REFERENCES jbemployee(id);
/*Query OK, 6 rows affected (0.12 sec)
Records: 6  Duplicates: 0  Warnings: 0*/
