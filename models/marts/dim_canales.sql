{{ config(materialized = 'table') }}


select 
    distinct  canal,
    tipo,
    descripcion

from {{ ref('stg_canales') }}