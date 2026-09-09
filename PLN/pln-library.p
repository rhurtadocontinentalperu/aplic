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
DEF SHARED VAR s-codcia AS INTE. 
DEF SHARED VAR s-nomcia AS CHAR. 


DEFINE TEMP-TABLE Tempo NO-UNDO LIKE PL-MOV-MES.

DEFINE TEMP-TABLE Tempo-Cts NO-UNDO LIKE PL-MOV-MES
    FIELD Moneda-Cts LIKE Pl-Cts.Moneda
    FIELD Ult6Sueldos AS DEC.

DEFINE VAR lListaTest AS CHAR FORMAT "x(250)".
DEFINE VAR lCTasTest AS CHAR FORMAT "x(250)".

lListaTest = "000175,000665,000894,000951,000987". /* En caso de Pruebas */
lCtasTest = "00110057720212961753,00110057780212961613,00110057770212961982,00110057720212961885,00110057740212961605".

lListaTest = "".   /* No pruebas */
lCtasTest = "".


/* Librerias

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN <libreria>.rutina_interna IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

*/

DEF STREAM s-Archivo.

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
         HEIGHT             = 11.23
         WIDTH              = 42.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cts_bbva) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cts_bbva Procedure 
PROCEDURE cts_bbva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pDocSal AS CHAR.
DEF INPUT PARAMETER F-tc AS DECI.
DEF INPUT PARAMETER pCodCal LIKE PL-CALC.CodCal.
DEF INPUT PARAMETER COMBO-canal AS CHAR.
DEF INPUT PARAMETER TABLE FOR tempo-cts.

DEFINE VAR xlLinea AS CHAR format "x(254)".

DEFINE VAR lOficina AS CHAR.
DEFINE VAR lControl AS CHAR.
DEFINE VAR lCuenta AS CHAR.
DEFINE VAR lImpTot AS DEC.
DEFINE VAR lTipoProc AS CHAR.
DEFINE VAR lFechProc AS CHAR.
DEFINE VAR lHoraProc AS CHAR.
DEFINE VAR lDescri AS CHAR.
DEFINE VAR lNumTrab AS INT.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lCTaCargo AS CHAR.
DEFINE VAR lCTaTraba AS CHAR.

DEFINE VAR lTipoReg AS CHAR.
DEFINE VAR lMone AS CHAR.
DEFINE VAR cFile-Name AS CHAR.

cFile-Name = pDocSal.

IF INDEX(cFile-Name,".") = 0 THEN DO:    
    cFile-Name = cFile-Name + ".txt".    
END.
lOficina    = '1234'.   /* 4 Digitos*/
lCOntrol    = '00'.     /* 2 Digitos */
lCuenta     = ''.       /* 10 Digitos */
lImpTot     = 0.
lTipoProc   = "F".      /* A:Immediato  H:Hora de Proceso  F:Fecha Futura */
lFechProc   = "        ".    /* 8 Spaceios */
lHoraProc   = "D".       /* B:11am C:03pm D:07pm */
lDescri     = "C.T.S.".
lNumTrab    = 5.        /* Total de trabajadores */
lFiler      = FILL(" ",68).


/*  Cuenta inicial  : 00110130010000000455 
    Cuenta SLeon    : 00110130240100000455      15Ene2015
*/

IF INDEX(s-NOMCIA,"CONTINENTAL") > 0 THEN DO:
    /*lCtaBBVA = '00110130240100000455'.*/
    lCTaCargo    = "00110130240100000455".        /* 20 Digitos */   
END.
ELSE DO:
    /*lCtaBBVA = '00110349880100021984'.*/
    lCTaCargo    = "00110349880100021984".        /* 20 Digitos */   
END.

lCTaTraba   = "".        /* 20 Digitos */
/* RHC 07/05/2014 */
FIND pl-pago WHERE pl-pago.cnpago = COMBO-canal NO-LOCK NO-ERROR.
IF AVAILABLE pl-pago THEN lCTaCargo = TRIM(pl-pago.libre_c01) + FILL(" ", 20 - LENGTH(TRIM(pl-pago.libre_c01)) ).

IF lTipoProc="F" THEN DO:
    lFechProc =  STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99").
END.
IF lTipoProc="H" THEN DO:
    lHoraProc = "D".
END.
lDescri = lDescri + FILL(" ", 25 - LENGTH(lDescri)).

/* Calculo el Importe total */
lNumTrab = 0.
/*for each Tempo-Cts WHERE (lListaTest = "" OR LOOKUP(Tempo-Cts.codper,lListaTest) > 0) :*/
FOR EACH Tempo-Cts WHERE Tempo-Cts.moneda-cts = pCodMon NO-LOCK:
    lImpTot = lImpTot + Tempo-Cts.valcal-mes.
    lNumTrab = lNumTrab + 1.
END.
IF pCodMon = 1  THEN DO:
    lTipoReg = '600'.
    lMone = 'PEN'.
END.
ELSE DO :
    lTipoReg = '610'.
    lMone = 'USD'.
END.

lImpTot     = lImpTot * 100.

OUTPUT TO VALUE(cFile-Name).       

/* Cabecera (lOficina + lControl + lCuenta)*/
xlLinea = lTipoReg + lCtaCargo + lMone + STRING(lImpTot,"999999999999999") + 
        lTipoProc + lFechProc + lHoraProc + lDescri + STRING(lNumTrab,"999999") + "S" + lFiler.

/*DISPLAY lLinea  WITH no-labels WIDTH 300.*/
PUT UNFORMATTED xlLinea FORMAT "x(151)" SKIP .

/* Detalle */
/*for each Tempo-Cts WHERE (lListaTest = "" OR LOOKUP(tempo.codper,lListaTest) > 0) :*/
FOR EACH Tempo-Cts WHERE Tempo-Cts.moneda-cts = pCodMon NO-LOCK:
    xlLinea = "002".

    find pl-pers where pl-pers.codper = Tempo-Cts.codper no-lock no-error.
    find first pl-flg-mes where pl-flg-mes.codcia  = Tempo-Cts.codcia  and
                      pl-flg-mes.periodo = Tempo-Cts.periodo and
                      pl-flg-mes.nromes  = Tempo-Cts.nromes  and
                      pl-flg-mes.codper  = Tempo-Cts.codper  no-lock no-error.
    if available pl-flg-mes THEN DO:
        if available pl-flg-mes and pl-flg-mes.nrodpt <> "" then do: 
            /* Tipo Dcto */
            CASE pl-pers.tpodocid :
                WHEN '01' THEN DO:
                    xlLinea = xlLinea + "L".
                END.
                WHEN '04' THEN DO:
                    xlLinea = xlLinea + "E".
                END.
                WHEN '06' THEN DO:
                    xlLinea = xlLinea + "R".
                END.
                WHEN '07' THEN DO:
                    xlLinea = xlLinea + "P".
                END.
            END CASE.
            /* Nro Dcto */
            xlLinea = xlLinea + TRIM(pl-pers.nrodocid) + FILL(" ",(12 - LENGTH(TRIM(pl-pers.nrodocid)))).
            /* Tipo de Abono */
            xlLinea = xlLinea + "P".
            /* Cuenta de deposito */
            lCTaTraba = TRIM(pl-flg-mes.nrodpt).
            lCTaTraba = FILL(" ", 20 - LENGTH(pl-flg-mes.nrodpt-cts)) + pl-flg-mes.nrodpt-cts.
            
            lCTaTraba = lCtaTraba + FILL(" ", 20 - LENGTH(lCtaTraba)).
            /*lLinea = lLinea + "0011" + lOficina + lCOntrol + TRIM(pl-flg-mes.nrodpt).*/
            xlLinea = xlLinea + lCtaTraba.
            /* Beneficiario */
            lFiler = SUBSTRING( trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + trim(PL-PERS.nomper),1,40).
            lFiler = TRIM(lFiler).
            lFiler = lFiler + FILL(" ",40 - LENGTH(lFiler)).
            xlLinea = xlLinea + lFiler.
            /* Importe */
            lFiler = STRING((Tempo-Cts.valcal-mes ) * 100,"999999999999999").
            xlLinea = xlLinea + lFiler.
            /* Descripcion Abono */
            lFiler = "DEPOSITO C.T.S.".
            lFiler = lFiler + FILL(" ",40 - LENGTH(lFiler)).
            xlLinea = xlLinea + lFiler.
            /* Indicador aviso */
            lFiler = " ".
            xlLinea = xlLinea + lFiler.
            /* Medio de aviso */
            lFiler = FILL(" ",50).
            xlLinea = xlLinea + lFiler.
            /* Indicador de Proceso */
            lFiler = FILL(" ",2).            
            xlLinea = xlLinea + lFiler.
            /* Descripcion */
            lFiler = FILL(" ",30).
            xlLinea = xlLinea + lFiler.
            /* Filer */
            lFiler = FILL(" ",21).
            xlLinea = xlLinea + lFiler.
            /* 6 Ultimas remuneracioens */
            lFiler = FILL("0",15).
            xlLinea = xlLinea + lFiler.
            /* Moneda de Importe */
            lFiler = FILL(" ",3).
            xlLinea = xlLinea + lFiler.
            /* Datos blanco */
            lFiler = FILL(" ",18).
            xlLinea = xlLinea + lFiler.

            /*DISPLAY xlLinea  WITH no-labels WIDTH 500.*/
            PUT UNFORMATTED xlLinea FORMAT "x(272)" SKIP.
        end.
    END.   
  
end.  


OUTPUT CLOSE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cts_bcp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cts_bcp Procedure 
PROCEDURE cts_bcp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pDocSal AS CHAR.
DEF INPUT PARAMETER F-tc AS DECI.
DEF INPUT PARAMETER pCodCal LIKE PL-CALC.CodCal.
DEF INPUT PARAMETER TABLE FOR Tempo-Cts.

define var y as integer init 0.
define var x-tot as deci init 0.
define var x-tipo as deci init 0.
define var x-factor as deci init 0.
define var i as integer .
define var x-des as char.

define var x-in as DEC.
define var x-de as DEC.
define var x-nom as char format "x(40)".
define var x-ruc as char format "x(11)".
define var x as char format "x(1000)".
define var x-cta as char format "x(14)".
define var x-dir as char format "x(40)".

x-factor = 0.0833.
x-factor = 1.
x-tipo   = F-tc .
IF pCodMon = 1 
THEN x-tipo = 1.
ELSE x-tipo = f-Tc.

output to VALUE(pDocSal).

x-dir = "RENE DESCARTES MZ C LT 1 URB. STA RAQUEL 2DA ETAPA ATE".
IF INDEX(s-NOMCIA,"CONTINENTAL") > 0 THEN DO:
    x-nom = "CONTINENTAL S.A.".
    x-ruc = "20100038146".
END.
ELSE DO:
    x-nom = "CORPORACION DE INDUSTRIAS STANDFORD S.A.C.".
    x-ruc = "20511358907".
END.

y = 0 .
x-tot = 0.
for each Tempo-Cts where Tempo-Cts.moneda-cts = pCodMon:
    find pl-pers where pl-pers.codper = Tempo-Cts.codper no-lock no-error.
    find pl-flg-mes where pl-flg-mes.codcia  = Tempo-Cts.codcia  and
                          pl-flg-mes.periodo = Tempo-Cts.periodo and
                          pl-flg-mes.nromes  = Tempo-Cts.nromes  and
                          pl-flg-mes.codper  = Tempo-Cts.codper  no-lock no-error.
    if available pl-flg-mes and nrodpt-Cts <> "" then do: 
        x-in = 0.
        x-in = ROUND((Tempo-Cts.valcal-mes * x-factor ) / x-tipo , 2).
        x-tot = x-tot + x-in.
        y  = y + 1.
    end.
end.

  x  =    "2" +
          "              " + 
          (IF pCodMon = 1 THEN "MN" ELSE "ME") +
          "      " +
          x-ruc +
          "00000000000" +
          "      " +
          string(x-tot,"999999999999999") +
          string(y,"99999")  + 
          "          " +
          "R" +
          "1" +
          " " +
          string(x-nom,"x(40)") + 
          string(x-dir,"x(40)") + 
          "                  " +          
          "      " +
          "           " +                        
          "@" .

/* ************************************************************************************ */
/* Cabecera */
/* ************************************************************************************ */
DEF VAR x-CheckSum AS INT64 NO-UNDO.
DEF VAR x-TpoDocId AS CHAR INIT "1" NO-UNDO.

DEF VAR x-CtaCargo AS CHAR INIT "1911179051005" NO-UNDO.

/* Calculamos ChekSum */

for each Tempo-Cts where Tempo-Cts.moneda-cts = pCodMon:
    find pl-pers where pl-pers.codper = Tempo-Cts.codper no-lock no-error.
    find pl-flg-mes where pl-flg-mes.codcia  = Tempo-Cts.codcia  and
                          pl-flg-mes.periodo = Tempo-Cts.periodo and
                          pl-flg-mes.nromes  = Tempo-Cts.nromes  and
                          pl-flg-mes.codper  = Tempo-Cts.codper  no-lock no-error.
    if available pl-flg-mes and nrodpt-Cts <> "" then do: 
        x-Cta = REPLACE(PL-FLG-MES.nrodpt-cts,"-","").
        x-CheckSum = x-CheckSum + DECIMAL(SUBSTRING(x-Cta,4)).
    END.
END.
x-CheckSum = x-CheckSum + DECIMAL(SUBSTRING(x-CtaCargo,4)).

X = "1" +
    STRING(Y,'999999') +
    STRING(YEAR(TODAY),'9999') + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') +
    "C" +
    ( IF pCodMon = 1 THEN "0001" ELSE "1001" ) +
    STRING("1911179051005",'x(20)') +
    "6" +
    STRING(x-ruc,'x(12)') +
    STRING(x-tot, '99999999999999.99') +
    FILL(" ",40) +
    STRING(x-CheckSum, '999999999999999') 
    .
PUT UNFORMATTED X SKIP.
/* ************************************************************************************ */
/* Pagos */
/* ************************************************************************************ */
for each Tempo-Cts where Tempo-Cts.moneda-cts = pCodMon:
    find pl-pers where pl-pers.codper = Tempo-Cts.codper no-lock no-error.
    find pl-flg-mes where pl-flg-mes.codcia  = Tempo-Cts.codcia  and
                          pl-flg-mes.periodo = Tempo-Cts.periodo and
                          pl-flg-mes.nromes  = Tempo-Cts.nromes  and
                          pl-flg-mes.codper  = Tempo-Cts.codper  no-lock no-error.
    if available pl-flg-mes and nrodpt-Cts <> "" then do: 
        x-in = 0.
        x-in = ROUND((Tempo-Cts.valcal-mes * x-factor ) / x-tipo, 2).
        x-des = "".
        do I = 1 to length(left-trim(PL-PERS.nomper)):
            if substr(left-trim(PL-PERS.nomper),i,1) = " " then do:
               x-des = substr(left-trim(PL-PERS.nomper),1,i - 1).
               leave.
            end.
        end.
        if x-des = "" then  x-des = trim(PL-PERS.nomper).
        x-nom =   trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + x-des .  
        x-Cta = REPLACE(PL-FLG-MES.nrodpt-cts,"-","").
        x  = "2" +
            STRING(x-Cta,'x(20)').
        CASE pl-pers.TpoDocId:
            WHEN '04' THEN X = X + "3".
            WHEN '07' THEN X = X + "4".
            OTHERWISE X = X + "1".
        END CASE.
        X = X + 
            STRING(PL-PERS.NroDocId, 'x(12)') +
            FILL(" ",3) +
            STRING(x-nom, 'x(75)') +
            FILL(" ",40) +
            FILL(" ",20) +
            (IF pCodMon = 1 THEN "0001" ELSE "1001") +
            STRING(x-in, "99999999999999.99") +
            (IF pCodMon = 1 THEN "0001" ELSE "1001") +
            STRING(Tempo-Cts.Ult6Sueldos, "99999999999999.99") 
            .
          PUT UNFORMATTED X SKIP.
    END.  
END.  

output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cts_bcp_old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cts_bcp_old Procedure 
PROCEDURE cts_bcp_old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pDocSal AS CHAR.
DEF INPUT PARAMETER F-tc AS DECI.
DEF INPUT PARAMETER pCodCal LIKE PL-CALC.CodCal.
DEF INPUT PARAMETER TABLE FOR Tempo-Cts.

define var y as integer init 0.
define var x-tot as deci init 0.
define var x-tipo as deci init 0.
define var x-factor as deci init 0.
define var i as integer .
define var x-des as char.

define var x-in as integer.
define var x-de as integer.
define var x-nom as char format "x(40)".
define var x-ruc as char format "x(11)".
define var x as char format "x(1000)".
define var x-cta as char format "x(14)".
define var x-dir as char format "x(40)".

x-factor = 0.0833.
x-factor = 1.
x-tipo   = F-tc .
IF pCodMon = 1 
THEN x-tipo = 1.
ELSE x-tipo = f-Tc.

output to VALUE(pDocSal).

x-dir = "RENE DESCARTES MZ C LT 1 URB. STA RAQUEL 2DA ETAPA ATE".
IF INDEX(s-NOMCIA,"CONTINENTAL") > 0 THEN DO:
    x-nom = "CONTINENTAL S.A.".
    x-ruc = "20100038146".
END.
ELSE DO:
    x-nom = "CORPORACION DE INDUSTRIAS STANDFORD S.A.C.".
    x-ruc = "20511358907".
END.

y = 0 .
x-tot = 0.
for each Tempo-Cts where Tempo-Cts.moneda-cts = pCodMon:
    find pl-pers where pl-pers.codper = Tempo-Cts.codper no-lock no-error.
    find pl-flg-mes where pl-flg-mes.codcia  = Tempo-Cts.codcia  and
                          pl-flg-mes.periodo = Tempo-Cts.periodo and
                          pl-flg-mes.nromes  = Tempo-Cts.nromes  and
                          pl-flg-mes.codper  = Tempo-Cts.codper  no-lock no-error.
    if available pl-flg-mes and nrodpt-Cts <> "" then do: 
        x-in = 0.
        x-in = ROUND((Tempo-Cts.valcal-mes * x-factor ) / x-tipo , 2) * 100.
        x-tot = x-tot + x-in.
        y  = y + 1.
    end.
end.

/*x-tot = x-tot * 100.*/
x = "".
  x  =    "2" +
          "              " + 
          (IF pCodMon = 1 THEN "MN" ELSE "ME") +
          "      " +
          x-ruc +
          "00000000000" +
          "      " +
          string(x-tot,"999999999999999") +
          string(y,"99999")  + 
          "          " +
          "R" +
          "1" +
          " " +
          string(x-nom,"x(40)") + 
          string(x-dir,"x(40)") + 
          "                  " +          
          "      " +
          "           " +                        
          "@" .
PUT UNFORMATTED X SKIP.

for each Tempo-Cts where Tempo-Cts.moneda-cts = pCodMon:
    find pl-pers where pl-pers.codper = Tempo-Cts.codper no-lock no-error.
    find pl-flg-mes where pl-flg-mes.codcia  = Tempo-Cts.codcia  and
                          pl-flg-mes.periodo = Tempo-Cts.periodo and
                          pl-flg-mes.nromes  = Tempo-Cts.nromes  and
                          pl-flg-mes.codper  = Tempo-Cts.codper  no-lock no-error.
    if available pl-flg-mes and nrodpt-Cts <> "" then do: 
      x-in = 0.
      x-in = ROUND((Tempo-Cts.valcal-mes * x-factor ) / x-tipo, 2) * 100.  
      x-des = "".
      do I = 1 to length(left-trim(PL-PERS.nomper)):
         if substr(left-trim(PL-PERS.nomper),i,1) = " " then do:
            x-des = substr(left-trim(PL-PERS.nomper),1,i - 1).
            leave.
         end.
      end.
      if x-des = "" then  x-des = trim(PL-PERS.nomper).
    
      x-nom =   trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + x-des .  
      x-cta = substring(trim(PL-FLG-MES.nrodpt-cts),1,3) + 
                substring(trim(PL-FLG-MES.nrodpt-cts),5,8) +
                substring(trim(PL-FLG-MES.nrodpt-cts),14,1) +
                substring(trim(PL-FLG-MES.nrodpt-cts),16).
      
      x  =    "3" +
              "              " + 
              (IF pCodMon = 1 THEN "MN" ELSE "ME") +
              "      " +
              x-ruc +
              STRING(x-cta,"x(14)") +
              "   " +
              string(x-in,"999999999999999") +
              "00000" + 
              "          " +
              "R" +
              "1" +
              " " +
              string(x-nom,"x(40)") + 
              string(x-dir,"x(40)") + 
              string(YEAR(PL-PERS.fecnac)) + string(MONTH(PL-PERS.fecnac),"99") + string(DAY(PL-PERS.fecnac),"99") +          
              string(PL-PERS.NroDocId,"x(9)") +
              "1" +                        
              "      " + 
              "            " +
              "MN" +
              STRING(Tempo-Cts.Ult6Sueldos * 100 , "999999999999999").
        PUT UNFORMATTED X SKIP.
    END.  
END.  

output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cts_bif) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cts_bif Procedure 
PROCEDURE cts_bif :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pDocSal AS CHAR.
DEF INPUT PARAMETER F-tc AS DECI.
DEF INPUT PARAMETER pCodCal LIKE PL-CALC.CodCal.
DEF INPUT PARAMETER TABLE FOR tempo-cts.
  
DEFINE VARIABLE iCount AS INTEGER FORMAT "9999999" NO-UNDO.
DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cTpoPln AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cCodBco AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE iTpoMon AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE cMonto AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE cNroCta AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE iMotivo AS INTEGER FORMAT "9" NO-UNDO.

DEFINE VAR x-tipo       AS DECI INIT 0.
DEFINE VAR x-factor     AS DECI INIT 0.

/* iMotivo
    0=Para Pago CTS.
    4=Pagos de Haberes de Cuarta Categoría
    5=Pagos de Haberes de Quinta Categoría
    8=Otros Haberes Gravados
    9=Otros Haberes Exonerados
*/

CASE pCodCal:
    WHEN 6 THEN DO:
        cTpoPln = "C".
        iMotivo = 0.
    END.
    OTHERWISE DO:
        cTpoPln = "H".
        iMotivo = 5.
    END.
END CASE.

cCodBco = "038".    /* Código BIF */
iTpoMon = 1.      /* 1=Soles, 2=Dólares */

x-factor = 0.0833.
x-factor = 1.
x-tipo   = F-tc .
IF pCodMon = 1 THEN x-tipo = 1.
ELSE x-tipo = f-Tc.

OUTPUT TO VALUE(pDocSal).
FOR EACH Tempo-Cts WHERE Tempo-Cts.moneda-cts = pCodMon NO-LOCK:
    FIND pl-pers WHERE pl-pers.codper = Tempo-Cts.codper NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN NEXT.
    FIND FIRST pl-flg-mes WHERE pl-flg-mes.codcia = Tempo-Cts.codcia
        AND pl-flg-mes.periodo = Tempo-Cts.periodo
        AND pl-flg-mes.codpln = Tempo-Cts.codpln
        AND pl-flg-mes.nromes = Tempo-Cts.nromes
        AND pl-flg-mes.codper = Tempo-Cts.codper NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-flg-mes THEN NEXT.
    IF pl-flg-mes.nrodpt-cts = "" THEN NEXT.

    iCount = iCount + 1.
    CASE pl-pers.TpoDocId:
        WHEN "01" THEN cTpodoc = "1".
        WHEN "04" THEN cTpodoc = "3".
        OTHERWISE cTpodoc = "1".
    END CASE.
    cMonto = STRING(ROUND((Tempo-Cts.valcal-mes * x-factor ) / x-tipo, 2) * 100,"99999999999999").  
    cNroCta = FILL(" ", 20 - LENGTH(pl-flg-mes.nrodpt-cts)) + pl-flg-mes.nrodpt-cts.

    PUT
        iCount
        cTpodoc
        pl-pers.NroDocId FORMAT "x(11)"
        CAPS(pl-pers.patper) FORMAT "x(20)"
        CAPS(pl-pers.matper) FORMAT "x(20)"
        CAPS(pl-pers.nomper) FORMAT "x(44)"
        FILL(" ",60) FORMAT "x(60)"
        FILL(" ",10) FORMAT "x(10)"
        cTpoPln
        cCodBco
        cNroCta
        iTpoMon
        cMonto
        iMotivo
        SKIP.

END.  

 OUTPUT CLOSE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cts_interbank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cts_interbank Procedure 
PROCEDURE cts_interbank :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pDocSal AS CHAR.
DEF INPUT PARAMETER F-tc AS DECI.
DEF INPUT PARAMETER pCodCal LIKE PL-CALC.CodCal.
DEF INPUT PARAMETER TABLE FOR tempo-cts.
  
DEFINE VARIABLE iCount AS INTEGER FORMAT "9999999" NO-UNDO.
DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "xx" NO-UNDO.
DEFINE VARIABLE cTpoPln AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cCodBco AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE iTpoMon AS INTEGER FORMAT "99" NO-UNDO.
DEFINE VARIABLE iTpoMon2 AS INTEGER FORMAT "99" NO-UNDO.
DEFINE VARIABLE cMonto AS CHARACTER FORMAT "x(15)" NO-UNDO.
DEFINE VARIABLE cNroCta AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE iMotivo AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE iUltSueldo AS int64 FORMAT "999999999999999".
DEFINE VARIABLE cNroDocId LIKE PL-PERS.NroDocId NO-UNDO.

DEFINE VAR x-tipo       AS DECI INIT 0.
DEFINE VAR x-factor     AS DECI INIT 0.

/* iMotivo
    0=Para Pago CTS.
    4=Pagos de Haberes de Cuarta Categoría
    5=Pagos de Haberes de Quinta Categoría
    8=Otros Haberes Gravados
    9=Otros Haberes Exonerados
*/

CASE pCodCal:
    WHEN 6 THEN DO:
        cTpoPln = "C".
        iMotivo = 0.
    END.
    OTHERWISE DO:
        cTpoPln = "H".
        iMotivo = 5.
    END.
END CASE.

cCodBco = "038".    /* Código BIF */
iTpoMon = 1.      /* 1=Soles, 2=Dólares */

x-factor = 0.0833.
x-factor = 1.
x-tipo   = F-tc .
IF pCodMon = 1 THEN x-tipo = 1.
ELSE x-tipo = f-Tc.

DEFINE VAR x-nombres AS CHAR.

OUTPUT TO VALUE(pDocSal).
FOR EACH Tempo-Cts NO-LOCK WHERE Tempo-Cts.moneda-cts = pCodMon:
    FIND pl-pers WHERE pl-pers.codper = Tempo-Cts.codper NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN NEXT.
    FIND FIRST pl-flg-mes WHERE pl-flg-mes.codcia = Tempo-Cts.codcia
        AND pl-flg-mes.periodo = Tempo-Cts.periodo
        AND pl-flg-mes.codpln = Tempo-Cts.codpln
        AND pl-flg-mes.nromes = Tempo-Cts.nromes
        AND pl-flg-mes.codper = Tempo-Cts.codper NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-flg-mes THEN NEXT.
    IF pl-flg-mes.nrodpt-cts = "" THEN NEXT.

    iCount = iCount + 1.
    CASE pl-pers.TpoDocId:
        WHEN "01" THEN cTpodoc = "01".
        WHEN "02" THEN cTpodoc = "03".
        WHEN "04" THEN cTpodoc = "03".
        OTHERWISE cTpodoc = "01".
    END CASE.
    cMonto = STRING(ROUND((Tempo-Cts.valcal-mes * x-factor ) / x-tipo, 2) * 100,"99999999999999").  
    cMonto = STRING(ROUND(Tempo-Cts.valcal-mes * 100, 2), '999999999999999').
    cNroCta = FILL(" ", 20 - LENGTH(pl-flg-mes.nrodpt-cts)) + pl-flg-mes.nrodpt-cts.
    cNroCta = pl-flg-mes.nrodpt-cts.
    iTpoMon = (IF Tempo-Cts.moneda-cts = 1 THEN 01 ELSE 10).
    iTpoMon2 = iTpoMon.
    iUltSueldo = 0.
    cNroDocId = PL-PERS.NroDocId.

    x-nombres = TRIM(pl-pers.nomper).
    x-nombres = REPLACE(x-nombres,"  "," ").
    x-nombres = TRIM(x-nombres).
    x-nombres = REPLACE(x-nombres," ",";").

    FIND LAST pl-mov-mes USE-INDEX IDX02 WHERE PL-MOV-MES.CodCia = s-codcia
        AND PL-MOV-MES.Periodo = (IF Tempo-Cts.nromes = 12 THEN Tempo-Cts.periodo - 1 ELSE Tempo-Cts.periodo)
        AND PL-MOV-MES.codpln = Tempo-Cts.codpln
        AND PL-MOV-MES.codcal = 000
        AND PL-MOV-MES.codper = Tempo-Cts.codper
        AND PL-MOV-MES.CodMov = 101
        AND PL-MOV-MES.NroMes < Tempo-Cts.nromes
        NO-LOCK NO-ERROR.
    IF AVAILABLE pl-mov-mes THEN iUltSueldo =  ROUND(PL-MOV-MES.valcal-mes * 100 * 4, 0).
    PUT 
        '07'            FORMAT 'x(2)'
        cNroDocId        FORMAT 'x(20)'
        ' ' FORMAT 'x'
        FILL(' ',20)     FORMAT 'x(20)'
        FILL(' ',8)     FORMAT 'x(8)'
        iTpoMon
        cMonto 
        '0'             FORMAT 'x'
        '09'            FORMAT 'x(2)'
        '007'           FORMAT 'x(3)'
        iTpoMon
        SUBSTRING(cNroCta,1,3) FORMAT 'x(3)'
        SUBSTRING(cNroCta,4) FORMAT 'x(20)'
        'P' FORMAT 'x'
        cTpoDoc
        pl-pers.NroDocId FORMAT "x(15)"
        pl-pers.patper /*+ ";"*/  FORMAT "x(20)"
        pl-pers.matper /*+ ";"*/   FORMAT "x(20)"
        x-nombres   FORMAT "x(20)"
        iTpoMon2
        iUltSueldo
        SKIP.
END.  

OUTPUT CLOSE. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cts_sbp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cts_sbp Procedure 
PROCEDURE cts_sbp :
/*------------------------------------------------------------------------------
  Purpose:     CTS SCOTIABANK PERU
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER cFile-Name AS CHAR.
DEF INPUT PARAMETER F-tc AS DECI.
DEF INPUT PARAMETER TABLE FOR Tempo-Cts.

DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cTpoPln AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cCodBco AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE iTpoMon AS INTEGER FORMAT "99" NO-UNDO.
DEFINE VARIABLE cMonto AS CHARACTER FORMAT "x(11)" NO-UNDO.
DEFINE VARIABLE cNroCta AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE iMotivo AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE dFecha AS DATE NO-UNDO.
DEFINE VARIABLE cNroDocId LIKE pl-pers.NroDocId FORMAT 'x(12)' NO-UNDO.
DEFINE VAR x-tipo       AS DECI INIT 0.

x-tipo   = F-tc .
IF pCodMon = 1 THEN x-tipo = 1.
ELSE x-tipo = f-Tc.

OUTPUT STREAM s-Archivo TO VALUE(cFile-Name).

FOR EACH Tempo-Cts NO-LOCK:
    FIND pl-pers WHERE pl-pers.codper = Tempo-Cts.codper NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN NEXT.
    FIND FIRST pl-flg-mes WHERE pl-flg-mes.codcia = Tempo-Cts.codcia
        AND pl-flg-mes.periodo = Tempo-Cts.periodo
        AND pl-flg-mes.codpln = Tempo-Cts.codpln
        AND pl-flg-mes.nromes = Tempo-Cts.nromes
        AND pl-flg-mes.codper = Tempo-Cts.codper NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-flg-mes THEN NEXT.
    
    IF TRUE <> (pl-flg-mes.nrodpt-cts > "") THEN NEXT.

    CASE pl-pers.TpoDocId:
        WHEN "01" THEN cTpodoc = "1".      /* DNI */
        WHEN "02" THEN cTpodoc = "2".      /* Extranjeria */
        WHEN "04" THEN cTpodoc = "3".      /* Pasaporte */
        OTHERWISE cTpodoc = "1".
    END CASE.

    cMonto = STRING((ROUND(Tempo-Cts.valcal-mes / x-Tipo,2)),"99999999.99").
    cNroCta = pl-flg-mes.nrodpt-cts.
    dFecha = DATE(pl-flg-mes.nromes,01,pl-flg-mes.periodo).
    dFecha = ADD-INTERVAL(dFecha,1,'month') - 1.
    cNroDocId = PL-PERS.NroDocId.
    iTpoMon = (IF pCodMon = 1 THEN 0 ELSE 1).

    PUT STREAM s-Archivo
        cTpoDoc
        cNroDocId   FORMAT 'x(12)'
        TRIM(pl-pers.nomper) + " " + 
        TRIM(pl-pers.patper) + " " + 
        TRIM(pl-pers.matper) FORMAT "x(60)"
        "1"
        FILL(" ",3) FORMAT 'x(3)'
        SUBSTRING(cNroCta,1,7) FORMAT 'x(7)'
        FILL(" ",20) FORMAT 'x(20)'
        cMonto
        iTpoMon
        FILL(" ",20) FORMAT 'x(20)'
        "05" FORMAT 'x(2)'
        SKIP.
END.  

OUTPUT STREAM s-Archivo CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sueldo_bbva) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sueldo_bbva Procedure 
PROCEDURE sueldo_bbva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER cFile-Name AS CHAR.
DEF INPUT PARAMETER COMBO-canal AS CHAR.
DEF INPUT PARAMETER pCodCal AS INTE.
DEF INPUT PARAMETER TABLE FOR tempo.


DEFINE VAR xlLinea AS CHAR format "x(254)".

DEFINE VAR lOficina AS CHAR.
DEFINE VAR lControl AS CHAR.
DEFINE VAR lCuenta AS CHAR.
DEFINE VAR lImpTot AS DEC.
DEFINE VAR lTipoProc AS CHAR.
DEFINE VAR lFechProc AS CHAR.
DEFINE VAR lHoraProc AS CHAR.
DEFINE VAR lDescri AS CHAR.
DEFINE VAR lNumTrab AS INT.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lCTaCargo AS CHAR.
DEFINE VAR lCTaTraba AS CHAR.

IF INDEX(cFile-Name,".") = 0 THEN DO:
    cFile-Name = cFile-Name + ".txt".
END.
lOficina    = '1234'.   /* 4 Digitos*/
lCOntrol    = '00'.     /* 2 Digitos */
lCuenta     = ''.       /* 10 Digitos */
lImpTot     = 0.
lTipoProc   = "H".      /* A:Immediato  H:Hora de Proceso  F:Fecha Futura */
lFechProc   = "        ".    /* 8 Spaceios */
lHoraProc   = " ".       /* B:11am C:03pm D:07pm */
lDescri     = "HABERES".
lNumTrab    = 5.        /* Total de trabajadores */
lFiler      = FILL(" ",68).

/*  Cuenta inicial  : 00110130010000000455 
    Cuenta SLeon    : 00110130240100000455      15Ene2015
*/
lCTaCargo   = "00110130240100000455".        /* 20 Digitos */               
lCTaTraba   = "".        /* 20 Digitos */
/* RHC 07/05/2014 */
FIND pl-pago WHERE pl-pago.cnpago = COMBO-canal NO-LOCK NO-ERROR.
IF AVAILABLE pl-pago THEN lCTaCargo = TRIM(pl-pago.libre_c01) + FILL(" ", 20 - LENGTH(TRIM(pl-pago.libre_c01)) ).

IF lTipoProc="F" THEN DO:
    lFechProc =  STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99").
END.
IF lTipoProc="H" THEN DO:
    lHoraProc = "D".
END.
lDescri = lDescri + FILL(" ", 25 - LENGTH(lDescri)).

/* Calculo el Importe total */
lNumTrab = 0.
for each tempo WHERE (lListaTest = "" OR LOOKUP(tempo.codper,lListaTest) > 0) :
    lImpTot = lImpTot + tempo.valcal-mes.
    lNumTrab = lNumTrab + 1.
END.

lImpTot     = lImpTot * 100.

OUTPUT TO VALUE(cFile-Name).       
/*OUTPUT STREAM lLinea TO cFile-Name.*/

/* Cabecera (lOficina + lControl + lCuenta)*/
xlLinea = '700' + lCtaCargo + "PEN" + STRING(lImpTot,"999999999999999") + 
        lTipoProc + lFechProc + lHoraProc + lDescri + STRING(lNumTrab,"999999") + "S" + lFiler.

/*DISPLAY lLinea  WITH no-labels WIDTH 300.*/
PUT UNFORMATTED xlLinea FORMAT "x(151)" SKIP .

/* Detalle */
for each tempo WHERE (lListaTest = "" OR LOOKUP(tempo.codper,lListaTest) > 0) :
    xlLinea = "002".
    find pl-pers where pl-pers.codper = tempo.codper no-lock no-error.
    find first pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                      pl-flg-mes.periodo = tempo.periodo and
                      pl-flg-mes.nromes  = tempo.nromes  and
                      pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    if available pl-flg-mes and (lListaTest <> "" OR pl-flg-mes.cnpago = "BBVA") THEN DO:
        if available pl-flg-mes and pl-flg-mes.nrodpt <> "" then do: 
            /* Tipo Dcto */
            CASE pl-pers.tpodocid :
                WHEN '01' THEN DO:
                    xlLinea = xlLinea + "L".
                END.
                WHEN '04' THEN DO:
                    xlLinea = xlLinea + "E".
                END.
                WHEN '06' THEN DO:
                    xlLinea = xlLinea + "R".
                END.
                WHEN '07' THEN DO:
                    xlLinea = xlLinea + "P".
                END.
            END CASE.
            /* Nro Dcto */
            xlLinea = xlLinea + TRIM(pl-pers.nrodocid) + FILL(" ",(12 - LENGTH(TRIM(pl-pers.nrodocid)))).
            /* Tipo de Abono */
            xlLinea = xlLinea + "P".
            /* Cuenta de deposito */
            IF lListaTest = "" THEN DO:
                lCTaTraba = TRIM(pl-flg-mes.nrodpt).
            END.
            ELSE DO:
                lCtaTraba = ENTRY(LOOKUP(tempo.codper,lListaTest),lCtasTest,",").
            END.
            
            lCTaTraba = lCtaTraba + FILL(" ", 20 - LENGTH(lCtaTraba)).
            /*lLinea = lLinea + "0011" + lOficina + lCOntrol + TRIM(pl-flg-mes.nrodpt).*/
            xlLinea = xlLinea + lCtaTraba.
            /* Beneficiario */
            lFiler = SUBSTRING( trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + trim(PL-PERS.nomper),1,40).
            lFiler = TRIM(lFiler).
            lFiler = lFiler + FILL(" ",40 - LENGTH(lFiler)).
            xlLinea = xlLinea + lFiler.
            /* Importe */
            lFiler = STRING((tempo.valcal-mes ) * 100,"999999999999999").
            xlLinea = xlLinea + lFiler.
            /* Descripcion Abono */
            lFiler = IF (tempo.CodCal = 002) THEN "PAGO 15 ADELANTO" ELSE "PAGO FIN DE MES ADELANTO".
            lFiler = lFiler + FILL(" ",40 - LENGTH(lFiler)).
            xlLinea = xlLinea + lFiler.
            /* Indicador aviso */
            lFiler = " ".
            xlLinea = xlLinea + lFiler.
            /* Medio de aviso */
            lFiler = FILL(" ",50).
            xlLinea = xlLinea + lFiler.

            /* Relleno */
            lFiler = FILL(" ",51).
            xlLinea = xlLinea + lFiler.


            /*DISPLAY xlLinea  WITH no-labels WIDTH 500.*/
            PUT UNFORMATTED xlLinea FORMAT "x(233)" SKIP.
        end.
    END.   
  
end.  

output close.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sueldo_bcp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sueldo_bcp Procedure 
PROCEDURE sueldo_bcp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER cFile-Name AS CHAR.
DEF INPUT PARAMETER COMBO-canal AS CHAR.
DEF INPUT PARAMETER pCodCal AS INTE.
DEF INPUT PARAMETER TABLE FOR tempo.

define var x-cargo as char format "x(20)".
define var y as integer init 0.
define var x-tot as deci init 0.
define var x-tipo as deci init 0.
define var x-factor as deci init 0.
define var i as integer .
define var x-des as char.
define var x-chek as deci .

define var x-in as DECIMAL.
define var x-de as integer.
define var x-nom as char format "x(40)".
define var x as char format "x(200)".
define var x-cta as char format "x(11)".
define var x-dir as char format "x(40)".

DEFINE VAR x-tipodoc AS CHAR FORMAT 'x(1)'.

IF INDEX(cFile-Name,".") = 0 THEN DO:
    cFile-Name = cFile-Name + ".txt".
END.

x-dir = "RENE DESCARTES MZ C LT 1 URB. STA RAQUEL 2DA ETAPA ATE".
x-nom = "CONTINENTAL S.A.".
x-cargo = "19101179051005      ".
/* RHC 07/05/2014 */
FIND pl-pago WHERE pl-pago.cnpago = COMBO-canal NO-LOCK NO-ERROR.
IF AVAILABLE pl-pago THEN x-cargo = TRIM(pl-pago.libre_c01) + FILL(" ", 20 - LENGTH(TRIM(pl-pago.libre_c01)) ).

/* BOrramos registros que sobren */
y = 0 .
x-tot = 0.
x-chek = 0.
for each tempo:
    find FIRST pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  
        and pl-flg-mes.periodo = tempo.periodo 
        and pl-flg-mes.nromes  = tempo.nromes  
        and pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    IF NOT AVAILABLE pl-flg-mes THEN DO:
        DELETE Tempo.
        NEXT.
    END.
    if (pl-flg-mes.cnpago = "EFECTIVO" OR pl-flg-mes.cnpago = "") THEN DO:
        DELETE Tempo.
        NEXT .
    END.
    IF pl-flg-mes.nrodpt = "" THEN DO:
        DELETE Tempo.
        NEXT.
    END.
    x-in = (tempo.valcal-mes).
    x-tot = x-tot + x-in.
    x-chek = x-chek + DECI(substring(nrodpt,5,8)).
    y  = y + 1.
end.
x-chek = x-chek + DECI(substring(x-cargo,4,8)).

DEF VAR x-CheckSum AS INT64 NO-UNDO.
DEF VAR x-CtaCargo AS CHAR INIT "1911179051005" NO-UNDO.

/* Calculamos ChekSum */

for each tempo :
    find pl-pers where pl-pers.codper = tempo.codper no-lock no-error.
    find first pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                      pl-flg-mes.periodo = tempo.periodo and
                      pl-flg-mes.nromes  = tempo.nromes  and
                      pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    x-Cta = REPLACE(PL-FLG-MES.nrodpt,"-","").
    x-CheckSum = x-CheckSum + DECIMAL(SUBSTRING(x-Cta,4)).
END.
x-CheckSum = x-CheckSum + DECIMAL(SUBSTRING(x-CtaCargo,4)).

OUTPUT TO VALUE(cFile-Name).
X = "1" +
    STRING(Y,'999999') +
    string(YEAR(TODAY),"9999") + string(MONTH(TODAY),"99") +  string(DAY(TODAY),"99")  + 
    "X" +
    "C" +
    "0001" +
    STRING(x-CtaCargo,'x(20)') +

    STRING(x-tot,"99999999999999.99") +

    FILL(" ",40) +
    STRING(x-CheckSum, '999999999999999')
    .
PUT UNFORMATTED X SKIP.

for each tempo :
    find pl-pers where pl-pers.codper = tempo.codper no-lock no-error.
    find first pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                      pl-flg-mes.periodo = tempo.periodo and
                      pl-flg-mes.nromes  = tempo.nromes  and
                      pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    x-in = (tempo.valcal-mes ).  
    x-des = "".
    do I = 1 to length(left-trim(PL-PERS.nomper)):
        if substr(left-trim(PL-PERS.nomper),i,1) = " " then do:
            x-des = substr(left-trim(PL-PERS.nomper),1,i - 1).
            leave.
        END.
    END.
    if x-des = "" then  x-des = trim(PL-PERS.nomper).
    x-nom =   trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + x-des .  
    x-cta = substring(PL-FLG-MES.nrodpt,1,3) + substring(PL-FLG-MES.nrodpt,5,8) + substring(PL-FLG-MES.nrodpt,14,1) + substring(PL-FLG-MES.nrodpt,16,2).
    x-Cta = REPLACE(PL-FLG-MES.nrodpt,"-","").

    X = "2" +
        "A" +
        STRING(x-Cta,'x(20)').
    CASE pl-pers.TpoDocId:
        WHEN '04' THEN X = X + "3".
        WHEN '07' THEN X = X + "4".
        OTHERWISE X = X + "1".
    END CASE.
    X = X + 
        STRING(PL-PERS.NroDocId, 'x(12)') +
        "   " +
        STRING(x-nom, 'x(75)') +
        FILL(" ",40) +
        FILL(" ",20) +
        "0001" +
        STRING(x-in,"99999999999999.99") +
        "N"
        .
    PUT UNFORMATTED X SKIP.
END.  

output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sueldo_bcp_old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sueldo_bcp_old Procedure 
PROCEDURE sueldo_bcp_old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER cFile-Name AS CHAR.
DEF INPUT PARAMETER COMBO-canal AS CHAR.
DEF INPUT PARAMETER pCodCal AS INTE.
DEF INPUT PARAMETER TABLE FOR tempo.

define var x-cargo as char format "x(20)".
define var y as integer init 0.
define var x-tot as deci init 0.
define var x-tipo as deci init 0.
define var x-factor as deci init 0.
define var i as integer .
define var x-des as char.
define var x-chek as deci .

define var x-in as DECIMAL.
define var x-de as integer.
define var x-nom as char format "x(40)".
define var x as char format "x(200)".
define var x-cta as char format "x(11)".
define var x-dir as char format "x(40)".

DEFINE VAR x-tipodoc AS CHAR FORMAT 'x(1)'.

IF INDEX(cFile-Name,".") = 0 THEN DO:
    cFile-Name = cFile-Name + ".txt".
END.

x-dir = "RENE DESCARTES MZ C LT 1 URB. STA RAQUEL 2DA ETAPA ATE".
x-nom = "CONTINENTAL S.A.".
x-cargo = "19101179051005      ".
/* RHC 07/05/2014 */
FIND pl-pago WHERE pl-pago.cnpago = COMBO-canal NO-LOCK NO-ERROR.
IF AVAILABLE pl-pago THEN x-cargo = TRIM(pl-pago.libre_c01) + FILL(" ", 20 - LENGTH(TRIM(pl-pago.libre_c01)) ).

/* BOrramos registros que sobren */
y = 0 .
x-tot = 0.
x-chek = 0.
for each tempo:
    find FIRST pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  
        and pl-flg-mes.periodo = tempo.periodo 
        and pl-flg-mes.nromes  = tempo.nromes  
        and pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    IF NOT AVAILABLE pl-flg-mes THEN DO:
        DELETE Tempo.
        NEXT.
    END.
    if (pl-flg-mes.cnpago = "EFECTIVO" OR pl-flg-mes.cnpago = "") THEN DO:
        DELETE Tempo.
        NEXT .
    END.
    IF pl-flg-mes.nrodpt = "" THEN DO:
        DELETE Tempo.
        NEXT.
    END.
    x-in = (tempo.valcal-mes  ) * 100.
    x-tot = x-tot + x-in.
    x-chek = x-chek + DECI(substring(nrodpt,5,8)).
    y  = y + 1.
end.
x-chek = x-chek + DECI(substring(x-cargo,4,8)).

x = "#" +
    "1" + 
    "H" +
    "C" +
    STRING(x-cargo,"x(20)") +          
    "S/" +
    string(x-tot,"999999999999999") +
    string(DAY(TODAY),"99")  + string(MONTH(TODAY),"99") + string(YEAR(TODAY),"9999") +
    "PAGO DE HABERES     " +
    string(x-chek,"999999999999999") + 
    STRING(y,"999999") +
    "1" +
    "               " + 
    "0".

OUTPUT TO VALUE(cFile-Name).
DISPLAY x  WITH no-labels WIDTH 300.
for each tempo :
    find pl-pers where pl-pers.codper = tempo.codper no-lock no-error.
    find first pl-flg-mes where pl-flg-mes.codcia  = tempo.codcia  and
                      pl-flg-mes.periodo = tempo.periodo and
                      pl-flg-mes.nromes  = tempo.nromes  and
                      pl-flg-mes.codper  = tempo.codper  no-lock no-error.
    x-in = (tempo.valcal-mes ) * 100.  
    x-des = "".
    do I = 1 to length(left-trim(PL-PERS.nomper)):
        if substr(left-trim(PL-PERS.nomper),i,1) = " " then do:
            x-des = substr(left-trim(PL-PERS.nomper),1,i - 1).
            leave.
        END.
    END.
    if x-des = "" then  x-des = trim(PL-PERS.nomper).
    x-nom =   trim(PL-PERS.patper) + " " + trim(PL-PERS.matper) + " " + x-des .  
    x-cta = substring(PL-FLG-MES.nrodpt,1,3) + substring(PL-FLG-MES.nrodpt,5,8) + substring(PL-FLG-MES.nrodpt,14,1) + substring(PL-FLG-MES.nrodpt,16,2).
    x  =  " " +
          "2" + 
          "A" +
          STRING(x-cta,"x(20)") +
          string(x-nom,"x(40)") + 
          "S/" + 
          string(x-in,"999999999999999") +
          "PAGO DE HABERES                         " +
          "0".
    CASE pl-pers.TpoDocId:
        WHEN '04' THEN X = X + "CE ".
        WHEN '07' THEN X = X + "PAS".
        OTHERWISE X = X + "DNI".
    END CASE.

    x-tipodoc = "   1" .
    IF pl-pers.TpoDocId = '04' THEN x-tipodoc = "   3" .
    /* IF pl-pers.TpoDocId = '07' THEN x-tipodoc = "   4" . Correo Flor Saavedra 13Jun2018 */

    /*X = X + string(PL-PERS.NroDocId,"x(9)") + "   1" .*/
    X = X + string(PL-PERS.NroDocId,"x(9)") + x-tipodoc .
    
    DISPLAY x  WITH no-labels WIDTH 300.
END.  

output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sueldo_bif) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sueldo_bif Procedure 
PROCEDURE sueldo_bif :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER cFile-Name AS CHAR.
DEF INPUT PARAMETER COMBO-canal AS CHAR.
DEF INPUT PARAMETER pCodCal AS INTE.
DEF INPUT PARAMETER TABLE FOR tempo.

DEFINE VARIABLE iCount AS INTEGER FORMAT "9999999" NO-UNDO.
DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cTpoPln AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cCodBco AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE iTpoMon AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE cMonto AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE cNroCta AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE iMotivo AS INTEGER FORMAT "9" NO-UNDO.

/* iMotivo
    0=Para Pago CTS.
    4=Pagos de Haberes de Cuarta Categoría
    5=Pagos de Haberes de Quinta Categoría
    8=Otros Haberes Gravados
    9=Otros Haberes Exonerados
*/

/*CASE PL-CALC.CodCal:*/
CASE pCodCal:
    WHEN 6 THEN DO:
        cTpoPln = "C".
        iMotivo = 0.
    END.
    OTHERWISE DO:
        cTpoPln = "H".
        iMotivo = 5.
    END.
END CASE.

cCodBco = "038".    /* Código BIF */
iTpoMon = 1.      /* 1=Soles, 2=Dólares */

OUTPUT TO VALUE(cFile-Name).

FOR EACH tempo NO-LOCK:

    FOR pl-pers
        FIELDS (pl-pers.codper pl-pers.patper pl-pers.matper pl-pers.nomper
            pl-pers.TpoDocId pl-pers.NroDocId)
        WHERE pl-pers.codper = tempo.codper NO-LOCK:
    END.
    IF NOT AVAILABLE pl-pers THEN NEXT.

    FOR FIRST pl-flg-mes
        FIELDS (pl-flg-mes.codcia pl-flg-mes.periodo pl-flg-mes.nromes
            pl-flg-mes.codpln pl-flg-mes.codper pl-flg-mes.nrodpt)
        WHERE pl-flg-mes.codcia = tempo.codcia
        AND pl-flg-mes.periodo = tempo.periodo
        AND pl-flg-mes.codpln = tempo.codpln
        AND pl-flg-mes.nromes = tempo.nromes
        AND pl-flg-mes.codper = tempo.codper NO-LOCK:
    END.

    IF NOT AVAILABLE pl-flg-mes THEN NEXT.

    IF pl-flg-mes.nrodpt = "" THEN NEXT.

    iCount = iCount + 1.

    CASE pl-pers.TpoDocId:
        WHEN "01" THEN cTpodoc = "1".
        WHEN "04" THEN cTpodoc = "3".
        OTHERWISE cTpodoc = "1".
    END CASE.

    cMonto = STRING((tempo.valcal-mes * 100),"99999999999999").
    cNroCta = FILL(" ", 20 - LENGTH(pl-flg-mes.nrodpt)) + pl-flg-mes.nrodpt.

    PUT
        iCount
        cTpodoc
        pl-pers.NroDocId FORMAT "x(11)"
        CAPS(pl-pers.patper) FORMAT "x(20)"
        CAPS(pl-pers.matper) FORMAT "x(20)"
        CAPS(pl-pers.nomper) FORMAT "x(44)"
        FILL(" ",60) FORMAT "x(60)"
        FILL(" ",10) FORMAT "x(10)"
        cTpoPln
        cCodBco
        cNroCta
        iTpoMon
        cMonto
        iMotivo
        SKIP.

END.  

OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sueldo_interbank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sueldo_interbank Procedure 
PROCEDURE sueldo_interbank :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER cFile-Name AS CHAR.
DEF INPUT PARAMETER COMBO-canal AS CHAR.
DEF INPUT PARAMETER pCodCal AS INTE.
DEF INPUT PARAMETER TABLE FOR tempo.

DEFINE VARIABLE iCount AS INTEGER FORMAT "99" NO-UNDO.
DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "xx" NO-UNDO.
DEFINE VARIABLE cTpoPln AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cCodBco AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE iTpoMon AS INTEGER FORMAT "99" NO-UNDO.
DEFINE VARIABLE cMonto AS CHARACTER FORMAT "x(15)" NO-UNDO.
DEFINE VARIABLE cNroCta AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE iMotivo AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE dFecha AS DATE NO-UNDO.
DEFINE VARIABLE cNroDocId LIKE pl-pers.NroDocId NO-UNDO.
/* iMotivo
    0=Para Pago CTS.
    4=Pagos de Haberes de Cuarta Categoría
    5=Pagos de Haberes de Quinta Categoría
    8=Otros Haberes Gravados
    9=Otros Haberes Exonerados
*/

/*CASE PL-CALC.CodCal:*/
CASE pCodCal:
    WHEN 6 THEN DO:
        cTpoPln = "C".
        iMotivo = 0.
    END.
    OTHERWISE DO:
        cTpoPln = "H".
        iMotivo = 5.
    END.
END CASE.

cCodBco = "038".    /* Código BIF */
iTpoMon = 01.      /* 1=Soles, 10=Dólares */

OUTPUT TO VALUE(cFile-Name).

FOR EACH tempo NO-LOCK:

    FOR pl-pers
        FIELDS (pl-pers.codper pl-pers.patper pl-pers.matper pl-pers.nomper
            pl-pers.TpoDocId pl-pers.NroDocId)
        WHERE pl-pers.codper = tempo.codper NO-LOCK:
    END.
    IF NOT AVAILABLE pl-pers THEN NEXT.

    FOR FIRST pl-flg-mes
        FIELDS (pl-flg-mes.codcia pl-flg-mes.periodo pl-flg-mes.nromes
            pl-flg-mes.codpln pl-flg-mes.codper pl-flg-mes.nrodpt)
        WHERE pl-flg-mes.codcia = tempo.codcia
        AND pl-flg-mes.periodo = tempo.periodo
        AND pl-flg-mes.codpln = tempo.codpln
        AND pl-flg-mes.nromes = tempo.nromes
        AND pl-flg-mes.codper = tempo.codper NO-LOCK:
    END.

    IF NOT AVAILABLE pl-flg-mes THEN NEXT.

    IF pl-flg-mes.nrodpt = "" THEN NEXT.

    iCount = 02.

    CASE pl-pers.TpoDocId:
        WHEN "01" THEN cTpodoc = "01".      /* DNI */
        WHEN "02" THEN cTpodoc = "03".      /* Extranjeria */
        WHEN "04" THEN cTpodoc = "05".      /* Pasaporte */
        OTHERWISE cTpodoc = "01".
    END CASE.

    cMonto = STRING((tempo.valcal-mes * 100),"999999999999999").
    cNroCta = REPLACE(pl-flg-mes.nrodpt,'-','').
    dFecha = DATE(pl-flg-mes.nromes,01,pl-flg-mes.periodo).
    dFecha = ADD-INTERVAL(dFecha,1,'month') - 1.
    cNroDocId = PL-PERS.NroDocId.
    PUT
        '02'        FORMAT 'x(2)'
        cNroDocId   FORMAT 'x(20)'
        ' '         FORMAT 'x'              /* ¿F? */
        '003'       FORMAT 'x(20)'
        STRING(YEAR(dFecha),'9999') + STRING(MONTH(dFecha),'99') + STRING(DAY(dFecha),'99') FORMAT 'x(8)'
        iTpoMon
        cMonto
        '0'         FORMAT 'x'
        '09'        FORMAT 'x(2)'
        '002'       FORMAT 'x(3)'
        iTpoMon
        SUBSTRING(cNroCta,1,3) FORMAT 'x(3)'
        SUBSTRING(cNroCta,4) FORMAT 'x(20)'
        'P' FORMAT 'x'
        cTpoDoc
        pl-pers.NroDocId FORMAT "x(15)"
        pl-pers.patper   FORMAT "x(20)"
        pl-pers.matper   FORMAT "x(20)"
        pl-pers.nomper   FORMAT "x(20)"
        SKIP.
END.  

OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sueldo_sbp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sueldo_sbp Procedure 
PROCEDURE sueldo_sbp :
/*------------------------------------------------------------------------------
  Purpose:     PLANILLA DE SUELDO SCOTIABANK PERU
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER cFile-Name AS CHAR.
DEF INPUT PARAMETER COMBO-canal AS CHAR.
DEF INPUT PARAMETER pCodCal AS INTE.
DEF INPUT PARAMETER TABLE FOR tempo.

DEFINE VARIABLE iCount AS INTEGER FORMAT "99" NO-UNDO.
DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cTpoPln AS CHARACTER FORMAT "x" NO-UNDO.
DEFINE VARIABLE cCodBco AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE iTpoMon AS INTEGER FORMAT "99" NO-UNDO.
DEFINE VARIABLE cMonto AS CHARACTER FORMAT "x(11)" NO-UNDO.
DEFINE VARIABLE cNroCta AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE iMotivo AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE dFecha AS DATE NO-UNDO.
DEFINE VARIABLE cNroDocId LIKE pl-pers.NroDocId NO-UNDO.


iTpoMon = 00.    /* SOLES por defecto */
OUTPUT STREAM s-Archivo TO VALUE(cFile-Name).

FOR EACH tempo NO-LOCK:
    FOR pl-pers
        FIELDS (pl-pers.codper pl-pers.patper pl-pers.matper pl-pers.nomper
            pl-pers.TpoDocId pl-pers.NroDocId)
        WHERE pl-pers.codper = tempo.codper NO-LOCK:
    END.
    IF NOT AVAILABLE pl-pers THEN NEXT.

    FOR FIRST pl-flg-mes
        FIELDS (pl-flg-mes.codcia pl-flg-mes.periodo pl-flg-mes.nromes
            pl-flg-mes.codpln pl-flg-mes.codper pl-flg-mes.nrodpt)
        WHERE pl-flg-mes.codcia = tempo.codcia
        AND pl-flg-mes.periodo = tempo.periodo
        AND pl-flg-mes.codpln = tempo.codpln
        AND pl-flg-mes.nromes = tempo.nromes
        AND pl-flg-mes.codper = tempo.codper NO-LOCK:
    END.

    IF NOT AVAILABLE pl-flg-mes THEN NEXT.

    IF pl-flg-mes.nrodpt = "" THEN NEXT.

    iCount = 02.

    CASE pl-pers.TpoDocId:
        WHEN "01" THEN cTpodoc = "1".      /* DNI */
        WHEN "02" THEN cTpodoc = "2".      /* Extranjeria */
        WHEN "04" THEN cTpodoc = "3".      /* Pasaporte */
        OTHERWISE cTpodoc = "1".
    END CASE.

    cMonto = STRING((tempo.valcal-mes),"99999999.99").
    cNroCta = REPLACE(pl-flg-mes.nrodpt,'-','').
    dFecha = DATE(pl-flg-mes.nromes,01,pl-flg-mes.periodo).
    dFecha = ADD-INTERVAL(dFecha,1,'month') - 1.
    cNroDocId = PL-PERS.NroDocId.
    PUT STREAM s-Archivo UNFORMATTED
        cTpoDoc     FORMAT 'x(1)'
        cNroDocId   FORMAT 'x(12)'
        TRIM(pl-pers.nomper) + " " + 
        TRIM(pl-pers.patper) + " " + 
        TRIM(pl-pers.matper) FORMAT "x(60)"
        "3"                                     /* Cuenta Ahorro */
        SUBSTRING(cNroCta,1,3) FORMAT 'x(3)'    /* Oficina de cuenta */
        SUBSTRING(cNroCta,4,7) FORMAT 'x(7)'    /* Cuenta abono */
        FILL(' ',20) FORMAT 'x(20)'             /* CCI */
        cMonto
        "1"                                     /* 5ta categoría */
        iTpoMon FORMAT '99'                     /* 00: Soles */
        FILL(" ",20) FORMAT 'x(20)'             /* Concepto */
        "02"                                    /* Haberes */
        SKIP.
END.  

OUTPUT STREAM s-Archivo CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

