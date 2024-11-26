-- Your answers here:
-- 1 Count the total number of states in each country.
SELECT
  c.name,
  count(s.name)
FROM
  states s
  INNER JOIN countries c ON c.id = s.country_id
GROUP BY
  c.name;

-- 2 How many employees do not have supervisores.
SELECT
  count(s.id) as employees_without_bosses
FROM
  employees s
WHERE
  supervisor_id is NULL;

-- 3 List the top five offices address with the most amount of employees, order the result by country and display a column with a counter.
SELECT
  c.name,
  o.address,
  count(e.id) as employees
FROM
  offices o
  INNER JOIN employees e ON e.office_id = o.id
  INNER JOIN countries c ON c.id = o.country_id
GROUP BY
  c.name,
  o.address
ORDER BY
  employees DESC
LIMIT
  5;

-- 4
-- 5
-- 6
-- 7
