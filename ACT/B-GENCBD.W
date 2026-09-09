&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR s-periodo AS INTEGER.
DEFINE SHARED VAR s-NroMes  AS INTEGER.
DEFINE SHARED VAR s-NomCia  AS CHAR.
DEFINE SHARED VAR s-User-Id AS CHAR.

DEFINE TEMP-TABLE T-DMOV LIKE CB-DMOV.

DEFINE VAR x-OpeAju AS CHAR.
DEFINE VAR x-OpeDep AS CHAR.

DEFINE VAR x-CodOpe AS CHAR.
DEFINE VAR x-NroAst AS CHAR.

x-NroAst = STRING(s-NroMes,"99") + "0001".

DEF VAR x-msg1 AS CHAR FORMAT "X(60)".
DEF VAR x-msg2 AS CHAR FORMAT "X(60)".

DEFINE FRAME F-MENSAJE 
       x-msg1 NO-LABEL  SKIP
       x-msg2 NO-LABEL  SKIP
       WITH CENTERED
       TITLE "Espere un Momento por Favor" 
       VIEW-AS DIALOG-BOX KEEP-TAB-ORDER  
       SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
       BGCOLOR 15 FGCOLOR 0.  

DEF VAR U-DIA-MES AS DATE.

DEFINE BUFFER DETALLE FOR CB-DMOV.

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
&Scoped-define INTERNAL-TABLES T-DMOV

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DMOV.Codope T-DMOV.CodDiv T-DMOV.Codcta T-DMOV.Codmon T-DMOV.CodDoc T-DMOV.NroDoc T-DMOV.NroRef T-DMOV.Glodoc T-DMOV.TpoMov T-DMOV.ImpMn1   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH T-DMOV WHERE T-DMOV.CodOpe = x-CodOpe             NO-LOCK {&SORTBY-PHRASE}.  RUN TOTAL-SUMAS
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH T-DMOV WHERE T-DMOV.CodOpe = x-CodOpe             NO-LOCK {&SORTBY-PHRASE}.  RUN TOTAL-SUMAS.
&Scoped-define TABLES-IN-QUERY-br_table T-DMOV
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DMOV


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-6 C-TpoLib B-IMPRIME br_table 
&Scoped-Define DISPLAYED-OBJECTS C-TpoLib F-SumDbe F-SumHbe 

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
DEFINE BUTTON B-IMPRIME 
     IMAGE-UP FILE "img\pvprint1":U
     LABEL "Imprimir" 
     SIZE 3.57 BY .96.

DEFINE VARIABLE C-TpoLib AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Ajustes","Depreciaci¢n" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE F-SumDbe AS DECIMAL FORMAT "-Z,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Total Debe" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81 NO-UNDO.

DEFINE VARIABLE F-SumHbe AS DECIMAL FORMAT "-Z,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Total Haber" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.57 BY 1.27.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.43 BY 1.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      T-DMOV.Codope COLUMN-LABEL "Cod!Ope"
      T-DMOV.CodDiv 
      T-DMOV.Codcta
      T-DMOV.Codmon
      T-DMOV.CodDoc
      T-DMOV.NroDoc
      T-DMOV.NroRef
      T-DMOV.Glodoc
      T-DMOV.TpoMov
      T-DMOV.ImpMn1
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 76.43 BY 6.73
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     C-TpoLib AT ROW 1.19 COL 1.72 NO-LABEL
     B-IMPRIME AT ROW 1.19 COL 73.14
     br_table AT ROW 2.35 COL 1
     F-SumDbe AT ROW 9.27 COL 41.14 COLON-ALIGNED
     F-SumHbe AT ROW 9.27 COL 64 COLON-ALIGNED
     RECT-7 AT ROW 1 COL 1
     RECT-6 AT ROW 9.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
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
         HEIGHT             = 9.35
         WIDTH              = 76.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{aplic/act/def-imp.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table B-IMPRIME F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX C-TpoLib IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN F-SumDbe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-SumHbe IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH T-DMOV WHERE T-DMOV.CodOpe = x-CodOpe
            NO-LOCK {&SORTBY-PHRASE}.

RUN TOTAL-SUMAS.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
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

&Scoped-define SELF-NAME B-IMPRIME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-IMPRIME B-table-Win
ON CHOOSE OF B-IMPRIME IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN C-TpoLib.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME C-TpoLib
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-TpoLib B-table-Win
ON VALUE-CHANGED OF C-TpoLib IN FRAME F-Main
DO:
  IF C-TpoLib:SCREEN-VALUE = "Ajustes" THEN x-CodOpe = x-OpeAju.
  ELSE x-CodOpe = x-OpeDep. 
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GENERA-CBD B-table-Win 
PROCEDURE GENERA-CBD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  x-msg1 = "Eliminando Movimiento Anterior".
  DISPLAY x-msg1 WITH FRAME F-MENSAJE.
  PAUSE 0.

FOR EACH cb-dmov WHERE cb-dmov.Codcia  = s-codcia  AND
                       cb-dmov.Periodo = s-periodo AND
                       cb-dmov.NroMes  = s-NroMes  AND
                       cb-dmov.CodOpe  = x-OpeAju  AND
                       cb-dmov.NroAst  = x-NroAst :
    RUN cbd/cb-acmd(RECID(cb-dmov),NO,YES).
    DELETE cb-dmov.                       
END.

  x-msg1 = "Eliminando Movimiento Anterior".
  DISPLAY x-msg1 WITH FRAME F-MENSAJE.
  PAUSE 0.
  
FOR EACH cb-dmov WHERE cb-dmov.Codcia  = s-codcia  AND
                       cb-dmov.Periodo = s-periodo AND
                       cb-dmov.NroMes  = s-NroMes  AND
                       cb-dmov.CodOpe  = x-OpeDep  AND
                       cb-dmov.NroAst  = x-NroAst :
    RUN cbd/cb-acmd(RECID(cb-dmov),NO,YES).
    DELETE cb-dmov.                       
END.

HIDE FRAME F-MENSAJE.

RUN GENERA-DETALLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GENERA-DETALLE B-table-Win 
PROCEDURE GENERA-DETALLE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-NroItm AS INTEGER.
DEFINE VAR c-CodOpe AS CHAR.

FOR EACH T-DMOV BREAK BY codOpe :
    IF FIRST-OF(CodOpe) THEN DO :
       c-CodOpe = T-DMOV.CodOpe.
       x-msg1 = "Actualizando a Contabilidad ... ".
       x-msg2 = "Operaci¢n : " + c-CodOpe.
       DISPLAY x-msg1 x-msg2 WITH FRAME F-MENSAJE.
       PAUSE 0.
       x-NroItm = 0.
       FIND cb-cmov WHERE cb-cmov.CodCia  = s-codcia  AND
                   cb-cmov.Periodo = s-periodo AND
                   cb-cmov.NroMes  = s-NroMes  AND
                   cb-cmov.CodOPe  = c-CodOpe  AND
                   cb-cmov.NroAst  = x-NroAst
                   NO-ERROR.
                     
       IF NOT AVAIL cb-cmov THEN CREATE cb-cmov.
       
       ASSIGN cb-cmov.CodCia  = s-CodCia
              cb-cmov.Periodo = s-periodo
              cb-cmov.NroMes  = s-NroMes
              cb-cmov.CodOPe  = c-CodOpe
              cb-cmov.NroAst  = x-NroAst
              cb-cmov.NotAst  = "ASIENTO AUTOMATICO ACTIVOS"
              cb-cmov.GloAst  = "ASIENTO AUTOMATICO ACTIVOS"
              cb-cmov.fchast  = u-dia-mes
              cb-cmov.usuario = s-user-id
              cb-cmov.DbeMn1 = 0
              cb-cmov.DbeMn2 = 0
              cb-cmov.DbeMn3 = 0
              cb-cmov.HbeMn1 = 0
              cb-cmov.HbeMn2 = 0
              cb-cmov.HbeMn3 = 0.        
    END.
    
    CREATE Detalle.
    x-nroitm = x-nroitm + 1.
                      
    ASSIGN Detalle.CodCia   = s-CodCia
           Detalle.Periodo  = s-Periodo
           Detalle.NroMes   = s-NroMes
           Detalle.Codope   = c-CodOpe
           Detalle.Nroast   = x-NroAst
           Detalle.coddiv   = T-DMOV.CodDiv
           Detalle.Codcta   = T-DMOV.CodCta
           Detalle.Codmon   = T-DMOV.CodMon           
           Detalle.Glodoc   = T-DMOV.GloDoc
           Detalle.ImpMn1   = T-DMOV.ImpMn1
           Detalle.ImpMn2   = 0          
           Detalle.Nroitm   = x-NroItm
           Detalle.Tpocmb   = 1
           Detalle.clfaux   = T-DMOV.ClfAux
           Detalle.codaux   = T-DMOV.CodAux
           Detalle.coddoc   = T-DMOV.CodDoc
           Detalle.nrodoc   = T-DMOV.NroDoc
           Detalle.Cco      = T-DMOV.Cco
           Detalle.TpoMov   = T-DMOV.TpoMov.
        
    IF DETALLE.TPOMOV THEN cb-cmov.HBEMN1 = cb-cmov.HBEMN1 + DETALLE.IMPMN1.
                      ELSE cb-cmov.DBEMN1 = cb-cmov.DBEMN1 + DETALLE.IMPMN1.         
                     
    RUN cbd/cb-acmd.p(RECID(Detalle), YES, YES).
    
END.
HIDE FRAME F-MENSAJE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GENERA-TMP B-table-Win 
PROCEDURE GENERA-TMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
x-CodOpe = x-OpeAju.    

/* BORRANDO TEMPORAL SI TUVIESE INFORMACION       */

x-msg1 = "Buscando partidas Activas ..... ".
DISPLAY x-msg1 WITH FRAME F-MENSAJE.
PAUSE 0. 

FOR EACH T-DMOV :
    DELETE T-DMOV.
END.    

FOR EACH AC-RPAR NO-LOCK WHERE ac-rpar.CodCia = s-CodCia AND 
                               ac-rpar.Periodo = s-Periodo AND
                               ac-rpar.NroMes = s-NroMes, 
                               FIRST AC-PART WHERE ac-part.CodCia = s-CodCia AND                                
                               ac-part.CodPar = ac-rpar.CodPar :

    x-msg1 = "Procesando Partida :".
    x-Msg2 = ac-rpar.CodPar + " " + ac-part.DesPar. 
    DISPLAY x-msg1 x-msg2 WITH FRAME F-MENSAJE.
    PAUSE 0.    
    FIND AC-CNFG WHERE ac-cnfg.CodCia = s-CodCia AND ac-cnfg.TpoCfg = "A" AND
                       ac-cnfg.CodCta[1] = ac-rpar.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE AC-CNFG THEN RUN GRABA-TMP(X-OPEAJU, AC-PART.CodCta, 
                                            AC-CNFG.CODCTA[2], AC-CNFG.CODCTA[3],
                                            AC-RPAR.Rei).
                                            
    FIND AC-CNFG WHERE ac-cnfg.CodCia = s-CodCia AND ac-cnfg.TpoCfg = "D" AND
                       ac-cnfg.CodCta[1] = ac-rpar.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE AC-CNFG THEN RUN GRABA-TMP(X-OPEDEP, AC-PART.CodCta, 
                                            AC-CNFG.CODCTA[2], AC-CNFG.CODCTA[3],
                                            AC-RPAR.DpAjtM).                                            
END.                                            

HIDE FRAME f-Mensaje.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRABA-TMP B-table-Win 
PROCEDURE GRABA-TMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-CodOpe AS CHAR.
DEFINE INPUT PARAMETER P-CodCta AS CHAR.
DEFINE INPUT PARAMETER P-CtaA-D AS CHAR.
DEFINE INPUT PARAMETER p-CtrA-D AS CHAR.
DEFINE INPUT PARAMETER p-Import AS DECIMAL.

 CREATE T-DMOV.
 ASSIGN T-DMOV.CodCia  = s-CodCia
        T-DMOV.periodo = s-periodo
        T-DMOV.NroMes  = s-NroMes
        T-DMOV.CodOpe  = P-CodOpe
        T-DMOV.NroAst  = x-NroAst
        T-DMOV.CodDiv  = ac-part.CodDiv
        T-DMOV.CodCta  = p-CtaA-D
        T-DMOV.CtaAut  = p-CtrA-D
        T-DMOV.CodDoc  = "PAR"        
        T-DMOV.NroDoc  = ac-part.CodPar
        T-DMOV.ClfAux  = "PAR"        
        T-DMOV.CodAux  = ac-part.CodPar
        T-DMOV.NroRef  = p-CodCta
        T-DMOV.Cco     = ac-part.CCosto
        T-DMOV.GloDoc  = ac-part.DesPar
        T-DMOV.CodMon  = 1
        T-DMOV.ImpMn1  = ABS(p-Import)
        T-DMOV.TpoMov  = ( p-Import < 0 ).
        
 p-import = p-import * -1.
 CREATE T-DMOV.
 ASSIGN T-DMOV.CodCia  = s-CodCia
        T-DMOV.periodo = s-periodo
        T-DMOV.NroMes  = s-NroMes
        T-DMOV.CodOpe  = P-CodOpe
        T-DMOV.NroAst  = x-NroAst
        T-DMOV.CodDiv  = ac-part.CodDiv
        T-DMOV.CodCta  = p-CtrA-D
        T-DMOV.CtaAut  = p-CtaA-D
        T-DMOV.CodDoc  = "PAR"        
        T-DMOV.NroDoc  = ac-part.CodPar
        T-DMOV.NroRef  = p-CodCta
        T-DMOV.Cco     = ac-part.CCosto
        T-DMOV.GloDoc  = ac-part.DesPar
        T-DMOV.ImpMn1  = ABS(p-Import)
        T-DMOV.CodMon  = 1
        T-DMOV.TpoMov  = ( p-Import < 0 ).       
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR B-table-Win 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr3.p.
  IF s-salida-impresion = 0 THEN RETURN.
  
  RUN aderb/_prlist.p ( OUTPUT s-printer-list,
                        OUTPUT s-port-list,
                        OUTPUT s-printer-count).
                        
  s-port-name = ENTRY( LOOKUP ( s-printer-name, s-printer-list ) , s-port-list ).
  s-port-name = REPLACE( s-port-name, ":", "").
  
  DEFINE VAR x-Debe  AS DECIMAL.
  DEFINE VAR x-Haber AS DECIMAL.
  
DEFINE FRAME F-Cab
    SPACE(10)
    T-DMOV.CodOpe  COLUMN-LABEL "Cod.!Ope."
    T-DMOV.NroAst  COLUMN-LABEL "Asiento"
    T-DMOV.CodDiv  COLUMN-LABEL "Divi "
    T-DMOV.CodCta  COLUMN-LABEL "Cuenta!Contable"
    T-DMOV.ClfAux  COLUMN-LABEL "ClfAux"
    T-DMOV.CodAux  COLUMN-LABEL "Partidas"
    T-DMOV.CodDoc  COLUMN-LABEL "CodDoc"
    T-DMOV.NroDoc  COLUMN-LABEL "Partidas"    
    T-DMOV.GloDoc  COLUMN-LABEL "Glosa"
    T-DMOV.TpoMov  COLUMN-LABEL "TPO"
    x-Debe         COLUMN-LABEL "Debe  (S/.)"
    x-haber        COLUMN-LABEL "Haber (S/.)"
    HEADER   
    {&Prn7a} + s-NomCia + {&Prn7b} FORMAT "X(60)" 
    "Fecha :" TO 90 TODAY AT 92
    "Pagina : " AT 102 PAGE-NUMBER(Report) FORMAT "ZZ9" AT 115 SKIP
    {&Prn7a} + "PRE-ASIENTO CONTABLE" + {&Prn7b} FORMAT "X(60)" AT 60 SKIP
    {&Prn7a} + "LIBRO (" + x-CodOpe + ")" + {&Prn7b} FORMAT "X(60)" AT 69 SKIP
    "MES > " + STRING(s-NroMes,"99") AT 74 SKIP(2)
    WITH DOWN NO-BOX STREAM-IO WIDTH 150.    
    
    OUTPUT STREAM REPORT TO VALUE ( s-port-name )  PAGE-SIZE 62.
    
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5a} + CHR(66) + {&Prn3}.
            
    FOR EACH T-DMOV WHERE T-DMOV.CodOpe = x-CodOpe 
                          BREAK BY CodOpe :
                          
        ASSIGN x-Debe = 0 x-Haber = 0.
        IF T-DMOV.TpoMov THEN x-Haber = T-DMOV.ImpMn1.
        ELSE x-Debe = T-DMOV.ImpMn1.
        DISPLAY STREAM REPORT T-DMOV.CodOpe  
                              T-DMOV.NroAst  
                              T-DMOV.CodDiv  
                              T-DMOV.CodCta  
                              T-DMOV.ClfAux 
                              T-DMOV.CodAux  
                              T-DMOV.CodDoc  
                              T-DMOV.NroDoc  
                              T-DMOV.GloDoc  
                              T-DMOV.TpoMov  
                              x-Debe  WHEN x-Debe <> 0
                              x-Haber WHEN x-haber <> 0 WITH FRAME f-cab.
        IF LAST-OF (CodOpe) THEN DO :
           UNDERLINE STREAM REPORT x-Debe
                                   x-Haber  WITH FRAME f-cab.
                            
           DISPLAY STREAM REPORT "TOTALES >>>> " @ T-DMOV.GloDoc  
                                 F-SumDbe @ x-Debe
                                 F-SumHbe @ x-Haber  WITH FRAME f-cab.
        END.
    END.      
                              
    OUTPUT STREAM REPORT CLOSE.    

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  C-TpoLib:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Ajustes".
  
  x-NroAst = STRING(s-NroMes,"99") + "0001".
    
  IF S-NROMES = 12 THEN U-DIA-MES = DATE(12,31,S-PERIODO).  
     ELSE U-DIA-MES = DATE(S-NROMES + 1, 1 , S-PERIODO) - 1.
     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RECOGE B-table-Win 
PROCEDURE RECOGE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-OpeAju AS CHAR.
DEFINE INPUT PARAMETER p-OpeDep AS CHAR.

x-OpeAju = p-OpeAju.
x-OpeDep = p-OpeDep.

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
  {src/adm/template/snd-list.i "T-DMOV"}

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

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TOTAL-SUMAS B-table-Win 
PROCEDURE TOTAL-SUMAS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
F-SumHbe = 0.
F-SumDbe = 0.

FOR EACH T-DMOV WHERE CodOpe = X-CodOpe :
    IF T-DMOV.TpoMov THEN F-SumHbe = F-SumHbe + T-DMOV.ImpMn1.
    ELSE F-SumDbe = F-SumDbe + T-DMOV.ImpMn1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

