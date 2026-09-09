&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-facimp.p
    Purpose     : 

    Syntax      :

    Description : Imprime Factura de Importaciones

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV  LIKE gn-divi.coddiv.
DEFINE SHARED VARIABLE S-NomCia  AS CHARACTER.
DEFINE VARIABLE F-Estado AS CHAR INIT "".
DEFINE INPUT PARAMETER X-ROWID   AS ROWID.
DEFINE INPUT PARAMETER X-coddoc  AS character.
DEFINE INPUT PARAMETER X-nrofac  AS integer.
FIND ImCFacCom WHERE ROWID(ImCFacCom) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ImCFacCom THEN RETURN.
DEFINE        VARIABLE IMPTOT LIKE ImCFacCom.ImpTot.
DEFINE        VARIABLE X-NRO     AS CHARACTER FORMAT "X(6)" NO-UNDO.
DEFINE        VARIABLE X-PED     AS CHARACTER.
DEFINE        VARIABLE C-DesCnd  AS CHARACTER FORMAT "X(35)" NO-UNDO.
DEFINE        VARIABLE C-NomPro  AS CHARACTER FORMAT "X(35)" NO-UNDO.
DEFINE STREAM Reporte.
FIND gn-prov WHERE 
     gn-prov.CodCia = PV-CODCIA AND  
     gn-prov.CodPro = ImCFacCom.CodPro 
     NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN C-NomPro = gn-prov.NomPro.

FIND gn-concp WHERE
     gn-concp.Codig = ImCFacCom.CndCmp
     NO-LOCK NO-ERROR.
IF AVAILABLE gn-concp THEN C-DesCnd = gn-concp.Nombr.

CASE ImCFacCom.FlgEst:
    WHEN 'E' THEN f-Estado = 'E M I T I D O'.
    WHEN 'A' THEN f-Estado = 'A N U L A D O'.
    OTHERWISE f-Estado = 'C E R R A D O'.
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
X-NRO = STRING(X-NROFAC, "999999").
X-PED = ImCFacCom.NroPed.
DEFINE FRAME F-HdrCmp
    ImDFacCom.Codmat    FORMAT "X(8)"
    Almmmatg.DesMat   FORMAT "X(60)"
    Almmmatg.DesMar   FORMAT "X(20)"
    ImDFacCom.UndCmp    FORMAT "X(5)"
    ImDFacCom.CanAten   FORMAT ">,>>>,>>9.99"
    ImDFacCom.PreUni    FORMAT "ZZZ,ZZ9.99"
    ImDFacCom.ImpTot    FORMAT "ZZ,ZZZ,ZZ9.99"
    
    
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)"  SKIP
    {&PRN6A} + F-Estado +  {&PRN6B} + {&PRN3} AT 110 FORMAT "X(15)" SKIP 
    {&PRN7A} + "FACTURA IMPORTACION Nº:" + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(25)" 
    {&PRN7A} + {&PRN6A} + X-NRO + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "XXXXXXXXXX" SKIP 
    {&PRN7A} + "NRO.DE PEDIDO:" + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(25)" 
    {&PRN7A} + {&PRN6A} + X-PED + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(25)" SKIP 
    "Proveedor/ Exportador : " gn-prov.CodPro gn-prov.NomPro FORMAT "x(60)"
    "Fecha Emision :" AT 85 ImCFacCom.FchDoc FORMAT "99/99/9999" SKIP
    "Forma de Pago :" AT 85 C-DesCnd SKIP
    "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "CODIGO             DESCRIPCION                                        MARCA               UM       CANTIDAD    PRE. UNIT.     TOTAL       " SKIP
    "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.         
    OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
    PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.   
    
    FOR EACH ImCFacCom NO-LOCK WHERE ImCFacCom.NroFAC = X-NROFAC,
    EACH ImDFacCom /* OF ImCFacCom*/ NO-LOCK /* USE-INDEX Llave01 */  
    WHERE ImCFacCom.NroFac = ImDFacCom.NroFac,
    FIRST Almmmatg OF ImDFacCom NO-LOCK WHERE 
          ImDFacCom.CodCia = Almmmatg.CodCia AND   
          ImDFacCom.CodMat = Almmmatg.CodMat
             BREAK BY ImDFacCom.NroFac
                   BY Almmmatg.CodMat:                   
                   DISPLAY STREAM Reporte 
                       ImDFacCom.Codmat 
                       Almmmatg.DesMat
                       Almmmatg.DesMar
                       ImDFacCom.UndCmp
                       ImDFacCom.CanAten
                       ImDFacCom.PreUni 
                       ImDFacCom.ImpTot
                   WITH FRAME F-HdrCmp.
        DOWN STREAM Reporte WITH FRAME F-HdrCmp.
    END.  
    DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 7 :
        PUT STREAM Reporte "" SKIP.
    END.
    PUT STREAM Reporte "TOTAL : "/*  AT 90 C-Moneda */ AT 100 ImCFacCom.ImpTot AT 116 SKIP.
/*     PUT STREAM Reporte "Observaciones :" ImCFacCom.Observaciones. */
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                 -----------------------------------                             -----------------------------------" SKIP.
    PUT STREAM Reporte "                           GENERADO POR                                                       GERENCIA            " SKIP.
    PUT STREAM Reporte "                             "ImCFacCom.Userid-fac  SKIP.
  
  OUTPUT STREAM Reporte CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


