&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DETALLE NO-UNDO LIKE CCBCMOV.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEF SHARED VARIABLE s-codcia AS INTEGER.
DEF SHARED VARIABLE pv-codcia AS INTEGER.
DEF SHARED VARIABLE s-periodo AS INTEGER.
DEF SHARED VARIABLE s-nromes AS INTEGER.

DEFINE VARIABLE cCodOpe AS CHARACTER NO-UNDO.

DEFINE STREAM s-Texto.

DEFINE TEMP-TABLE tt_ret NO-UNDO
    FIELDS tt_nroret AS CHARACTER FORMAT "x(9)"
    FIELDS tt_fchast LIKE cb-cmov.fchast FORMAT "99/99/9999"
    FIELDS tt_codpro LIKE gn-prov.CodPro
    FIELDS tt_coddoc AS CHARACTER FORMAT "x(2)"
    FIELDS tt_serie AS CHARACTER FORMAT "x(3)"
    FIELDS tt_nrodoc AS CHARACTER FORMAT "x(8)"
    FIELDS tt_fchdoc AS DATE FORMAT "99/99/9999"
    FIELDS tt_imptot AS DECIMAL FORMAT ">>>>>>>>9.99"
    FIELDS tt_impret AS DECIMAL FORMAT ">>>>>>>>9.99"
    INDEX tt_idx1 AS PRIMARY tt_codpro.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor..." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando..." FONT 7.

FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

cCodOpe = "002,005".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-period COMBO-month BUTTON-Genera ~
BUTTON-Salir 
&Scoped-Define DISPLAYED-OBJECTS COMBO-period COMBO-month FILL-IN-file 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Genera 
     IMAGE-UP FILE "adeicon\rbuild%":U
     LABEL "Button 2" 
     SIZE 11 BY 1.73 TOOLTIP "Genera Texto".

DEFINE BUTTON BUTTON-Salir 
     IMAGE-UP FILE "img\exit":U
     LABEL "Button 3" 
     SIZE 8 BY 1.73 TOOLTIP "Salir".

DEFINE VARIABLE COMBO-month AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-period AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-file AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 5 FGCOLOR 15  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-period AT ROW 1.77 COL 17 COLON-ALIGNED
     COMBO-month AT ROW 2.73 COL 17 COLON-ALIGNED
     FILL-IN-file AT ROW 3.69 COL 17 COLON-ALIGNED WIDGET-ID 2
     BUTTON-Genera AT ROW 4.77 COL 42
     BUTTON-Salir AT ROW 4.77 COL 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71 BY 6
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DETALLE T "?" NO-UNDO INTEGRAL CCBCMOV
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PDT - COMPROBANTES DE RETENCION"
         HEIGHT             = 6
         WIDTH              = 71
         MAX-HEIGHT         = 6
         MAX-WIDTH          = 71
         VIRTUAL-HEIGHT     = 6
         VIRTUAL-WIDTH      = 71
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-file IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PDT - COMPROBANTES DE RETENCION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PDT - COMPROBANTES DE RETENCION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Genera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Genera W-Win
ON CHOOSE OF BUTTON-Genera IN FRAME F-Main /* Button 2 */
DO:

    ASSIGN COMBO-month COMBO-period.

    RUN Genera-Texto.

    MESSAGE
        "Generación de Archivo terminado"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Salir W-Win
ON CHOOSE OF BUTTON-Salir IN FRAME F-Main /* Button 3 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY COMBO-period COMBO-month FILL-IN-file 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-period COMBO-month BUTTON-Genera BUTTON-Salir 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Texto W-Win 
PROCEDURE Genera-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cFile-Name AS CHARACTER FORMAT 'x(30)' NO-UNDO.
    DEFINE VARIABLE iMonth AS INTEGER NO-UNDO.
    DEFINE VARIABLE cString AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lAnswer AS LOGICAL INITIAL NO NO-UNDO.

    DEFINE VARIABLE cRuc AS CHARACTER FORMAT "x(11)" NO-UNDO.
    DEFINE VARIABLE cNomPro AS CHARACTER FORMAT "x(40)" NO-UNDO.
    DEFINE VARIABLE cApePat AS CHARACTER FORMAT "x(20)" NO-UNDO.
    DEFINE VARIABLE cApeMat AS CHARACTER FORMAT "x(20)" NO-UNDO.
    DEFINE VARIABLE cNombre AS CHARACTER FORMAT "x(20)" NO-UNDO.
    DEFINE VARIABLE dPorRetencion AS DECIMAL NO-UNDO.

    DEFINE BUFFER b_cb-dmov FOR cb-dmov.

    /* Determina % de Retención */
    FIND FIRST cb-tabl WHERE cb-tabl.Tabla = "RET" NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl THEN
        ASSIGN
            dPorRetencion = DECIMAL(cb-tabl.Codigo) NO-ERROR.

    FIND GN-CIAS WHERE GN-CIAS.codcia = s-codcia NO-LOCK.

    iMonth = LOOKUP(COMBO-month, COMBO-month:LIST-ITEMS IN FRAME {&FRAME-NAME}).  
    cFile-Name = '0626' + 
        STRING(GN-CIAS.Libre-c[1],'x(11)') +
        STRING(COMBO-period,'9999') + 
        STRING(iMonth,'99') + '.TXT'.

    SYSTEM-DIALOG GET-FILE cFile-Name
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION '.TXT'
        INITIAL-DIR 'c:\tmp'
        SAVE-AS
        TITLE 'Guardar como...'
        USE-FILENAME
        UPDATE lAnswer.
    IF lAnswer = NO THEN RETURN.

    DISPLAY cFile-Name @ FILL-IN-file WITH FRAME {&FRAME-NAME}.

    FOR EACH tt_ret:
        DELETE tt_ret.
    END.

    FOR EACH cb-cmov FIELDS
        (cb-cmov.CodCia cb-cmov.Periodo cb-cmov.NroMes
        cb-cmov.CodOpe cb-cmov.FchAst cb-cmov.codmon) WHERE
        cb-cmov.CodCia = s-CodCia AND
        cb-cmov.Periodo = COMBO-period AND
        cb-cmov.NroMes = iMonth AND
        LOOKUP(cb-cmov.CodOpe,cCodOpe) > 0 NO-LOCK,
        EACH cb-dmov FIELDS
        (cb-dmov.CodCia cb-dmov.Periodo cb-dmov.NroMes cb-dmov.CodOpe
        cb-dmov.NroAst cb-dmov.chr_01 cb-dmov.codaux cb-dmov.coddoc cb-dmov.CodCta
        cb-dmov.nrodoc cb-dmov.fchdoc cb-dmov.ImpMn1) WHERE
        cb-dmov.CodCia = cb-cmov.CodCia AND
        cb-dmov.Periodo = cb-cmov.Periodo AND
        cb-dmov.NroMes = cb-cmov.NroMes AND
        cb-dmov.CodOpe = cb-cmov.CodOpe AND
        cb-dmov.NroAst = cb-cmov.NroAst AND
        cb-dmov.chr_01 <> "" NO-LOCK:

        DISPLAY
            cb-dmov.NroAst @ Fi-Mensaje LABEL " Nro Asiento" FORMAT "X(11)"
            WITH FRAME F-Proceso.

        CREATE tt_ret.
        ASSIGN
            tt_nroret = cb-dmov.chr_01
            tt_fchast = cb-cmov.fchast
            tt_codpro = cb-dmov.codaux
            tt_coddoc = cb-dmov.coddoc
            tt_fchdoc = cb-dmov.fchdoc
            tt_impret = cb-dmov.ImpMn1
            tt_imptot = ROUND(((cb-dmov.ImpMn1 * 100) / dPorRetencion),2).

        IF tt_coddoc = "37" THEN DO:
            tt_coddoc = "99".
            tt_serie = "".
            tt_nrodoc = cb-dmov.nrodoc.
        END.
        ELSE DO:
            IF NUM-ENTRIES(cb-dmov.nrodoc,"-") > 1 THEN DO:
                tt_serie = ENTRY(1,cb-dmov.nrodoc,"-").
                tt_nrodoc = ENTRY(2,cb-dmov.nrodoc,"-").
            END.
            ELSE DO:
                tt_serie = SUBSTRING(cb-dmov.nrodoc,1,3).
                tt_nrodoc = SUBSTRING(cb-dmov.nrodoc,4).
            END.
        END.

    END.

    OUTPUT STREAM s-Texto TO VALUE(cFile-Name).
    FOR EACH tt_ret BREAK BY tt_codpro:
        IF FIRST-OF(tt_codpro) THEN DO:
            FOR gn-prov
                FIELDS (gn-prov.CodCia gn-prov.CodPro gn-prov.NomPro gn-prov.Ruc
                    gn-prov.ApePat gn-prov.ApeMat gn-prov.Nombre gn-prov.persona)
                WHERE gn-prov.CodCia = pv-CodCia
                AND gn-prov.CodPro = tt_codpro
                NO-LOCK:
            END.
            IF AVAILABLE gn-prov THEN DO:
                CASE gn-prov.persona:
                    WHEN "J" THEN DO:
                        cNomPro = gn-prov.NomPro.
                        cApePat = "".
                        cApeMat = "".
                        cNombre = "".
                    END.
                    WHEN "N" THEN DO:
                        cNomPro = "".
                        cApePat = gn-prov.ApePat.
                        cApeMat = gn-prov.ApeMat.
                        cNombre = gn-prov.Nombre.
                    END.
                    OTHERWISE DO:
                        cNomPro = gn-prov.NomPro.
                        cApePat = "".
                        cApeMat = "".
                        cNombre = "".
                    END.
                END CASE.
                cRuc = gn-prov.Ruc.
            END.
            ELSE DO:
                cNomPro = "".
                cApePat = "".
                cApeMat = "".
                cNombre = "".
                cRuc = "".
            END.
        END.
        PUT STREAM s-Texto
            cRuc "|"                            /* R.U.C. */
            cNomPro "|"                         /* Razón Social */
            cApePat "|"                         /* Apellido Paterno */
            cApeMat "|"                         /* Apellido Materno */
            cNombre "|".                        /* Nombre(s) */
        PUT STREAM s-Texto UNFORMATTED
            SUBSTRING(tt_nroret,1,3) "|"        /* Serie Compte. Retención */
            SUBSTRING(tt_nroret,4) "|".         /* Número Compte. Retención */
        PUT STREAM s-Texto
            tt_fchast "|"                       /* Fecha Compte. Retención */
            tt_impret "|"                       /* Importe Compte. Retención */
            tt_coddoc "|"                       /* Tipo de Comprobante de Pago */
            tt_serie "|"                        /* Serie */
            tt_nrodoc "|"                       /* Número */
            tt_fchdoc "|"                       /* Fecha de Emisión */
            tt_imptot "|" SKIP.                 /* Valor Total */
    END.
    OUTPUT STREAM s-Texto CLOSE.

    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
        COMBO-period:DELETE(1).
        FOR EACH Cb-Peri WHERE Cb-peri.codcia = s-codcia NO-LOCK:
            COMBO-period:ADD-LAST(STRING(CB-PERI.Periodo, '9999')).
        END.
        COMBO-period = s-Periodo.
        COMBO-month = ENTRY(s-nromes, COMBO-month:LIST-ITEMS).
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

