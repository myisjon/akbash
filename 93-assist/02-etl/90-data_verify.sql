
SELECT ${hiveconf:INDEX_COLUMN},
    ${hiveconf:STAT_CONDITION} AS rlt
FROM ${hiveconf:DB_TABLE_NAME}
    ${hiveconf:JOIN_CONDITION}
WHERE '${hiveconf:WHERE_CONDITION}'
GROUP BY ${hiveconf:INDEX_COLUMN}
;