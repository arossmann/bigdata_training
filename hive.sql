--
-- Step 1:
-- create database for your user
--
create database <username>;

--
-- Step 2:
-- create the hvac raw table
--
create external table hvac_raw (
  date_str string,
  Time string,
  TargetTemp int,
  ActualTemp int,
  System int,
  SystemAge int,
  BuildingID int
  ) 
 row format delimited fields terminated by ',' location '/user/<username>/HVAC';

--
-- Step 3:
-- create the building table
--
create external table building_raw (
  BuildingID int,
  BuildingMgr string,
  BuildingAge int,
  HVACproduct string,
  Country string
  ) 
 row format delimited fields terminated by ',' location '/user/<username>/building';

--
-- Step 4:
-- create the optimized table for HVAC data
--
CREATE TABLE hvac STORED AS PARQUET AS SELECT * FROM hvac_raw;

--
-- Step 5:
-- create the optimized table for the building data
-- 
CREATE TABLE buildings STORED AS PARQUET AS SELECT * FROM building_raw;

--
-- Step 6:
-- create optimized views
--
CREATE VIEW hvac_temperatures as 
select *, targettemp - actualtemp as temp_diff, 
IF((targettemp - actualtemp) > 5, 'COLD', 
IF((targettemp - actualtemp) < -5, 'HOT', 'NORMAL')) 
AS temprange, 
IF((targettemp - actualtemp) > 5, '1', 
IF((targettemp - actualtemp) < -5, '1', 0)) 
AS extremetemp from hvac;

--
-- Step 7:
-- create combined table
--
create table if not exists hvac_building 
as select h.*, b.country, b.hvacproduct, b.buildingage, b.buildingmgr 
from buildings b join hvac_temperatures h on b.buildingid = h.buildingid;