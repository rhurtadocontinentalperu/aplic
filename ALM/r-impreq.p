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
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHARACTER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHARACTER.

DEFINE VARIABLE X-DESPRO AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESART AS CHARACTER FORMAT "X(50)".
DEFINE STREAM Reporte.

FIND PR-ODPC WHERE ROWID(PR-ODPC) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-ODPC THEN RETURN.

FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND  
                   gn-prov.CodPro = PR-ODPC.Codpro NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN X-DESPRO = gn-prov.NomPro .
ELSE DO:
  FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND  
                     gn-prov.CodPro = PR-ODPC.CodPro NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN X-DESPRO = gn-prov.NomPro .
END.  

FIND Almmmatg WHERE Almmmatg.CodCia = PR-ODPC.CodCia AND
                    Almmmatg.CodMat = PR-ODPC.CodArt NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN X-DESART = Almmmatg.DesMat.

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
         HEIGHT             = 3.92
         WIDTH              = 35.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEFINE FRAME F-Orden
         PR-ODPD.CodMat   FORMAT "X(06)"
         Almmmatg.DesMat  FORMAT "X(50)"
         Almmmatg.Desmar  FORMAT "X(15)"
         PR-ODPD.CodUnd   FORMAT "X(05)"
         PR-ODPD.CanPed   FORMAT ">,>>>,>>9.9999"
         HEADER
         S-NOMCIA FORMAT "X(45)" 
         "ORDEN No. : " AT 80 PR-ODPC.NumOrd AT 100 SKIP
         "C.Conversion  : " PR-ODPC.CodPro X-DESPRO AT 30
         "Fecha Emision : " AT 90 PR-ODPC.FchOrd FORMAT "99/99/9999" AT 105 SKIP
         "Observaciones : " SUBSTRING(PR-ODPC.Observ[1],1,60) FORMAT "X(60)" AT 20  
         "Fecha Entrega : " AT 90 PR-ODPC.FchVto FORMAT "99/99/9999" AT 105 SKIP
          SUBSTRING(PR-ODPC.Observ[1],81,160) FORMAT "X(60)" AT 20 SKIP
          "Articulo     : " PR-ODPC.CodArt
          X-DESART AT 20 SKIP
         "-----------------------------------------------------------------------------------------------" SKIP
         " CODIGO      DESCRIPCION                                MARCA               UND.     CANTIDAD " SKIP
         "-----------------------------------------------------------------------------------------------" SKIP
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
         

  OUTPUT STREAM Reporte TO PRINTER .

  
  FOR EACH PR-ODPD OF PR-ODPC:
      FIND Almmmatg WHERE Almmmatg.CodCia = PR-ODPD.CodCia AND
                          Almmmatg.CodMat = PR-ODPD.CodMat NO-LOCK NO-ERROR.

      DISPLAY STREAM Reporte 
        PR-ODPD.CodMat 
        Almmmatg.DesMat 
        Almmmatg.Desmar
        PR-ODPD.CodUnd
        PR-ODPD.CanDes  
      WITH FRAME F-Orden.
      DOWN STREAM Reporte WITH FRAME F-Orden.  
  END.
/*
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 6 :
     PUT STREAM Reporte "" skip.
  END.
*/
  PUT STREAM Reporte SKIP(2).
  PUT STREAM Reporte "-------------------------------------------------------------------------------------------" SKIP.
  PUT STREAM Reporte "-------------------------------------------------------------------------------------------" SKIP.
  PUT STREAM Reporte "-------------------------------------------------------------------------------------------" SKIP.
  PUT STREAM Reporte "-------------------------------------------------------------------------------------------" SKIP.
  PUT STREAM Reporte SKIP(2).
  PUT STREAM Reporte "    -----------------     " AT 10 SKIP.
  PUT STREAM Reporte "        Firma             " AT 10 SKIP(2).
  PUT STREAM Reporte  PR-ODPC.Usuario  SKIP.

  OUTPUT STREAM Reporte CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


