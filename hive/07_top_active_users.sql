-- 7. Top 10 des utilisateurs les plus actifs
SELECT 
    user_name,
    COUNT(*) as tweet_count,
    MAX(user_followers) AS user_followers,
    MAX(user_verified) AS user_verified
FROM covid_tweets
WHERE user_name IS NOT NULL AND user_followers IS NOT NULL  AND user_verified IS NOT NULL
GROUP BY user_name
ORDER BY tweet_count DESC
LIMIT 10;
