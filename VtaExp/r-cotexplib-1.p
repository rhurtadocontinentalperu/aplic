&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-ImpPed.p
    Purpose     : Impresion de Pedidos y Cotizaciones
    Syntax      :
    Description :
    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.

DEF SHARED VAR S-USER-ID AS CHAR. 
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR CL-codcia  AS INT.
DEF SHARED VAR pv-codcia  AS INT.
DEF SHARED VAR s-codalm  AS CHAR.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR S-NomCia  AS CHAR.
DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR C-TitDoc  AS CHAR FORMAT "X(50)".
DEF        VAR XD        AS CHAR FORMAT "X(2)".
DEF        VAR I-NroItm  AS INTEGER.
DEF        VAR F-PreNet  AS DECIMAL.
DEF        VAR W-DIRALM  AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM  AS CHAR FORMAT "X(65)".

DEF        VAR F-PreUni  LIKE FacDPedi.Preuni.
DEF        VAR F-ImpLin  LIKE FacDPedi.ImpLin.
DEF        VAR F-ImpTot  LIKE FacCPedi.ImpTot.

DEF        VAR F-CodUbi  LIKE Almmmate.CodUbi.

DEFINE VARIABLE x-dscto AS DECIMAL.

DEFINE VARIABLE X-IMPIGV AS CHARACTER FORMAT "X(30)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.

FIND FacCPedi WHERE ROWID(FacCPedi) = X-ROWID NO-LOCK NO-ERROR.

IF NOT AVAILABLE FacCPedi THEN RETURN.

IF FacCPedi.CodDoc = "PED" THEN 
     C-TitDoc = "    PEDIDO :". 
ELSE C-TitDoc = "COTIZACION :". 

IF FacCpedi.Codmon = 2 THEN C-Moneda = "DOLARES US$.".
ELSE C-Moneda = "SOLES   S/. ".

C-NomVen = FacCPedi.CodVen.
C-NomCon = FacCPedi.FmaPgo.
XD       = STRING (FacCpedi.Fchven - FacCpedi.Fchped,"999").

IF FacCpedi.FlgIgv THEN DO:
   X-IMPIGV = "LOS PRECIOS INCLUYEN EL I.G.V.".
   F-ImpTot = FacCPedi.ImpTot.
END.
ELSE DO:
   X-IMPIGV = "LOS PRECIOS NO INCLUYEN EL IGV.".
   F-ImpTot = FacCPedi.ImpVta.
END.  

FIND gn-clie WHERE 
     gn-clie.codcia = CL-CODCIA AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
     
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.

FIND Almacen WHERE 
     Almacen.CodCia = S-CODCIA AND  
     Almacen.CodAlm = Faccpedi.CODALM 
     NO-LOCK NO-ERROR.
IF AVAILABLE Almacen 
    THEN ASSIGN
    W-DIRALM = Almacen.DirAlm
    W-TLFALM = Almacen.TelAlm. 
W-TLFALM = 'Telemarketing:(511) 349-2351 / 349-2444  Fax:349-4670'.  
/************************  PUNTEROS EN POSICION  *******************************/
/*RUN bin/_numero(FacCPedi.imptot, 2, 1, OUTPUT X-EnLetras).*/
RUN bin/_numero(F-IMPTOT, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF FacCPedi.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

DEFINE VARIABLE C-OBS AS CHAR EXTENT 2.
DEFINE VARIABLE K AS INTEGER.
IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
END.


DEF TEMP-TABLE DETA LIKE FacDPedi
    FIELD Clave AS CHAR
    INDEX Llave01 Clave NroItm.
    
DEF TEMP-TABLE DDOCU LIKE Ccbddocu.
DEF TEMP-TABLE T-PROM LIKE Expcprom.

DEF TEMP-TABLE Resumen 
    FIELD CodPro AS CHAR FORMAT 'x(11)'
    FIELD NomPro AS CHAR FORMAT 'x(40)'
    FIELD Cantidad AS INT.


  DEF TEMP-TABLE Detalle
      FIELD codmat LIKE FacDPedi.codmat
      FIELD canped LIKE FacDPedi.canped
      FIELD implin LIKE FacDPedi.implin
      FIELD impmin AS DEC         /* Importes y cantidades minimas */
      FIELD canmin AS DEC.

  DEF TEMP-TABLE Promocion LIKE FacDPedi.

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
         HEIGHT             = 12.23
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Definimos impresoras */

DEFINE VARIABLE X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEFINE VARIABLE Rpta     AS LOG NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE Rpta.
IF Rpta = NO THEN RETURN.

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".
    

C-OBS[1] = '- LOS PRECIOS INCLUYEN IGV'.
C-OBS[2] = '- GARANTIZAMOS NUESTROS PRODUCTOS CON CERTIFICADOS DE CALIDAD'.

/************************  DEFINICION DE FRAMES  *******************************/
DEFINE FRAME F-FtrCot
    HEADER
    X-EnLetras   FORMAT "x(100)" SKIP 
    "  DTO.GLOBAL :" WHEN FacCPedi.PorDto > 0 AT 70 FORMAT 'x(20)'
    STRING(FacCPedi.PorDto,'>>9.99') WHEN FacCPedi.PorDto > 0 FORMAT 'x(10)' SKIP
    "NETO A PAGAR : "  AT 70  FORMAT "x(20)" 
    SUBSTRING(C-MONEDA,9,4)   FORMAT "X(10)" 
    STRING(F-ImpTot,">>,>>>,>>9.99")  FORMAT "x(20)" SKIP    
    "OBSERVACIONES : "  FORMAT "x(20)" SKIP 
    FacCPedi.Glosa VIEW-AS TEXT FORMAT "X(80)" SKIP
    "--------------------------------------------------" SKIP
    C-OBS[1] VIEW-AS TEXT FORMAT "X(315)"  SKIP 
    C-OBS[2] VIEW-AS TEXT FORMAT "X(315)"  SKIP 
    "--------------------------------------------------                            ------------------- " SKIP
    "                                                                              VoBo Jefe de Ventas " SKIP
    "HORA : " AT 1 STRING(TIME,"HH:MM:SS") "  " S-USER-ID SKIP  
    WITH PAGE-BOTTOM NO-LABELS NO-BOX STREAM-IO WIDTH 360.
    

DEFINE FRAME F-HdrPed
    HEADER 
    skip(4)
    "Page:" AT 110 PAGE-NUMBER FORMAT ">>9" skip
    S-NOMCIA FORMAT "X(45)" SKIP
    /*RDP - 22-10-10
    W-DIRALM  at 1 FORMAT "x(55)" 
    W-TLFALM  at 60 FORMAt "x(65)"
    */ 
    SKIP    
    C-TitDoc  AT 80 FORMAT "X(22)" 
    FacCPedi.NroPed AT 102 FORMAT "XXXXXX-XXXXXXXXXXXX" SKIP
   
    "Señor(es) : " TO 25 C-Descli       FORMAT "x(40)" "Emision         : " TO 100 FacCPedi.FchPed SKIP
    "Direccion : " TO 25 gn-clie.DirCli FORMAT "x(40)" "Entrega         : " TO 100 FacCPedi.FchEnt SKIP
    "R.U.C.    : " TO 25 gn-clie.Ruc    "Vencimiento     : " TO 100 FacCPedi.fchven FORMAT "99/99/9999" SKIP
    "<OFICINA> "   TO 6
    "Vendedor  : " TO 25 C-NomVen       X-ORDCOM TO 100 FacCPedi.ordcmp SKIP
    "Cond.Venta: " TO 25 C-NomCon       "Moneda          : " TO 100 C-Moneda        SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    "ITEM CODIGO   CANTIDAD UND.             D E S C R I P C I O N             M A R C A      PRECI_VTA     DSCTOS.    TOTAL NETO   " SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.
                         
DEFINE FRAME F-DetaCot
    DETA.NroItm FORMAT ">>>9"
    DETA.codmat FORMAT "X(6)"
    DETA.CanPed FORMAT ">>>,>>9.99"
    DETA.undvta FORMAT "X(4)"
    almmmatg.desmat FORMAT "X(45)"
    almmmatg.desmar FORMAT "X(11)"
    F-PreUni FORMAT "->,>>>,>>9.9999"
    DETA.Por_Dsctos[1] FORMAT "->>9.99 %"
    F-ImpLin FORMAT "->,>>>,>>9.9999" 
    almmmate.CodUbi SKIP
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.


/* CARGA TEMPORALES */
RUN Carga-Detalle.
/*RUN Carga-Promociones.*/
RUN Carga-Promociones-2012.
/*RDP - 22/10/2010
RUN Carga-Resumen-Digitacion.
*/
/* **************** */

/*OUTPUT  TO VALUE(s-port-name) PAGE-SIZE 48.*/
OUTPUT  TO PRINTER PAGE-SIZE 48.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     
FOR EACH DETA,
        FIRST Almmmatg OF DETA NO-LOCK
        BREAK BY DETA.Clave BY DETA.NroItm:
    VIEW  FRAME F-HdrPed.

    I-NroItm = I-NroItm + 1.
    F-PreNet = DETA.preuni * ( 1 - DETA.PorDto / 100 ).
    x-dscto = 0.

    IF FacCpedi.FlgIgv THEN DO:
       F-PreUni = DETA.PreUni.
       F-ImpLin = DETA.ImpLin. 
    END.
    ELSE DO:
       F-PreUni = ROUND(DETA.PreUni / (1 + FacCPedi.PorIgv / 100),2).
       F-ImpLin = ROUND(DETA.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
    END.  
    IF FIRST-OF(DETA.Clave) AND DETA.Clave = 'B'
    THEN DO:
        DOWN 2 WITH FRAME F-DetaCot.
        DISPLAY
            'PROMOCIONES' @ Almmmatg.desmat
            WITH FRAME F-DetaCot.
        UNDERLINE
            Almmmatg.desmat 
            WITH FRAME F-DetaCot.
    END.
    DISPLAY  
            DETA.NroItm  
            DETA.codmat
            DETA.CanPed
            DETA.undvta
            Almmmatg.desmat
            Almmmatg.desmar
            F-PreUni            WHEN DETA.Clave = 'A'
            DETA.Por_Dsctos[1]  WHEN DETA.Clave = 'A'
            F-ImpLin            WHEN DETA.Clave = 'A'
            WITH FRAME F-DetaCot.  
END.
VIEW  FRAME F-FtrCot.
OUTPUT CLOSE.


DEFINE FRAME F-HdrRes
    HEADER 
    skip(4)
    "Page:" AT 110 PAGE-NUMBER FORMAT ">>9" skip
    S-NOMCIA FORMAT "X(45)" SKIP
    W-DIRALM  at 1 FORMAT "x(55)" 
    W-TLFALM  at 60 FORMAt "x(65)" SKIP
    C-TitDoc  AT 80 FORMAT "X(22)" 
    FacCPedi.NroPed AT 102 FORMAT "XXXXXX-XXXXXXXXXXXX" SKIP
   
    "Señor(es) : " TO 25 C-Descli       FORMAT "x(40)" "Emision         : " TO 100 FacCPedi.FchPed SKIP
    "Direccion : " TO 25 gn-clie.DirCli FORMAT "x(40)" "Entrega         : " TO 100 FacCPedi.FchEnt SKIP
    "R.U.C.    : " TO 25 gn-clie.Ruc    "Vencimiento     : " TO 100 FacCPedi.fchven FORMAT "99/99/9999" SKIP
    "<OFICINA> "   TO 6
    "Vendedor  : " TO 25 C-NomVen       X-ORDCOM TO 100 FacCPedi.ordcmp SKIP
    "Cond.Venta: " TO 25 C-NomCon       "Moneda          : " TO 100 C-Moneda        SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    "PROVEEDOR                                                            ITEMS DIGITADOS                                           " SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 160.

DEFINE FRAME F-DetaRes
    Resumen.CodPro
    Resumen.NomPro
    Resumen.Cantidad
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 160.

OUTPUT  TO PRINTER PAGE-SIZE 48.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     
FOR EACH Resumen:
    VIEW  FRAME F-HdrRes.
    DISPLAY  
        Resumen.CodPro
        Resumen.NomPro
        Resumen.Cantidad
        WITH FRAME F-DetaRes.  
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Detalle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle Procedure 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR i-NroItm AS INT NO-UNDO.

I-NroItm = 0.
FOR EACH FacDPedi OF FacCPedi NO-LOCK BY FacDPedi.NroItm:
    I-NroItm = I-NroItm + 1.
    CREATE DETA.
    BUFFER-COPY FacDPedi TO DETA
        ASSIGN 
            Deta.Clave = 'A'
            Deta.NroItm = i-NroItm.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Promociones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Promociones Procedure 
PROCEDURE Carga-Promociones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {vtaexp/carga-promociones.i}
  
/*
  DEF VAR x-ImpTot AS DEC NO-UNDO.
  DEF VAR x-Factor AS INT NO-UNDO.
  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR i-NroItm AS INT INIT 1 NO-UNDO.
  
  /* Acumulamos los comprobantes en S/. */
  FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    FIND DDOCU WHERE DDOCU.CodCia = Facdpedi.codcia
        AND DDOCU.CodMat = Facdpedi.codmat
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DDOCU THEN CREATE DDOCU.
    ASSIGN
        DDOCU.CodCia = Facdpedi.codcia
        DDOCU.CodMat = Facdpedi.codmat.
    IF Faccpedi.CodMon = 1
    THEN ASSIGN
            DDOCU.ImpLin = DDOCU.ImpLin + Facdpedi.ImpLin.
    ELSE ASSIGN
            DDOCU.ImpLin = DDOCU.ImpLin + Facdpedi.ImpLin * Faccpedi.TpoCmb.
  END.

  /* barremos las promociones */
  PROMOCION:
  FOR EACH Expcprom NO-LOCK WHERE ExpCProm.CodCia = s-codcia AND ExpCProm.FlgEst = 'A':
    x-ImpTot = 0.
    FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'P':
        FIND DDOCU WHERE DDOCU.codmat = Expdprom.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DDOCU THEN NEXT.
        x-ImpTot = x-ImpTot + DDOCU.ImpLin.
    END.
    IF Expcprom.codmon = 2
    THEN x-ImpTot = x-ImpTot / Faccpedi.tpocmb.
    IF x-ImpTot < ExpCProm.Importe THEN NEXT PROMOCION.
    x-Factor = TRUNCATE(x-ImpTot / Expcprom.importe, 0).
    FOR EACH Expdprom OF Expcprom NO-LOCK WHERE Expdprom.Tipo = 'G', 
            FIRST Almmmatg OF Expdprom NO-LOCK:
        FIND DETA WHERE DETA.Clave = 'B'
            AND DETA.CodMat = Expdprom.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE DETA THEN CREATE DETA.
        ASSIGN
            DETA.clave  = 'B'
            DETA.codcia = s-codcia
            DETA.codmat = Expdprom.codmat
            DETA.canped = DETA.canped + (ExpDProm.Cantidad * x-Factor)
            DETA.undvta = Almmmatg.undbas
            DETA.factor = 1
            DETA.NroItm = i-NroItm.
        i-NroItm = i-NroItm + 1.
    END.
  END.
*/
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Promociones-2012) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Promociones-2012 Procedure 
PROCEDURE Carga-Promociones-2012 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
DEF VAR i-NroItm AS INT INIT 0 NO-UNDO.
DEF VAR x-Factor AS INT.
DEF VAR x-ImpLin AS DEC.
DEF VAR x-ImpMin AS DEC.
DEF VAR x-CanDes AS DEC.
DEF VAR x-CanMin AS DEC.

/* Barremos las promociones activas */
FOR EACH Vtacprom NO-LOCK WHERE Vtacprom.codcia = FacCPedi.codcia
    AND Vtacprom.coddiv = FacCPedi.coddiv
    AND Vtacprom.coddoc = 'PRO'
    AND Vtacprom.FlgEst = 'A'
    AND (TODAY >= VtaCProm.Desde AND TODAY <= VtaCProm.Hasta):
  /* Acumulamos los productos promocionables */
  EMPTY TEMP-TABLE Detalle.   /* Limpiamos temporal */
  FOR EACH Vtadprom OF Vtacprom NO-LOCK WHERE Vtadprom.Tipo = 'P':
      FIND FacDPedi OF FacCPedi WHERE FacDPedi.codmat = Vtadprom.codmat
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacDPedi THEN DO:
          FIND Detalle WHERE Detalle.codmat = FacDPedi.codmat NO-ERROR.
          IF NOT AVAILABLE Detalle THEN CREATE Detalle.
          ASSIGN
              Detalle.codmat = Vtadprom.codmat
              Detalle.canped = Detalle.canped + ( FacDPedi.canped * FacDPedi.Factor )
              Detalle.implin = Detalle.implin + FacDPedi.implin
              Detalle.impmin = Vtadprom.importe
              Detalle.canmin = Vtadprom.cantidad.
      END.
  END.
  /* Generamos la promocion */
  PROMOCIONES:
  DO:
      x-Factor = 0.
      CASE Vtacprom.TipProm:
          WHEN 1 THEN DO:     /* Por Importes */
              x-ImpLin = 0.
              FOR EACH Detalle:
                  IF FacCPedi.CodMon = Vtacprom.codmon THEN x-ImpMin = Detalle.ImpMin.
                  ELSE IF FacCPedi.CodMon = 1 THEN x-ImpMin = Detalle.ImpMin * FacCPedi.TpoCmb.
                                              ELSE x-ImpMin = Detalle.ImpMin / FacCPedi.TpoCmb.
                  IF x-ImpMin > 0 AND x-ImpMin > Detalle.ImpLin THEN NEXT.
                  x-ImpLin = x-ImpLin + Detalle.ImpLin.
              END.
              x-ImpMin = Vtacprom.Importe.
              IF FacCPedi.CodMon <> Vtacprom.CodMon
                  THEN IF FacCPedi.CodMon = 1 THEN x-ImpLin = x-ImpLin / FacCPedi.TpoCmb.
                                              ELSE x-ImpLin = x-ImpLin * FacCPedi.TpoCmb.
              IF x-ImpMin <= x-ImpLin THEN x-Factor = TRUNCATE(x-ImpLin / x-ImpMin, 0).
          END.
          WHEN 2 THEN DO:     /* Por cantidades */
              x-CanDes = 0.
              FOR EACH Detalle:
                  IF Detalle.CanMin > 0 AND Detalle.CanMin > Detalle.CanPed THEN NEXT.
                  x-CanDes = x-CanDes + Detalle.CanPed.
              END.
              x-CanMin = Vtacprom.Cantidad.
              IF x-CanMin <= x-CanDes THEN x-Factor = TRUNCATE(x-CanDes / x-CanMin, 0).
          END.
          WHEN 3 THEN DO:     /* Por importes y proveedor  */
              x-ImpLin = 0.
              FOR EACH FacDPedi OF FacCPedi NO-LOCK, FIRST Almmmatg OF Facdpedi WHERE Almmmatg.codpr1 = VtaCProm.CodPro:
                  x-ImpLin = x-ImpLin + FacDPedi.ImpLin.
              END.
              IF FacCPedi.CodMon = 2 THEN x-ImpLin = x-ImpLin * FacCPedi.TpoCmb.
              x-Factor = 1.
          END.
      END CASE.
      IF x-Factor <= 0 THEN LEAVE PROMOCIONES.
      /* cargamos las promociones */
      CASE Vtacprom.TipProm:
          WHEN 1 OR WHEN 2 THEN DO:
              FOR EACH Vtadprom OF Vtacprom NO-LOCK WHERE Vtadprom.Tipo = 'G', FIRST Almmmatg OF Vtadprom NO-LOCK:
                  FIND Promocion WHERE Promocion.codmat = Vtadprom.codmat NO-ERROR.
                  IF NOT AVAILABLE Promocion THEN CREATE Promocion.
                  ASSIGN
                      Promocion.codcia = FacCPedi.codcia
                      Promocion.coddiv = FacCPedi.coddiv
                      Promocion.almdes = FacCPedi.codalm
                      Promocion.codmat = Vtadprom.codmat
                      Promocion.canped = Promocion.canped + ( Vtadprom.cantidad * x-Factor )
                      Promocion.undvta = Almmmatg.undbas
                      Promocion.aftigv = Almmmatg.AftIgv
                      Promocion.factor = 1.
                  IF Vtadprom.Tope > 0 AND Promocion.canped > Vtadprom.Tope
                      THEN Promocion.canped = Vtadprom.Tope.
              END.
          END.
          WHEN 3 THEN DO:
              FOR EACH Vtadprom OF Vtacprom NO-LOCK WHERE Vtadprom.Tipo = 'G', FIRST Almmmatg OF Vtadprom NO-LOCK
                  BY Vtadprom.Importe DESC:
                  IF x-ImpLin >= Vtadprom.Importe THEN DO:
                      FIND Promocion WHERE Promocion.codmat = Vtadprom.codmat NO-ERROR.
                      IF NOT AVAILABLE Promocion THEN CREATE Promocion.
                      ASSIGN
                          Promocion.codcia = FacCPedi.codcia
                          Promocion.coddiv = FacCPedi.coddiv
                          Promocion.almdes = FacCPedi.codalm
                          Promocion.codmat = Vtadprom.codmat
                          Promocion.canped = Promocion.canped + ( Vtadprom.cantidad * x-Factor )
                          Promocion.undvta = Almmmatg.undbas
                          Promocion.aftigv = Almmmatg.AftIgv
                          Promocion.factor = 1.
                      IF Vtadprom.Tope > 0 AND Promocion.canped > Vtadprom.Tope
                          THEN Promocion.canped = Vtadprom.Tope.

                      LEAVE PROMOCIONES.    /* <<< OJO <<< */
                  END.
              END.
          END.
      END CASE.
  END.
END.

FOR EACH Promocion:
    FIND DETA WHERE DETA.Clave = 'B'
        AND DETA.CodMat = Expdprom.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DETA THEN DO:
        CREATE DETA.
        i-NroItm = i-NroItm + 1.
        ASSIGN
            DETA.NroItm = i-NroItm.
    END.
    ASSIGN
        DETA.clave  = 'B'
        DETA.codcia = s-codcia
        DETA.codmat = Promocion.codmat
        DETA.canped = DETA.canped + Promocion.canped
        DETA.undvta = Promocion.undvta
        DETA.factor = Promocion.factor.

END.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Resumen-Digitacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumen-Digitacion Procedure 
PROCEDURE Carga-Resumen-Digitacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-prov THEN DO:
        FIND Resumen WHERE Resumen.codpro = Almmmatg.codpr1
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Resumen THEN DO:
            CREATE Resumen.
            ASSIGN
                Resumen.codpro = gn-prov.codpro
                Resumen.nompro = gn-prov.nompro.
        END.
    END.
    ELSE DO:
        FIND Resumen WHERE Resumen.codpro = "NN"
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Resumen THEN DO:
            CREATE Resumen.
            ASSIGN
                Resumen.codpro = 'NN'
                Resumen.nompro = 'PROVEEDOR DESCONOCIDO'.
        END.
    END.
    Resumen.cantidad = Resumen.cantidad + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

