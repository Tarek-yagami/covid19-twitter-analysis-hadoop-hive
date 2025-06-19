SELECT 
    substr(tweet_date, 1, 7) AS month,
    COUNT(*) AS tweets_count
FROM covid_tweets
WHERE tweet_date IS NOT NULL
  AND length(tweet_date) >= 7
  AND tweet_date rlike '^[0-9]{4}-[0-9]{2}'
GROUP BY substr(tweet_date, 1, 7)
ORDER BY month;

