&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-LogTabla NO-UNDO LIKE logtabla.



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

/* Mensaje Alerta Tope de Pedido */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pAlmDes AS CHAR.
DEF INPUT PARAMETER pCanPed AS DEC.     /* OJO: Convertido a unidad de stock */
DEF INPUT PARAMETER pPreguntar AS LOG.  /* Pregunta o no */
DEF INPUT-OUTPUT PARAMETER TABLE FOR T-LogTabla.
DEF OUTPUT PARAMETER pAlmSug AS CHAR.
DEF OUTPUT PARAMETER pRetirar AS LOG.

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

pRetirar = NO.   /* Por defecto NO se retira el código del pedido */

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
    VtaTabla.Tabla = 'TOPEDESPACHO' AND
    VtaTabla.Llave_c1 = pCodMat AND
    VtaTabla.Llave_c2 = pAlmDes
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN RETURN.
IF pCanPed <= VtaTabla.Valor[1] THEN RETURN.

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
      TABLE: T-LogTabla T "?" NO-UNDO INTEGRAL logtabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.38
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR x-StkSug AS DEC NO-UNDO.

DEF VAR pStockComprometido AS DEC NO-UNDO.

/* Buscamos stock disponible del almacén sugerio */
FIND Almmmate WHERE Almmmate.codcia = s-codcia AND
    Almmmate.codalm = VtaTabla.LLave_c3 AND
    Almmmate.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN RETURN.
x-StkAct = Almmmate.StkAct.

RUN gn/stock-comprometido-v2 (pCodMat,
                              Almmmate.codalm,
                              NO,
                              OUTPUT pStockComprometido).
x-StkSug = (x-StkAct - pStockComprometido).
IF x-StkSug < pCanPed THEN RETURN.

IF pPreguntar = YES THEN DO:
    /* Mensaje con dos alternativas:
        Hacer caso a la sugerencia
        Continuar sin sugerencia
        */
    FIND Almmmatg WHERE Almmmatg.CodCia = s-CodCia AND
        Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
/*     MESSAGE                                                            */
/*         '             Código:' pCodMat Almmmatg.DesMat SKIP            */
/*         '              Marca:' Almmmatg.DesMar SKIP                    */
/*         '             Unidad:' Almmmatg.UndStk SKIP                    */
/*         '       Alm.Despacho:' pAlmDes SKIP                            */
/*         '         Cant. Tope:'  VtaTabla.Valor[1]  SKIP                */
/*         '      Alm. Sugerido:' VtaTabla.LLave_c3 SKIP                  */
/*         'Stock Alm. Sugerido:' (x-StkAct - pStockComprometido) SKIP(2) */
/*         '¿Retiro el artículo del pedido?'                              */
/*         VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO                       */
/*         TITLE 'ALERTA TOPE DE DESPACHO'                                */
/*         UPDATE rpta AS LOG                                             */
/*         .                                                              */
/*     pRetirar = rpta. */
END.
ELSE pRetirar = YES.     /* Se retira automáticamente */

pAlmSug = VtaTabla.LLave_c3.

/* LOG de control */
DEF VAR x-StkDes AS DEC NO-UNDO.    /* Stock almacén despacho */

FIND Almmmate WHERE Almmmate.codcia = s-codcia AND
    Almmmate.codalm = pAlmDes AND
    Almmmate.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE Almmmate THEN x-StkDes = Almmmate.StkAct.

RUN gn/stock-comprometido-v2 (pCodMat,
                              pAlmDes,
                              NO,
                              OUTPUT pStockComprometido).
x-StkDes = (x-StkDes - pStockComprometido).

CREATE T-LogTabla.
ASSIGN
    T-LogTabla.codcia = s-CodCia
    T-LogTabla.Dia = TODAY
    T-LogTabla.Evento = (IF pRetirar = YES THEN 'RETIRAR' ELSE 'NO RETIRAR')
    T-LogTabla.Hora = STRING(TIME, 'HH:MM:SS')
    /*T-LogTabla.NumId */
    T-LogTabla.Tabla = "TOPEPEDIDO"
    T-LogTabla.Usuario = s-user-id
    T-LogTabla.ValorLlave = pCodMat + '|' +
                            STRING(pCanPed,'->>>,>>>,>>9.9999') + '|' +
                            STRING(VtaTabla.Valor[1],'->>>,>>>,>>9.9999') + '|' +
                            pAlmDes + '|' + 
                            STRING(x-StkDes, '->>>,>>>,>>9.99') + '|' +
                            pAlmSug + '|' + 
                            STRING(x-StkSug, '->>>,>>>,>>9.99').

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


