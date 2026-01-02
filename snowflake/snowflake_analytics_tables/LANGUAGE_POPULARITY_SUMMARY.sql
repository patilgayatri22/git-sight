CREATE OR REPLACE TABLE BIGDATA_GITHUB.ANALYTICS.LANGUAGE_POPULARITY_TABLE AS
SELECT 
  TO_CHAR(repo_created_at, 'YYYY-MM') AS year_month,
  CASE 
    WHEN LOWER(repo_language) = 'fortran' THEN 'Fortran'
    WHEN LOWER(repo_language) = 'haxe' THEN 'Haxe'
    WHEN LOWER(repo_language) = 'ecl' THEN 'ECL'
    ELSE repo_language
  END AS repo_language,
  COUNT(*) AS user_count
FROM BIGDATA_GITHUB.RAW.REPO_LIST_TABLE
WHERE repo_language IS NOT NULL
GROUP BY 
  TO_CHAR(repo_created_at, 'YYYY-MM'),
  CASE 
    WHEN LOWER(repo_language) = 'fortran' THEN 'Fortran'
    WHEN LOWER(repo_language) = 'haxe' THEN 'Haxe'
    WHEN LOWER(repo_language) = 'ecl' THEN 'ECL'
    ELSE repo_language
  END
ORDER BY year_month, user_count DESC;