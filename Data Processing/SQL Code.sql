---Viewing table: viewers
select * from `workspace`.`default`.`viewer_transactions`;

---Viewing table: users
select * from `workspace`.`default`.`user_profiles`;

---LEFT JOIN TABLES

SELECT 
       UserID0, Channel2, RecordDate2, `Duration 2`, Gender, Age, Race, Province
FROM `workspace`.`default`.`viewer_transactions` AS A
LEFT JOIN `workspace`.`default`.`user_profiles` AS B
ON A.UserID0 = B.UserID;

---Count Different Age group: There are 71 age groups

SELECT DISTINCT Age AS Age
FROM `workspace`.`default`.`user_profiles`;

--- Counting Male, Female & None
UPDATE `workspace`.`default`.`user_profiles`
SET Gender = 'No Gender'
WHERE Gender IS NULL
OR TRIM(Gender) = ''
OR Gender = 'None';

DESCRIBE HISTORY `workspace`.`default`.`user_profiles`;


--- Checking Null
SELECT UserID0,
       Channel2,
       RecordDate2,
      `Duration 2`,
      userid4
FROM `workspace`.`default`.`viewer_transactions` AS A
LEFT JOIN `workspace`.`default`.`user_profiles` AS B
ON A.UserID0 = B.UserID
WHERE UserID0 IS NULL
OR    Channel2 IS NULL
OR    RecordDate2 IS NULL
OR   `Duration 2` IS NULL
OR     userid4 IS NULL;

---
SELECT  Province
FROM `workspace`.`default`.`user_profiles`
WHERE Province = 'Kwazulu Natal';

--- Cleaning a None Value to a value
SELECT 
       CASE
              WHEN Gender = 'None' OR Gender = '' THEN 'No Gender'
              ELSE Gender
       END AS Gender,

        CASE
              WHEN Race = 'None' THEN 'No Race'
              ELSE Race
       END AS Race,

         CASE
              WHEN Province = 'None' THEN 'No Province'
              ELSE Province
       END AS Province
FROM `workspace`.`default`.`user_profiles`;

---Trimming 
SELECT (TRIM(Gender)) AS Gender,
       (TRIM(Race)) AS Race,
       (TRIM(Age)) AS Age,
       (TRIM(Province)) AS Province
FROM `workspace`.`default`.`user_profiles`;

---Trimming Channel2
SELECT (TRIM(Channel2)) AS Channel2
FROM `workspace`.`default`.`viewer_transactions`;

---Converting to time
SELECT TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss') AS Duration_Time
FROM `workspace`.`default`.`viewer_transactions`;

---Standardising
SELECT 
       date_format(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'), 'HH:mm:ss') AS Clean_Duration
       FROM `workspace`.`default`.`viewer_transactions`;

--- Convert UTC to South african time
SELECT DATEADD(hour, 2, RecordDate2) AS SouthAfricaTime
FROM `workspace`.`default`.`viewer_transactions`;

--- Cleaned Converted UTC to South african time
SELECT date_format(DATEADD(Hour, 2, RecordDate2), 'HH:mm:ss')  AS SouthAfricaTime
FROM `workspace`.`default`.`viewer_transactions`;

--- First & Last date of data collection
SELECT MIN(RecordDate2) AS Min_date,
       MAX(RecordDate2) AS Max_date
FROM `workspace`.`default`.`viewer_transactions`;

SELECT Gender, COUNT(UserID) AS Male_Female
FROM `workspace`.`default`.`user_profiles`
GROUP BY Gender;

---
SELECT *
FROM `workspace`.`default`.`user_profiles`
WHERE TRIM(Gender) = '';


---MAIN CODE: Data cleaning: columns and Standardising duration to (HH:mm:ss)
SELECT  UserID0  AS UserID,
        Channel2 AS Channel, 
       date_format(TO_TIMESTAMP(RecordDate2, 'yyyy:MM:dd'), 'yyyy:MM:dd') AS RecordDate,
        date_format(DATEADD(Hour, 2, RecordDate2), 'HH:mm:ss')  AS SouthAfricaTime,
       date_format(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'), 'HH:mm:ss') AS Duration,
       Age AS Age,
     

CASE

       WHEN Gender = 'None' THEN 'No Gender'
       ELSE Gender
       END AS Gender,

CASE
       WHEN Race = 'None' THEN 'No Race'
       ELSE Race
       END AS Race,

CASE
       WHEN Province = 'None' THEN 'No Province'
       ELSE Province
       END AS Province

---Left JOIN tables      
FROM `workspace`.`default`.`viewer_transactions` AS A
LEFT JOIN `workspace`.`default`.`user_profiles` AS B
ON A.UserID0 = B.UserID;

  Gender, Age, Race, Province,
