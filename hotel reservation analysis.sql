SELECT * FROM hotel_reservation;

Use hoteldb;

#1 What is the total number of reservation in the dataset
Select COUNT(*) as No_of_reservations from hotel_reservation;

#2 Which meal plan is most popular among guests?
Select 
	type_of_meal_plan as most_popular_meal_plan
From hotel_reservation 
Group by type_of_meal_plan
Order by Count(*) desc
Limit 1;

#3 What is the average price per room for reservations involving children?
Select 
	no_of_children,
    round(avg(avg_price_per_room),2) as avg_price_per_room
from hotel_reservation where no_of_children > 0
Group by no_of_children
Order by no_of_children asc;

#4 how many reservations were made for the year 2017?
Select 
	Year(arrival_date) as year,
    Count(*) as no_res_made
From hotel_reservation 
Where Year(arrival_date) = 2017 
Group by Year(arrival_date);

# how many reservations were made for the year 2018?
Select 
	Year(arrival_date) as year,
    Count(*) as no_res_made
From hotel_reservation 
Where Year(arrival_date) = 2018 
Group by Year(arrival_date);

#5 What is the most commonly booked roomtype?
Select 
	room_type_reserved as booked_roomtype,
    Count(*) as res_count
From hotel_reservation 
Group by room_type_reserved
Order by Count(*) desc
Limit 1;

#6 How many reservations fall on weekend(no_of_weekend_nights>0)?
Select 
	Count(*) as res_weekend_count 
From hotel_reservation 
Where no_of_weekend_nights > 0;

#7 What is the highest and lowest lead time for reservations?
Select
	max(lead_time) as highest_lead_time,
    min(lead_time) as lowest_lead_time,
    Round(avg(lead_time)) as avg_lead_time
From hotel_reservation;

#8 what is most common market segment type for reservations?
Select
	market_segment_type,
    Count(*) as res_cnt
From hotel_reservation
Group by market_segment_type
Order by res_cnt desc
Limit 1;

#9 How many reservations have a booking status of "Confirmed"?
Select 
	Count(*) as confirmed_booking
From hotel_reservation 
Where booking_status = "Not_canceled";

#10 What is the total number of adults and chidren across all reservations?
Select
	SUM(no_of_adults) as total_no_adults,
    SUM(no_of_children) as total_no_children,
    (SUM(no_of_adults) + SUM(no_of_children)) as total_guests
From hotel_reservation;

#11 What is the average number of weekend nights 
# for reservation involving children?

Select
	round(avg(no_of_weekend_nights)) as avg_weekend_nights
From hotel_reservation
Where no_of_children > 0;

#12 How many reservation were made in each month of the year?
Select
	monthname(arrival_date) as month,
    Count(*) as res_count
From hotel_reservation
Group by Month(arrival_date)
Order by res_count desc;

#13 What is the average number of nights (both weekend and weekday) spent
# by guests for each room type?
Select 
	room_type_reserved as room_type,
	Round(avg(no_of_weekend_nights)) as avg_weekend_nights,
    Round(avg(no_of_week_nights)) as avg_weekday_nights
From hotel_reservation
Group by room_type_reserved;

#14 For reservations involving children, what is the most common room type,
# what is the average price for the that room type?
Select
	room_type_reserved as room_type,
    Count(*) as res_cnt,
    Round(avg(avg_price_per_room),1) as avg_price
From hotel_reservation
Where no_of_children>0
Group by room_type_reserved
Order by res_cnt desc
limit 1;

#15 Find the market segment type that generates 
# the highest average price per room.
Select
	market_segment_type,
    Round(avg(avg_price_per_room),1) as high_avg_price_per_room
From hotel_reservation
Group by market_segment_type
order by high_avg_price_per_room desc
limit 1;


#16 Is there a significant difference in the distribution of 
# booking lead time across different seasons? 

With cte as (
	Select
		lead_time,
		monthname(arrival_date) as month,
		Count(*) as res_count
	From hotel_reservation
	Group by Month(arrival_date)
	Order by Month(arrival_date))
Select 
	month,
	ROUND(Avg(lead_time)) as avg_lead_time,
    res_count
From cte
Group by month
Order by res_count desc;


#17  Which market segment type has the highest number of cancelled reservations? 
# For that segment, how does the average lead time for cancelled bookings 
# compare to the average lead time for confirmed bookings?
With x as (
	Select
		market_segment_type,
		booking_status,
		round(avg(lead_time)) as avg_lead_time,
		Count(*) as res_cnt
	From hotel_reservation
	Where booking_status = 'Canceled'
	Group By market_segment_type
	Order by avg_lead_time desc
	limit 1),
    y as (
		Select
			market_segment_type,
			booking_status,
			round(avg(lead_time)) as avg_lead_time,
			Count(*) as res_cnt
		From hotel_reservation
		Where booking_status = 'Not_canceled' and 
			  market_segment_type = "Online"
		Group By market_segment_type)
select 
	    x.market_segment_type, 
        x.avg_lead_time as cncl_lead_time,
        x.res_cnt as cncl_res_cnt,
        y.avg_lead_time as ntcncl_lead_time,
        y.res_cnt as ntcncl_res_cnt
	from x
	join y
	Using(market_segment_type)

