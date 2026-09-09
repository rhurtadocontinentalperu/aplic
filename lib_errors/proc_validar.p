/* proc_validar.p */
{lib_errors/pedido_master.i}

DEFINE PARAMETER BUFFER bPedido FOR ttPedido.

/* --- Reglas de Negocio --- */

/* 1. Validación de Cantidad */
IF bPedido.Cantidad <= 0 THEN 
    RETURN ERROR "La cantidad debe ser al menos 1 unidad.".

/* 2. Validación de Articulo */
IF bPedido.Articulo = "" THEN 
    RETURN ERROR "El nombre del artículo no puede estar vacío.".

/* 3. Cálculo automático si todo está bien */
bPedido.Total = bPedido.Cantidad * bPedido.Precio.

RETURN.
