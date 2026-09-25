SELECT 
    sale_date,
    region,
    product_line,
    revenue_ngn,
    -- Running total revenue by region over time
    SUM(revenue_ngn) OVER(
        PARTITION BY region 
        ORDER BY sale_date
    ) AS cumulative_region_revenue,
    -- Rank revenue days within each region
    DENSE_RANK() OVER(
        PARTITION BY region 
        ORDER BY revenue_ngn DESC
    ) AS regional_revenue_rank
FROM regional_sales;

-- Query 2: Filtering Top Performers using a CTE
WITH ranked_daily_sales AS (
    SELECT 
        sale_date,
        region,
        product_line,
        revenue_ngn,
        DENSE_RANK() OVER(
            PARTITION BY region 
            ORDER BY revenue_ngn DESC
        ) AS rank_in_region
    FROM regional_sales
)
SELECT 
    region,
    rank_in_region,
    sale_date,
    product_line,
    revenue_ngn
FROM ranked_daily_sales
WHERE rank_in_region <= 3
ORDER BY region, rank_in_region;

-- Query 3: Month-over-Month Growth by Product Line using LAG()
WITH monthly_summary AS (
    SELECT 
        DATE_TRUNC('month', sale_date)::DATE AS sales_month,
        product_line,
        ROUND(SUM(revenue_ngn), 2) AS monthly_revenue
    FROM regional_sales
    GROUP BY 1, 2
)
SELECT 
    sales_month,
    product_line,
    monthly_revenue,
    -- Pull previous month's revenue for the same product
    LAG(monthly_revenue, 1) OVER(
        PARTITION BY product_line 
        ORDER BY sales_month
    ) AS prev_month_revenue,
    -- Calculate MoM Growth Percentage
    ROUND(
        ((monthly_revenue - LAG(monthly_revenue, 1) OVER(
            PARTITION BY product_line ORDER BY sales_month
        )) / LAG(monthly_revenue, 1) OVER(
            PARTITION BY product_line ORDER BY sales_month
        )) * 100, 2
    ) AS mom_growth_pct
FROM monthly_summary
ORDER BY product_line, sales_month;

