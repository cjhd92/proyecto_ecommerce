import streamlit as st
import duckdb
import pandas as pd
import altair as alt

st.set_page_config(page_title="Dashboard de Ventas", layout="wide")

# Conexión a DuckDB
con = duckdb.connect("dev.duckdb")

# Cargar tabla fct_ventas con join a dim_clientes
query = """
SELECT v.*, c.pais
FROM fct_ventas v
LEFT JOIN dim_clientes c ON v.cliente_id = c.cliente_id
"""
df = con.execute(query).fetchdf()
print(df)

# Título
st.title("📊 Dashboard de Ventas (Proyecto dbt + Streamlit)")

# KPIs generales
col1, col2, col3 = st.columns(3)

col1.metric("Ventas totales", f"{df['total_venta'].sum():,.2f} €")
col2.metric("Nº total de ventas", f"{df['venta_id'].nunique()}")
col3.metric("Tasa de devoluciones", f"{(df['es_devolucion'].mean()*100):.2f} %")

st.markdown("---")

# Ventas por canal
st.subheader("🛍️ Ventas por Canal")
ventas_canal = df.groupby("canal")["total_venta"].sum().reset_index()
chart1 = alt.Chart(ventas_canal).mark_bar().encode(
    x=alt.X("canal:N", title="Canal de venta"),
    y=alt.Y("total_venta:Q", title="Total vendido (€)"),
    tooltip=["canal", "total_venta"]
).properties(width=600)
st.altair_chart(chart1)

# Devoluciones por país
st.subheader("📦 Devoluciones por País")
devoluciones = df[df["es_devolucion"] == True]
dev_pais = devoluciones.groupby("pais").size().reset_index(name="n_devoluciones").sort_values(by="n_devoluciones", ascending=False).head(10)
st.dataframe(dev_pais)

# Ventas por mes
st.subheader("📅 Ventas Mensuales")
df["mes"] = pd.to_datetime(df["fecha"]).dt.to_period("M").astype(str)
ventas_mes = df.groupby("mes")["total_venta"].sum().reset_index()
chart2 = alt.Chart(ventas_mes).mark_line(point=True).encode(
    x=alt.X("mes:T", title="Mes"),
    y=alt.Y("total_venta:Q", title="Total vendido (€)"),
    tooltip=["mes", "total_venta"]
).properties(width=800)
st.altair_chart(chart2)

st.markdown("Proyecto desarrollado por ti como parte del portafolio de Data Engineer 💻")
