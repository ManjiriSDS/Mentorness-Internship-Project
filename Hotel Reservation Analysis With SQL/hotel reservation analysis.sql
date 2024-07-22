SELECT * FROM hotel_reservation;

Use hoteldb;

#1 What is the total number of reservation in the dataset

SELECT 
    COUNT(*) AS No_of_reservations
FROM hotel_reservation;


#2 Which meal plan is most popular among guests?
SELECT 
    type_of_meal_plan AS most_popular_meal_plan
FROM hotel_reservation
GROUP BY type_of_meal_plan
ORDER BY COUNT(*) DESC
LIMIT 1;


#3 What is the average price per room for reservations involving children?

SELECT 
    no_of_children,
    ROUND(AVG(avg_price_per_room), 2) AS avg_price_per_room
FROM hotel_reservation
WHERE no_of_children > 0
GROUP BY no_of_children
ORDER BY no_of_children ASC;


#4 how many reservations were made for the year 2017?

SELECT 
    YEAR(arrival_date) AS year,
    COUNT(*) AS no_res_made
FROM hotel_reservation
WHERE YEAR(arrival_date) = 2017
GROUP BY YEAR(arrival_date);

# how many reservations were made for the year 2018?

SELECT 
    YEAR(arrival_date) AS year, 
    COUNT(*) AS no_res_made
FROM hotel_reservation
WHERE YEAR(arrival_date) = 2018
GROUP BY YEAR(arrival_date);


#5 What is the most commonly booked roomtype?

SELECT 
    room_type_reserved AS booked_roomtype, 
    COUNT(*) AS res_count
FROM hotel_reservation
GROUP BY room_type_reserved
ORDER BY COUNT(*) DESC
LIMIT 1;


#6 How many reservations fall on weekend(no_of_weekend_nights>0)?

SELECT 
    COUNT(*) AS res_weekend_count
FROM hotel_reservation
WHERE no_of_weekend_nights > 0;


#7 What is the highest and lowest lead time for reservations?

SELECT 
    MAX(lead_time) AS highest_lead_time,
    MIN(lead_time) AS lowest_lead_time,
    ROUND(AVG(lead_time)) AS avg_lead_time
FROM
    hotel_reservation;

#8 what is most common market segment type for reservations?

SELECT 
    market_segment_type, 
    COUNT(*) AS res_cnt
FROM hotel_reservation
GROUP BY market_segment_type
ORDER BY res_cnt DESC
LIMIT 1;


#9 How many reservations have a booking status of "Confirmed"?

SELECT 
    COUNT(*) AS confirmed_booking
FROM hotel_reservation
WHERE booking_status = 'Not_canceled';


#10 What is the total number of adults and chidren across all reservations?

SELECT 
    SUM(no_of_adults) AS total_no_adults,
    SUM(no_of_children) AS total_no_children,
    (SUM(no_of_adults) + SUM(no_of_children)) AS total_guests
FROM hotel_reservation;


#11 What is the average number of weekend nights 
# for reservation involving children?

SELECT 
    ROUND(AVG(no_of_weekend_nights)) AS avg_weekend_nights
FROM hotel_reservation
WHERE no_of_children > 0;


#12 How many reservation were made in each month of the year?

SELECT 
    MONTHNAME(arrival_date) AS month, 
    COUNT(*) AS res_count
FROM hotel_reservation
GROUP BY MONTH(arrival_date)
ORDER BY res_count DESC;


#13 What is the average number of nights (both weekend and weekday) spent
# by guests for each room type?

SELECT 
    room_type_reserved AS room_type,
    ROUND(AVG(no_of_weekend_nights)) AS avg_weekend_nights,
    ROUND(AVG(no_of_week_nights)) AS avg_weekday_nights
FROM hotel_reservation
GROUP BY room_type_reserved;


#14 For reservations involving children, what is the most common room type,
# what is the average price for the that room type?

SELECT 
    room_type_reserved AS room_type,
    COUNT(*) AS res_cnt,
    ROUND(AVG(avg_price_per_room), 1) AS avg_price
FROM hotel_reservation
WHERE no_of_children > 0
GROUP BY room_type_reserved
ORDER BY res_cnt DESC
LIMIT 1;


#15 Find the market segment type that generates 
# the highest average price per room.

SELECT 
    market_segment_type,
    ROUND(AVG(avg_price_per_room), 1) AS high_avg_price_per_room
FROM hotel_reservation
GROUP BY market_segment_type
ORDER BY high_avg_price_per_room DESC
LIMIT 1;


#16 Is there a significant difference in the distribution of 
# booking lead time across different seasons? 

WITH cte AS (
	SELECT
		lead_time,
		monthname(arrival_date) AS month,
		Count(*) as res_count
	FROM hotel_reservation
	GROUP BY MONTH(arrival_date)
	ORDER BY MONTH(arrival_date))
SELECT
	month,
	ROUND(AVG(lead_time)) as avg_lead_time,
    res_count
FROM cte
GROUP BY MONTH
ORDER BY res_count desc;


#17  Which market segment type has the highest number of cancelled reservations? 
# For that segment, how does the average lead time for cancelled bookings 
# compare to the average lead time for confirmed bookings?

WITH x AS (
	SELECT
		market_segment_type,
		booking_status,
		ROUND(AVG(lead_time)) AS avg_lead_time,
		COUNT(*) AS res_cnt
	FROM hotel_reservation
	WHERE booking_status = 'Canceled'
	GROUP BY market_segment_type
	ORDER BY avg_lead_time DESC
	LIMIT 1),
    y AS (
		SELECT
			market_segment_type,
			booking_status,
			ROUND(AVG(lead_time)) AS avg_lead_time,
			COUNT(*) AS res_cnt
		FROM hotel_reservation
		WHERE booking_status = 'Not_canceled' AND
			  market_segment_type = "Online"
		GROUP BY market_segment_type)
SELECT 
	    x.market_segment_type, 
        x.avg_lead_time AS cncl_lead_time,
        x.res_cnt AS cncl_res_cnt,
        y.avg_lead_time AS ntcncl_lead_time,
        y.res_cnt AS ntcncl_res_cnt
	FROM x
	JOIN y
	USING (market_segment_type)

