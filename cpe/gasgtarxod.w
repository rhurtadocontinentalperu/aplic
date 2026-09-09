&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
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

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

/* NOTA: Cada parámetro es una lista separados por "|" */
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodZona AS CHAR.
DEF INPUT PARAMETER pUbicacion AS CHAR.
DEF OUTPUT PARAMETER pOk AS LOG.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodDoc AS CHAR INIT 'CPT'.
DEF VAR x-Ubicacion AS CHAR.
DEF VAR x-Orden AS CHAR INIT 'ALM,CHE,DIS,ENT'. /* Orden en que se debe hacer el trabajo */
/*
ALM: sacado de mercaderia
CHE: zona de chequeo
DIS: chequeo en distribución
ENT: listo para la entrega
*/

pOk = NO.
pUbicacion = CAPS( SUBSTRING( ENTRY(1, pUbicacion, '|'), 1, 3 ) ).

FIND FIRST Faccorre WHERE FacCorre.CodCia = s-codcia
    AND FacCorre.CodDiv = s-coddiv
    AND FacCorre.FlgEst = YES
    AND FacCorre.CodDoc = 'CPT'
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'NO se ha definido en control de correlativos (CPT) para esta división' SKIP
        'Proceso abortado'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CodPer COMBO-BOX-Tarea Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodDoc FILL-IN-NroPed ~
FILL-IN-Almacen FILL-IN-Zona FILL-IN-CodPer FILL-IN-NomPer FILL-IN-Area ~
COMBO-BOX-Tarea 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer gDialog 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE COMBO-BOX-Tarea AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tarea" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 41 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Area AS CHARACTER FORMAT "X(256)":U 
     LABEL "Area" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Orden de Despacho" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPer AS CHARACTER FORMAT "X(6)":U 
     LABEL "Personal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(9)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Zona AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zona" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     FILL-IN-CodDoc AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 66
     FILL-IN-NroPed AT ROW 1.27 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     FILL-IN-Almacen AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 62
     FILL-IN-Zona AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 64
     FILL-IN-CodPer AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 54
     FILL-IN-NomPer AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 58
     FILL-IN-Area AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 52
     COMBO-BOX-Tarea AT ROW 6.12 COL 19 COLON-ALIGNED WIDGET-ID 48
     Btn_OK AT ROW 7.46 COL 4
     Btn_Cancel AT ROW 7.46 COL 21
     SPACE(51.99) SKIP(0.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "ASIGNACION DE TAREA"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Area IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodDoc IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPer IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroPed IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Zona IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* ASIGNACION DE TAREA */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    /* Consistencias */
    FIND pl-pers WHERE pl-pers.codper = FILL-IN-CodPer:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        MESSAGE 'Personal NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND cpetrased WHERE cpetrased.CodCia = s-codcia
        AND cpetrased.CodDiv = s-coddiv
        AND cpetrased.CodPer = FILL-IN-CodPer:SCREEN-VALUE
        AND cpetrased.FlgEst = 'P'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cpetrased THEN DO:
        MESSAGE 'Trabajador NO registrado en la SEDE' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF CpeTraSed.FlgTarea <> 'L' THEN DO:
        MESSAGE 'El trabajador YA tiene una tarea asignada' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF COMBO-BOX-Tarea:SCREEN-VALUE = ? THEN DO:
        MESSAGE 'Seleccione la tarea que va a realizar' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    /* BUscamos de acuerdo al código del documento */
    CASE FILL-IN-CodDoc:SCREEN-VALUE:
        WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
            FIND faccpedi WHERE faccpedi.codcia = s-codcia
                AND faccpedi.coddoc = FILL-IN-CodDoc:SCREEN-VALUE
                AND faccpedi.nroped = FILL-IN-NroPed:SCREEN-VALUE
                AND faccpedi.divdes = s-coddiv
                AND LOOKUP (faccpedi.flgest, 'P,C') > 0
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE faccpedi THEN DO:
                MESSAGE 'Orden de Despacho NO válida' VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
            END.
        END.
        WHEN "G/R" THEN DO:
            FIND almcmov WHERE almcmov.codcia = s-codcia
                AND almcmov.nroser = INTEGER(SUBSTRING(FILL-IN-NroPed:SCREEN-VALUE,1,3))
                AND almcmov.nrodoc = INTEGER(SUBSTRING(FILL-IN-NroPed:SCREEN-VALUE,4))
                AND almcmov.codalm = pCodAlm
                AND almcmov.tipmov = "S"
                AND almcmov.codmov = 03
                AND almcmov.flgest <> "A"
                AND almcmov.flgsit = "T"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE almcmov THEN DO:
                MESSAGE 'Guia de Salida por Transferencia NO válida' VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
            END.
        END.
    END CASE.

    /* Ubicacion */
    x-Ubicacion = CpeTraSed.CodArea.
    IF LOOKUP(x-Ubicacion, x-Orden) < LOOKUP(pUbicacion, x-Orden) THEN DO:
        MESSAGE 'La asignación de esta tarea va a requerir la aprobación del supervisor' SKIP
            'Continuamos (S-N)?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
        {adm/i-DocPssw.i s-CodCia s-CodDoc ""UPD""}
    END.

    /* GRABACION */
    MESSAGE 'Confirme la asignación de la tarea' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta-1 AS LOG.
    IF rpta-1 = NO THEN RETURN NO-APPLY.

    DEF VAR s-NroSer LIKE FacCorre.NroSer.
    DEF VAR i AS INT.
    s-NroSer = FacCorre.NroSer.
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND CURRENT CpeTraSed EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE CpeTraSed THEN UNDO, RETURN NO-APPLY.
        ASSIGN
            CpeTraSed.FlgTarea = 'O'.       /* Ocupado */

        DO i = 1 TO NUM-ENTRIES(pCodZona, '|'):
            {vtagn/i-faccorre-01.i &Codigo = 'CPT' &Serie = s-nroser}

            CREATE Cpetareas.
            ASSIGN
                CpeTareas.CodCia = s-codcia
                CpeTareas.CodDiv = s-coddiv
                CpeTareas.CodPer = CpeTraSed.CodPer
                CpeTareas.CodArea = CpeTraSed.CodArea
                CpeTareas.FlgEst = 'P'
                CpeTareas.NroTarea = FacCorre.Correlativo
                CpeTareas.TpoTarea = ENTRY(1, COMBO-BOX-Tarea:SCREEN-VALUE, ' - ')
                CpeTareas.FchInicio = DATETIME(TODAY, MTIME)
                CpeTareas.UsuarioReg = s-user-id
                CpeTareas.CodOD = FILL-IN-CodDoc:SCREEN-VALUE
                CpeTareas.NroOD = FILL-IN-NroPed:SCREEN-VALUE
                CpeTareas.CodAlm = ENTRY(i, pCodAlm, '|')
                CpeTareas.CodZona = ENTRY(i, pCodZona, '|').
            CASE FILL-IN-CodDoc:SCREEN-VALUE:
                WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
                    FOR EACH Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
                        AND Facdpedi.coddoc = Cpetareas.CodOD
                        AND facdpedi.nroped = Cpetareas.NroOD
                        AND Facdpedi.almdes = Cpetareas.CodAlm,
                        FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Facdpedi.codcia
                        AND Almmmate.codalm = Facdpedi.almdes
                        AND Almmmate.codmat = Facdpedi.codmat,
                        FIRST Almtubic OF Almmmate NO-LOCK WHERE Almtubic.CodZona = CpeTareas.CodZona:
                        CpeTareas.TotItems = CpeTareas.TotItems + 1.
                        CpeTareas.TotImporte = CpeTareas.TotImporte + Facdpedi.ImpLin.
                    END.
                END.
                WHEN "G/R" THEN DO:
                    FOR EACH Almdmov OF Almcmov NO-LOCK,
                        FIRST Almmmate OF Almdmov NO-LOCK,
                        FIRST Almtubic OF Almmmate NO-LOCK WHERE Almtubic.CodZona = CpeTareas.CodZona:
                        CpeTareas.TotItems = CpeTareas.TotItems + 1.
                        /*CpeTareas.TotImporte = CpeTareas.TotImporte + Facdpedi.ImpLin.*/
                    END.
                END.
            END CASE.

            ASSIGN
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            /* Tracking de Tareas */
            CREATE CpeTrkTar.
            BUFFER-COPY CpeTareas TO CpeTrkTar.
            ASSIGN
                CpeTrkTar.Estado = 'Tarea Asignada'
                CpeTrkTar.Fecha = DATETIME(TODAY, MTIME)
                CpeTrkTar.Usuario = s-user-id.
        END.
        IF AVAILABLE(CpeTraSed) THEN RELEASE CpeTraSed.
        IF AVAILABLE(CpeTareas) THEN RELEASE CpeTareas.
        IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
        IF AVAILABLE(CpeTrkTar) THEN RELEASE CpeTrkTar.
    END.
    pOk = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPer gDialog
ON LEAVE OF FILL-IN-CodPer IN FRAME gDialog /* Personal */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN DO:
      FILL-IN-NomPer:SCREEN-VALUE = fNomPer(SELF:SCREEN-VALUE).
      FIND cpetrased WHERE cpetrased.CodCia = s-codcia
          AND cpetrased.CodDiv = s-coddiv
          AND cpetrased.CodPer = FILL-IN-CodPer:SCREEN-VALUE
          AND cpetrased.FlgEst = 'P'
          NO-LOCK NO-ERROR.
      IF AVAILABLE cpetrased THEN DO:
          FIND Almtabla WHERE Almtabla.Tabla = 'AS'
              AND almtabla.Codigo = cpetrased.CodArea
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtabla THEN FILL-IN-Area:SCREEN-VALUE = almtabla.Nombre.
      END.
      ELSE DO:
          MESSAGE 'Trabajador NO registrado en la SEDE' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY FILL-IN-CodDoc FILL-IN-NroPed FILL-IN-Almacen FILL-IN-Zona 
          FILL-IN-CodPer FILL-IN-NomPer FILL-IN-Area COMBO-BOX-Tarea 
      WITH FRAME gDialog.
  ENABLE FILL-IN-CodPer COMBO-BOX-Tarea Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
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

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Vtatabla NO-LOCK WHERE VtaTabla.CodCia = s-codcia
          AND VtaTabla.Tabla = 'CPETAREA'
          AND VtaTabla.Libre_c01 = 'Si':    /* Solo los relacionados con O/D */
          COMBO-BOX-Tarea:ADD-LAST(VtaTabla.Llave_c1 + ' - ' + VtaTabla.Llave_c2).
      END.
      ASSIGN
          FILL-IN-Almacen:SCREEN-VALUE = ENTRY (1, pCodAlm, '|')
          FILL-IN-CodDoc:SCREEN-VALUE = ENTRY (1, pCodDoc, '|')
          FILL-IN-NroPed:SCREEN-VALUE = ENTRY (1, pNroPed, '|')
          FILL-IN-Zona:SCREEN-VALUE = pCodZona
          COMBO-BOX-Tarea:SCREEN-VALUE = COMBO-BOX-Tarea:ENTRY(1).
      FIND Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = pCodAlm NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN FILL-IN-Almacen:SCREEN-VALUE = pCodAlm + ' - ' + Almacen.Descripcion.
/*       FIND Almtzona WHERE Almtzona.codcia = s-codcia                                              */
/*           AND Almtzona.codalm = pCodAlm                                                           */
/*           AND AlmtZona.CodZona = pCodZona NO-LOCK NO-ERROR.                                       */
/*       IF AVAILABLE Almtzona THEN FILL-IN-Zona:SCREEN-VALUE = pCodZona + ' - ' + AlmtZona.DesZona. */
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomPer gDialog 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 
  FIND pl-pers WHERE pl-pers.codper = pCodPer NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers 
      THEN RETURN TRIM(pl-pers.patper) + ' ' + TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    ELSE RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

