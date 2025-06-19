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
