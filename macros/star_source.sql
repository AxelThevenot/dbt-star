{%- macro star_source(source_name, table_name, except=none) -%}
{#-
    Generates a list of column names for a given source.

    Args:
        source_name (str): The name of the source.
        table_name (str): The name of the source node.
        except (optional[list[str]]): A list of columns to exclude from the generated select expressions.

    Returns:
        str: A comma-separated string of column names during execution.

    Example Usage:
        To get a list of columns for a source:

        SELECT
            {{ dbt_star.star_source('source_name', 'table_name') }}
#}

{%- if execute %}

    {#- Get the source node by its name -#}
    {%- set node = dbt_star._get_source_node(source_name, table_name) %}

    {{- dbt_star._generate_star_expression(node, except or []) }}


{#- Just in case... #}
{%- else -%}
    *
{%- endif -%}

{%- endmacro %}
