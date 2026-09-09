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

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.

DEFINE TEMP-TABLE tmp-tempo NO-UNDO
    FIELD t-codpro  LIKE Almmmatg.Codpr1
    FIELD t-nompro  LIKE Gn-Prov.Nompro 
    FIELD t-codalm  LIKE FacCpedi.Codalm
    FIELD t-codcli  LIKE FacCpedi.Codcli
    FIELD t-nomcli  LIKE FacCpedi.Nomcli
    FIELD t-codmat  LIKE FacDpedi.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-codubi  LIKE Almmmate.CodUbi    FORMAT "X(6)"
    FIELD t-nroped  LIKE FacCPedi.NroPed
    FIELD t-fchped  LIKE FacCPedi.FchPed
    FIELD t-glosa   AS CHAR          FORMAT "X(30)"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-solici  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-atendi  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-pendie  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-totsol  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-totdol  AS DEC           FORMAT "->>>>,>>9.99".

DEFINE BUFFER b-tempo FOR tmp-tempo.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

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
&Scoped-Define ENABLED-OBJECTS f-clien R-Tipo f-desde f-hasta x-CodVen ~
BUTTON-1 BtnDone BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 f-clien f-nomcli R-Tipo f-desde ~
f-hasta x-CodVen f-nomven f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .69 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE x-CodVen AS CHARACTER FORMAT "x(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69 NO-UNDO.

DEFINE VARIABLE R-Tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cliente", 1,
"Resumen Proveedor", 2,
"Ubicacion", 3
     SIZE 17.72 BY 1.73 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-3 AT ROW 1.27 COL 4.86 WIDGET-ID 12
     f-clien AT ROW 2.08 COL 9 COLON-ALIGNED WIDGET-ID 4
     f-nomcli AT ROW 2.08 COL 21.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     R-Tipo AT ROW 2.88 COL 11 NO-LABEL WIDGET-ID 14
     f-desde AT ROW 4.77 COL 9 COLON-ALIGNED WIDGET-ID 6
     f-hasta AT ROW 4.77 COL 25.57 COLON-ALIGNED WIDGET-ID 8
     x-CodVen AT ROW 5.58 COL 9 COLON-ALIGNED WIDGET-ID 20
     f-nomven AT ROW 5.58 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     f-Mensaje AT ROW 6.65 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     BUTTON-1 AT ROW 8.54 COL 4 WIDGET-ID 24
     BtnDone AT ROW 8.54 COL 20 WIDGET-ID 30
     BUTTON-3 AT ROW 8.54 COL 36 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 10.35
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
         TITLE              = "COTIZACIONES POR ATENDER OFICINA"
         HEIGHT             = 10.35
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* COTIZACIONES POR ATENDER OFICINA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* COTIZACIONES POR ATENDER OFICINA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN f-Desde f-hasta f-clien R-tipo x-codven.

    IF f-desde = ? then do:
       MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.   
    END.

    IF f-hasta = ? then do:
       MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-hasta.
       RETURN NO-APPLY.   
    END.   

    IF f-desde > f-hasta then do:
       MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.
    END.


    IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
  
    /*RUN Imprimir.*/
    RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN f-Desde f-hasta f-clien R-tipo x-codven.

    IF f-desde = ? then do:
       MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.   
    END.

    IF f-hasta = ? then do:
       MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-hasta.
       RETURN NO-APPLY.   
    END.   

    IF f-desde > f-hasta then do:
       MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
       APPLY "ENTRY":U to f-desde.
       RETURN NO-APPLY.
    END.


    IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
    RUN Excel. /*RUN Imprime.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien W-Win
ON LEAVE OF f-clien IN FRAME F-Main /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  

EMPTY TEMP-TABLE TMP-TEMPO.

FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.coddiv = s-coddiv
        AND Faccpedi.coddoc = "COT"
        AND Faccpedi.flgest = "P"
        AND Faccpedi.fchped >= f-Desde
        AND Faccpedi.fchped <= f-Hasta:
    IF f-Clien > "" AND Faccpedi.codcli <> f-Clien THEN NEXT.
    IF x-CodVen > "" AND Faccpedi.codven <> x-CodVen THEN NEXT.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
            FIRST Almmmatg OF Facdpedi NO-LOCK:
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Faccpedi.coddoc + ' ' + Faccpedi.nroped + ' ' + STRING(Faccpedi.fchped).
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = FacDpedi.UndVta
            NO-LOCK NO-ERROR.
        F-FACTOR  = 1. 
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
        END.
        FIND Tmp-tempo WHERE Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
            AND Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Tmp-Tempo THEN DO: 
            CREATE Tmp-Tempo.  
            ASSIGN   
                Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                Tmp-Tempo.t-DesMat = Almmmatg.DesMat
                Tmp-Tempo.t-DesMar = Almmmatg.DesMar
                Tmp-Tempo.t-UndBas = Almmmatg.UndBas. 
        END.  
        ASSIGN
            Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + SUBSTRING(STRING(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'
            Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR
            Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR
            Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
        IF FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
        IF FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
    END.
END.

/*
FOR EACH FacCpedi NO-LOCK WHERE
        FacCpedi.CodCia = S-CODCIA AND
        FacCpedi.CodDiv = S-CODDIV AND
        FacCpedi.CodDoc = "COT"    AND
        FacCpedi.FlgEst = "P"      AND
        FacCpedi.FchPed >= F-desde AND
        FacCpedi.FchPed <= F-hasta AND 
        FacCpedi.Codcli BEGINS f-clien AND
        FacCpedi.CodVen BEGINS x-CodVen,
        EACH FacDpedi OF FacCpedi NO-LOCK WHERE (CanPed - CanAte) > 0,
        FIRST Almmmatg OF Facdpedi NO-LOCK:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Faccpedi.coddoc + ' ' + Faccpedi.nroped + ' ' + STRING(Faccpedi.fchped).
     FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
         AND Almtconv.Codalter = FacDpedi.UndVta
         NO-LOCK NO-ERROR.
     F-FACTOR  = 1. 
     IF AVAILABLE Almtconv THEN DO:
         F-FACTOR = Almtconv.Equival.
         IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
     END.
     FIND Tmp-tempo WHERE Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
         AND Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
         NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Tmp-Tempo THEN DO: 
         CREATE Tmp-Tempo.  
         ASSIGN   
             Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
             Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
             Tmp-Tempo.t-Codmat = FacdPedi.Codmat
             Tmp-Tempo.t-DesMat = Almmmatg.DesMat
             Tmp-Tempo.t-DesMar = Almmmatg.DesMar
             Tmp-Tempo.t-UndBas = Almmmatg.UndBas. 
     END.  
     ASSIGN
         Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + SUBSTRING(STRING(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'
         Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR
         Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR
         Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
     IF FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
     IF FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Proveedor W-Win 
PROCEDURE Carga-Temporal-Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  
 DEFINE VAR x-nompro AS CHAR.
 
FOR EACH TMP-TEMPO:
    DELETE tmp-tempo.
END.


FOR EACH FacCpedi NO-LOCK WHERE
          FacCpedi.CodCia = S-CODCIA AND
          FacCpedi.CodDiv = S-CODDIV AND
          FacCpedi.CodDoc = "COT"    AND
          FacCpedi.FlgEst = "P"      AND
          FacCpedi.FchPed >= F-desde AND
          FacCpedi.FchPed <= F-hasta AND 
          FacCpedi.Codcli BEGINS f-clien AND
          FacCpedi.CodVen BEGINS x-CodVen,
   EACH FacDpedi OF FacCpedi NO-LOCK  WHERE (CanPed - CanAte) > 0:
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Faccpedi.coddoc + ' ' + Faccpedi.nroped + ' ' + STRING(Faccpedi.fchped).

     IF CANPED - CANATE = 0 THEN NEXT.
     
     FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
                         Almmmatg.CodmAT = FacDpedi.CodMat
                         NO-LOCK NO-ERROR. 

     FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                         Almtconv.Codalter = FacDpedi.UndVta
                         NO-LOCK NO-ERROR.
  
      F-FACTOR  = 1. 
          
      IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
        IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
      END.
      
      FIND Tmp-tempo WHERE Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
                           NO-LOCK NO-ERROR.
                           
      IF NOT AVAILABLE Tmp-Tempo THEN DO: 
         FIND Gn-Prov WHERE Gn-Prov.Codcia = pv-codcia AND
                            Gn-Prov.Codpro = Almmmatg.Codpr1
                            NO-LOCK NO-ERROR.
         x-nompro = "".                   
         IF AVAILABLE Gn-Prov THEN x-nompro = Gn-prov.NomPro.                   
         CREATE Tmp-Tempo.  /*Faccpedi.CodAlm*/
         ASSIGN   /*Tmp-Tempo.t-CodAlm = cbo-alm*/
                  Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                  Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                  Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                  Tmp-Tempo.t-DesMat = Almmmatg.DesMat
                  Tmp-Tempo.t-DesMar = Almmmatg.DesMar
                  Tmp-Tempo.t-UndBas = Almmmatg.UndBas
                  Tmp-Tempo.t-Codpro = Almmmatg.Codpr1 
                  Tmp-Tempo.t-Nompro = x-nompro.

       END.  
         Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + substring(string(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'.
         Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
         Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.
         Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
         If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
         If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).

 END.

FOR EACH Tmp-Tempo:
     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     
     IF AVAILABLE Almmmate THEN DO:
        IF Almmmate.stkact >= tmp-tempo.t-pendie THEN DELETE Tmp-Tempo.
     End.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Ubicacion W-Win 
PROCEDURE Carga-Temporal-Ubicacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
  DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  

  FOR EACH TMP-TEMPO:
    DELETE tmp-tempo.
  END.

  FOR EACH FacCpedi NO-LOCK WHERE
          FacCpedi.CodCia = S-CODCIA AND
          FacCpedi.CodDiv = S-CODDIV AND
          FacCpedi.CodDoc = "COT"    AND
          FacCpedi.FlgEst = "P"      AND
          FacCpedi.FchPed >= F-desde AND
          FacCpedi.FchPed <= F-hasta AND 
          FacCpedi.Codcli BEGINS f-clien AND
          FacCpedi.CodVen BEGINS x-CodVen,
        EACH FacDpedi OF FacCpedi NO-LOCK  WHERE (CanPed - CanAte) > 0:
    IF CANPED - CANATE = 0 THEN NEXT.
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Faccpedi.coddoc + ' ' + Faccpedi.nroped + ' ' + STRING(Faccpedi.fchped).
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.CodMat = FacDpedi.CodMat
        NO-LOCK NO-ERROR. 
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.codalm = FacDPedi.AlmDes
        AND Almmmate.CodMat = FacDpedi.CodMat
        NO-LOCK NO-ERROR.
    F-FACTOR  = 1. 
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = FacDpedi.UndVta
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
        IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    END.
    CREATE Tmp-Tempo.
    ASSIGN   /*Faccpedi.CodAlm*/
        /*Tmp-Tempo.t-CodAlm = cbo-alm*/
        Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
        Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
        Tmp-Tempo.t-Codmat = FacdPedi.Codmat
        Tmp-Tempo.t-DesMat = Almmmatg.DesMat
        Tmp-Tempo.t-DesMar = Almmmatg.DesMar
        Tmp-Tempo.t-UndBas = Almmmatg.UndBas
        Tmp-Tempo.t-CodUbi = Almmmate.CodUbi
        Tmp-Tempo.t-NroPed = FacCPedi.NroPed
        Tmp-Tempo.t-FchPed = FacCPedi.FchPed
        Tmp-Tempo.t-atendi = FacdPedi.Canate * F-FACTOR
        Tmp-Tempo.t-pendie = (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
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
  DISPLAY FILL-IN-3 f-clien f-nomcli R-Tipo f-desde f-hasta x-CodVen f-nomven 
          f-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE f-clien R-Tipo f-desde f-hasta x-CodVen BUTTON-1 BtnDone BUTTON-3 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.
DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
DEFINE VAR X-STOCK     AS DECIMAL INIT 0. 
DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 14.
chWorkSheet:COLUMNS("B"):ColumnWidth = 40.
chWorkSheet:COLUMNS("C"):ColumnWidth = 7.
chWorkSheet:COLUMNS("D"):ColumnWidth = 30.
chWorkSheet:COLUMNS("E"):ColumnWidth = 10.
chWorkSheet:COLUMNS("F"):ColumnWidth = 10.
chWorkSheet:COLUMNS("G"):ColumnWidth = 10.
chWorkSheet:COLUMNS("H"):ColumnWidth = 5.
chWorkSheet:COLUMNS("I"):ColumnWidth = 12.
chWorkSheet:COLUMNS("J"):ColumnWidth = 12.
chWorkSheet:COLUMNS("K"):ColumnWidth = 12.

chWorkSheet:Range("A1: M2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "COTIZACIONES POR ATENDER OFICINA" +
    " DESDE " + STRING(f-desde) + " AL " + STRING(f-hasta).
chWorkSheet:Range("A2"):VALUE = "Código Cliente".
chWorkSheet:Range("B2"):VALUE = "Nombre Cliente".
chWorkSheet:Range("C2"):VALUE = "Código".
chWorkSheet:Range("D2"):VALUE = "Descripción".
chWorkSheet:Range("E2"):VALUE = "Marca".
chWorkSheet:Range("F2"):VALUE = "Fecha".
chWorkSheet:Range("G2"):VALUE = "Cotizaciones".
chWorkSheet:Range("H2"):VALUE = "U.M.".
chWorkSheet:Range("I2"):VALUE = "Stock".
chWorkSheet:Range("J2"):VALUE = "Solicitado".
chWorkSheet:Range("K2"):VALUE = "Pediente".
chWorkSheet:Range("L2"):VALUE = "Pendiente S/.".
chWorkSheet:Range("M2"):VALUE = "Pendiente US$".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
chWorkSheet:COLUMNS("I"):NumberFormat = "@".
chWorkSheet:COLUMNS("J"):NumberFormat = "@".
chWorkSheet:COLUMNS("K"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Temporal.
loopREP:
FOR EACH Tmp-Tempo:
     t-column = t-column + 1.
     cColumn = STRING(t-Column).      
     cRange = "A" + cColumn.   
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-CodCli.                      
     cRange = "B" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-NomCli.                      
     cRange = "C" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-codmat.   
     cRange = "D" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmat.                      
     cRange = "E" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmar. 
     cRange = "F" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-fchped. 
     cRange = "G" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-nroped.
     cRange = "H" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-UndBas.
     cRange = "I" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = X-Stock.
     cRange = "J" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-solici.
     cRange = "K" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = tmp-tempo.t-pendie.
     cRange = "L" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = Tmp-tempo.t-totsol.
     cRange = "M" + cColumn.                                                
     chWorkSheet:Range(cRange):Value = Tmp-tempo.t-totdol.
END.
SESSION:SET-WAIT-STATE('').

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.


/*
FOR EACH TMP-TEMPO:
    DELETE tmp-tempo.
END.

loopREP:

FOR EACH FacCpedi NO-LOCK WHERE
          FacCpedi.CodCia = S-CODCIA AND
          FacCpedi.CodDiv = S-CODDIV AND
          FacCpedi.CodDoc = "COT"    AND
          FacCpedi.FlgEst = "P"      AND
          FacCpedi.FchPed >= F-desde AND
          FacCpedi.FchPed <= F-hasta AND 
          FacCpedi.Codcli BEGINS f-clien AND
          FacCpedi.CodVen BEGINS x-CodVen,
     EACH FacDpedi OF FacCpedi NO-LOCK  WHERE (CanPed - CanAte) > 0:
          IF CANPED - CANATE = 0 THEN NEXT.
          f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Faccpedi.coddoc + ' ' + Faccpedi.nroped + ' ' + STRING(Faccpedi.fchped).
          FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
                              Almmmatg.CodmAT = FacDpedi.CodMat
                              NO-LOCK NO-ERROR. 
          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                              Almtconv.Codalter = FacDpedi.UndVta
                              NO-LOCK NO-ERROR.
           F-FACTOR  = 1. 
           IF AVAILABLE Almtconv THEN DO:
             F-FACTOR = Almtconv.Equival.
             IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
           END.

           FIND Tmp-tempo WHERE Tmp-Tempo.t-Codcli = Faccpedi.Codcli AND
                                Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
                                NO-LOCK NO-ERROR.
           IF NOT AVAILABLE Tmp-Tempo THEN DO: 
              CREATE Tmp-Tempo.  /*Faccpedi.CodAlm*/
              ASSIGN   /*Tmp-Tempo.t-CodAlm = cbo-alm*/
                       Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                       Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                       Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                       Tmp-Tempo.t-DesMat = Almmmatg.DesMat
                       Tmp-Tempo.t-DesMar = Almmmatg.DesMar
                       Tmp-Tempo.t-UndBas = Almmmatg.UndBas. 
            END.  
              Tmp-Tempo.t-fchped = FaccPedi.FchPed.
              Tmp-Tempo.t-nroped = FaccPedi.Nroped.
              Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
              Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.
              Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
              If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
              If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).

                     t-column = t-column + 1.
                     cColumn = STRING(t-Column).      
                     cRange = "A" + cColumn.   
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-CodCli.                      
                     cRange = "B" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-NomCli.                      
                     cRange = "C" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-codmat.   
                     cRange = "D" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmat.                      
                     cRange = "E" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-Desmar. 
                     cRange = "F" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-fchped. 
                     cRange = "G" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-nroped.
                     cRange = "H" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-UndBas.
                     cRange = "I" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = X-Stock.
                     cRange = "J" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-solici.
                     cRange = "K" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = tmp-tempo.t-pendie.
                     cRange = "L" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = Tmp-tempo.t-totsol.
                     cRange = "M" + cColumn.                                                
                     chWorkSheet:Range(cRange):Value = Tmp-tempo.t-totdol.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    CASE R-tipo:
        WHEN 1 THEN RUN CARGA-TEMPORAL.
        WHEN 2 THEN RUN CARGA-TEMPORAL-PROVEEDOR.
        WHEN 3 THEN RUN Carga-temporal-ubicacion.
    END.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.        
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3}.
        CASE R-Tipo:
            WHEN 1 THEN RUN Prn-ofi.
            WHEN 2 THEN RUN Proveedor.
            WHEN 3 THEN RUN Prn-Ubicacion.
        END CASE.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
/*********
  DEF VAR cCopias AS INT NO-UNDO.
  
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  CASE R-tipo:
    WHEN 1 THEN RUN CARGA-TEMPORAL.
    WHEN 2 THEN RUN CARGA-TEMPORAL-PROVEEDOR.
    WHEN 3 THEN RUN Carga-temporal-ubicacion.
  END.

  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").

  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY +
     STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.

  DO cCopias = 1 TO s-Nro-Copias:
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
    CASE R-Tipo:
        WHEN 1 THEN RUN Prn-ofi.
        WHEN 2 THEN RUN Proveedor.
        WHEN 3 THEN RUN Prn-Ubicacion.
    END CASE.
    PAGE STREAM REPORT.
    OUTPUT STREAM REPORT CLOSE.
  END.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
  END CASE. 
******/

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
  ASSIGN FILL-IN-3 = S-CODDIV
         F-DESDE   = TODAY
         F-HASTA   = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prn-ofi W-Win 
PROCEDURE Prn-ofi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
 /*RUN CARGA-TEMPORAL.*/
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat                          
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(23)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT "->>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        HEADER
        S-NOMCIA FORMAT "X(45)" SKIP
        "( " + S-CODDIV + ")" AT 1 FORMAT "X(15)"
        "COTIZACIONES POR ATENDER OFICINA"  AT 43 
        "Pag.  : " AT 110 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Desde : " AT 50 STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") FORMAT "X(12)"
        "Fecha : " AT 110 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 110 STRING(TIME,"HH:MM") SKIP
        "----------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                               C    A    N    T    I    D    A    D   " SKIP
        " Codigos      Descripcion              Marca          Pedidos                  U.M.    Stock   Solicitado  Pendiente  " SKIP
        "----------------------------------------------------------------------------------------------------------------------" SKIP
/*                1         2         3         4         5         6         7         8         9        10        11        12        13                      
         1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123456 12345678901234567890123456789012345 1234567890 12345678901234567890123 1234 ->>>,>>9.99 ->>>,>>9.99 ->>>,>>9.99
*/
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
/*PUT STREAM REPORT CONTROL {&Prn0} + {&Prn4} + {&Prn5A}  CHR(66). */
FOR EACH TMP-TEMPO BREAK BY tmp-tempo.t-codcli BY tmp-tempo.t-codmat:
     /*{&new-page}.*/
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
     IF FIRST-OF(tmp-tempo.t-Codcli) THEN DO:
       PUT STREAM REPORT "CLIENTE  : "  tmp-tempo.t-Codcli  "  " tmp-tempo.t-NomCli SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.
/**/
     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm  AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     IF AVAILABLE Almmmate THEN X-STOCK = Almmmate.StkAct.
     ACCUM  t-totsol  (SUB-TOTAL BY t-codcli) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codcli) .
     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-pendie
        WITH FRAME F-Cab.
        
     IF LAST-OF(tmp-tempo.t-Codcli) THEN DO:
       PUT STREAM REPORT ' ' SKIP.
       PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codcli t-totsol) AT 60 .
       PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codcli t-totdol) AT 110  SKIP.
     END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prn-Ubicacion W-Win 
PROCEDURE Prn-Ubicacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR x-Pendie AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 
/* RUN carga-temporal-ubicacion.*/
 
 DEFINE FRAME f-cab
        tmp-tempo.t-nroped
        tmp-tempo.t-codcli
        tmp-tempo.t-nomcli
        tmp-tempo.t-fchped
        tmp-tempo.t-undbas
        tmp-tempo.t-pendie
        HEADER
        S-NOMCIA FORMAT "X(45)" SKIP
        "( " + S-CODDIV + ")" AT 1 FORMAT "X(15)"
        "COTIZACIONES POR ATENDER OFICINA"  AT 30 
        "Pag.  : " AT 72 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Desde : " AT 20 STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") FORMAT "X(12)"
        "Fecha : " AT 75 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 50 FORMAT "X(20)" "Hora  : " AT 89 STRING(TIME,"HH:MM:SS") SKIP
        "------------------------------------------------------------------------------------------------------" SKIP
        "Nº Pedido Cliente     Nombre o Razon Social                            F. Pedido  Und.Base  Pendiente "  SKIP
        "------------------------------------------------------------------------------------------------------" SKIP
/*
        0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123123456 12345678901 123456789012345678901234567890123456789012345 99/99/9999 123456 ->>>>,>>9.99
*/
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
/*     PUT STREAM REPORT CONTROL {&Prn0} + {&Prn4} + {&Prn5A} + CHR(66). */

FOR EACH TMP-TEMPO BREAK BY tmp-tempo.t-codubi BY tmp-tempo.t-codmat:
        DISPLAY STREAM REPORT WITH FRAME F-CAB.
        IF FIRST-OF(tmp-tempo.t-CodUbi) OR FIRST-OF(tmp-tempo.t-CodMat)
        THEN DO:
            /* Calculamos totales */
            x-Pendie = 0.
            FOR EACH b-tempo WHERE b-tempo.t-codubi = tmp-tempo.t-codubi
                    AND b-tempo.t-codmat = tmp-tempo.t-codmat:
                x-Pendie = x-Pendie + b-tempo.t-pendie.
            END.
            PUT STREAM REPORT "UBICACION: " tmp-tempo.t-codubi " " tmp-tempo.t-codmat " " tmp-tempo.t-desmat 
                x-Pendie AT 90 SKIP.
            PUT STREAM REPORT '----------------------------------------------------' SKIP.
        END.
        DISPLAY STREAM REPORT 
           tmp-tempo.t-nroped
           tmp-tempo.t-codcli
           tmp-tempo.t-nomcli
           tmp-tempo.t-fchped
           tmp-tempo.t-UndBas
           tmp-tempo.t-pendie
           WITH FRAME F-Cab.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proveedor W-Win 
PROCEDURE Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
/* RUN CARGA-TEMPORAL-PROVE.*/
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(30)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT "->>>,>>9.99"
        tmp-tempo.t-atendi FORMAT "->>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        HEADER
        S-NOMCIA FORMAT "X(45)" SKIP
        "( " + S-CODDIV + ")" AT 1 FORMAT "X(15)"
        "COIZACIONES POR ATENDER OFICINA"  AT 43 FORMAT "X(35)"
        "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") FORMAT "X(12)"
        "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                 C    A    N    T    I    D    A    D   " SKIP
        " Codigos      Descripcion              Marca          Pedidos                         U.M.    Stock   Solicitado   Atendido  Pendiente  " 
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
/*     PUT STREAM REPORT CONTROL {&Prn0} + {&Prn4} + {&Prn5A} + CHR(66). */

FOR EACH TMP-TEMPO BREAK
                     BY tmp-tempo.t-codpro
                     BY tmp-tempo.t-codmat:

     DISPLAY STREAM REPORT WITH FRAME F-CAB.
    

     IF FIRST-OF(tmp-tempo.t-Codpro) THEN DO:
       PUT STREAM REPORT "PROVEEDOR  : "  tmp-tempo.t-Codpro  "  " tmp-tempo.t-Nompro SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.
     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-codpro) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codpro) .

     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-atendi
        tmp-tempo.t-pendie

        WITH FRAME F-Cab.
        
     IF LAST-OF(tmp-tempo.t-Codpro) THEN DO:
       PUT STREAM REPORT ' ' SKIP.
       PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codpro t-totsol) AT 60 .
       PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codpro t-totdol) AT 110  SKIP.

     END.
END.

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

