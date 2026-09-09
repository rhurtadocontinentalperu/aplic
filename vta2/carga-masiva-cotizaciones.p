&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
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

/*MESSAGE "Definiciones"
                    VIEW-AS ALERT-BOX ERROR.*/

DEFINE INPUT PARAMETER x-archivo                     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER x-msgret                     AS CHARACTE  NO-UNDO.
DEFINE OUTPUT PARAMETER x-ordcmp                     AS CHARACTE  NO-UNDO.
DEFINE OUTPUT PARAMETER x-codibc                     AS CHARACTE  NO-UNDO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-CodCli AS CHAR.
DEF SHARED VAR s-porigv AS DEC.
DEF SHARED VAR s-cndvta AS CHAR.
DEF SHARED VAR s-tpocmb AS DEC.
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-codven AS CHAR.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR s-nrodec AS INT.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-flgigv AS LOG.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-import-ibc AS LOG.
DEF SHARED VAR s-import-cissac AS LOG.
DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VARIABLE S-NROPED AS CHAR.
DEFINE SHARED VARIABLE s-pendiente-ibc AS LOG.

DEF TEMP-TABLE ITEM LIKE FacDPedi.

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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/*
          MESSAGE "Main Block carga-masiva-cotizaciones"
                    VIEW-AS ALERT-BOX ERROR.
  */
BloqueTrasaccion:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:

    RUN add_record NO-ERROR.
    /*
    IF ERROR-STATUS:ERROR THEN DO:
        UNDO BloqueTrasaccion, RETURN ERROR.
    END.
    */
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        UNDO BloqueTrasaccion, RETURN "ADM-ERROR".
    END.


    RUN cargar-txt NO-ERROR.
    /*
    IF ERROR-STATUS:ERROR THEN DO:
        UNDO BloqueTrasaccion, RETURN ERROR.
    END.
    */
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        UNDO BloqueTrasaccion, RETURN "ADM-ERROR".
    END.

    RUN assign-statement NO-ERROR.
    /*
    IF ERROR-STATUS:ERROR THEN DO:
        UNDO BloqueTrasaccion, RETURN ERROR.
    END.
    */
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        UNDO BloqueTrasaccion, RETURN "ADM-ERROR".
    END.

    RETURN "OK".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-add_record) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add_record Procedure 
PROCEDURE add_record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      x-msgret = "Esta serie está bloqueada para hacer movimientos".
      RETURN "ADM-ERROR".
      /*MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.*/
      /*RETURN ERROR.*/
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
  IF NOT AVAILABLE FacCfgGn THEN DO:
      x-msgret = "No existe configuracion de Empresa en FacCfgGn".
      RETURN "ADM-ERROR".
      /*
      MESSAGE 'No existe configuracion de Empresa en FacCfgGn' VIEW-AS ALERT-BOX WARNING.
       RETURN ERROR.
       */
  END.
  ASSIGN
      /*s-Copia-Registro = NO*/
      s-PorIgv = FacCfgGn.PorIgv
      s-Import-IBC = NO
      s-Import-Cissac = NO
      s-adm-new-record = "YES"
      s-nroped = "".

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .*/

  CREATE faccpedi.

  /* Code placed here will execute AFTER standard behavior.    */
  /*IF lEs-Masivo = NO THEN RUN Procesa-Handle IN lh_Handle ('Pagina2').*/

  /*DO WITH FRAME {&FRAME-NAME}:*/
      ASSIGN
          s-CodMon = 1
          s-CodCli = ''
          s-CndVta = ''
          s-TpoCmb = 1  
          s-NroDec = (IF s-CodDiv = '00018' OR s-CodDiv = '10018' THEN 4 ELSE 2)
          s-FlgIgv = YES    /* Venta AFECTA a IGV */
          FacCPedi.CodMon = 1
          FacCPedi.Cmpbnte = "FAC"
          FacCPedi.Libre_d01 = s-NroDec
          FacCPedi.FlgIgv = YES.
          facCpedi.codven = '151'.
          FacCpedi.fmapgo = '161'.
          FacCpedi.fchven = TODAY + 15.

      FIND TcmbCot WHERE  TcmbCot.Codcia = 0
          AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
          AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
          NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN DO:
           S-TPOCMB = TcmbCot.TpoCmb.  
      END.          
        ELSE DO:
            x-msgret = "No existe Tipo de Cambio".
            RETURN "ADM-ERROR".
            /*MESSAGE 'No existe Tipo de Cambio' VIEW-AS ALERT-BOX WARNING.
             RETURN ERROR.*/
        END.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assign-statement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assign-statement Procedure 
PROCEDURE assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

   {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
      ASSIGN 
          FacCPedi.CodCia = S-CODCIA
          FacCPedi.CodDiv = S-CODDIV
          FacCPedi.CodDoc = s-coddoc 
          FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
          FacCPedi.FchPed = TODAY 
          FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          FacCPedi.TpoPed = s-TpoPed
          FacCPedi.FlgEst = "P".    /* APROBADO */
      /*IF s-import-ibc = YES AND s-pendiente-ibc = YES THEN Faccpedi.flgest = 'E'.*/
      Faccpedi.flgest = 'E'.
      IF s-Import-Ibc = YES THEN FacCPedi.Libre_C05 = "1".
      IF s-Import-Cissac = YES THEN FacCPedi.Libre_C05 = "2".
      ASSIGN
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
  ASSIGN 
      FacCPedi.PorIgv = s-PorIgv
      FacCPedi.Hora = STRING(TIME,"HH:MM")
      FacCPedi.Usuario = S-USER-ID
      FacCPedi.Observa = ''. /*F-Observa.*/

  FOR EACH ITEM WHERE ITEM.ImpLin > 0 BY ITEM.NroItm: 
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

  {vta2/graba-totales-cotizacion-cred.i}
  IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cargar-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-txt Procedure 
PROCEDURE cargar-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*DEFINE INPUT PARAMETER X-archivo                     AS CHARACTER NO-UNDO.*/

DEF VAR x-Linea   AS CHAR FORMAT 'x(200)' NO-UNDO.
DEF VAR x-CodMat LIKE ITEM.codmat NO-UNDO.
DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-ImpLin LIKE ITEM.implin NO-UNDO.
DEF VAR x-ImpIgv LIKE ITEM.impigv NO-UNDO.
DEF VAR x-Encabezado AS LOG INIT FALSE.
DEF VAR x-Detalle    AS LOG INIT FALSE.
DEF VAR x-NroItm AS INT INIT 0.
DEF VAR x-Ok AS LOG.
DEF VAR x-Item AS CHAR NO-UNDO.
  
DEFINE VARIABLE cSede   AS CHAR NO-UNDO.
DEFINE VARIABLE cCodCli AS CHAR NO-UNDO.


EMPTY TEMP-TABLE ITEM.
    
INPUT FROM VALUE(x-Archivo).
TEXTO:
REPEAT:
    IMPORT UNFORMATTED x-Linea.
    IF x-Linea BEGINS 'ENC' THEN DO:
        ASSIGN
            x-Encabezado = YES
            x-Detalle    = NO
            x-CodMat = ''
            x-CanPed = 0
            x-ImpLin = 0
            x-ImpIgv = 0.
        x-Item = ENTRY(6,x-Linea).
        FacCPedi.ordcmp = SUBSTRING(x-Item,11,10).
        x-ordcmp        = FacCPedi.ordcmp.

        FIND LOG-EDI-TRANS WHERE LOG-EDI-TRANS.codcia = s-codcia AND nordencompra = x-ordcmp AND flgok = YES NO-LOCK NO-ERROR.
        IF AVAILABLE LOG-EDI-TRANS THEN DO:
            x-msgret = "Orden de Compra ya esta registradoo..".
            RETURN "ADM-ERROR".
            /*RETURN ERROR.*/
        END.
    END.
    /* Sede y Lugar de Entrega */
    IF x-Linea BEGINS 'DPGR' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cSede = TRIM(ENTRY(2,x-Linea)).
    END.
    /* Cliente */
    IF x-Linea BEGINS 'IVAD' AND NUM-ENTRIES(x-Linea) > 1 THEN DO:
        cCodCli = TRIM(ENTRY(2,x-Linea)).
        x-codibc = cCodCli.
        /* PINTAMOS INFORMACION */
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codibc = cCodCli
            AND gn-clie.flgsit = 'A'
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                s-codcli = gn-clie.codcli.
                Faccpedi.codcli = gn-clie.codcli.
                FacCpedi.dircli = gn-clie.dircli.
                FacCpedi.nomcli = gn-clie.nomcli.
                FacCpedi.RucCli = gn-clie.ruc.

            FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Libre_c01 = cSede NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clied THEN DO: 
                ASSIGN
                    Faccpedi.sede = Gn-ClieD.Sede.
                FIND gn-clied WHERE gn-clied.codcia = cl-codcia
                    AND gn-clied.codcli = Faccpedi.codcli
                    AND gn-clied.sede = Faccpedi.sede
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clied
                THEN ASSIGN 
                      /*FILL-IN-Sede = Gn-ClieD.DirCli*/
                      FacCPedi.LugEnt = Gn-ClieD.DirCli
                      FacCPedi.Glosa = (IF FacCPedi.Glosa = '' THEN Gn-ClieD.DirCli ELSE FacCPedi.Glosa).
            END.              
            ELSE DO:
                FacCPedi.LugEnt = Gn-Clie.DirCli.
                FacCPedi.Glosa = (IF FacCPedi.Glosa = '' THEN Gn-Clie.DirCli ELSE FacCPedi.Glosa).
            END.
        END.
        ELSE DO: 
            /*MESSAGE "Cliente NO Existe"
                    VIEW-AS ALERT-BOX ERROR.*/
                x-msgret = "Cliente No existe".
                RETURN "ADM-ERROR".
                /*RETURN ERROR.*/
        END.
            
    END.

    /* DETALLE */
    IF x-Linea BEGINS 'LIN' 
    THEN ASSIGN
            x-Encabezado = FALSE
            x-Detalle = YES.
    IF x-Detalle = YES THEN DO:
        IF x-Linea BEGINS 'LIN' 
        THEN DO:
            x-Item = ENTRY(2,x-Linea).
            IF NUM-ENTRIES(x-Linea) = 6
            THEN ASSIGN x-CodMat = STRING(INTEGER(ENTRY(6,x-Linea)), '999999') NO-ERROR.
            ELSE ASSIGN x-CodMat = ENTRY(3,x-Linea) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN x-CodMat = ENTRY(3,x-Linea).
        END.
        FIND Almmmatg WHERE almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-codmat
            AND Almmmatg.tpoart <> 'D'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN DO:
            FIND Almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codbrr = x-codmat
                AND Almmmatg.tpoart <> 'D'
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmatg THEN DO:
                x-codmat = almmmatg.codmat.
            END.                            
        END.
        IF NOT AVAILABLE Almmmatg THEN DO:
            MESSAGE "El Item" x-Item x-codmat "no esta registrado en el catalogo"
                    VIEW-AS ALERT-BOX ERROR.
            NEXT TEXTO.
        END.

        IF x-Linea BEGINS 'QTY' THEN x-CanPed = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'MOA' THEN x-ImpLin = DECIMAL(ENTRY(2,x-Linea)).
        IF x-Linea BEGINS 'TAX' 
        THEN DO:
            ASSIGN
                x-ImpIgv = DECIMAL(ENTRY(3,x-Linea))
                x-NroItm = x-NroItm + 1.
            /* consistencia de duplicidad */
            FIND FIRST ITEM WHERE ITEM.codmat = x-CodMat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ITEM THEN DO:
                CREATE ITEM.
                ASSIGN 
                    ITEM.CodCia = s-codcia
                    ITEM.codmat = x-CodMat
                    ITEM.Factor = 1 
                    ITEM.CanPed = x-CanPed
                    ITEM.NroItm = x-NroItm 
                    ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
                    ITEM.ALMDES = S-CODALM
                    ITEM.AftIgv = (IF x-ImpIgv > 0 THEN YES ELSE NO).
                /* RHC 09.08.06 IGV de acuerdo al cliente */
                IF LOOKUP(TRIM(s-CodCli), '20100070970,20109072177,20100106915,20504912851') > 0
                THEN ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin
                        ITEM.PreUni = (ITEM.ImpLin / ITEM.CanPed).
                ELSE ASSIGN
                        ITEM.ImpIgv = x-ImpIgv 
                        ITEM.ImpLin = x-ImpLin + x-ImpIgv
                        ITEM.PreUni = (ITEM.ImpLin / ITEM.CanPed).
            END.    /* fin de grabacion del detalle */
        END.
    END.
  END.
  INPUT CLOSE.
  s-import-ibc = YES.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

