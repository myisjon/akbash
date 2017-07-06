--01 指标主表
CREATE TABLE IF NOT EXISTS assist.indicator_main (
    indicator_id        INT         COMMENT "指标ID",
    indicator_name      STRING      COMMENT "指标名",
    update_freq         STRING      COMMENT "更新频率",
    is_valid            STRING      COMMENT "是否在用，1-是；0-否",
    creater             STRING      COMMENT "创建人",
    created_at          TIMESTAMP   COMMENT "创建时间"
) COMMENT "指标主表"
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

--02 指标明细
CREATE TABLE IF NOT EXISTS assist.indicator_detail (
    indicator_id        INT         COMMENT "指标ID",
    indicator_name      STRING      COMMENT "指标名",
    indicator_desc      STRING      COMMENT "指标描述",
    data_stage          STRING      COMMENT "数据层",
    db_table_name       STRING      COMMENT "所在表",
    stat_codition       STRING      COMMENT "聚合明细",
    join_codition       STRING      COMMENT "关联条件",
    where_codition      STRING      COMMENT "检索条件",
    index_column        STRING      COMMENT "聚合列",
    update_freq         STRING      COMMENT "更新频率",
    script_model        STRING      COMMENT "脚本模型",
    created_at          TIMESTAMP   COMMENT "创建时间"
) COMMENT "指标明细表"
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

--11 指标检查结果明细 assist.indicator_verify_detail
CREATE TABLE IF NOT EXISTS assist.indicator_verify_detail (
    indicator_id        INT         COMMENT "指标ID",
    indicator_name      STRING      COMMENT "指标名",
    ods_value           DOUBLE      COMMENT "ods结果",
    dws_value           DOUBLE      COMMENT "dws结果",
    app_value           DOUBLE      COMMENT "app结果",
    od_diff             DOUBLE      COMMENT "ods-dws差异",
    da_diff             DOUBLE      COMMENT "dws-app差异",
    is_exact            INT         COMMENT "是否正常，1-正常；0-异常",
    created_at          TIMESTAMP   COMMENT "创建时间"
) COMMENT "统计结果明细"
PARTITIONED BY (calc_day STRING );


--12 统计结果汇总 assist.indicator_verify_overview
CREATE TABLE IF NOT EXISTS assist.indicator_verify_overview(
    run_date            STRING          COMMENT "更新日期",
    freq_type           STRING          COMMENT "频率类型",
    run_condition       STRING          COMMENT "结果汇总",
    unusual_indicator   ARRAY<STRING>   COMMENT "异常指标",
    created_at          TIMESTAMP       COMMENT "创建时间"
) COMMENT "统计结果汇总"
PARTITIONED BY (calc_day STRING);
