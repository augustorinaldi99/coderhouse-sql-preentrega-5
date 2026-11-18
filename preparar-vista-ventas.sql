-- ADAPTACION DEL DATASET EXISTENTE DE CLASES
-- Ejecutar en la base tienda, despues de cargar dataset/ddl-tienda.sql en public.
-- Si las nueve tablas ya estan cargadas en public, no volver a insertar datos.
-- Solo se crea una vista de lectura; no se agregan ni modifican registros.
-- Una venta es un detalle de un pedido Completado. Los pedidos Cancelado,
-- En proceso y Enviado no se consideran compras completadas en este analisis.
-- Se conserva id_pedido para contar ocasiones sin duplicar productos repetidos
-- dentro de un mismo pedido. La fecha es fecha_pedido, con hora original.
-- No se usa pedidos.fecha: el DDL le asigna CURRENT_DATE cuando carga el archivo.
BEGIN;
CREATE SCHEMA IF NOT EXISTS preentrega_4;

CREATE OR REPLACE VIEW preentrega_4.ventas AS
SELECT
    d.detalle_id AS id_venta,
    pe.pedido_id AS id_pedido,
    pe.cliente_id AS id_cliente,
    d.producto_id AS id_producto,
    pe.fecha_pedido AS fecha_venta,
    d.cantidad,
    d.precio_unitario,
    d.subtotal AS importe
FROM public.pedidos AS pe
INNER JOIN public.detalle_pedidos AS d
    ON d.pedido_id = pe.pedido_id
WHERE pe.estado = 'Completado';

COMMIT;
