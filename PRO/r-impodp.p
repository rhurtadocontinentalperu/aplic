&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

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

DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHARACTER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHARACTER.
DEFINE SHARED VAR pv-CODCIA AS INTEGER.

DEFINE VARIABLE X-DESPRO AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESART AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-UNDVTA AS CHARACTER FORMAT "X(6)".
DEFINE VARIABLE X-NRO AS CHARACTER FORMAT "X(6)".
DEFINE VARIABLE X-DESALM AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESMAQ AS CHARACTER FORMAT "X(50)".

DEFINE STREAM Reporte.

FIND PR-ODPC WHERE ROWID(PR-ODPC) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-ODPC THEN RETURN.

FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND  
                   gn-prov.CodPro = PR-ODPC.Codpro NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN X-DESPRO = gn-prov.NomPro .
ELSE DO:
  FIND gn-prov WHERE gn-prov.CodCia = 0 AND  
                     gn-prov.CodPro = PR-ODPC.CodPro NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN X-DESPRO = gn-prov.NomPro .
END.  

FIND Almmmatg WHERE Almmmatg.CodCia = PR-ODPC.CodCia AND
                    Almmmatg.CodMat = PR-ODPC.CodArt NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN DO:
   X-DESART = Almmmatg.DesMat.
   X-UNDVTA = Almmmatg.UndBas.
END.   
FIND Almacen WHERE Almacen.Codcia = S-CODCIA AND
                   Almacen.CodAlm = PR-ODPC.CodAlm
                   No-LOCK No-ERROR.
IF AVAILABLE Almacen THEN X-DESALM = Almacen.Descripcion.



FIND LprMaqui WHERE LprMaqui.codcia = s-codcia
      AND LprMaqui.CodMaq = Pr-Odpc.CodMaq 
      NO-LOCK NO-ERROR.
  IF AVAILABLE LprMaqui THEN x-DesMaq =  LPRMAQUI.DesPro.

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
         HEIGHT             = 2.19
         WIDTH              = 36.43.
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
/*MLR* 26/11/07 ***
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).
* ***/

DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
IF NOT answer THEN RETURN.

X-NRO = STRING(PR-ODPC.NumOrd,"999999").

  DEFINE FRAME F-Cabe
         PR-ODPCX.CodArt   FORMAT "X(06)"
         Almmmatg.DesMat  FORMAT "X(50)"
         Almmmatg.Desmar  FORMAT "X(15)"
         PR-ODPCX.CodUnd   FORMAT "X(05)"
         PR-ODPCX.CanPed   FORMAT ">,>>>,>>9.9999"  
  WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta
         PR-ODPD.CodMat   FORMAT "X(06)"
         Almmmatg.DesMat  FORMAT "X(50)"
         Almmmatg.Desmar  FORMAT "X(15)"
         PR-ODPD.CodUnd   FORMAT "X(05)"
         PR-ODPD.CanPed   FORMAT ">,>>>,>>9.9999"  
  WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.         

  DEFINE FRAME F-Orden
    HEADER
    {&PRN2} + {&PRN7A} + S-NOMCIA + {&PRN7B} + {&PRN3} FORMAT "X(45)"  SKIP
    {&PRN7A} + "ORDEN DE TRABAJO " + {&PRN7B} + {&PRN3} AT 50 FORMAT "X(22)" 
    {&PRN7A} + {&PRN6A} +  X-NRO  + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "XXXXXXXXXXXX"
    SKIP
    "Alm.Conversion : " PR-ODPC.CodAlm X-DESALM FORMAT "x(45)" SKIP
    "Maquina        : " PR-ODPC.CodMaq X-DESMAQ FORMAT "x(45)" SKIP
    "Proveedor      : " PR-ODPC.CodPro X-DESPRO FORMAT "x(45)" SKIP
    "Fecha Emision  : " PR-ODPC.FchOrd FORMAT "99/99/9999" SKIP    
    "Fecha Entrega  : " PR-ODPC.FchVto FORMAT "99/99/9999"  SKIP
    "Observaciones  : " SUBSTRING(PR-ODPC.Observ[1],1,60) FORMAT "X(60)" AT 20  SKIP
    SUBSTRING(PR-ODPC.Observ[1],81,160) FORMAT "X(60)" AT 20 SKIP
/*
    {&PRN6A} + "Articulo : " +  {&PRN6B} AT 1 FORMAT "X(15)" {&PRN6A} + PR-ODPC.CodArt + " " + X-DESART + {&PRN6B} FORMAT "X(100)" SKIP
    {&PRN6A} + "Cantidad : " +  {&PRN6B} AT 1 FORMAT "X(15)" {&PRN6A} + STRING(PR-ODPC.CanPed,">>,>>>,>>9.99") + " " + X-UNDVTA + {&PRN6B} FORMAT "X(100)" SKIP
*/
    "-----------------------------------------------------------------------------------------------" SKIP
    " CODIGO      DESCRIPCION                                   MARCA             UND.     CANTIDAD " SKIP
    "-----------------------------------------------------------------------------------------------" SKIP
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.         


   OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 64.
   PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     

   VIEW STREAM Reporte FRAME F-Orden.
  
  FOR EACH PR-ODPCX OF PR-ODPC 
           BREAK BY PR-ODPCX.Codcia:
      IF FIRST-OF(PR-ODPCX.Codcia) THEN DO:
         PUT STREAM Reporte "A R T I C U L O S " SKIP.
         PUT STREAM Reporte "------------------" SKIP.          
      END.
      
      FIND Almmmatg WHERE Almmmatg.CodCia = PR-ODPCX.CodCia AND
                          Almmmatg.CodMat = PR-ODPCX.CodArt NO-LOCK NO-ERROR.

      DISPLAY STREAM Reporte 
        PR-ODPCX.CodArt
        Almmmatg.DesMat 
        Almmmatg.Desmar
        PR-ODPCX.CodUnd 
        PR-ODPCX.CanPed 
      WITH FRAME F-Cabe.
      DOWN STREAM Reporte WITH FRAME F-Cabe.  
  END.

  PUT STREAM Reporte "" SKIP.          
  PUT STREAM Reporte "-------------------------------------" SKIP.          
  PUT STREAM Reporte "" SKIP.          
  
  FOR EACH PR-ODPD OF PR-ODPC
           BREAK BY PR-ODPD.Codcia :

      IF FIRST-OF(PR-ODPD.Codcia) THEN DO:
         PUT STREAM Reporte "M A T E R I A L E S  /  I N S U M O S " SKIP.
         PUT STREAM Reporte "--------------------------------------" SKIP.          
      END.

      FIND Almmmatg WHERE Almmmatg.CodCia = PR-ODPD.CodCia AND
                          Almmmatg.CodMat = PR-ODPD.CodMat NO-LOCK NO-ERROR.

      DISPLAY STREAM Reporte 
        PR-ODPD.CodMat 
        Almmmatg.DesMat 
        Almmmatg.Desmar
        PR-ODPD.CodUnd
        PR-ODPD.CanPed  
      WITH FRAME F-Deta.
      DOWN STREAM Reporte WITH FRAME F-Deta.  
  END.

  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 14 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte "-------------------------------------------------------------------------------------------" SKIP(2).
  PUT STREAM Reporte "-------------------------------------------------------------------------------------------" SKIP(2).
  PUT STREAM Reporte "    -----------------     " AT 10 SKIP.
  PUT STREAM Reporte "        Firma             " AT 10 SKIP(2).
  PUT STREAM Reporte  PR-ODPC.Usuario  SKIP.

  OUTPUT STREAM Reporte CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


