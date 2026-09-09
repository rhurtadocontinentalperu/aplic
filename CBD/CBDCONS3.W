&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/24/95 -  5:48 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT PARAMETER RegAct   AS RECID.
    DEFINE INPUT PARAMETER y-codcia AS INTEGER.
&ELSE
    DEFINE VARIABLE RegAct AS RECID.
    DEFINE VARIABLE y-codcia AS INTEGER INITIAL 0.
&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER.

DEFINE STREAM report.
DEFINE VAR x-nomope AS CHAR.
DEFINE SHARED VAR s-CodCia AS INTEGER.
DEFINE SHARED VAR cl-CodCia AS INTEGER.
DEFINE SHARED VAR pv-CodCia AS INTEGER.
DEFINE SHARED VAR cb-CodCia AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-dmov cb-cmov

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 cb-dmov.Nroitm cb-dmov.Codcta ~
cb-dmov.Codaux cb-dmov.Glodoc cb-dmov.Nrodoc cb-dmov.TpoMov cb-dmov.ImpMn1 ~
cb-dmov.ImpMn2 cb-dmov.Coddoc cb-dmov.Nroref cb-dmov.Fchdoc cb-dmov.Fchvto ~
cb-dmov.Clfaux cb-dmov.CodDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH cb-dmov WHERE cb-dmov.CodCia = cb-cmov.Codcia AND ~
integral.cb-dmov.Periodo = cb-cmov.Periodo AND ~
integral.cb-dmov.NroMes = cb-cmov.Nromes AND ~
integral.cb-dmov.Codope = cb-cmov.Codope AND ~
integral.cb-dmov.Nroast = cb-cmov.Nroast NO-LOCK ~
    BY cb-dmov.Nroitm.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 cb-dmov


/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1 cb-cmov.NroAst cb-cmov.FchAst ~
cb-cmov.NroVou cb-cmov.NotAst cb-cmov.GloAst cb-cmov.DbeMn1 cb-cmov.DbeMn2 ~
cb-cmov.Usuario cb-cmov.TpoCmb cb-cmov.HbeMn1 cb-cmov.HbeMn2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DIALOG-1 cb-cmov.GloAst 
&Scoped-define ENABLED-TABLES-IN-QUERY-DIALOG-1 cb-cmov
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-DIALOG-1 cb-cmov
&Scoped-define OPEN-BROWSERS-IN-QUERY-DIALOG-1 ~
    ~{&OPEN-QUERY-BROWSE-2}
&Scoped-define OPEN-QUERY-DIALOG-1 OPEN QUERY DIALOG-1 FOR EACH cb-cmov ~
      WHERE RECID(cb-cmov) = RegAct SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DIALOG-1 cb-cmov
&Scoped-define FIRST-TABLE-IN-QUERY-DIALOG-1 cb-cmov


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-cmov.GloAst 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES cb-cmov
&Scoped-define FIRST-ENABLED-TABLE cb-cmov
&Scoped-Define ENABLED-OBJECTS R-maestro1 R-maestro2 BROWSE-2 B-Imprimir ~
b-salir 
&Scoped-Define DISPLAYED-FIELDS cb-cmov.NroAst cb-cmov.FchAst ~
cb-cmov.NroVou cb-cmov.NotAst cb-cmov.GloAst cb-cmov.DbeMn1 cb-cmov.DbeMn2 ~
cb-cmov.Usuario cb-cmov.TpoCmb cb-cmov.HbeMn1 cb-cmov.HbeMn2 
&Scoped-Define DISPLAYED-OBJECTS s-nomcia 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-B-Imprimir 
       MENU-ITEM m_Todas_las_Cuentas LABEL "Todas las Cuentas"
       MENU-ITEM m_Omitir_Automticas LABEL "Omitir Autom ticas"
       MENU-ITEM m_Todas_las_cuentas_Ordenado_ LABEL "Todas las cuentas Ordenado por Cuenta"
       MENU-ITEM m_Omitir_Automticas_Ordenado_ LABEL "Omitir Autom ticas Ordenado por Cuenta"
       MENU-ITEM m_Todas_Las_Cuentas_Ordenado_2 LABEL "Todas Las Cuentas Ordenado por D/H"
       MENU-ITEM m_Omitir_Automticas_Ordernado LABEL "Omitir Autom ticas Ordernado por D/H".


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Imprimir 
     LABEL "&Imprimir" 
     SIZE 10.14 BY 1.

DEFINE BUTTON b-salir AUTO-END-KEY 
     LABEL "&Atrás" 
     SIZE 11.72 BY 1.08.

DEFINE VARIABLE s-nomcia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.14 BY .69
     FONT 0 NO-UNDO.

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.86 BY 14.35
     BGCOLOR 8 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.86 BY 2.04
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      cb-dmov SCROLLING.

DEFINE QUERY DIALOG-1 FOR 
      cb-cmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 DIALOG-1 _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      cb-dmov.Nroitm COLUMN-LABEL "Nro.!item"
      cb-dmov.Codcta COLUMN-LABEL "C¢digo!cuenta"
      cb-dmov.Codaux COLUMN-LABEL "C¢digo!auxil."
      cb-dmov.Glodoc
      cb-dmov.Nrodoc COLUMN-LABEL "N£mero de!documento"
      cb-dmov.TpoMov
      cb-dmov.ImpMn1 COLUMN-LABEL "Importe!(soles)"
      cb-dmov.ImpMn2 COLUMN-LABEL "Importe!(d¢lares)"
      cb-dmov.Coddoc COLUMN-LABEL "C¢digo!docum."
      cb-dmov.Nroref COLUMN-LABEL "N£mero de!referencia"
      cb-dmov.Fchdoc COLUMN-LABEL "Fecha de!docum."
      cb-dmov.Fchvto COLUMN-LABEL "Fecha de!vencim."
      cb-dmov.Clfaux COLUMN-LABEL "Clasif.!auxiliar"
      cb-dmov.CodDiv COLUMN-LABEL "C¢digo de!Division."
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 86 BY 7.38
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     BROWSE-2 AT ROW 5.73 COL 3
     cb-cmov.NroAst AT ROW 1.15 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmov.FchAst AT ROW 1.92 COL 11 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .69
     cb-cmov.NroVou AT ROW 2.69 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .69
     cb-cmov.NotAst AT ROW 3.42 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52.86 BY .69
     cb-cmov.GloAst AT ROW 4.23 COL 13 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 74.86 BY 1.35
     cb-cmov.DbeMn1 AT ROW 13.35 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .69
          FGCOLOR 1 
     cb-cmov.DbeMn2 AT ROW 14.08 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .69
          FGCOLOR 1 
     s-nomcia AT ROW 1.15 COL 43.86 COLON-ALIGNED NO-LABEL
     B-Imprimir AT ROW 15.88 COL 60.14
     cb-cmov.Usuario AT ROW 1.92 COL 72.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .69
     cb-cmov.TpoCmb AT ROW 2.69 COL 72.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .69
     cb-cmov.HbeMn1 AT ROW 13.35 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .69
          FGCOLOR 1 
     cb-cmov.HbeMn2 AT ROW 14.08 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .69
          FGCOLOR 1 
     b-salir AT ROW 15.85 COL 75.86
     R-maestro1 AT ROW 1 COL 1
     R-maestro2 AT ROW 15.35 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Diario General".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
                                                                        */
/* BROWSE-TAB BROWSE-2 R-maestro2 DIALOG-1 */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       B-Imprimir:POPUP-MENU IN FRAME DIALOG-1       = MENU POPUP-MENU-B-Imprimir:HANDLE.

ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME DIALOG-1 = 2.

/* SETTINGS FOR FILL-IN cb-cmov.DbeMn1 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.DbeMn2 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.FchAst IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       cb-cmov.GloAst:READ-ONLY IN FRAME DIALOG-1        = TRUE.

/* SETTINGS FOR FILL-IN cb-cmov.HbeMn1 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.HbeMn2 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.NotAst IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.NroAst IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.NroVou IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-nomcia IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.TpoCmb IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmov.Usuario IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.cb-dmov WHERE integral.cb-cmov  ..."
     _Options          = "NO-LOCK"
     _OrdList          = "integral.cb-dmov.Nroitm|yes"
     _JoinCode[1]      = "integral.cb-dmov.CodCia = integral.cb-cmov.Codcia AND
integral.cb-dmov.Periodo = integral.cb-cmov.Periodo AND
integral.cb-dmov.NroMes = integral.cb-cmov.Nromes AND
integral.cb-dmov.Codope = integral.cb-cmov.Codope AND
integral.cb-dmov.Nroast = integral.cb-cmov.Nroast"
     _FldNameList[1]   > integral.cb-dmov.Nroitm
"cb-dmov.Nroitm" "Nro.!item" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.cb-dmov.Codcta
"cb-dmov.Codcta" "C¢digo!cuenta" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.cb-dmov.Codaux
"cb-dmov.Codaux" "C¢digo!auxil." ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   = integral.cb-dmov.Glodoc
     _FldNameList[5]   > integral.cb-dmov.Nrodoc
"cb-dmov.Nrodoc" "N£mero de!documento" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[6]   = integral.cb-dmov.TpoMov
     _FldNameList[7]   > integral.cb-dmov.ImpMn1
"cb-dmov.ImpMn1" "Importe!(soles)" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[8]   > integral.cb-dmov.ImpMn2
"cb-dmov.ImpMn2" "Importe!(d¢lares)" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[9]   > integral.cb-dmov.Coddoc
"cb-dmov.Coddoc" "C¢digo!docum." ? "character" ? ? ? ? ? ? no ?
     _FldNameList[10]   > integral.cb-dmov.Nroref
"cb-dmov.Nroref" "N£mero de!referencia" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[11]   > integral.cb-dmov.Fchdoc
"cb-dmov.Fchdoc" "Fecha de!docum." ? "date" ? ? ? ? ? ? no ?
     _FldNameList[12]   > integral.cb-dmov.Fchvto
"cb-dmov.Fchvto" "Fecha de!vencim." ? "date" ? ? ? ? ? ? no ?
     _FldNameList[13]   > integral.cb-dmov.Clfaux
"cb-dmov.Clfaux" "Clasif.!auxiliar" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[14]   > integral.cb-dmov.CodDiv
"cb-dmov.CodDiv" "C¢digo de!Division." ? "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DIALOG-1
/* Query rebuild information for DIALOG-BOX DIALOG-1
     _TblList          = "integral.cb-cmov"
     _Options          = "SHARE-LOCK"
     _Where[1]         = "RECID(cb-cmov) = RegAct"
     _Query            is OPENED
*/  /* DIALOG-BOX DIALOG-1 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir DIALOG-1
ON CHOOSE OF B-Imprimir IN FRAME DIALOG-1 /* Imprimir */
DO:
    Message "Seleccione Impresión con el " SKIP
            "Click Derecho de su Mouse"    
            VIEW-AS ALERT-BOX INFORMA.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Omitir_Automticas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Omitir_Automticas DIALOG-1
ON CHOOSE OF MENU-ITEM m_Omitir_Automticas /* Omitir Autom ticas */
DO:  
   RUN IMPRIME(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Omitir_Automticas_Ordenado_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Omitir_Automticas_Ordenado_ DIALOG-1
ON CHOOSE OF MENU-ITEM m_Omitir_Automticas_Ordenado_ /* Omitir Autom ticas Ordenado por Cuenta */
DO:
  /* MESSAGE "OPCION NO AUTORIZADA"
   VIEW-AS ALERT-BOX INFORMA.
   RETURN.*/
   RUN IMPRIME-ORDENADO(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Omitir_Automticas_Ordernado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Omitir_Automticas_Ordernado DIALOG-1
ON CHOOSE OF MENU-ITEM m_Omitir_Automticas_Ordernado /* Omitir Autom ticas Ordernado por D/H */
DO:
  /* MESSAGE "OPCION NO AUTORIZADA"
   VIEW-AS ALERT-BOX INFORMA.
   RETURN.*/
   RUN IMPRIME-DH(2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todas_las_Cuentas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todas_las_Cuentas DIALOG-1
ON CHOOSE OF MENU-ITEM m_Todas_las_Cuentas /* Todas las Cuentas */
DO:
   RUN IMPRIME(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todas_las_cuentas_Ordenado_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todas_las_cuentas_Ordenado_ DIALOG-1
ON CHOOSE OF MENU-ITEM m_Todas_las_cuentas_Ordenado_ /* Todas las cuentas Ordenado por Cuenta */
DO:
   RUN IMPRIME-ORDENADO(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todas_Las_Cuentas_Ordenado_2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todas_Las_Cuentas_Ordenado_2 DIALOG-1
ON CHOOSE OF MENU-ITEM m_Todas_Las_Cuentas_Ordenado_2 /* Todas Las Cuentas Ordenado por D/H */
DO:
   RUN IMPRIME-DH(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.

    FIND Empresas WHERE Empresas.CodCia = cb-cmov.CodCia NO-LOCK NO-ERROR.
    FIND cb-oper WHERE cb-oper.CodCia = y-Codcia AND
        cb-oper.CodOpe = cb-cmov.CodOpe NO-LOCK NO-ERROR.
    IF AVAILABLE cb-oper THEN DO:
       x-nomope = cb-oper.NomOpe.
        RUN bin/_mes.p ( INPUT cb-cmov.NroMes , 1,  OUTPUT s-nomcia ).
        s-nomcia = cb-oper.NomOpe + "  " + s-nomcia + ", " +
            STRING( s-periodo , "9999" ).
        FRAME DIALOG-1:TITLE = s-nomcia.
    END.
    s-nomcia = Empresas.NomCia.
    DISPLAY s-nomcia WITH FRAME DIALOG-1.

    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/

  {&OPEN-QUERY-DIALOG-1}
  GET FIRST DIALOG-1.
  DISPLAY s-nomcia 
      WITH FRAME DIALOG-1.
  IF AVAILABLE cb-cmov THEN 
    DISPLAY cb-cmov.NroAst cb-cmov.FchAst cb-cmov.NroVou cb-cmov.NotAst 
          cb-cmov.GloAst cb-cmov.DbeMn1 cb-cmov.DbeMn2 cb-cmov.Usuario 
          cb-cmov.TpoCmb cb-cmov.HbeMn1 cb-cmov.HbeMn2 
      WITH FRAME DIALOG-1.
  ENABLE R-maestro1 R-maestro2 BROWSE-2 cb-cmov.GloAst B-Imprimir b-salir 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIME DIALOG-1 
PROCEDURE IMPRIME :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.

DEFINE INPUT PARAMETER F-CUENTAS AS Integer.
    /* 1 todas las cuentas
       2 eliminar las automaticas
     */
    DEF VAR X-IMPRESO AS CHAR FORMAT "X(20)".
    X-IMPRESO = STRING(TIME,"HH:MM AM") + "-" + STRING(TODAY,"99/99/99").
    DEFINE var X-PAG AS CHAR FORMAT "999". 
    DEFINE VARIABLE x-filtro   AS CHAR.   
    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(40)".
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/99" INITIAL TODAY.
    DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-nom-ope  AS CHARACTER FORMAT "x(40)".
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
    RUN bin/_mes.p ( INPUT cb-cmov.nromes , 1,  OUTPUT pinta-mes ).
    pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-codmon = integral.cb-cmov.codmon.
    x-fecha  = integral.cb-cmov.Fchast.
  
    DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "División"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.cco          LABEL "C.Cos"
        cb-dmov.nroref LABEL "Referencia"
        cb-dmov.coddoc LABEL "Cod"
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 150 NO-BOX STREAM-IO DOWN.
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 66.    
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66) .
    PUT STREAM report empresas.nomcia SKIP.
    PUT STREAM report x-nomope. 
    PUT STREAM report "ASIENTO No: " AT 60 
                      integral.cb-cmov.codope
                      "-"
                      integral.cb-cmov.nroast 
                      SKIP(1).
    PUT STREAM report pinta-mes SKIP(1).
    PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.
    PUT STREAM report "FECHA     : " cb-cmov.fchast.
    PUT STREAM REPORT "REFERENCIA : " AT 70 cb-cmov.NroVou SKIP.
    IF integral.cb-cmov.codmon = 1 THEN
        PUT STREAM report "MONEDA    :         S/. " SKIP.
    ELSE
        PUT STREAM report "MONEDA    :         US$ " SKIP.
    PUT STREAM report "T.CAMBIO  : " integral.cb-cmov.tpocmb SKIP.    
    PUT STREAM report "CONCEPTO  : " integral.cb-cmov.notast SKIP.
    
    PUT STREAM report CONTROL CHR(27) CHR(77) CHR(15).

    PUT STREAM report FILL("_",150) FORMAT "X(150)" SKIP.

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = cb-cmov.periodo
                    AND cb-dmov.nromes  = cb-cmov.NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast)
              BY (cb-dmov.Nroitm) ON ERROR UNDO, LEAVE:
        IF F-CUENTAS = 2 AND cb-dmov.tpoitm = "A" THEN NEXT.
        x-glodoc = glodoc.
        IF x-glodoc = "" THEN DO:
            CASE cb-dmov.clfaux:
            WHEN "@CL" THEN DO:
                FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                    AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                    AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                    AND cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
               IF AVAILABLE cb-ctas THEN x-glodoc = cb-ctas.nomcta.
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                    AND cb-auxi.codaux = cb-dmov.codaux
                    AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
            END.
            END CASE.
        END.
        IF x-glodoc = "" THEN DO:
            IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
        END.
        CASE x-codmon:
            WHEN 2 THEN DO:
                SUBSTR(x-glodoc,( 35 - LENGTH(STRING(ImpMn2)) ),31) = "(US$" + STRING(ImpMn2) + ")".
            END.
        END CASE.
        IF cb-dmov.tpomov THEN DO:
            x-debe  = 0.
            x-haber = ImpMn1.
        END.
        ELSE DO:
            x-debe  = ImpMn1.
            x-haber = 0.
        END.
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ?
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
            IF LINE-COUNTER(report)  + 5 > PAGE-SIZE(report)
            THEN DO :
                      X-PAG =  STRING(PAGE-NUMBER(report),"999").
                      UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Van.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                       WITH FRAME f-cab.    
                       X-PAG =  STRING(PAGE-NUMBER(report) + 1 ,"999").  
                       DOWN STREAM report with frame f-cab.
                       PAGE stream report.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Vienen.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                     
                       
                 END.     
            DISPLAY STREAM report cb-dmov.coddiv
                                  cb-dmov.codcta
                                  cb-dmov.clfaux
                                  cb-dmov.codaux
                                  cb-dmov.cco
                                  cb-dmov.nroref
                                  cb-dmov.coddoc
                                  cb-dmov.nrodoc
                                  cb-dmov.fchdoc
                                  x-glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0) 
                            WITH FRAME f-cab.

        END.
        IF LAST-OF (cb-dmov.nroast)
        THEN DO:
            x-glodoc = "                    TOTALES :".
            IF LINE-COUNTER(report)  + 3 > PAGE-SIZE(report)
            THEN PAGE stream report.
            DOWN STREAM report 1 WITH FRAME f-cab.
            UNDERLINE STREAM report 
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
            DOWN STREAM report with frame f-cab.
            DISPLAY STREAM report x-glodoc
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-cab.
                


        END.
    END.
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 10 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "               -----------------       -----------------       -----------------       ----------------- " SKIP.
    PUT STREAM report "                  PREPARADO                  Vo. Bo.            ADMINISTRACION             CONTADOR           Impreso:".
    PUT STREAM report x-impreso SKIP.
    
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIME-DH DIALOG-1 
PROCEDURE IMPRIME-DH :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.

DEFINE INPUT PARAMETER F-CUENTAS AS Integer.
    /* 1 todas las cuentas
       2 eliminar las automaticas
     */
    DEF VAR X-IMPRESO AS CHAR FORMAT "X(20)".
    X-IMPRESO = STRING(TIME,"HH:MM AM") + "-" + STRING(TODAY,"99/99/99").
    DEFINE var X-PAG AS CHAR FORMAT "999". 
    DEFINE VARIABLE x-filtro   AS CHAR.   
    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(40)".
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/99" INITIAL TODAY.
    DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-nom-ope  AS CHARACTER FORMAT "x(40)".
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
    RUN bin/_mes.p ( INPUT cb-cmov.NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-codmon = integral.cb-cmov.codmon.
    x-fecha  = integral.cb-cmov.Fchast.
  
    DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Divisi¢n"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.cco          LABEL "C.Cos"
        cb-dmov.nroref LABEL "Referencia"
        cb-dmov.coddoc LABEL "Cod"
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 150 NO-BOX STREAM-IO DOWN.
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 66.    
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66) .
    PUT STREAM report empresas.nomcia SKIP.
    PUT STREAM report x-nomope. 
    PUT STREAM report "ASIENTO No: " AT 60 
                      integral.cb-cmov.codope
                      "-"
                      integral.cb-cmov.nroast 
                      SKIP(1).
    PUT STREAM report pinta-mes SKIP(1).
    PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.
    PUT STREAM report "FECHA     : " cb-cmov.fchast SKIP.
    PUT STREAM REPORT "REFERENCIA : " AT 70 cb-cmov.NroVou SKIP.
    IF integral.cb-cmov.codmon = 1 THEN
        PUT STREAM report "MONEDA    :         S/. " SKIP.
    ELSE
        PUT STREAM report "MONEDA    :         US$ " SKIP.
    PUT STREAM report "T.CAMBIO  : " integral.cb-cmov.tpocmb SKIP.    
    PUT STREAM report "CONCEPTO  : " integral.cb-cmov.notast SKIP.
    
    PUT STREAM report CONTROL CHR(27) CHR(77) CHR(15).

    PUT STREAM report FILL("_",150) FORMAT "X(150)" SKIP.

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = s-periodo
                    AND cb-dmov.nromes  = cb-cmov.nromes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast) 
              BY (cb-dmov.tpomov)
              BY (cb-dmov.Nroitm) 
        ON ERROR UNDO, LEAVE:
        IF F-CUENTAS = 2 AND cb-dmov.tpoitm = "A" THEN NEXT.
        x-glodoc = glodoc.
        IF x-glodoc = "" THEN DO:
            CASE cb-dmov.clfaux:
            WHEN "@CL" THEN DO:
                FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                    AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                    AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                    AND cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
               IF AVAILABLE cb-ctas THEN x-glodoc = cb-ctas.nomcta.
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                    AND cb-auxi.codaux = cb-dmov.codaux
                    AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
            END.
            END CASE.
        END.
        IF x-glodoc = "" THEN DO:
            IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
        END.
        CASE x-codmon:
            WHEN 2 THEN DO:
                SUBSTR(x-glodoc,( 35 - LENGTH(STRING(ImpMn2)) ),31) = "(US$" + STRING(ImpMn2) + ")".
            END.
        END CASE.
        IF cb-dmov.tpomov THEN DO:
            x-debe  = 0.
            x-haber = ImpMn1.
        END.
        ELSE DO:
            x-debe  = ImpMn1.
            x-haber = 0.
        END.
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ?
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
            IF LINE-COUNTER(report)  + 5 > PAGE-SIZE(report)
            THEN DO :
                      X-PAG =  STRING(PAGE-NUMBER(report),"999").
                      UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Van.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                       WITH FRAME f-cab.    
                       X-PAG =  STRING(PAGE-NUMBER(report) + 1 ,"999").  
                       DOWN STREAM report with frame f-cab.
                       PAGE stream report.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Vienen.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                     
                       
                 END.     
            DISPLAY STREAM report cb-dmov.coddiv
                                  cb-dmov.codcta
                                  cb-dmov.clfaux
                                  cb-dmov.codaux
                                  cb-dmov.cco
                                  cb-dmov.nroref
                                  cb-dmov.coddoc
                                  cb-dmov.nrodoc
                                  cb-dmov.fchdoc
                                  x-glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0) 
                            WITH FRAME f-cab.

        END.
        IF LAST-OF (cb-dmov.nroast)
        THEN DO:
            x-glodoc = "                    TOTALES :".
            IF LINE-COUNTER(report)  + 3 > PAGE-SIZE(report)
            THEN PAGE stream report.
            DOWN STREAM report 1 WITH FRAME f-cab.
            UNDERLINE STREAM report 
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
            DOWN STREAM report with frame f-cab.
            DISPLAY STREAM report x-glodoc
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-cab.
                


        END.
    END.
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 10 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "               -----------------       -----------------       -----------------       ----------------- " SKIP.
    PUT STREAM report "                  PREPARADO                  Vo. Bo.            ADMINISTRACION             CONTADOR           Impreso:".
    PUT STREAM report x-impreso SKIP.
    
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIME-ORDENADO DIALOG-1 
PROCEDURE IMPRIME-ORDENADO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.

DEFINE INPUT PARAMETER F-CUENTAS AS Integer.
    /* 1 todas las cuentas
       2 eliminar las automaticas
     */
    DEF VAR X-IMPRESO AS CHAR FORMAT "X(20)".
    X-IMPRESO = STRING(TIME,"HH:MM AM") + "-" + STRING(TODAY,"99/99/99").
    DEFINE var X-PAG AS CHAR FORMAT "999". 
    DEFINE VARIABLE x-filtro   AS CHAR.   
    DEFINE VARIABLE x-glodoc   AS CHARACTER FORMAT "X(40)".
    DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
    DEFINE VARIABLE x-fecha    AS DATE FORMAT "99/99/99" INITIAL TODAY.
    DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
    DEFINE VARIABLE x-con-reg  AS INTEGER.
    DEFINE VARIABLE x-nom-ope  AS CHARACTER FORMAT "x(40)".
    DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
    RUN bin/_mes.p ( INPUT cb-cmov.NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-codmon = integral.cb-cmov.codmon.
    x-fecha  = integral.cb-cmov.Fchast.
  
    DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Divisi¢n"
        cb-dmov.codcta LABEL "Cuenta"
        cb-dmov.clfaux LABEL "Clf!Aux"
        cb-dmov.codaux       LABEL "Auxiliar"
        cb-dmov.cco          LABEL "C.Cos"
        cb-dmov.nroref LABEL "Referencia"
        cb-dmov.coddoc LABEL "Cod"
        cb-dmov.nrodoc LABEL "Nro!Documento"
        cb-dmov.fchdoc LABEL "Fecha!Doc"
        x-glodoc       LABEL "Detalle"
        x-debe         LABEL "Cargos"
        x-haber        LABEL "Abonos"
        WITH WIDTH 150 NO-BOX STREAM-IO DOWN.
    OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 66.    
    PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66) .
    PUT STREAM report empresas.nomcia SKIP.
    PUT STREAM report x-nomope. 
    PUT STREAM report "ASIENTO No: " AT 60 
                      integral.cb-cmov.codope
                      "-"
                      integral.cb-cmov.nroast 
                      SKIP(1).
    PUT STREAM report pinta-mes SKIP(1).
    PUT STREAM report CONTROL CHR(27) CHR(70) CHR(27) CHR(120) 0.
    PUT STREAM report "FECHA     : " cb-cmov.fchast SKIP.
    PUT STREAM REPORT "REFERENCIA : " AT 70 cb-cmov.NroVou SKIP.
    IF integral.cb-cmov.codmon = 1 THEN
        PUT STREAM report "MONEDA    :         S/. " SKIP.
    ELSE
        PUT STREAM report "MONEDA    :         US$ " SKIP.
    PUT STREAM report "T.CAMBIO  : " integral.cb-cmov.tpocmb SKIP.    
    PUT STREAM report "CONCEPTO  : " integral.cb-cmov.notast SKIP.
    
    PUT STREAM report CONTROL CHR(27) CHR(77) CHR(15).

    PUT STREAM report FILL("_",150) FORMAT "X(150)" SKIP.

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                    AND cb-dmov.periodo = s-periodo
                    AND cb-dmov.nromes  = cb-cmov.NroMes
                    AND cb-dmov.codope  = cb-cmov.codope
                    AND cb-dmov.nroast  = cb-cmov.nroast
        BREAK BY (cb-dmov.nroast) 
              BY (cb-dmov.codcta) 
              BY (cb-dmov.Nroitm)
              ON ERROR UNDO, LEAVE:
        IF F-CUENTAS = 2 AND cb-dmov.tpoitm = "A" THEN NEXT.
        x-glodoc = glodoc.
        IF x-glodoc = "" THEN DO:
            CASE cb-dmov.clfaux:
            WHEN "@CL" THEN DO:
                FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                    AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                    AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                    AND cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
               IF AVAILABLE cb-ctas THEN x-glodoc = cb-ctas.nomcta.
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                    AND cb-auxi.codaux = cb-dmov.codaux
                    AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
            END.
            END CASE.
        END.
        IF x-glodoc = "" THEN DO:
            IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
        END.
        CASE x-codmon:
            WHEN 2 THEN DO:
                SUBSTR(x-glodoc,( 35 - LENGTH(STRING(ImpMn2)) ),31) = "(US$" + STRING(ImpMn2) + ")".
            END.
        END CASE.
        IF cb-dmov.tpomov THEN DO:
            x-debe  = 0.
            x-haber = ImpMn1.
        END.
        ELSE DO:
            x-debe  = ImpMn1.
            x-haber = 0.
        END.
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ?
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
            IF LINE-COUNTER(report)  + 5 > PAGE-SIZE(report)
            THEN DO :
                      X-PAG =  STRING(PAGE-NUMBER(report),"999").
                      UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Van.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                       WITH FRAME f-cab.    
                       X-PAG =  STRING(PAGE-NUMBER(report) + 1 ,"999").  
                       DOWN STREAM report with frame f-cab.
                       PAGE stream report.
                       DISPLAY STREAM report 
                              "PAG."              @ cb-dmov.coddiv
                              X-PAG               @ cb-dmov.codcta
                              "    .....Vienen.... " @ x-glodoc
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                              ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                       UNDERLINE STREAM report 
                              cb-dmov.coddiv
                              cb-dmov.codcta
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
                       DOWN STREAM report with frame f-cab.
                     
                       
                 END.     
            DISPLAY STREAM report cb-dmov.coddiv
                                  cb-dmov.codcta
                                  cb-dmov.clfaux
                                  cb-dmov.codaux
                                  cb-dmov.cco
                                  cb-dmov.nroref
                                  cb-dmov.coddoc
                                  cb-dmov.nrodoc
                                  cb-dmov.fchdoc
                                  x-glodoc
                                  x-debe   WHEN (x-debe  <> 0)
                                  x-haber  WHEN (x-haber <> 0) 
                            WITH FRAME f-cab.

        END.
        IF LAST-OF (cb-dmov.nroast)
        THEN DO:
            x-glodoc = "                    TOTALES :".
            IF LINE-COUNTER(report)  + 3 > PAGE-SIZE(report)
            THEN PAGE stream report.
            DOWN STREAM report 1 WITH FRAME f-cab.
            UNDERLINE STREAM report 
                              x-glodoc
                              x-debe 
                              x-haber
                       WITH FRAME f-cab.    
            DOWN STREAM report with frame f-cab.
            DISPLAY STREAM report x-glodoc
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                    ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                WITH FRAME f-cab.
                


        END.
    END.
    DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 10 :
        PUT STREAM report "" skip.
    END.
    PUT STREAM report "               -----------------       -----------------       -----------------       ----------------- " SKIP.
    PUT STREAM report "                  PREPARADO                  Vo. Bo.            ADMINISTRACION             CONTADOR           Impreso:".
    PUT STREAM report x-impreso SKIP.
    
    OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


