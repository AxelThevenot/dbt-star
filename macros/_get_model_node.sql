{%- macro _get_model_node(project_or_package, model_name) -%}
{#-
    Retrieves the node for a specified model.

    Args:
        project_or_package (str): The project or package containing the model.
        model_name (optional[str]): The name of the model for which columns are generated.

    Returns:
        dict: The node representing the model in the project or package.

    Example Usage:
        To retrieve the model node for a specific model:

        {%- set my_model_node = dbt_star._get_model_node() %}
        {%- set my_model_node = dbt_star._get_model_node('my_model') %}
        {%- set my_model_node = dbt_star._get_model_node('my_project', 'my_model') %}
        {%- set my_model_node = dbt_star._get_model_node(model_name='my_model') %}

-#}

{#- Set current model values if project_or_package and model_name are not provided #}
{%- if project_or_package is not defined and model_name is not defined %}
    {%- set model_name         = model.name %}
    {%- set project_or_package = model.package_name %}

{#- If one argument is given, suppose this is the model_name #}
{%- elif project_or_package is defined and model_name is not defined %}
    {%- set model_name         = project_or_package %}
    {%- set project_or_package = model.package_name %}

{#- Get current package_name if model_name is given as a keyword argument #}
{%- elif project_or_package is not defined and model_name is defined %}
    {%- set model_name         = model_name %}
    {%- set project_or_package = model.package_name %}

{%- endif %}


{#- Filter the graph to find the node for the specified model -#}
{%- set node = (
        graph.nodes.values()
        | selectattr('resource_type', 'equalto', 'model')
        | selectattr('package_name', 'equalto', project_or_package)
        | selectattr('name', 'equalto', model_name)
    ) | first %}

{#- Raise an error if the node is not found -#}
{%- if node is not defined %}
    {{-
        exceptions.raise_compiler_error(
            'Model "model.' ~ project_or_package ~ '.' ~ model_name ~ '" is not found.'
        )
    }}


{%- endif %}

{{- return(node) }}

{%- endmacro -%}
