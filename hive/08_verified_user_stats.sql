-- 8. Analyse des comptes vérifiés
SELECT 
    user_verified,
    COUNT(*) as count,
    ROUND(AVG(user_followers), 0) as avg_followers,
    ROUND(AVG(user_friends), 0) as avg_friends
FROM covid_tweets
WHERE user_verified IS NOT NULL
GROUP BY user_verified;
