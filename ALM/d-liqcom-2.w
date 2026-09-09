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

DEFINE STREAM REPORT.

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE PTO        AS LOGICAL.
DEFINE        VARIABLE L-FIN      AS LOGICAL.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

/*** DEFINE VARIABLES SUB-TOTALES ***/

DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.

DEFINE VAR S-Procedencia AS CHAR FORMAT "X(55)" INIT "".
DEFINE VAR S-Moneda      AS CHAR FORMAT "X(32)"  INIT "".
DEFINE VAR S-Mon         AS CHAR FORMAT "X(4)"  INIT "".
DEFINE VAR S-Referencia1 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Referencia2 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Referencia3 AS CHAR FORMAT "X(16)" INIT "".
DEFINE VAR S-Encargado   AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-RUC         AS CHAR FORMAT "X(32)" INIT "".
DEFINE VAR S-Movimiento  LIKE Almtmovm.Desmov INIT "".
DEFINE VAR S-TOTAL       AS DECIMAL INIT 0.
DEFINE VAR S-SUBTO       AS DECIMAL INIT 0.
DEFINE VAR S-Item        AS INTEGER INIT 0.
DEFINE VAR W-VTA0        AS DECIMAL INIT 0.
DEFINE VAR W-VTA1        AS DECIMAL INIT 0.
DEFINE VAR W-VTA2        AS DECIMAL INIT 0.
DEFINE VAR X-COMPRA      AS INTEGER INIT 02.
DEFINE VAR C-TIPMOV      AS CHAR     INIT "I" .
DEFIN  VAR X-TIPO        AS DECI     INIT 0.
DEFINE VAR X-LIQ         AS CHAR     INIT "LIQ".
FIND Faccfggn WHERE Faccfggn.Codcia = S-CODCIA NO-LOCK NO-ERROR.

/*ML01*/ DEFINE VARIABLE lEsAgente AS LOGICAL NO-UNDO.
/*ML01*/ DEFINE VARIABLE dPorRetencion AS DECIMAL NO-UNDO.
/*ML01*/ DEFINE VARIABLE dMontoMinimo AS DECIMAL NO-UNDO.
/*ML01*/ DEFINE VARIABLE iNroSer AS INTEGER NO-UNDO.
/*ML01*/ DEFINE VARIABLE cCodDoc AS CHARACTER INITIAL "RET" NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS i-codmov c-nrodoc B-TOTAL c-imptot R-moneda ~
F-fecha R-compra F-factura Btn_OK BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 i-codmov N-MOVI c-nrodoc F-TOTAL ~
c-imptot R-moneda F-fecha R-compra F-factura 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-TOTAL  NO-CONVERT-3D-COLORS
     LABEL "Total" 
     SIZE 6 BY 1.

DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 17 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 17 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE i-codmov AS INTEGER FORMAT "99":U INITIAL 2 
     LABEL "Movimiento" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "02","17","06" 
     DROP-DOWN-LIST
     SIZE 5.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-imptot AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Importe Factura" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE c-nrodoc AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Ingreso" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE F-factura AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "Numero Factura" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE F-fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Factura" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE F-TOTAL AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE N-MOVI AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE R-compra AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pre-Compra", 1,
"Compra", 2
     SIZE 20 BY 1.88 NO-UNDO.

DEFINE VARIABLE R-moneda AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 20 BY 1.08 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-3 AT ROW 1.27 COL 12.57 WIDGET-ID 18
     i-codmov AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 20
     N-MOVI AT ROW 2.35 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     c-nrodoc AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 10
     B-TOTAL AT ROW 3.42 COL 41 WIDGET-ID 6
     F-TOTAL AT ROW 3.42 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     c-imptot AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 8
     R-moneda AT ROW 4.5 COL 41 NO-LABEL WIDGET-ID 28
     F-fecha AT ROW 5.58 COL 19 COLON-ALIGNED WIDGET-ID 14
     R-compra AT ROW 5.58 COL 41 NO-LABEL WIDGET-ID 24
     F-factura AT ROW 6.65 COL 19 COLON-ALIGNED WIDGET-ID 12
     Btn_OK AT ROW 8.54 COL 4 WIDGET-ID 54
     BtnDone AT ROW 8.54 COL 21 WIDGET-ID 58
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 10.19 WIDGET-ID 100.


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
         TITLE              = "LIQUIDACION DE COMPRA"
         HEIGHT             = 10.19
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-TOTAL IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN N-MOVI IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* LIQUIDACION DE COMPRA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* LIQUIDACION DE COMPRA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-TOTAL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-TOTAL W-Win
ON CHOOSE OF B-TOTAL IN FRAME F-Main /* Total */
DO:
  DEFINE VAR X-Sub    LIKE Almdmov.Candes NO-UNDO INIT 0. 
  DEFINE VAR X-Tot    LIKE Almdmov.Candes NO-UNDO INIT 0. 
  DEFINE VAR x-igv    AS DECI INIT 0. 

  ASSIGN C-ImpTot I-CodMov C-Nrodoc R-Compra R-MONEDA F-FECHA F-FACTURA.
  
    FIND FIRST Almcmov WHERE Almcmov.CodCia  = S-CODCIA 
                        AND  Almcmov.CodAlm  = S-CODALM 
                        AND  Almcmov.TipMov  = C-TipMov 
                        AND  Almcmov.CodMov  = I-CodMov
                        AND  Almcmov.NroDoc  = C-NroDoc 
                        NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almcmov THEN DO:
        MESSAGE "MOVIMIENTO NO REGISTRADO " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U  TO I-CodMov.
        RETURN NO-APPLY.
      END.
  
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha =  F-FECHA NO-LOCK NO-ERROR.
  x-tipo = IF AVAILABLE gn-tcmb THEN  gn-tcmb.venta ELSE 0.

  IF SUBSTRING(AlmcMov.Observ,1,3) = X-LIQ OR Almcmov.CodMov = X-COMPRA THEN DO:
      FOR EACH ALMDMOV OF ALMCMOV NO-LOCK:
        FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                       AND  Almmmatg.codmat = Almdmov.codmat 
                       NO-LOCK NO-ERROR.
        x-sub  = Almdmov.PreUni.
        IF R-MONEDA = 1 THEN DO:
          x-sub = IF Almdmov.Codmon = R-MONEDA THEN x-sub ELSE  x-sub * x-tipo.
        END.  
        IF R-MONEDA = 2 THEN DO:
          x-sub = IF Almdmov.Codmon = R-MONEDA THEN x-sub ELSE  x-sub / x-tipo.
        END.  
         x-igv     = Almdmov.Igvmat.
         x-sub     = ROUND(( x-sub + ( x-sub * ( x-igv / 100 ))),4).
         x-sub     = ROUND( x-sub * Almdmov.Candes,2).
         X-TOT     = X-TOT + X-SUB.
      END.
      F-TOTAL:SCREEN-VALUE = STRING(X-TOT,"->>,>>9.99").
  END.
  ELSE DO:
      FOR EACH ALMDMOV OF ALMCMOV NO-LOCK:
        FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                       AND  Almmmatg.codmat = Almdmov.codmat 
                       NO-LOCK NO-ERROR.
        x-sub  = Almmmatg.CtoLis.
        IF R-MONEDA = 1 THEN DO:
          x-sub = IF Almmmatg.Monvta = R-MONEDA THEN x-sub ELSE  x-sub * x-tipo.
        END.  
        IF R-MONEDA = 2 THEN DO:
          x-sub = IF Almmmatg.Monvta = R-MONEDA THEN x-sub ELSE  x-sub / x-tipo.
        END.  
         x-igv     = IF Almmmatg.AftIgv THEN Faccfggn.PorIgv ELSE 0.
         x-sub     = ROUND(( x-sub + ( x-sub * ( x-igv / 100 ))),4).
         x-sub     = ROUND( x-sub * Almdmov.Candes,2).
         X-TOT     = X-TOT + X-SUB.
      END.
      F-TOTAL:SCREEN-VALUE = STRING(X-TOT,"->>,>>9.99").
  END.
  
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN C-ImpTot I-CodMov C-Nrodoc R-Compra R-MONEDA F-FECHA F-FACTURA.
  IF I-CODMOV <> 0 THEN DO:
    FIND FIRST Almdmov WHERE Almdmov.CodCia  = S-CODCIA 
                        AND  Almdmov.CodAlm  = S-CODALM 
                        AND  Almdmov.TipMov  = C-TipMov 
                        AND  Almdmov.CodMov  = I-CodMov
                        AND  Almdmov.NroDoc  = C-NroDoc 
                       NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almdmov THEN DO:
        MESSAGE "MOVIMIENTO NO REGISTRADO " VIEW-AS ALERT-BOX.
        APPLY "ENTRY":U  TO I-CodMov.
        RETURN NO-APPLY.
      END.
      /*X-CODMOV = I-CODMOV.*/
  END.
 FIND FIRST Almcmov WHERE Almcmov.CodCia  = S-CODCIA 
                     AND  Almcmov.CodAlm  = S-CODALM 
                     AND  Almcmov.TipMov  = C-TipMov 
                     AND  Almcmov.CodMov  = I-CodMov
                     AND  Almcmov.NroDoc  = C-NroDoc 
                     NO-ERROR.
  
  IF SUBSTRING(AlmcMov.Observ,1,3) = X-LIQ AND R-COMPRA = 2  THEN DO:
    MESSAGE "MOVIMIENTO YA REGISTRA COMPRA " .
  END.
  
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha =  F-FECHA NO-LOCK NO-ERROR.
  x-tipo = IF AVAILABLE gn-tcmb THEN  gn-tcmb.venta ELSE 0.

  FIND FIRST Almtmovm WHERE  Almtmovm.CodCia = Almcmov.CodCia AND
             Almtmovm.Tipmov = Almcmov.TipMov AND 
             Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO:
     S-Movimiento = CAPS(Almtmovm.Desmov).
     IF Almtmovm.PidCli THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = 0 AND 
             gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN 
           FIND gn-clie WHERE gn-clie.CodCia = Almcmov.CodCia AND 
                gn-clie.CodCli = Almcmov.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN S-Procedencia = "Cliente          : " + gn-clie.NomCli.
           S-RUC = "R.U.C.          :   " + Almcmov.CodCli.
                                        
     END.
     IF Almtmovm.PidPro THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = 0 AND 
             gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN 
          FIND gn-prov WHERE gn-prov.CodCia = Almcmov.CodCia AND 
               gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN S-Procedencia = "Proveedor        : " + gn-prov.NomPro.
          S-RUC = "R.U.C.          :   " + Almcmov.CodPro.
/*ML01* Inicio de bloque */
        iNroSer = 0.
        lEsAgente = FALSE.
        IF AVAILABLE gn-prov THEN DO:

            lEsAgente = (
                gn-prov.Libre_C01 = "Si" OR
                gn-prov.Libre_C02 = "Si" OR
                gn-prov.Libre_C03 = "Si"
                ).

            FOR EACH faccorre WHERE
                faccorre.codcia = s-codcia AND
                faccorre.coddoc = cCodDoc AND
                faccorre.NroSer >= 0 NO-LOCK:
                IF faccorre.FlgEst THEN DO:
                    iNroSer = faccorre.NroSer.
                    LEAVE.
                END.
            END.

            IF iNroSer <> 0 THEN DO:
                FIND FIRST cb-tabl WHERE cb-tabl.Tabla = "RET" NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN
                    ASSIGN
                        dPorRetencion = DECIMAL(cb-tabl.Codigo)
                        dMontoMinimo = DECIMAL(cb-tabl.Digitos) NO-ERROR.
            END.

        END.
/*ML01* Fin de bloque */
     END.
     IF Almtmovm.Movtrf THEN DO:
        S-Moneda = "".
        FIND Almacen WHERE Almacen.CodCia = S-CODCIA AND
             Almacen.CodAlm = Almcmov.AlmDes NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN DO:
           IF Almcmov.TipMov = "I" THEN
              S-Procedencia = "Procedencia      : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.
           ELSE 
              S-Procedencia = "Destino          : " + Almcmov.AlmDes + " - " + Almacen.Descripcion.   
           END.            
     END.   
     IF Almtmovm.PidRef1 THEN ASSIGN S-Referencia1 = Almtmovm.GloRf1.
     IF Almtmovm.PidRef2 THEN ASSIGN S-Referencia2 = Almtmovm.GloRf2.
     IF Almtmovm.PidRef3 THEN ASSIGN S-Referencia3 = Almtmovm.GloRf3.
  END.

  RUN Imprimir.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-factura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-factura W-Win
ON LEAVE OF F-factura IN FRAME F-Main /* Numero Factura */
DO:
  f-factura:SCREEN-VALUE = string(integer(SUBSTRING(f-factura:SCREEN-VALUE,1,3)),"999") + 
      "-" + string(integer(SUBSTRING(f-factura:SCREEN-VALUE,5,6)),"999999").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-codmov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-codmov W-Win
ON VALUE-CHANGED OF i-codmov IN FRAME F-Main /* Movimiento */
DO:
  FIND Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
                      Almtmovm.tipmov = C-TIPMOV AND
                      Almtmovm.codmov = integer(I-CodMov:screen-value)  NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN
  assign
    N-MOVI:screen-value = Almtmovm.Desmov.

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
  DISPLAY FILL-IN-3 i-codmov N-MOVI c-nrodoc F-TOTAL c-imptot R-moneda F-fecha 
          R-compra F-factura 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE i-codmov c-nrodoc B-TOTAL c-imptot R-moneda F-fecha R-compra F-factura 
         Btn_OK BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-flgest AS CHAR NO-UNDO.
  DEFINE VAR x-desmat AS CHAR NO-UNDO.
  DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
  DEFINE VAR X-Movi    AS CHAR NO-UNDO.
  DEFINE VAR X-NomR LIKE Almcmov.NomRef NO-UNDO.
  DEFINE VAR X-Usua LIKE Almcmov.usuario NO-UNDO.
  DEFINE VAR X-Ref1 LIKE Almcmov.NroRf1 NO-UNDO. 
  DEFINE VAR X-Sub  LIKE Almdmov.Candes NO-UNDO. 
  DEFINE VAR X-Mon  AS CHAR initial "DOLARES" NO-UNDO. 
  DEFINE VAR X-Tot  LIKE Almdmov.Candes NO-UNDO. 
  
/*ML01*/ DEFINE VARIABLE cRetencion AS CHARACTER FORMAT "x(60)" NO-UNDO.

  IF almcmov.Codmon = 1 THEN DO:
     S-Moneda = "Compra en       :   SOLES".
     S-Mon    = "S/.".
     R-MONEDA = 1.
  END.
  ELSE DO:
     S-Moneda = "Compra en       :   DOLARES".
     S-Mon    = "US$.".
     R-MONEDA = 2.
  END.

  
  x-titulo2 = ' P R O D U C T O S ' .
  CASE C-TipMov:
     WHEN 'I' THEN x-titulo1 = 'LIQUIDACION DE COMPRA '.
     WHEN 'S' THEN x-titulo1 = 'LIQUIDACION DE COMPRA '.
  END CASE.

     DEFINE FRAME H-REP
          Almdmov.codmat  FORMAT "X(8)"
          Almmmatg.DesMat AT 9 FORMAT "X(35)"
          Almdmov.CodUnd  AT 45 FORMAT "X(6)" 
          Almdmov.CanDes  FORMAT  "(>>>,>>9.99)" 
          Almdmov.Prelis  FORMAT  "(>>>,>>9.9999)"
          X-Sub           FORMAT  "(>>>,>>9.99)" 
          Almmmatg.UndA      AT 95  FORMAT "X(4)"
          Almmmatg.MrgUti-A  AT 100 FORMAT "(>>9.99)"
          Almmmatg.UndB      AT 110 FORMAT "X(4)" 
          Almmmatg.MrgUti-B  AT 115 FORMAT "(>>9.99)"
          Almmmatg.UndC      AT 125 FORMAT "X(4)"
          Almmmatg.MrgUti-C  AT 130 FORMAT "(>>9.99)"

          HEADER
          
          {&PRN2} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN3} FORMAT "X(45)" 
          "INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
          {&PRN2} + {&PRN7A} + {&PRN6A} + "( " + S-CODALM + " )" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 5 FORMAT "X(20)" 
          S-Movimiento  AT 52  "Pag. " AT 108  SKIP(1)
          S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
          S-Referencia3 AT 1 ": " Almcmov.NroRf3  AT 20 "Almacen Ingreso : " AT 79 S-CODALM AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
          S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 SKIP
          "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP

          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
          "                                                                                               Undidad-A      Unidad-B       Unidad-C  " SKIP
          "Articulo        Descripcion                    Unid      Cantidad         Costo     Subtotal  Und  Margen    Und  Margen    Und  Margen" SKIP
          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  
       
 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4}.
      
  FOR EACH Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                    AND  Almdmov.CodAlm = S-CODALM 
                    AND  Almdmov.TipMov = C-TipMov 
                    AND  Almdmov.CodMov = I-CodMov
                    AND  Almdmov.NroDoc = C-NroDoc
                    BREAK BY Almdmov.CodCia
                         BY Almdmov.CodAlm
                         BY Almdmov.TipMov
                         BY Almdmov.CodMov
                         BY Almdmov.NroSer 
                         BY Almdmov.Nrodoc 
                         ON ERROR UNDO, LEAVE :
      FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                     AND  Almmmatg.codmat = Almdmov.codmat 
                    NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN x-desmat = 'PRODUCTO NO REGISTRADO'.
      ELSE x-desmat = Almmmatg.DesMat.
           W-VTA0 = almdmov.prelis * (1 - (Almdmov.dsctos[1] / 100)).
           W-VTA1 = w-vta0  * (1 - (Almdmov.dsctos[2] / 100)).
           W-VTA2 = w-vta1  * (1 - (Almdmov.dsctos[3] / 100)).
           IF Almmmatg.AftIgv THEN    
               X-SUB = ROUND(( W-VTA2 + ( W-VTA2 * (Almdmov.IgvMat / 100 ))) * ALMDMOV.CANDES,2).
           ELSE 
               X-SUB = ROUND( W-VTA2  * ALMDMOV.CANDES,2).
            X-TOT = X-TOT + X-SUB.
      IF R-Compra = 2 THEN DO:
         Almdmov.Tpocmb = x-tipo.
      END.
      DISPLAY STREAM REPORT 
              Almdmov.codmat 
              x-desmat @ Almmmatg.DesMat
              Almdmov.CodUnd 
              Almdmov.CanDes 
              X-SUB / AlmdmoV.Candes @ Almdmov.Prelis
              x-sub    
              Almmmatg.UndA      
              Almmmatg.MrgUti-A  
              Almmmatg.UndB      
              Almmmatg.MrgUti-B  
              Almmmatg.UndC      
              Almmmatg.MrgUti-C  
              WITH FRAME H-REP.

      IF LAST-OF(Almdmov.Nrodoc) THEN DO:
           IF R-Compra = 2 THEN DO:
             Almcmov.Observ = If substring(Almcmov.Observ,1,3) = X-LIQ  + Almcmov.Observ THEN "" ELSE X-LIQ + Almcmov.Observ .
             /*Almcmov.NroRf3 = f-factura.*/
             Almcmov.NroRf2 = f-factura.
             Almcmov.Tpocmb = x-tipo.
             Almcmov.ImpMn1 = IF R-MONEDA = 1 THEN X-TOT ELSE X-TOT * x-tipo.
             Almcmov.ImpMn2 = IF R-MONEDA = 2 THEN X-TOT ELSE X-TOT / x-tipo.
           END.
           
/*ML01* Inicio de bloque */
            IF NOT lEsAgente THEN
                cRetencion =
                    "  Retencion: " +
                    TRIM(STRING(dPorRetencion,">9.9<%")) + " " +
                    TRIM(STRING(ROUND((C-IMPTOT * dPorRetencion / 100),2),"(>,>>>,>>9.99)")) + "  " +
                    "Saldo: " + TRIM(STRING(ROUND((C-IMPTOT - (C-IMPTOT * dPorRetencion / 100)),2),"(>,>>>,>>9.99)")).
            ELSE cRetencion = "".
/*ML01* Fin de bloque */

           PUT STREAM REPORT 
           SKIP
           "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*ML01* Inicio de bloque */
            "Importe Calculado: " TO 30 X-tot            TO 45 FORMAT  "(>,>>>,>>9.99)" SKIP
            "Importe Ingresado: " TO 30 C-IMPTOT         TO 45 FORMAT  "(>,>>>,>>9.99)" cRetencion SKIP
            "Diferencia       : " TO 30 X-TOT - C-IMPTOT TO 45 FORMAT  "(>,>>>,>>9.99)" skip
/*ML01* Fin de bloque */
           "---------------------------------------------------------------------------------------------------------------------------------------".

          DOWN STREAM REPORT 1 WITH FRAME F-REP. 
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2a W-Win 
PROCEDURE Formato2a :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-flgest AS CHAR NO-UNDO.
  DEFINE VAR x-desmat AS CHAR NO-UNDO.
  DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
  DEFINE VAR X-Movi    AS CHAR NO-UNDO.
  DEFINE VAR X-NomR LIKE Almcmov.NomRef NO-UNDO.
  DEFINE VAR X-Usua LIKE Almcmov.usuario NO-UNDO.
  DEFINE VAR X-Ref1 LIKE Almcmov.NroRf1 NO-UNDO. 
  DEFINE VAR X-Sub  LIKE Almdmov.Candes NO-UNDO. 
  DEFINE VAR X-Mon  AS CHAR initial "DOLARES" NO-UNDO. 
  DEFINE VAR X-Tot  LIKE Almdmov.Candes NO-UNDO. 
  
/*ML01*/ DEFINE VARIABLE cRetencion AS CHARACTER FORMAT "x(60)" NO-UNDO.

  IF almcmov.Codmon = 1 THEN DO:
     S-Moneda = "Compra en       :   SOLES".
     S-Mon    = "S/.".
     R-MONEDA = 1.
  END.
  ELSE DO:
     S-Moneda = "Compra en       :   DOLARES".
     S-Mon    = "US$.".
     R-MONEDA = 2.
  END.

  
  x-titulo2 = ' P R O D U C T O S ' .
  CASE C-TipMov:
     WHEN 'I' THEN x-titulo1 = 'LIQUIDACION DE COMPRA '.
     WHEN 'S' THEN x-titulo1 = 'LIQUIDACION DE COMPRA '.
  END CASE.

     DEFINE FRAME H-REP
          Almdmov.codmat  FORMAT "X(8)"
          Almmmatg.DesMat AT 9 FORMAT "X(35)"
          Almdmov.CodUnd  AT 45 FORMAT "X(6)" 
          Almdmov.CanDes  FORMAT  "(>>>,>>9.99)" 
          Almdmov.Prelis  FORMAT  "(>>>,>>9.9999)"
          X-Sub           FORMAT  "(>>>,>>9.99)" 
          Almmmatg.UndA      AT 95  FORMAT "X(4)"
          Almmmatg.MrgUti-A  AT 100 FORMAT "(>>9.99)"
          Almmmatg.UndB      AT 110 FORMAT "X(4)" 
          Almmmatg.MrgUti-B  AT 115 FORMAT "(>>9.99)"
          Almmmatg.UndC      AT 125 FORMAT "X(4)"
          Almmmatg.MrgUti-C  AT 130 FORMAT "(>>9.99)"

          HEADER
          
          {&PRN2} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN3} FORMAT "X(45)" 
          "INGRESO No. : " AT 96 Almcmov.NroDoc AT 114 SKIP
          {&PRN2} + {&PRN7A} + {&PRN6A} + "( " + S-CODALM + " )" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 5 FORMAT "X(20)" 
          S-Movimiento  AT 52  "Pag. " AT 108  SKIP(1)
          S-PROCEDENCIA AT 1 FORMAT "X(70)" S-RUC AT 79 "Fecha : " AT 113 Almcmov.FchDoc AT 121 SKIP
          S-Referencia3 AT 1 ": " Almcmov.NroRf3  AT 20 "Almacen Ingreso : " AT 79 S-CODALM AT 99       "Hora  : " AT 113 Almcmov.HorRcp AT 121 SKIP 
          S-Referencia1 AT 1 ": " Almcmov.NroRf1  AT 20 S-MONEDA AT 79 SKIP
          "Observaciones    : " AT 1 Almcmov.Observ  AT 20 "Responsable     : " AT 79 S-Encargado AT 99 SKIP

          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
          "                                                                                               Undidad-A      Unidad-B       Unidad-C  " SKIP
          "Articulo        Descripcion                    Unid      Cantidad         Costo     Subtotal  Und  Margen    Und  Margen    Und  Margen" SKIP
          "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  
       
 
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4}.
      
  FOR EACH Almdmov WHERE Almdmov.CodCia = S-CODCIA 
                    AND  Almdmov.CodAlm = S-CODALM 
                    AND  Almdmov.TipMov = C-TipMov 
                    AND  Almdmov.CodMov = I-CodMov
                    AND  Almdmov.NroDoc = C-NroDoc
                    BREAK BY Almdmov.CodCia
                         BY Almdmov.CodAlm
                         BY Almdmov.TipMov
                         BY Almdmov.CodMov
                         BY Almdmov.NroSer 
                         BY Almdmov.Nrodoc 
                         ON ERROR UNDO, LEAVE :
      FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                     AND  Almmmatg.codmat = Almdmov.codmat 
                    NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmatg THEN x-desmat = 'PRODUCTO NO REGISTRADO'.
      ELSE x-desmat = Almmmatg.DesMat.
           W-VTA0 = almdmov.prelis * (1 - (Almdmov.dsctos[1] / 100)).
           W-VTA1 = w-vta0  * (1 - (Almdmov.dsctos[2] / 100)).
           W-VTA2 = w-vta1  * (1 - (Almdmov.dsctos[3] / 100)).
           IF Almmmatg.AftIgv THEN    
               X-SUB = ROUND(( W-VTA2 + ( W-VTA2 * (Almdmov.IgvMat / 100 ))) * ALMDMOV.CANDES,2).
           ELSE 
               X-SUB = ROUND( W-VTA2  * ALMDMOV.CANDES,2).
            X-TOT = X-TOT + X-SUB.
      IF R-Compra = 2 THEN DO:
         Almdmov.Tpocmb = x-tipo.
      END.

      FIND VtaListaMinGn WHERE VtaListaMinGn.CodCia = s-codcia
          AND VtaListaMinGn.codmat = Almdmov.codmat
          NO-LOCK NO-ERROR.
      DISPLAY STREAM REPORT 
              Almdmov.codmat 
              x-desmat @ Almmmatg.DesMat
              Almdmov.CodUnd 
              Almdmov.CanDes 
              X-SUB / AlmdmoV.Candes @ Almdmov.Prelis
              x-sub    
              VtaListaMinGn.Chr__01 WHEN AVAILABLE(VtalistaminGn) @ Almmmatg.UndA      
              VtaListaMinGn.Dec__01 WHEN AVAILABLE(VtalistaminGn) @ Almmmatg.MrgUti-A  
              WITH FRAME H-REP.
/*       FIND VtaListaMIn WHERE VtaListaMin.CodCia = s-codcia */
/*           AND VtaListaMin.CodDiv = Almacen.coddiv          */
/*           AND VtaListaMin.codmat = Almdmov.codmat          */
/*           NO-LOCK NO-ERROR.                                */
/*       DISPLAY STREAM REPORT                                                       */
/*               Almdmov.codmat                                                      */
/*               x-desmat @ Almmmatg.DesMat                                          */
/*               Almdmov.CodUnd                                                      */
/*               Almdmov.CanDes                                                      */
/*               X-SUB / AlmdmoV.Candes @ Almdmov.Prelis                             */
/*               x-sub                                                               */
/*               VtaListaMin.Chr__01 WHEN AVAILABLE(Vtalistamin) @ Almmmatg.UndA     */
/*               VtaListaMin.Dec__01 WHEN AVAILABLE(Vtalistamin) @ Almmmatg.MrgUti-A */
/*               WITH FRAME H-REP.                                                   */

      IF LAST-OF(Almdmov.Nrodoc) THEN DO:
           IF R-Compra = 2 THEN DO:
             Almcmov.Observ = If substring(Almcmov.Observ,1,3) = X-LIQ  + Almcmov.Observ THEN "" ELSE X-LIQ + Almcmov.Observ .
             /*Almcmov.NroRf3 = f-factura.*/
             Almcmov.NroRf2 = f-factura.
             Almcmov.Tpocmb = x-tipo.
             Almcmov.ImpMn1 = IF R-MONEDA = 1 THEN X-TOT ELSE X-TOT * x-tipo.
             Almcmov.ImpMn2 = IF R-MONEDA = 2 THEN X-TOT ELSE X-TOT / x-tipo.
           END.
           
/*ML01* Inicio de bloque */
            IF NOT lEsAgente THEN
                cRetencion =
                    "  Retencion: " +
                    TRIM(STRING(dPorRetencion,">9.9<%")) + " " +
                    TRIM(STRING(ROUND((C-IMPTOT * dPorRetencion / 100),2),"(>,>>>,>>9.99)")) + "  " +
                    "Saldo: " + TRIM(STRING(ROUND((C-IMPTOT - (C-IMPTOT * dPorRetencion / 100)),2),"(>,>>>,>>9.99)")).
            ELSE cRetencion = "".
/*ML01* Fin de bloque */

           PUT STREAM REPORT 
           SKIP
           "---------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*ML01* Inicio de bloque */
            "Importe Calculado: " TO 30 X-tot            TO 45 FORMAT  "(>,>>>,>>9.99)" SKIP
            "Importe Ingresado: " TO 30 C-IMPTOT         TO 45 FORMAT  "(>,>>>,>>9.99)" cRetencion SKIP
            "Diferencia       : " TO 30 X-TOT - C-IMPTOT TO 45 FORMAT  "(>,>>>,>>9.99)" skip
/*ML01* Fin de bloque */
           "---------------------------------------------------------------------------------------------------------------------------------------".

          DOWN STREAM REPORT 1 WITH FRAME F-REP. 
      END.
  END.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = s-codalm NO-LOCK.
        IF Almacen.coddiv = '00023'         /* UTILEX */
        THEN RUN Formato2a.
        ELSE RUN Formato2.
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
  ASSIGN F-FACTURA = ""
         C-IMPTOT = 0
         R-COMPRA = 1
         R-MONEDA = 1
         F-FECHA  = TODAY
         FILL-IN-3 = S-CODALM.

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

