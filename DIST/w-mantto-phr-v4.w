&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-RutaC FOR DI-RutaC.
DEFINE BUFFER B-RutaD FOR DI-RutaD.
DEFINE TEMP-TABLE R-RUTAC NO-UNDO LIKE DI-RutaC.
DEFINE TEMP-TABLE T-RutaC NO-UNDO LIKE DI-RutaC
       FIELD Libre_d06 AS DEC
       FIELD Libre_d07 AS INT /* Ptos Entrega */
       INDEX Llave01 AS PRIMARY CodCia CodDoc NroDoc.
DEFINE TEMP-TABLE T-RutaD NO-UNDO LIKE DI-RutaD
       FIELD LugEnt AS CHAR
       FIELD SKU AS INT
       FIELD FchEnt AS DATE
       FIELD Docs AS INT
       FIELD Estado AS CHAR
       FIELD Reprogramado AS LOG INITIAL NO
       FIELD PtoDestino AS CHAR
       FIELD Departamento AS CHAR.
DEFINE TEMP-TABLE TT-RutaD NO-UNDO LIKE DI-RutaD
       FIELD LugEnt AS CHAR
       FIELD SKU AS INT
       FIELD FchEnt AS DATE
       FIELD Docs AS INT
       FIELD Estado AS CHAR
       FIELD Reprogramado AS LOG INITIAL NO
       FIELD PtoDestino AS CHAR
       FIELD Departamento AS CHAR.



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
DEF SHARED VAR s-codcia AS INTE.

/* Local Variable Definitions ---                                       */

DEF NEW SHARED VAR lh_handle AS HANDLE.

DEF TEMP-TABLE Detalle
    FIELD FchDoc AS DATE FORMAT '99/99/9999' LABEL 'Fecha'
    FIELD NroDoc AS CHAR FORMAT 'x(9)' LABEL 'Numero'
    FIELD Estado AS CHAR FORMAT 'x(20)'
    FIELD Libre_d01 AS DECI FORMAT '>>>,>>9.99' LABEL 'Peso'
    FIELD Libre_d06 AS DECI FORMAT '>>>,>>9.99' LABEL 'Volumen'
    FIELD Libre_d02 AS DECI FORMAT '>>>,>>9.99' LABEL 'Importe'
    FIELD Libre_d03 AS DECI FORMAT '>>>,>>9' LABEL 'Clientes'
    FIELD Observ AS CHAR FORMAT 'x(40)' LABEL 'Glosa'
    FIELD Libre_c05 AS CHAR FORMAT 'x(10)' LABEL 'Usuario Modificacion'
    FIELD Libre_f05 AS DATE FORMAT '99/99/9999' LABEL 'Fecha Modificacion'

    FIELD DesDiv AS CHAR FORMAT 'x(25)' LABEL 'Canal'

    FIELD Termino_Pago AS CHAR FORMAT 'x(50)' LABEL 'Termino de Pago'
    FIELD Cliente_Recoge AS CHAR LABEL 'Cliente Recoge'
    FIELD Embalaje_Especial AS CHAR LABEL 'Embalaje Especial'
    FIELD Departamento AS CHAR FORMAT 'x(25)'
    FIELD Distrito AS CHAR FORMAT 'x(25)'
    FIELD CodRef AS CHAR FORMAT 'x(3)' LABEL 'Codigo'
    FIELD NroRef AS CHAR FORMAT 'x(9)' LABEL 'Numero'
    FIELD FchPed AS DATE FORMAT '99/99/9999' LABEL 'Fecha de Pedido'
    FIELD Hora   AS CHAR FORMAT 'x(10)' LABEL 'Hora'
    FIELD FchEnt AS DATE FORMAT '99/99/9999' LABEL 'Fecha Entrega'
    FIELD lugent AS CHAR FORMAT 'x(100)' LABEL 'Lugar de entrega'
    FIELD NomCli AS CHAR FORMAT 'x(100)' LABEL 'Cliente'
    FIELD Estado2 AS CHAR FORMAT 'x(20)' LABEL 'Situación'
    FIELD Sku AS INTE FORMAT '>>,>>9'
    FIELD Libre_c01 AS CHAR FORMAT 'x(6)' LABEL 'Bultos'
    FIELD Libre_d021 AS DECI FORMAT '>>>,>>9.99' LABEL 'Importe'
    FIELD Libre_d011 AS DECI FORMAT '>>>,>>9.99' LABEL 'Peso'
    FIELD ImpCob AS DECI FORMAT '>>>,>>9.99' LABEL 'm3'
    FIELD Repro01 AS DATE FORMAT '99/99/9999' LABEL 'Reprogramacion 1'
    FIELD Repro02 AS DATE FORMAT '99/99/9999' LABEL 'Reprogramacion 2'
    FIELD Repro03 AS DATE FORMAT '99/99/9999' LABEL 'Reprogramacion 3'
    FIELD Direccion AS CHAR FORMAT 'x(89)' LABEL 'Direccion'
    FIELD Pendiente_Cobro AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Pendiente de Cobro'

    FIELD ffinprechq AS DATE FORMAT '99/99/9999' LABEL 'Fin de Picking'
    FIELD Hfinprechq AS CHAR LABEL 'Hora Fin de Picking'
    FIELDS ffincheq  AS CHAR LABEL "Fin Chequeo"
    FIELDS hfincheq  AS CHAR LABEL "Hora fin de chequeo"
    FIELDS ffindocu  AS CHAR LABEL 'Fecha Documentación'
    FIELDS hfindocu  AS CHAR LABEL 'Hora de Documentación'
    .

DEFINE BUFFER B-DI-RUTAC FOR DI-RUTAC.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-Print BUTTON-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistrito W-Win 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado2 W-Win 
FUNCTION fEstado2 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPendiente W-Win 
FUNCTION fPendiente RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-mantto-phr-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-mantto-phr-det-v4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv98 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Enviar a Texto" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Print 
     IMAGE-UP FILE "img/printer.ico":U
     LABEL "Imprimir" 
     SIZE 7 BY 1.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Print AT ROW 2.62 COL 37 WIDGET-ID 2
     BUTTON-1 AT ROW 2.73 COL 46 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.96 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-RutaC B "?" ? INTEGRAL DI-RutaC
      TABLE: B-RutaD B "?" ? INTEGRAL DI-RutaD
      TABLE: R-RUTAC T "?" NO-UNDO INTEGRAL DI-RutaC
      TABLE: T-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
      ADDITIONAL-FIELDS:
          FIELD Libre_d06 AS DEC
          FIELD Libre_d07 AS INT /* Ptos Entrega */
          INDEX Llave01 AS PRIMARY CodCia CodDoc NroDoc
      END-FIELDS.
      TABLE: T-RutaD T "?" NO-UNDO INTEGRAL DI-RutaD
      ADDITIONAL-FIELDS:
          FIELD LugEnt AS CHAR
          FIELD SKU AS INT
          FIELD FchEnt AS DATE
          FIELD Docs AS INT
          FIELD Estado AS CHAR
          FIELD Reprogramado AS LOG INITIAL NO
          FIELD PtoDestino AS CHAR
          FIELD Departamento AS CHAR
      END-FIELDS.
      TABLE: TT-RutaD T "?" NO-UNDO INTEGRAL DI-RutaD
      ADDITIONAL-FIELDS:
          FIELD LugEnt AS CHAR
          FIELD SKU AS INT
          FIELD FchEnt AS DATE
          FIELD Docs AS INT
          FIELD Estado AS CHAR
          FIELD Reprogramado AS LOG INITIAL NO
          FIELD PtoDestino AS CHAR
          FIELD Departamento AS CHAR
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "MANTENIMIENTO DE PRE-HOJA DE RUTA"
         HEIGHT             = 25.96
         WIDTH              = 144.29
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* MANTENIMIENTO DE PRE-HOJA DE RUTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* MANTENIMIENTO DE PRE-HOJA DE RUTA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Enviar a Texto */
DO:
    DEF VAR pOptions AS CHAR NO-UNDO.
    DEF VAR pArchivo AS CHAR NO-UNDO.

    DEF VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE pArchivo
        FILTERS "Archivo txt" "*.txt"
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".txt"
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN NO-APPLY.
    
    ASSIGN
        pOptions = "FileType:TXT" + CHR(1) + ~
              "Grid:ver" + CHR(1) + ~ 
              "ExcelAlert:false" + CHR(1) + ~
              "ExcelVisible:false" + CHR(1) + ~
              "Labels:yes".


    /* Capturamos información de la cabecera y el detalle */
    DEF VAR pEstado AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE DETALLE.

    DEF VAR x-Registro AS INT NO-UNDO.
    DEF VAR i-Cuentas AS INTE NO-UNDO.

    EMPTY TEMP-TABLE T-RutaC.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Captura-Registro IN h_b-mantto-phr-cab ( OUTPUT TABLE T-RutaC).
    FOR EACH T-RutaC NO-LOCK, FIRST B-Di-RutaC OF T-RutaC NO-LOCK:

        FIND FIRST Di-RutaC OF T-RutaC NO-LOCK NO-ERROR.

        /*MESSAGE  "Va..." B-DI-RUTAC.coddoc B-DI-RUTAC.nrodoc.*/

        EMPTY TEMP-TABLE T-RutaD.
        RUN Captura-Temporal IN h_b-mantto-phr-det-v4( INPUT ROWID(B-DI-RutaC),
                                                     INPUT-OUTPUT TABLE T-RUTAD).
        FOR EACH T-RutaD NO-LOCK WHERE T-RutaD.CodCia = T-RutaC.CodCia AND
            T-RutaD.CodDiv = T-RutaC.CodDiv AND
            T-RutaD.CodDoc = T-RutaC.CodDoc AND
            T-RutaD.NroDoc = T-RutaC.NroDoc,
            FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = T-RutaD.CodCia AND
            Faccpedi.coddoc = T-RutaD.CodRef AND
            Faccpedi.nroped = T-RutaD.NroRef,
            FIRST gn-divi OF Faccpedi NO-LOCK:
            CREATE Detalle.
            BUFFER-COPY T-RutaC TO Detalle
                ASSIGN Detalle.Estado = fEstado().
            Detalle.termino_pago = "TRANSFERENCIA".
            IF Faccpedi.coddoc <> "OTR" THEN DO:
                FIND gn-convt WHERE gn-ConVt.Codig = Faccpedi.fmapgo NO-LOCK NO-ERROR.
                IF AVAILABLE gn-convt THEN Detalle.termino_pago = gn-ConVt.Codig + " " + gn-ConVt.Nombr.
            END.
            ASSIGN
                Detalle.DesDiv = gn-divi.desdiv
                Detalle.Distrito = fDistrito()
                Detalle.CodRef = T-RutaD.CodRef
                Detalle.NroRef = T-RutaD.NroRef
                Detalle.FchEnt = Faccpedi.FchEnt
                Detalle.NomCli = Faccpedi.NomCli
                Detalle.Estado2 = T-RutaD.estado    /*fEstado2()*/
                Detalle.Sku = T-RutaD.Sku
                Detalle.Libre_c01 = T-RutaD.Libre_c01
                Detalle.Libre_d021 = T-RutaD.ImpCob /*Libre_d02*/
                Detalle.Libre_d011 = T-RutaD.Libre_d01
                Detalle.ImpCob = T-RutaD.Libre_d02.   /*ImpCob.*/
            ASSIGN
                Detalle.Cliente_Recoge = (IF FacCPedi.Cliente_Recoge = YES THEN "SI" ELSE "NO")
                Detalle.Embalaje_Especial = (IF FacCPedi.EmpaqEspec = YES THEN "SI" ELSE "NO")
                Detalle.Departamento = T-RUTAD.Departamento
                Detalle.FchPed = Faccpedi.fchped
                Detalle.hora   = Faccpedi.hora
                Detalle.lugent = T-RutaD.lugent
                .
            ASSIGN
                Detalle.Direccion = Faccpedi.DirCli.
            ASSIGN
                Detalle.Pendiente_Cobro = fPendiente().

            /* *********************************************************************************************** */
            /* 02/02/2023 Datos adicional F. Oblitas */
            /* *********************************************************************************************** */
            FIND FIRST ccbcbult WHERE ccbcbult.codcia = s-codcia AND 
                ccbcbult.coddoc = faccpedi.coddoc AND
                ccbcbult.nrodoc = faccpedi.nroped NO-LOCK NO-ERROR.
            CASE Faccpedi.CodDoc:
                WHEN "OTR" THEN DO:
                    Detalle.ffincheq = IF (AVAILABLE ccbcbult) THEN STRING(Ccbcbult.dte_02) ELSE Detalle.ffincheq.
                    Detalle.hfincheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.CHR_03 ELSE IF(AVAILABLE ccbcbult) THEN Ccbcbult.CHR_04 ELSE "".
                    FOR EACH almcmov WHERE almcmov.codcia = s-codcia AND 
                        almcmov.codref = faccpedi.coddoc AND
                        almcmov.nroref = faccpedi.nroped AND 
                        almcmov.codalm = faccpedi.codalm AND
                        almcmov.flgest <> 'A' NO-LOCK:
                        Detalle.ffindocu = STRING(almcmov.fchdoc).
                        Detalle.hfindocu = almcmov.hradoc.
                    END.
                END.
                WHEN "O/D" THEN DO:
                    Detalle.ffincheq = IF (AVAILABLE ccbcbult) THEN STRING(Ccbcbult.dte_02) ELSE Detalle.ffincheq.
                    Detalle.hfincheq = IF(AVAILABLE ccbcbult) THEN ccbcbult.CHR_03 ELSE IF(AVAILABLE ccbcbult) THEN Ccbcbult.CHR_04 ELSE "".
                    FOR EACH ccbcdocu USE-INDEX llave15 WHERE ccbcdocu.codcia = s-codcia AND 
                        ccbcdocu.codped = faccpedi.codref AND
                        ccbcdocu.nroped = faccpedi.nroref AND 
                        LOOKUP(ccbcdocu.coddoc,"FAC,BOL") > 0 AND 
                        ccbcdocu.libre_c01 = faccpedi.coddoc AND
                        ccbcdocu.libre_c02 = faccpedi.nroped AND
                        ccbcdocu.flgest <> 'A' NO-LOCK:
                        Detalle.ffindocu = STRING(ccbcdocu.fchdoc).
                        Detalle.hfindocu = ccbcdocu.horcie.
                    END.
                END.
            END CASE.
            /* Cierre de Pre-Picking */
            FIND FIRST Vtadtrkped WHERE vtadtrkped.CodCia = Faccpedi.codcia AND
                vtadtrkped.CodDoc = Faccpedi.coddoc AND 
                vtadtrkped.NroPed = Faccpedi.nroped AND
                vtadtrkped.CodUbic = "VODP"
                NO-LOCK NO-ERROR.
            IF AVAILABLE vtadtrkped THEN 
                ASSIGN
                Detalle.ffinprechq = DATE(ENTRY(1,STRING(vtadtrkped.fechat,'99/99/9999 HH:MM:SS'), ' '))
                Detalle.hfinprechq = SUBSTRING(ENTRY(2,STRING(vtadtrkped.fechat,'99/99/9999 HH:MM:SS'), ' '),1,8)
                .
            /* Si no lo encuentro */
            FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.codcia = Faccpedi.codcia AND
                LogTrkDocs.coddoc = Faccpedi.coddoc AND
                LogTrkDocs.nrodoc = Faccpedi.nroped AND
                LogTrkDocs.codigo = "PC_ALM"
                BY LogTrkDocs.Fecha:
                Detalle.ffinprechq = DATE(ENTRY(1,STRING(LogTrkDocs.Fecha,'99/99/9999 HH:MM:SS'), ' ')).
                Detalle.hfinprechq = SUBSTRING(ENTRY(2,STRING(LogTrkDocs.Fecha,'99/99/9999 HH:MM:SS'), ' '),1,8).
            END.
            /* *********************************************************************************************** */
            /* *********************************************************************************************** */
            /* Buscamos Reprogramaciones de GR */
            EMPTY TEMP-TABLE R-RUTAC.
            /* Buscamos por la O/D referenciada */
            FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = T-RutaD.codcia AND
                Ccbcdocu.codped = Faccpedi.codref AND   /* PED */
                Ccbcdocu.nroped = Faccpedi.nroref AND
                Ccbcdocu.coddoc = "G/R":
                FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.codcia = T-RutaD.codcia AND
                    B-RutaD.coddoc = "H/R" AND 
                    B-RutaD.codref = Ccbcdocu.CodDoc AND
                    B-RutaD.nroref = Ccbcdocu.NroDoc,
                    FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst = "C":
                    FIND FIRST R-RUTAC OF B-RutaC NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE R-RUTAC THEN DO:
                        CREATE R-RUTAC.
                        BUFFER-COPY B-RutaC TO R-RUTAC.
                    END.
                END.
            END.
            i-Cuentas = 0.
            FOR EACH R-RUTAC BREAK BY R-RUTAC.FchSal:
                IF FIRST-OF(R-RUTAC.FchSal) THEN DO:
                    i-Cuentas = i-Cuentas + 1.
                    CASE i-Cuentas:
                        WHEN 1 THEN Detalle.Repro01 = R-RutaC.FchSal.
                        WHEN 2 THEN Detalle.Repro02 = R-RutaC.FchSal.
                        WHEN 3 THEN Detalle.Repro03 = R-RutaC.FchSal.
                    END CASE.
                    IF i-Cuentas > 3 THEN LEAVE.
                END.
            END.
        END.
    END.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST DETALLE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    DEF VAR cArchivo AS CHAR NO-UNDO.
    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN lib/tt-filev2 (TEMP-TABLE DETALLE:HANDLE, cArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.
    RUN dispatch IN h_b-mantto-phr-cab ('open-query':U).
    /*RUN dispatch IN h_b-mantto-phr-det-v4 ('open-query':U).*/
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Print W-Win
ON CHOOSE OF BUTTON-Print IN FRAME F-Main /* Imprimir */
DO:
   RUN dispatch IN h_b-mantto-phr-cab ('imprime':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-mantto-phr-cab-distribucion.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = NroDoc':U ,
             OUTPUT h_b-mantto-phr-cab ).
       RUN set-position IN h_b-mantto-phr-cab ( 1.04 , 2.29 ) NO-ERROR.
       RUN set-size IN h_b-mantto-phr-cab ( 10.35 , 140.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv98.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv98 ).
       RUN set-position IN h_p-updv98 ( 2.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_p-updv98 ( 1.54 , 34.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-mantto-phr-det-v4.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-mantto-phr-det-v4 ).
       RUN set-position IN h_b-mantto-phr-det-v4 ( 11.38 , 2.86 ) NO-ERROR.
       RUN set-size IN h_b-mantto-phr-det-v4 ( 14.00 , 140.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 25.42 , 3.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-mantto-phr-cab. */
       RUN add-link IN adm-broker-hdl ( h_p-updv98 , 'TableIO':U , h_b-mantto-phr-cab ).

       /* Links to SmartBrowser h_b-mantto-phr-det-v4. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-mantto-phr-det-v4 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-mantto-phr-cab ,
             BUTTON-Print:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv98 ,
             h_b-mantto-phr-cab , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-mantto-phr-det-v4 ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_b-mantto-phr-det-v4 , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal W-Win 
PROCEDURE Captura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pRowId AS ROWID.
DEF INPUT-OUTPUT PARAMETER TABLE FOR TT-RUTAD.

RUN Captura-Temporal IN h_b-mantto-phr-det-v4
    ( INPUT pRowId, INPUT-OUTPUT TABLE TT-RUTAD).


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
  ENABLE BUTTON-Print BUTTON-1 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN 'Pinta-Cabecera' THEN DO:
         RUN dispatch IN h_b-mantto-phr-cab ('display-fields':U).
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar-detalle W-Win 
PROCEDURE refrescar-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pRowId AS ROWID NO-UNDO.

RUN refrescar IN h_b-mantto-phr-det-v4(INPUT pRowId).


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDistrito W-Win 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ ) :

    DEF VAR pUbigeo AS CHAR NO-UNDO.
    DEF VAR pLongitud AS DEC NO-UNDO.
    DEF VAR pLatitud AS DEC NO-UNDO.
    DEF VAR pCuadrante AS CHAR NO-UNDO.

    RUN logis/p-datos-sede-auxiliar (
        FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
        FacCPedi.Ubigeo[3],   /* Auxiliar */
        FacCPedi.Ubigeo[1],   /* Sede */
        OUTPUT pUbigeo,
        OUTPUT pLongitud,
        OUTPUT pLatitud
        ).
    FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
        AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
        AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
        NO-LOCK NO-ERROR.
      IF AVAILABLE TabDistr THEN RETURN TabDistr.NomDistr.
      ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado W-Win 
FUNCTION fEstado RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
  DEF VAR x-Estado AS CHAR NO-UNDO.
  CASE DI-RutaC.FlgEst:
      WHEN 'P' THEN x-Estado = 'Pendiente'.
      WHEN 'C' THEN x-Estado = 'Cerrada'.
      WHEN 'A' THEN x-Estado = 'Anulada'.
      WHEN 'PK' THEN x-Estado = 'Con HPK'.
      WHEN 'PX' THEN x-Estado = 'Generada'.
      OTHERWISE x-Estado = 'NO DEFINIDO: ' + DI-RutaC.FlgEst.
  END CASE.
  RETURN x-Estado.

  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado2 W-Win 
FUNCTION fEstado2 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
  /*
  DEF VAR cEstado AS CHAR NO-UNDO.

  cEstado = 'Aprobado'.
  CASE Faccpedi.CodDoc:
      WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
          IF Faccpedi.usrImpOD > '' THEN cEstado = 'Impreso'.
          IF Faccpedi.FlgSit = "P" OR Faccpedi.FlgSit = "PI" THEN cEstado = "Picking Terminado".
          IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "C" THEN cEstado = "Por Facturar".
          IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "PC" THEN cEstado = "Checking Terminado".
          IF Faccpedi.FlgEst = "C" THEN cEstado = "Documentado".
          IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "TG" THEN cEstado = "En Almacén".
      END.
  END CASE.
  RETURN cEstado.
  */
  DEF VAR cEstado AS CHAR NO-UNDO.

  cEstado = T-RutaD.flgest.
  CASE T-RutaD.CodRef:
      WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
          IF T-RutaD.flgest = "P" THEN cEstado = "Por Entregar".
          IF T-RutaD.flgest = "C" THEN cEstado = "Cerrado".
          IF T-RutaD.flgest = "A" THEN cEstado = "Anulado".
          IF T-RutaD.flgest = "R" THEN cEstado = "Reprogramado".
      END.
  END CASE.

  RETURN cEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPendiente W-Win 
FUNCTION fPendiente RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF Faccpedi.coddoc = "OTR" THEN RETURN 0.00.

  DEF VAR x-Importe AS  DECI NO-UNDO.

  /* Buscamos comprobantes */
  DEF VAR lUbicado AS LOG INIT FALSE NO-UNDO.

  /* 12/08/2021: Se va a tomar el tipo de cambio venta de caja cobranza */
  FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= Faccpedi.FchPed NO-LOCK NO-ERROR.
  
  DEF BUFFER COMPROBANTES FOR Ccbcdocu.
  FOR EACH COMPROBANTES NO-LOCK WHERE COMPROBANTES.codcia = s-codcia AND
      COMPROBANTES.codcli = Faccpedi.codcli AND
      LOOKUP(COMPROBANTES.coddoc, 'FAC,BOL') > 0 AND
      COMPROBANTES.codped = Faccpedi.codref AND
      COMPROBANTES.nroped = Faccpedi.nroref AND
      COMPROBANTES.FmaPgo = "001" AND       /* 21/04/2023 Caso 69682 */
      COMPROBANTES.flgest <> "A":
      /*x-Importe = x-Importe + COMPROBANTES.SdoAct.*/
      IF AVAILABLE Gn-tccja THEN
          x-Importe = x-Importe + (IF COMPROBANTES.codmon = 2 THEN Gn-tccja.venta * COMPROBANTES.SdoAct ELSE COMPROBANTES.SdoAct).
      ELSE 
          x-Importe = x-Importe + (IF COMPROBANTES.codmon = 2 THEN Faccpedi.TpoCmb * COMPROBANTES.SdoAct ELSE COMPROBANTES.SdoAct).
      lUbicado = YES.
  END.
/*   IF lUbicado = NO THEN x-Importe = T-RutaD.Libre_d02. */
  RETURN x-Importe.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

