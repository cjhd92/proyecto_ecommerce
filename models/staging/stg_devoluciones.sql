{{ config(materialized = 'view') }}


select 
    cast(devolucion_id as integer) as devolucion_id,
    cast(venta_id as integer) as venta_id,
    cast(fecha as date) as fecha,
    motivo

from {{ source('datos','devoluciones') }}