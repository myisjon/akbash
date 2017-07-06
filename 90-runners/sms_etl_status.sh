#!/bin/bash
# ==========================================================================
# desc          : etl执行失败，发送短信
# data flow     : ods -> dim
# created info  : jiabinjie 2017-04-07
# note          : 
# exec example  : bash sms_etl_status.sh [2017-04-10]
# change log    :
# ===========================================================================

function get_exec_msg(){

    local host='114.55.232.8'
    local user='root'
    local psd='EMRroot1234'

    
    # -N，获取的数据信息省去列名称
    mysql_con="mysql -h$host -u$user -p$psd --default-character-set=utf8 -N"

    
    sql_str="USE azkaban;
        CALL etl_err_sms('$1','$2')
    ;"

    status_msg="$($mysql_con -e "$sql_str")"
}

function send_sms(){

    local md5_sign=''
    local t=$(date +%s)
    local appkey='h90C8gaBnmJ5'
    local app_secret='2pWgSdBZGZeKer1m'
    # local appkey='FwbEl4vogjRp'
    # local app_secret='KS8ARqWBKwO2MeEU'

    local postdata='{"header":{},"body":{"mobile":'"$mobile"',"msg":"'"$status_msg"'","mode":"alert"}}'
    
    md5=$(echo -n  "$t$app_secret$postdata"  | openssl md5 | awk -F ' ' '{print $2}')
    md5_sign=${md5:0:12}
    
    local apiurl="localhost"


    sms_result=$(curl -H "Content-Type: application/json" -X POST --data "$postdata" "$apiurl")


}

main() {
    declare mobile_group="18911115678"
    local status_msg='hello etl MassSMS'
    local mobile

    local cur_day=$(date -d now +%Y-%m-%d)
    local sms_result='init'

    if [[ ! -z $1 ]];then
        cur_day="$1"
    fi

    get_exec_msg "$cur_day" 'init'

    # echo "$status_msg"

    if [[ "$status_msg" == "" ]] || [[ "$status_msg" == 'NULL' ]]; then
        echo "etl is OK"
    else
        for mobile in $mobile_group; do
            send_sms
        done
        get_exec_msg "$cur_day" "$sms_result"
    fi

}

main "$@"
