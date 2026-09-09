&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR VtaCDocu.
DEFINE TEMP-TABLE t-VtaDDocu NO-UNDO LIKE VtaDDocu.
DEFINE TEMP-TABLE tmpVtaDDocu NO-UNDO LIKE VtaDDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEF INPUT PARAMETER pRowid AS ROWID.        /* HPK */
DEF OUTPUT PARAMETER pOk AS LOG NO-UNDO.
DEF OUTPUT PARAMETER TABLE FOR t-Vtaddocu.

pOk = NO.

FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CDOCU THEN RETURN.

&SCOPED-DEFINE Condicion ~
( VtaDDocu.CodCia = B-CDOCU.codcia AND ~
  VtaDDocu.CodDiv = B-CDOCU.coddiv AND ~
  VtaDDocu.CodPed = B-CDOCU.codped AND ~
  VtaDDocu.NroPed = B-CDOCU.nroped )


/* 08/04/2025: Felix Perez, para hacer que el browse se muestre como la impresión de HPK
    hay que replicar las mismas condiciones del reporte 
*/
DEFINE TEMP-TABLE Reporte NO-UNDO
        FIELD Tipo      AS CHAR 
        FIELD CodDoc    LIKE FacCPedi.CodDoc
        FIELDS NroPed   LIKE FacCPedi.NroPed
        FIELD  CodRef    LIKE FacCPedi.CodRef
        FIELDS NroRef   LIKE FacCPedi.NroRef
        FIELDS CodAlm   LIKE Facdpedi.almdes
        FIELDS CodMat   LIKE FacDPedi.CodMat
        FIELDS DesMat   LIKE Almmmatg.DesMat
        FIELDS DesMar   LIKE Almmmatg.DesMar
        FIELDS UndBas   LIKE Almmmatg.UndBas
        FIELDS CanPed   LIKE FacDPedi.CanPed
        FIELDS CodUbi   LIKE Almmmate.CodUbi
        FIELDS CodZona  LIKE Almtubic.CodZona
        FIELDS X-TRANS  LIKE FacCPedi.Libre_c01
        FIELDS X-DIREC  LIKE FACCPEDI.Libre_c02
        FIELDS X-LUGAR  LIKE FACCPEDI.Libre_c03
        FIELDS X-CONTC  LIKE FACCPEDI.Libre_c04
        FIELDS X-HORA   LIKE FACCPEDI.Libre_c05
        FIELDS X-FECHA  LIKE FACCPEDI.Libre_f01
        FIELDS X-OBSER  LIKE FACCPEDI.Observa
        FIELDS X-Glosa  LIKE FACCPEDI.Glosa
        FIELDS X-codcli LIKE FACCPEDI.CodCli
        FIELDS X-NomCli LIKE FACCPEDI.NomCli
        FIELDS X-fchent LIKE faccpedi.fchent
        FIELDS X-peso   AS DEC INIT 0
        FIELDS x-empaques AS CHAR FORMAT 'x(25)'
        FIELDS x-corrrsector AS INT INIT 0
        FIELD Picador AS CHAR
        FIELD Mensaje AS CHAR FORMAT 'x(15)'
        FIELD Agencia AS LOG
        FIELD EmpaqEspec LIKE FacCPedi.EmpaqEspec
        /* 06/05/2024: C.Tenazoa Mostar ORIGEN: RIQRA HORIZONTAL */
        FIELD CodOrigen LIKE Faccpedi.CodOrigen
        FIELD NroOrigen LIKE Faccpedi.NroOrigen
        .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tmpVtaDDocu VtaDDocu Almmmatg Almmmate ~
almtubic

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 almtubic.CodZona Almmmate.CodUbi ~
VtaDDocu.CodMat VtaDDocu.CanPed Almmmatg.DesMat Almmmatg.DesMar ~
VtaDDocu.UndVta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tmpVtaDDocu NO-LOCK, ~
      FIRST VtaDDocu WHERE VtaDDocu.CodCia = tmpVtaDDocu.CodCia ~
  AND VtaDDocu.CodPed = tmpVtaDDocu.CodPed ~
  AND VtaDDocu.NroPed = tmpVtaDDocu.NroPed ~
  AND VtaDDocu.CodMat = tmpVtaDDocu.CodMat NO-LOCK, ~
      FIRST Almmmatg OF VtaDDocu NO-LOCK, ~
      FIRST Almmmate WHERE Almmmate.CodCia = VtaDDocu.CodCia ~
  AND Almmmate.CodAlm = VtaDDocu.AlmDes ~
  AND Almmmate.codmat = VtaDDocu.CodMat OUTER-JOIN NO-LOCK, ~
      FIRST almtubic OF Almmmate OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tmpVtaDDocu NO-LOCK, ~
      FIRST VtaDDocu WHERE VtaDDocu.CodCia = tmpVtaDDocu.CodCia ~
  AND VtaDDocu.CodPed = tmpVtaDDocu.CodPed ~
  AND VtaDDocu.NroPed = tmpVtaDDocu.NroPed ~
  AND VtaDDocu.CodMat = tmpVtaDDocu.CodMat NO-LOCK, ~
      FIRST Almmmatg OF VtaDDocu NO-LOCK, ~
      FIRST Almmmate WHERE Almmmate.CodCia = VtaDDocu.CodCia ~
  AND Almmmate.CodAlm = VtaDDocu.AlmDes ~
  AND Almmmate.codmat = VtaDDocu.CodMat OUTER-JOIN NO-LOCK, ~
      FIRST almtubic OF Almmmate OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tmpVtaDDocu VtaDDocu Almmmatg ~
Almmmate almtubic
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tmpVtaDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 VtaDDocu
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 Almmmatg
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE-2 Almmmate
&Scoped-define FIFTH-TABLE-IN-QUERY-BROWSE-2 almtubic


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tmpVtaDDocu
    FIELDS(), 
      VtaDDocu
    FIELDS(VtaDDocu.CodMat
      VtaDDocu.CanPed
      VtaDDocu.UndVta), 
      Almmmatg
    FIELDS(Almmmatg.DesMat
      Almmmatg.DesMar), 
      Almmmate
    FIELDS(Almmmate.CodUbi), 
      almtubic
    FIELDS(almtubic.CodZona) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      almtubic.CodZona COLUMN-LABEL "Zona" FORMAT "x(8)":U
      Almmmate.CodUbi FORMAT "x(10)":U
      VtaDDocu.CodMat COLUMN-LABEL "Artículo" FORMAT "X(6)":U WIDTH 8.43
      VtaDDocu.CanPed FORMAT "->>>,>>9.9999":U WIDTH 9
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 59.86
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 17.43
      VtaDDocu.UndVta FORMAT "x(10)":U WIDTH 4.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 127 BY 17.77
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-2 AT ROW 1 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 20.38 COL 2
     Btn_Cancel AT ROW 20.38 COL 18
     "Puede seleccionar más de un registro" VIEW-AS TEXT
          SIZE 62 BY 1.08 AT ROW 19.04 COL 2 WIDGET-ID 2
          BGCOLOR 0 FGCOLOR 15 FONT 8
     SPACE(66.71) SKIP(2.45)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE ""
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL VtaCDocu
      TABLE: t-VtaDDocu T "?" NO-UNDO INTEGRAL VtaDDocu
      TABLE: tmpVtaDDocu T "?" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 TEXT-1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tmpVtaDDocu,INTEGRAL.VtaDDocu WHERE Temp-Tables.tmpVtaDDocu ...,INTEGRAL.Almmmatg OF INTEGRAL.VtaDDocu,INTEGRAL.Almmmate WHERE INTEGRAL.VtaDDocu ...,INTEGRAL.almtubic OF INTEGRAL.Almmmate"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED, FIRST USED, FIRST USED, FIRST OUTER USED, FIRST OUTER USED"
     _JoinCode[2]      = "INTEGRAL.VtaDDocu.CodCia = Temp-Tables.tmpVtaDDocu.CodCia
  AND INTEGRAL.VtaDDocu.CodPed = Temp-Tables.tmpVtaDDocu.CodPed
  AND INTEGRAL.VtaDDocu.NroPed = Temp-Tables.tmpVtaDDocu.NroPed
  AND INTEGRAL.VtaDDocu.CodMat = Temp-Tables.tmpVtaDDocu.CodMat"
     _JoinCode[4]      = "INTEGRAL.Almmmate.CodCia = INTEGRAL.VtaDDocu.CodCia
  AND INTEGRAL.Almmmate.CodAlm = INTEGRAL.VtaDDocu.AlmDes
  AND INTEGRAL.Almmmate.codmat = INTEGRAL.VtaDDocu.CodMat"
     _FldNameList[1]   > INTEGRAL.almtubic.CodZona
"almtubic.CodZona" "Zona" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmate.CodUbi
"Almmmate.CodUbi" ? "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaDDocu.CodMat
"VtaDDocu.CodMat" "Artículo" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaDDocu.CanPed
"VtaDDocu.CanPed" ? ? "decimal" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "59.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaDDocu.UndVta
"VtaDDocu.UndVta" ? "x(10)" "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  pOk = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS <= 0 THEN DO:
      MESSAGE 'Debe seleccionar al menos un registro' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  EMPTY TEMP-TABLE t-Vtaddocu.
  DEF VAR k AS INTE NO-UNDO.
  DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
      IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
          CREATE t-Vtaddocu.
          BUFFER-COPY Vtaddocu TO t-Vtaddocu.
      END.
  END.
  pOk = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Reporte.
EMPTY TEMP-TABLE tmpVtaDDocu.

DEF VAR x-cantidad AS DECI NO-UNDO.
DEF VAR x-ubicacion AS CHAR NO-UNDO.
DEFINE VAR x-empaques AS CHAR NO-UNDO.

/* 1ro. el temporal base */
FOR EACH Vtaddocu NO-LOCK WHERE {&Condicion},
    FIRST Almmmatg OF Vtaddocu NO-LOCK:
    x-cantidad = VtaDDocu.CanPed * VtaDDocu.Factor.
    FIND Almmmate OF Almmmatg WHERE Almmmate.codalm = VtaDDocu.AlmDes NO-LOCK NO-ERROR.
    x-ubicacion = (IF AVAILABLE Almmmate THEN Almmmate.CodUbi ELSE VtaDDocu.CodUbi).

    CREATE Reporte.            
    ASSIGN 
        Reporte.Tipo   = B-CDOCU.CodTer
        Reporte.CodDoc = B-CDOCU.CodPed
        Reporte.NroPed = B-CDOCU.NroPed
        Reporte.CodRef = B-CDOCU.CodRef    /* O/D OTR */
        Reporte.NroRef = B-CDOCU.NroRef
        Reporte.CodMat = VtaDDocu.CodMat
        Reporte.DesMat = Almmmatg.DesMat
        Reporte.DesMar = Almmmatg.DesMar
        Reporte.UndBas = Almmmatg.UndBas
        Reporte.CanPed = x-cantidad
        Reporte.CodAlm = B-CDOCU.CodAlm
        Reporte.CodUbi = x-ubicacion
        Reporte.Agencia = (IF B-CDOCU.ZonaPickeo = "VA" THEN YES ELSE NO)
        Reporte.CodZona = "G-0"
        Reporte.x-peso = almmmatg.pesmat
        Reporte.x-empaque = x-empaques
        Reporte.Picador = B-CDOCU.UsrSac
        Reporte.EmpaqEspec = B-CDOCU.EmpaqEspec
        .
END.
/* 2do. el temporal final */
DEF VAR lNoItm AS INTE NO-UNDO.

FOR EACH Reporte NO-LOCK BY Reporte.NroPed BY Reporte.CodUbi:
    lNoItm = lNoItm + 1.
    CREATE tmpVtaDDocu.
    ASSIGN
        tmpVtaDDocu.CodCia = B-CDOCU.codcia
        tmpVtaDDocu.CodDiv = B-CDOCU.coddiv
        tmpVtaDDocu.CodPed = B-CDOCU.codped
        tmpVtaDDocu.NroPed = B-CDOCU.nroped
        tmpVtaDDocu.NroItm = lNoItm
        tmpVtaDDocu.CodMat = Reporte.codmat
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  ENABLE BROWSE-2 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tmpVtaDDocu"}
  {src/adm/template/snd-list.i "VtaDDocu"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "almtubic"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

