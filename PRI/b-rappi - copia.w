&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
DEF SHARED VAR s-codcia AS INTE.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE Detalle
    FIELD Referencia_Aliado AS CHAR FORMAT 'x(8)'
    FIELD Sku AS CHAR FORMAT 'x(13)' 
    FIELD Nombre AS CHAR FORMAT 'x(100)'
    FIELD Descripcion AS CHAR FORMAT 'x(100)'
    FIELD Marca AS CHAR FORMAT 'x(30)'
    FIELD Stock AS INTE FORMAT '>>>>>>>>9'
    FIELD Tienda AS CHAR FORMAT 'x(8)'
    FIELD Precio_Por_Tienda AS DECI FORMAT '>>>>>>>>9.99'
    FIELD Precio_Con_Descuento AS DECI FORMAT '>>>>>>>>9.99'
    FIELD Descuento AS DECI FORMAT '>>>>>9.9999'
    FIELD Fecha_Inicio_Descuento AS CHAR FORMAT 'x(10)'
    FIELD Fecha_Fin_Descuento AS CHAR FORMAT 'x(10)'
    FIELD Categoria_Producto_1 AS CHAR FORMAT 'x(8)'
    FIELD Categoria_Producto_2 AS CHAR FORMAT 'x(8)'
    FIELD Categoria_Producto_3 AS CHAR FORMAT 'x(8)'
    FIELD Categoria_Producto_4 AS CHAR FORMAT 'x(8)'
    FIELD Imagen_de_Producto AS CHAR
    FIELD Categoria_Combinacion AS CHAR
    FIELD Nombre_Combinacion AS CHAR
    .

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES GN-DIVI
&Scoped-define FIRST-EXTERNAL-TABLE GN-DIVI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR GN-DIVI.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaListaMay Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaListaMay.codmat Almmmatg.DesMat ~
Almmmatg.DesMar ~
(IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * VtaListaMay.PreOfi @ VtaListaMay.PreOfi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH VtaListaMay OF GN-DIVI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF VtaListaMay NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaListaMay OF GN-DIVI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF VtaListaMay NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaListaMay Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaListaMay
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaListaMay, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaListaMay.codmat FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 60.86
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * VtaListaMay.PreOfi @ VtaListaMay.PreOfi COLUMN-LABEL "Precio en S/"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 109 BY 16.96
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.GN-DIVI
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 17.04
         WIDTH              = 128.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaListaMay OF INTEGRAL.GN-DIVI,INTEGRAL.Almmmatg OF INTEGRAL.VtaListaMay"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   = INTEGRAL.VtaListaMay.codmat
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "60.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"(IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * VtaListaMay.PreOfi @ VtaListaMay.PreOfi" "Precio en S/" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "GN-DIVI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "GN-DIVI"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Texto B-table-Win 
PROCEDURE Genera-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPorStock AS DEC.

IF NOT AVAILABLE Gn-Divi THEN RETURN.

DEF VAR cArchivo AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-DIR cArchivo TITLE "Seleccione la carpeta de destino".
IF TRUE <> (cArchivo > '') THEN RETURN.

DEF BUFFER TIENDAS FOR Gn-Divi.
DEF BUFFER B-DIVI FOR Gn-Divi.

DEF VAR x-StkAct AS INTE NO-UNDO.


SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE Detalle.
/* Barremos por cada precio registrado en la lista de precios y
    por cada ID Rappi registrado
*/
FOR EACH VtaListaMay NO-LOCK WHERE VtaListaMay.CodCia = gn-divi.codcia
        AND VtaListaMay.CodDiv = gn-divi.coddiv,
    FIRST Almmmatg OF VtaListaMay NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK,
    EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
        AND FacTabla.Tabla = 'IDRAPPI',
    FIRST TIENDAS NO-LOCK WHERE TIENDAS.codcia = s-codcia
        AND TIENDAS.coddiv = FacTabla.Codigo:
    x-StkAct = 0.
    FOR EACH VtaAlmDiv OF TIENDAS NO-LOCK,
        FIRST Almacen OF VtaAlmDiv NO-LOCK,
        FIRST B-DIVI OF Almacen NO-LOCK
        BY VtaAlmDiv.Orden:
        FIND Almmmate WHERE Almmmate.codcia = s-CodCia
            AND Almmmate.codalm = VtaAlmDiv.CodAlm
            AND Almmmate.codmat = VtaListaMay.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            x-StkAct = Almmmate.StkAct.
            LEAVE.
        END.
    END.
    x-StkAct = x-StkAct * pPorStock / 100.
    IF x-StkAct < 0 THEN x-StkAct = 0.
    CREATE Detalle.
    ASSIGN
        Detalle.Referencia_Aliado = VtaListaMay.CodMat
        Detalle.Sku = VtaListaMay.CodMat        /*Almmmatg.CodBrr*/
        Detalle.Nombre = Almmmatg.DesMat
        Detalle.Descripcion = Almmmatg.DesMat
        Detalle.Marca = Almmmatg.DesMar
        Detalle.Stock = x-StkAct
        Detalle.Tienda = FacTabla.Campo-C[1] 
        Detalle.Precio_Por_Tienda = ROUND(VtaListaMay.PreOfi * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1),2)
        Detalle.Precio_Con_Descuento = 0
        Detalle.Descuento = 0
        Detalle.Fecha_Inicio_Descuento = ''
        Detalle.Fecha_Fin_Descuento = ''
        Detalle.Categoria_Producto_1 = Almtfami.desfam
        Detalle.Categoria_Producto_2 = AlmSFami.dessub
        Detalle.Categoria_Producto_3 = ''
        Detalle.Categoria_Producto_4 = ''
        Detalle.Imagen_de_Producto = ''
        Detalle.Categoria_Combinacion = ''
        Detalle.Nombre_Combinacion = ''
        .
    FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia
        AND VtaDctoProm.CodDiv = gn-divi.CodDiv
        AND VtaDctoProm.CodMat = VtaListaMay.CodMat
        AND TODAY >= VtaDctoProm.FchIni
        AND TODAY <= VtaDctoProm.FchFin:
        ASSIGN
            Detalle.Descuento = VtaDctoProm.Descuento / 100
            Detalle.Precio_Con_Descuento = ROUND(VtaDctoProm.Precio * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1),2)
            Detalle.Fecha_Inicio_Descuento = STRING(VtaDctoProm.FchIni,'99-99-9999')
            Detalle.Fecha_Fin_Descuento = STRING(VtaDctoProm.FchFin,'99-99-9999')
            .
    END.
END.

/* Archivo separa por TABs */
cArchivo = cArchivo + '\RAPPI ' + STRING(DAY(TODAY), '99') + ' ' +
    STRING(MONTH(TODAY), '99') + ' ' + SUBSTRING(STRING(YEAR(TODAY)),3,2) +
    '.csv'.

DEF VAR x-Titulo AS CHAR NO-UNDO.

x-Titulo = 'Referencia_Aliado;Sku;Nombre;Descripcion;Marca;Stock;Tienda;Precio_Por_Tienda;Precio_Con_Descuento;~
Descuento;Fecha_Inicio_Descuento;Fecha_Fin_Descuento;~
Categoria_Producto_1;Categoria_Producto_2;Categoria_Producto_3;Categoria_Producto_4;~
Imagen_de_Producto;Categoria_Combinacion;Nombre_Combinacion'.
x-Titulo = REPLACE(x-Titulo,';',"~011").

OUTPUT TO VALUE(cArchivo).
PUT UNFORMATTED x-Titulo SKIP.
FOR EACH Detalle NO-LOCK:
    PUT UNFORMATTED
        Detalle.Referencia_Aliado       "~011"
        Detalle.Sku                     "~011"
        Detalle.Nombre                  "~011"
        Detalle.Descripcion             "~011"
        Detalle.Marca                   "~011"
        Detalle.Stock                   "~011"
        Detalle.Tienda                  "~011"
        Detalle.Precio_Por_Tienda       "~011"
        Detalle.Precio_Con_Descuento    "~011"
        Detalle.Descuento               "~011"
        Detalle.Fecha_Inicio_Descuento  "~011"
        Detalle.Fecha_Fin_Descuento     "~011"
        Detalle.Categoria_Producto_1    "~011"
        Detalle.Categoria_Producto_2    "~011"
        Detalle.Categoria_Producto_3    "~011"
        Detalle.Categoria_Producto_4    "~011"
        Detalle.Imagen_de_Producto      "~011"
        Detalle.Categoria_Combinacion   "~011"
        Detalle.Nombre_Combinacion      "~011"
        SKIP.
END.
OUTPUT CLOSE.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.


/*
OUTPUT TO VALUE(cArchivo).
PUT UNFORMATTED
    'Referencia_Aliado;Sku;Nombre;Descripcion;Marca;Stoc;Tienda;Precio_Por_Tienda;Precio_Con_Descuento;~
Descuento;Fecha_Inicio_DEscuento;Fecha_Fin_Descuento;~
Categoria_Producto_1;Categoria_Producto_2;Categoria_Producto_3;Categoria_Producto_4;~
Imagen_de_Producto;Categoria_Combinacion;Nombre_Combinacion'
    SKIP.
FOR EACH Detalle NO-LOCK:
    EXPORT DELIMITER ';' Detalle.
END.
OUTPUT CLOSE.

*/

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
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "VtaListaMay"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

