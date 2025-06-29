{{ config(materialized = 'view') }}


select 
    cast(producto_id as integer) as producto_id,
    categoria,
    subcategoria,
    cast(precio_base  as float) as precio_base

from {{ source('datos','productos') }}