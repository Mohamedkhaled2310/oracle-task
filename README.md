# Oracle Database Session Management and Locking

This project demonstrates session management, user creation, and handling row lock contention in Oracle Database. The process involves creating users, tables, and functions, and executing transactions to simulate row locking issues.

## Steps

### 1. Create Users and Grant Privileges

```sql
create user manager identified by 123;
grant create session to manager;
grant dba to manager;

conn manager/123;
create user user1 identified by 123;
create user user2 identified by 123;
grant create session to user1, user2;
grant create table to user1;
alter user user1 quota 100m on system;
2. Setup Schema and Grant Permissions
sql
Copy code
conn user1/123;
create table department(id int, depart_name varchar(50), constraint pk primary key(id));
create table employee(id int, emp_name varchar(50), salary float, depart_id int, primary key(id), foreign key(depart_id) references department(id));
grant insert on department to user2;
grant insert on employee to user2;
3. Insert Data
sql
Copy code
conn user2/123;
insert into user1.department values(1, 'HR');
insert into user1.department values(2, 'IT');
insert into user1.department values(3, 'finance');

insert into user1.employee values(1, 'mahmoud', 1550, 3);
insert into user1.employee values(2, 'mohamed', 1550, 1);
insert into user1.employee values(3, 'nshat', 1350, 2);
insert into user1.employee values(4, 'jooo', 1100, 2);
insert into user1.employee values(5, 'shabaan', 1650, 1);
4. Create and Grant Procedure
sql
Copy code
conn manager/123;
CREATE OR REPLACE PROCEDURE rais IS
BEGIN
  UPDATE user1.employee SET salary = salary * 1.1 WHERE depart_id = 1;
  DBMS_LOCK.SLEEP(5);
END rais;
/

grant execute on rais to user1, user2;
5. Simulate Transactions
sql
Copy code
conn user1/123;
BEGIN
  UPDATE employee
  SET salary = salary * 1.1
  WHERE depart_id = 1;
  
  DBMS_LOCK.SLEEP(10);
  
  UPDATE employee
  SET salary = salary * 1.1
  WHERE depart_id = 2;
END;
/

conn user2/123;
BEGIN
  UPDATE user1.employee
  SET salary = salary * 1.1
  WHERE depart_id = 2;
  
  DBMS_LOCK.SLEEP(10);
  
  UPDATE user1.employee
  SET salary = salary * 1.1
  WHERE depart_id = 1;
END;
/
6. Identify Blocking and Waiting Sessions
sql
Copy code
conn manager/123;
-- Identify blocker session
SELECT sid, serial#
FROM V$SESSION
WHERE EVENT = 'enq: TX - row lock contention'
  AND TYPE = 'USER';

-- Identify waiting session
SELECT sid, serial#
FROM V$SESSION
WHERE EVENT = 'enq: TX - row lock contention'
  AND TYPE = 'USER';
7. Create Functions
sql
Copy code
conn user1/123;
CREATE OR REPLACE FUNCTION calculate_avg_salary(department_id NUMBER)
RETURN NUMBER
IS
  avg_salary NUMBER;
BEGIN
  SELECT AVG(salary) INTO avg_salary
  FROM employee
  WHERE depart_id = department_id;
  
  RETURN avg_salary;
END;
/

CREATE OR REPLACE FUNCTION calculate_total_salary(department_id NUMBER)
RETURN NUMBER
IS
  total_salary NUMBER;
BEGIN
  SELECT SUM(salary) INTO total_salary
  FROM employee
  WHERE depart_id = department_id; -- Corrected column name
  
  RETURN total_salary;
END;
/

CREATE OR REPLACE FUNCTION calculate_max_salary
RETURN NUMBER
IS
  max_salary NUMBER;
BEGIN
  SELECT MAX(salary) INTO max_salary
  FROM employee;
  
  RETURN max_salary;
END;
/
