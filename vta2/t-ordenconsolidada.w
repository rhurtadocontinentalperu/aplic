&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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
DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES FacDPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacDPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacDPedi.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PEDI FacCPedi Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI.codmat PEDI.CanPed PEDI.CodDoc ~
PEDI.NroPed FacCPedi.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI WHERE PEDI.codmat = FacDPedi.codmat NO-LOCK, ~
      FIRST FacCPedi OF PEDI NO-LOCK, ~
      FIRST Almmmatg OF PEDI NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI WHERE PEDI.codmat = FacDPedi.codmat NO-LOCK, ~
      FIRST FacCPedi OF PEDI NO-LOCK, ~
      FIRST Almmmatg OF PEDI NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table PEDI FacCPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmatg


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
      PEDI, 
      FacCPedi, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
      PEDI.CanPed FORMAT ">,>>>,>>9.9999":U
      PEDI.CodDoc FORMAT "x(3)":U
      PEDI.NroPed COLUMN-LABEL "Numero O/D" FORMAT "X(9)":U
      FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(50)":U WIDTH 38.86
  ENABLE
      PEDI.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 87 BY 6.69
         FONT 4
         TITLE "ARTICULOS POR O/D ORIGINAL" FIT-LAST-COLUMN.


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
   External Tables: INTEGRAL.FacDPedi
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "SHARED" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 6.85
         WIDTH              = 88.43.
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
     _TblList          = "Temp-Tables.PEDI WHERE INTEGRAL.FacDPedi <external> ...,INTEGRAL.FacCPedi OF Temp-Tables.PEDI,INTEGRAL.Almmmatg OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST"
     _JoinCode[1]      = "Temp-Tables.PEDI.codmat = FacDPedi.codmat"
     _FldNameList[1]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.PEDI.CodDoc
     _FldNameList[4]   > Temp-Tables.PEDI.NroPed
"PEDI.NroPed" "Numero O/D" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "38.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* ARTICULOS POR O/D ORIGINAL */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* ARTICULOS POR O/D ORIGINAL */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* ARTICULOS POR O/D ORIGINAL */
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

ON 'return':U OF PEDI.CanPed
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-OC B-table-Win 
PROCEDURE Actualiza-OC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 3ro Volvemos a grabar todo */
    RUN Genera-Pedido.    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    FIND CURRENT Faccpedi NO-LOCK NO-ERROR.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "FacDPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacDPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido B-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/i-borra-pedido-consolidado.i}

/*
  DEFINE VARIABLE r-Rowid AS ROWID NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      /* Bloqueamos Cabeceras */
      FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
          AND PEDIDO.coddoc = Faccpedi.codref
          AND PEDIDO.nroped = Faccpedi.nroref
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE PEDIDO THEN DO:
          pMensaje = "NO se pudo extornar el " + PEDIDO.codref + " " + PEDIDO.nroref.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
          AND COTIZACION.coddiv = PEDIDO.coddiv
          AND COTIZACION.coddoc = PEDIDO.codref
          AND COTIZACION.nroped = PEDIDO.nroref
          EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          pMensaje = "NO se pudo extornar la " + COTIZACION.codref + " " + COTIZACION.nroref.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      /* Actualizamos saldo de cotización */
      FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = COTIZACION.codcia
          AND B-DPEDI.coddiv = COTIZACION.coddiv
          AND B-DPEDI.coddoc = COTIZACION.coddoc
          AND B-DPEDI.nroped = COTIZACION.nroped
          AND B-DPEDI.codmat = PEDI.codmat
          AND B-DPEDI.libre_c05 = PEDI.libre_c05    /* Producto Promocional */
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPEDI THEN DO:
          pMensaje = "ERROR EN COTIZACION" + CHR(10) +
              "No se pudo extornar el artículo " + PEDI.codmat.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          B-DPEDI.canate = B-DPEDI.canate - PEDI.canped.
      ASSIGN
          COTIZACION.FlgEst = "P".
      /* Borramos detalles PEDIDO */
      FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = PEDIDO.codcia
          AND B-DPEDI.coddiv = PEDIDO.coddiv
          AND B-DPEDI.coddoc = PEDIDO.coddoc
          AND B-DPEDI.nroped = PEDIDO.nroped
          AND B-DPEDI.codmat = PEDI.codmat
          AND B-DPEDI.libre_c05 = PEDI.libre_c05    /* Producto Promocional */
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPEDI THEN DO:
          pMensaje = "ERROR EN PEDIDO" + CHR(10) +
              "No se pudo extornar el artículo " + PEDI.codmat.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      /* Borramos detalle O/D */
      DELETE B-DPEDI.
      FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = PEDI.codcia
          AND B-DPEDI.coddiv = PEDI.coddiv
          AND B-DPEDI.coddoc = PEDI.coddoc      /* O/D */
          AND B-DPEDI.nroped = PEDI.nroped
          AND B-DPEDI.codmat = PEDI.codmat
          AND B-DPEDI.libre_c05 = PEDI.libre_c05
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPEDI THEN DO:
          pMensaje = "ERROR EN O/D" + CHR(10) +
              "No se pudo extornar el artículo " + PEDI.codmat.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      DELETE B-DPEDI.

      ASSIGN r-Rowid = ROWID(Faccpedi).
      RUN Recalcular-Pedido.
      FIND Faccpedi WHERE ROWID(Faccpedi) = r-Rowid.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = "NO se pudo recalcular el " + PEDIDO.codref + " " + PEDIDO.nroref.
          UNDO, RETURN 'ADM-ERROR'.
      END.

  END.
  RETURN 'OK'.
*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido B-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
   DEFINE VARIABLE r-Rowid AS ROWID NO-UNDO.

   rloop:
   DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
       /* Bloqueamos Cabeceras */
       FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
           AND PEDIDO.coddoc = Faccpedi.codref
           AND PEDIDO.nroped = Faccpedi.nroref
           EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE PEDIDO THEN DO:
           pMensaje = "NO se pudo actualizar el " + PEDIDO.codref + " " + PEDIDO.nroref.
           UNDO, RETURN 'ADM-ERROR'.
       END.
       FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
           AND COTIZACION.coddiv = PEDIDO.coddiv
           AND COTIZACION.coddoc = PEDIDO.codref
           AND COTIZACION.nroped = PEDIDO.nroref
           EXCLUSIVE-LOCK NO-ERROR.
       IF ERROR-STATUS:ERROR = YES THEN DO:
           pMensaje = "NO se pudo actualizar la " + COTIZACION.codref + " " + COTIZACION.nroref.
           UNDO, RETURN 'ADM-ERROR'.
       END.
       /* Regeneramos O/D */
       FOR EACH B-DPEDI OF Faccpedi NO-LOCK:
           I-NITEM = I-NITEM + 1.
       END.
       I-NITEM = I-NITEM + 1.
       CREATE B-DPEDI. 
       BUFFER-COPY PEDI TO B-DPEDI
           ASSIGN  
           B-DPEDI.CodCia  = FacCPedi.CodCia 
           B-DPEDI.coddiv  = FacCPedi.coddiv 
           B-DPEDI.coddoc  = FacCPedi.coddoc 
           B-DPEDI.NroPed  = FacCPedi.NroPed 
           B-DPEDI.FchPed  = FacCPedi.FchPed
           B-DPEDI.Hora    = FacCPedi.Hora 
           B-DPEDI.FlgEst  = FacCPedi.FlgEst
           B-DPEDI.NroItm  = I-NITEM
           B-DPEDI.CanAte  = 0
           B-DPEDI.CanSol  = PEDI.CanPed
           B-DPEDI.CanPick = PEDI.CanPed.     /* <<< OJO <<< */
       /* Regeneramos PEDIDO */
       CREATE B-DPEDI. 
       BUFFER-COPY PEDI TO B-DPEDI
           ASSIGN
           B-DPEDI.coddiv = PEDIDO.coddiv
           B-DPEDI.coddoc = PEDIDO.coddoc
           B-DPEDI.fchped = PEDIDO.fchped
           B-DPEDI.nroped = PEDIDO.nroped
           B-DPEDI.NroItm  = I-NITEM
           B-DPEDI.CanAte  = PEDI.CanPed
           B-DPEDI.CanSol  = PEDI.CanPed
           B-DPEDI.CanPick = PEDI.CanPed.     /* <<< OJO <<< */

       ASSIGN r-Rowid = ROWID(Faccpedi).
       RUN Recalcular-Pedido.
       FIND Faccpedi WHERE ROWID(Faccpedi) = r-Rowid.
       IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
           pMensaje = "NO se pudo recalcular el " + PEDIDO.codref + " " + PEDIDO.nroref.
           UNDO, RETURN 'ADM-ERROR'.
       END.

       /* Actualizamos la cotización  */
       FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = COTIZACION.codcia
           AND B-DPEDI.coddiv = COTIZACION.coddiv
           AND B-DPEDI.coddoc = COTIZACION.coddoc
           AND B-DPEDI.nroped = COTIZACION.nroped
           AND B-DPEDI.codmat = PEDI.codmat
           AND B-DPEDI.libre_c05 = PEDI.libre_c05   /* Producto Promocional */
           EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE B-DPEDI THEN UNDO rloop, RETURN 'ADM-ERROR'.
       ASSIGN
           B-DPEDI.canate = B-DPEDI.canate + PEDI.canped.
       FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = COTIZACION.codcia
           AND B-DPEDI.coddiv = COTIZACION.coddiv
           AND B-DPEDI.coddoc = COTIZACION.coddoc
           AND B-DPEDI.nroped = COTIZACION.nroped
           AND B-DPEDI.CanAte < B-DPEDI.CanPed NO-LOCK NO-ERROR.
       IF NOT AVAILABLE B-DPEDI THEN ASSIGN COTIZACION.FlgEst = "C".
   END.

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
  DEF VAR pRowid1 AS ROWID NO-UNDO.
  DEF VAR pRowid2 AS ROWID NO-UNDO.

  ASSIGN
      pRowid1 = ROWID(Faccpedi)
      pRowid2 = ROWID(Facdpedi).

  /* 1ro. Bloquemos la ODC */
  FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi THEN DO:
      pMensaje = 'NO se pudo bloquear el documento ' + Facdpedi.coddoc + ' ' + Facdpedi.nroped.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* 2do. Bloqueamos O/D */
  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      pMensaje = 'NO se pudo bloquear el documento ' + PEDI.coddoc + ' ' + PEDI.nroped.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* 3ro extornamos */
  ASSIGN 
      Facdpedi.CanPed = Facdpedi.CanPed - PEDI.CanPed.
  RUN Borra-Pedido.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  FIND Facdpedi WHERE ROWID(Facdpedi) = pRowid2 EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi THEN DO:
      pMensaje = 'NO se pudo bloquear el documento ' + Facdpedi.coddoc + ' ' + Facdpedi.nroped.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* 3ro Volvemos a grabar todo */
  ASSIGN 
      Facdpedi.CanPed = Facdpedi.CanPed + PEDI.CanPed.
  ASSIGN
      PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                    ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
  IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
      ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.

  IF PEDI.Libre_d02 > 0 THEN DO:
      /* El flete afecta el monto final */
      IF PEDI.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          ASSIGN
              PEDI.PreUni = ROUND(PEDI.PreVta[1] + PEDI.Libre_d02, INTE(Faccpedi.Libre_d01))  /* Incrementamos el PreUni */
              PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni.
      END.
      ELSE DO:      /* CON descuento promocional o volumen */
          ASSIGN
              PEDI.ImpLin = PEDI.ImpLin + (PEDI.CanPed * PEDI.Libre_d02)
              PEDI.PreUni = ROUND( (PEDI.ImpLin + PEDI.ImpDto) / PEDI.CanPed, INTE(Faccpedi.Libre_d01)).
      END.
  END.
  ASSIGN
      PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
      PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
  IF PEDI.AftIsc 
  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE PEDI.ImpIsc = 0.
  IF PEDI.AftIgv 
  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
  ELSE PEDI.ImpIgv = 0.

  RUN Genera-Pedido.    /* Detalle del pedido */ 
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      
  {vta2/graba-totales-cotizacion-cred.i}

  FIND Facdpedi WHERE ROWID(Facdpedi) = pRowid2 NO-LOCK NO-ERROR.
  FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid1 NO-LOCK NO-ERROR.

  RUN Procesa-Handle IN lh_handle ('Repintar-Registro').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Chequeamos la O/D */                       
  IF Faccpedi.FlgSit <> "X" THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* 1ro. Bloquemos la ODC */
      DEF VAR pRowid AS ROWID NO-UNDO.
      FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Facdpedi THEN DO:
          pMensaje = 'NO se pudo bloquear el documento ' + Facdpedi.coddoc + ' ' + Facdpedi.nroped.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      pRowid = ROWID(Facdpedi).

      /* 2do. Bloqueamos O/D */
      FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Faccpedi THEN DO:
          pMensaje = 'NO se pudo bloquear el documento ' + PEDI.coddoc + ' ' + PEDI.nroped.
          UNDO, RETURN 'ADM-ERROR'.
      END.

      /* 3ro extornamos ODC */
      ASSIGN 
          Facdpedi.CanPed = Facdpedi.CanPed - PEDI.CanPed.
      IF Facdpedi.CanPed <= 0 THEN DELETE Facdpedi.
      
      RUN Borra-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      {vta2/graba-totales-cotizacion-cred.i}

      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  END.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ("Repinta-Browse" ).

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
  pMensaje = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje <> '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Pedido B-table-Win 
PROCEDURE Recalcular-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND Faccpedi OF PEDIDO EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

{vta2/graba-totales-cotizacion-cred.i}

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
  {src/adm/template/snd-list.i "FacDPedi"}
  {src/adm/template/snd-list.i "PEDI"}
  {src/adm/template/snd-list.i "FacCPedi"}
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

IF DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) = 0 THEN DO:
    MESSAGE 'NO se puede despachar cero' PEDI.UndVta
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO PEDI.CanPed.
    RETURN 'ADM-ERROR'.
END.

IF DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) > PEDI.CanSol THEN DO:
    MESSAGE 'NO se puede despachar mas de' PEDI.CanSol PEDI.UndVta
        VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO PEDI.CanPed.
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

/* Chqueamos la O/D */                       
IF Faccpedi.FlgSit <> "X" THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

