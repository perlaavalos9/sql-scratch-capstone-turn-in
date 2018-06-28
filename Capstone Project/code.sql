--First need to know the number of distinct campaigns
SELECT COUNT(DISTINCT utm_campaign), COUNT(DISTINCT utm_source)
FROM page_visits;
  
--Second list the distinct campaign names and distinct source names
SELECT DISTINCT utm_campaign
FROM page_visits;
  
SELECT DISTINCT utm_source
FROM page_visits;

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

SELECT DISTINCT page_name
FROM page_visits;

--number of first touches per campaign
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    COUNT(ft.first_touch_at),
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
 GROUP BY pv.utm_campaign;
 
 --number of last touches per campaign
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
    COUNT(lt.last_touch_at),
    pv.utm_source,
		pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
 GROUP BY pv.utm_campaign;
 
 -- how may visitors make a purchase 
SELECT COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase';

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
    COUNT(lt.last_touch_at),
    pv.utm_source,
		pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
 WHERE page_name = '4 - purchase'   
 GROUP BY pv.utm_campaign;

 -- how many visitors does CoolTShirts had 
SELECT COUNT(DISTINCT user_id) AS Total_visitors
FROM page_visits; 

-- CoolTShirt Marketing campaigns success rate
SELECT 1.0* 
(
  SELECT COUNT(DISTINCT user_id) 
  FROM page_visits
  WHERE page_name = '4 - purchase'
)/(	
  SELECT COUNT(DISTINCT user_id)
  FROM page_visits
 ) AS success_rate;

-- at wich step of the user journey CoolTShirt loose the most customers
  SELECT COUNT(DISTINCT user_id) AS landing_page_visitors
  FROM page_visits
  WHERE page_name = '1 - landing_page';
    
  SELECT COUNT(DISTINCT user_id) AS shopping_cart_visitors
  FROM page_visits
  WHERE page_name = '2 - shopping_cart';
  
  SELECT COUNT(DISTINCT user_id) AS chechout_visitors
  FROM page_visits
  WHERE page_name = '3 - checkout';
  
  SELECT COUNT(DISTINCT user_id) AS total_purchases
  FROM page_visits
  WHERE page_name = '4 - purchase';