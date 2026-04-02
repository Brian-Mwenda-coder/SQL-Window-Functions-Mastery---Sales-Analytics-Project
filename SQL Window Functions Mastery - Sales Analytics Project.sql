-- =============================================
-- Sample Dataset for Practicing Window Aggregate Functions in SQL Server
-- =============================================
-- This table contains sales data across 4 regions, multiple salespeople,
-- and dates in 2024. It's designed specifically for window functions:
--   - SUM(), AVG(), COUNT(), MIN(), MAX() ... OVER()
--   - PARTITION BY (e.g., by Region or Salesperson)
--   - ORDER BY (for running totals, moving averages)
--   - ROWS vs RANGE frame clauses
-- Perfect for learning running totals, cumulative sums, averages per group, etc.

CREATE TABLE Sales2026 (
    SaleID       INT PRIMARY KEY,
    SaleDate     DATE,
    Region       VARCHAR(20),
    Salesperson  VARCHAR(30),
    Amount       DECIMAL(10, 2)
);

-- Populate the sample data (20 realistic rows)
INSERT INTO Sales2026 (SaleID, SaleDate, Region, Salesperson, Amount)
VALUES
    (1,  '2026-01-05', 'North', 'Alice',  1200.50),
    (2,  '2026-01-12', 'North', 'Bob',     850.00),
    (3,  '2026-01-20', 'North', 'Alice',  2300.75),
    (4,  '2026-02-03', 'South', 'Charlie', 950.00),
    (5,  '2026-02-10', 'South', 'Dana',   1800.25),
    (6,  '2026-02-18', 'South', 'Charlie',1400.00),
    (7,  '2026-03-01', 'East',  'Eve',    2100.00),
    (8,  '2026-03-08', 'East',  'Frank',  1750.50),
    (9,  '2026-03-15', 'East',  'Eve',     900.00),
    (10, '2026-03-22', 'West',  'Grace',  1600.75),
    (11, '2026-04-05', 'West',  'Henry',  2200.00),
    (12, '2026-04-12', 'West',  'Grace',  1300.00),
    (13, '2026-04-19', 'North', 'Bob',    1100.25),
    (14, '2026-05-02', 'North', 'Alice',  1950.00),
    (15, '2026-05-10', 'South', 'Dana',    800.00),
    (16, '2026-05-17', 'South', 'Charlie',2500.50),
    (17, '2026-06-01', 'East',  'Frank',  1400.75),
    (18, '2026-06-08', 'East',  'Eve',    1850.00),
    (19, '2026-06-15', 'West',  'Henry',   900.00),
    (20, '2026-06-22', 'West',  'Grace',  1700.25);

	SELECT* FROM Sales2026 ORDER BY SaleDate, Region

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


-- 2. Average sale amount per region (same for every row in the partition)
SELECT 
    SaleID, Region, Amount,
    AVG(Amount) OVER (PARTITION BY Region) AS AvgAmountPerRegion
FROM Sales2026
ORDER BY Region;

-- 3. Moving average of last 3 sales (overall, using ROWS)
SELECT 
    SaleID, SaleDate, Amount,
    AVG(Amount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvgLast3
FROM Sales2026
ORDER BY SaleDate;

-- 4. Total sales across the whole dataset as a window (no partition)
SELECT 
    SaleID, Region, Amount,
    SUM(Amount) OVER () AS GrandTotal
FROM Sales2026;

---Salesperson Performance with % Contribution
SELECT 
    Salesperson, Region, Amount, SaleDate,
    SUM(Amount) OVER (PARTITION BY Salesperson ORDER BY SaleDate) AS RunningTotalByPerson,
    SUM(Amount) OVER (PARTITION BY Region) AS TotalRegionSales,
    ROUND(100.0 * Amount / SUM(Amount) OVER (PARTITION BY Region), 2) AS PctOfRegion
FROM Sales2026
ORDER BY Region, Salesperson, SaleDate;