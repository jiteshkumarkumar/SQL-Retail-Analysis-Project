--SQL Retail Sales Analysis-- 

create database SQL_Sales_Project;

Use SQL_Sales_Project;

--create table Retail Sales Analysis
drop table if exists [Retail Sales Analysis]
create table [Retail Sales Analysis]
(
          transactions_id Int primary key,	
       sale_date date,
       sale_time time,
       customer_id int,
       gender varchar(10),
       age Int,
      category varchar(15),	
quantiy int,
price_per_unit float,	
cogs float,	
total_sale float
);

--Check the metadata of the table 
EXEC sp_help 'SQL - Retail Sales Analysis_utf ';

--Check the dataset
select  top(10) * from [dbo].[SQL - Retail Sales Analysis_utf ];

--Deal with Null value in the dataset 

select * from [dbo].[SQL - Retail Sales Analysis_utf ] 
where transactions_id is null
	 or
	 sale_date is null
	 or 
	 sale_time is null
	 or 
	 customer_id is null
	 or 
	 gender is null
	 or 
	 age is null
	 or
	 category is null
	 or 
	 quantiy is null
	 or 
	 price_per_unit is null
	 or 
	 cogs is null
	 or 
	 total_sale is null;

-- Found the Null values in Age, Quantity,Price_per_unit, cogs and total_sale

--Duplicate table will be execute to clean the data and further analysis
select * into [Retail Sales Analysis] from [dbo].[SQL - Retail Sales Analysis_utf ];

select * from [Retail Sales Analysis];

-- Deal with appopiate value all the null values
select * from [Retail Sales Analysis] where age is null;

--Age Column--
update [Retail Sales Analysis]
set age = (select avg(age) from [Retail Sales Analysis] ) where age is null;


--Fill the appropiate value instead of null value

update [Retail Sales Analysis]
set quantiy=0,
    price_per_unit=0,
    cogs=0,
    total_sale = 0
where 
    quantiy is null
    or price_per_unit is null
    or cogs is null 
    or total_sale is null;


--Data exploration 
-- How many sales we have 
select sum(total_sale) as sales_count from [Retail Sales Analysis];

--How many unique customer we have
select count(distinct customer_id)  as total_customer from [Retail Sales Analysis];

--Convert the Cogs column provide value till 2 decimal number only.
update [Retail Sales Analysis]
set cogs = ROUND(cogs,2);

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from [Retail Sales Analysis] where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select  * 
        from [Retail Sales Analysis]
where category='Clothing'
      and  
	  sale_date >= '2022-11-01'
	  and
	  sale_date < '2022-12-01'
	  and
	  quantiy >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select  category, sum(total_sale) as total_sales
        from [Retail Sales Analysis]
group by category order by total_sales desc;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select  category, avg(age) as [average age]
        from [Retail Sales Analysis] 
		where category = 'Beauty'
group by category;


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
       from [Retail Sales Analysis] 
where total_sale  > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender, count(transactions_id) as total_transaction
     from [Retail Sales Analysis] 
group by category,gender
order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with cte as(
select DATENAME(month,sale_date) as month_name, YEAR(sale_date) as year_,
     avg(total_sale) as avg_sales
     from [Retail Sales Analysis]
group by DATENAME(month,sale_date),YEAR(sale_date))

,ranked_cte as (select *,
ROW_NUMBER() over(partition by year_ order by avg_sales desc) as rak
from cte)

select month_name,year_,avg_sales
from ranked_cte where rak =1;


-- Q.8 Write a SQL queryrn to find the top 5 customers based on the highest total sales 

select  top(5)
      customer_id, sum(total_sale) as total_sales
	  from [Retail Sales Analysis]
group by customer_id
order by total_sales desc;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select  
      category, count(distinct customer_id) as unique_customer
       from [Retail Sales Analysis]
	   group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_order as (

select *,
       case
	   when datepart(HOUR,sale_time) < 12 then 'Morning'
	   when datepart(HOUR,sale_time) between 12 and 17 then 'Afternoon'
	   else 
	       'Evening'  end as  Shift_
from [Retail Sales Analysis])

select shift_,count(*) as total_orders  from hourly_order group by shift_ ;