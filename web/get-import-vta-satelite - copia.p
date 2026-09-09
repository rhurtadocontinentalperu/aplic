&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE PEDI2 NO-UNDO LIKE VtaDDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INTE. 

DEF VAR s-CodVen AS CHAR NO-UNDO.
DEF VAR s-CodDoc AS CHAR INIT 'PET' NO-UNDO.
DEF VAR s-CodAlm AS CHAR NO-UNDO. 
DEF VAR pCodDiv AS CHAR NO-UNDO.
DEF VAR cCodCli AS CHAR NO-UNDO.
DEF VAR cCodRef AS CHAR INIT "PPX" NO-UNDO.
DEF VAR cNroRef AS CHAR NO-UNDO.
DEF VAR s-TpoPed AS CHAR NO-UNDO.
DEF VAR s-CodTer AS CHAR NO-UNDO.
DEF VAR s-NroDec AS INTE INIT 4 NO-UNDO.

DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

/* ***************************************************************** */
/* Pantalla de Mensajes */
/* ***************************************************************** */
DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.
/* ***************************************************************** */
/* ***************************************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI2 T "?" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.54
         WIDTH              = 60.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-RIQRA_Captura_Parametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RIQRA_Captura_Parametros Procedure 
PROCEDURE RIQRA_Captura_Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodVen AS CHAR.
DEF INPUT PARAMETER ppCodDiv AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pTpoPed AS CHAR.
DEF INPUT PARAMETER pCodTer AS CHAR.

s-CodVen = pCodVen.
pCodDiv = ppCodDiv.
s-CodAlm = pCodAlm.
s-TpoPed = pTpoPed.
S-CODTER = pCodTer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RIQRA_Import_Detail_OnLine) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RIQRA_Import_Detail_OnLine Procedure 
PROCEDURE RIQRA_Import_Detail_OnLine :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR I-NITEM AS INTE NO-UNDO.
DEF VAR pSugerido AS DEC NO-UNDO.
DEF VAR pEmpaque AS DEC NO-UNDO.

EMPTY TEMP-TABLE PEDI2.

DETALLES:
FOR EACH FacDVtaOnLine NO-LOCK WHERE FacDVtaOnLine.CodCia = FacCVtaOnLine.CodCia AND
        FacDVtaOnLine.CodDiv = FacCVtaOnLine.CodDiv AND
        FacDVtaOnLine.CodDoc = FacCVtaOnLine.CodDoc AND
        FacDVtaOnLine.NroPed = FacCVtaOnLine.NroPed,
    FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = FacDVtaOnLine.CodCia AND
        Almmmatg.codmat = FacDVtaOnLine.CodMat
    BY FacDVtaOnLine.CodMat:
    DISPLAY FacDVtaOnLine.codmat @ Fi-Mensaje WITH FRAME F-Proceso.
    /* GRABACION */
    I-NITEM = I-NITEM + 1.
    /* Se acumulan por cada sku y en unidades de stock */
    FIND FIRST PEDI2 WHERE PEDI2.codmat = FacDVtaOnLine.CodMat NO-ERROR.
    IF NOT AVAILABLE PEDI2 THEN CREATE PEDI2.
    BUFFER-COPY FacDVtaOnLine 
        EXCEPT FacDVtaOnLine.Libre_d05
        TO PEDI2
        ASSIGN 
        PEDI2.CodCia = s-codcia
        PEDI2.CodDiv = s-CodDiv
        PEDI2.CodPed = s-CodDoc      /* Normalmente PET */
        PEDI2.NroPed = ''
        PEDI2.NroItm = I-NITEM
        PEDI2.CanPed = PEDI2.CanPed + FacDVtaOnLine.CanPed
        PEDI2.CanAte = 0
        PEDI2.Libre_d01 = PEDI2.CanPed + FacDVtaOnLine.CanPed.
    /* *********************************************************************************************** */
    /* Cantidad Sugerida */
    /* *********************************************************************************************** */
    RUN vtagn/p-cantidad-sugerida-v2.r (INPUT s-CodDiv,
                                      INPUT pCodDiv,
                                      INPUT PEDI2.codmat,
                                      INPUT PEDI2.CanPed,
                                      INPUT PEDI2.UndVta,
                                      INPUT cCodCli,
                                      OUTPUT pSugerido,
                                      OUTPUT pEmpaque,
                                      OUTPUT pMensaje).
    /* RHC NO dar mensaje en caso de expolibreria Cesar Camus */
    IF pMensaje > '' THEN DO:
        MESSAGE "pMensaje " pMensaje.
        PEDI2.CanPed = pSugerido.
    END.
    IF PEDI2.CanPed <= 0 THEN DELETE PEDI2.
    /* *********************************************************************************************** */
    /* *********************************************************************************************** */
END.
HIDE FRAME F-Proceso.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RIQRA_Import_Master) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RIQRA_Import_Master Procedure 
PROCEDURE RIQRA_Import_Master :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Valores iniciales */
/* Número de Serie */
FIND FIRST FacCorre WHERE 
    FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDoc = s-CodDoc AND      /* PET */
    FacCorre.CodDiv = s-CodDiv AND
    FacCorre.FlgEst = YES NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMensaje = "NO está configurado el correlativo para el documento " + s-CodDoc.
    RETURN 'ADM-ERROR'.
END.
s-NroSer = FacCorre.NroSer.

SESSION:SET-WAIT-STATE('GENERAL'). 

/* 1ra Parte: Transfiere la información del satélite a FacCVtaOnLine y FacDVtaOnLine */
/*DISPLAY 'Importando RIQRA.....Un momento por favor' @ Fi-Mensaje WITH FRAME F-Proceso.*/
    DEFINE VAR hRiqra AS HANDLE NO-UNDO.
    RUN web/web-library.r PERSISTENT SET hRiqra.

    RUN web_api-riqra-import-horizontal IN hRiqra (INPUT s-CodVen,OUTPUT pMensaje).

    DELETE PROCEDURE hRiqra.   

    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        /*HIDE FRAME F-proceso.*/
        SESSION:SET-WAIT-STATE('').
        
        MESSAGE "VALOR RETORNO API:" SKIP pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    /*HIDE FRAME F-Proceso.*/

/* 2da. Parte: Transfiere la información de OnLine a VtaCDocu y VtaDDocu */
/* Por cada PEDIDO RIQRA armamos un PRE-PEDIDO */
IF TRUE <> (pCodDiv > '') THEN pCodDiv = s-CodDiv.  /* Ajuste Valor */

FOR EACH FacCVtaOnLine WHERE FacCVtaOnLine.codcia = s-codcia
    AND FacCVtaOnLine.codven = s-CodVen 
    /*AND FacCVtaOnLine.coddiv = s-CodDiv*/ /* 26Feb2024 : Carla Tenazoa/Rodolfo Salas, el vendedor puede vender en mas de una division */
    AND FacCVtaOnLine.flgest = "P" 
    AND FacCVtaOnLine.coddoc = cCodRef        /* OJO: Normalmente PPX */
    AND FacCVtaOnLine.codorigen = "RIQRA":
    ASSIGN
        cNroRef = FacCVtaOnLine.nroped.

    /* Cargamos PEDI2 */
    ASSIGN
        cCodCli = FacCVtaOnLine.CodCli.

    RUN RIQRA_Import_Detail_OnLine.    /* Carga PEDI2 */

    /* Generamos PET */
    IF NOT CAN-FIND(FIRST PEDI2 NO-LOCK) THEN NEXT.


    RUN RIQRA_Save_PrePed (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        SESSION:SET-WAIT-STATE('').
        RETURN 'ADM-ERROR'.
    END.        
        
END.
SESSION:SET-WAIT-STATE('').

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RIQRA_Save_Detail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RIQRA_Save_Detail Procedure 
PROCEDURE RIQRA_Save_Detail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

  FOR EACH PEDI2 NO-LOCK WHERE PEDI2.CanPed > 0 BY PEDI2.NroItm:
      I-NITEM = I-NITEM + 1.
      CREATE VtaDDocu.
      BUFFER-COPY PEDI2 TO VtaDDocu
          ASSIGN
              VtaDDocu.CodCia = VtaCDocu.CodCia
              VtaDDocu.CodDiv = VtaCDocu.CodDiv
              VtaDDocu.codped = VtaCDocu.codped
              VtaDDocu.NroPed = VtaCDocu.NroPed
              VtaDDocu.FchPed = VtaCDocu.FchPed
              VtaDDocu.FlgEst = VtaCDocu.FlgEst
              VtaDDocu.NroItm = I-NITEM.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RIQRA_Save_PrePed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RIQRA_Save_PrePed Procedure 
PROCEDURE RIQRA_Save_PrePed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-Cuenta AS INTE NO-UNDO.

FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':    
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = S-CODCIA ~ 
        AND FacCorre.CodDoc = S-CODDOC ~ 
        AND FacCorre.CodDiv = S-CODDIV ~ 
        AND Faccorre.NroSer = S-NroSer" ~ 
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~ 
        &Accion="RETRY" ~ 
        &Mensaje="NO" ~ 
        &txtMensaje="pMensaje" ~ 
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    
    CREATE VtaCDocu.
    BUFFER-COPY FacCVtaOnLine TO VtaCDocu
        ASSIGN 
        VtaCDocu.CodCia = S-CODCIA
        VtaCDocu.CodDiv = S-CODDIV
        VtaCDocu.CodPed = s-coddoc 
        VtaCDocu.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        VtaCDocu.FchPed = TODAY 
        VtaCDocu.CodAlm = S-CODALM
        VtaCDocu.PorIgv = FacCfgGn.PorIgv 
        VtaCDocu.Libre_c02 = s-TpoPed
        /*VtaCDocu.Libre_c03 = FILL-IN-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}*/
        VtaCDocu.CodSed = S-CODTER
        VtaCDocu.Libre_d01 = s-NroDec
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Campos Relacionados */
    ASSIGN
        VtaCDocu.CodRef = FacCVtaOnLine.CodDoc
        VtaCDocu.NroRef = FacCVtaOnLine.NroPed.
    /* 02/03/2024. C.Iman */
    ASSIGN
        VtaCDocu.CodOri = FacCVtaOnLine.CodOrigen.      /* RIQRA */
    /* 06/05/2024: C.Tenazoa HORIZONTAL */
    ASSIGN
        VtaCDocu.NroOri = FacCVtaOnLine.NroOrigen           /* RIQRA */
        vtaCdocu.tpolic = FacCVtaOnLine.cliente_recoge.     /* Ic - 21May2024 */
    /* Correlativo */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.
    /* Datos Adicionales */
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = VtaCDocu.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        IF TRUE <> (VtaCDocu.NomCli > '')   THEN VtaCDocu.NomCli = gn-clie.NomCli.
        IF TRUE <> (VtaCDocu.RucCli > '')   THEN VtaCDocu.RucCli = gn-clie.Ruc.
        IF TRUE <> (VtaCDocu.DirCli > '')   THEN VtaCDocu.DirCli = gn-clie.DirCli.
        IF TRUE <> (VtaCDocu.NroCard > '')  THEN VtaCDocu.NroCard = gn-clie.NroCard.
        IF TRUE <> (VtaCDocu.DniCli > '')   THEN VtaCDocu.DniCli  = gn-clie.DNI.
    END.
    FIND gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = VtaCDocu.codcli
        AND gn-clied.sede = VtaCDocu.sede
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clied THEN DO:
        IF TRUE <> (VtaCDocu.CodPos > '') THEN VtaCDocu.CodPos = Gn-ClieD.Codpos.
        VtaCDocu.Glosa = (IF TRUE <> (VtaCDocu.Glosa > '') 
                          THEN Gn-ClieD.DirCli ELSE VtaCDocu.Glosa).
    END.
    /* 01/12/2023: Solo una vez cuando es un nuevo pre-pedido  */
    IF VtaCDocu.CodRef = "PPX" THEN DO:
        DEF BUFFER b-FacCVtaOnLine FOR FacCVtaOnLine.
        FIND b-FacCVtaOnLine WHERE ROWID(b-FacCVtaOnLine) = ROWID(FacCVtaOnLine)
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE b-FacCVtaOnLine THEN DO:
            {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            b-FacCVtaOnLine.FlgEst = "C"
            b-FacCVtaOnLine.NCmpbnte = Vtacdocu.codped  + ',' + Vtacdocu.nroped.  /* OJO */
        RELEASE b-FacCVtaOnLine.
    END.
    ASSIGN 
        VtaCDocu.Hora = STRING(TIME,"HH:MM")
        VtaCDocu.Usuario = S-USER-ID
        VtaCDocu.Libre_c01 = pCodDiv.

    RUN RIQRA_Save_Detail.

    IF AVAILABLE(VtaCDocu) THEN RELEASE VtaCDocu.
    IF AVAILABLE(VtaDDocu) THEN RELEASE VtaDDocu.
END.
RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

