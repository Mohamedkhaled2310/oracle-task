# Oracle Database Session Management and Locking

This guide demonstrates how to manage Oracle database users, handle row lock contention, and create functions for various calculations.

## 1. Create Users and Grant Privileges

```sql
-- Create a manager user and grant privileges
create user manager identified by 123;
grant create session to manager;
grant dba to manager;

-- Connect as manager and create additional users
conn manager/123;
create user user1 identified by 123;
create user user2 identified by 123;
grant create session to user1, user2;
grant create table to user1;
alter user user1 quota 100m on system;
