# Preentrega 5: análisis avanzado de ventas

**Autor:** Augusto Rinaldi Davids. **Motor:** PostgreSQL 18.

El archivo `preentrega_analisis_avanzado.sql` responde qué categorías lideran por mes, cuánto acumulan y cómo se compara cada venta mensual con el promedio de su categoría. Utiliza el dataset de clases de la Preentrega 4, como permite la consigna.

## Ejecución

1. Conectarse en DBeaver a la base `tienda` con las tablas del dataset cargadas en `public`.
2. Si todavía no existe la vista `preentrega_4.ventas`, ejecutar `preparar-vista-ventas.sql` de la Preentrega 4. La vista está incluida en `preparar-vista-ventas.sql` y el dataset original, en `dataset/ddl-tienda.sql`. Si ya están cargados, no volver a ejecutar el archivo de inserción.
3. Abrir `preentrega_analisis_avanzado.sql` y ejecutar la consulta con `Ctrl+Enter` o el script con `Alt+X`.

La vista considera solo pedidos con estado `Completado`. Cada importe es el subtotal del detalle, calculado con su precio unitario. La fuente no especifica una moneda.

## Criterios de cálculo

- `ventas_mensuales` agrupa por mes e identificador de categoría, y suma sus importes.
- `metricas_ventana` calcula el ranking con `RANK()`, el acumulado con `SUM() OVER` y el promedio histórico de cada categoría con `AVG() OVER`.
- El promedio incluye el mes evaluado y comprende únicamente los meses con ventas registradas; no se agregan meses sin datos como cero.
- `CASE WHEN` clasifica `Exitoso` cuando la venta es mayor o igual al promedio sin redondear y `Bajo el promedio` cuando es menor. El promedio se redondea solo para mostrarlo.
- El acumulado sigue el orden cronológico de los meses; los empates del ranking comparten posición.

## Verificación

La consulta se ejecutó en PostgreSQL 18.6 en una instancia temporal con el dataset de la Preentrega 4. Devolvió **164 filas**, correspondientes a **8 categorías** en **24 meses**, entre enero de 2023 y diciembre de 2024. Los totales, rankings, acumulados, promedios y etiquetas se cotejaron con un cálculo independiente para todas las filas. El resumen está en `resultados-verificados.json`.

La consulta principal solo lee datos.
