#!/bin/bash
# ==========================================================================
# desc          : 增量维度数据加载
# data flow     : ods -> dim
# created info  : jiabinjie 2017-04-05
# note          : 
# exec example  : bash load_dim_data.sh [bash]
# change log    :
# ===========================================================================
cd "$(dirname "$0")" || exit 1

function run_sh(){

    local loop_cnt=0

    if [[ ! -z $1 ]];then
        loop_cnt="$1"
    fi

    for ((i=0; i<loop_cnt; i++))
    do
    {
        local file_name=''
        
        files=$(find "${folder_array[i]}" -name '*.'"$file_type")

        for file_name in $files ; do

            echo "bash $file_name"
        done
    }&
    done
}

main() {

    declare -a folder_array
    local folder_cnt
    local file_type='sh'

    if [[ ! -z $1 ]];then
        file_type="$1"
    fi

    folder_array=($(find ./  -type d | tr -d './'))

    folder_cnt="${#folder_array[@]}"

    run_sh "$folder_cnt"
}

main "$@"

