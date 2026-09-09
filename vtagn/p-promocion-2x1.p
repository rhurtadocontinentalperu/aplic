&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-2 NO-UNDO LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parámetros:
Tabla temporal con el detalle de los productos, sin agruparlos 
Tabla temporal resultado del descuento 2x1 
*/

DEF INPUT PARAMETER TABLE FOR ITEM.
DEF OUTPUT PARAMETER TABLE FOR ITEM-2.

DEF SHARED VAR s-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-2 T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.31
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Acumulamos por producto: en unidades de stock */
EMPTY TEMP-TABLE ITEM-2.
FOR EACH ITEM:
    FIND FIRST ITEM-2 WHERE ITEM-2.codmat = ITEM.codmat NO-ERROR.
    IF NOT AVAILABLE ITEM-2 THEN CREATE ITEM-2.
    ASSIGN
        ITEM-2.PreUni = ITEM.PreUni
        ITEM-2.Factor = ITEM.Factor
        ITEM-2.CanPed = ITEM-2.CanPed + (ITEM.CanPed * ITEM.Factor).
END.
/* Barremos promoción por promoción */
DEF VAR x-Factor      AS INT NO-UNDO.
DEF VAR x-Promociones AS INT NO-UNDO.
RLOOP:
FOR EACH PromCabecera NO-LOCK WHERE PromCabecera.Codcia = s-codcia AND
    PromCabecera.FlgEst = YES AND 
    TODAY >= PromCabecera.FechaInicio AND
    TODAY <= PromCabecera.FechaFin:
    /* Productos implicados en la promoción (Parámetros) */
    x-Factor = 0.
    x-Promociones = 0.
    FOR EACH PromDetalle OF PromCabecera WHERE PromDetalle.Llave = "P":
        FIND FIRST ITEM-2 WHERE ITEM-2.codmat = PromDetalle.CodMat NO-LOCK NO-ERROR.
        /* Si no lo encuentra entonces pasamos a la siguiente promoción */
        IF NOT AVAILABLE ITEM-2 OR ITEM-2.Libre_c04 = "2x1" THEN NEXT RLOOP.
        x-Factor = TRUNCATE(ITEM-2.CanPed / PromDetalle.Cantidad, 0).
        IF x-Promociones = 0 THEN x-Promociones = x-Factor.
        ELSE x-Promociones = MINIMUM(x-Promociones, x-Factor).
    END.
    IF x-Promociones = 0 THEN NEXT.
    /* Productos beneficiados con la promoción */
    FOR EACH PromDetalle OF PromCabecera WHERE PromDetalle.Llave = "B":
        FIND FIRST ITEM-2 WHERE ITEM-2.codmat = PromDetalle.CodMat NO-LOCK NO-ERROR.
        /* Si no lo encuentra entonces pasamos a la siguiente promoción */
        IF NOT AVAILABLE ITEM-2 THEN NEXT RLOOP.
        x-Factor = TRUNCATE(ITEM-2.CanPed / PromDetalle.Cantidad, 0).
        x-Promociones = MINIMUM(x-Promociones, x-Factor).
    END.
    IF x-Promociones = 0 THEN NEXT.
    /* Aplicamos la promoción */
    FOR EACH PromDetalle OF PromCabecera WHERE PromDetalle.Llave = "B",
        FIRST ITEM-2 WHERE ITEM-2.codmat = PromDetalle.CodMat:
        CASE PromCabecera.Tipo_Dcto:
            WHEN "P" THEN DO:   /* Porcentaje */
                ITEM-2.ImpDto2 = (x-Promociones * ITEM-2.PreUni / ITEM-2.Factor * PromCabecera.Valor_Dcto / 100).
                ITEM-2.Libre_c04 = "2x1".   /* OJO */
            END.
        END CASE.
    END.
    /* Marcamos los productos relacionados */
    FOR EACH PromDetalle OF PromCabecera WHERE PromDetalle.Llave = "P":
        FIND FIRST ITEM-2 WHERE ITEM-2.codmat = PromDetalle.CodMat NO-LOCK NO-ERROR.
        ITEM-2.Libre_c04 = "2x1".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


