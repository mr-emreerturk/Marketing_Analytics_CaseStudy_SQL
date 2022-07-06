# Q1: Which film title was the most recommended for all customers?
WITH all_recommendations AS (
  SELECT
    title
  FROM
    category_recommendations
  UNION ALL
  SELECT
    title
  FROM
    actor_recommendations
)
SELECT
  title,
  COUNT(*) AS recommendations
FROM
  all_recommendations
GROUP BY
  1
ORDER BY
  2 DESC;

# Q2: How many customers were included in the email campaign?
SELECT COUNT(*) FROM final_data_asset;

# Q3: Out of all the possible films - what percentage coverage do we have in our recommendations? (total unique films recommended divided by total available films)
WITH all_recommendations AS (
  SELECT
    title
  FROM
    category_recommendations
  UNION
  SELECT
    title
  FROM
    actor_recommendations
),
recommendations AS (
  SELECT
    COUNT(DISTINCT title) AS _count
  FROM
    all_recommendations
),
all_films AS (
  SELECT
    COUNT(DISTINCT title) AS _count
  FROM
    dvd_rentals.film
)
SELECT
  all_films._count AS all,
  recommendations._count AS recommended,
  ROUND(
    100 * recommendations._count :: NUMERIC / all_films._count :: NUMERIC
  ) AS coverage_percentage
FROM
  recommendations
  CROSS JOIN all_films;

# Q4: What is the most popular top category?
SELECT
  category_name,
  COUNT(*) AS category_count
FROM
  first_category_insights
GROUP BY
  1
ORDER BY
  2 DESC
Limit
  1;

#Q5: What is the 4th most popular top category?
WITH ranked_cte AS (
  SELECT
    category_name,
    COUNT(*) AS category_count,
    ROW_NUMBER() OVER (
      ORDER BY
        COUNT(*) DESC
    ) AS category_rank
  FROM
    first_category_insights
  GROUP BY
    1
)
SELECT
  *
FROM
  ranked_cte
WHERE
  category_rank = 4;

# Q6: What is the average percentile ranking for each customer in their top category rounded to the nearest 2 decimal places? Hint: be careful of your data types!
SELECT
  ROUND(AVG(percentile :: NUMERIC), 2)
FROM
  first_category_insights;

#Q7: What is the cumulative distribution of the top 5 percentile values for the top category from the first_category_insights table rounded to the nearest round percentage?
SELECT
  ROUND(percentile) AS percentile,
  COUNT(*),
  ROUND(
    100 * CUME_DIST() OVER (
      ORDER BY
        ROUND(percentile)
    )
  ) AS cumulative_distribution
FROM
  first_category_insights
GROUP BY
  1
ORDER BY
  1

#Q8: What is the median of the second category percentage of entire viewing history?
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (
    ORDER BY
      total_percentage
  ) AS median_percentage
FROM
  second_category_insights;

#Q9: What is the 80th percentile of films watched featuring each customer's favourite actor?
SELECT
  PERCENTILE_CONT(0.8) WITHIN GROUP (
    ORDER BY
      rental_count
  ) AS p80_rental_count
FROM
  top_actor_counts;

#Q10: What was the average number of films watched by each customer rounded to the nearest whole number?
SELECT
  ROUND(AVG(total_count)) AS avg_count
FROM
  total_counts

#Q11: What is the top combination of top 2 categories and how many customers if the order is relevant?
SELECT
  cat_1,
  cat_2,
  COUNT(*) AS customer_count
FROM
  final_data_asset
GROUP BY
  cat_1,
  cat_2
ORDER BY
  3 DESC
LIMIT
  5;

#Q12: Which actor was the most popular for all customers?
SELECT
  actor,
  COUNT(*) AS customer_count
FROM
  final_data_asset
GROUP BY
  1
ORDER BY
  2 DESC;

#Q13: How many films on average had customers already seen that feature their favourite actor rounded to closest integer?
SELECT
  ROUND(AVG(rental_count))
FROM
  top_actor_counts;



















