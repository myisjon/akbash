#!/bin/bash
# ==========================================================================
# desc          : mysql sync to ods
# data flow     : db -> ods.o_fyd_b_family_mamber
# created info  : system 2017-05-10
# note          :
# change log    :
# ===========================================================================
### 1.系统参数加载
unset HBASE_CONF_DIR
unset HBASE_HOME
export HADOOP_CLASSPATH=/usr/lib/hadoop-current/lib/*:/usr/lib/tez-current/*:/usr/lib/tez-current/lib/*:/etc/emr/tez-conf:/usr/lib/hadoop-current/lib/*:/usr/lib/tez-current/*:/usr/lib/tez-current/lib/*:/etc/emr/tez-conf:/opt/apps/extra-jars/*:/usr/lib/spark-current/lib/spark-1.6.2-yarn-shuffle.jar:/opt/apps/extra-jars/*:/usr/lib/spark-current/lib/spark-1.6.2-yarn-shuffle.jar


### 2.变量加载
if [ $# -eq 1 ]
then
    cur_date="$(date -d "$1" +%Y-%m-%d)"
else
    cur_date="$(date -d '0 day ago' +%Y-%m-%d)"
fi

echo "cur_date:$cur_date"


### 3.初始化连接数据库
db_name="fyd_zg"
split_symbol="#"

mysql_table_name=b_family_mamber
mysql_db_name=$(awk -F "$split_symbol" -v gloab="$db_name" '{if($1==gloab) {print $2}}' /home/hadoop/db_link/mysql_link.txt |jq '.username' |sed 's/"//g')
mysql_db_pwd=$(awk -F "$split_symbol" -v gloab="$db_name" '{if($1==gloab) {print $2}}' /home/hadoop/db_link/mysql_link.txt |jq '.password' |sed 's/"//g')
mysql_db_con=$(awk -F "$split_symbol" -v gloab="$db_name" '{if($1==gloab) {print $2}}' /home/hadoop/db_link/mysql_link.txt |jq '.host' |sed 's/"//g')
mysql_columns="id,relation,NAME,sex,age,fam_register,cert_no,education,health_status,health_remark,income,profession,company,post,harmful,harmful_remark,creat_time,op_id,cust_no,family_customer_id,reg_property,famregister_code,occupation,occupation_detail,headship,position,unit_address,unit_properties,unit_industry"
hive_table_name="ods.o_${db_name}_${mysql_table_name}"


### 4. 同步数据
echo 'sqoop start'
sqoop import \
--connect "$mysql_db_con" \
--username "$mysql_db_name" \
--password "$mysql_db_pwd" \
--table "$mysql_table_name" \
--columns "$mysql_columns" \
--fields-terminated-by "\t" \
--lines-terminated-by "\n" \
--hive-import \
--hive-overwrite \
--hive-table "$hive_table_name" \
--delete-target-dir \
--hive-drop-import-delims \
--null-string '\\N' \
--null-non-string '\\N'

val=$?
echo "运行状态：${val}"
exit $val

