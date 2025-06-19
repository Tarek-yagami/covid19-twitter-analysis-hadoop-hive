WITH raw_hashtags AS (
    SELECT explode(split(hashtags, ',')) as raw_tag
    FROM covid_tweets
    WHERE hashtags IS NOT NULL AND hashtags != ''
),
normalized AS (
    SELECT lower(
        regexp_replace(
            trim(raw_tag),
            "[\\[\\]'\"]",
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
