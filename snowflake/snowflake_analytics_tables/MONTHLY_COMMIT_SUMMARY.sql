CREATE OR REPLACE TABLE BIGDATA_GITHUB.ANALYTICS.MONTHLY_COMMIT_SUMMARY AS
WITH cleaned_commits AS (
    SELECT 
        TO_DATE(commit_at) AS commit_date
    FROM BIGDATA_GITHUB.RAW.COMMIT_LIST_TABLE
    WHERE commit_at IS NOT NULL
),
monthly_counts AS (
    SELECT 
        TO_CHAR(commit_date, 'Mon') AS month,
        COUNT(*) AS monthly_commits
    FROM cleaned_commits
    GROUP BY TO_CHAR(commit_date, 'Mon')
),
total_count AS (
    SELECT COUNT(*) AS total_commits
    FROM cleaned_commits
)
SELECT 
    mc.month,
    mc.monthly_commits,
    ROUND(mc.monthly_commits * 100.0 / tc.total_commits, 2) AS percent_of_total
FROM monthly_counts mc
CROSS JOIN total_count tc
ORDER BY 
  CASE mc.month
    WHEN 'Jan' THEN 1
    WHEN 'Feb' THEN 2
    WHEN 'Mar' THEN 3
    WHEN 'Apr' THEN 4
    WHEN 'May' THEN 5
    WHEN 'Jun' THEN 6
    WHEN 'Jul' THEN 7
    WHEN 'Aug' THEN 8
    WHEN 'Sep' THEN 9
    WHEN 'Oct' THEN 10
    WHEN 'Nov' THEN 11
    WHEN 'Dec' THEN 12
  END;
