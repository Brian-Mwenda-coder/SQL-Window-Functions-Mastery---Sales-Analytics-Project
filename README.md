# SQL-Window-Functions-Mastery---Sales-Analytics-Project

## Project Overview

This repository demonstrates my proficiency in **SQL Window Aggregate Functions** using Microsoft SQL Server. 

I created a realistic **Sales dataset** and applied various window functions to perform advanced analytics such as:

- Running (cumulative) totals
- Moving averages
- Group-level metrics without collapsing rows
- Performance comparisons across regions and salespeople

Window functions are powerful because they allow calculations across a set of rows related to the current row — all while keeping every detail row intact (unlike `GROUP BY`).

This project is part of my journey into **Data Analytics** and serves as a portfolio piece to showcase practical SQL skills for business intelligence and reporting.

## Learning Objectives Achieved

- Understanding the `OVER()` clause
- Using `PARTITION BY` for grouping without aggregation
- Applying `ORDER BY` inside windows for time-based calculations (running totals, moving averages)
- Working with **frame clauses** (`ROWS` vs `RANGE`)
- Combining window aggregates with regular columns for rich insights

## Dataset Description

The `Sales` table contains **20 realistic sales records** from 2024 across 4 regions (**North, South, East, West**) and multiple salespeople.

**Columns:**
- `SaleID` – Unique identifier
- `SaleDate` – Date of the sale
- `Region` – Sales region
- `Salesperson` – Name of the salesperson
- `Amount` – Sale amount (DECIMAL)

The data is spread across January to June 2024, making it ideal for time-series window calculations.

## Quick Start

### 1. Setup
Run the following script in **SQL Server Management Studio (SSMS)** :

```sql
-- Create the Sales table
CREATE TABLE Sales2026 (
    SaleID       INT PRIMARY KEY,
    SaleDate     DATE,
    Region       VARCHAR(20),
    Salesperson  VARCHAR(30),
    Amount       DECIMAL(10, 2)
);

-- Insert sample data
INSERT INTO Sales2026 (SaleID, SaleDate, Region, Salesperson, Amount)
VALUES
    (1,  '2026-01-05', 'North', 'Alice',  1200.50),
    (2,  '2026-01-12', 'North', 'Bob',     850.00),
    -- ... (full INSERT statements - copy from the original script)
    (20, '2026-06-22', 'West',  'Grace',  1700.25);
```

### 2. Key Window Function Examples
Running Total per Region

```sql
-- Running Totals of sales per region (Cummulative sum)

SELECT
	SaleID,
	SaleDate,
	Region,
	Salesperson,
	Amount,
	SUM(Amount) OVER(PARTITION BY Region ORDER BY SaleDate) AS RunningTotalPerRegion
	FROM Sales2026
	ORDER BY Region,SaleDate
```
Average Sale Amount per Region
```sql
-- Average sale amount per region (same for every row in the partition)
SELECT 
    SaleID, Region, Amount,
    AVG(Amount) OVER (PARTITION BY Region) AS AvgAmountPerRegion
FROM Sales2026
ORDER BY Region;
```
Period Moving Average
```sql
Moving average of last 3 sales (overall, using ROWS)
SELECT 
    SaleID, SaleDate, Amount,
    AVG(Amount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvgLast3
FROM Sales2026
ORDER BY SaleDate;
```
Salesperson Performance with % Contribution
```sql
SELECT 
    Salesperson, Region, Amount, SaleDate,
    SUM(Amount) OVER (PARTITION BY Salesperson ORDER BY SaleDate) AS RunningTotalByPerson,
    SUM(Amount) OVER (PARTITION BY Region) AS TotalRegionSales,
    ROUND(100.0 * Amount / SUM(Amount) OVER (PARTITION BY Region), 2) AS PctOfRegion
FROM Sales
ORDER BY Region, Salesperson, SaleDate;
```
### What I Practiced
- Aggregate Window Functions: `SUM(), AVG(), COUNT(), MIN(), MAX()`
- Partitioning by Region and Salesperson
- Ordering within windows for cumulative calculations
- Frame specification using `ROWS BETWEEN`
- Combining multiple window functions in a single query
- Comparing individual rows to group-level metrics

### Technologies Used
- Microsoft SQL Server
- Window Aggregate Functions `(OVER, PARTITION BY, ORDER BY, frame clauses)`
  
### Future Enhancements (Planned)
- Add more advanced window functions `(RANK(), LAG(), LEAD(), NTILE())`
- Include CTEs for complex multi-step analysis
- Performance comparison between window functions and traditional self-joins
- Export results to Power BI for visualization








