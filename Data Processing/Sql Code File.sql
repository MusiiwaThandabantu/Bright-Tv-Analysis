------------------------------------------------------------------
---Viewing table: viewers
select * from `workspace`.`default`.`viewer_transactions`;

---Viewing table: users
select * from `workspace`.`default`.`user_profiles`;
-------------------------------------------------------------------
--- First & Last date of data collection
SELECT date_format(MIN(RecordDate22), 'yyyy-MM-dd') AS  Start_date,
       date_format(MAX(RecordDate22), 'yyyy:MM:dd') AS  End_date
FROM `workspace`.`default`.`viewer_transactions` AS A
LEFT JOIN `workspace`.`default`.`user_profiles` AS B
ON A.UserID0 = B.UserID;
--------------------------------------------------------------------
---LEFT JOIN TABLES

SELECT 
       UserID0, Channel2, RecordDate22, `Duration 2`, Gender, Age, Race, Province
FROM `workspace`.`default`.`viewer_transactions` AS A
LEFT JOIN `workspace`.`default`.`user_profiles` AS B
ON A.UserID0 = B.UserID;
---------------------------------------------------------------
---Count Different Age group, Channel, Province & Race
--- Checking the Age group
SELECT DISTINCT Age AS Age
FROM `workspace`.`default`.`user_profiles`;

--- Checking all Channels: There are 21 Channels
SELECT DISTINCT(Channel2) AS Channel
FROM `workspace`.`default`.`viewer_transactions`;

--- Checking all Provinces
SELECT DISTINCT(Province) AS Province
FROM `workspace`.`default`.`user_profiles`;

---Checking all Races
SELECT DISTINCT(Race) AS Race
FROM `workspace`.`default`.`user_profiles`;

-------------------------------------------------------------
--- Checking Null
SELECT UserID0,
       Channel2,
       RecordDate22,
      `Duration 2`,
       userID,
       Gender,
       Age,
       Race,
       Province
FROM `workspace`.`default`.`viewer_transactions` AS A
LEFT JOIN `workspace`.`default`.`user_profiles` AS B
ON A.UserID0 = B.UserID
WHERE UserID0 IS NULL
OR    Channel2 IS NULL
OR    RecordDate22 IS NULL
OR   `Duration 2` IS NULL
OR     userID IS NULL;
-----------------------------------------------------------
--- Counting Province & Channel
SELECT  Province, COUNT(UserID) AS Province
FROM `workspace`.`default`.`user_profiles`
GROUP BY Province;

SELECT  Channel2, COUNT(UserID0) AS Channel
FROM `workspace`.`default`.`viewer_transactions`
GROUP BY Channel2;
------------------------------------------------------------
--- Cleaning a None Value to a value
SELECT 
       CASE
              WHEN Gender = 'None' 
              OR Gender = '' THEN 'No Gender'
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
----------------------------------------------------------------
---Trimming 
SELECT (TRIM(Gender)) AS Gender,
       (TRIM(Race)) AS Race,
       (TRIM(Age)) AS Age,
       (TRIM(Province)) AS Province
FROM `workspace`.`default`.`user_profiles`;

---Trimming Channel2
SELECT (TRIM(Channel2)) AS Channel2
FROM `workspace`.`default`.`viewer_transactions`;
----------------------------------------------------------------
---Converting to time
SELECT TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss') AS Duration_Time
FROM `workspace`.`default`.`viewer_transactions`;

---Standardising
SELECT 
       date_format(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'), 'HH:mm:ss') AS Clean_Duration
FROM `workspace`.`default`.`viewer_transactions`;

--- Convert UTC to South african time
SELECT DATEADD(hour, 2, RecordDate22) AS SouthAfricaTime
FROM `workspace`.`default`.`viewer_transactions`;

--- Cleaned Converted UTC to South african time
SELECT date_format(DATEADD(Hour, 2, RecordDate22), 'HH:mm:ss')  AS SouthAfricaTime
FROM `workspace`.`default`.`viewer_transactions`;
-------------------------------------------------------------------
--- Extraction of Day name from Record Date
SELECT   Dayname(RecordDate22) AS Day_name,
         Monthname(RecordDate22) AS Month_name,
CASE
   WHEN Day_name IN('Sat','Sun') THEN 'Weekend'
        ELSE 'Weekdays'
    END AS Days,

 CASE
    WHEN date_format(RecordDate22, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN date_format(RecordDate22, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
    WHEN date_format(RecordDate22, 'HH:mm:ss') >= '17:00:00' THEN 'Evening'
END AS time_buckets
FROM `workspace`.`default`.`viewer_transactions`;

--- Extracting Age groups
SELECT
CASE
    WHEN Age BETWEEN '0' AND '17' THEN 'Kids'
    WHEN Age BETWEEN '18' AND '35' THEN 'Kids'
    WHEN Age BETWEEN '36' AND '45' THEN 'Kids'
    WHEN Age BETWEEN '46' AND '60' THEN 'Kids'
ELSE 'Pensioner'
END AS Age_group
FROM `workspace`.`default`.`user_profiles`;
--------------------------------------------------------------------
--- Counting Genders
SELECT Gender, COUNT(UserID) AS Count
FROM `workspace`.`default`.`user_profiles`
GROUP BY Gender;

---Check Viewership by Race
SELECT Race,
       COUNT(userID) AS Race_Viewers
FROM `workspace`.`default`.`user_profiles`
GROUP BY Race;
---------------------------------------------------------------------
---MAIN CODE
---------------------------------------------------------------------
SELECT  UserID0  AS UserID,
        Channel2 AS Channel, 
  ---Record date
        date_format(TO_TIMESTAMP(RecordDate22, 'yyyy:mm:dd'), 'yyyy:mm:dd') AS RecordDate, 
  -- Get the month name (e.g., Jan, Mar.etc)
        Monthname(RecordDate22) AS Month_name, 
  -- Get the day name (e.g., Monday)
        date_format(TO_TIMESTAMP(RecordDate22, 'yyyy:mm:dd'), 'EEEE') AS Day_name, 

CASE
   WHEN Day_name IN('Sat','Sun') THEN 'Weekend'
        ELSE 'Weekdays'
    END AS Days,

 CASE
    WHEN date_format(RecordDate22, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN date_format(RecordDate22, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
    WHEN date_format(RecordDate22, 'HH:mm:ss') >= '17:00:00' THEN 'Evening'
END AS time_buckets,

        date_format(DATEADD(Hour, 2, RecordDate22), 'HH:mm:ss')  AS SATime, --- Convert UTC to South african time
      
      
        date_format(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'), 'HH:mm:ss') AS Duration, ---Cleaned Converted UTC to South african time
        Age AS Age,
CASE
    WHEN Age BETWEEN '0' AND '17' THEN 'Kids'
    WHEN Age BETWEEN '18' AND '35' THEN 'Young Adult'
    WHEN Age BETWEEN '36' AND '45' THEN 'Adult'
    WHEN Age BETWEEN '46' AND '60' THEN 'Elderly'
         ELSE 'Pensioner'
END AS Age_group,
      
--- Cleaning a None Value to a value
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

FROM `workspace`.`default`.`viewer_transactions` AS A
LEFT JOIN `workspace`.`default`.`user_profiles` AS B
ON A.UserID0 = B.UserID;
