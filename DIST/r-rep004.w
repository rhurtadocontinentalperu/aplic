&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
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
{src/bin/_prns.i}   /* Para la impresion */

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE Detalle 
    FIELD tFchDoc        AS DATE     COLUMN-LABEL 'Fecha'
    FIELD tNroDoc        AS CHAR     COLUMN-LABEL 'Hoja de Ruta'
    FIELD tResponsable   AS CHAR     COLUMN-LABEL 'Responsable de Reparto'
    FIELD tCodPro        AS CHAR     COLUMN-LABEL 'Proveedor de Transp.'
    FIELD tCodVeh        AS CHAR     COLUMN-LABEL 'Placa'
    FIELD tchofer        AS CHAR     COLUMN-LABEL 'Transportista'
    FIELD tcliente       AS CHAR     COLUMN-LABEL "Cliente"
    FIELD tNro_od        AS CHAR     COLUMN-LABEL 'Orden'
    FIELD tNroGui        AS CHAR     COLUMN-LABEL 'No Guia'
    FIELD tDivOri        AS CHAR     COLUMN-LABEL 'División Pedido'
    FIELD tNroFac        AS CHAR     COLUMN-LABEL 'Número FAC/BOL'
    FIELD tImpFac        AS DEC      COLUMN-LABEL 'Importe FAC/BOL'
    FIELD tSituacion     AS CHAR     COLUMN-LABEL 'Situación'
    FIELD tcodmat        AS CHAR     COLUMN-LABEL 'Item'
    FIELD tdesMat        AS CHAR     COLUMN-LABEL "Descripcion Item"
    FIELD tMotivo        AS CHAR     COLUMN-LABEL "Motivo"
    FIELD tTipo          AS CHAR     COLUMN-LABEL "Tipo"
    FIELD tCantidad      AS DEC      COLUMN-LABEL "Cantidad Devuelta"
    FIELD tImporte       AS DEC      COLUMN-LABEL "Importe devolucion".

DEFINE VAR lDirectorio AS CHAR.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS txtCD FILL-IN-Fecha-1 FILL-IN-Fecha-2 Btn_OK ~
Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS txtCD txtNom-CD FILL-IN-Fecha-1 ~
FILL-IN-Fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fHorTra W-Win 
FUNCTION fHorTra RETURNS DECIMAL
  ( INPUT Parm1 AS CHAR,
    INPUT Parm2 AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Done" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "OK" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE txtCD AS CHARACTER FORMAT "X(256)":U 
     LABEL "CD (Vacio = Todos)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtNom-CD AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtCD AT ROW 2.77 COL 15 COLON-ALIGNED WIDGET-ID 4
     txtNom-CD AT ROW 2.77 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-Fecha-1 AT ROW 4.08 COL 15 COLON-ALIGNED
     FILL-IN-Fecha-2 AT ROW 4.08 COL 38 COLON-ALIGNED
     Btn_OK AT ROW 6 COL 34
     Btn_Done AT ROW 6 COL 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 67 BY 7.12
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE DEVOLUCIONES"
         HEIGHT             = 7.12
         WIDTH              = 67
         MAX-HEIGHT         = 7.12
         MAX-WIDTH          = 67
         VIRTUAL-HEIGHT     = 7.12
         VIRTUAL-WIDTH      = 67
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txtNom-CD IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE DEVOLUCIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE DEVOLUCIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* OK */
DO:
  ASSIGN
    FILL-IN-Fecha-1 FILL-IN-Fecha-2 txtCD txtnom-cd.
  IF txtCD = "" OR txtnom-cd <> ""  THEN DO:

    lDirectorio = "".
    
    SYSTEM-DIALOG GET-DIR lDirectorio  
       RETURN-TO-START-DIR 
       TITLE 'Elija el directorio '.
        IF lDirectorio = "" THEN RETURN NO-APPLY.

      RUN Imprimir.
  END.
  ELSE DO:
      MESSAGE "No existe CD".
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCD W-Win
ON LEAVE OF txtCD IN FRAME F-Main /* CD (Vacio = Todos) */
DO:
  
    DEFINE VAR x-cd AS CHAR.

    txtNom-cd:SCREEN-VALUE = "".

    x-cd = SELF:SCREEN-VALUE.

    IF x-cd <> "" THEN DO:
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
                                gn-divi.coddiv = x-cd NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN txtNom-cd:SCREEN-VALUE = gn-divi.desdiv.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-cabecera W-Win 
PROCEDURE add-cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CREATE detalle.
    ASSIGN tFchDoc = di-rutaC.fchsal
            tNroDoc = di-rutaC.nrodoc
            tResponsable = di-rutaC.responsable
            tCodPro = di-rutaC.codpro + " " + di-rutaC.nomtra
            tCodVeh = di-rutaC.codveh
            tchofer = di-rutaC.libre_c01.

/* Responsable */
FIND FIRST pl-pers WHERE pl-pers.codper = di-rutaC.responsable NO-LOCK NO-ERROR.
IF AVAILABLE pl-pers THEN
        ASSIGN tResponsable = di-rutaC.responsable + " "  +
                pl-pers.nomper + " " + pl-pers.patper + " " +
                pl-pers.matper.

/* Chofer */
FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
    vtatabla.llave_c1 = DI-RutaC.libre_c01 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN DO:
    ASSIGN tchofer = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-detalle-D W-Win 
PROCEDURE add-detalle-D :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN detalle.tcliente = ccbcdocu.codcli + " " + ccbcdocu.nomcli
        tNro_od = ccbcdocu.libre_c01 + " " + ccbcdocu.libre_c02
        tNroGui = SUBSTRING(di-rutaD.nroref,1,3) + "-" + SUBSTRING(di-rutaD.nroref,4)
        tDivOri = ccbcdocu.divori
        tNroFac = IF (AVAILABLE b-ccbcdocu) THEN (b-ccbcdocu.coddoc + " " + b-ccbcdocu.nrodoc) ELSE (ccbcdocu.codref + " " + ccbcdocu.nroref)
        tImpFac = IF (AVAILABLE b-ccbcdocu) THEN b-ccbcdocu.imptot ELSE ccbcdocu.imptot
        tSituacion = di-rutaD.libre_c02        
        tdesMat = IF(AVAILABLE almmmatg) THEN almmmatg.desmat ELSE ""
        tMotivo = di-rutaD.flgestdet
        tTipo = di-rutaD.flgest.

IF tTipo = ? THEN tTipo = "".
IF tTipo = "N" THEN tTipo = "NO ENTREGADO".
IF tTipo = "X" THEN tTipo = "DEVOLUCION TOTAL".
IF tTipo = "C" THEN tTipo = "ENTREGADO".
IF tTipo = "D" THEN tTipo = "DEVOLUCION PARCIAL".
IF tTipo = "P" THEN tTipo = "POR ENTREGAR".

IF tSituacion = ? THEN ASSIGN tSituacion = "".
IF tSituacion = "R" THEN ASSIGN tSituacion = "REPROGRAMADO".
IF tSituacion = "A" THEN ASSIGN tSituacion = "ANULADO".

FIND FIRST almtabla WHERE almtabla.tabla = 'HR' AND
                            almtabla.codigo = di-rutaD.flgestdet AND
                            almtabla.nomant = 'N' AND 
                            almtabla.codcta1 <> "I" NO-LOCK NO-ERROR.
IF AVAILABLE almtabla THEN DO:
    tMotivo = tMotivo + " " + almtabla.nombre.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-detalle-G W-Win 
PROCEDURE add-detalle-G :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN detalle.tcliente = almcmov.nomref
        tNro_od = almcmov.codref + " " + almcmov.nroref
        tNroGui = STRING(almcmov.nroser,"999") + "-" + STRING(almcmov.nrodoc,"9999999999")
        tDivOri = almcmov.almdes
        tNroFac = ""
        tImpFac = 0
        tSituacion = ""
        tdesMat = IF(AVAILABLE almmmatg) THEN almmmatg.desmat ELSE ""
        tMotivo = di-rutaG.flgestdet
        tTipo = di-rutaG.flgest.

IF tTipo = ? THEN tTipo = "".
IF tTipo = "N" THEN tTipo = "NO ENTREGADO".
IF tTipo = "X" THEN tTipo = "DEVOLUCION TOTAL".
IF tTipo = "C" THEN tTipo = "ENTREGADO".
IF tTipo = "D" THEN tTipo = "DEVOLUCION PARCIAL".
IF tTipo = "P" THEN tTipo = "POR ENTREGAR".

IF tSituacion = ? THEN ASSIGN tSituacion = "".
IF tSituacion = "R" THEN ASSIGN tSituacion = "REPROGRAMADO".
IF tSituacion = "A" THEN ASSIGN tSituacion = "ANULADO".

FIND FIRST almtabla WHERE almtabla.tabla = 'HR' AND
                            almtabla.codigo = di-rutaD.flgestdet AND
                            almtabla.nomant = 'N' AND 
                            almtabla.codcta1 <> "I" NO-LOCK NO-ERROR.
IF AVAILABLE almtabla THEN DO:
    tMotivo = tMotivo + " " + almtabla.nombre.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE detalle.
 
SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.

FOR EACH Di-RutaC NO-LOCK WHERE Di-RutaC.codcia = s-codcia
    AND Di-RutaC.coddoc = 'H/R'
    AND (di-rutac.fchsal >= FILL-IN-Fecha-1
    AND di-rutac.fchsal <= FILL-IN-Fecha-2)
    AND Di-RutaC.flgest = 'C' 
    AND (txtCD = "" OR txtCD = di-rutaC.coddiv):    

    /* Despachos O/D */
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK WHERE LOOKUP(TRIM(Di-RutaD.flgest), 'X,D,N') > 0 :
        /*
            X : Devolucion Total (Versiones acteriores)
            N : No entregado
            D : Devolucion parcial
        */

        /* G/R */
        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                                    ccbcdocu.coddoc = di-rutaD.codref AND 
                                    ccbcdocu.nrodoc = di-rutaD.nroref 
                                    NO-LOCK NO-ERROR.

        IF di-rutaD.codref = 'G/R' THEN DO:

            IF AVAILABLE ccbcdocu THEN DO:
                x-coddoc = ccbcdocu.codref.
                x-nrodoc = ccbcdocu.nroref.

                /* El Comprobante */
                FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                                            b-ccbcdocu.coddoc = x-coddoc AND 
                                            b-ccbcdocu.nrodoc = x-nrodoc 
                                            NO-LOCK NO-ERROR.
            END.
        END.
        ELSE DO:
            /* Inducirlo al NOT AVAILABLE */
            FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                                        b-ccbcdocu.coddoc = 'x-coddoc' AND 
                                        b-ccbcdocu.nrodoc = 'x-nrodoc' 
                                        NO-LOCK NO-ERROR.
        END.

        IF Di-RutaD.flgest= 'D' THEN DO:

            FOR EACH di-rutaDv OF di-rutaC NO-LOCK 
                    WHERE di-rutaDv.codref = di-rutaD.codref AND 
                            di-rutaDv.nroref = di-rutaD.nroref AND
                            di-rutaDv.candev > 0 :

                RUN add-cabecera.

                IF AVAILABLE ccbcdocu THEN DO:

                    /* Comprobante */

                    FIND FIRST almmmatg OF di-rutaDV NO-LOCK NO-ERROR.
                    
                    ASSIGN tCantidad = di-rutaDv.candev
                            tImporte = di-rutaDv.candev * di-rutaDv.preuni
                            tcodmat = di-rutaDv.codmat.

                    IF ccbcdocu.codmon = 2  THEN DO:
                        ASSIGN tImporte = (di-rutaDv.candev * di-rutaDv.preuni) * ccbcdocu.tpocmb.
                    END.

                    RUN add-detalle-D.

                END.
                    
            END.
        END.
        ELSE DO:
            /*
            FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                                        ccbcdocu.coddoc = di-rutaD.codref AND 
                                        ccbcdocu.nrodoc = di-rutaD.nroref 
                                        NO-LOCK NO-ERROR.
            */
            IF AVAILABLE ccbcdocu THEN DO:
                FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
                    FIND FIRST almmmatg OF ccbddocu NO-LOCK NO-ERROR.

                    RUN add-cabecera.

                    ASSIGN tCantidad = ccbddocu.candes
                            tImporte = ccbddocu.implin
                            tcodmat = ccbddocu.codmat.
                    IF ccbcdocu.codmon = 2  THEN DO:
                        tImporte = tImporte * ccbcdocu.tpocmb.
                    END.


                    RUN add-detalle-D.

                END.
            END.
        END.

    END.

    /* Despachos OTR */
    FOR EACH Di-RutaG OF Di-RutaC NO-LOCK WHERE LOOKUP(TRIM(Di-RutaG.flgest), 'X,N') > 0 :
        FOR EACH almcmov WHERE almcmov.codcia = di-rutaG.codcia AND 
                                almcmov.codalm = di-rutaG.codalm AND 
                                almcmov.tipmov = di-rutaG.tipmov AND 
                                almcmov.codmov = di-rutaG.codmov AND 
                                almcmov.nroser = di-rutaG.serref AND 
                                almcmov.nrodoc = di-rutag.nroref AND
                                almcmov.codref = 'OTR' NO-LOCK:
            FOR EACH almdmov OF almcmov NO-LOCK:

                FIND FIRST almmmatg OF almdmov NO-LOCK NO-ERROR.

                RUN add-cabecera.

                ASSIGN tCantidad = almdmov.candes                        
                        tcodmat = almdmov.codmat.

                tImporte = almdmov.candes * almmmatg.ctolis.
                IF almmmatg.monvta = 2 AND almmmatg.tpocmb > 0 THEN DO:
                    tImporte = tImporte * almmmatg.tpocmb.
                END.

                RUN add-detalle-G.

            END.
        END.
    END.
END.

SESSION:SET-WAIT-STATE('').

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
  DISPLAY txtCD txtNom-CD FILL-IN-Fecha-1 FILL-IN-Fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtCD FILL-IN-Fecha-1 FILL-IN-Fecha-2 Btn_OK Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.
    DEFINE VAR x-file AS CHAR.

    RUN Carga-Temporal.

    FIND FIRST DETALLE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN DO:
        MESSAGE
            'No hay información a imprimir'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.


    x-file = STRING(TODAY,"99/99/9999").
    x-file = x-file + "-" + STRING(TIME,"HH:MM:SS").

    x-file = REPLACE(x-file,"/","").
    x-file = REPLACE(x-file,":","").

    x-file = "devoluciones-" + x-file.

    SESSION:SET-WAIT-STATE('GENERAL').

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */

    c-xls-file = lDirectorio + '\' + x-file.

    run pi-crea-archivo-csv IN hProc (input  buffer DETALLE:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer DETALLE:handle,
                            input  c-csv-file,
                            output c-xls-file) .

    DELETE PROCEDURE hProc.


    SESSION:SET-WAIT-STATE('').

    MESSAGE "Proceso Terminado" SKIP
            c-xls-file.



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
  ASSIGN
    FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
    FILL-IN-Fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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
        WHEN "" THEN .
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fHorTra W-Win 
FUNCTION fHorTra RETURNS DECIMAL
  ( INPUT Parm1 AS CHAR,
    INPUT Parm2 AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR x-Min1 AS DEC.
  DEF VAR x-Min2 AS DEC.
  
  IF Parm1 = '' OR Parm2 = '' THEN RETURN 0.00.   /* Function return value. */
  ASSIGN
    x-Min1 = INTEGER(SUBSTRING(Parm1,1,2)) * 60 +
            INTEGER(SUBSTRING(Parm1,3))
    x-Min2 = INTEGER(SUBSTRING(Parm2,1,2)) * 60 +
            INTEGER(SUBSTRING(Parm2,3))
    NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN 0.00.
  IF x-Min2 < x-Min1 THEN RETURN 0.00.
  RETURN (x-Min2 - x-Min1) / 60.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

