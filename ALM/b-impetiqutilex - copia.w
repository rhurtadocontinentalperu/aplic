&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-REPORT NO-UNDO LIKE w-report.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF STREAM REPORTE.
DEFINE TEMP-TABLE tt-articulos 
    FIELDS t-codmat LIKE almmmatg.codmat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-REPORT

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-REPORT.Campo-C[1] ~
T-REPORT.Campo-C[2] T-REPORT.Campo-C[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-REPORT.Campo-C[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-REPORT
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-REPORT
&Scoped-define QUERY-STRING-br_table FOR EACH T-REPORT WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-REPORT WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-REPORT
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-REPORT


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Seleciona-Printer FILL-IN-Copias ~
TOGGLE-nuevoformato br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Impresora FILL-IN-Copias ~
TOGGLE-nuevoformato 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Seleciona-Printer 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 9" 
     SIZE 5 BY 1.12 TOOLTIP "Seleccionar Impresora por Defecto".

DEFINE VARIABLE FILL-IN-Copias AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Impresora AS CHARACTER FORMAT "X(256)":U 
     LABEL "Impresora por defecto" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE TOGGLE-nuevoformato AS LOGICAL INITIAL no 
     LABEL "Nuevo formato - pequeño" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-REPORT SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-REPORT.Campo-C[1] COLUMN-LABEL "Artículo" FORMAT "X(14)":U
      T-REPORT.Campo-C[2] COLUMN-LABEL "EAN 13" FORMAT "X(15)":U
      T-REPORT.Campo-C[3] COLUMN-LABEL "Descripción" FORMAT "X(80)":U
  ENABLE
      T-REPORT.Campo-C[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 96 BY 19.12
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Impresora AT ROW 1.54 COL 23 COLON-ALIGNED WIDGET-ID 2
     BUTTON-Seleciona-Printer AT ROW 1.54 COL 75 WIDGET-ID 4
     FILL-IN-Copias AT ROW 2.65 COL 23 COLON-ALIGNED WIDGET-ID 6
     TOGGLE-nuevoformato AT ROW 2.92 COL 52 WIDGET-ID 8
     br_table AT ROW 4.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-REPORT T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 22.81
         WIDTH              = 113.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table TOGGLE-nuevoformato F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Impresora IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-REPORT"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.T-REPORT.Campo-C[1]
"T-REPORT.Campo-C[1]" "Artículo" "X(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-REPORT.Campo-C[2]
"T-REPORT.Campo-C[2]" "EAN 13" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-REPORT.Campo-C[3]
"T-REPORT.Campo-C[3]" "Descripción" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-REPORT.Campo-C[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-REPORT.Campo-C[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-REPORT.Campo-C[1] IN BROWSE br_table /* Artículo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF NOT AVAILABLE Almmmatg THEN DO:        
        BELL.
        SELF:SCREEN-VALUE = ''.
        APPLY 'ENTRY':U TO SELF.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Seleciona-Printer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Seleciona-Printer B-table-Win
ON CHOOSE OF BUTTON-Seleciona-Printer IN FRAME F-Main /* Button 9 */
DO:
  DEF VAR rpta AS LOG NO-UNDO.
  ASSIGN FILL-IN-Copias.
  SYSTEM-DIALOG PRINTER-SETUP NUM-COPIES FILL-IN-Copias UPDATE rpta.
  DISPLAY FILL-IN-Copias WITH FRAME {&FRAME-NAME}.
  DISPLAY SESSION:PRINTER-NAME @ FILL-IN-Impresora WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-nuevoformato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-nuevoformato B-table-Win
ON VALUE-CHANGED OF TOGGLE-nuevoformato IN FRAME F-Main /* Nuevo formato - pequeño */
DO:
      ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF T-REPORT.Campo-C[1]
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Etiqueta-Precio B-table-Win 
PROCEDURE Imprime-Etiqueta-Precio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dPreUni  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDsctos  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dDstoVo1 AS DECIMAL     .
    DEFINE VARIABLE dDstoVo2 AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dPrecio  AS DECIMAL     NO-UNDO.

    DEF VAR x-dtovol  AS CHAR NO-UNDO FORMAT 'X(40)'.
    DEF VAR x-dtovo2  AS CHAR NO-UNDO FORMAT 'X(40)'.
    DEF VAR cNotita   AS CHAR NO-UNDO FORMAT 'X(35)'.
    DEF VAR x-cod-barra AS CHAR NO-UNDO FORMAT 'X(15)'.
    DEF VAR x-desmat  AS CHAR NO-UNDO FORMAT 'X(30)'.
    DEF VAR x-desmat2 AS CHAR NO-UNDO FORMAT 'X(20)'.
    DEF VAR x-desmar  AS CHAR NO-UNDO FORMAT 'X(30)'.
    DEF VAR x-preuni  AS CHAR NO-UNDO FORMAT 'X(12)'.
    DEF VAR x-prec-ean14  AS CHAR NO-UNDO FORMAT 'X(40)'.

    DEFINE VARIABLE lEmpqPres  AS DECIMAL.
    DEFINE VARIABLE lSec AS INT.
    DEFINE VARIABLE lEscala AS INT.

    DEFINE VAR x-fila1 AS CHAR.
    DEFINE VAR x-fila2 AS CHAR.
    DEFINE VAR x-fila3 AS CHAR.
    DEFINE VAR x-dsctopromo AS CHAR.
    DEFINE VAR x-mesyear AS CHAR.

    lEmpqPres = 0.
    ASSIGN
        x-DtoVol = ''
        x-Dtovo2 = ''
        dPrecio  = 0
        cNotita  = ''
        x-cod-barra = ''.
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
    /* Lista de Precio General  */
    IF gn-divi.CanalVenta = "MIN" THEN DO:
        FIND FIRST vtalistaminGn WHERE vtalistaminGn.codcia = s-codcia
            AND vtalistaminGn.codmat = almmmatg.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL vtalistaminGn OR vtalistaminGn.PreOfi <= 0 THEN DO:
            MESSAGE 'Articulo ' + almmmatg.codmat + ' No tiene Precio' 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN.
        END.
        IF vtalistaminGn.MonVta = 2 THEN dPreUni = vtalistaminGn.PreOfi * almmmatg.TpoCmb.
        ELSE dPreUni = vtalistaminGn.PreOfi.
        /* Si hay descuentos por promocion */
        /* Ic - 06Jun2019, recien me dijeron que habia otra tabla */
        /*
        REPEAT lSec = 1 TO 10:
            IF VtaListaMinGn.promdivi[lSec] = s-coddiv THEN DO:
                IF TODAY >= VtaListaMinGn.PromFchD[lSec] AND TODAY <= VtaListaMinGn.PromFchH[lSec] THEN DO:
                    IF VtaListaMinGn.PromDto[lSec] > 0 THEN DO:
                        dDstoVo1 = VtaListaMinGn.PromDto[lSec].
                        dPreUni  = ROUND(dPreUni * ( 1 - ( DECI(dDstoVo1) / 100 ) ),4).
                    END.
                END.
            END.
        END.
        */
        IF toggle-nuevoformato = YES THEN DO:
            FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                        vtatabla.tabla = 'DTOPROUTILEX' AND
                                        vtatabla.llave_c1 = vtalistaminGn.codmat AND
                                        vtatabla.llave_c2 = s-coddiv NO-LOCK NO-ERROR.
            IF AVAILABLE vtatabla THEN DO:
                IF TODAY >= vtatabla.rango_fecha[1] AND TODAY <= vtatabla.rango_fecha[2] THEN DO:
                    IF vtatabla.valor[1] > 0 THEN DO:
                        dDstoVo1 = vtatabla.valor[1].
                        x-dsctopromo = "Antes: S/ " + STRING(dPreUni,'>>>9.99').
                        dPreUni  = ROUND(dPreUni * ( 1 - ( DECI(dDstoVo1) / 100 ) ),4).                    
                    END.
                END.
            END.
        END.
        /* Ic - 06Jun2019 */

        /* Imprimir los primeros 2 Descuentos x Volumen */
        IF vtalistaminGn.DtoVolR[1] > 0 THEN DO:
            cNotita = '*Prom.solo para pago con efectivo.'.
            dDstoVo1 = ROUND(vtalistaminGn.PreOfi * ( 1 - ( DECI(vtalistaminGn.DtoVolD[1]) / 100 ) ),4).
            IF vtalistaminGn.MonVta = 2 THEN dPrecio = dDstoVo1 * almmmatg.TpoCmb.
            ELSE dPrecio = dDstoVo1.                
            x-DtoVol  = 'x ' + STRING(vtalistaminGn.DtoVolR[1],'>>9') + ' ' + Almmmatg.undbas + '= S/' + STRING(dPrecio,">>9.99") + ' c/u'. 
        END.
        IF vtalistaminGn.DtoVolR[2] > 0 THEN DO:
            dDstoVo2 = ROUND(vtalistaminGn.PreOfi * ( 1 - ( DECI(vtalistaminGn.DtoVolD[2]) / 100 ) ),4).
            IF vtalistaminGn.MonVta = 2 THEN dPrecio = dDstoVo2 * almmmatg.TpoCmb.
            ELSE dPrecio = dDstoVo2.                
            x-DtoVo2  = 'x ' + STRING(vtalistaminGn.DtoVolR[2],'>>9') + ' ' + Almmmatg.undbas + '= S/' + STRING(dPrecio,">>9.99") + ' c/u'. 
        END.
    END.
    ASSIGN 
        x-DesMat  = TRIM(SUBSTRING(Almmmatg.Desmat,1,30))
        x-DesMat2 = TRIM(SUBSTRING(Almmmatg.Desmat,31))
        x-DesMar  = SUBSTRING(Almmmatg.Desmar,1,18)
        x-PreUni  = 'S/' + STRING(dPreUni,'>>>9.99').    

    x-cod-barra = Almmmatg.CodBrr.
    x-prec-ean14 = "".
    /* Ic - 10Nov2017, Cristian Huarac, correo 08Nov2017 */
    DEFINE VAR lBarraEan14 AS CHAR.
    DEFINE VAR lIndiceBarra AS INT.

    /* Que precio se imprime ? */
    FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
        factabla.tabla = "PRECIOSEAN14" AND
        factabla.codigo = almmmatg.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE factabla AND (factabla.valor[1] > 0 AND factabla.valor[1] < 5) THEN DO:
        /* Se imprime el precio del EAN que se configuro */
        FIND FIRST almmmat1 WHERE almmmat1.codcia = s-codcia AND
            almmmat1.codmat = almmmatg.codmat NO-ERROR.
        IF AVAILABLE almmmat1 THEN DO:
            lIndiceBarra = factabla.valor[1].
            lBarraEan14 = almmmat1.barras[lIndiceBarra].
            if NOT (TRUE <> (lBarraEan14 > "")) THEN DO:
                IF almmmat1.equival[lIndicebarra] > 0 THEN DO:
                    x-preuni = "S/" + STRING((dPreuni * almmmat1.equival[lIndicebarra]),'>>>9.99').
                    x-prec-ean14 = "(precio x " + STRING(almmmat1.equival[lIndicebarra],'>>9') + " " + TRIM(Almmmatg.undbas) + ")".
                    x-cod-barra = lBarraEan14.
                END.
            END.
        END.
    END.

    x-mesyear = STRING(TODAY,"99/99/9999").
    x-mesyear = SUBSTRING(x-mesyear,4,2) + SUBSTRING(x-mesyear,9,2).

    /* Envio a TEXTO */
    /*
    DEFINE VAR x-file AS CHAR.
    x-file = "D:\codigo-" + almmmatg.codmat + ".txt".
    /*OUTPUT STREAM REPORTE TO d:\vineta.txt.*/
    OUTPUT STREAM REPORTE TO VALUE(x-file).
    */
    PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
    IF toggle-nuevoformato = YES THEN DO:
        {alm/eti-gondolas02-formatochico.i}
    END.
    ELSE DO:
        {alm/eti-gondolas02-01.i}
    END.
    
    PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
    PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
    PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-registro B-table-Win 
PROCEDURE Imprime-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-articulos.
    CREATE tt-articulos.        

    ASSIGN t-codmat = T-REPORT.Campo-C[1].

    DEF VAR k AS INT NO-UNDO.

    OUTPUT STREAM REPORTE TO PRINTER.
    DO k = 1 TO FILL-IN-Copias:
        FOR EACH tt-articulos NO-LOCK:
            RUN Imprime-Etiqueta-Precio.
        END.
    END.
    OUTPUT STREAM reporte CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      T-REPORT.Campo-C[2] = Almmmatg.codbrr
      T-REPORT.Campo-C[3] = Almmmatg.desmat.
  ASSIGN FRAME {&FRAME-NAME} FILL-IN-Copias.
  RUN Imprime-registro.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ENABLE BUTTON-Seleciona-Printer FILL-IN-Copias.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISABLE BUTTON-Seleciona-Printer FILL-IN-Copias.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FILL-IN-Impresora = SESSION:PRINTER-NAME.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */
    CASE HANDLE-CAMPO:name:
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-REPORT"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = T-REPORT.Campo-C[1]:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK.
IF NOT AVAILABLE Almmmatg THEN DO:        
    BELL.
    T-REPORT.Campo-C[1]:SCREEN-VALUE IN BROWSE {&browse-name} = ''.
    APPLY 'ENTRY':U TO T-REPORT.Campo-C[1].
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

