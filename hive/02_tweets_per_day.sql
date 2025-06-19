-- 2. Nombre de tweets par jour (top 10)
SELECT 
    substr(tweet_date, 1, 10) as date_only,
    COUNT(*) as tweets_count
FROM covid_tweets
WHERE tweet_date IS NOT NULL
GROUP BY substr(tweet_date, 1, 10)
ORDER BY tweets_count DESC
LIMIT 10;
