-- db is employee_sti
-- create employee table

-- CREATE TABLE IF NOT EXISTS employees (
DROP TABLE IF EXISTS employees; CREATE TABLE employees (
  id SERIAL PRIMARY KEY
  ,name VARCHAR NOT NULL
  ,role VARCHAR NOT NULL CHECK (role IN ('bossman', 'manager', 'lead', 'eng'))
  ,salary INT NOT NULL
  ,reporter_id INT
)
;

-- inserts
INSERT INTO employees(name,role,salary,reporter_id) VALUES ('boss joe', 'bossman', 120, NULL);

INSERT INTO employees(name,role,salary,reporter_id) VALUES ('manager1 joe', 'manager', 40, (select id from employees where name = 'boss joe'));
INSERT INTO employees(name,role,salary,reporter_id) VALUES ('manager2 joe', 'manager', 40, (select id from employees where name = 'boss joe'));


INSERT INTO employees(name,role,salary,reporter_id) VALUES ('lead1 joe', 'lead', 30, (select id from employees where name = 'manager1 joe'));
INSERT INTO employees(name,role,salary,reporter_id) VALUES ('lead2 joe', 'lead', 30, (select id from employees where name = 'manager1 joe'));
INSERT INTO employees(name,role,salary,reporter_id) VALUES ('lead3 joe', 'lead', 30, (select id from employees where name = 'manager2 joe'));
INSERT INTO employees(name,role,salary,reporter_id) VALUES ('lead4 joe', 'lead', 30, (select id from employees where name = 'manager2 joe'));

INSERT INTO employees(name,role,salary,reporter_id) VALUES ('eng1 joe', 'eng', 10, (select id from employees where name = 'lead1 joe'));
INSERT INTO employees(name,role,salary,reporter_id) VALUES ('eng2 joe', 'eng', 10, (select id from employees where name = 'lead1 joe'));
INSERT INTO employees(name,role,salary,reporter_id) VALUES ('eng3 joe', 'eng', 10, (select id from employees where name = 'lead1 joe'));
INSERT INTO employees(name,role,salary,reporter_id) VALUES ('eng4 joe', 'eng', 10, (select id from employees where name = 'lead2 joe'));
INSERT INTO employees(name,role,salary,reporter_id) VALUES ('eng5 joe', 'eng', 10, (select id from employees where name = 'lead2 joe'));

-- end inserts

\echo ALL EMPLOYEES 👇
SELECT * from employees;

-- print X's reporter, given X's name
\echo Reporter of 'eng5 joe' 👇
with reportee as (
  select * from employees where name = 'eng5 joe'
) select e.name "reporter", e.role, r.name "reportee", r.role from employees e, reportee r where e.id = r.reporter_id
;

-- print X's reportees, given X's name
\echo Reportees of 'lead1 joe' 👇
with reporter as (
  select * from employees where name = 'lead1 joe'
) select r.name "reporter", r.role, e.name "reportees", e.role from employees e, reporter r where e.reporter_id = r.id
;

-- superiors of X
\echo Superiors of 'eng5 joe' 👇
WITH RECURSIVE superiors AS (
   SELECT * FROM employees WHERE name = 'eng5 joe'
   UNION
   SELECT e.* FROM employees e INNER JOIN superiors s ON s.reporter_id = e.id
) SELECT * FROM superiors
;

-- subordinates of X
\echo Subordinates of 'manager2 joe' 👇
WITH RECURSIVE  subordinates AS (
   SELECT * FROM employees WHERE name = 'manager2 joe'
   UNION
   SELECT e.* FROM employees e INNER JOIN subordinates s ON s.id = e.reporter_id
) SELECT * from subordinates
;

-- Top 10 employees with ratio of salary 
\echo TOP 10 SALARIES 👇
with top10 as (
  select * from employees order by salary desc limit 10
), top10sum as (
  select sum(top10.salary) "top10sum" from top10
) select e.id, e.name, e.role, e.salary, (e.salary*100)::numeric/top10sum.top10sum "%", top10sum "total" from top10 e, top10sum
;

-- select sum(salary) from (select salary from employees order by salary desc limit 10) t;

-- with top10 as (
  -- select * from employees order by salary desc limit 10
-- ) select sum(top10.salary) "top10sum" from top10
-- ;

-- (X, Y) -> A -> B
-- X and Y report to A, who reports to B
-- A resigns. Then,
-- (X, Y) -> B
-- take A's reporter_id and assign it to reporter_id of A's reportees
\echo Delete 'lead2 joe' and point his reportees to his reporter 👇
with resignee as (
  select * from employees where name = 'lead2 joe'
)
update employees set reporter_id = resignee.reporter_id 
  from resignee
  where employees.reporter_id = resignee.id
;
delete from employees where name = 'lead2 joe';
select * from employees;
