{{ config(materialized = 'view') }}


select 
    canal,
    tipo,
    descripcion

from {{ source('datos','canales') }}