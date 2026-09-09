&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER s-codalm AS CHAR.
DEF INPUT PARAMETER s-codmat AS CHAR.
/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

    DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
    /*DEFINE SHARED VARIABLE S-CODALM   AS CHAR.*/
    /*DEFINE SHARED VARIABLE S-CODMAT   AS CHAR.*/

    DEFINE TEMP-TABLE tmp-tabla
        FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
        FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
        FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
        FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
        FIELD t-FchPed LIKE FacDPedi.FchPed
        FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
        FIELD t-CodMat LIKE FacDPedi.codmat
        FIELD t-Canped LIKE FacDPedi.CanPed.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tmp-tabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-CodAlm t-CodDiv t-CodDoc t-NroPed t-FchPed t-NomCli t-CanPed   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tmp-tabla WHERE ~{&KEY-PHRASE} NO-LOCK     ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tmp-tabla WHERE ~{&KEY-PHRASE} NO-LOCK     ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tmp-tabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tmp-tabla


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS x-Total 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "SALIR" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE x-Total AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tmp-tabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 gDialog _FREEFORM
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-CodAlm COLUMN-LABEL "Almacén!Despacho" FORMAT 'x(3)'
      t-CodDiv COLUMN-LABEL "División" FORMAT 'x(10)'
      t-CodDoc COLUMN-LABEL "Codigo!Documento"  FORMAT "XXX"
      t-NroPed COLUMN-LABEL "Numero!Pedido" FORMAT "XXX-XXXXXXXXXX"
      t-FchPed COLUMN-LABEL "  Fecha       !  Pedido       "  FORMAT "99/99/9999"
      t-NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
      t-CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 14
         FONT 4
         TITLE "MERCADERIA POR INGRESAR - EN TRANSITO" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     BROWSE-2 AT ROW 1 COL 1 WIDGET-ID 200
     Btn_OK AT ROW 15.23 COL 46
     x-Total AT ROW 15.23 COL 65 COLON-ALIGNED WIDGET-ID 2
     "STR: Solicitud de Transferencia" VIEW-AS TEXT
          SIZE 21 BY .5 AT ROW 15.04 COL 24 WIDGET-ID 10
     "REP: Reposiciones de stock" VIEW-AS TEXT
          SIZE 20 BY .5 AT ROW 15.04 COL 2 WIDGET-ID 4
     "TRF: Transferencias por recibir" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 15.62 COL 2 WIDGET-ID 6
     "OTR: Orden de Transferencia" VIEW-AS TEXT
          SIZE 21 BY .5 AT ROW 15.62 COL 24 WIDGET-ID 8
     SPACE(40.42) SKIP(0.52)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE ""
         DEFAULT-BUTTON Btn_OK WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB BROWSE-2 1 gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-Total IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tmp-tabla WHERE ~{&KEY-PHRASE} NO-LOCK
    ~{&SORTBY-PHRASE}.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal gDialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       VER TAMBIEN alm/pedidoreposicionentransito.p
------------------------------------------------------------------------------*/

RUN alm\p-articulo-en-transito (
    s-codcia,
    s-codalm,
    s-codmat,
    INPUT-OUTPUT TABLE tmp-tabla,
    OUTPUT x-Total).

/*
x-Total = 0.
FOR EACH Almcrepo NO-LOCK WHERE Almcrepo.codcia = s-codcia
    /*AND Almcrepo.TipMov = 'A'*/
    AND Almcrepo.CodAlm = s-CodAlm
    AND LOOKUP(Almcrepo.AlmPed, '997,998') = 0
    AND Almcrepo.FlgEst = 'P'
    AND LOOKUP(Almcrepo.FlgSit, 'A,P') > 0,     /* Aprobado y x Aprobar */
    EACH Almdrepo OF Almcrepo NO-LOCK WHERE Almdrepo.codmat = s-CodMat
    AND almdrepo.CanApro > almdrepo.CanAten,
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = Almcrepo.AlmPed:
    FIND tmp-tabla WHERE t-CodDoc = "REP"
        AND  t-NroPed = STRING(Almcrepo.nroser, '999') + STRING(Almcrepo.nrodoc, '9999999')
        NO-ERROR.
    IF NOT AVAIL tmp-tabla THEN DO:
        CREATE tmp-tabla.
        ASSIGN 
            t-CodAlm = Almcrepo.AlmPed
            t-CodDoc = "REP"
            t-NroPed = STRING(Almcrepo.nroser, '999') + STRING(Almcrepo.nrodoc, '9999999')
            t-CodDiv = Almacen.CodDiv
            t-FchPed = Almcrepo.FchDoc
            t-codmat = s-CodMat
            t-CanPed = (Almdrepo.CanApro - Almdrepo.CanAten).
        x-Total = x-Total + t-CanPed.
    END.
END.
/* G/R por Transferencia en Tránsito */
FOR EACH Almdmov USE-INDEX Almd02 NO-LOCK WHERE Almdmov.codcia = s-codcia
    AND Almdmov.fchdoc >= TODAY - 30
    AND Almdmov.codmat = s-CodMat
    AND Almdmov.tipmov = "S"
    AND Almdmov.codmov = 03,
    FIRST Almcmov OF Almdmov NO-LOCK,
    FIRST Almacen OF Almcmov NO-LOCK:
    IF Almcmov.flgest <> "A" AND Almcmov.flgsit = "T" AND Almcmov.almdes = s-CodAlm 
        THEN DO:
        FIND tmp-tabla WHERE t-CodDoc = "TRF"
            AND  t-NroPed = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999')
            NO-ERROR.
        IF NOT AVAIL tmp-tabla THEN DO:
            CREATE tmp-tabla.
            ASSIGN 
                t-CodAlm = Almdmov.CodAlm
                t-CodDoc = "TRF"
                t-NroPed = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999')
                t-CodDiv = Almacen.CodDiv
                t-FchPed = Almdmov.FchDoc
                t-codmat = s-CodMat
                t-CanPed = Almdmov.CanDes.
            x-Total = x-Total + t-CanPed.
        END.
    END.
END.

/* POR ORDENES DE TRANSFERENCIA */
FOR EACH Facdpedi USE-INDEX Llave02 NO-LOCK WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.codmat = s-CodMat
    AND Facdpedi.coddoc = 'STR'     /* Solicitud de Transferencia */
    AND Facdpedi.flgest = 'P':
    FIND FIRST Faccpedi OF Facdpedi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi OR NOT (Faccpedi.flgest = 'P' AND Faccpedi.codcli = s-CodAlm)
        THEN NEXT.
    /* Chequeamos que la R/A NO esté pendientes */
    FIND FIRST Almcrepo WHERE Almcrepo.codcia = s-codcia
        AND Almcrepo.codalm = Faccpedi.codcli
        AND Almcrepo.nroser = INTEGER(SUBSTRING(Faccpedi.nroref,1,3))
        AND Almcrepo.nrodoc = INTEGER(SUBSTRING(Faccpedi.nroref,4))
        AND Almcrepo.flgest = "M"   /* Lo han cerrado manualmente */
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almcrepo THEN NEXT.
    FIND tmp-tabla WHERE t-CodDoc = Faccpedi.coddoc AND t-NroPed = Faccpedi.nroped NO-ERROR.
    IF NOT AVAIL tmp-tabla THEN DO:
        CREATE tmp-tabla.
        ASSIGN 
            t-CodAlm = Faccpedi.CodAlm
            t-CodDoc = Faccpedi.CodDoc
            t-NroPed = Faccpedi.NroPed
            t-CodDiv = Faccpedi.CodDiv
            t-FchPed = Faccpedi.FchPed
            t-codmat = s-CodMat
            t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.CanAte).
        x-Total = x-Total + t-CanPed.
    END.
END.
FOR EACH Facdpedi USE-INDEX Llave02 NO-LOCK WHERE Facdpedi.codcia = s-codcia
    AND Facdpedi.codmat = s-CodMat
    AND Facdpedi.coddoc = 'OTR'     /* Orden de Transferencia */
    AND Facdpedi.flgest = 'P':
    FIND FIRST Faccpedi OF Facdpedi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi OR NOT (Faccpedi.flgest = 'P' AND Faccpedi.codcli = s-CodAlm)
        THEN NEXT.
    FIND tmp-tabla WHERE t-CodDoc = Faccpedi.coddoc AND t-NroPed = Faccpedi.nroped NO-ERROR.
    IF NOT AVAIL tmp-tabla THEN DO:
        CREATE tmp-tabla.
        ASSIGN 
            t-CodAlm = Faccpedi.CodAlm
            t-CodDoc = Faccpedi.CodDoc
            t-NroPed = Faccpedi.NroPed
            t-CodDiv = Faccpedi.CodDiv
            t-FchPed = Faccpedi.FchPed
            t-codmat = s-CodMat
            t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.CanAte).
        x-Total = x-Total + t-CanPed.
    END.
END.
*/


DISPLAY x-Total WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY x-Total 
      WITH FRAME gDialog.
  ENABLE BROWSE-2 Btn_OK 
      WITH FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN CARGA-TEMPORAL.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

