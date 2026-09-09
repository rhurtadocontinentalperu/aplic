&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

DEFINE TEMP-TABLE tmpGRERpt 
    FIELD   motivoTraslado LIKE gre_header.motivoTraslado COLUMN-LABEL "Cod.Mot.Trasaldo"
    FIELD   dMotivoTraslado LIKE gre_header.descripcionMotivoTraslado COLUMN-LABEL "Descripcion.Mot.Trasaldo"
    FIELD   m_codmov LIKE gre_header.m_codmov COLUMN-LABEL "Cod. Movimiento"
    FIELD   descripcionMotivoTraslado LIKE gre_header.descripcionMotivoTraslado COLUMN-LABEL "Descripcion.Movimiento"
    FIELD   ncorrelatio LIKE gre_header.ncorrelatio COLUMN-LABEL "Nro. Pre-guia"
    FIELD   fechaEmisionGuia LIKE gre_header.fechaEmisionGuia COLUMN-LABEL "Fecha de emision"
    FIELD   horaEmisionGuia LIKE gre_header.horaEmisionGuia COLUMN-LABEL "Hora emision"
    FIELD   serieGuia LIKE gre_header.serieGuia COLUMN-LABEL "Serie Guia"
    FIELD   numeroGuia LIKE gre_header.numeroGuia COLUMN-LABEL "Numero Guia"
    FIELD   m_codalm LIKE gre_header.m_codalm COLUMN-LABEL "Alm. Origen"
    FIELD   m_cliente LIKE gre_header.m_cliente COLUMN-LABEL "Cod.Cliente"
    FIELD   razonSocialDestinatario LIKE gre_header.razonSocialDestinatario COLUMN-LABEL "Nombre del Cliente"
    FIELD   m_rspta_sunat LIKE gre_header.m_rspta_sunat COLUMN-LABEL "Estado Sunat"
    FIELD   m_usuario LIKE gre_header.m_usuario COLUMN-LABEL "Usuario"
    FIELD   m_sede LIKE gre_header.m_sede COLUMN-LABEL "Cod.Sede"
    FIELD   direccionPtoLlegada LIKE gre_header.direccionPtoLlegada COLUMN-LABEL "Direccion llegada"
    FIELD   m_nroref1 LIKE gre_header.m_nroref1 COLUMN-LABEL "Cod.Solicitante"
    FIELD   m_nroref2 LIKE gre_header.m_nroref2 COLUMN-LABEL "Cod.Aprobador"
    FIELD   numeroBultos LIKE gre_header.numeroBultos COLUMN-LABEL "Bultos"
    FIELD   pesoBrutoTotalBienes LIKE gre_header.pesoBrutoTotalBienes COLUMN-LABEL "Peso bruto KGR"
    FIELD   m_llevar_traer_mercaderia LIKE gre_header.m_llevar_traer_mercaderia COLUMN-LABEL "Movimiento 1: Salidas"
    FIELD   observaciones LIKE gre_header.observaciones COLUMN-LABEL "Observaciones"
    FIELD   nroitm LIKE gre_detail.nroitm COLUMN-LABEL "Itm"
    FIELD   usr_desalm    AS CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Descripcion almacen"
    FIELD   usr_solipor     AS  CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Solicitado por"
    FIELD   usr_apropor     AS  CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Abrobado por"
    FIELD   usr_codmat      AS  CHAR     FORMAT 'x(8)'  COLUMN-LABEL "Cod.Articulo"
    FIELD   usr_desmat      AS  CHAR     FORMAT 'x(8)'  COLUMN-LABEL "Descripcion articulo"
    FIELD   usr_candes      AS  DEC     FORMAT '->>,>>>,>>9.9999'   COLUMN-LABEL "Cantidad"
    FIELD   usr_marca       AS  CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Marca"
    FIELD   usr_undmed       AS  CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Unidad Medida"
    FIELD   usr_muevestk      AS  CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Mueve Stock"
.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-almacenes FILL-IN-desde ~
FILL-IN-hasta BUTTON-ruta BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-almacenes FILL-IN-almacen ~
FILL-IN-desde FILL-IN-hasta TOGGLE-tipomov FILL-IN-ruta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar" 
     SIZE 14 BY .96.

DEFINE BUTTON BUTTON-ruta 
     LABEL "..." 
     SIZE 4 BY .92.

DEFINE VARIABLE FILL-IN-almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-almacenes AS CHARACTER FORMAT "X(6)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ruta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ruta" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-tipomov AS LOGICAL INITIAL yes 
     LABEL "Solo salidas mercaderia - Motivo sunat OTROS (13)" 
     VIEW-AS TOGGLE-BOX
     SIZE 39 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-almacenes AT ROW 1.5 COL 14 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-almacen AT ROW 1.5 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-desde AT ROW 3.42 COL 14 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-hasta AT ROW 3.42 COL 37 COLON-ALIGNED WIDGET-ID 6
     TOGGLE-tipomov AT ROW 4.77 COL 15.29 WIDGET-ID 8
     BUTTON-ruta AT ROW 5.96 COL 53.43 WIDGET-ID 18
     FILL-IN-ruta AT ROW 6 COL 6 COLON-ALIGNED WIDGET-ID 16
     BUTTON-1 AT ROW 7.38 COL 34.86 WIDGET-ID 10
     "(Blanco = todos los almacenes)" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 2.54 COL 16 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.14 BY 7.92
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "Salidas de mercaderias GRE"
         HEIGHT             = 7.92
         WIDTH              = 62.14
         MAX-HEIGHT         = 38.81
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 38.81
         VIRTUAL-WIDTH      = 274.29
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
/* SETTINGS FOR FILL-IN FILL-IN-almacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ruta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-tipomov IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Salidas de mercaderias GRE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Salidas de mercaderias GRE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:
  ASSIGN fill-in-almacenes fill-in-desde fill-in-hasta toggle-tipomov fill-in-ruta.

  IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
      MESSAGE "El rango de fechas no son validas" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "El rango de fechas estan erradas" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  IF NOT (TRUE <> (fill-in-almacenes > "")) THEN DO:
      FIND FIRST almacen WHERE almacen.codcia = 1 AND 
                                almacen.codalm = fill-in-almacenes NO-LOCK NO-ERROR.
      IF NOT AVAILABLE almacen THEN DO:
          MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX INFORMATION.
          RETURN NO-APPLY.
      END.
  END.

  IF TRUE <> (fill-in-ruta > "") THEN DO:
      MESSAGE "Seleccione la RUTA donde grabar le archivo EXCEL" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
      
  /*fill-in-almacen:SCREEN-VALUE = almacen.descripcion.*/

    RUN procesar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-ruta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-ruta W-Win
ON CHOOSE OF BUTTON-ruta IN FRAME F-Main /* ... */
DO:
  
    DEFINE VAR lDirectorio AS CHAR.

        lDirectorio = "".

        SYSTEM-DIALOG GET-DIR lDirectorio  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.


        IF lDirectorio = "" THEN DO :
        /**/        
            END.
             ELSE fill-in-ruta:SCREEN-VALUE = lDirectorio.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-almacenes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-almacenes W-Win
ON LEAVE OF FILL-IN-almacenes IN FRAME F-Main /* Almacen */
DO:
    ASSIGN {&self-name}.

    fill-in-almacen:SCREEN-VALUE = "".

    FIND FIRST almacen WHERE almacen.codcia = 1 AND 
                              almacen.codalm = fill-in-almacenes NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN fill-in-almacen:SCREEN-VALUE = almacen.descripcion.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
  DISPLAY FILL-IN-almacenes FILL-IN-almacen FILL-IN-desde FILL-IN-hasta 
          TOGGLE-tipomov FILL-IN-ruta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-almacenes FILL-IN-desde FILL-IN-hasta BUTTON-ruta BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      fill-in-desde:SCREEN-VALUE = STRING(TODAY - 15,"99/99/99999").
      fill-in-hasta:SCREEN-VALUE = STRING(TODAY,"99/99/99999").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tmpGRERpt.
        
SESSION:SET-WAIT-STATE('GENERAL').
DEFINE VAR iConteo AS INT.
DEFINE VAR iConteo1 AS INT.

DEFINE VAR cNomPersonal1 AS CHAR.
DEFINE VAR cNomPersonal2 AS CHAR.

FOR EACH gre_header WHERE gre_header.fechaEmisionGuia >= fill-in-desde AND 
                            gre_header.fechaEmisionGuia <= fill-in-hasta AND 
                            gre_header.motivoTraslado = '13' AND gre_header.m_llevar_traer_mercaderia = 1 NO-LOCK,
         EACH gre_detail WHERE gre_header.ncorrelatio = gre_detail.ncorrelativo NO-LOCK,
         FIRST almmmatg WHERE almmmatg.codcia = 1 AND almmmatg.codmat =  gre_detail.codmat NO-LOCK 
         BREAK BY gre_header.ncorrelatio :

    iConteo = iConteo + 1.
    IF NOT (TRUE <> (fill-in-almacenes > "")) THEN DO:
        /* Del mismo almacen */
        IF fill-in-almacenes <> gre_header.m_codalm THEN NEXT.
    END.
    /* Solo salidas */
    /*IF gre_header.m_llevar_traer_mercaderia <> 1 THEN NEXT.*/

    IF FIRST-OF(gre_header.ncorrelatio) THEN DO:
        FIND FIRST almacen WHERE almacen.codcia = 1 AND 
                                  almacen.codalm = gre_header.m_codalm NO-LOCK NO-ERROR.

          FIND FIRST almtmovm WHERE almtmovm.codcia = 1 AND almtmovm.tipmov = 'S' AND 
          almtmovm.codmov = gre_header.m_codmov NO-LOCK NO-ERROR.

        FIND FIRST sunat_fact_electr_detail WHERE sunat_fact_electr_detail.catalogue = 20 AND
                                                    sunat_fact_electr_detail.CODE = gre_header.motivoTraslado NO-LOCK NO-ERROR.

        cNomPersonal2 = "".
        cNomPersonal1 = "".
         RUN gn/nombre-personal(1, gre_header.m_nroref1, OUTPUT cNomPersonal1).
         RUN gn/nombre-personal(1, gre_header.m_nroref2, OUTPUT cNomPersonal2).
    END.

    CREATE tmpGRERpt.
    BUFFER-COPY gre_header TO tmpGRERpt.
    ASSIGN tmpGRERpt.usr_desalm = IF AVAILABLE almacen THEN almacen.descripcion ELSE ""
           tmpGRERpt.usr_solipor = cNomPersonal1
           tmpGRERpt.usr_apropor = cNomPersonal2
            tmpGRERpt.usr_codmat = gre_detail.codmat
            tmpGRERpt.usr_desmat = almmmatg.desmat
            tmpGRERpt.usr_candes = gre_detail.candes * gre_detail.factor
            tmpGRERpt.usr_marca = almmmatg.desmar
            tmpGRERpt.usr_undmed = gre_detail.codund
            tmpGRERpt.usr_muevestk = "NO MUEVE STOCK"
            tmpGRERpt.dMotivoTraslado = IF AVAILABLE sunat_fact_electr_detail THEN sunat_fact_electr_detail.DESCRIPTION ELSE ""
            tmpGRERpt.nroitm = gre_detail.nroitm
                .

      IF AVAILABLE almtmovm THEN DO:
          IF almtmovm.movVal =YES THEN DO:
                ASSIGN tmpGRERpt.usr_muevestk = "SI MUEVE STOCK".                  
          END.
      END.

    iConteo1 = iConteo1 + 1.
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = fill-in-ruta + "\GRE-OTROS-SALIDAS.xlsx".

run pi-crea-archivo-csv IN hProc (input  buffer tmpGRERpt:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tmpGRERpt:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso terminado" SKIP
    "Se grabo el archivo en " SKIP
    c-xls-file
    VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.



/*
    FIELD   usr_desalm    AS CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Descripcion almacen"
    FIELD   usr_solipor     AS  CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Solicitado por"
    FIELD   usr_apropor     AS  CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Abrobado por"
    FIELD   usr_codmat      AS  CHAR     FORMAT 'x(8)'  COLUMN-LABEL "Cod.Articulo"
    FIELD   usr_desmat      AS  CHAR     FORMAT 'x(8)'  COLUMN-LABEL "Descripcion articulo"
    FIELD   usr_candes      AS  DEC     FORMAT '->>,>>>,>>9.9999'   COLUMN-LABEL "Cantidad"
    FIELD   usr_marca       AS  CHAR     FORMAT 'x(80)'  COLUMN-LABEL "Marca"
    FIELD   usr_undmed       AS  CHAR     FORMAT 'x(25)'  COLUMN-LABEL "Unidad Medida"
*/

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

