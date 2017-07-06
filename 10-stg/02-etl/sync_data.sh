#!/bin/bash
# ==========================================================================
# desc          : 自动创建sqoop脚本同步数据
# data flow     : ods -> dim
# created info  : system 2017-0*-**
# note          :
# exec example  : bash sync_data.sh
# change log    :
# ===========================================================================
function init_conn(){

    db_name="fyd_zg"

    if [[ ! -z $1 ]];then
        db_name="$1"
    fi

    split_symbol="#"

    mysql_table_name=b_cust_message

    db_user=$(awk -F "$split_symbol" -v gloab="$db_name" '{if($1==gloab) {print $2}}' /home/hadoop/db_link/mysql_link.txt |jq '.username' |sed 's/"//g')
    db_pwd=$(awk -F "$split_symbol" -v gloab="$db_name" '{if($1==gloab) {print $2}}' /home/hadoop/db_link/mysql_link.txt |jq '.password' |sed 's/"//g')
    db_conn_url=$(awk -F "$split_symbol" -v gloab="$db_name" '{if($1==gloab) {print $2}}' /home/hadoop/db_link/mysql_link.txt |jq '.host' |sed 's/"//g')
    db_host=$(echo "${db_conn_url:13}" | awk -F ":" '{print $1}')
    db_port=$(echo "${db_conn_url:13}" | awk -F ":" '{print $2}' | awk -F "/" '{print $1}')

    echo -e  "$db_user \n $db_pwd \n $db_conn_url \n  $db_host \n $db_port"

    mysql_conn="mysql -h$db_host -P$db_port -u$db_user -p$db_pwd --default-character-set=utf8  -N"

    echo "output"
}


function get_columns(){

    #local host='114.55.232.8'
    #local user='root'
    #local psd='EMRroot1234'
    #local db_name='information_schema'

    # -N，获取的数据信息省去列名称
    #mysql_conn="mysql -h$host -u$user -p$psd --default-character-set=utf8 -D$db_name -N"

    sql="
        SELECT column_name
            -- ,
            -- CASE WHEN data_type in ('char','varchar') then 'STRING' ELSE column_type END AS column_type,
            -- column_comment
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA='gateway'
            AND TABLE_NAME='dl_bills'
    ;"

    columns_info="$($mysql_conn -e "$sql")"

    mysql_columns=$(echo "$columns_info" | sed ':dn;N;s/\n/,/;b dn')

}

function generate_script(){
    
    sql="
        SELECT column_name
            -- ,
            -- CASE WHEN data_type in ('char','varchar') then 'STRING' ELSE column_type END AS column_type,
            -- column_comment
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA='gateway'
            AND TABLE_NAME='dl_bills'
    ;"

    columns_info="$($mysql_conn -e "$sql")"

    mysql_columns=$(echo "$columns_info" | sed ':dn;N;s/\n/,/;b dn')

}


main() {
    local db_user
    local db_pwd
    local db_conn_url
    local db_host
    local db_port
    local mysql_conn
    local -a db_info

    init_conn
    get_columns

    db_info=(${db_info[*]} test)
    bash sqoop_mysql_to_hive.sh "${db_info[@]}"
    
    echo "$columns_info" | tr "\n" ","
    echo "$mysql_columns"
}

main "$@"
