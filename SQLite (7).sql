CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1
UNION ALL		
SELECT * FROM appleStore_description2
UNION ALL						
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4


--- check the number of unique apps in both tablesappleStore;



SELECT
	COUNT(DISTINCT id) as UniqueAppIDs
    FROM AppleStore
    
    
SELECT
	COUNT(DISTINCT id) as UniqueAppIDs
    FROM appleStore_description_combined
    
    
-- Check missing values in Key Fields

SELECT 
	COUNT(*) AS MissingValues
	FROM appleStore_description_combined
    WHERE track_name IS null or size_bytes IS null OR app_desc IS NULL
    
    
SELECT 
	COUNT(*) AS MissingValues
	FROM AppleStore
    WHERE track_name IS null or user_rating IS null OR prime_genre IS NULL
    
    
-- Find the number of apps per genre

SELECT
	prime_genre, 
    COUNT(*) AS NumApps
    from AppleStore
    GROUP BY prime_genre
    ORDER BY NumApps DESC

---Get an overview if the apps ratings;

SELECT
	track_name,
	min(user_rating) AS MinRating,
    max(user_rating) AS MaxRating,
    avg(user_rating) AS AvgRating
    FROM AppleStore
    GROUP BY user_rating
    ORDER BY AvgRating DESC
    Limit 10
    

SELECT
	prime_genre,
	min(user_rating) AS MinRating,
    max(user_rating) AS MaxRating,
    avg(user_rating) AS AvgRating
    FROM AppleStore
    GROUP BY prime_genre
    ORDER BY AvgRating DESC
    Limit 10

--Determine if Paid apps have higher ratings than Free appsAppleStore

SELECT CASE
	WHEN price > 0 THEN 'Paid' ELSE 'Free'
    END AS App_Type,
    avg(user_rating) AS Avg_Rating
    FROM AppleStore
    GROUP BY App_Type
    
    
-- Does App that support more language have higher ratingsAppleStore

SELECT CASE
	WHEN lang_num <10 THEN 'Minor 10' 
    WHEN lang_num BETWEEN 10 AND 30 THEN 'Mid Lang'
    ELSE 'Multiple lang'
    END AS Lang_Supp,
    avg(user_rating) AS Avg_Rating
    FROM AppleStore
    GROUP BY Lang_Supp
    ORDER BY Avg_Rating DESC
    
-- Prime Genre with Low ratingsAppleStore

SELECT
	prime_genre,
    avg(user_rating) AS AVG_RATING
    FROM AppleStore
    GROUP BY prime_genre
    ORDER BY AVG_RATING ASC
    LIMIT 10
    
--Check if theres correlation with app Description and user ratingAppleStore
SELECT CASE
	WHEN length(b.app_desc) < 500 then 'Short'
    WHEN length(b.app_desc) BETWEEN 500 and 1000 then 'MEDIUM'
    else 'LONG'
    END AS DESC_LEN,
    avg(a.user_rating) AS AVG_RATING
FROM 
	AppleStore AS A
JOIN	appleStore_description_combined as B
ON A.id = B.id
GROUP BY DESC_LEN
ORDER BY AVG_RATING DESC

--Check Top rated each categoryAppleStore

SELECT
	track_name,
    prime_genre,
    avg(user_rating) AS AVG_RATING
FROM AppleStore
group by prime_genre
ORDER BY AVG_RATING DESC


SELECT
	track_name,
    prime_genre,
    user_rating
FROM (
SELECT
	track_name,
    prime_genre,
    user_rating,
  	RANK() OVER(PARTITION BY prime_genre order by user_rating DESC, rating_count_tot DESC) AS rank
FROM AppleStore) as a
WHERE
a.rank = 1    