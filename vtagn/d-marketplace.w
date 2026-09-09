&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
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

&SCOPED-DEFINE ARITMETICA-SUNAT YES


/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.

DEF SHARED VAR s-CodDoc AS CHAR.
DEF SHARED VAR s-NroSer AS INT.
DEF SHARED VAR s-MinimoDiasDespacho AS DEC.
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-codven AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-TpoPed AS CHAR.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE Resumen LIKE Faccpedi
    FIELD CanPed LIKE Facdpedi.CanPed
    FIELD ImpLin LIKE Facdpedi.ImpLin
    FIELD CodMat LIKE Facdpedi.CodMat
    FIELD PreUni LIKE Facdpedi.PreUni
    FIELD Factor LIKE Facdpedi.Factor
    FIELD NroItm LIKE Facdpedi.NroItm
    FIELD UndVta LIKE Facdpedi.UndVta
    FIELD AftIgv LIKE Facdpedi.AftIgv
    FIELD PorDto2 LIKE Facdpedi.PorDto2
    FIELD Det_ImpIgv LIKE Facdpedi.ImpIgv
    FIELD Det_ImpLin LIKE Facdpedi.ImpLin
    FIELD DescWeb LIKE Facdpedi.DesMatWeb
    FIELD Departamento AS CHAR
    FIELD Provincia AS CHAR
    FIELD Distrito AS CHAR
    FIELD Telefono1 AS CHAR
    FIELD Telefono2 AS CHAR
    FIELD Sede_DirCli AS CHAR
    FIELD Sede_Departamento AS CHAR
    FIELD Sede_Provincia AS CHAR
    FIELD Sede_Distrito AS CHAR
    FIELD Sede_CodDept AS CHAR
    FIELD Sede_CodProv AS CHAR
    FIELD Sede_CodDist AS CHAR
    INDEX Idx00 AS PRIMARY codcia nroped.

DEF VAR pMensaje AS CHAR NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

/* Variables para el Excel */
DEF VAR x-Ok AS LOG.
DEF VAR x-Archivo AS CHAR NO-UNDO.

DEFINE VARIABLE lNuevoFile      AS LOG NO-UNDO.
DEFINE VARIABLE lFileXls        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-Market Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-Market 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/error.ico":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/ok.ico":U
     LABEL "OK" 
     SIZE 15 BY 1.69
     BGCOLOR 8 .

DEFINE VARIABLE RADIO-SET-Market AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ripley", 1,
"Sagafalabella", 2
     SIZE 30 BY 3.23
     FONT 8 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     RADIO-SET-Market AT ROW 2.08 COL 11 NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 6.38 COL 3
     Btn_Cancel AT ROW 6.38 COL 20
     SPACE(30.13) SKIP(1.45)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SELECCIONE MARKETPLACE"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
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
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* SELECCIONE MARKETPLACE */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN 
      RADIO-SET-Market.
  CASE RADIO-SET-Market:
      WHEN 1 THEN DO:       /* Ripley */
          SYSTEM-DIALOG GET-FILE x-Archivo
              FILTERS 'Archivo Excel (xls,xlsx)' '*.xls,*.xlsx'
              RETURN-TO-START-DIR
              TITLE 'Selecciona al archivo Excel'
              MUST-EXIST
              USE-FILENAME
              UPDATE x-Ok.
          IF x-Ok = NO THEN RETURN NO-APPLY.
          pMensaje = ''.
          RUN Ripley.
          IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
              IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          END.
      END.
      WHEN 2 THEN DO:       /* Sagafalabella */
          SYSTEM-DIALOG GET-FILE x-Archivo
              FILTERS 'Archivo CSV (csv)' '*.csv'
              RETURN-TO-START-DIR
              TITLE 'Selecciona al archivo CSV'
              MUST-EXIST
              USE-FILENAME
              UPDATE x-Ok.
          IF x-Ok = NO THEN RETURN NO-APPLY.
          pMensaje = ''.
          RUN Saga.
          IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
              IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          END.
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY RADIO-SET-Market 
      WITH FRAME D-Dialog.
  ENABLE RADIO-SET-Market Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Cotizaciones D-Dialog 
PROCEDURE Graba-Cotizaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-codmon AS INT.
DEF VAR s-tpocmb AS DEC.
DEF VAR s-nrodec AS INT.
DEF VAR s-PorIgv AS DEC.
DEF VAR s-Cmpbnte AS CHAR.
DEF VAR s-CodCli AS CHAR.

DEFINE VAR x-nroitm AS INT.
DEFINE VAR lxCostoEnvio  AS DEC.
DEFINE VAR x-CodMat AS CHAR.
DEFINE VAR x-Precio AS DEC.
DEFINE VAR x-CanPed AS DEC.
DEFINE VAR x-ImpLin AS DEC.
DEFINE VAR x-Precio-Sin-Igv AS DEC.
DEFINE VAR x-ImpIgv AS DEC.
DEFINE VAR pCuenta AS INTE NO-UNDO.

DEFINE BUFFER b-FacCorre FOR FacCorre.                                
DEFINE BUFFER b-Almmmatg FOR Almmmatg.

FIND b-FacCorre WHERE b-FacCorre.CodCia = S-CODCIA 
    AND b-FacCorre.CodDoc = S-CODDOC 
    AND b-FacCorre.NroSer = s-NroSer
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-facCorre THEN DO:
    pMensaje = 'Cod.Doc(' + s-coddoc + ") y Nro Serie(" + STRING(s-nroser,"999") + ") " +
            "No estan configurados".
    RETURN 'ADM-ERROR'.
END.
IF b-FacCorre.FlgEst = NO THEN DO:
    pMensaje = 'Esta serie está bloqueada para hacer movimientos'.
    RETURN 'ADM-ERROR'.
END.
MESSAGE 'Seguro de realizar el proceso?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.

IF rpta = NO THEN RETURN 'ADM-ERROR'.

DEF VAR pSede AS CHAR NO-UNDO.        

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
    FOR EACH Resumen NO-LOCK BREAK BY Resumen.NroPed:
        IF FIRST-OF(Resumen.NroPed) THEN DO:
            x-nroitm = 0.
            lxCostoEnvio = 0.
            /* Cabecera de la Cotizacion */
            RUN Registra-Cliente (OUTPUT pSede, OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
            /* Adiciono el NUEVO REGISTRO */
            ASSIGN
                s-PorIgv = FacCfgGn.PorIgv.
            ASSIGN
                s-CodCli = Resumen.CodCli
                s-CodMon = Resumen.CodMon
                s-TpoCmb = 1
                s-NroDec = 4
                .
            /* Tipo de Cambio */
            FIND FIRST TcmbCot WHERE  TcmbCot.Codcia = 0
                AND (TcmbCot.Rango1 <= TODAY - TODAY + 1 AND TcmbCot.Rango2 >= TODAY - TODAY + 1)
                NO-LOCK NO-ERROR.
            IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
            /* RHC 11.08.2014 TC Caja Compra */
            FOR EACH gn-tccja NO-LOCK BY Fecha:
                IF TODAY >= Fecha THEN s-TpoCmb = Gn-TCCja.Compra.
            END.
            CREATE Faccpedi.        /* OJO */
            BUFFER-COPY Resumen TO Faccpedi     /* OJO */
                ASSIGN 
                FacCPedi.NroPed = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
                /*FacCPedi.FchPed = TODAY*/         /* Vamos a tomar la del excel */
                FacCPedi.FchVen = FacCPedi.FchEnt   /* OJO */
                FacCPedi.TpoCmb = s-TpoCmb
                Faccpedi.codven = s-CodVen
                FacCPedi.CodPos = Resumen.CodPos
                FacCPedi.ubigeo[2] = Resumen.coddept
                FacCPedi.ubigeo[3] = Resumen.codprov
                FacCPedi.ubigeo[4] = Resumen.coddist
                Faccpedi.ImpDto2 = 0 
                Faccpedi.TpoPed = s-TpoPed
                NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
            ASSIGN
                FacCPedi.CodAlm = S-CODALM
                FacCPedi.PorIgv = s-PorIgv
                FacCPedi.FecAct = TODAY
                FacCPedi.UsrAct = s-User-Id
                FacCPedi.Hora = STRING(TIME,"HH:MM")
                FacCPedi.Usuario = S-USER-ID
                FacCPedi.Libre_c01 = s-CodDiv.  /* OJO */
            ASSIGN 
                FacCPedi.FlgEst = "P"   /* OJO */
                FacCPedi.CodMon = s-CodMon
                FacCPedi.Cmpbnte = "BOL"
                FacCPedi.Libre_d01  = s-NroDec
                FacCPedi.FlgIgv = YES.
            /* ******************************** */
            /* RHC 26/05/2020 Datos Adicionales */
            /* ******************************** */
            ASSIGN
                FacCPedi.OrdCmp = Resumen.NroRef
                FacCPedi.CustomerPurchaseOrder = Resumen.NroRef.
            /* ******************************** */
            FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = Resumen.codcli
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN DO:
                ASSIGN 
                    Faccpedi.NomCli = gn-clie.Nomcli
                    Faccpedi.DirCli = gn-clie.DirCli
                    Faccpedi.RucCli = gn-clie.Ruc
                    Faccpedi.Atencion = gn-clie.DNI
                    FacCPedi.NroCard = ""
                    Faccpedi.CodVen = "021"
                    Faccpedi.FaxCli = IF (AVAILABLE gn-clie) THEN SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                        SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2) ELSE ""
                            Faccpedi.Cmpbnte = 'BOL'.    
                ASSIGN 
                    Faccpedi.Cmpbnte = "BOL".
                IF Faccpedi.RucCli > "" THEN Faccpedi.Cmpbnte = "FAC".
                /* ------------------------------ */
            END.
            /* ********************************************************************************************** */
            /* UBIGEO POR DEFECTO */
            /* ********************************************************************************************** */
            IF FacCPedi.CodCli = x-ClientesVarios THEN
                ASSIGN
                    FacCPedi.LugEnt    = Gn-Clie.DirCli
                    FacCPedi.Sede      = ''
                    FacCPedi.CodPos    = Faccpedi.CodPos       /* Código Postal */
                    FacCPedi.Ubigeo[2] = Faccpedi.CodDept 
                    FacCPedi.Ubigeo[3] = Faccpedi.CodProv 
                    FacCPedi.Ubigeo[4] = Faccpedi.CodDist.
            ELSE DO:
                /* ********************************************************************************************** */
                /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
                /* ********************************************************************************************** */
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = Faccpedi.codcli
                    AND gn-clied.sede = pSede       /* "@@@" */
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied THEN
                    ASSIGN
                    FacCPedi.LugEnt    = Gn-ClieD.DirCli
                    FacCPedi.Sede      = Gn-ClieD.Sede
                    FacCPedi.CodPos    = Gn-ClieD.CodPos
                    FacCPedi.Ubigeo[1] = Gn-ClieD.Sede
                    FacCPedi.Ubigeo[2] = "@CL"
                    FacCPedi.Ubigeo[3] = Gn-ClieD.CodCli.
            END.
            /* ********************************************************************************************** */
        END.
        /* Detalle */
        FIND FIRST Almmmatg OF Resumen NO-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        FIND FIRST Almtfami OF Almmmatg NO-LOCK.
        FIND FIRST Almsfami OF Almmmatg NO-LOCK.
        x-NroItm = x-NroItm + 1.
        lxCostoEnvio = lxCostoEnvio + Resumen.ImpFle.
        CREATE FacDPedi.
        ASSIGN 
            FacDPedi.CodCia = FacCPedi.CodCia
            FacDPedi.CodDiv = FacCPedi.CodDiv
            FacDPedi.coddoc = FacCPedi.coddoc
            FacDPedi.NroPed = FacCPedi.NroPed
            FacDPedi.FchPed = FacCPedi.FchPed
            FacDPedi.Hora   = FacCPedi.Hora 
            FacDPedi.codmat = Resumen.CodMat
            FacDPedi.Factor = Resumen.factor 
            FacDPedi.CanPed = Resumen.Canped
            FacDPedi.NroItm = x-NroItm 
            FacDPedi.UndVta = Resumen.UndVta
            FacDPedi.ALMDES = S-CODALM
            FacDPedi.AftIgv = Resumen.AftIgv   /*(IF x-ImpIgv > 0 THEN YES ELSE NO)*/
            FacDPedi.ImpIgv = Resumen.Det_ImpIgv
            FacDPedi.ImpLin = Resumen.ImpLin /*+ Resumen.ImpDto2*/
            FacDPedi.PreUni = Resumen.PreUni
            FacDPedi.ImpDto = Resumen.ImpDto
            FacDPedi.ImpDto2 = Resumen.ImpDto2
            FacDPedi.PorDto2 = Resumen.porDto2.
        ASSIGN
            FacDPedi.CanPedWeb = Resumen.Canped
            FacDPedi.CodMatWeb = Resumen.CodMat
            FacDPedi.DesMatWeb = Resumen.DescWeb
            FacDPedi.ImpLinWeb = Resumen.ImpLin
            FacDPedi.PreUniWeb = Resumen.PreUni .
        /* ***************************************************************** */
        s-Cmpbnte = FacCPedi.Cmpbnte.
        {vtagn/CalculoDetalleMayorCredito.i &Tabla="Facdpedi" }
        /* ***************************************************************** */
        IF LAST-OF(Resumen.NroPed) THEN DO:
            /* FLETE */
            IF lxCostoEnvio > 0 THEN DO:
                /* Buscar el codigo como interno del FLETE */
                x-CodMat = '044939'.
                /* Se ubico el Codigo Interno  */
                FIND b-Almmmatg WHERE b-Almmmatg.codcia = s-codcia
                    AND b-Almmmatg.codmat = x-codmat
                    AND b-Almmmatg.tpoart <> 'D'
                    NO-LOCK NO-ERROR.
                IF AVAILABLE b-Almmmatg THEN DO:
                    /* Cantidad pedida */
                    x-CanPed = 1.
                    x-ImpIgv = 0.
                    /* El precio final ?????????????*/
                    x-Precio =  x-CanPed * lxCostoEnvio.
                    /**/
                    x-ImpLin = x-Precio .
                    x-Precio = ROUND(x-ImpLin / x-CanPed, 5).
                    x-Precio-Sin-Igv = x-Precio * 100 / (1 + s-PorIgv / 100).
                    /* Verificar el IGV */
                    IF x-precio > x-precio-sin-igv THEN DO:
                        x-ImpIgv = x-ImpLin - (x-CanPed * x-precio-sin-igv).
                    END.                        
                    /* Items */
                    x-NroItm = x-NroItm + 1.
                    CREATE  FacDPedi.
                    ASSIGN 
                        FacDPedi.CodCia = FacCPedi.CodCia
                        FacDPedi.CodDiv = FacCPedi.CodDiv
                        FacDPedi.coddoc = FacCPedi.coddoc
                        FacDPedi.NroPed = FacCPedi.NroPed
                        FacDPedi.FchPed = FacCPedi.FchPed
                        FacDPedi.Hora   = FacCPedi.Hora 
                        FacDPedi.codmat = x-CodMat
                        FacDPedi.Factor = 1
                        FacDPedi.CanPed = x-CanPed
                        FacDPedi.NroItm = x-NroItm 
                        FacDPedi.UndVta = (IF AVAILABLE b-Almmmatg THEN b-Almmmatg.UndStk ELSE '')
                        FacDPedi.ALMDES = S-CODALM
                        FacDPedi.AftIgv = b-Almmmatg.AftIgv   /*(IF x-ImpIgv > 0 THEN YES ELSE NO)*/
                        FacDPedi.ImpIgv = x-ImpIgv
                        FacDPedi.ImpLin = x-ImpLin
                        FacDPedi.PreUni = x-Precio
                        FacDPedi.Libre_c05 = "FLETE".
                    IF FacDPedi.AftIgv THEN FacDPedi.ImpIgv = FacDPedi.ImpLin - ROUND( FacDPedi.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
                    ELSE FacDPedi.ImpIgv = 0.
                    /* DATOS LISTA EXPRESS */
                    ASSIGN
                        FacDPedi.CanPedWeb = x-CanPed
                        FacDPedi.CodMatWeb = x-CodMat
                        FacDPedi.DesMatWeb = "FLETE"
                        FacDPedi.ImpLinWeb = x-ImpLin
                        FacDPedi.PreUniWeb = x-Precio.
                END.
            END.
            /* ********************************************************************************************** */
            /* Ic 10Feb2016 - Metodo de Pago Lista Express */
            DEFINE BUFFER i-vtatabla FOR vtatabla.
            DEFINE VAR lxDescuentos AS DEC.    
            DEFINE VAR lxdsctosinigv AS DEC.
            /* Ic - 17Ene2018, ListaExpress desde IVERSA */
            CREATE i-vtatabla.
            ASSIGN 
                i-vtatabla.codcia = s-codcia
                i-vtatabla.tabla = 'MTPGLSTEXPRS'
                i-vtatabla.llave_c1 = FacCPedi.NroPed
                i-vtatabla.llave_c2 = FacCPedi.NroPed /*tt-MetodPagoListaExpress.tt-pedidoweb*/
                i-vtatabla.llave_c3 = FacCPedi.OrdCmp /*tt-MetodPagoListaExpress.tt-metodopago*/
                i-vtatabla.llave_c5 = ""  /*tt-MetodPagoListaExpress.tt-tipopago                        */
                i-vtatabla.llave_c4 = ""  /*tt-MetodPagoListaExpress.tt-nombreclie*/
                i-vtatabla.valor[1] = 0   /*tt-MetodPagoListaExpress.tt-preciopagado*/
                i-vtatabla.valor[2] = 0   /*tt-MetodPagoListaExpress.tt-preciounitario*/
                i-vtatabla.valor[3] = 0   /*tt-MetodPagoListaExpress.tt-costoenvio                          */
                i-vtatabla.valor[4] = 0.   /*tt-MetodPagoListaExpress.tt-descuento.  Importe*/  
            lxDescuentos = i-vtatabla.valor[4].
            lxDescuentos = 0.
            lxdsctosinigv = 0.
            IF lxDescuentos > 0  THEN DO:
                  lxdsctosinigv = (lxDescuentos * 100) / 118.
            END.
            ASSIGN 
                faccpedi.impdto2 = lxDescuentos
                faccpedi.importe[3] = lxdsctosinigv.
            RELEASE i-vtatabla.
            /* ************************ */
            /* TOTAL GENERAL COTIZACION */
            /* ************************ */
           /* ****************************************************************************************** */
           /* ****************************************************************************************** */
           &IF {&ARITMETICA-SUNAT} &THEN
             {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
             /* ****************************************************************************************** */
             /* Importes SUNAT */
             /* ****************************************************************************************** */
             DEFINE VAR hproc AS HANDLE NO-UNDO.
             RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
             RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                          INPUT Faccpedi.CodDoc,
                                          INPUT Faccpedi.NroPed,
                                          OUTPUT pMensaje).
             IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
             DELETE PROCEDURE hProc.
           &ELSE
             {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
             /* ****************************************************************************************** */
             /* Importes SUNAT */
             /* NO actualiza importes Progress */
             /* ****************************************************************************************** */
             DEFINE VAR hproc AS HANDLE NO-UNDO.
             RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
             RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                          INPUT Faccpedi.CodDoc,
                                          INPUT Faccpedi.NroPed,
                                          OUTPUT pMensaje).
             IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
             DELETE PROCEDURE hProc.
           &ENDIF
        END.
    END.
END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Cliente D-Dialog 
PROCEDURE Registra-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pSede AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR cEvento AS CHAR INIT "CREATE" NO-UNDO.
DEF VAR x-Cuenta AS INT NO-UNDO.

IF Resumen.CodCli = x-ClientesVarios THEN RETURN 'OK'.

FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
    AND gn-clie.codcli = Resumen.CodCli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN DO:
    CREATE gn-clie.
    ASSIGN
        gn-clie.CodCia      = cl-codcia
        gn-clie.CodCli      = Resumen.CodCli
        gn-clie.Libre_C01   = "N"
        gn-clie.NomCli      = CAPS(Resumen.NomCli)
        gn-clie.DirCli      = CAPS(Resumen.DirCli)
        gn-clie.Ruc         = Resumen.RucCli
        gn-clie.DNI         = Resumen.DNICli
        gn-clie.clfCli      = "C" 
        gn-clie.CodPais     = "01" 
        gn-clie.CodVen      = Resumen.CodVen
        gn-clie.CndVta      = Resumen.FmaPgo
        gn-clie.Fching      = TODAY 
        gn-clie.usuario     = S-USER-ID 
        gn-clie.TpoCli      = "1"
        gn-clie.CodDiv      = Resumen.CodDiv
        gn-clie.Rucold      = "NO"
        gn-clie.Libre_L01   = NO
        gn-clie.FlgSit      = 'A'    /* Activo */
        gn-clie.FlagAut     = 'A'   /* Autorizado */
        gn-clie.CodDept     = Resumen.CodDept 
        gn-clie.CodProv     = Resumen.CodProv 
        gn-clie.CodDist     = Resumen.CodDist
        gn-clie.E-Mail      = Resumen.E-Mail
        gn-clie.Telfnos[1]  = Resumen.TelephoneContactReceptor
        gn-clie.SwCargaSunat = "N"
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    cEvento = "CREATE".
    /* ****************************************************************************** */
    /* Datos Adicionales */
    /* ****************************************************************************** */
    IF gn-clie.codcli BEGINS '20' THEN gn-clie.Libre_C01   = "J".
    IF gn-clie.codcli BEGINS '15' OR gn-clie.codcli BEGINS '17' THEN gn-clie.Libre_C01   = "E".
    /* ****************************************************************************** */
    /* RHC 24/06/2020 Agregar información a la dirección */
    /* ****************************************************************************** */
    /* Armado de la dirección */
    DEF VAR pAddress AS CHAR NO-UNDO.
    pAddress = CAPS(Resumen.DirCli).
    FIND TabDepto WHERE TabDepto.CodDepto = Resumen.CodDept NO-LOCK NO-ERROR.
    FIND TabProvi WHERE TabProvi.CodDepto = Resumen.CodDept AND
        TabProvi.CodProvi = Resumen.CodProv NO-LOCK NO-ERROR.
    FIND TabDistr WHERE TabDistr.CodDepto = Resumen.CodDept AND
        TabDistr.CodProvi = Resumen.CodProv AND
        TabDistr.CodDistr = Resumen.CodDist NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto AND AVAILABLE TabProvi AND AVAILABLE TabDistr THEN DO:
        pAddress = TRIM(pAddress) + ' ' + 
                    CAPS(TRIM(TabDepto.NomDepto)) + ' - ' +
                    CAPS(TRIM(TabProvi.NomProvi)) + ' - ' +
                    CAPS(TabDistr.NomDistr).
    END.
    ASSIGN
        Gn-Clie.DirCli = pAddress.
    /* Actualizamos datos COTIZACION */
    ASSIGN
        Resumen.NomCli = Gn-Clie.NomCli
        Resumen.DirCli = Gn-Clie.DirCli.
END.
ELSE DO:
    FIND CURRENT gn-clie EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    cEvento = "UPDATE".
END.
/* Disparamos Triggers */
/* Si es cliente nuevo va a crear la sede @@@ */
RELEASE gn-clie.
/* ****************************************************************************** */
/* RHC Control de Sede del Cliente */
/* Nota: Lo vamos a controlar por dirección de entrega */
/* ****************************************************************************** */
/* Direccion */
IF TRUE <> (Resumen.Sede_DirCli > '') THEN RETURN 'OK'.     /* Siguiente registro */

FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
    AND gn-clie.codcli = Resumen.CodCli
    NO-LOCK NO-ERROR.
FIND FIRST gn-clied OF gn-clie WHERE gn-clied.DirCli BEGINS Resumen.Sede_DirCli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clied THEN DO:
    DEFINE VAR x-correlativo AS INT INIT 0.

    DEF BUFFER x-gn-clied FOR gn-clied.

    FOR EACH x-gn-clieD OF gn-clie NO-LOCK:
        IF x-gn-clieD.sede <> '@@@' THEN DO:
            ASSIGN 
                x-correlativo = MAXIMUM(INTEGER(TRIM(x-gn-clieD.sede)),x-correlativo)
                NO-ERROR.
        END.
    END.
    CREATE gn-clied.
    ASSIGN
        Gn-ClieD.CodCia = gn-clie.codcia
        Gn-ClieD.CodCli = gn-clie.codcli
        Gn-ClieD.FchCreacion = TODAY
        Gn-ClieD.Sede = STRING(x-correlativo + 1,"9999")
        Gn-ClieD.UsrCreacion = s-user-id
        Gn-ClieD.DomFiscal = NO
        Gn-ClieD.SwSedeSunat = "M"   /* MANUAL */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
ELSE DO:
    FIND CURRENT gn-clied EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
/* Armado de la dirección */
pAddress = CAPS(Resumen.Sede_DirCli).

FIND TabDepto WHERE TabDepto.CodDepto = Resumen.Sede_CodDept NO-LOCK NO-ERROR.
FIND TabProvi WHERE TabProvi.CodDepto = Resumen.Sede_CodDept AND
    TabProvi.CodProvi = Resumen.Sede_CodProv NO-LOCK NO-ERROR.
FIND TabDistr WHERE TabDistr.CodDepto = Resumen.Sede_CodDept AND
    TabDistr.CodProvi = Resumen.Sede_CodProv AND
    TabDistr.CodDistr = Resumen.Sede_CodDist NO-LOCK NO-ERROR.
IF AVAILABLE TabDepto AND AVAILABLE TabProvi AND AVAILABLE TabDistr THEN DO:
    pAddress = TRIM(pAddress) + ' ' + 
                CAPS(TRIM(TabDepto.NomDepto)) + ' - ' +
                CAPS(TRIM(TabProvi.NomProvi)) + ' - ' +
                CAPS(TabDistr.NomDistr).
END.
ASSIGN
    Gn-ClieD.CodDept = Resumen.Sede_CodDept
    Gn-ClieD.CodProv = Resumen.Sede_CodProv
    Gn-ClieD.CodDist = Resumen.Sede_CodDist
    Gn-ClieD.DirCli  = pAddress
    Gn-ClieD.Referencias = Resumen.ReferenceAddress
    Gn-ClieD.Libre_c04 = Resumen.TelephoneContactReceptor 
    Gn-ClieD.Libre_c05 = Resumen.ContactReceptorName.
FIND TabDistr WHERE TabDistr.CodDepto = Gn-ClieD.CodDept AND
    TabDistr.CodProvi = Gn-ClieD.CodProv AND
    TabDistr.CodDistr = Gn-ClieD.CodDist
    NO-LOCK NO-ERROR.
IF AVAILABLE TabDistr THEN DO:
    ASSIGN
        Gn-ClieD.Codpos = TabDistr.CodPos NO-ERROR.
END.
ASSIGN
    pSede = Gn-ClieD.Sede.      /* OJO */

RELEASE Gn-ClieD.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ripley D-Dialog 
PROCEDURE Ripley :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Inicializamos variables del excel */
ASSIGN
    lNuevoFile = NO
    lFileXls = x-Archivo.

{lib\excel-open-file.i}

ASSIGN
    lCerrarAlTerminar = YES
    lMensajeAlTerminar = NO.
/* ******************************************************************************** */
/* LOGICA PRINCIPAL */
/* ******************************************************************************** */
DEF VAR x-Cuenta AS INTE NO-UNDO.
DEF VAR cEvento AS CHAR INIT "CREATE" NO-UNDO.

/* ******************************************************************************** */
/* 1ro. Cargamos el Archivo Temporal con las Ventas */ 
/* ******************************************************************************** */
EMPTY TEMP-TABLE Resumen.
iColumn = 1.
/* Control del registro */
cRange = "A" + TRIM(STRING(iColumn)).
cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
IF cValue <> "TIENDA" THEN DO:
    pMensaje = "NO es un archivo válido de RIPLEY".
    RETURN 'ADM-ERROR'.
END.
REPEAT:
    iColumn = iColumn + 1.
    /* Control del registro */
    cRange = "A" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF TRUE <> (cValue > '') THEN LEAVE.    /* Fin de lectura */

    CREATE Resumen.

    /* Número de Pedido */
    cRange = "C" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    ASSIGN
        Resumen.CodCia = s-CodCia
        Resumen.CodDiv = s-CodDiv
        Resumen.CodDoc = s-CodDoc       /* "COT" */
        Resumen.NroPed = cValue
        Resumen.NroRef = cValue
        Resumen.FchPed = TODAY
        Resumen.Usuario = s-User-Id
        Resumen.CodVen = '020'
        Resumen.FmaPgo = '001'
        .
    /* Fecha */
    cRange = "Z" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    ASSIGN
        Resumen.FchPed = DATE(ENTRY(1,cValue,' ')).
    cRange = "AA" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    ASSIGN
        Resumen.FchEnt = DATE(ENTRY(1,cValue,' ')).
    /* Cantidad */
    cRange = "D" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.CanPed = chWorkSheet:Range(cRange):VALUE.
    /* Importe */
    cRange = "G" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.ImpLin = chWorkSheet:Range(cRange):VALUE.
    /* Moneda */
    cRange = "H" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF cValue = "PEN" THEN ASSIGN Resumen.CodMon = 1.
    ELSE ASSIGN Resumen.CodMon = 2.
    /* Artículo */
    cRange = "L" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.CodMat = TRIM(chWorkSheet:Range(cRange):VALUE)
        Resumen.Factor = 1.     /* OJO */
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = Resumen.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN 
        ASSIGN
        Resumen.UndVta = Almmmatg.UndStk
        Resumen.AftIgv = Almmmatg.AftIgv.
    /* Unitario */
    cRange = "Q" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.PreUni = chWorkSheet:Range(cRange):VALUE.
    /* Flete */
    cRange = "S" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.ImpFle = chWorkSheet:Range(cRange):VALUE.
    /* ******************************************************************************** */
    /* DATOS DEL CLIENTE */
    /* ******************************************************************************** */
    cRange = "BM" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.CodCli = TRIM(chWorkSheet:Range(cRange):VALUE).
    ASSIGN
        Resumen.CodCli = FILL('0', (11 - LENGTH(Resumen.CodCli))) + Resumen.CodCli.
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
        AND gn-clie.codcli = Resumen.CodCli
        NO-LOCK NO-ERROR.
    cRange = "AW" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.NomCli = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "AX" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.NomCli = TRIM(Resumen.NomCli + ' ' + TRIM(chWorkSheet:Range(cRange):VALUE)).
    cRange = "AZ" + TRIM(STRING(iColumn)).
    /* DNI */
    cRange = "BM" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.DNICli = TRIM(chWorkSheet:Range(cRange):VALUE).
    /* Telefonos */
    cRange = "BG" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.Telefono1 = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "BH" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.Telefono2 = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "AR" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.TelephoneContactReceptor = TRIM(chWorkSheet:Range(cRange):VALUE).
    /* ****************************************************************************** */
    /* Direccion */
    /* ****************************************************************************** */
    cRange = "AZ" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.DirCli = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "BA" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.Departamento = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "BE" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.Provincia = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "BD" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.Distrito = TRIM(chWorkSheet:Range(cRange):VALUE).
    FIND TabDepto WHERE TabDepto.NomDepto = Resumen.Departamento NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN DO:
        ASSIGN
            Resumen.CodDept = TabDepto.CodDepto.
        FIND TabProvi WHERE TabProvi.CodDepto = TabDepto.CodDepto
            AND TabProvi.NomProvi = Resumen.Provincia
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabProvi THEN DO:
            ASSIGN
                Resumen.CodProv = TabProvi.CodProvi .
            FIND TabDistr WHERE TabDistr.CodDepto = TabProvi.CodDepto 
                AND TabDistr.CodProvi = TabProvi.CodProvi
                AND TabDistr.NomDistr = Resumen.Distrito
                NO-LOCK NO-ERROR.
            IF AVAILABLE TabDistr THEN Resumen.CodDist = TabDistr.CodDistr.
        END.
    END.
    /* ****************************************************************************** */
    /* RHC Control de Sede del Cliente */
    /* Nota: Lo vamos a controlar por dirección de entrega */
    /* ****************************************************************************** */
    /* Direccion */
    cRange = "AK" + TRIM(STRING(iColumn)).
    cValue = TRIM(chWorkSheet:Range(cRange):VALUE).
    IF TRUE <> (cValue > '') THEN NEXT.     /* Siguiente registro */

    ASSIGN
        Resumen.Sede_DirCli = cValue.
    cRange = "AL" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.Sede_Departamento = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "AP" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.Sede_Provincia = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "AO" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.Sede_Distrito = TRIM(chWorkSheet:Range(cRange):VALUE).
    FIND TabDepto WHERE TabDepto.NomDepto = Resumen.Sede_Departamento NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN DO:
        ASSIGN
            Resumen.Sede_CodDept = TabDepto.CodDepto.
        FIND TabProvi WHERE TabProvi.CodDepto = TabDepto.CodDepto
            AND TabProvi.NomProvi = Resumen.Sede_Provincia
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabProvi THEN DO:
            ASSIGN
                Resumen.Sede_CodProv = TabProvi.CodProvi.
            FIND TabDistr WHERE TabDistr.CodDepto = TabProvi.CodDepto 
                AND TabDistr.CodProvi = TabProvi.CodProvi
                AND TabDistr.NomDistr = Resumen.Sede_Distrito
                NO-LOCK NO-ERROR.
            IF AVAILABLE TabDistr THEN Resumen.Sede_CodDist = TabDistr.CodDistr.
        END.
    END.
    cRange = "AR" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.TelephoneContactReceptor = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "AH" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.ContactReceptorName = TRIM(chWorkSheet:Range(cRange):VALUE).
    cRange = "AI" + TRIM(STRING(iColumn)).
    ASSIGN
        Resumen.ContactReceptorName = TRIM( Resumen.ContactReceptorName + ' ' +
                                            TRIM(chWorkSheet:Range(cRange):VALUE) ).
END.
/* Cerrar el Excel  */
{lib\excel-close-file.i}

/* ******************************************************************************** */
/* 2do. Grabamos las Cotizaciones */
/* ******************************************************************************** */
pMensaje = ''.
RUN Graba-Cotizaciones.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saga D-Dialog 
PROCEDURE Saga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       archivo CSV delimitado por comas
------------------------------------------------------------------------------*/

/* Inicializamos variables  */
ASSIGN
    lNuevoFile = NO
    lFileXls = x-Archivo.

DEF VAR MyRow AS CHAR EXTENT 14 NO-UNDO.    /* por los # de columnas */

/* ******************************************************************************** */
/* LOGICA PRINCIPAL */
/* ******************************************************************************** */
DEF VAR x-Cuenta AS INTE NO-UNDO.
DEF VAR cEvento AS CHAR INIT "CREATE" NO-UNDO.

/* ******************************************************************************** */
/* 1ro. Cargamos el Archivo Temporal con las Ventas */ 
/* ******************************************************************************** */
EMPTY TEMP-TABLE Resumen.
DEF VAR x-Contador AS INTE INIT 0 NO-UNDO.

INPUT FROM VALUE(lFileXls).
REPEAT:
    IMPORT DELIMITER "," myRow.
    MESSAGE myrow[1] myrow[2] myrow[3].
    IF TRUE <> (myRow[1] > '') THEN LEAVE.
    x-Contador = x-Contador + 1.
    IF x-Contador = 1 AND myRow[1] <> 'FECHA DE COMPRA' THEN DO:
        pMensaje = "NO es un archivo válido de RIPLEY".
        RETURN 'ADM-ERROR'.
    END.
    /* Saltamos el primer registro */
    IF x-Contador = 1 THEN NEXT.

    CREATE Resumen.
    /* Control del registro */
    ASSIGN
        Resumen.CodCia = s-CodCia
        Resumen.CodDiv = s-CodDiv
        Resumen.CodDoc = s-CodDoc       /*"COT"*/
        Resumen.NroPed = myRow[2]
        Resumen.NroRef = myRow[2]
        Resumen.FchPed = TODAY
        Resumen.Usuario = s-User-Id
        Resumen.CodVen = '020'
        Resumen.FmaPgo = '001'
        .
    /* Fecha */
    ASSIGN
        Resumen.FchPed = DATE(ENTRY(1,myRow[1],' ')).
    ASSIGN
        Resumen.FchEnt = DATE(myRow[11]).
    /* Cantidad */
    ASSIGN
        Resumen.CanPed = DECIMAL(myRow[9]).
    /* Unitario */
    ASSIGN
        Resumen.PreUni = DECIMAL(myRow[10]).
    /* Importe */
    ASSIGN
        Resumen.ImpLin = Resumen.CanPed * Resumen.PreUni.
    /* Moneda */
    ASSIGN Resumen.CodMon = 1.
    /* Artículo */
    ASSIGN
        Resumen.CodMat = myRow[7]
        Resumen.Factor = 1.     /* OJO */
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = Resumen.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN 
        ASSIGN
        Resumen.UndVta = Almmmatg.UndStk
        Resumen.AftIgv = Almmmatg.AftIgv.
    /* ******************************************************************************** */
    /* DATOS DEL CLIENTE */
    /* ******************************************************************************** */
    ASSIGN
        Resumen.CodCli = myRow[13].
    ASSIGN
        Resumen.CodCli = FILL('0', (11 - LENGTH(Resumen.CodCli))) + Resumen.CodCli.
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
        AND gn-clie.codcli = Resumen.CodCli
        NO-LOCK NO-ERROR.
    ASSIGN
        Resumen.NomCli = myRow[14].
    ASSIGN
        Resumen.DNICli = myRow[13].
END.
INPUT CLOSE.
/* ******************************************************************************** */
/* 2do. Grabamos las Cotizaciones */
/* ******************************************************************************** */
pMensaje = ''.
RUN Graba-Cotizaciones.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

