-- PREENTREGA 5: ANALISIS MENSUAL DE VENTAS
-- Augusto Rinaldi Davids | PostgreSQL 18
-- Ejecutar en la base tienda con el dataset y la vista de la Preentrega 4.
-- La vista preentrega_4.ventas contiene los detalles de pedidos completados.
-- Esta consulta solo lee datos. Los importes no tienen moneda especificada.

-- Pregunta: que categorias lideran cada mes, como acumulan sus ventas y
-- como se compara cada mes con el promedio historico de su propia categoria.
WITH ventas_mensuales AS (
    -- Primero se agrupan los detalles al nivel de mes y categoria.
    SELECT
        DATE_TRUNC('month', v.fecha_venta)::date AS mes,
        cat.categoria_id,
        cat.nombre_categoria AS categoria,
        SUM(v.importe) AS venta_total
    FROM preentrega_4.ventas AS v
    INNER JOIN public.productos AS p ON p.producto_id = v.id_producto
    INNER JOIN public.categorias AS cat ON cat.categoria_id = p.categoria_id
    GROUP BY DATE_TRUNC('month', v.fecha_venta)::date,
             cat.categoria_id, cat.nombre_categoria
),
metricas_ventana AS (
    -- Ranking dentro de cada mes; los empates reciben la misma posicion.
    -- Acumulado cronologico y promedio sobre los meses con ventas registradas.
    SELECT
        vm.mes,
        vm.categoria_id,
        vm.categoria,
        vm.venta_total,
        RANK() OVER (PARTITION BY vm.mes ORDER BY vm.venta_total DESC) AS ranking_mes,
        SUM(vm.venta_total) OVER (
            PARTITION BY vm.categoria_id ORDER BY vm.mes
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS venta_acumulada,
        AVG(vm.venta_total) OVER (PARTITION BY vm.categoria_id) AS promedio_historico
    FROM ventas_mensuales AS vm
)
SELECT
    mv.mes,
    mv.categoria,
    mv.venta_total,
    mv.ranking_mes,
    mv.venta_acumulada,
    ROUND(mv.promedio_historico, 2) AS promedio_historico,
    -- Igual al promedio se considera Exitoso; se compara antes de redondear.
    CASE WHEN mv.venta_total >= mv.promedio_historico
         THEN 'Exitoso'
         ELSE 'Bajo el promedio'
    END AS comparativa
FROM metricas_ventana AS mv
ORDER BY mv.mes, mv.ranking_mes, mv.categoria;
