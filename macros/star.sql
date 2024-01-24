{%- macro star(project_or_package, model_name, except=none, alias=none) -%}
{#-
    Generates a list of column names for a given model in a project or package.

    Args:
        project_or_package (str): The project or package containing the model.
        model_name (optional[str]): The name of the model for which columns are generated.
        except (optional[list[str]]): A list of columns to exclude from the generated select expressions.
        alias (optional[str]): The alias name to reference columns if passed.

    Returns:
        str: A comma-separated string of column names during execution.

    Example Usage:
        To get a list of columns for a model:

        SELECT
            {{ star('project_or_package', 'model_name', except=['column_to_exclude']) }}

#}

{%- if execute %}

    {#- Get the model node by its name -#}
    {%- set node = dbt_star._get_model_node(project_or_package, model_name) %}

    {{- dbt_star._generate_star_expression(node, except or [], alias) }}


{#- Just in case... #}
{%- else -%}
    {{ '*'  if alias is none else alias ~ '.' ~ '*' }}
{%- endif -%}

{%- endmacro %}
