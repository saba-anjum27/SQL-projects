 --  Part 2 – Restaurant:
CREATE DATABASE mini_project_restaurant;
USE mini_project_restaurant;
drop DATABASE mini_project_restaurant;
   
SHOW TABLES;
DESC chefmozaccepts; 
DESC chefmozhours4;      
DESC chefmozcuisine;    
DESC chefmozparking;   
DESC geoplaces2;         
DESC rating_final;       
DESC usercuisine;       
DESC userpayment;        
DESC userprofile;         
   
  --  We need to find out the total visits to all restaurants under all alcohol categories available.
SELECT a.placeID,a.name, a.alcohol, COUNT(b.userid) AS total_visits
FROM geoplaces2 a JOIN rating_final b 
ON a.placeID = b.placeID
where a.alcohol not like "%NO_Alcohol%"
GROUP BY alcohol, a.placeID, a.name
ORDER BY total_visits DESC;                         

/*   From the data it can be seen that majority of the restaurants serve the wine-beer type of alcohol. Most of the visits were made to
 Cafeteria y Restaurant El Pacifico which serves the alcohol under wine-beer category. Further, in the full_bar category, 
 La Cantina Restaurant has the maximum number of visits. The restaurants that are least visited are 'Mikasa' and 'Rincon del Bife' 
 under wine-beer and full bar categories respectively.
This analysis helps in analyzing the popularity of places that serve alcohol and identifying the number of users who have rated those places.
            */

  
-- finding out the average rating according to alcohol and price so that we can understand the rating in respective price categories as well.
 
SELECT distinct b.placeID,b.name, b.alcohol, b.price,
 AVG(a.rating) OVER(PARTITION BY b.alcohol) as `rating according to alcohol`,
AVG(a.rating) OVER(PARTITION BY b.price) as `rating according to price`
FROM rating_final a JOIN geoplaces2 b
ON a.placeID = b.placeID 
WHERE b.alcohol NOT LIKE "%NO_Alcohol%"                                
ORDER BY AVG(a.rating) OVER(PARTITION BY b.alcohol) DESC,
AVG(a.rating) OVER(PARTITION BY b.price) DESC;

/*   The highest rating with respect to price, as well as the alcohol is given to the restaurants under the category of full-bar type.
 There are 4 restaurants which top the rating list with respect to both price and alcohol, which include la Cantina, Rincon del Bife,
 Restaurant and Bar and Clothesline Carlos N Charlies and La Cantina Restaurante even though the price is high.
Considering both the price ratings and alcohol ratings, lowest ratings are given to particularly 5 restaurants which belong under 
the wine-beer category of alcohol. The restaurants are Unicols Pizza, emilianos, El cotorreo, Abondance Restaurante Bar and crudalia.
 These restaurants have low ratings despite having low prices.
*/


-- Let’s write a query to quantify that what are the parking availability as well in different alcohol 
-- categories along with the total number of restaurants.


SELECT a.alcohol AS alcohol_type, b.parking_lot,
       COUNT(DISTINCT a.placeID) AS total_restaurants, 
       SUM(b.parking_lot IN 
       ('public', 'yes', 'valet parking', 'fee', 'street','validated parking')) AS ParkingAvailable_count, 
       SUM(b.parking_lot = 'none') AS NoParking_count
FROM geoplaces2 a LEFT JOIN chefmozparking b
ON a.placeID = b.placeID
 WHERE a.alcohol NOT LIKE '%NO_Alcohol%'
GROUP BY a.alcohol, b.parking_lot;


/*
From the data it can be inferred that there are a total of three Full-bar restaurants with no parking availability. 
In case of wine-beer restaurants there are 12 restaurants which do not have parking facilities.          */

-- taking out the percentage of different cuisine in each alcohol type.
SELECT 
  a.alcohol AS alcohol_type, 
  b.rcuisine AS cuisine_type, 
  COUNT(DISTINCT a.placeid) AS total_restaurants,
  SUM(p.parking_lot
  IN ('public', 'yes', 'valet parking', 'fee', 'street','validated parking')) AS parking_available_count,
  SUM(p.parking_lot = 'none') AS no_parking_count,
  ROUND(COUNT(DISTINCT a.placeid) / SUM(COUNT(DISTINCT a.placeid)) OVER (PARTITION BY a.alcohol) * 100, 2) AS cuisine_percentage
FROM geoplaces2 a 
JOIN chefmozCuisine b ON a.placeid = b.placeid 
JOIN chefmozparking p ON a.placeid = p.placeid
WHERE a.alcohol NOT LIKE '%NO_Alcohol%' AND a.country <> '?'
GROUP BY a.alcohol, b.rcuisine
ORDER BY a.alcohol, cuisine_percentage DESC;
/* 
From the data, It can be seen maximum varieties of cuisines are present in wine-beer type of restaurants.
 Majority of full bar and wine beer restaurants have bar cuisine. The cuisines with least percentage include bar pub brewery,
 Italian, Japanese and Mexican.
It can also be seen that all the restaurants with Mexican cuisine type have the parking availability. 
All the international and contemporary restaurants also have parking availability.There is only one restaurant with Japanese cuisine. 
Even the Italian cuisine is served in only one restaurant.

*/

-- Questions 5: - let’s take out the average rating of each state.
update geoplaces2 set state= replace(state,"san luis potos","San Luis Potosi");
update geoplaces2 set state= replace(state,"San Luis Potosii","San Luis Potosi");

SELECT 
    a.state, ROUND(AVG(b.rating), 2) AS average_rating
FROM 
    geoplaces2 a
        INNER JOIN
    rating_final b ON a.placeid = b.placeid where a.state <> "?" 
GROUP BY state order by average_rating desc;

/* 
The column state in geoplaces2 table required data cleaning as the strings “san luis potos” and "San Luis Potosii" were believed
 to be same as the string “San Luis Potosi”. Hence, they were corrected.
Further it is seen that the highest rating is given to the state s.l.p which is presumed to be San Luis Potosi but due to uncertainty 
it is left unchanged since this has to be discussed and cross checked.However, the state with the least rating is Tamaulipas.


*/

-- ' Tamaulipas' Is the lowest average rated state. Quantifying the reason why it is the lowest rated by providing the
--  summary on the basis of State, alcohol, and Cuisine.
SELECT 
    COUNT(gp.placeid) AS number_of_restaurants,
    Rcuisine,
    alcohol
FROM
    geoplaces2 gp
        INNER JOIN
    chefmozcuisine cc ON gp.placeid = cc.placeid
WHERE
    gp.state LIKE '%Tamaulipas%'
GROUP BY Rcuisine , alcohol;

/* None of the restaurants in Tamaulipas serve alcohol. There are no international restaurants in Tamaulipas.
 Further, there are only 6 types of cuisines in Tamaulipas state, compared to other states like san luis potos which have 11 types of cuisines
 */

 
 /*- Finding the average weight, food rating, and service rating of the customers who have visited KFC and
 tried Mexican or Italian types of cuisine, and also their budget level is low.We encourage you to give it a try by not using joins.*/
 
select b.userid,avg(b.weight) as avg_weight , a.food_rating,a.service_rating from userprofile b,
(SELECT 
    placeid, userid, food_rating, service_rating
FROM
    rating_final
WHERE
    placeid IN (SELECT 
            placeid
        FROM
            geoplaces2
        WHERE
            placeid IN (SELECT 
                    placeid
                FROM
                    chefmozcuisine
                WHERE
                    Rcuisine LIKE '%mexican%'
                        OR Rcuisine LIKE '%italian%') 
                AND price LIKE '%low%'))a where a.userid=b.userid group by b.userid ,food_rating,service_rating 
                order by avg_weight desc;
select * from rating_final;
select * from chefmozcuisine;
select * from geoplaces2 where name like "%kfc%";
SELECT 
    up.userid, jp.name,jp.placeid
FROM
    geoplaces2 jp
        INNER JOIN
    rating_final rf ON jp.placeid = rf.placeid
        INNER JOIN
    userprofile up ON rf.userid = up.userid
    where name like "%kfc%";

/*The query used a subquery to filter the data the only include rows where “placeid “is associated with a restaurant that serves Mexican or Italian cuisine, is named “KFC” and has a low price.
But it is seen that there are no customers who have visited KFC and tried Mexican or Italian types of cuisine
*/
-- -----
