-- 1. Nombre total de tweets
SELECT COUNT(*) as total_tweets 
FROM covid_tweets;

-- 2. Nombre de tweets par jour (top 10)
SELECT 
    substr(tweet_date, 1, 10) as date_only,
    COUNT(*) as tweets_count
FROM covid_tweets
WHERE tweet_date IS NOT NULL
GROUP BY substr(tweet_date, 1, 10)
ORDER BY tweets_count DESC
LIMIT 10;

-- 3. Hashtags les plus fréquents
WITH raw_hashtags AS (
    SELECT explode(split(hashtags, ',')) as raw_tag
    FROM covid_tweets
    WHERE hashtags IS NOT NULL AND hashtags != ''
),
normalized AS (
    SELECT lower(
        regexp_replace(
            trim(raw_tag),
            "[\\[\\]'\']",
            ""
        )
    ) as hashtag
    FROM raw_hashtags
    WHERE raw_tag != '' AND raw_tag IS NOT NULL
)
SELECT hashtag, COUNT(*) as frequency
FROM normalized
WHERE hashtag != '' 
GROUP BY hashtag
ORDER BY frequency DESC
LIMIT 20


-- 4. Analyse des mots-clés COVID dans le texte
SELECT 
    'COVID-19' as keyword,
    COUNT(*) as mentions
FROM covid_tweets
WHERE lower(text) LIKE '%covid%' OR lower(text) LIKE '%coronavirus%'

UNION ALL

SELECT 
    'Vaccine' as keyword,
    COUNT(*) as mentions
FROM covid_tweets
WHERE lower(text) LIKE '%vaccine%' OR lower(text) LIKE '%vaccination%'

UNION ALL

SELECT 
    'Mask' as keyword,
    COUNT(*) as mentions
FROM covid_tweets
WHERE lower(text) LIKE '%mask%'

UNION ALL

SELECT 
    'Lockdown' as keyword,
    COUNT(*) as mentions
FROM covid_tweets
WHERE lower(text) LIKE '%lockdown%';

-- 5. Distribution des tweets par type de source
SELECT 
    source,
    COUNT(*) as tweet_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM covid_tweets), 2) as percentage
FROM covid_tweets
WHERE source IS NOT NULL
GROUP BY source
ORDER BY tweet_count DESC
LIMIT 10;

-- 6. Analyse des retweets vs tweets originaux
SELECT 
    CASE WHEN is_retweet = true THEN 'Retweets' ELSE 'Original Tweets' END as tweet_type,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM covid_tweets), 2) as percentage
FROM covid_tweets
GROUP BY is_retweet;

-- 7. Top 10 des utilisateurs les plus actifs
SELECT 
    user_name,
    COUNT(*) as tweet_count,
    MAX(user_followers) AS user_followers,
    MAX(user_verified) AS user_verified
FROM covid_tweets
WHERE user_name IS NOT NULL AND user_followers IS NOT NULL  AND user_verified IS NOT NU>
GROUP BY user_name
ORDER BY tweet_count DESC
LIMIT 10;

-- 8. Analyse des comptes vérifiés
SELECT 
    user_verified,
    COUNT(*) as count,
    ROUND(AVG(user_followers), 0) as avg_followers,
    ROUND(AVG(user_friends), 0) as avg_friends
FROM covid_tweets
WHERE user_verified IS NOT NULL
GROUP BY user_verified;


-- 9. Tweets par mois
SELECT 
    substr(tweet_date, 1, 7) AS month,
    COUNT(*) AS tweets_count
FROM covid_tweets
WHERE tweet_date IS NOT NULL
  AND length(tweet_date) >= 7
  AND tweet_date rlike '^[0-9]{4}-[0-9]{2}'
GROUP BY substr(tweet_date, 1, 7)
ORDER BY month;


-- 10. Longueur moyenne des tweets
SELECT 
    ROUND(AVG(length(text)), 2) as avg_tweet_length,
    MIN(length(text)) as min_length,
    MAX(length(text)) as max_length
FROM covid_tweets
WHERE text IS NOT NULL;
