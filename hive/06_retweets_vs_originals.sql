SELECT 
    CASE WHEN is_retweet = true THEN 'Retweets' ELSE 'Original Tweets' END as tweet_type,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM covid_tweets), 2) as percentage
FROM covid_tweets
GROUP BY is_retweet;
