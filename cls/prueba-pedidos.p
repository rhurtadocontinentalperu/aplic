
/*
 * Archivo: mi_programa_principal.p
 *
 * Descripción:
 * Ejemplo de cómo usar los métodos de la clase cls_gestor_clientes.
 */

DEFINE VARIABLE oGestorPedidos AS cls_utilities_od_otr NO-UNDO.
DEFINE VARIABLE lExito AS LOGICAL NO-UNDO.
DEFINE VARIABLE cNombre AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodigo AS CHARACTER NO-UNDO.

DEFINE VARIABLE cMensaje AS CHAR NO-UNDO.
DEFINE VARIABLE cAviso   AS CHAR NO-UNDO.

FIND LAST Faccpedi WHERE Faccpedi.codcia = 1
    AND Faccpedi.coddoc = "PED"
    AND Faccpedi.coddiv = "00002"
    AND Faccpedi.flgest = "G"
    AND Faccpedi.fmapgo <> "002"
    NO-LOCK NO-ERROR.
MESSAGE faccpedi.coddoc faccpedi.nroped.


oGestorPedidos = NEW cls_utilities_od_otr(INPUT Faccpedi.codcia,
                                          INPUT Faccpedi.coddiv,
                                          INPUT 0).


lExito = oGestorPedidos:PED_Despachar_Rutina_Master (BUFFER Faccpedi,
                                                    INPUT YES,
                                                    INPUT "ADMIN",
                                                    OUTPUT cMensaje,
                                                    OUTPUT cAviso).
MESSAGE 'salida' lExito.

IF lExito THEN
  MESSAGE "El pedido se grabó con éxito." VIEW-AS ALERT-BOX.
ELSE
    IF cMensaje > '' THEN MESSAGE cMensaje VIEW-AS ALERT-BOX ERROR.


DELETE OBJECT oGestorPedidos.
