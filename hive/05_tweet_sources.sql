SELECT 
    source,
    COUNT(*) as tweet_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM covid_tweets), 2) as percentage
FROM covid_tweets
WHERE source IS NOT NULL
GROUP BY source
ORDER BY tweet_count DESC
LIMIT 10;
