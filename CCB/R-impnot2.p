&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-fact01.p
    Purpose     : Impresion de Fact/Boletas 

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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.

DEF VAR X-Nomcli AS CHAR NO-UNDO.
DEF VAR X-Dircli AS CHAR NO-UNDO.
DEF VAR X-Ruccli AS CHAR NO-UNDO.
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR I-NroItm AS INTEGER .
DEF VAR X-TOTAL  AS DECIMAL NO-UNDO.
DEF VAR X-DESCRI AS CHAR .
DEF VAR I-NroSer AS INTEGER .
DEF BUFFER  B-CDOCU FOR CCBCDOCU.
def var x-mon as char init " " .
def var x-mon1 as char init " " .
FIND ccbcdocu WHERE ROWID(ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.
ASSIGN
    X-Nomcli = ccbcdocu.nomcli
    X-Dircli = ccbcdocu.dircli
    X-Ruccli = ccbcdocu.ruc.

FIND b-cdocu where b-cdocu.codcia = S-CODCIA AND
                   b-cdocu.coddoc = ccbcdocu.codref AND
                   b-cdocu.nrodoc = ccbcdocu.nroref no-error.
                   
FIND gn-clie WHERE gn-clie.codcia = 0 AND
     gn-clie.codcli = ccbcdocu.codcli NO-LOCK.
IF AVAILABLE gn-clie 
THEN ASSIGN
        X-Nomcli = (IF x-nomcli = '' THEN gn-clie.nomcli ELSE x-nomcli)
        X-Dircli = (IF x-dircli = '' THEN gn-clie.dircli ELSE x-dircli)
        X-Ruccli = (IF x-ruccli = '' THEN gn-clie.ruc ELSE x-ruccli).

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

IF ccbcdocu.codcli = FacCfgGn.CliVar THEN
   ASSIGN       
      X-Nomcli = Ccbcdocu.nomcli
      X-Dircli = Ccbcdocu.dircli
      X-Ruccli = Ccbcdocu.ruccli.
      
/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").
x-mon = (IF ccbcdocu.codmon = 1 THEN " S/." ELSE "US$").
x-mon1 = (IF ccbcdocu.codmon = 1 THEN " S/." ELSE "US$").

/************************  DEFINICION DE FRAMES  *******************************/


/*DEFINE FRAME F-HdrN/D
 *     HEADER
 *     SKIP(5)
 *     /*DAY(today) at 18 SPACE(5) MONTH(TODAY) SPACE(10) YEAR(TODAY) SKIP(1)*/
 *     X-nomcli AT 15 FORMAT "x(40)" SKIP
 *     X-dircli FORMAT "x(35)" SKIP(1)
 *     "SIRVASE TOMAR DEBIDA NOTA QUE EN LA FECHA LE ESTAMOS CARGANDO EN SU ESTIMABLE CUENTA" AT 8 SKIP(1)
 *     "LA CANTIDAD DE   : " AT 8  ccbcdocu.imptot skip(1)
 *     "Por Concepto de : " SKIP
 *     WITH PAGE-TOP WIDTH 255 NO-LABELS NO-BOX STREAM-IO DOWN. */
 
DEFINE FRAME F-HdrN/D
    HEADER
    /*SKIP(3)*/
    SKIP
    "N.I.T. 20100038146" AT 92 FORMAT "X(20)" SKIP(6)
    /*CcbCDocu.NomCli*/ X-nomcli AT 12 FORMAT "x(50)" SKIP
    /*CcbCDocu.DirCli*/ X-dircli AT 12 FORMAT "x(35)" SKIP
    /*CcbCDocu.RucCli*/ X-ruccli AT 12 FORMAT "x(11)"  
    CcbCDocu.CodCli AT 40 SKIP(2.5)
    CcbCDocu.Codref AT 78  FORMAT "XXXX" 
    CcbCDocu.nroref AT 83 FORMAT "XXX-XXXXXX"
    B-CDocu.FchDoc AT 98 FORMAT "99/99/9999" 
    B-CDOCU.ImpTot AT 118 FORMAT ">>>,>>9.99" 
    SKIP(1)
    CcbCDocu.NRODOC AT  78  FORMAT "XXX-XXXXXX"
    ccbcdocu.Fchdoc AT 118 FORMAT "99/99/9999"  
    SKIP(1)
    /*
    X-nomcli AT 15 FORMAT "x(40)" SKIP
    X-dircli AT 15 FORMAT "x(35)" SKIP(1)
    X-Ruccli AT 15 FORMAT "X(10)" CcbCDocu.CodCli AT 60 FORMAT "X(10)" skip(1)
    ccbcdocu.imptot at 40 skip(2)
    ccbcdocu.nrodoc at 100 format "x(10)" 
    ccbcdocu.fchdoc at 140 skip(3)
    */
    WITH PAGE-TOP WIDTH 255 NO-LABELS NO-BOX STREAM-IO DOWN. 



DEFINE FRAME F-DetaN/C
    I-NroItm FORMAT ">>>9" AT 3
    ccbddocu.codmat AT  15
    Almmmatg.Desmat AT  35 FORMAT "x(30)"
    ccbddocu.candes AT  105 FORMAT ">>>,>>9.99" 
    ccbddocu.undvta AT  117 
    ccbddocu.preuni AT 125 FORMAT ">>>,>>9.99" 
    /*CcbDDocu.Por_Dsctos[1] FORMAT ">>9.99" 
    " %"*/
    ccbddocu.implin AT 140 FORMAT ">>>,>>>9.99"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaN/D
    I-NroItm FORMAT ">>>9" AT 3
    ccbddocu.codmat AT  10
    Almmmatg.Desmat AT  30 FORMAT "x(30)"
    ccbddocu.candes AT  80 FORMAT ">>>,>>9.99" 
    ccbddocu.undvta AT  92 
    ccbddocu.preuni AT 100 FORMAT ">>>,>>9.99" 
    /*CcbDDocu.Por_Dsctos[1] FORMAT ">>9.99" 
    " %"*/
    ccbddocu.implin AT 115 FORMAT ">>>,>>>9.99"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.


DEFINE FRAME F-HdrN/C
    HEADER
    SKIP(5)
    /*CcbCDocu.NomCli*/ X-nomcli AT 12 FORMAT "x(50)" SKIP 1.5
    CcbCDocu.DirCli /*X-dircli*/ AT 12 FORMAT "x(50)" SKIP 1.5
    CcbCDocu.RucCli /*X-ruccli*/ AT 12 FORMAT "x(11)"  
    CcbCDocu.CodCli AT 60 SKIP(1.5)
    CcbCDocu.Codref AT 97  FORMAT "XXXX" 
    CcbCDocu.nroref AT 102 FORMAT "XXX-XXXXXX"
    B-CDocu.FchDoc AT 120 FORMAT "99/99/9999" 
    B-CDOCU.ImpTot AT 140 FORMAT ">>>,>>9.99" 
    SKIP(1)
    /*"DEVOLUCION DE MERCADERIA" AT 24 FORMAT "X(30)" 
    "NRO. DEV" CcbCDocu.NroOrd FORMAT "XXX-XXXXXX"*/
    CcbCDocu.NRODOC AT 97  FORMAT "XXX-XXXXXX"
    ccbcdocu.Fchdoc AT 140 FORMAT "99/99/9999"  
    SKIP(2)
/*    "Factura : " AT 18  space(5) "  Fecha Emision:" ccbcdocu.fchdoc space(5) "  Por el importe de :" CcbCDocu.ImpTOT skip(3)
 *     "Sirvase tomar debida nota que en la fecha le estamos abonando en su cuenta la cantidad de : " AT 8 CcbCDocu.ImpTOT skip
 *     "Por Concepto de : " AT 8 ccbcdocu.codmov SKIP*/
    WITH PAGE-TOP WIDTH 255 NO-LABELS NO-BOX STREAM-IO DOWN .



/*DEFINE FRAME F-FtrN/D
 *     HEADER
 *     SKIP (2)
 *     "VALOR VENTA  :     " AT 90  ccbcdocu.impvta FORMAT ">>>,>>9.99"  SKIP
 *     "SON: " X-EnLetras  "I.G.V. 18%   :     " AT 90 ccbcdocu.impigv  FORMAT ">>>,>>9.99" SKIP
 *     "S.E.U.O." AT 20 "NETO A PAGAR :     " AT 90 ccbcdocu.imptot  FORMAT ">>>,>>9.99" SKIP
 *     WITH PAGE-BOTTOM WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.*/

DEFINE FRAME F-FtrN/D
    HEADER
    "Observaciones : " FORMAT "X(17)" AT 15 
    Ccbcdocu.Glosa     FORMAT "X(60)" SKIP
    "Son : " X-EnLetras SKIP(1)
    ccbcdocu.PorIgv AT 100 FORMAT ">>9.99" "%" FORMAT "X(1)" 
    x-mon  format "x(4)" at 110
    /*ccbcdocu.impvta FORMAT ">>>,>>9.99" AT 102*/
    ccbcdocu.impigv FORMAT ">>>,>>9.99" AT 115 SKIP
    " "
    x-mon1 format "x(4)" at 110
    ccbcdocu.imptot FORMAT ">>>,>>9.99" AT 115 SKIP(2)
   
    /*
    Ccbcdocu.Glosa  at 20 Format "x(80)" skip
    CCbcdocu.Codref at 20 Format "x(5)" Ccbcdocu.Nroref at 28 format "X(15)" skip(2)    
    "SON: " X-EnLetras at 15 SKIP(3)
    x-mon at 120 format "x(4)" ccbcdocu.impigv at 130 FORMAT ">>>,>>9.99" SKIP(1)
    x-mon at 120 format "x(4)" ccbcdocu.imptot at 130 FORMAT ">>>,>>9.99" SKIP
    */
    WITH PAGE-BOTTOM WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME F-FtrN/C
    HEADER
    skip(2)
    "Observaciones : " FORMAT "X(17)" AT 15 
    Ccbcdocu.Glosa     FORMAT "X(60)" SKIP(2)
    "Son : " X-EnLetras SKIP  
    ccbcdocu.PorIgv AT 140 FORMAT ">>9.99" "%" FORMAT "X(1)" SKIP    
    /*"Imp.Brt: " FORMAT "X(9)" AT 73
    CcbCDocu.ImpBrt FORMAT ">>>,>>9.99"
    "DSCTO.: " FORMAT "X(9)"
    CcbCDocu.ImpDto FORMAT ">>>,>>9.99"
    CcbCDocu.PorDto FORMAT ">9.99"
    " %" FORMAT "X(2)" */
    x-mon  format "x(4)" at 116
    ccbcdocu.impvta FORMAT ">>>,>>9.99" AT 122
    ccbcdocu.impigv FORMAT ">>>,>>9.99" AT 140 SKIP(.5)
    ccbcdocu.imptot FORMAT ">>>,>>9.99" AT 140 SKIP(2)
/*    X-TOTAL FORMAT ">>>,>>9.99" AT 122 SKIP(4)
 * /*    ccbcdocu.imptot AT 104 FORMAT ">>,>>>9.99" SKIP(4) */
 * 
 *     "VALOR VENTA  :     " AT 102  ccbcdocu.impvta FORMAT ">>>,>>9.99"  SKIP
 * /*    ccbcdocu.impdto FORMAT ">>>,>>9.99" */
 *     "I.G.V. 18%   :     " AT 102 ccbcdocu.impigv  FORMAT ">>>,>>9.99" SKIP
 *     "Son : " X-EnLetras   "NETO A PAGAR :     "  AT 102 ccbcdocu.imptot  FORMAT ">>>,>>9.99" SKIP*/
    WITH PAGE-BOTTOM WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 1.77
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
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND 
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.CodDoc = ccbcdocu.coddoc AND
     FacCorre.NroSer = INTEGER(SUBSTRING(ccbcdocu.nrodoc, 1, 3)) 
     NO-LOCK NO-ERROR.

IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").



I-NroItm = 0.
CASE ccbcdocu.coddoc:
   WHEN "N/C" THEN DO:
    OUTPUT STREAM REPORT TO VALUE(s-port-name) PAGE-SIZE 42.
    /*PUT STREAM REPORT CONTROL CHR(27) "@" CHR(27) "C" CHR(48) CHR(18) CHR(15).*/
    PUT STREAM REPORT CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN4} .

    RUN Imp-NC-Otros.
   END.
        /*IF ccbcdocu.cndcre = 'D' THEN RUN Imp-NC-Devoluciones.
        ELSE RUN Imp-NC-Otros.*/
WHEN "N/D" 
THEN DO:
     OUTPUT STREAM REPORT TO VALUE(s-port-name) PAGE-SIZE 33.
     PUT STREAM REPORT CONTROL CHR(27) "@" CHR(27) "C" CHR(38) CHR(18) CHR(15).

     FOR EACH ccbddocu OF ccbcdocu , FIRST Ccbtabla where
                                     Ccbtabla.codcia = ccbddocu.codcia AND
                                     Ccbtabla.Tabla  = ccbddocu.codDoc AND
                                     Ccbtabla.codigo = ccbddocu.codmat
              BREAK BY ccbddocu.nrodoc
              BY ccbddocu.codmat: 
          VIEW STREAM REPORT FRAME F-HdrN/D.
          VIEW STREAM REPORT FRAME F-FtrN/D.    

          DISPLAY STREAM REPORT 
                  ccbddocu.codmat 
                  CcbTabla.nombre @ Almmmatg.Desmat
                  ccbddocu.candes
                  ccbddocu.undvta 
                  ccbddocu.preuni 
                  ccbddocu.implin
       
                  WITH FRAME F-DetaN/D.
         IF LAST-OF(ccbddocu.nrodoc) THEN DO:
              PAGE STREAM REPORT.
         END.
      END.
END. 
END CASE.
OUTPUT STREAM REPORT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-NC-Devoluciones Procedure 
PROCEDURE Imp-NC-Devoluciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      FOR EACH ccbddocu OF ccbcdocu ,
               FIRST almmmatg OF ccbddocu
               BREAK BY ccbddocu.nrodoc
                     BY ccbddocu.codmat: 
          VIEW STREAM REPORT FRAME F-HdrN/C.            
          VIEW STREAM REPORT FRAME F-FtrN/C.
          I-NroItm = I-NroItm + 1.
          X-TOTAL = X-TOTAL + ccbddocu.implin.
          DISPLAY STREAM REPORT 
                  I-NroItm 
                  ccbddocu.codmat 
                  ccbddocu.candes 
                  ccbddocu.undvta 
                  almmmatg.desmat 
                  ccbddocu.preuni 
                  ccbddocu.implin
                  WITH FRAME F-DetaN/C.
          /*DOWN WITH FRAME F-DetaN/C.*/
          IF LAST-OF(ccbddocu.nrodoc) THEN DO:
             PAGE STREAM REPORT.
          END.
      END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-NC-Otros Procedure 
PROCEDURE Imp-NC-Otros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       FOR EACH ccbddocu OF ccbcdocu WHERE BREAK BY ccbddocu.nrodoc
          BY ccbddocu.codmat: 
          x-descri = ''.
          FIND FIRST CcbTabla WHERE CcbTabla.Tabla = 'N/C' AND CcbTabla.Codigo = CcbDDocu.codmat NO-LOCK NO-ERROR.
          IF AVAILABLE CcbTabla THEN x-descri = CcbTabla.nombre.
          
          VIEW STREAM REPORT FRAME F-HdrN/C.
          VIEW STREAM REPORT FRAME F-FtrN/C.    

            FIND CcbTabla WHERE CcbTabla.CodCia = ccbddocu.codcia 
                           AND  CcbTabla.Tabla  = ccbddocu.coddoc 
                           AND  CcbTabla.Codigo = ccbddocu.CodMat
                          NO-LOCK NO-ERROR.
/*            IF AVAILABLE CcbTabla THEN 
 *                   CcbTabla.Nombre = CcbTabla.nombre.*/
          
          I-NroItm = I-NroItm + 1.
          X-TOTAL = X-TOTAL + ccbddocu.implin.
          /* MESSAGE X-DESCRI VIEW-AS ALERT-BOX. */
          DISPLAY STREAM REPORT 
                  I-NroItm 
                  ccbddocu.codmat 
                  CcbTabla.nombre @ Almmmatg.Desmat
                  ccbddocu.candes
                  ccbddocu.undvta 
                  ccbddocu.preuni 
                  ccbddocu.implin
                  WITH FRAME F-DetaN/C.
          
          IF LAST-OF(ccbddocu.nrodoc) THEN DO:
             PAGE STREAM REPORT.
          END.
      END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


