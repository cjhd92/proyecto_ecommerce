{{ config(materialized = 'table') }}


select 
    producto_id,
    categoria,
    subcategoria,
    precio_base

from {{ ref('stg_productos') }}