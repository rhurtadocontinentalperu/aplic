&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-duaimp.p
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
DEFINE VARIABLE x-vers   AS INTEGER.
DEFINE INPUT PARAMETER X-ROWID   AS ROWID.
/* DEFINE INPUT PARAMETER X-coddoc  AS character. */
DEFINE INPUT PARAMETER X-nrodua  AS integer.
FIND ImCDua WHERE ROWID(ImCDua) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ImCDua THEN RETURN. 
/* DEFINE        VARIABLE IMPTOT LIKE ImCFacCom.ImpTot. */
DEFINE        VARIABLE X-NRO     AS CHARACTER FORMAT "X(6)" NO-UNDO.
DEFINE        VARIABLE X-FAC     AS CHARACTER FORMAT "X(6)" NO-UNDO.
/* DEFINE        VARIABLE C-DesCnd  AS CHARACTER FORMAT "X(35)" NO-UNDO. */
DEFINE        VARIABLE C-NomPro  AS CHARACTER FORMAT "X(35)" NO-UNDO.
DEFINE STREAM Reporte.
FIND gn-prov WHERE 
     gn-prov.CodCia = PV-CODCIA AND  
     gn-prov.CodPro = ImCDua.CodPro 
     NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN C-NomPro = gn-prov.NomPro.

/* FIND gn-concp WHERE                                   */
/*      gn-concp.Codig = ImCFacCom.CndCmp                */
/*      NO-LOCK NO-ERROR.                                */
/* IF AVAILABLE gn-concp THEN C-DesCnd = gn-concp.Nombr. */

CASE ImCDua.FlgEst:
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
X-NRO = STRING(X-NRODUA, "999999").
X-FAC = STRING(ImCDua.NroFac,"999999"). 
DEFINE FRAME F-HdrCmp
    ImDDua.Codmat     FORMAT "X(8)"
    Almmmatg.DesMat   FORMAT "X(60)"
    Almmmatg.DesMar   FORMAT "X(15)"
    ImDDua.UndCmp     FORMAT "X(3)"
    ImDDua.CanDua     FORMAT ">,>>>,>>9.99"

   /*  ImDDua.PreUni     FORMAT "ZZZ,ZZ9.99" */
/*     ImDDua.ImpTot     FORMAT "ZZ,ZZZ,ZZ9.99" */
    
    
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)"  SKIP
    {&PRN6A} + F-Estado +  {&PRN6B} + {&PRN3} AT 110 FORMAT "X(15)" SKIP 
    {&PRN7A} + "DUA IMPORTACION Nº:" + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(25)" 
    {&PRN7A} + {&PRN6A} + X-NRO + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "XXXXXXXXXX" SKIP
    {&PRN7A} + "NRO.DE FACTURA:" + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(25)" 
    {&PRN7A} + {&PRN6A} + X-FAC + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "XXXXXXXXX" SKIP 
    "Proveedor/ Exportador : " gn-prov.CodPro gn-prov.NomPro FORMAT "x(60)"
    "Fecha Emision :" AT 85 ImCDua.FchDoc FORMAT "99/99/9999" SKIP
    "Valor FOB :" AT 1 ImCDua.ImpFob SKIP
    "Valor Flete :" AT 1 ImCDua.ImpFlete SKIP
    "Valor Seguro :" AT 1 ImCDua.Seguro SKIP
    "------------------------------------------------------------------------------------------------------------" SKIP
    "CODIGO             DESCRIPCION                                        MARCA           UM       CANTIDAD     " SKIP
    "------------------------------------------------------------------------------------------------------------" SKIP
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.         
    OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
    PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.   
    
    FOR EACH ImCDua NO-LOCK WHERE ImCDua.NroDua = X-NRODUA,
    EACH ImDDua /* OF ImCDua*/ NO-LOCK /* USE-INDEX Llave01 */  
    WHERE ImCDua.NroDua = ImDDua.NroDua,
    FIRST Almmmatg OF ImDDua NO-LOCK WHERE 
          ImDDua.CodCia = Almmmatg.CodCia AND   
          ImDDua.CodMat = Almmmatg.CodMat
             BREAK BY ImDDua.NroDua
                   BY Almmmatg.CodMat:    
                   DISPLAY STREAM Reporte 
                       ImDDua.Codmat 
                       Almmmatg.DesMat
                       Almmmatg.DesMar
                       ImDDua.UndCmp
                       ImDDua.CanDua
                       /* ImDDua.PreUni */
/*                        ImDDua.ImpTot */
                   WITH FRAME F-HdrCmp.
        DOWN STREAM Reporte WITH FRAME F-HdrCmp.
    END.  
    DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 7 :
        PUT STREAM Reporte "" SKIP.
    END.
  /*   PUT STREAM Reporte "TOTAL : "/*  AT 90 C-Moneda */ AT 100 ImCDua.ImpTot AT 116 SKIP. */
/*     PUT STREAM Reporte "Observaciones :" ImCDua.Observaciones. */
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                 -----------------------------------                             -----------------------------------" SKIP.
    PUT STREAM Reporte "                           GENERADO POR                                                       GERENCIA            " SKIP.
    PUT STREAM Reporte "                             "ImCDua.Userid-dua  SKIP.
  
  OUTPUT STREAM Reporte CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


