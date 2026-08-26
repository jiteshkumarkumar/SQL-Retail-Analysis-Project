# SQL-Retail-Analysis-Project

## Project Overview

**Project Title**: Retail Sales Analysis   
**Database**: `Sales_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.


## Project Structure
```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```


### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.


```sql
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

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2 **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**

```sql
sselect  * 
        from [Retail Sales Analysis]
where category='Clothing'
      and  
	  sale_date >= '2022-11-01'
	  and
	  sale_date < '2022-12-01'
	  and
	  quantiy >=4;
```

3 **Write a SQL query to calculate the total sales (total_sale) for each category.**

```sql
select  category, sum(total_sale) as total_sales
    from [Retail Sales Analysis]
group by category order by total_sales desc;
```

4 **rite a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**
```sql
select  category, avg(age) as [average age]
    from [Retail Sales Analysis] 
    where category = 'Beauty'
group by category;
```


5 **Write a SQL query to find all transactions where the total_sale is greater than 1000.**

```sql
    select *
    from [Retail Sales Analysis] 
    where total_sale  > 1000;
```

6 **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**

```sql
select category,gender, count(transactions_id) as total_transaction
from [Retail Sales Analysis] 
group by category,gender
order by category;
```

7 **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**

```sql
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
```


8 **Write a SQL query to find the top 5 customers based on the highest total sales**

```sql
select  top(5)
customer_id, sum(total_sale) as total_sales
from [Retail Sales Analysis]
group by customer_id
order by total_sales desc;
```


9 **Write a SQL query to find the number of unique customers who purchased items from each category.**

```Sql
select  
category, count(distinct customer_id) as unique_customer
from [Retail Sales Analysis]
group by category;
```

10 **Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)**

```sql
with hourly_order as (
select *,
       case
	   when datepart(HOUR,sale_time) < 12 then 'Morning'
	   when datepart(HOUR,sale_time) between 12 and 17 then 'Afternoon'
	   else 
       'Evening'  end as  Shift_
from [Retail Sales Analysis])
select shift_,count(*) as total_orders  from hourly_order group by shift_ ;
```
## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

-- End Project
