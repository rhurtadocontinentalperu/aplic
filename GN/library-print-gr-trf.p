&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER fai_ccbcdocu FOR CcbCDocu.
DEFINE BUFFER fai_ccbddocu FOR CcbDDocu.
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : Libreria general para la impresión de GR

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Solicitamos tipo de impresión */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR pv-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR lPesoMat AS DEC.
DEF VAR x-bultos AS INT.
DEF VAR x-CrossDocking AS CHAR NO-UNDO.
DEF VAR x-AlmDesp AS CHAR NO-UNDO.
DEF VAR x-AlmDest AS CHAR NO-UNDO.
DEF VAR X-AlmInt LIKE Almacen.DirAlm.   /* Almacen Intermedio */
DEF VAR x-AlmFiler AS CHAR NO-UNDO.
DEF VAR x-origen-crossdocking AS LOG.
DEF VAR x-codref AS CHAR INIT "" FORMAT 'x(5)'.
DEF VAR x-nroref AS CHAR INIT "" FORMAT 'x(30)'.
DEF VAR X-LugPar LIKE Almacen.DirAlm.   /* Dir Alm Despacho */
DEF VAR X-Lugent AS CHAR NO-UNDO.       /* Dir Alm Destino */
DEF VAR x-transportista AS CHAR.
DEF VAR x-ruc-trans AS CHAR.
DEF VAR x-lic-cond AS CHAR.
DEF VAR x-cert-inscrip AS CHAR.
DEF VAR x-vehi-marca AS CHAR.
DEF VAR x-placa AS CHAR.
DEF VAR x-carreta AS CHAR.
DEF VAR x-placa-carreta AS CHAR.
DEF VAR x-inicio-traslado AS CHAR FORMAT 'x(10)'.
DEF VAR lNroDoc AS CHAR.
DEF VAR X-MOTIVO AS CHAR.

DEFINE BUFFER y-faccpedi FOR faccpedi.
DEFINE BUFFER y-ALMACEN FOR Almacen.
DEFINE BUFFER B-ALMACEN FOR Almacen.
DEFINE BUFFER X-ALMACEN FOR Almacen.

    /* Definimos Detalle de Impresión */
    DEF TEMP-TABLE Detalle
        FIELD codcia AS INTE
        FIELD codalm AS CHAR FORMAT 'x(6)'
        FIELD nroitm AS INTE FORMAT '>>9'
        FIELD codmat AS CHAR FORMAT 'x(15)'
        FIELD desmat AS CHAR FORMAT 'x(70)'
        FIELD desmar AS CHAR FORMAT 'x(10)'
        FIELD candes AS DECI FORMAT '>>,>>9.99'
    FIELD undvta AS CHAR FORMAT 'x(8)'
    FIELD peso AS DECI FORMAT '>,>>>,>>9.9999' INIT ""
    FIELD codmat_cli AS CHAR FORMAT 'x(15)' INIT ""
    FIELD desmat_cli AS CHAR FORMAT 'x(70)' INIT ""
    INDEX idx00 AS PRIMARY nroitm.

DEF VAR ftr-Valor1 AS DECI NO-UNDO.
DEF VAR ftr-Valor2 AS DECI NO-UNDO.
DEF VAR ftr-Glosa1 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa2 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa3 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa4 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa5 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa6 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa7 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa8 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa9 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa10 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa11 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa12 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa13 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa14 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa15 AS CHAR NO-UNDO.
DEF VAR ftr-Glosa16 AS CHAR NO-UNDO.

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
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: fai_ccbcdocu B "?" ? INTEGRAL CcbCDocu
      TABLE: fai_ccbddocu B "?" ? INTEGRAL CcbDDocu
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.23
         WIDTH              = 60.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-GRIMP_Carga-Temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Carga-Temporal Procedure 
PROCEDURE GRIMP_Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cCodUbi AS CHAR NO-UNDO.
DEF VAR i-NroItm AS INTE NO-UNDO.

EMPTY TEMP-TABLE Detalle.

i-NroItm = 0.
FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST almmmatg OF Almdmov NO-LOCK:
    FIND FIRST almmmate WHERE almmmate.codcia = almcmov.codcia
        AND almmmate.codalm = almdmov.codalm
        AND almmmate.codmat = almdmov.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN cCodUbi = almmmate.codubi.
    ELSE cCodUbi = "".
    I-NroItm = I-NroItm + 1.
    CREATE Detalle.
    ASSIGN
        Detalle.codalm = cCodUbi
        Detalle.nroitm = i-NroItm
        Detalle.codmat = Almdmov.codmat
        Detalle.desmat = Almmmatg.desmat
        Detalle.desmar = Almmmatg.desmar
        Detalle.candes = Almdmov.candes
        Detalle.undvta = Almdmov.codund
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Formato-Continuo-13) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Formato-Continuo-13 Procedure 
PROCEDURE GRIMP_Formato-Continuo-13 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ***************************************************************************** */
/* Definimos Encabezado */
/* ***************************************************************************** */

DEFINE FRAME F-HdrGui
    HEADER
    SKIP(2)
    "Comprobante de pago emitido en contingencia" AT 20 FORMAT 'x(45)' SKIP
    "Emisor Electronico Obligado" AT 93 FORMAT 'x(27)'
    SKIP(2)
    /*SKIP(6)*/
    x-LugPar AT 12 FORMAT 'x(60)' SKIP
    x-LugEnt AT 12 FORMAT 'x(60)' SKIP
    b-Almacen.Descripcion AT 12 FORMAT "X(70)" SKIP
    b-Almacen.CodCli AT 12 FORMAT "X(11)" SKIP
    "Nro. Req." AT 17 Almcmov.NroRf1  FORMAT "X(10)"
    x-transportista AT 89 FORMAT 'x(40)' SKIP
    x-codref AT 42  x-nroref
    x-ruc-trans AT 82 FORMAT 'x(12)'
    x-vehi-marca AT 115 FORMAT 'x(15)' SKIP
    x-lic-cond AT 88 FORMAT 'x(15)'
    x-placa-carreta AT 110 FORMAT 'x(19)' SKIP
    x-cert-inscrip AT 90 FORMA 'x(12)' 
    x-inicio-traslado AT 120 SKIP
    X-MOTIVO SKIP(1)
    "G/R " AT 96 (STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999")) FORMAT "X(10)"
    Almcmov.fchdoc AT 115 FORMAT "99/99/9999" SKIP(2) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

/* ***************************************************************************** */
/* Definimos Pie de Página */
/* ***************************************************************************** */
DEFINE FRAME F-FtrGui
    HEADER
    SKIP(3)
    ftr-Glosa5  FORMAT 'x(100)' SKIP
    ftr-Glosa6  FORMAT 'x(100)' SKIP
    ftr-Glosa7  FORMAT 'x(100)' SKIP
    ftr-Glosa8  FORMAT 'x(100)' SKIP
    ftr-Glosa9  FORMAT 'x(100)' SKIP
    ftr-Glosa10 FORMAT 'x(100)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.


/* ***************************************************************************** */
/* Definición de Detalle */
/* ***************************************************************************** */
DEFINE FRAME F-DetaGui
    Detalle.codalm  AT 01 FORMAT "X(6)"
    Detalle.NroItm  AT 07 FORMAT "Z9"
    Detalle.codmat  AT 12 FORMAT "999999" 
    Detalle.desmat  AT 27 FORMAT "X(45)"
    Detalle.desmar  FORMAT "X(10)"
    Detalle.candes  FORMAT ">>>,>>>,>>9.99"
    Detalle.UndVta  FORMAT "X(6)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

/* ***************************************************************************** */
/* Imprimimos de acuerdo al formato seleccionado */
/* ***************************************************************************** */
OUTPUT TO PRINTER PAGE-SIZE 44.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

FOR EACH Detalle NO-LOCK BREAK BY Detalle.codcia BY Detalle.nroitm:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    DISPLAY 
        Detalle.codalm WHEN Detalle.codmat > ''
        Detalle.NroItm WHEN Detalle.codmat > ''
        Detalle.codmat WHEN Detalle.codmat > '' 
        Detalle.desmat 
        Detalle.desmar WHEN Detalle.codmat > ''
        Detalle.candes WHEN Detalle.codmat > ''
        Detalle.undvta WHEN Detalle.codmat > ''
        WITH FRAME F-DetaGui.
    IF LAST-OF(Detalle.codcia) THEN PAGE.
END.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Formato-Continuo-36) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Formato-Continuo-36 Procedure 
PROCEDURE GRIMP_Formato-Continuo-36 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ***************************************************************************** */
/* Definimos Encabezado */
/* ***************************************************************************** */
DEFINE FRAME F-HdrGui
    HEADER
    SKIP(2)
    "Comprobante de pago emitido en contingencia" AT 20 FORMAT 'x(45)' SKIP
    "Emisor Electronico Obligado" AT 93 FORMAT 'x(27)'
    SKIP(2)
    /*SKIP(6)*/
    x-LugPar  AT 17 FORMAT 'x(100)' STRING(Almcmov.NroSer, '999') + STRING(Almcmov.NroDoc, '9999999') FORMAT 'x(15)' SKIP(1)
    b-Almacen.Descripcion           AT 12 FORMAT "X(70)"  SKIP
    x-LugEnt  AT 12 FORMAT "X(100)" SKIP
    b-Almacen.CodCli                AT 12 FORMAT "X(11)" SKIP(3)
    x-codref + " " + x-nroref FORMAT 'x(30)' AT 18
    Almcmov.fchdoc                  AT 70 FORMAT '99/99/9999'
    x-Bultos                        AT 96
    lPesoMat                        AT 120
    SKIP(2)
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

/* ***************************************************************************** */
/* Definimos Pie de Página */
/* ***************************************************************************** */
DEFINE FRAME F-FtrGui
    HEADER
    ftr-Glosa1  FORMAT 'x(50)' AT 15 
    ftr-Glosa9  FORMAT 'x(50)' AT 90 SKIP(0.1)
    ftr-Glosa2  FORMAT 'x(60)' 
    ftr-Glosa10 FORMAT 'x(50)' AT 80 SKIP(0.1)
    ftr-Glosa3  FORMAT 'x(60)' 
    ftr-Glosa11 FORMAT 'x(50)' AT 90 SKIP(0.1)
    ftr-Glosa4  FORMAT 'x(50)' AT 12 
    ftr-Glosa12 FORMAT 'x(50)' AT 75 SKIP(0.1)
    ftr-Glosa5  FORMAT 'x(50)' AT 10 
    ftr-Glosa13 FORMAT 'x(50)' AT 90 SKIP(0.1)
    ftr-Glosa6  FORMAT 'x(50)' AT 10 
    ftr-Glosa14 FORMAT 'x(20)' AT 90 SKIP(0.1)
    ftr-Glosa7  FORMAT 'x(50)' AT 15 
    ftr-Glosa15 FORMAT 'x(20)' AT 85 SKIP(0.1)
    ftr-Glosa8  FORMAT 'x(50)' AT 15 
    ftr-Glosa16 FORMAT 'x(50)' AT 85 
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 320.

/* ***************************************************************************** */
/* Definición de Detalle */
/* ***************************************************************************** */
DEFINE FRAME F-DetaGui
    Detalle.codmat AT 6
    Detalle.candes ' ' 
    Detalle.UndVta  
    Detalle.desmat FORMAT 'x(100)'
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

/* ***************************************************************************** */
/* Imprimimos de acuerdo al formato seleccionado */
/* ***************************************************************************** */
OUTPUT TO PRINTER PAGE-SIZE 66.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(72) + {&PRN3}.     
FOR EACH Detalle NO-LOCK BREAK BY Detalle.codcia BY Detalle.nroitm:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    DISPLAY 
        Detalle.codmat WHEN Detalle.codmat > '' 
        Detalle.candes WHEN Detalle.codmat > ''
        Detalle.undvta WHEN Detalle.codmat > ''
        (Detalle.DesMat + " - " + Detalle.DesMar) @ Detalle.DesMat
        WITH FRAME F-DetaGui.
    IF LAST-OF(Detalle.codcia) THEN PAGE.
END.
OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Pie-de-Pagina) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Pie-de-Pagina Procedure 
PROCEDURE GRIMP_Pie-de-Pagina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    ftr-Glosa1 = ""
    ftr-Glosa2 = ""
    ftr-Glosa3 = ""
    ftr-Glosa4 = ""
    ftr-Glosa5 = FILL(' ', 41) + STRING(x-bultos, '->>>,>>9') + FILL(' ', 22) + STRING(lPesoMat)
    ftr-Glosa6 =  STRING(x-CrossDocking, 'x(15)')
    ftr-Glosa7 = 'ALM DESPACHO: ' + STRING(x-AlmDesp, 'X(40)')
    ftr-Glosa8 = 'ALM INTERMD.: ' + STRING(x-AlmInt, 'X(40)')
    ftr-Glosa9 = 'ALM DESTINO : ' + STRING(x-AlmDest, 'X(40)')
    ftr-Glosa10 = 'Glosa   : ' + STRING(Almcmov.Observ, 'X(30)')
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Pie-de-Pagina-36) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Pie-de-Pagina-36 Procedure 
PROCEDURE GRIMP_Pie-de-Pagina-36 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


ASSIGN
    ftr-Glosa1 = Almcmov.Observ
    ftr-Glosa2 = ""
    ftr-Glosa3 = ""
    ftr-Glosa4 = ""
    ftr-Glosa5 = ""
    ftr-Glosa6 = ""
    ftr-Glosa7 = ""
    ftr-Glosa8 = ""
    ftr-Glosa9 = x-AlmInt
    ftr-Glosa10 = ""
    ftr-Glosa11 = x-AlmDest
    ftr-Glosa12 = ""
    ftr-Glosa13 = ""
    ftr-Glosa14 = ""
    ftr-Glosa15 = ""
    ftr-Glosa16 = ""
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GRIMP_Rutina-Principal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GRIMP_Rutina-Principal Procedure 
PROCEDURE GRIMP_Rutina-Principal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Por esta rutina NO SE IMPRIME FORMATO BCP
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.       

FIND Almcmov WHERE ROWID(Almcmov) = pROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcmov THEN RETURN.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia 
    AND  gn-clie.codcli = Almcmov.codcli 
    NO-LOCK NO-ERROR.

lPesoMat = 0.
FOR EACH Almdmov OF Almcmov NO-LOCK:
    lPesoMat = lPesoMat + almdmov.pesmat.
END.

/* ************************************************************************************* */
/* Datos de la cabecera */
/* ************************************************************************************* */
FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
    AND  Almacen.CodAlm = Almcmov.CodAlm 
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN X-LugPar = Almacen.DirAlm.
/* Almacen DESTINO */
FIND b-Almacen WHERE b-Almacen.CodCia = Almcmov.CodCia 
    AND  b-Almacen.CodAlm = Almcmov.AlmDes
    NO-LOCK NO-ERROR.
IF AVAILABLE b-Almacen THEN X-LugEnt = b-Almacen.DirAlm.

/* Almacen INTERMEDIO */
X-AlmInt = "" .
IF Almcmov.AlmacenXD > '' THEN DO:
    FIND x-Almacen WHERE x-Almacen.CodCia = Almcmov.CodCia 
        AND  x-Almacen.CodAlm = Almcmov.almacenXD
        NO-LOCK NO-ERROR.
    IF AVAILABLE x-Almacen THEN X-AlmInt = TRIM(Almcmov.almacenXD) + " " + trim(x-Almacen.DirAlm).
    ELSE DO:
        /* Buscamos por el cliente */
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = Almcmov.almacenXD
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN X-AlmInt = gn-clie.nomcli.
    END.
END.
/* Ic - 11Set2018, correo de Max Ramos */
x-codref = almcmov.codref.
x-nroref = almcmov.nroref.
x-origen-crossdocking = NO.

FIND FIRST y-faccpedi WHERE y-faccpedi.codcia = s-codcia AND 
    y-faccpedi.coddoc = x-codref AND 
    y-faccpedi.nroped = x-nroref NO-LOCK NO-ERROR.
IF AVAILABLE y-faccpedi THEN DO:
    IF almcmov.crossdocking = YES THEN DO:
        /* Crossdocking primer salida */
        x-codref = y-faccpedi.codref.
        x-nroref = y-faccpedi.nroref + " (" + almcmov.codref + " " + almcmov.nroref + ")".
    END.
    ELSE DO:
        /* Verificar si es crossdocking 2da salida */
        IF y-faccpedi.crossdocking = NO AND y-faccpedi.tpoped = 'XD' THEN DO:
            x-codref = y-faccpedi.codref.
            x-nroref = y-faccpedi.nroref + " (" + almcmov.codref + " " + almcmov.nroref + ")".
            x-origen-crossdocking = YES.
        END.
    END.
END.
X-MOTIVO = IF LOOKUP(Almcmov.AlmDes,"11,83") > 0 THEN  "(3) Traslado entre..." ELSE " ".
/* Datos TRANSPORTISTA */
x-transportista = "".
x-ruc-trans = ''.
x-lic-cond = ''.
x-cert-inscrip = ''.
x-vehi-marca = ''.
x-placa = ''.
x-carreta = ''.
x-inicio-traslado = "".
x-bultos = 0.
x-placa-carreta = "".
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
    faccpedi.coddoc = almcmov.codref AND 
    faccpedi.nroped = almcmov.nroref NO-LOCK NO-ERROR.
IF AVAILABLE faccpedi THEN DO:
    lNroDoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
    /* Datos del transportista */
    FIND Ccbadocu WHERE Ccbadocu.codcia = s-codcia
        AND Ccbadocu.coddiv = faccpedi.coddiv
        AND Ccbadocu.coddoc = 'G/R'
        AND Ccbadocu.nrodoc = lNroDoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        x-placa = CcbADocu.Libre_C[1].               /*= pPlaca*/
        x-carreta = CcbADocu.Libre_C[18].               /*= pCarreta*/
        x-vehi-marca = CcbADocu.Libre_C[2].          /*= pVehiculoMarca*/
        x-transportista = CcbADocu.Libre_C[4].       /* = pNomTransportista*/
        x-ruc-trans = CcbADocu.Libre_C[5].           /*= pRUC*/                
        x-lic-cond = CcbADocu.Libre_C[6].            /*= pLicConducir*/
        x-inicio-traslado = STRING(CcbADocu.Libre_F[1],"99/99/9999").     /*= pInicioTraslado*/
        x-cert-inscrip = CcbADocu.Libre_C[17].      /*= pCertInscripcion.*/
    END.
END.
/* Bultos de la OTR */
x-Bultos = 0.
RUN logis/p-numero-de-bultos (INPUT s-CodDiv,
                              INPUT Almcmov.CodRef,
                              INPUT Almcmov.NroRef,
                              OUTPUT x-Bultos).
/* Ic - 28Feb2018, si es OTR que salga solo en la primera G/R de la OTR */
IF almcmov.codref = 'OTR' THEN DO:
    DEFINE BUFFER x-almcmov FOR almcmov.
    DEFINE VAR x-nrodoc AS INT64.

    x-nrodoc = 9999999999.
    FOR EACH x-almcmov WHERE x-almcmov.codcia = s-codcia AND 
                                x-almcmov.codref = almcmov.codref AND 
                                x-almcmov.nroref = almcmov.nroref AND
                                x-almcmov.flgest <> 'A'
                                NO-LOCK :
        IF x-almcmov.nrodoc < x-nrodoc THEN x-nrodoc = x-almcmov.nrodoc.
    END.

    IF x-nrodoc <> 9999999999 THEN DO:
        IF x-nrodoc <> almcmov.nrodoc THEN x-bultos = 0.
    END.
    
END.
x-placa-carreta = x-placa.
IF (x-carreta <> "" AND x-carreta <> ?) THEN DO:
    x-placa-carreta = x-placa-carreta + " / " + x-carreta.
END.

x-CrossDocking = "".
x-AlmDesp = TRIM(Almcmov.CodAlm) + "-" + Almacen.Descripcion.
x-AlmDest = TRIM(Almcmov.AlmDes) + "-" + b-Almacen.Descripcion.
IF Almcmov.CrossDocking = YES THEN DO:
    x-CrossDocking = "CROSS-DOCKING".
    x-AlmFiler = x-AlmInt.
    x-AlmInt = x-AlmDest.
    x-AlmDest = x-AlmFiler.
END.    
ELSE DO:
    IF x-origen-crossdocking = YES THEN DO:        
        x-CrossDocking = "CROSS-DOCKING".
        x-AlmInt = x-AlmDesp.
        x-AlmDesp = "".
        /* Buscar el almacen de despacho de origen */ 
        FIND FIRST y-faccpedi WHERE y-faccpedi.codcia = s-codcia AND 
            y-faccpedi.codref = x-codref AND 
            y-faccpedi.nroref = x-nroref AND
            y-faccpedi.tpoped <> "XD" NO-LOCK NO-ERROR.
        IF AVAILABLE y-faccpedi THEN DO:
            FIND y-Almacen WHERE y-Almacen.CodCia = Almcmov.CodCia 
                AND  y-Almacen.CodAlm = y-faccpedi.codalm NO-LOCK NO-ERROR.
            IF AVAILABLE y-Almacen THEN x-AlmDesp = TRIM(y-faccpedi.codalm) + " " + trim(y-almacen.descripcion).
        END.
    END.
END.

/* ************************************************************************************* */
/* Cargamos temporales de acuerdo al origen */
/* ************************************************************************************* */
DEF VAR x-Formato AS CHAR NO-UNDO.

/*x-Formato = "13".       /* Formato por defecto: 13 líneas por hoja */*/
x-Formato = "C13".       /* Formato por defecto: 13 líneas por hoja */

/* 01/12/2023 */
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEF VAR pItemsGuias AS INTE NO-UNDO.

RUN alm/almacen-library.p PERSISTENT SET hProc.
RUN GR_Formato_Items IN hProc (INPUT Almcmov.NroSer,
                               OUTPUT x-Formato,
                               OUTPUT pItemsGuias).
DELETE PROCEDURE hProc.

/* FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND          */
/*     FacTabla.Tabla = 'CFG_FMT_GR' AND                       */
/*     FacTabla.Codigo = s-CodDiv NO-LOCK NO-ERROR.            */
/* IF AVAILABLE FacTabla THEN x-Formato = FacTabla.Campo-C[2]. */
IF TRUE <> (x-Formato > '') THEN RETURN.

RUN GRIMP_Carga-Temporal.

CASE TRUE:
    /*WHEN x-Formato = "13" THEN DO:*/
    WHEN x-Formato = "C13" THEN DO:
        /* Formato 13 líneas por hoja */
        RUN GRIMP_Pie-de-Pagina.
        RUN GRIMP_Formato-Continuo-13.
    END.
    /*WHEN x-Formato = "36" THEN DO:*/
    WHEN x-Formato = "C36" THEN DO:
        /* Formato 36 líneas por hoja */
        RUN GRIMP_Pie-de-Pagina-36.
        RUN GRIMP_Formato-Continuo-36.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

