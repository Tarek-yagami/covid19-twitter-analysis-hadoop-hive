DROP TABLE IF EXISTS covid_tweets;

CREATE EXTERNAL TABLE covid_tweets (
    user_name STRING,
    user_location STRING,
    user_description STRING,
    user_created STRING,
    user_followers INT,
    user_friends INT,
    user_favourites INT,
    user_verified STRING,
    tweet_date STRING,
    text STRING,
    hashtags STRING,
    source STRING,
    is_retweet STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = ",",
    "quoteChar" = "\"",
    "escapeChar" = "\\"
)
STORED AS TEXTFILE
LOCATION '/user/tarek/data/covid_tweets/'
TBLPROPERTIES ('skip.header.line.count'='1')
