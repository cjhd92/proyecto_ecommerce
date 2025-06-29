{{ config(materialized = 'view') }}


select 
    cast(cliente_id as integer) as cliente_id,
    nombre,
    pais,
    cast(fecha_registro  as date) as fecha_registro

from {{ source('datos','clientes') }}