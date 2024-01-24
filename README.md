# dbt-star

![Alt text](./img/dbt-star.png)

<p align="center">
    <img alt="License" src="https://img.shields.io/badge/license-Apache--2.0-ff69b4?style=plastic"/>
    <img alt="Static Badge" src="https://img.shields.io/badge/dbt-package-orange">
    <img alt="GitHub Release" src="https://img.shields.io/github/v/release/AxelThevenot/dbt-star">
    <img alt="GitHub (Pre-)Release Date" src="https://img.shields.io/github/release-date-pre/AxelThevenot/dbt-star">
</p>

<p align="center">
    <img src="https://img.shields.io/circleci/project/github/badges/shields/master" alt="build status">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues/AxelThevenot/dbt-star">
    <img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/AxelThevenot/dbt-star">
    <img src="https://img.shields.io/github/contributors/AxelThevenot/dbt-star" />
</p>

## Features

**A dbt package to `SELECT *` without `SELECT *`!**


🎯 **Selective Column Inclusion:** 
Generate exhaustive `SELECT` expressions for [models](#star) and [sources](#star_source) removing your old `SELECT *` from your queries, improving readability when compiled.
  
🚫 **Configurable:** 
Use the optional [`except`](#except-argument) argument to tailor the output by excluding specific columns.
Enhance query clarity with the [`alias`](#alias-argument) argument, especially useful for multiple model instances.

🌐 **Cross-Platform Compatibility:** Supports all data platforms, ensuring flexibility in your data stack.

## Content

- [dbt-star](#dbt-star)
  - [Features](#features)
  - [Content](#content)
  - [Install](#install)
  - [Dependencies](#dependencies)
  - [Variables](#variables)
  - [Basic Example](#basic-example)
  - [Documentation](#documentation)
    - [Macros](#macros)
      - [star](#star)
      - [star\_source](#star_source)
      - [`except` argument](#except-argument)
      - [`alias` argument](#alias-argument)
  - [Contribution](#contribution)
  - [Contact](#contact)


## Install

`dbt-star` currently supports `dbt 1.7.x` or higher.


Check [dbt github package](https://hub.getdbt.com/calogica/dbt_expectations/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in `packages.yml`

```yaml
packages:
  - git: https://github.com/AxelThevenot/dbt-star.git
    revision: 0.1.0
    # <see https://github.com/AxelThevenot/dbt-star/releases/latest> for the latest version tag
```

This package supports all data platforms:

* AllowDB
* BigQuery
* Databricks
* Dremio
* Postgres
* Redshift
* Snowflake
* Spark
* Starbust/Trino
* Microsoft Fabric
* Azure Synapse
* Teradata
* ...

For latest release, see [https://github.com/AxelThevenot/dbt-star/releases](https://github.com/AxelThevenot/dbt-star/releases)


## Dependencies

This package do not have dependencies.

## Variables

This package do not have variables.

## Basic Example

You can see the [basic star example here](./models/basic_star_example/). 

For even more basic. This package is made to remove `SELECT *` from your queries.

```sql
-- Old query
SELECT
    *
FROM {{ ref('my_model') }}

-- Reworked query
SELECT
    {{ dbt_star.star('my_model') | indent(4) }} -- reads from the `.yml` configuration
FROM {{ ref('my_model') }}

-- Compiled query
SELECT
    column_1,
    column_2,
    column_3
FROM {{ ref('my_model') }}
```

## Documentation

### Macros

#### [star](./macros/star.sql)

`star()` generates a list of column names for a given model as your `SELECT` expression.
It is callable the same way you call the native dbt [`ref()`](https://docs.getdbt.com/reference/dbt-jinja-functions/ref). (`version` argument is not supported yet)

```sql
WITH
    final AS (
        SELECT
          {{ dbt_star.star('my_model') }},
          CURRENT_TIMESTAMP() AS ingested_at
        FROM {{ ref('my_model') }}
    )
SELECT
    *
FROM final
```

You can call `star()` macro without providing model name and package. It will consider the current model configuration.


```sql
WITH
    final AS (
        SELECT
          {{ dbt_star.star('my_model') }},
          CURRENT_TIMESTAMP() AS ingested_at
        FROM {{ ref('my_model') }}
    )
SELECT
    {{ dbt_star.star() }}
FROM final
```

It supports optional [`except`](#except-argument) and [`alias`](#alias-argument) arguments.

---


#### [star_source](./macros/star_source.sql)

`star_source()` generates a list of column names for a given source as your `SELECT` expression.
It is callable the same way you call the native dbt [`source()`](https://docs.getdbt.com/reference/dbt-jinja-functions/source).

```sql
WITH
    final AS (
        SELECT
          {{ dbt_star.star_source('source_name', 'table_name') }},
          CURRENT_TIMESTAMP() AS ingested_at
        FROM {{ source('source_name', 'table_name') }}
    )
SELECT
    *
FROM final
```

It supports optional [`except`](#except-argument) and [`alias`](#alias-argument) arguments.

---

#### `except` argument

`except` (optional[list[str]]) argument is compatible with [`star()`](#star) and [`star_source()`] macros.
If provided, it contains the list of columns to exclude from the generated `SELECT` expressions.

```sql
SELECT
    {{ dbt_star.star('my_model', except=['i_dont_want_you', 'you_neither']) }}
FROM {{ ref('my_model') }}
```

---

#### `alias` argument

`alias` (optional[str]) argument is compatible with [`star()`](#star) and [`star_source()`] macros.
If provided, it prefixes the list of columns from the generated `SELECT` expressions.

```sql
SELECT
    {{ dbt_star.star('my_model', alias='model_1') | indent(4) }},
    model_2.column_a,
    model_2.column_b,
    model_2.column_c
FROM {{ ref('my_model') }} AS model_1
LEFT JOIN {{ ref('my_model') }} AS model_2
    ON model_1.column_1 = model_2.column_1
```

Is compiled as

```sql
SELECT
    model_1.column_1,
    model_1.column_2,
    model_1.column_3,
    ...
    model_2.column_a,
    model_2.column_b,
    model_2.column_c
FROM {{ ref('my_model') }} AS model_1
LEFT JOIN {{ ref('my_model') }} AS model_2
    ON model_1.column_1 = model_2.column_1
```

---

## Contribution

If you want to contribute, please open a Pull Request or an Issue on this repo.
Feel free to reach me [Linkedin](https://www.linkedin.com/in/axel-thevenot/).


## Contact

If you have any question, please open a new Issue or feel free to reach out to [Linkedin](https://www.linkedin.com/in/axel-thevenot/)

---

Happy coding with **dbt-star**!
