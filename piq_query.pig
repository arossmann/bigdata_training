-- Create a list which user played which track by an artist Filter all data (country not null, gender not null, age not null) 

tracks = LOAD '/data/lastfm-dataset-1k/userid-timestamp-artid-artname-traid-traname.tsv' AS (user_id, timestamp, mb_artist_id, artist_name,
 mb_track_id, track_name);

users = LOAD '/data/lastfm-dataset-1k/userid-profile.tsv' AS (user_id, gender, age: int, country, signup);

users_with_countries = FILTER users BY (country IS NOT NULL);

users_with_gender = FILTER users_with_countries BY (gender IS NOT NULL);

users_with_age = FILTER users_with_gender BY (age IS NOT NULL);

users_data = FOREACH users_with_age GENERATE user_id, country, gender, age;

tracks_data = FOREACH tracks GENERATE user_id, artist_name, track_name;

users_tracks = JOIN tracks_data BY user_id, users_data BY user_id;

users_tracks_data = FOREACH users_tracks GENERATE users_data::user_id, country, gender, age, artist_name, track_name;

STORE users_tracks_data INTO 'users_tracks_data.tsv';

-- Create a list which user played which artist how often Filter all data (country not null, gender not null, age not null) 
artist_plays = LOAD '/data/lastfm-dataset-360K/usersha1-artmbid-artname-plays.tsv' AS (user_id, mb_artist_id, artist_name, plays: int);

users = LOAD '/data/lastfm-dataset-360K/usersha1-profile.tsv' AS (user_id, gender, age: int, country, signup);

users_with_countries = FILTER users BY (country IS NOT NULL);

users_with_gender = FILTER users_with_countries BY (gender IS NOT NULL);

users_with_age = FILTER users_with_gender BY (age IS NOT NULL);

users_data = FOREACH users_with_age GENERATE user_id, country, gender, age;

artist_plays_data = FOREACH artist_plays GENERATE user_id, artist_name, plays;

users_artist_plays = JOIN artist_plays_data BY user_id, users_data BY user_id;

users_artist_plays_data = FOREACH users_artist_plays GENERATE users_data::user_id, country, gender, age, artist_name, plays;

STORE users_artist_plays_data INTO 'users_artist_plays_data.tsv';

