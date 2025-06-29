{{ config(materialized = 'view') }}


select 
    cast(venta_id as integer) as venta_id,
    cast(fecha  as date) as fecha,
    cast(cliente_id as integer) as cliente_id,
    cast(producto_id as integer) as producto_id,
    cast(cantidad as integer) as cantidad,
    cast(precio_unitario as float) as precio_unitario,
    canal

from {{ source('datos','ventas') }}