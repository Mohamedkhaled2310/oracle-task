-- Connect as user1
conn user1/123;

-- Create department table
create table department (
  id int,
  depart_name varchar(50),
  constraint pk primary key(id)
);

-- Create employee table
create table employee (
  id int,
  emp_name varchar(50),
  salary float,
  depart_id int,
  primary key(id),
  foreign key(depart_id) references department(id)
);

-- Connect as user1
conn user1/123;

-- Create department table
create table department (
  id int,
  depart_name varchar(50),
  constraint pk primary key(id)
);

-- Create employee table
create table employee (
  id int,
  emp_name varchar(50),
  salary float,
  depart_id int,
  primary key(id),
  foreign key(depart_id) references department(id)
);

-- Grant permissions to user2
grant insert on department to user2;
grant insert on employee to user2;

-- Connect as user2
conn user2/123;

-- Insert data into department table
insert into user1.department values(1, 'HR');
insert into user1.department values(2, 'IT');
insert into user1.department values(3, 'Finance');

-- Insert data into employee table
insert into user1.employee values(1, 'Mahmoud', 1550, 3);
insert into user1.employee values(2, 'Mohamed', 1550, 1);
insert into user1.employee values(3, 'Nshat', 1350, 2);
insert into user1.employee values(4, 'Jooo', 1100, 2);
insert into user1.employee values(5, 'Shabaan', 1650, 1);

-- Connect as manager
conn manager/123;

-- Create a procedure to update employee salaries
CREATE OR REPLACE PROCEDURE rais IS
BEGIN
  UPDATE user1.employee SET salary = salary * 1.1 WHERE depart_id = 1;
  DBMS_LOCK.SLEEP(5);
END rais;
/

-- Grant execute permissions on the procedure
grant execute on rais to user1, user2;

-- Connect as user1 and perform a transaction
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

-- Connect as user2 and perform a transaction
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

-- Connect as manager
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

-- Connect as user1
conn user1/123;

-- Create function to calculate average salary
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

-- Create function to calculate total salary
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

-- Create function to calculate maximum salary
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


### Explanation

- **Steps Overview Table**: Provides a quick reference to each major section of the README with links to detailed sections.
- **Detailed Sections**: Each section includes the specific SQL commands or code relevant to the step.

You can copy this Markdown content into your `README.md` file and adjust any details as needed.
