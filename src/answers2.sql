-- 1 Total money of all the accounts group by types.
SELECT
  a.type,
  SUM(a.mount)
FROM
  accounts a
GROUP BY
  a.type;

-- 2 How many users with at least 2 CURRENT_ACCOUNT.
SELECT
  COUNT(u.*)
FROM
  accounts ac
  INNER JOIN public.users u ON u.id = ac.user_id
WHERE
  ac.type = 'CURRENT_ACCOUNT'
GROUP BY
  ac.type;

-- 3 List the top five accounts with more money.
SELECT
  a.account_id
FROM
  accounts a
ORDER BY
  a.mount DESC
LIMIT
  5;

-- 4 Get the three users with the most money after making movements.
WITH user_balances AS (
  -- Calculate the total money for each user after all movements
  SELECT
    u.id AS user_id,
    u.name,
    u.last_name,
    SUM(
      CASE
        WHEN a.user_id = u.id THEN a.mount
        ELSE 0
      END
    ) + COALESCE(
      SUM(
        CASE
          WHEN m.account_to = a.id THEN m.mount
          ELSE 0
        END
      ),
      0
    ) - COALESCE(
      SUM(
        CASE
          WHEN m.account_from = a.id THEN m.mount
          ELSE 0
        END
      ),
      0
    ) AS total_money
  FROM
    public.users u
    LEFT JOIN public.accounts a ON a.user_id = u.id
    LEFT JOIN public.movements m ON m.account_from = a.id
    OR m.account_to = a.id
  GROUP BY
    u.id,
    u.name,
    u.last_name
)
SELECT
  user_id,
  name,
  last_name,
  total_money
FROM
  user_balances
ORDER BY
  total_money DESC
LIMIT
  3;

-- 5 In this part you need to create a transaction with the following steps:
-- a First,
-- get the ammount for the account 3b79e403 - c788 - 495a - a8ca - 86ad7643afaf
-- and fd244313 - 36e5 - 4a17 - a27c - f8265bc46590 after all their movements.
-- b. Add a new movement with the information:
-- from :
-- 3b79e403 - c788 - 495a - a8ca - 86ad7643afaf make a transfer to fd244313 - 36e5 - 4a17 - a27c - f8265bc46590 mount: 50.75
-- c Add a new movement with the information:
--   from:
--   3b79e403 - c788 - 495a - a8ca - 86ad7643afaf type: OUT mount: 731823.56
-- d Put your answer here if the transaction fails(YES / NO):
-- e If the transaction fails, make the correction on step c to avoid the failure:
-- f Once the transaction is correct, make a commit
-- g How much money the account fd244313 - 36e5 - 4a17 - a27c - f8265bc46590 have:
-- 6 All the movements and the user information with the account 3b79e403-c788-495a-a8ca-86ad7643afaf
SELECT
  u.name,
  u.email,
  a.id AS account_id,
  m.type,
  m.mount
FROM
  users u
  LEFT JOIN accounts a ON a.user_id = u.id
  LEFT JOIN movements m ON m.account_from = a.id
  OR m.account_to = a.id
WHERE
  a.id = '3b79e403-c788-495a-a8ca-86ad7643afaf';

-- 7 The name and email of the user with the highest money in all his / her accounts
SELECT
  u.name,
  u.email,
  SUM(a.mount) AS total
FROM
  users u
  INNER JOIN accounts a ON u.id = a.user_id
GROUP BY
  u.name,
  u.email
ORDER BY
  total DESC
LIMIT
  1;

-- 8 Show all the movements for the user Kaden.Gusikowski @gmail.com order by account type and created_at on the movements table
SELECT
  u.email,
  a.account_id,
  m.type,
  m.mount,
  m.created_at
FROM
  users u
  INNER JOIN accounts a ON a.user_id = u.id
  INNER JOIN movements m ON m.account_from = a.id
WHERE
  u.email = 'Kaden.Gusikowski@gmail.com';
