create or replace TABLE BIGDATA_GITHUB.ANALYTICS.TOP_COMPANY_ACTIVITY_SUMMARY (
	COMPANY VARCHAR(16777216),
	LOCATION VARCHAR(16777216),
	ACTIVITY_SCORE FLOAT
);

-- SQL Equivalent


-- 1. Count commits per user
WITH commit_counts AS (
  SELECT
    committer_id,
    COUNT(*) AS commit_count
  FROM commits
  WHERE YEAR(generate_at) BETWEEN 2008 AND 2018
  GROUP BY committer_id
)
SELECT * FROM commit_counts;
-- 2. Join with users and compute activity score
users_enriched AS (
  SELECT
    LOWER(TRIM(REPLACE(u.company, '@', ''))) AS company_cleaned,
    LOWER(TRIM(u.location)) AS location,
    COALESCE(c.commit_count, 0) AS commit_count,  
    u.public_repos,
    u.followers,
    u.public_gists,
    (
      3 * COALESCE(c.commit_count, 0) +
      2 * u.public_repos +
      1 * u.followers +
      0.5 * u.public_gists
    ) AS activity_score
  FROM users_with_score u
  LEFT JOIN commit_counts c ON u.id = c.committer_id
  WHERE u.company IS NOT NULL AND TRIM(LOWER(u.company)) NOT IN ('', 'none')
),
	
-- 3. Sum activity score per company
company_scores AS (
  SELECT
    company_cleaned,
    SUM(activity_score) AS total_activity_score
  FROM users_enriched
  GROUP BY company_cleaned
),

-- 4. Find most common location per company
location_mode AS (
  SELECT
    company_cleaned,
    location,
    ROW_NUMBER() OVER (PARTITION BY company_cleaned ORDER BY COUNT(*) DESC) AS
    row_num
  FROM users_enriched
  WHERE location IS NOT NULL AND location != ''
  GROUP BY company_cleaned, location
)

-- 5. Final output: top 20 companies with top location
SELECT
  cs.company_cleaned AS company,
  cs.total_activity_score,
  lm.location
FROM
  company_scores cs
LEFT JOIN
  location_mode lm
  ON cs.company_cleaned = lm.company_cleaned AND lm.row_num = 1
ORDER BY
  cs.total_activity_score DESC  
LIMIT 20;
