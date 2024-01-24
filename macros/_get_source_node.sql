{%- macro _get_source_node(source_name, table_name) -%}
{#-
    Retrieves the node for a specified source.

    Args:
        source_name (str): The project or package containing the source.
        table_name (str): The name of the source for which columns are generated.

    Returns:
        dict: The node representing the source in the project or package.

    Example Usage:
        To retrieve the source node for a specific source:

        {%- set my_source_node = dbt_star._get_source_node('my_source', 'my_table') %}
        {%- set my_source_node = dbt_star._get_source_node(source_name='my_source', table_name='my_table') %}

#}

{#- The source must be correctly defined #}
{%- if source_name is not defined and table_name is not defined %}
    {{-
        exceptions.raise_compiler_error(
            'Source must be defined to use `dbt_star.star_source()` function.'
            ~ ' Having source_name: ' ~ source_name ~ ' and table_name: ' ~ table_name ~ '.'
        )
    }}
{%- endif %}

{#- Filter the graph to find the node for the specified source -#}
{%- set node = (
        graph.sources.values()
        | selectattr('resource_type', 'equalto', 'source')
        | selectattr('source_name', 'equalto', source_name)
        | selectattr('name', 'equalto', table_name)
    ) | first %}

{#- Raise an error if the node is not found -#}
{%- if node is not defined %}
    {{-
        exceptions.raise_compiler_error(
            'Source "source.<project_or_package>.' ~ source_name ~ '.' ~ table_name ~ '" is not found.'
        )
    }}


{%- endif %}

{{- return(node) }}

{%- endmacro -%}
