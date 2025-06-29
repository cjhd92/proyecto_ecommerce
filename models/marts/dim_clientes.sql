{{ config(materialized = 'table') }}


select 
    cliente_id,
    nombre,
    pais,
    fecha_registro

from {{ ref('stg_clientes') }}