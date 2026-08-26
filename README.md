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
