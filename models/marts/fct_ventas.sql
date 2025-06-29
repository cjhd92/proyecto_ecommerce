/* {{ config(materialized = 'table') }} */

{{ config(
    materialized='incremental',
    unique_key='venta_id'
) }}

with base as(
    select 
        v.venta_id,
        v.fecha,
        v.cliente_id,
        v.producto_id,
        v.cantidad,
        v.precio_unitario,
        v.canal,
        v.cantidad * v.precio_unitario as total_venta,
        case when d.venta_id is not null then true else false end as es_devolucion

    from {{ ref('stg_ventas') }} v
    left join {{ ref('stg_devoluciones') }} d on v.venta_id = d.venta_id 

    {% if is_incremental() %}
      -- Solo incluir ventas que no estén ya en la tabla existente
      where v.venta_id not in (select venta_id from {{ this }})
    {% endif %}
)


select * from base