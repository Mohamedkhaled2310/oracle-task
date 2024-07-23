-- SQL Block Description
-- Example: Creating a table

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date DATE,
    salary DECIMAL(10, 2)
);

-- SQL Block Description
-- Example: Inserting data into the table

INSERT INTO employees (employee_id, first_name, last_name, hire_date, salary)
VALUES (1, 'John', 'Doe', '2024-07-23', 50000.00);

-- SQL Block Description
-- Example: Querying the table

SELECT * FROM employees;
