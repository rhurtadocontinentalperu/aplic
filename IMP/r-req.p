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
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV  LIKE gn-divi.coddiv.
DEFINE SHARED VARIABLE S-NomCia  AS CHARACTER.
DEFINE VARIABLE F-Estado AS CHAR INIT "".
DEFINE INPUT PARAMETER X-ROWID   AS ROWID.
DEFINE INPUT PARAMETER X-NroReq  AS integer.
FIND LG-CREQU WHERE ROWID(LG-CREQU) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE LG-CREQU THEN RETURN.
DEFINE        VARIABLE X-NRO     AS CHARACTER FORMAT "X(6)" NO-UNDO.
DEFINE STREAM Reporte.
CASE LG-CREQU.FlgSit:
    WHEN "S" THEN F-Estado = "Solicitado".
    WHEN "R" THEN F-Estado = "Rechazado".
    WHEN "N" THEN F-Estado = "Anulado".
    WHEN "A" THEN F-Estado = "Aprobado".
    WHEN "P" THEN F-Estado = "Atendido Parcialmente".
END CASE.

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
         HEIGHT             = 2
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
X-NRO = STRING(X-NROREQ, "999999").

DEFINE FRAME F-HdrCmp
    LG-DREQU.Codmat    FORMAT "X(8)"
    Almmmatg.DesMat    FORMAT "X(80)"
    LG-DREQU.CanPedi   FORMAT ">,>>>,>>9.99"
    LG-DREQU.FchIng    FORMAT "99/99/9999"
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)"  SKIP(2)
    {&PRN6A} + F-Estado +  {&PRN6B} AT 130 FORMAT "X(15)" SKIP
    {&PRN7A} + {&PRN6A} + "REQUERIMIENTO DE COMPRA NRO." + {&PRN6B} + {&PRN7B} + {&PRN4} AT 1 FORMAT "X(40)" 
    {&PRN7A} + {&PRN6A} + STRING(X-NROREQ, "999999") + {&PRN6B} + {&PRN7B} + {&PRN4} AT 45 FORMAT "X(9)" SKIP
    "Solicitante: " LG-CREQU.Solicita FORMAT "x(45)"
    "Fecha Requision:" AT 120 LG-CREQU.FchReq FORMAT "99/99/9999" SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    "CODIGO             DESCRIPCION                                                                CANTIDAD   FCH.ING. SUGERIDA     " SKIP
    "-------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 300 STREAM-IO DOWN.         
    OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
    PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.   
    
    FOR EACH LG-CREQU NO-LOCK WHERE LG-CREQU.NroReq = X-NroReq,
    EACH LG-DREQU OF LG-CREQU NO-LOCK /*USE-INDEX Llave01 */
    WHERE LG-CREQU.NroReq = LG-DREQU.NroReq,
    FIRST Almmmatg OF LG-DREQU NO-LOCK WHERE 
          LG-DREQU.CodCia = Almmmatg.CodCia AND   
          LG-DREQU.CodMat = Almmmatg.CodMat
             BREAK BY LG-DREQU.NroReq
                   BY Almmmatg.CodMat:                   
                   DISPLAY STREAM Reporte 
                       LG-DREQU.Codmat 
                       Almmmatg.DesMat
                       LG-DREQU.CanPedi
                       LG-DREQU.FchIng
                   WITH FRAME F-HdrCmp.
        DOWN STREAM Reporte WITH FRAME F-HdrCmp.
    END.  
    DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 7 :
        PUT STREAM Reporte "" SKIP.
    END.
    PUT STREAM Reporte "Observaciones :" LG-CREQU.Observ.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                 -----------------------------------                             -----------------------------------" SKIP.
    PUT STREAM Reporte "                           GENERADO POR                                                       GERENCIA            " SKIP.
    PUT STREAM Reporte "                             " LG-CREQU.Userid-Sol  SKIP.
  
  OUTPUT STREAM Reporte CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


