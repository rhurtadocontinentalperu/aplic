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
DEFINE SHARED VARIABLE PV-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV  LIKE gn-divi.coddiv.
DEFINE SHARED VARIABLE S-NomCia  AS CHARACTER.
DEFINE VARIABLE F-Estado AS CHAR INIT "".
DEFINE INPUT PARAMETER X-ROWID   AS ROWID.
DEFINE INPUT PARAMETER X-coddoc  AS character.
DEFINE INPUT PARAMETER X-nroimp  AS integer.
FIND ImCOCmp WHERE ROWID(ImCOCmp) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ImCOCmp THEN RETURN.
DEFINE        VARIABLE IMPTOT LIKE ImCOCmp.ImpTot.
DEFINE        VARIABLE X-NRO     AS CHARACTER FORMAT "X(6)" NO-UNDO.
DEFINE        VARIABLE X-PED     AS CHARACTER.
DEFINE        VARIABLE C-Pais    AS CHARACTER FORMAT "X(25)" NO-UNDO.
DEFINE        VARIABLE C-RucPro  AS CHARACTER FORMAT "X(15)" NO-UNDO.
DEFINE        VARIABLE C-Moneda  AS CHARACTER FORMAT "X(15)" NO-UNDO.
DEFINE        VARIABLE C-Banco   AS CHARACTER FORMAT "X(35)" NO-UNDO.
DEFINE        VARIABLE C-DesCnd  AS CHARACTER FORMAT "X(35)" NO-UNDO.
DEFINE STREAM Reporte.
FIND gn-prov WHERE 
     gn-prov.CodCia = PV-CODCIA AND  
     gn-prov.CodPro = ImCOCmp.CodPro 
     NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN C-RucPro = gn-prov.Ruc.
FIND gn-concp WHERE 
     gn-concp.Codig = ImCOCmp.CndCmp 
     NO-LOCK NO-ERROR.
IF AVAILABLE gn-concp THEN C-DesCnd = gn-concp.Nombr.
FIND AlmTabla WHERE 
     AlmTabla.Codigo = ImCOCmp.Pais AND
     AlmTabla.Tabla = "PA" 
     NO-LOCK NO-ERROR.     
IF AVAILABLE AlmTabla THEN C-Pais = AlmTabla.Nombre.
FIND AlmTabla WHERE 
     AlmTabla.Codigo = ImCOCmp.Moneda AND
     AlmTabla.Tabla = "MO" 
     NO-LOCK NO-ERROR.
IF AVAILABLE AlmTabla THEN C-Moneda = AlmTabla.Nombre.
FIND AlmTabla WHERE 
     AlmTabla.Codigo = ImCOCmp.CodBco AND
     AlmTabla.Tabla = "BN" 
     NO-LOCK NO-ERROR.
IF AVAILABLE AlmTabla THEN C-Banco = AlmTabla.Nombre.
CASE ImCOCmp.FlgSit:
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
X-NRO = STRING(X-NROIMP, "999999").
X-PED = ImCOCmp.NroPed.
DEFINE FRAME F-HdrCmp
    ImDOCmp.Codmat    FORMAT "X(8)"
    Almmmatg.DesMat   FORMAT "X(60)"
    Almmmatg.DesMar   FORMAT "X(15)"
    ImDOCmp.UndCmp    FORMAT "X(3)"
    ImDOCmp.CanPedi   FORMAT ">,>>>,>>9.99"
    ImDOCmp.PreUni    FORMAT "ZZZ,ZZ9.99"
    ImDOCmp.ImpTot    FORMAT "ZZ,ZZZ,ZZ9.99"
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)"  SKIP
    {&PRN6A} + F-Estado +  {&PRN6B} AT 110 FORMAT "X(15)" SKIP
    {&PRN7A} + {&PRN6A} + "ORDEN DE COMPRA NRO." + {&PRN6B} + {&PRN7B} + {&PRN4} AT 1 FORMAT "X(22)" 
    {&PRN7A} + {&PRN6A} + STRING(X-NROIMP, "999999") + {&PRN6B} + {&PRN7B} + {&PRN4} /*FORMAT "XXXXXX"*/
    {&PRN7A} + {&PRN6A} + "NRO.DE PEDIDO" + {&PRN6B} + {&PRN7B} + {&PRN4} AT 35 FORMAT "X(18)"
    {&PRN7A} + {&PRN6A} + X-PED + {&PRN6B} + {&PRN7B} + {&PRN4} AT 55 FORMAT "X(25)" SKIP
    "Proveedor/ Exportador : " gn-prov.CodPro gn-prov.NomPro FORMAT "x(45)"
    "Fecha Emision :" AT 85 ImCOCmp.Fchdoc FORMAT "99/99/9999" SKIP
    "RUC : " gn-prov.Ruc  FORMAT "x(11)"
   /* "Fecha Entrega :" AT 85 ImCOCmp.FchEnt FORMAT "99/99/9999" SKIP*/ 
    "Fecha Estimada de Produccion :" AT 85 ImCOCmp.FchProd FORMAT "99/99/9999" SKIP
    "Productor : "  
    "Pais :" AT 85 C-Pais SKIP
    "Representante : " 
    "Moneda :" AT 85 C-Moneda SKIP
    "Tipo de Carga : "                     
    "Forma de Pago :" AT 85 C-DesCnd SKIP
    "Numero de Contenedores : "
    "Banco :" AT 85 C-Banco SKIP
/*    "FAX : " gn-prov.FaxPro FORMAT "x(10)"
 *     "TELF: " AT 30 gn-prov.Telfnos[1] AT 37 FORMAT "x(10)"
 *     "Impuesto :" AT 50 "INCLUIDO I.G.V" SKIP*/
    /*{&PRN6A} + "Favor entregar en : " + x-Direccion + {&PRN6B} FORMAT 'x(130)' SKIP*/
    "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "CODIGO             DESCRIPCION                                        MARCA           UM       CANTIDAD    PRE. UNIT.     TOTAL       " SKIP
    "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.         
    OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 31.
    PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.   
    
    FOR EACH ImCOCmp NO-LOCK WHERE ImCOCmp.NroImp = X-nroimp,
    EACH ImDOCmp OF ImCOCmp NO-LOCK USE-INDEX Llave01 
    WHERE ImCOCmp.NroImp = ImDOCmp.NroImp,
    FIRST Almmmatg OF ImDOCmp NO-LOCK WHERE 
          ImDOCmp.CodCia = Almmmatg.CodCia AND   
          ImDOCmp.CodMat = Almmmatg.CodMat
             BREAK BY ImDOCmp.NroImp
                   BY Almmmatg.CodMat:                   
                   DISPLAY STREAM Reporte 
                       ImDOCmp.Codmat 
                       Almmmatg.DesMat
                       Almmmatg.DesMar
                       ImDOCmp.UndCmp
                       ImDOCmp.CanPedi
                       ImDOCmp.PreUni 
                       ImDOCmp.ImpTot
                   WITH FRAME F-HdrCmp.
        DOWN STREAM Reporte WITH FRAME F-HdrCmp.
    END.  
    DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 7 :
        PUT STREAM Reporte "" SKIP.
    END.
    PUT STREAM Reporte "TOTAL : " AT 90 C-Moneda AT 100 ImCOCmp.ImpTot AT 116 SKIP.
    PUT STREAM Reporte "Observaciones :" ImCOCmp.Observaciones.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                                                  " SKIP.
    PUT STREAM Reporte "                 -----------------------------------                             -----------------------------------" SKIP.
    PUT STREAM Reporte "                           GENERADO POR                                                       GERENCIA            " SKIP.
    PUT STREAM Reporte "                             " ImCOCmp.Userid-com  SKIP.
  
  OUTPUT STREAM Reporte CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


