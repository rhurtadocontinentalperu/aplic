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

DEF SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tabla
    FIELDS tt-coddiv AS CHAR
    FIELDS tt-codmat LIKE almmmatg.codmat
    FIELDS tt-desmat LIKE almmmatg.desmat
    FIELDS tt-desmar LIKE almmmatg.desmar
    FIELDS tt-unidad LIKE almmmatg.undbas
    FIELDS tt-factor LIKE almmmatg.facequ
    FIELDS tt-stock  AS DECIMAL
    FIELDS tt-cancot AS DECIMAL  EXTENT 5
    FIELDS tt-canped AS DECIMAL  EXTENT 5
    FIELDS tt-candes AS DECIMAL  EXTENT 5
    FIELDS tt-candif AS DECIMAL  EXTENT 5.

DEFINE VARIABLE iInt AS INTEGER NO-UNDO INIT 0.


DEFINE VAR X-CODDIV  AS CHAR.
DEFINE VAR X-ARTI    AS CHAR.
DEFINE VAR X-FAMILIA AS CHAR.
DEFINE VAR X-SUBFAMILIA AS CHAR.
DEFINE VAR X-MARCA    AS CHAR.
DEFINE VAR X-PROVE    AS CHAR.
DEFINE VAR X-LLAVE    AS CHAR.
DEFINE VAR X-FECHA AS DATE.
DEFINE VAR X-CODDIA AS INTEGER INIT 1.
DEFINE VAR X-CODANO AS INTEGER .
DEFINE VAR X-CODMES AS INTEGER .
DEFINE VAR X-NROCOT LIKE faccpedi.nroped.

DEFINE BUFFER b-facdpedi FOR FacDPedi.

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
&Scoped-Define ENABLED-OBJECTS F-CodFam BUTTON-6 F-SubFam BUTTON-7 f-codmat ~
dDesde dHasta dDesde-2 dHasta-2 BUTTON-1 BUTTON-2 RECT-1 RECT-57 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-SubFam f-codmat dDesde dHasta ~
dDesde-2 dHasta-2 txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCantidades W-Win 
FUNCTION fCantidades RETURNS DECIMAL
  ( INPUT Parm1 AS CHAR, INPUT Parm2 AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 1" 
     SIZE 13 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 2" 
     SIZE 13 BY 1.5.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 6" 
     SIZE 4.43 BY .81.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 7" 
     SIZE 4.43 BY .81.

DEFINE VARIABLE dDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE dDesde-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE dHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE dHasta-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE f-codmat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .81
     BGCOLOR 8  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 8.35.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 1.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 2.08 COL 11 COLON-ALIGNED WIDGET-ID 20
     BUTTON-6 AT ROW 2.08 COL 19 WIDGET-ID 16
     F-SubFam AT ROW 3.19 COL 11 COLON-ALIGNED WIDGET-ID 22
     BUTTON-7 AT ROW 3.19 COL 19 WIDGET-ID 18
     f-codmat AT ROW 4.31 COL 11 COLON-ALIGNED WIDGET-ID 24
     dDesde AT ROW 5.58 COL 17.57 COLON-ALIGNED WIDGET-ID 4
     dHasta AT ROW 6.65 COL 17.57 COLON-ALIGNED WIDGET-ID 6
     dDesde-2 AT ROW 5.58 COL 47 COLON-ALIGNED WIDGET-ID 26
     dHasta-2 AT ROW 6.65 COL 47 COLON-ALIGNED WIDGET-ID 28
     txt-msj AT ROW 8.54 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     BUTTON-1 AT ROW 10.12 COL 33.86 WIDGET-ID 8
     BUTTON-2 AT ROW 10.12 COL 47 WIDGET-ID 10
     "Despacho" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 6.65 COL 34.43 WIDGET-ID 36
          FONT 6
     "Fecha" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.85 COL 34.43 WIDGET-ID 34
          FONT 6
     "Cotización" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 6.65 COL 5 WIDGET-ID 32
          FONT 6
     "Fecha" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.85 COL 5 WIDGET-ID 30
          FONT 6
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 2
     RECT-57 AT ROW 9.88 COL 2 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.57 BY 11.35
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Consolidado de Stock Articulos"
         HEIGHT             = 11.35
         WIDTH              = 61.57
         MAX-HEIGHT         = 11.35
         MAX-WIDTH          = 61.57
         VIRTUAL-HEIGHT     = 11.35
         VIRTUAL-WIDTH      = 61.57
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

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consolidado de Stock Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consolidado de Stock Articulos */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN f-CodFam f-SubFam f-codmat dDesde dHasta dDesde-2 dHasta-2.

  FOR EACH tabla:
      DELETE tabla.
  END.

  DISPLAY "Cargando Informacion" @ txt-msj WITH FRAME {&FRAME-NAME}.
  RUN Excel.
  DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = "".
    output-var-2 = "".
    RUN lkup\C-Famili02.r("Familias").
    IF output-var-2 <> ? THEN DO:
        F-CODFAM = output-var-2.
        DISPLAY F-CODFAM.
        IF NUM-ENTRIES(F-CODFAM) > 1 THEN ASSIGN 
        F-SUBFAM:SENSITIVE = FALSE
        F-SUBFAM:SCREEN-VALUE = ""
        BUTTON-2:SENSITIVE = FALSE.
        ELSE ASSIGN 
        F-SUBFAM:SENSITIVE = TRUE
        BUTTON-2:SENSITIVE = TRUE.
        APPLY "ENTRY" TO F-CODFAM .
        RETURN NO-APPLY.
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    input-var-1 = F-CODFAM.
    output-var-2 = "".
    RUN lkup\C-SubFam02.r("SubFamilias").
    IF output-var-2 <> ? THEN DO:
        F-SUBFAM = output-var-2.
        DISPLAY F-SUBFAM.
        APPLY "ENTRY" TO F-SUBFAM .
        RETURN NO-APPLY.
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Familia */
DO:
   ASSIGN F-CodFam.
   IF NUM-ENTRIES(F-CODFAM) > 1 THEN ASSIGN 
       F-SUBFAM:SENSITIVE = FALSE
       F-SUBFAM:SCREEN-VALUE = ""
       BUTTON-2:SENSITIVE = FALSE.
   ELSE ASSIGN
    F-SUBFAM:SENSITIVE = TRUE
    BUTTON-2:SENSITIVE = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-Familia */
DO:
   ASSIGN F-CodFam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-CodFam = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                  AND  AlmSFami.codfam = F-CodFam 
                  AND  AlmSFami.subfam = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmSFami THEN DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Cotizado W-Win 
PROCEDURE Carga-Cotizado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE f-factor AS DECIMAL NO-UNDO.
    
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        FOR EACH faccpedi WHERE faccpedi.codcia = gn-divi.codcia
            AND faccpedi.coddiv = gn-divi.coddiv
            AND faccpedi.coddoc = "COT"
            AND FacCPedi.FchPed >= dDesde
            AND FacCPedi.FchPed <= dHasta 
            AND faccpedi.flgest <> "A" NO-LOCK:

            FOR EACH facdpedi OF faccpedi NO-LOCK,
                FIRST almmmatg OF facdpedi NO-LOCK 
                WHERE almmmatg.codfam  BEGINS f-codfam
                AND almmmatg.subfam BEGINS  f-subfam
                AND almmmatg.codmat BEGINS f-codmat:
                PAUSE 0.
                FIND FIRST tabla WHERE tabla.tt-codmat = facdpedi.codmat NO-ERROR.
                IF NOT AVAIL tabla THEN DO:
                    CREATE tabla.
                    ASSIGN 
                        tabla.tt-codmat = facdpedi.codmat
                        tabla.tt-desmat = almmmatg.desmat
                        tabla.tt-desmar = almmmatg.desmar
                        tabla.tt-unidad = almmmatg.undbas.
                END.

                /*Factor de Conversion*/
                FIND Almtconv WHERE Almtconv.CodUnid  = tabla.tt-unidad
                    AND Almtconv.Codalter = facdpedi.UndVta NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN DO:
                    F-FACTOR = Almtconv.Equival.
                    IF almmmatg.facequ <> 0 THEN F-FACTOR = Almtconv.Equival / almmmatg.facequ.
                END.        
                 /*Revisando provincias*/
                CASE FacCPedi.CodDiv:
                    WHEN "00000" THEN DO:
                        IF LOOKUP(TRIM(FacCPedi.CodVen),"015,901,179,902") > 0 THEN DO:                    
                            ASSIGN 
                                tabla.tt-cancot[2] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[2]
                                tabla.tt-canped[2] = tabla.tt-canped[2] + (FacDPedi.CanAte * f-factor). 
                            NEXT.
                        END.
                        IF FacCPedi.CodVen = "151" THEN DO:
                            ASSIGN 
                                tabla.tt-cancot[3] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[3]
                                tabla.tt-canped[3] = tabla.tt-canped[3] + (FacDPedi.CanAte * f-factor). 
                            NEXT.
                        END.
                        ELSE DO:                    
                            ASSIGN 
                                tabla.tt-cancot[5] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[5]
                                tabla.tt-canped[5] = tabla.tt-canped[5] + (FacDPedi.CanAte * f-factor). 
                            NEXT.
                        END.    
                    END.
                    WHEN "00001" OR WHEN "00002" OR WHEN "00003" OR WHEN "00014" 
                        OR WHEN "00005" OR WHEN "00011" OR WHEN "00008" THEN DO:
                        ASSIGN 
                            tabla.tt-cancot[1] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[1]
                            tabla.tt-canped[1] = tabla.tt-canped[1] + (FacDPedi.Canate * f-factor). 
                        NEXT. 
                    END.
                    WHEN "00015" THEN DO:
                        ASSIGN 
                            tabla.tt-cancot[4] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[4]
                            tabla.tt-canped[4] = tabla.tt-canped[4] + (FacDPedi.CanAte * f-factor). 
                        NEXT.            
                    END.
                    OTHERWISE DO:                
                        ASSIGN 
                            tabla.tt-cancot[5] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[5]
                            tabla.tt-canped[5] = tabla.tt-canped[5] + (FacDPedi.CanAte * f-factor).  
                        NEXT.
                    END.
                END CASE.
            END.
        END.
    END.
 /*   
    FOR EACH FacDPedi USE-INDEX llave02
        WHERE FacDPedi.CodCia = s-codcia
        AND LOOKUP(FacDPedi.CodDoc,"COT ") > 0
        AND FacDPedi.FchPed >= dDesde
        AND FacDPedi.FchPed <= dHasta
        AND FacDPedi.FlgEst  = "P" NO-LOCK:            
        
        /*Verifica las condiciones del reporte*/
        FIND FIRST almmmatg WHERE almmmatg.codcia = FacDPedi.codcia
            AND almmmatg.codmat = facdpedi.codmat 
            AND almmmatg.codfam BEGINS f-CodFam 
            AND almmmatg.subfam BEGINS f-SubFam NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN NEXT.     
        IF NOT FacDPedi.CodMat BEGINS f-codmat THEN NEXT.

        FIND FIRST tabla WHERE tabla.tt-codmat = facdpedi.codmat NO-ERROR.
        IF NOT AVAIL tabla THEN DO:
            CREATE tabla.
            ASSIGN 
                tabla.tt-codmat = facdpedi.codmat
                tabla.tt-desmat = almmmatg.desmat
                tabla.tt-desmar = almmmatg.desmar
                tabla.tt-unidad = almmmatg.undbas.
        END.

        /*Factor de Conversion*/
        FIND Almtconv WHERE Almtconv.CodUnid  = tabla.tt-unidad
            AND Almtconv.Codalter = facdpedi.UndVta NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            IF almmmatg.facequ <> 0 THEN F-FACTOR = Almtconv.Equival / almmmatg.facequ.
        END.        

        FIND FIRST FacCPedi OF FacDPedi NO-LOCK NO-ERROR.
        IF AVAILABLE FacCPedi THEN FacCPedi.CodVen = FacCPedi.codven.

         /*Revisando provincias*/
        CASE FacCPedi.CodDiv:
            WHEN "00000" THEN DO:
                IF LOOKUP(TRIM(FacCPedi.CodVen),"015,901,179,902") > 0 THEN DO:                    
                    ASSIGN 
                        tabla.tt-cancot[2] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[2]
                        tabla.tt-canped[2] = tabla.tt-canped[2] + fCantidades(FacDPedi.NroPed, FacDPedi.CodMat). 
                    NEXT.
                END.
                IF FacCPedi.CodVen = "151" THEN DO:
                    ASSIGN 
                        tabla.tt-cancot[3] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[3]
                        tabla.tt-canped[3] = tabla.tt-canped[3] + fCantidades(FacDPedi.NroPed, FacDPedi.CodMat). 
                    NEXT.
                END.
                ELSE DO:                    
                    ASSIGN 
                        tabla.tt-cancot[5] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[5]
                        tabla.tt-canped[5] = tabla.tt-canped[5] + fCantidades(FacDPedi.NroPed, FacDPedi.CodMat). 
                    NEXT.
                END.    
            END.
            WHEN "00001" OR WHEN "00002" OR WHEN "00003" OR WHEN "00014" THEN DO:
                ASSIGN 
                    tabla.tt-cancot[1] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[1]
                    tabla.tt-canped[1] = tabla.tt-canped[1] + fCantidades(FacDPedi.NroPed, FacDPedi.CodMat). 
                NEXT. 
            END.
            WHEN "00015" THEN DO:
                ASSIGN 
                    tabla.tt-cancot[4] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[4]
                    tabla.tt-canped[4] = tabla.tt-canped[4] + fCantidades(FacDPedi.NroPed, FacDPedi.CodMat). 
                NEXT.            
            END.
            OTHERWISE DO:                
                ASSIGN 
                    tabla.tt-cancot[5] = (FacDPedi.CanPed * f-factor) + tabla.tt-cancot[5]
                    tabla.tt-canped[5] = tabla.tt-canped[5] + fCantidades(FacDPedi.NroPed, FacDPedi.CodMat).  
                NEXT.
            END.
        END CASE.
    END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data W-Win 
PROCEDURE Carga-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /*
 FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia
     AND faccpedi.coddoc = "PED"
     AND faccpedi.fchped >= dDesde
     AND faccpedi.fchped <= dHasta NO-LOCK,
     EACH facdpedi OF faccpedi NO-LOCK:

     /*Verifica las condiciones del reporte*/
     FIND FIRST almmmatg WHERE almmmatg.codcia = faccpedi.codcia
         AND almmmatg.codmat = facdpedi.codmat 
         AND almmmatg.codfam BEGINS f-CodFam 
         AND almmmatg.subfam BEGINS f-SubFam NO-LOCK NO-ERROR.
     IF NOT AVAILABLE almmmatg THEN NEXT.     
     IF NOT FacDPedi.CodMat BEGINS f-codmat THEN NEXT.

     FIND FIRST tabla WHERE tabla.tt-codmat = facdpedi.codmat NO-LOCK NO-ERROR.
     IF NOT AVAIL tabla THEN DO:
         CREATE tabla.
         ASSIGN tabla.tt-codmat = facdpedi.codmat.
     END.

     /*Revisando provincias*/
     CASE faccpedi.coddiv:
         WHEN "00000" THEN DO:
             IF LOOKUP(TRIM(faccpedi.codven),"015,901,179,902") > 0 THEN DO:                    
                 ASSIGN 
                     tabla.tt-totped[2] = tabla.tt-totped[2] + 1
                     tabla.tt-canate[2] = facdpedi.canate + tabla.tt-canate[2]
                     tabla.tt-candif[2] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[2].
                 NEXT.
             END.
             IF faccpedi.codven = "151" THEN DO:
                 ASSIGN 
                     tabla.tt-totped[3] = tabla.tt-totped[3] + 1
                     tabla.tt-canate[3] = facdpedi.canate + tabla.tt-canate[3]
                     tabla.tt-candif[3] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[3].
                 NEXT.
             END.
             ELSE DO:                    
                 ASSIGN 
                     tabla.tt-totped[5] = tabla.tt-totped[5] + 1
                     tabla.tt-canate[5] = facdpedi.canate + tabla.tt-canate[5]
                     tabla.tt-candif[5] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[5].
                 NEXT.
             END.    
         END.
         WHEN "00001" OR WHEN "00002" OR WHEN "00003" OR WHEN "00014" THEN DO:
             ASSIGN 
                 tabla.tt-totped[1] = tabla.tt-totped[1] + 1
                 tabla.tt-canate[1] = facdpedi.canate + tabla.tt-canate[1]
                 tabla.tt-candif[1] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[1].
             NEXT.
         END.
         WHEN "00015" THEN DO:
             ASSIGN 
                 tabla.tt-totped[4] = tabla.tt-totped[4] + 1
                 tabla.tt-canate[4] = facdpedi.canate + tabla.tt-canate[4]
                 tabla.tt-candif[4] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[4].
             NEXT.
         END.
         OTHERWISE DO:                
             ASSIGN 
                 tabla.tt-totped[5] = tabla.tt-totped[5] + 1
                 tabla.tt-canate[5] = facdpedi.canate + tabla.tt-canate[5]
                 tabla.tt-candif[5] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[5].    
             NEXT.
         END.
     END CASE.
 END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data2 W-Win 
PROCEDURE Carga-Data2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN Carga-Cotizado.
    /*RUN Carga-Pedidos.*/
    RUN Carga-Despachos.
    RUN Carga-Stock.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Despachos W-Win 
PROCEDURE Carga-Despachos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE f-factor AS DECIMAL     NO-UNDO.
    
    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        FOR EACH CcbCDocu USE-INDEX Llave10
            WHERE CcbCDocu.CodCia = gn-divi.codcia
            AND CcbCDocu.CodDiv = gn-divi.coddiv
            AND LOOKUP(CcbCDocu.CodDoc,"FAC,BOL,TCK") > 0
            AND CcbCDocu.FchDoc >= dDesde-2
            AND CcbCDocu.FchDoc <= dHasta-2 NO-LOCK:
            IF  CcbCDocu.FlgEst = "A" THEN NEXT.

            FOR EACH CcbDDocu OF CcbCDocu NO-LOCK,
                FIRST almmmatg OF CcbDDocu NO-LOCK
                WHERE almmmatg.codfam BEGINS f-CodFam 
                AND almmmatg.subfam BEGINS f-SubFam 
                AND almmmatg.codmat BEGINS f-codmat:
                PAUSE 0.
                FIND FIRST tabla WHERE tabla.tt-codmat = CcbDDocu.codmat NO-ERROR.
                IF NOT AVAIL tabla THEN DO:
                    CREATE tabla.
                    ASSIGN 
                        tabla.tt-codmat = ccbddocu.codmat
                        tabla.tt-desmat = almmmatg.desmat
                        tabla.tt-desmar = almmmatg.desmar
                        tabla.tt-unidad = almmmatg.undbas
                        tabla.tt-factor = almmmatg.facequ.
                END.

                /*Factor de Conversion*/
                FIND Almtconv WHERE Almtconv.CodUnid  = almmmatg.undbas
                    AND Almtconv.Codalter = CcbdDocu.UndVta NO-LOCK NO-ERROR.
                IF AVAILABLE Almtconv THEN DO:
                    F-FACTOR = Almtconv.Equival.
                    IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
                END.

                /*Revisando provincias*/
                CASE CcbCDocu.CodDiv:
                    WHEN "00000" THEN DO:
                        IF LOOKUP(TRIM(CcbCDocu.codven),"015,901,179,902") > 0 THEN DO:                    
                            ASSIGN tabla.tt-candes[2] = (CcbDDocu.CanDes * f-factor) + tabla.tt-candes[2]. NEXT.
                        END.
                        IF CcbCDocu.codven = "151" THEN DO:
                            ASSIGN tabla.tt-candes[3] = (CcbDDocu.CanDes * f-factor) + tabla.tt-candes[3]. NEXT.
                        END.
                        ELSE DO:                    
                            ASSIGN tabla.tt-candes[5] = (CcbDDocu.CanDes * f-factor) + tabla.tt-candes[5]. NEXT.
                        END.    
                    END.
                    WHEN "00001" OR WHEN "00002" OR WHEN "00003" OR WHEN "00014" 
                        OR WHEN "00005" OR WHEN "00011" OR WHEN "00008" THEN DO:
                        ASSIGN tabla.tt-candes[1] = (CcbDDocu.CanDes * f-factor) + tabla.tt-candes[1]. NEXT. 
                    END.
                    WHEN "00015" THEN DO:
                        ASSIGN tabla.tt-candes[4] = (CcbDDocu.CanDes * f-factor) + tabla.tt-candes[4]. NEXT.            
                    END.
                    OTHERWISE DO:                
                        ASSIGN tabla.tt-candes[5] = (CcbDDocu.CanDes * f-factor) + tabla.tt-candes[5]. NEXT.
                    END.
                END CASE.

            END.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Pedidos W-Win 
PROCEDURE Carga-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE f-factor AS DECIMAL     NO-UNDO.

    FOR EACH FacCPedi WHERE FacCPedi.CodCia = s-codcia
        AND LOOKUP(FacCPedi.CodDoc,"PED") > 0
        AND FacCPedi.Flgest = "P"
        AND FacCPedi.FchPed >= dDesde
        AND FacCPedi.FchPed <= dHasta 
        AND FacCPedi.FlgEst <> "A" NO-LOCK,
        EACH FacDPedi OF FacCPedi NO-LOCK
        /*WHERE FacDPedi.CodMat = Almmmatg.CodMat*/  :

        /*Verifica las condiciones del reporte*/
        FIND FIRST almmmatg WHERE almmmatg.codcia = faccpedi.codcia
            AND almmmatg.codmat = facdpedi.codmat 
            AND almmmatg.codfam BEGINS f-CodFam 
            AND almmmatg.subfam BEGINS f-SubFam NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN NEXT.     
        IF NOT FacDPedi.CodMat BEGINS f-codmat THEN NEXT.

        FIND FIRST tabla WHERE tabla.tt-codmat = facdpedi.codmat NO-ERROR.
        IF NOT AVAIL tabla THEN DO:
            CREATE tabla.
            ASSIGN 
                tabla.tt-codmat = facdpedi.codmat
                tabla.tt-desmat = almmmatg.desmat
                tabla.tt-desmar = almmmatg.desmar
                tabla.tt-unidad = almmmatg.undbas
                tabla.tt-factor = almmmatg.facequ.
        END.
        
        /*Factor de Conversion*/
        FIND Almtconv WHERE Almtconv.CodUnid  = tabla.tt-unidad
            AND Almtconv.Codalter = facdpedi.UndVta NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            IF tabla.tt-factor <> 0 THEN F-FACTOR = Almtconv.Equival / tabla.tt-factor.
        END.        

        /*Factor de Conversion*/
        FIND Almtconv WHERE Almtconv.CodUnid  = almmmatg.undbas
            AND Almtconv.Codalter = CcbdDocu.UndVta NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
        END.

        /*Revisando provincias*/
        CASE FacCPedi.CodDiv:
            WHEN "00000" THEN DO:
                IF LOOKUP(TRIM(FacCPedi.codven),"015,901,179,902") > 0 THEN DO:                    
                    ASSIGN tabla.tt-canped[2] = (FacDPedi.CanPed * f-factor) + tabla.tt-canped[2]. NEXT.
                END.
                IF FacCPedi.codven = "151" THEN DO:
                    ASSIGN tabla.tt-canped[3] = (FacDPedi.CanPed * f-factor) + tabla.tt-canped[3]. NEXT.
                END.
                ELSE DO:                    
                    ASSIGN tabla.tt-canped[5] = (FacDPedi.CanPed * f-factor) + tabla.tt-canped[5]. NEXT.
                END.    
            END.
            WHEN "00001" OR WHEN "00002" OR WHEN "00003" OR WHEN "00014" THEN DO:
                ASSIGN tabla.tt-canped[1] = (FacDPedi.CanPed * f-factor) + tabla.tt-canped[1]. NEXT. 
            END.
            WHEN "00015" THEN DO:
                ASSIGN tabla.tt-canped[4] = (FacDPedi.CanPed * f-factor) + tabla.tt-canped[4]. NEXT.            
            END.
            OTHERWISE DO:                
                ASSIGN tabla.tt-canped[5] = (FacDPedi.CanPed * f-factor) + tabla.tt-canped[5]. NEXT.
            END.
        END CASE.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Stock W-Win 
PROCEDURE Carga-Stock :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tabla NO-LOCK BREAK BY tt-codmat:
        FOR EACH almmmate USE-INDEX mate03
            WHERE almmmate.codcia = s-codcia
            AND almmmate.codmat = tt-codmat NO-LOCK:
            ASSIGN
                tt-stock = tt-stock + almmmate.StkAct.
        END.            
    END.
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
  DISPLAY F-CodFam F-SubFam f-codmat dDesde dHasta dDesde-2 dHasta-2 txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-CodFam BUTTON-6 F-SubFam BUTTON-7 f-codmat dDesde dHasta dDesde-2 
         dHasta-2 BUTTON-1 BUTTON-2 RECT-1 RECT-57 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A3: U3"):FONT:Bold = TRUE.
chWorkSheet:Range("A3"):VALUE = "Código.".
chWorkSheet:Range("B3"):VALUE = "Descripción".
chWorkSheet:Range("C3"):VALUE = "Marca".
chWorkSheet:Range("D3"):VALUE = "Unidad".
chWorkSheet:Range("E3"):VALUE = "Proyeccion Venta".
chWorkSheet:Range("F3"):VALUE = "Producido a la Fecha".
chWorkSheet:Range("G3"):VALUE = "Stock".
chWorkSheet:Range("H3"):VALUE = "Despachado(Lima)".
/*
chWorkSheet:Range("I3"):VALUE = "Saldo x Atender(Lima)".
*/
chWorkSheet:Range("I3"):VALUE = "Cotizado(Provincia)".
chWorkSheet:Range("J3"):VALUE = "Pedidos(Provincia)".
chWorkSheet:Range("K3"):VALUE = "Despachado(Provincias)".
chWorkSheet:Range("L3"):VALUE = "Saldo x Atender(Provincias)".
chWorkSheet:Range("M3"):VALUE = "Cotizado(Supermercados)".
chWorkSheet:Range("N3"):VALUE = "Pedidos(Supermercados)".
chWorkSheet:Range("O3"):VALUE = "Despacho(Supermercados)".
chWorkSheet:Range("P3"):VALUE = "Saldo x Atender(Supermercados)".
chWorkSheet:Range("Q3"):VALUE = "Cotizado(Expolibreria)".
chWorkSheet:Range("R3"):VALUE = "Pedidos(Expolibreria)".
chWorkSheet:Range("S3"):VALUE = "Despacho(Expolibreria)".
chWorkSheet:Range("T3"):VALUE = "Saldo x Atender(Expolibreria)".
chWorkSheet:Range("U3"):VALUE = "Despacho(Otros)".
/*
chWorkSheet:Range("T3"):VALUE = "Saldo x Atender(Otros)".
*/

chWorkSheet:COLUMNS("A"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

RUN Carga-Data2.

loopREP:
FOR EACH tabla NO-LOCK BREAK BY tt-codmat:

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-desmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-desmar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-unidad.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = 0.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = 0.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-stock.

    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-candes[1].
    /*
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-candif[1].
    */
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cancot[2].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-canped[2].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-candes[2].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-cancot[2] - tt-canped[2]).


    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cancot[3].
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-canped[3].
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-candes[3].
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-cancot[3] - tt-canped[3]).

    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-cancot[4].
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-canped[4].
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-candes[4].
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = (tt-cancot[4] - tt-canped[4]).


    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-candes[5].
    /*
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-candif[5].
    */
END.


/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
        ASSIGN 
            dDesde = DATE(TODAY - day(TODAY) + 1)
            dDesde-2 = DATE(TODAY - day(TODAY) + 1)
            dHasta = TODAY
            dHasta-2 = TODAY.

    END.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE New W-Win 
PROCEDURE New :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA
    AND  Almmmatg.codfam BEGINS F-CodFam
    AND  Almmmatg.subfam BEGINS F-Subfam
    AND  Almmmatg.codmat BEGINS f-Codmat USE-INDEX matg09:

    FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA:
        FOR EACH EvtAll01 NO-LOCK WHERE EvtAll01.CodCia = S-CODCIA
            AND EvtAll01.CodDiv = Gn-Divi.Coddiv
            AND EvtAll01.Codmat = Almmmatg.codmat
            AND (EvtAll01.Nrofch >= INTEGER(STRING(YEAR(dDesde),"9999") + STRING(MONTH(dDesde),"99"))
            AND EvtAll01.Nrofch <= INTEGER(STRING(YEAR(dHasta),"9999") + STRING(MONTH(dHasta),"99")) ):


            DO i = 1 TO 31:
                IF dDesde <= DATE(STRING(I,"99") + "/" + STRING(EvtAll01.Codmes,"99") + "/" + STRING(EvtAll01.Codano,"9999")) AND
                   dHasta >= DATE(STRING(I,"99") + "/" + STRING(EvtAll01.Codmes,"99") + "/" + STRING(EvtAll01.Codano,"9999")) THEN DO:
                    CASE faccpedi.coddiv:
                        WHEN "00000" THEN DO:
                            IF LOOKUP(TRIM(faccpedi.codven),"015,901,179,902") > 0 THEN DO:                    
                                ASSIGN 
                                    tabla.tt-totped[2] = tabla.tt-totped[2] + 1
                                    tabla.tt-canate[2] = tabla.tt-canate[2] + 
                                    tabla.tt-candif[2] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[2].
                                NEXT.
                            END.
                            IF faccpedi.codven = "151" THEN DO:
                                ASSIGN 
                                    tabla.tt-totped[3] = tabla.tt-totped[3] + 1
                                    tabla.tt-canate[3] = facdpedi.canate + tabla.tt-canate[3]
                                    tabla.tt-candif[3] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[3].
                                NEXT.
                            END.
                            ELSE DO:                    
                                ASSIGN 
                                    tabla.tt-totped[5] = tabla.tt-totped[5] + 1
                                    tabla.tt-canate[5] = facdpedi.canate + tabla.tt-canate[5]
                                    tabla.tt-candif[5] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[5].
                                NEXT.
                            END.    
                        END.
                        WHEN "00001" OR WHEN "00002" OR WHEN "00003" OR WHEN "00014" THEN DO:
                            ASSIGN 
                                tabla.tt-totped[1] = tabla.tt-totped[1] + 1
                                tabla.tt-canate[1] = facdpedi.canate + tabla.tt-canate[1]
                                tabla.tt-candif[1] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[1].
                            NEXT.
                        END.
                        WHEN "00015" THEN DO:
                            ASSIGN 
                                tabla.tt-totped[4] = tabla.tt-totped[4] + 1
                                tabla.tt-canate[4] = facdpedi.canate + tabla.tt-canate[4]
                                tabla.tt-candif[4] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[4].
                            NEXT.
                        END.
                        OTHERWISE DO:                
                            ASSIGN 
                                tabla.tt-totped[5] = tabla.tt-totped[5] + 1
                                tabla.tt-canate[5] = facdpedi.canate + tabla.tt-canate[5]
                                tabla.tt-candif[5] = (facdpedi.canped - facdpedi.canate) + tabla.tt-candif[5].    
                            NEXT.
                        END.
                    END CASE.
                END.
            END.

            
            /*****************Capturando el Mes siguiente *******************/
            IF EvtAll01.Codmes < 12 THEN DO:
                ASSIGN
                    X-CODMES = EvtAll01.Codmes + 1
                    X-CODANO = EvtAll01.Codano .
                END.
            ELSE DO: 
                ASSIGN
                    X-CODMES = 01
                    X-CODANO = EvtAll01.Codano + 1 .
            END.
            /**********************************************************************/

            /*********************** Calculo Para Obtener los datos diarios ************/
            DO I = 1 TO DAY( DATE(STRING(X-CODDIA,"99") + "/" + STRING(X-CODMES,"99") + "/" + STRING(X-CODANO,"9999")) - 1 ) :        
                X-FECHA = DATE(STRING(I,"99") + "/" + STRING(EvtAll01.Codmes,"99") + "/" + STRING(EvtAll01.Codano,"9999")).

                IF X-FECHA >= dDesde AND X-FECHA <= dHasta THEN DO:
                    /*Revisando provincias*/





            END.
       END.   */  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCantidades W-Win 
FUNCTION fCantidades RETURNS DECIMAL
  ( INPUT Parm1 AS CHAR, INPUT Parm2 AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE f-factor    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dCantidades AS DECIMAL     NO-UNDO.

    FOR EACH FacCPedi WHERE FacCPedi.CodCia = s-codcia
        AND FacCPedi.CodDoc = "PED"        
        AND FacCPedi.NroRef = Parm1
        AND FacCPedi.FlgEst <> "A" NO-LOCK,
        EACH FacDPedi OF FacCPedi NO-LOCK
        WHERE FacDPedi.CodMat = Parm2:
        
        /*Factor de Conversion*/
        FIND FIRST Almmmatg WHERE Almmmatg.codcia = faccpedi.codcia
            AND almmmatg.codmat = facdpedi.codmat NO-LOCK NO-ERROR.
        
        FIND Almtconv WHERE Almtconv.CodUnid  = tabla.tt-unidad
            AND Almtconv.Codalter = facdpedi.UndVta NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            IF almmmatg.facequ <> 0 THEN F-FACTOR = Almtconv.Equival / almmmatg.facequ.
        END.        
        dCantidades = dCantidades + (FacDPedi.CanPed * f-factor).
    END.

    RETURN dCantidades.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

