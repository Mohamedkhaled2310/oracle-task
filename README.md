# Oracle Database Management and Locking

## Introduction

This document provides a comprehensive guide on managing Oracle database users, handling row lock contention, creating and executing procedures, and defining functions. Follow the steps below to understand various aspects of Oracle database management.

## 1. Create Users and Grant Privileges

```sql
-- Create a manager user
CREATE USER manager IDENTIFIED BY 123;

-- Grant necessary privileges
GRANT CREATE SESSION TO manager;
GRANT DBA TO manager;
