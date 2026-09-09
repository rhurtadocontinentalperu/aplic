&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE C-Detalle NO-UNDO LIKE Almdmov.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE Almdmov.



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
&Scoped-define INTERNAL-TABLES Detalle Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Detalle.NroItm Detalle.codmat ~
Almmmatg.DesMat Detalle.CodUnd Detalle.CanDes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Detalle.codmat ~
Detalle.CanDes 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Detalle
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Detalle
&Scoped-define QUERY-STRING-br_table FOR EACH Detalle WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF Detalle NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Detalle WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF Detalle NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Detalle Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Detalle
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-OrdCmp br_table 
&Scoped-Define DISPLAYED-OBJECTS x-CodPro x-NomPro x-NroRf1 

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
DEFINE BUTTON Btn-OrdCmp 
     LABEL "O/C" 
     SIZE 8.43 BY 1.08
     FONT 1.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE x-NroRf1 AS CHARACTER FORMAT "x(10)" 
     LABEL "Orden de Compra" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Detalle, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Detalle.NroItm FORMAT ">>>>9":U
      Detalle.codmat COLUMN-LABEL "Codigo" FORMAT "X(14)":U
      Almmmatg.DesMat FORMAT "X(45)":U
      Detalle.CodUnd COLUMN-LABEL "Unidad" FORMAT "X(4)":U
      Detalle.CanDes FORMAT "ZZZ,ZZZ,ZZ9.9999":U
  ENABLE
      Detalle.codmat
      Detalle.CanDes
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 72 BY 10.77
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-OrdCmp AT ROW 1.19 COL 85 WIDGET-ID 8
     x-CodPro AT ROW 1.27 COL 17 COLON-ALIGNED WIDGET-ID 2
     x-NomPro AT ROW 1.27 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     x-NroRf1 AT ROW 2.23 COL 17.14 COLON-ALIGNED WIDGET-ID 6
     br_table AT ROW 3.15 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: C-Detalle T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: Detalle T "?" NO-UNDO INTEGRAL Almdmov
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
         HEIGHT             = 13
         WIDTH              = 96.43.
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
/* BROWSE-TAB br_table x-NroRf1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-CodPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NroRf1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.Detalle,INTEGRAL.Almmmatg OF Temp-Tables.Detalle"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   = Temp-Tables.Detalle.NroItm
     _FldNameList[2]   > Temp-Tables.Detalle.codmat
"Temp-Tables.Detalle.codmat" "Codigo" "X(14)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[4]   > Temp-Tables.Detalle.CodUnd
"Temp-Tables.Detalle.CodUnd" "Unidad" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.Detalle.CanDes
"Temp-Tables.Detalle.CanDes" ? "ZZZ,ZZZ,ZZ9.9999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartBrowserCues" B-table-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartBrowser,ab,49266
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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


&Scoped-define SELF-NAME Btn-OrdCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-OrdCmp B-table-Win
ON CHOOSE OF Btn-OrdCmp IN FRAME F-Main /* O/C */
DO:
  RUN Asigna-Orden-Compra.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Detalle-Orden-Compra B-table-Win 
PROCEDURE Actualiza-Detalle-Orden-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER I-Factor AS INTEGER.

  FOR EACH Almdmov OF Almcmov NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
    FIND LG-DOCmp WHERE 
        LG-DOCmp.CodCia = Almdmov.CodCia AND
        LG-DOCmp.TpoDoc = "N" AND
        LG-DOCmp.NroDoc = INTEGER(Almcmov.NroRf1) AND
        LG-DOCmp.Codmat = Almdmov.CodMat EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE lg-docmp
    THEN LG-DOCmp.CanAten = LG-DOCmp.CanAten + (Almdmov.CanDes * I-Factor).
    RELEASE LG-DOCmp.
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Orden-Compra B-table-Win 
PROCEDURE Asigna-Orden-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  input-var-1 = "P".       /* Solo aprobadas */
  input-var-2 = ''.

  RUN LKUP\C-OCPEN("Ordenes de Compra Pendientes").

  IF output-var-1 = ? THEN RETURN.

  FIND LG-COCmp WHERE ROWID(LG-COCmp) = output-var-1 NO-LOCK NO-ERROR.

  IF AVAILABLE LG-COCmp THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        x-NroRf1 = STRING(LG-COCmp.NroDoc)
        x-CodPro = LG-COCmp.CodPro
        x-NomPro = LG-COCmp.NomPro.
    DISPLAY 
        x-NroRf1 
        x-CodPro
        x-NomPro.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerrar-Orden-Compra B-table-Win 
PROCEDURE Cerrar-Orden-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR I-NRO AS INTEGER INIT 0 NO-UNDO.

  FOR EACH LG-DOCmp NO-LOCK WHERE 
            LG-DOCmp.CodCia = s-CodCia AND
            LG-DOCmp.TpoDoc = "N" AND
            LG-DOCmp.NroDoc = INTEGER(Almcmov.NroRf1):
       IF (LG-DOCmp.CanPedi - LG-DOCmp.CanAten) > 0 THEN DO:
          I-NRO = 1.
          LEAVE.
       END.
  END.

  FIND LG-COCmp WHERE 
        LG-COCmp.CodCia = Almcmov.CodCia AND
        LG-COCmp.TpoDoc = "N" AND
        LG-COCmp.NroDoc = INTEGER(Almcmov.NroRf1) EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
  IF I-NRO = 0 THEN LG-COCmp.FlgSit = "T".
  ELSE              LG-COCmp.FlgSit = "P".
  LG-COCmp.FchAte = Almcmov.FchDoc.
  RELEASE LG-COCmp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-Guia B-table-Win 
PROCEDURE Cierre-de-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Primero veamos si es consistente */
  FOR EACH C-Detalle:
    DELETE C-Detalle.
  END.
  
  FOR EACH Detalle:
    FIND C-Detalle WHERE C-Detalle.codmat = Detalle.codmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE C-Detalle THEN CREATE C-Detalle.
    BUFFER-COPY Detalle TO C-Detalle
        ASSIGN
            C-Detalle.candes = C-Detalle.candes + Detalle.candes
            C-Detalle.ImpCto = ROUND(C-Detalle.CanDes * C-Detalle.PreUni,2).

  END.

  FOR EACH Lg-docmp NO-LOCK WHERE Lg-docmp.codcia = s-codcia
        AND Lg-docmp.nrodoc = INTEGER(x-nrorf1):
    FIND C-Detalle WHERE C-Detalle.codmat = Lg-docmp.codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE C-Detalle THEN DO:
        MESSAGE 'No se ha registrado el artículo' Lg-docmp.codmat
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF C-Detalle.CanDes > (Lg-docmp.CanPed - LG-DOCmp.CanAten) THEN DO:
        MESSAGE 'Se ha excedido la cantidad en el artículo' Lg-docmp.codmat
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
  END.        

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE Almcmov.
    ASSIGN 
        Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.CodAlm  = Almtdocm.CodAlm 
        Almcmov.TipMov  = Almtdocm.TipMov
        Almcmov.CodMov  = Almtdocm.CodMov
        Almcmov.NroSer  = 000
        Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
        Almcmov.CodPro  = x-CodPro
        Almcmov.NroRf1  = x-NroRf1
        Almcmov.NomRef  = x-NomPro.
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
        Almacen.CodAlm = Almtdocm.CodAlm EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.        
    ASSIGN 
        Almcmov.NroDoc = Almacen.CorrIng
        Almacen.CorrIng = Almacen.CorrIng + 1.
    ASSIGN 
        Almcmov.usuario = S-USER-ID
        Almcmov.ImpIgv  = 0
        Almcmov.ImpMn1  = 0
        Almcmov.ImpMn2  = 0.

    /* GENERAMOS NUEVO DETALLE */
    RUN Genera-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    IF Almcmov.codmon = 1 
    THEN ASSIGN Almcmov.ImpMn2 = ROUND(Almcmov.ImpMn1 / Almcmov.tpocmb, 2).
    ELSE ASSIGN Almcmov.ImpMn1 = ROUND(Almcmov.ImpMn2 * Almcmov.tpocmb, 2).
  
    RUN Actualiza-Detalle-Orden-Compra(1).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RUN Cerrar-Orden-Compra.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    CREATE LogTabla.
    ASSIGN
        logtabla.codcia = s-codcia
        logtabla.Dia    = TODAY
        logtabla.Evento = 'CHEQUEADO'
        logtabla.Hora   = STRING(TIME, 'HH:MM')
        logtabla.Tabla  = 'Lg-cocmp'
        logtabla.Usuario = s-user-id
        logtabla.ValorLlave = STRING(x-NroRf1).
    RELEASE Almacen.
    RELEASE Almcmov.
    RELEASE LogTabla.
  END.
  
  /* INICIALIZAMOS VARIABLES Y TEMPORALES */
  FOR EACH Detalle:
    DELETE Detalle.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  ASSIGN
    x-CodPro = ''
    x-NomPro = ''
    x-NroRF1 = ''.
  DISPLAY x-CodPro x-NomPro x-NroRF1 WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle B-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR F-PesUnd AS DECIMAL NO-UNDO.

  FOR EACH C-Detalle WHERE C-Detalle.codmat <> "" 
        ON ERROR UNDO, RETURN "ADM-ERROR"
        ON STOP UNDO, RETURN "ADM-ERROR":
    CREATE almdmov.
    ASSIGN 
        Almdmov.CodCia = Almcmov.CodCia 
        Almdmov.CodAlm = Almcmov.CodAlm 
        Almdmov.TipMov = Almcmov.TipMov 
        Almdmov.CodMov = Almcmov.CodMov 
        Almdmov.NroSer = Almcmov.NroSer 
        Almdmov.NroDoc = Almcmov.NroDoc 
        Almdmov.CodMon = Almcmov.CodMon 
        Almdmov.FchDoc = Almcmov.FchDoc 
        Almdmov.TpoCmb = Almcmov.TpoCmb
        Almdmov.codmat = C-Detalle.codmat
        Almdmov.CanDes = C-Detalle.CanDes
        Almdmov.CodUnd = C-Detalle.CodUnd
        Almdmov.Factor = C-Detalle.Factor
        Almdmov.Pesmat = C-Detalle.Pesmat
        Almdmov.ImpCto = ROUND(C-Detalle.CanDes * C-Detalle.PreUni,2)
        Almdmov.PreLis = C-Detalle.PreLis
        Almdmov.PreUni = C-Detalle.PreUni
        Almdmov.Dsctos[1] = C-Detalle.Dsctos[1]
        Almdmov.Dsctos[2] = C-Detalle.Dsctos[2]
        Almdmov.Dsctos[3] = C-Detalle.Dsctos[3]
        Almdmov.IgvMat = C-Detalle.IgvMat
        Almdmov.CodAjt = 'A'
        Almdmov.HraDoc = Almcmov.HorRcp
               R-ROWID = ROWID(Almdmov).
    FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
        AND Almmmatg.CodMat = Almdmov.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg AND NOT Almmmatg.AftIgv THEN  Almdmov.IgvMat = 0.
    RUN ALM\ALMACSTK (R-ROWID).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN ALM\ALMACPR1 (R-ROWID,"U").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE
    RUN ALM\ALMACPR2 (R-ROWID,"U").
    *************************************************** */
        
    IF Almcmov.codmon = 1 THEN DO:
        Almcmov.ImpMn1 = Almcmov.ImpMn1 + Almdmov.ImpMn1.
    END.
    ELSE DO:
          Almcmov.ImpMn2 = Almcmov.ImpMn2 + Almdmov.ImpMn2.
    END.

/*
    /* Actualiza el Peso del Material  */
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
         Almmmatg.codmat = C-Detalle.Codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg AND Almmmatg.Pesmat > 0 
    THEN DO:
         FIND CURRENT Almmmatg EXCLUSIVE-LOCK NO-ERROR.
         IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
         F-PesUnd = ROUND(C-Detalle.Pesmat / (C-Detalle.Candes * C-Detalle.Factor) * 1000, 3).
         IF ABS((F-PesUnd * 100 / Almmmatg.Pesmat) - 100) <= 4 
         THEN ASSIGN Almmmatg.Pesmat = F-PesUnd.
         RELEASE Almmmatg.
    END.
*/

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF x-NroRf1 = '' THEN DO:
    MESSAGE 'Debe ingresar primero la Orden de Compra'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.
  
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    DEF BUFFER B-DETA FOR Detalle.
    FOR EACH B-DETA NO-LOCK BY B-DETA.NroItm:
        x-Item = x-Item + 1.
    END.
  END.
  ELSE x-Item = Detalle.NroItm.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    Detalle.codcia = s-codcia
    Detalle.codalm = s-codalm
    Detalle.nroitm = x-item
    Detalle.codund = Lg-docmp.undcmp
    Detalle.candes = DECIMAL(Detalle.candes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    Detalle.PreLis = LG-DOCmp.PreUni
    Detalle.Dsctos[1] = LG-DOCmp.Dsctos[1]
    Detalle.Dsctos[2] = LG-DOCmp.Dsctos[2]
    Detalle.Dsctos[3] = LG-DOCmp.Dsctos[3]
    Detalle.IgvMat = LG-DOCmp.IgvMat
    Detalle.PreUni = ROUND(LG-DOCmp.PreUni * (1 - (LG-DOCmp.Dsctos[1] / 100)) * 
                            (1 - (LG-DOCmp.Dsctos[2] / 100)) * 
                            (1 - (LG-DOCmp.Dsctos[3] / 100)),4)
    Detalle.ImpCto = ROUND(Detalle.CanDes * Detalle.PreUni,2).
    
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND  Almmmatg.codmat = Detalle.codmat  
        NO-LOCK NO-ERROR.
         
  FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Detalle.CodUnd 
        NO-LOCK NO-ERROR.
  Detalle.Factor = Almtconv.Equival / Almmmatg.FacEqu.

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
  {src/adm/template/snd-list.i "Detalle"}
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

