drop schema public cascade;
create schema public;

-- constraint exclusion to optimize selects, now that we have partitioned the db
set constraint_exclusion = on;

-- enable for postgresql 9.1+
create extension pgcrypto;

