# create directory
Create the directories in your users home directory, in which we can upload our files.

We need two directories:
- building
- HVAC

# upload files
Go to File Browser > Upload and put the files in their appropriate directories.

# create external tables
Create the external tables for our buildings and HVAC data.
## HVAC
```
-- create the hvac raw table
create external table hvac_raw (
  date_str string,
  Time string,
  TargetTemp int,
  ActualTemp int,
  System int,
  SystemAge int,
  BuildingID int
  ) 
 row format delimited fields terminated by ',' location '/user/cloudera/HVAC';
```

## building
```
 -- create the building table
 create external table building_raw (
  BuildingID int,
  BuildingMgr string,
  BuildingAge int,
  HVACproduct string,
  Country string
  ) 
 row format delimited fields terminated by ',' location '/user/cloudera/building';
```

# Creating derived tables, optimized for analytics

create internal tables, managed by Hive with optimized storage format
## HVAC
```
-- create the hvac internal table
create table hvac (
  date_str string,
  Time string,
  TargetTemp int,
  ActualTemp int,
  System int,
  SystemAge int,
  BuildingID int
  ) 
 stored as parquet location '/user/cloudera/hvac_analytics/HVAC';

 -- load the data
 insert into hvac select * from hvac_raw;
```

## building
```
 -- create the building table
 create  table building (
  BuildingID int,
  BuildingMgr string,
  BuildingAge int,
  HVACproduct string,
  Country string
  ) 
 stored as parquet location '/user/cloudera/hvac_analytics/building';

-- load the data
 insert into building select * from building_raw;

```
# Compare File Size
compare the size of files in /user/cloudera/HVAC and /user/cloudera/hvac_analytics/HVAC

# Creating optimized views
create the View hvac_temperaturesm which gives us an indicator for the temperature
```
CREATE VIEW hvac_temperatures as 
select *, targettemp - actualtemp as temp_diff, 
IF((targettemp - actualtemp) > 5, 'COLD', 
IF((targettemp - actualtemp) < -5, 'HOT', 'NORMAL')) 
AS temprange, 
IF((targettemp - actualtemp) > 5, '1', 
IF((targettemp - actualtemp) < -5, '1', 0)) 
AS extremetemp from hvac;
```
The table hvac_building is a merged table between the hvac_temperature and the buildings. This can be used in Analytics and Visualization applications.
```
create table if not exists hvac_building 
as select h.*, b.country, b.hvacproduct, b.buildingage, b.buildingmgr 
from buildings b join hvac_temperatures h on b.buildingid = h.buildingid;
```
