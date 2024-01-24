{%- macro _generate_star_expression(node, except) -%}
{#-
    Generates a star expression of a node.

    Args:
        node (dict): The dbt node configuration.
        except (optional[list[str]]): A list of columns to exclude from the generated select expressions.

    Returns:
        str: A comma-separated string of column names during execution.
#}

{#- Iterate through columns of the model and exclude those in the 'except' list #}
{%- set not_except_columns = [] %}
{%- for column in node.columns %}

    {#- Nested columns (with a '.') must be remove also #}
    {%- if column not in except and '.' not in column %}
        {%- do not_except_columns.append(column) %}
    {%- endif %}

{%- endfor %}

{#- Raise an error if not columns to select -#}
{%- if not_except_columns | length == 0 %}
    {{-
        exceptions.raise_compiler_error(
            'Node ' ~ node.unique_id ~ ' has 0 column to select.'
        )
    }}
{%- endif %}


{#- Generate the comma-separated list of columns -#}
{%- for column in not_except_columns %}
    {{- column -}}{{- ',\n' if not loop.last else '' }}
{%- endfor %}

{%- endmacro %}
