# Oracle Database Session Management and Locking

## Introduction

This document provides a comprehensive guide on managing Oracle database users, handling row lock contention, and creating functions for various calculations. Follow the steps below to set up users, perform transactions, and analyze sessions.

## Steps Overview

| Step | Description                                                                                         | SQL Code (Examples) |
|------|-----------------------------------------------------------------------------------------------------|----------------------|
| 1    | **Create Users and Grant Privileges**                                                               | [View Code](#1-create-users-and-grant-privileges) |
| 2    | **Setup Schema and Grant Permissions**                                                              | [View Code](#2-setup-schema-and-grant-permissions) |
| 3    | **Insert Data**                                                                                     | [View Code](#3-insert-data) |
| 4    | **Create and Grant Procedure**                                                                      | [View Code](#4-create-and-grant-procedure) |
| 5    | **Simulate Transactions**                                                                          | [View Code](#5-simulate-transactions) |
| 6    | **Identify Blocking and Waiting Sessions**                                                          | [View Code](#6-identify-blocking-and-waiting-sessions) |
| 7    | **Create Functions**                                                                              | [View Code](#7-create-functions) |

## 1. Create Users and Grant Privileges

```sql
-- Create a manager user
create user manager identified by 123;

-- Grant necessary privileges
grant create session to manager;
grant dba to manager;
