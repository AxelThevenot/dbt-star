{{
    config(materialized='view', enabled=true)
}}

WITH
    final AS (
        SELECT
            {{ dbt_star.star_source('basic_star_example_source', 'd_site') | indent(12) }},
            CURRENT_TIMESTAMP() AS ingested_at
        FROM {{ source('basic_star_example_source', 'd_site') }}
    )
SELECT
    {{ dbt_star.star()| indent(4) }}
FROM `final`
