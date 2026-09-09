&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.19
         WIDTH              = 59.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF INPUT PARAMETER pCodPed AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.

pEstado = pFlgEst.
CASE pCodPed:
    WHEN 'NPC' THEN DO:
        CASE pFlgEst:
            WHEN 'PV' THEN pEstado = "POR APROBAR".  /* Vendedor */
            WHEN 'PA' THEN pEstado = "POR APROBAR POR ADMINISTRADOR".
            WHEN 'E' THEN pEstado  = "POR APROBAR POR SUPERVISOR".
            WHEN 'V' THEN pEstado  = "VENCIDA".
            WHEN 'R' THEN pEstado  = "RECHAZADO".
            WHEN 'A' THEN pEstado  = "ANULADO".
            WHEN 'C' THEN pEstado  = "CON PEDIDO COMERCIAL".
            WHEN 'X' THEN pEstado  = "CERRADO MANUALMENTE".
        END CASE.
    END.
    WHEN 'COT' THEN DO:
        CASE pFlgEst:
            WHEN 'PP' THEN pEstado = "EN PROCESO".
            WHEN 'PV' THEN pEstado = "POR APROBAR".  /* Vendedor */
            WHEN 'PA' THEN pEstado = "POR APROBAR POR ADMINISTRADOR".
            WHEN "DA" THEN pEstado = "PEND.DCTO. ADMINISTRADOR".
            WHEN 'E' THEN pEstado = "POR APROBAR POR SUPERVISOR".
            WHEN 'P' THEN pEstado = "PENDIENTE PEDIDO LOGISTICO".
            WHEN 'V' THEN pEstado = "VENCIDA".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "ATENDIDO TOTAL".
            WHEN 'S' THEN pEstado = "SUSPENDIDA".
            WHEN 'X' THEN pEstado = "CERRADO MANUALMENTE".
            WHEN 'T' THEN pEstado = "EN REVISION".
            WHEN 'ST' THEN pEstado = "SALDO TRANSFERIDO".
        END CASE.
    END.
    WHEN 'PED' THEN DO:
        CASE pFlgEst:
            WHEN 'G' THEN pEstado = "GENERADO".
            WHEN 'X' THEN pEstado = "POR APROBAR X CRED. & COB.".
            WHEN 'T' THEN pEstado = "POR APROBAR X TESORERIA".
            WHEN 'W' THEN pEstado = "POR APROBAR POR SECR. GG.".
            WHEN 'WX' THEN pEstado = "POR APROBAR POR GG.".
            WHEN 'WL' THEN pEstado = "POR APROBAR POR LOGISTICA".
            WHEN 'WC' THEN pEstado = "POR APROBAR POR COMERCIAL".
            WHEN 'P' THEN pEstado = "APROBADO".
            WHEN 'V' THEN pEstado = "VENCIDO POR SER MAYOR A 24 HORAS".
            WHEN 'F' THEN pEstado = "FACTURADO".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "CON ORDEN DE DESPACHO".
            WHEN 'S' THEN pEstado = "SUSPENDIDO".
            WHEN 'E' THEN pEstado = "CERRADO MANUALMENTE".
            WHEN "O" THEN pEstado = "CON ORDEN DE TRANSFER.".
        END CASE.
    END.
    WHEN 'PET' OR WHEN 'PPT' THEN DO:     /* PRE-COTIZACION EXPO */
        CASE pFlgEst:
            WHEN "A" THEN pEstado = " ANULADO " .
            WHEN "C" THEN pEstado = "ATENDIDO " .
            WHEN "P" THEN pEstado = "PENDIENTE" .
            WHEN "V" THEN pEstado = " VENCIDO " .
            WHEN "X" THEN pEstado = " CERRADA " .
        END CASE.
    END.
    WHEN 'O/D' THEN DO:
        CASE pFlgEst:
            WHEN 'P' THEN pEstado = "POR FACTURAR".
            WHEN 'V' THEN pEstado = "VENCIDO".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "FACTURADO".
            WHEN 'S' THEN pEstado = "SUSPENDIDO".
            WHEN 'E' THEN pEstado = "CERRADO MANUALMENTE".
            WHEN "O" THEN pEstado = "OTR en proceso".
            WHEN "WL" THEN pEstado = "POR APROBAR LOGISTICA".
        END CASE.
    END.
    WHEN 'SUI' THEN DO: /* USO INTERNO */
        CASE pFlgEst:
            WHEN 'T' THEN pEstado = "POR APROBAR".
            WHEN 'WL' THEN pEstado = "POR APROBAR POR CONTRALORIA".
            WHEN 'P' THEN pEstado = "APROBADO".
            WHEN 'V' THEN pEstado = "VENCIDO".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "ATENDIDO TOTALMENTE".
            WHEN 'S' THEN pEstado = "SUSPENDIDO".
            WHEN 'E' THEN pEstado = "CERRADO MANUALMENTE".
        END CASE.
    END.
    WHEN 'CANASTA' THEN DO: /* TIENDA CHICLAYO */
        CASE pFlgEst:
            WHEN 'L' THEN pEstado = "LIBRE".
            WHEN 'O' THEN pEstado = "OCUPADO".
            WHEN 'R' THEN pEstado = "EN VENTAS".
            WHEN 'X' THEN pEstado = "NO USAR".
        END CASE.
    END.
    WHEN 'ANAQUEL' THEN DO: /* TIENDA CHICLAYO */
        CASE pFlgEst:
            WHEN 'L' THEN pEstado = "LIBRE".
            WHEN 'O' THEN pEstado = "OCUPADO".
            WHEN 'X' THEN pEstado = "NO USAR".
        END CASE.
    END.
    OTHERWISE DO:
        CASE pFlgEst:
            WHEN 'T' THEN pEstado = "POR APROBAR".
            WHEN 'X' THEN pEstado = "POR APROBAR X CRED. & COB.".
            WHEN 'W' THEN pEstado = "POR APROBAR POR SECR. GG.".
            WHEN 'WX' THEN pEstado = "POR APROBAR POR GG.".
            WHEN 'WL' THEN pEstado = "POR APROBAR POR LOGISTICA".
            WHEN 'P' THEN pEstado = "APROBADO".
            WHEN 'V' THEN pEstado = "VENCIDO".
            WHEN 'F' THEN pEstado = "FACTURADO".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "ATENDIDO TOTALMENTE".
            WHEN 'S' THEN pEstado = "SUSPENDIDO".
            WHEN 'E' THEN pEstado = "CERRADO MANUALMENTE".
            WHEN 'G' THEN pEstado = "GENERADO".
            WHEN "O" THEN pEstado = "OTR en proceso".
        END CASE.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


