&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE BONIFICACION NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.



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

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN DO:
    MESSAGE 'NO se pudo ubicar el documento origen' VIEW-AS ALERT-BOX  ERROR.
    RETURN 'ADM-ERROR'.
END.

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-CodDoc AS CHAR NO-UNDO.                         
DEF VAR x-NroDoc AS CHAR NO-UNDO.
DEF VAR pCodDiv AS CHAR NO-UNDO.
DEF VAR s-TpoPed AS CHAR NO-UNDO.

x-CodDoc = Faccpedi.CodDoc + "*".
x-NroDoc = Faccpedi.NroPed.
pCodDiv = Faccpedi.Libre_c01.
s-TpoPed = Faccpedi.TpoPed.
                         
/* Se barren las NPC* para generar las COT */
DEF BUFFER B-CDOCU FOR Faccpedi.
DEF BUFFER B-DDOCU FOR Facdpedi.

DEF VAR s-CodDoc AS CHAR INIT "COT" NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR I-NITEM AS INTE NO-UNDO.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDoc = s-CodDoc AND
    FacCorre.CodDiv = s-CodDiv AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO hay correlativo refido para esta división' VIEW-AS ALERT-BOX  ERROR.
    RETURN 'ADM-ERROR'.
END.
s-NroSer = FacCorre.NroSer.

DEF VAR s-DiasVtoCot AS INTE NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' pCodDiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot.

DEF VAR x-articulo-ICBPer AS CHAR INIT '099268'.

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
      TABLE: BONIFICACION T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia 
        AND B-CDOCU.CodDiv = s-CodDiv
        AND B-CDOCU.CodDoc = x-CodDoc
        AND B-CDOCU.NroPed BEGINS x-NroDoc:
        {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
        /* ********************************************************************************************* */
        /* Cargamos Detalle */
        /* ********************************************************************************************* */
        EMPTY TEMP-TABLE ITEM.
        FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
            CREATE ITEM.
            BUFFER-COPY B-DDOCU TO ITEM.
        END.
        /* ********************************************************************************************* */
        /* Creamos Cabecera */
        /* ********************************************************************************************* */
        CREATE Faccpedi.
        BUFFER-COPY B-CDOCU EXCEPT B-CDOCU.Libre_c02        /* NO los grupos */
            TO Faccpedi
            ASSIGN
                FacCPedi.CodDoc = s-coddoc 
                FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN 
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        ASSIGN 
            FacCPedi.FchPed = TODAY 
            FacCPedi.FchVen = TODAY + s-DiasVtoCot
            FacCPedi.Hora   = STRING(TIME,"HH:MM:SS")
            FacCPedi.FlgEst = (IF FacCPedi.CodCli BEGINS "SYS" THEN "I" ELSE "P")     /* APROBADO */
            FacCPedi.Lista_de_Precios = FacCPedi.Libre_c01      /* OJO */
            NO-ERROR.
        /* DATOS SUPERMERCADOS */
/*         CASE Faccpedi.TpoPed:                                                  */
/*             WHEN "S" THEN DO:                                                  */
/*                 IF s-Import-Ibc = YES THEN FacCPedi.Libre_C05 = "1".           */
/*                 IF s-Import-B2B = YES THEN FacCPedi.Libre_C05 = "3".  /* OJO*/ */
/*             END.                                                               */
/*         END CASE.                                                              */
/*         /*  */                                                                 */
/*         IF lOrdenGrabada > '' THEN DO:                                         */
/*             DISABLE TRIGGERS FOR LOAD OF factabla.                             */
/*             FIND FIRST factabla WHERE factabla.codcia = s-codcia AND           */
/*                 factabla.tabla = 'OC PLAZA VEA' AND                            */
/*                 factabla.codigo = lOrdenGrabada EXCLUSIVE NO-ERROR.            */
/*             IF NOT AVAILABLE factabla THEN DO:                                 */
/*                 CREATE factabla.                                               */
/*                 ASSIGN                                                         */
/*                     factabla.codcia = s-codcia                                 */
/*                     factabla.tabla = 'OC PLAZA VEA'                            */
/*                     factabla.codigo = lOrdenGrabada                            */
/*                     factabla.campo-c[2] = STRING(NOW,"99/99/9999 HH:MM:SS").   */
/*             END.                                                               */
/*         END.                                                                   */
        /* RHC 05/10/17 En caso de COPIAR una cotizacion hay que "limpiar" estos campos */
        ASSIGN
            Faccpedi.Libre_c02 = ""       /* "PROCESADO" por Abastecimientos */
            Faccpedi.LugEnt2   = ""
            .
        /* Control si el Cliente Recoge */
        IF FacCPedi.Cliente_Recoge = NO THEN FacCPedi.CodAlm = ''.
        /* ********************************************************************************************* */
        /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
        /* ********************************************************************************************* */
        RUN impuesto-icbper. 
        /* ********************************************************************************************* */
        /* ******************************************** */
        /* RHC 19/050/2021 Datos para HOMOLOGAR las COT */
        /* ******************************************** */
        ASSIGN
            FacCPedi.CustomerPurchaseOrder = Faccpedi.OrdCmp.
        /* ******************************************** */
        /* ******************************************** */
        I-NITEM = 0.
        FOR EACH ITEM,
            FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
            BY ITEM.NroItm:
            I-NITEM = I-NITEM + 1.
            CREATE FacDPedi.
            BUFFER-COPY ITEM 
                TO FacDPedi
                ASSIGN
                    FacDPedi.CodCia = FacCPedi.CodCia
                    FacDPedi.CodDiv = FacCPedi.CodDiv
                    FacDPedi.coddoc = FacCPedi.coddoc
                    FacDPedi.NroPed = FacCPedi.NroPed
                    FacDPedi.FchPed = FacCPedi.FchPed
                    FacDPedi.Hora   = FacCPedi.Hora 
                    FacDPedi.FlgEst = FacCPedi.FlgEst
                    FacDPedi.NroItm = I-NITEM.
        END.
        /* ****************************************************************************************** */
        /* RHC 02/01/2020 Promociones proyectadas */
        /* ****************************************************************************************** */
        EMPTY TEMP-TABLE ITEM.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            CREATE ITEM.
            BUFFER-COPY Facdpedi TO ITEM.
        END.
        RUN vtagn/p-promocion-general.r (INPUT Faccpedi.CodDiv,
                                         INPUT Faccpedi.CodDoc,
                                         INPUT Faccpedi.NroPed,
                                         INPUT TABLE ITEM,
                                         OUTPUT TABLE BONIFICACION,
                                         OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
        I-NITEM = 0.
        FOR EACH BONIFICACION,
            FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND 
            Almmmatg.codmat = BONIFICACION.codmat
            BY BONIFICACION.NroItm:
            I-NITEM = I-NITEM + 1.
            CREATE FacDPedi.
            BUFFER-COPY BONIFICACION
                TO FacDPedi
                ASSIGN
                    FacDPedi.CodCia = FacCPedi.CodCia
                    FacDPedi.CodDiv = FacCPedi.CodDiv
                    FacDPedi.coddoc = "CBO"   /* Bonificacion en COT */
                    FacDPedi.NroPed = FacCPedi.NroPed
                    FacDPedi.FchPed = FacCPedi.FchPed
                    FacDPedi.Hora   = FacCPedi.Hora 
                    FacDPedi.FlgEst = FacCPedi.FlgEst
                    FacDPedi.NroItm = I-NITEM.
        END.
        /* ****************************************************************************************** */
        /* ****************************************************************************************** */
        {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
        /* ****************************************************************************************** */
        IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
        IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
        IF AVAILABLE(gn-clie)  THEN RELEASE Gn-Clie.
    END.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-impuesto-icbper) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impuesto-icbper Procedure 
PROCEDURE impuesto-icbper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
  DEFINE VAR x-ultimo-item AS INT.
  DEFINE VAR x-cant-bolsas AS INT.
  DEFINE VAR x-precio-ICBPER AS DEC.
  DEFINE VAR x-alm-des AS CHAR INIT "".

  x-ultimo-item = -1.
  x-cant-bolsas = 0.
  x-precio-ICBPER = 0.0.

  /* Sacar el importe de bolsas plasticas */
  DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */
  
  RUN ccb\libreria-ccb.p PERSISTENT SET z-hProc.
  /* Procedimientos */
  RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).
  DELETE PROCEDURE z-hProc.                   /* Release Libreria */

  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK BY ITEM.NroItm DESC:
      IF Almmmatg.CodFam = '086' AND Almmmatg.SubFam = '001' THEN DO:
          x-cant-bolsas = x-cant-bolsas + (ITEM.canped * ITEM.factor).
          x-alm-des = ITEM.almdes.
      END.
  END.

  x-ultimo-item = 0.
  FOR EACH ITEM WHERE item.codmat = x-articulo-ICBPER :
      DELETE ITEM.
  END.

  FOR EACH ITEM BY ITEM.NroItm:
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN ITEM.implinweb = x-ultimo-item.
  END.
  FOR EACH ITEM :
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN ITEM.NroItm = ITEM.implinweb
            ITEM.implinweb = 0.
  END.

  IF x-cant-bolsas > 0 THEN DO:

      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = x-articulo-ICBPER NO-LOCK NO-ERROR.

        x-ultimo-item = x-ultimo-item + 1.

        CREATE ITEM.
        ASSIGN
          ITEM.CodCia = Faccpedi.CodCia
          ITEM.CodDiv = Faccpedi.CodDiv
          ITEM.coddoc = Faccpedi.coddoc
          ITEM.NroPed = Faccpedi.NroPed
          ITEM.FchPed = Faccpedi.FchPed
          ITEM.Hora   = Faccpedi.Hora 
          ITEM.FlgEst = Faccpedi.FlgEst
          ITEM.NroItm = x-ultimo-item
          ITEM.CanPick = 0.   /* OJO */

      ASSIGN 
          ITEM.codmat = x-articulo-ICBPER
          ITEM.UndVta = IF (AVAILABLE almmmatg) THEN Almmmatg.UndA ELSE 'UNI'
          ITEM.almdes = x-alm-des
          ITEM.Factor = 1
          ITEM.PorDto = 0
          ITEM.PreBas = x-precio-ICBPER
          ITEM.AftIgv = IF (AVAILABLE almmmatg) THEN Almmmatg.AftIgv ELSE NO
          ITEM.AftIsc = NO
          ITEM.Libre_c04 = "".
      ASSIGN 
          ITEM.CanPed = x-cant-bolsas
          ITEM.PreUni = x-precio-ICBPER
          ITEM.Por_Dsctos[1] = 0.00
          ITEM.Por_Dsctos[2] = 0.00
          ITEM.Por_Dsctos[3] = 0.00
          ITEM.Libre_d02     = 0.
      ASSIGN
          ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
      IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
          THEN ITEM.ImpDto = 0.
          ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
      /* ***************************************************************** */
    
      ASSIGN
          ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
          ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
      IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
      ELSE ITEM.ImpIsc = 0.
        IF ITEM.AftIgv 
      THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
  END.

  /* Ic - 03Oct2019, bolsas plasticas */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

