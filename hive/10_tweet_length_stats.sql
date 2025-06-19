-- 10. Longueur moyenne des tweets
SELECT 
    ROUND(AVG(length(text)), 2) as avg_tweet_length,
    MIN(length(text)) as min_length,
    MAX(length(text)) as max_length
FROM covid_tweets
WHERE text IS NOT NULL;
