#!/bin/bash


# dim.dim_pub_city
hive -e "LOAD DATA LOCAL INPATH '/home/hadoop/temp/dim_pub_city.txt' OVERWRITE INTO TABLE dim.dim_pub_city;"

#UPDATE dim_pub_date t1 INNER JOIN dim_date_holiday t2 ON t1.atdate = t2.atdate SET t1.is_holiday = t2.is_holiday;