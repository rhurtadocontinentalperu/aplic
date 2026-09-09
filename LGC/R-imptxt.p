&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-impcmp.p
    Purpose     : 

    Syntax      :

    Description : Imprime Orden de Compra

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-RUCCIA AS INT.
DEFINE SHARED VARIABLE PV-CODCIA AS INTEGER.
DEF SHARED VAR S-NomCia AS CHAR.
DEF VAR C-ConPgo   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-EnLetras AS CHAR FORMAT "X(100)" NO-UNDO.
DEF VAR I-NroItm AS INTEGER NO-UNDO.
DEF VAR C-Moneda AS CHAR INIT "S/." FORMAT "X(3)".
DEF VAR C-UNIT0   AS DECIMAL INIT 0.
DEF VAR C-UNIT1   AS DECIMAL INIT 0.
DEF VAR C-UNIT2   AS DECIMAL INIT 0.
DEF VAR C-IGV     AS DECIMAL INIT 0.
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.
DEF        VAR W-DIRALM AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM AS CHAR FORMAT "X(13)".
DEF VAR N-ITEM     AS INTEGER INIT 0 NO-UNDO.
DEF VAR X-NRO      AS CHARACTER.

DEFINE STREAM Reporte.

FIND LG-COCmp WHERE ROWID(LG-COCmp) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE LG-COCmp THEN RETURN.

IF LG-COCmp.Codmon = 2 THEN C-Moneda = "US$".
FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
              AND  gn-prov.CodPro = LG-COCmp.CodPro 
             NO-LOCK NO-ERROR.

FIND gn-ConCp WHERE gn-ConCp.Codig = LG-COCmp.CndCmp NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConCp THEN C-ConPgo = Gn-ConCp.Nombr.

FIND Almacen WHERE Almacen.CodCia = LG-COCmp.CodCia 
              AND  Almacen.CodAlm = LG-COCmp.CodAlm 
             NO-LOCK NO-ERROR.

DEF VAR X-MARGEN AS DECI INIT 0.
DEF VAR X-UNDMIN AS CHAR INIT "".
DEF VAR X-equival AS DECI INIT 0.
DEF VAR X-precon AS DECI INIT 0.
DEF VAR X-porce AS char INIT "%".



/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(LG-COCmp.ImpTot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF LG-COCmp.Codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

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
         HEIGHT             = 3.38
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
def var cotfile as char init "".
def var x-file  as char init "". 
DEF VAR Rpta-1 AS LOG NO-UNDO.

cotfile = "OC" + "-" + STRING(LG-COCmp.NroDoc, "999999") + ".txt".

SYSTEM-DIALOG GET-FILE x-File FILTERS '*.txt' '*.txt' 
    INITIAL-FILTER 1 ASK-OVERWRITE CREATE-TEST-FILE 
    DEFAULT-EXTENSION 'txt' 
    RETURN-TO-START-DIR SAVE-AS 
    TITLE 'Guardar en' USE-FILENAME
    UPDATE Rpta-1.

IF Rpta-1 = NO THEN RETURN.

/*MESSAGE SKIP
 *         "Orden de Compra ha sido guardado en C:\tmp\" + cotfile skip
 *         view-as alert-box information 
 *         title cotfile.
 * */
/*x-file = "C:\tmp\" + 
 *          cotfile.*/

X-NRO = STRING(LG-COCmp.NroDoc, "999999").

OUTPUT STREAM Report TO VALUE(x-file) PAGED PAGE-SIZE 31.

PUT STREAM REPORT S-NOMCIA FORMAT "X(50)" SKIP.
PUT STREAM REPORT 'RUC 20100038146' SKIP.
/*PUT STREAM REPORT S-CODDIV TO 100 SKIP.*/
PUT STREAM REPORT 'ALM ' TO 100 Lg-cocmp.codalm  SKIP.
PUT STREAM REPORT "E-MAIL: logistica@continentalperu.com" skip.
PUT STREAM REPORT "ORDEN DE COMPRA NRO."  AT 10 FORMAT "X(22)"  X-NRO FORMAT "XXXXXXXXXXXX" SKIP.
PUT STREAM REPORT "Proveedor : " gn-prov.CodPro gn-prov.NomPro FORMAT "x(45)".
PUT STREAM REPORT "Fecha Emision :" AT 85 LG-COCmp.Fchdoc FORMAT "99/99/9999" SKIP.
PUT STREAM REPORT "RUC : " gn-prov.Ruc  FORMAT "x(11)".
PUT STREAM REPORT "Fecha Entrega :" AT 85 LG-COCmp.FchEnt FORMAT "99/99/9999" SKIP.
PUT STREAM REPORT "Direccion : " gn-prov.DirPro FORMAT "x(40)".
PUT STREAM REPORT "Fecha Maxima Entrega :" AT 78 LG-COCmp.FchVto FORMAT "99/99/9999"  SKIP.
PUT STREAM REPORT  "Representante : " .
PUT STREAM REPORT "Forma de Pago :" AT 85 C-ConPgo SKIP.
PUT STREAM REPORT "FAX : " gn-prov.FaxPro FORMAT "x(10)".
PUT STREAM REPORT "TELF: " AT 30 gn-prov.Telfnos[1] AT 37 FORMAT "x(10)".
PUT STREAM REPORT "Impuesto :" AT 50 "INCLUIDO I.G.V"  .
PUT STREAM REPORT "Moneda        :" AT 85 IF LG-COCmp.Codmon = 1 THEN "Soles" ELSE "Dolares" SKIP.
PUT STREAM REPORT "Favor entregar en : " AT 1 FORMAT "X(25)" Almacen.DirAlm  + "Telf. "   + Almacen.TelAlm  FORMAT "X(100)" SKIP.
PUT STREAM REPORT "Horario de atención : Lunes a Viernes de 9:30am. a 2:00pm. y de 3:00 a 6:00pm. - Sábado de 9:30am. a 2:00pm" SKIP.
PUT STREAM REPORT "Contacto : " Almacen.EncAlm SKIP.
PUT STREAM REPORT "---------------------------------------------------------------------------------------------------------------------------" SKIP.
PUT STREAM REPORT "IT CODIGO          DESCRIPCION                  MARCA     UM  CANTIDAD      PRECIO    DSCT-1 DSCT-2 DSCT-3     TOTAL       " SKIP.
PUT STREAM REPORT "---------------------------------------------------------------------------------------------------------------------------" SKIP.

FOR EACH LG-DOCmp WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia 
                   AND  LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc 
                   AND  LG-DOCmp.NroDoc = LG-COCmp.NroDoc NO-LOCK,
    FIRST Almmmatg OF LG-DOCmp NO-LOCK
                BREAK BY LG-DOCmp.NroDoc
                      BY LG-DOCmp.ArtPro
                      BY Almmmatg.CodMat: 
    C-IGV   = ( 1 + ( LG-DOCmp.IGVmat / 100 )).
    C-UNIT0 = ROUND(LG-DOCmp.PreUni * ( 1 - ( LG-DOCmp.Dsctos[1] / 100)),4 ). 
    C-UNIT1 = ROUND(C-UNIT0 * ( 1 - ( LG-DOCmp.Dsctos[2] / 100)),4 ). 
    C-UNIT2 = ROUND(C-UNIT1 * ( 1 - ( LG-DOCmp.Dsctos[3] / 100)),4 ) * C-IGV.         
    
            
    n-item = n-item + 1.
    
PUT STREAM REPORT N-ITEM   FORMAT "ZZ9".
PUT STREAM REPORT " ".
PUT STREAM REPORT LG-DOCmp.Codmat    FORMAT "X(6)".
PUT STREAM REPORT " ".
PUT STREAM REPORT Almmmatg.DesMat    FORMAT "X(37)".
PUT STREAM REPORT " ".
PUT STREAM REPORT Almmmatg.DesMar    FORMAT "X(9)".
PUT STREAM REPORT " ".
PUT STREAM REPORT LG-DOCmp.UndCmp    FORMAT "X(3)".
PUT STREAM REPORT " ".
PUT STREAM REPORT LG-DOCmp.CanPedi   FORMAT ">>>,>>9.99" .
PUT STREAM REPORT " ".
PUT STREAM REPORT LG-DOCmp.PreUni    FORMAT ">>,>>9.999999". 
PUT STREAM REPORT " ".
PUT STREAM REPORT LG-DOCmp.Dsctos[1] FORMAT ">>9.99".
PUT STREAM REPORT " ".
PUT STREAM REPORT LG-DOCmp.Dsctos[2] FORMAT ">>9.99".
PUT STREAM REPORT " ".
PUT STREAM REPORT LG-DOCmp.Dsctos[3] FORMAT ">>9.99".
PUT STREAM REPORT " ".
PUT STREAM REPORT LG-DOCmp.ImpTot     FORMAT ">,>>>,>>9.99" SKIP.

END.

  PUT STREAM Report "" SKIP(7).
  PUT STREAM Report X-EnLetras format "X(95)".
  PUT STREAM Report C-Moneda AT 100 LG-COCmp.ImpTot AT 104 SKIP.
  PUT STREAM Report "Observaciones :" LG-COCmp.Observaciones.
  PUT STREAM Report "                                                  " SKIP.
  PUT STREAM Report "                                                  " SKIP.
  PUT STREAM Report "                -------------------                             -------------------" SKIP.
  PUT STREAM Report "                   GENERADO POR                                      GERENCIA      " SKIP.
  PUT STREAM Report "                                                  " SKIP.
  PUT STREAM Report "Incorp. al reg. de agentes de retención de IGV (RS:265-2009) a partir del 01/01/10." SKIP.

OUTPUT STREAM Report CLOSE.

MESSAGE SKIP
        "Orden de Compra ha sido guardado en" x-File
        view-as alert-box information 
        title cotfile.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


