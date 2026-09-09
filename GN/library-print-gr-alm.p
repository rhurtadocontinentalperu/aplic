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
/* Sintaxis 
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.
RUN <libreria>.rutina_internaIN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .
DELETE PROCEDURE hProc.
*/

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id LIKE ccbcterm.codter.

DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR C-NomVen AS CHAR FORMAT "X(21)".
DEF VAR C-NomCon AS CHAR FORMAT "X(30)".
DEF VAR C-RucTra AS CHAR FORMAT "X(30)".
DEF VAR C-NomTra AS CHAR FORMAT "X(30)".
DEF VAR C-DirTra AS CHAR FORMAT "X(30)".
DEF VAR I-NroItm AS INTEGER.
DEF VAR S-TOTPES AS DECIMAL.
DEF VAR X-senal  AS CHAR.
DEF VAR X-ZONA   AS CHAR.
DEF VAR X-DEPART LIKE TabDepto.NomDepto.
DEF VAR X-FchRef LIKE Almcmov.fchdoc.
DEF VAR X-MOTIVO AS CHAR.
DEF VAR cCodUbi  AS CHAR.

DEF VAR X-Lugent AS CHAR NO-UNDO.       /* Dir Alm Destino */
DEF VAR X-LugPar LIKE Almacen.DirAlm.   /* Dir Alm Despacho */

DEF VAR X-AlmInt LIKE Almacen.DirAlm.   /* Almacen Intermedio */

DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER B-ALMACEN FOR Almacen.
DEFINE BUFFER X-ALMACEN FOR Almacen.
DEFINE BUFFER y-ALMACEN FOR Almacen.

DEFINE VAR lPesoMat AS DEC.

/* Ic - 19Dic2017, imprimir datos del transportista */
DEFINE VAR x-transportista AS CHAR.
DEFINE VAR x-ruc-trans AS CHAR.
DEFINE VAR x-lic-cond AS CHAR.
DEFINE VAR x-cert-inscrip AS CHAR.
DEFINE VAR x-vehi-marca AS CHAR.
DEFINE VAR x-placa AS CHAR.
DEFINE VAR x-carreta AS CHAR.
DEFINE VAR x-placa-carreta AS CHAR.
DEFINE VAR x-inicio-traslado AS CHAR FORMAT 'x(10)'.

DEFINE VAR x-bultos AS INT.
DEFINE VAR x-codref AS CHAR INIT "" FORMAT 'x(5)'.
DEFINE VAR x-nroref AS CHAR INIT "" FORMAT 'x(30)'.
DEFINE VAR x-origen-crossdocking AS LOG.

DEFINE VAR lNroDoc AS CHAR.

DEFINE BUFFER y-faccpedi FOR faccpedi.

DEF VAR x-CrossDocking AS CHAR NO-UNDO.
DEF VAR x-AlmDesp AS CHAR NO-UNDO.
DEF VAR x-AlmDest AS CHAR NO-UNDO.
DEF VAR x-AlmFiler AS CHAR NO-UNDO.

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
         HEIGHT             = 7.88
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

OUTPUT CLOSE.

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

FIND gn-ven WHERE gn-ven.CodCia = Almcmov.CodCia 
             AND  gn-ven.CodVen = Almcmov.CodVen 
            NO-LOCK NO-ERROR.
IF AVAILABLE gn-ven THEN C-NomVen = gn-ven.NomVen.

FIND admrutas WHERE admruta.CodPro = Almcmov.CodTra NO-LOCK NO-ERROR.
IF AVAILABLE admrutas THEN C-NomTra = admrutas.NomTra.

FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND
      gn-prov.codpro = C-RucTra NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN C-DirTra = gn-prov.DirPro.

/* Almacen DESPACHO */
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

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(0 /*Almcmov.imptot*/, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF Almcmov.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

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

/* Busco la DIVISION de la OTR */
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
    /* RHC 21/05/2018 */
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

DEFINE FRAME F-HdrGui
    HEADER
    SKIP(6)
    x-LugPar AT 12 FORMAT 'x(60)' SKIP
    x-LugEnt AT 12 FORMAT 'x(60)' SKIP
    b-Almacen.Descripcion AT 12 FORMAT "X(70)" SKIP
    b-Almacen.CodCli AT 12 FORMAT "X(11)" SKIP
    /*'NUEVO R.U.C 20100038146' AT 92  FORMAT "X(20)" SKIP(1)*/
    "Nro. Req." AT 17 FORMAT "X(10)"  Almcmov.NroRf1  FORMAT "X(10)"
    x-transportista AT 89 FORMAT 'x(40)' SKIP
    /*Almcmov.codref AT 45  Almcmov.nroref*/
    x-codref AT 42  x-nroref
    x-ruc-trans AT 82 FORMAT 'x(12)'
    x-vehi-marca AT 115 FORMAT 'x(15)' SKIP
    x-lic-cond AT 88 FORMAT 'x(15)'
    x-placa-carreta AT 110 FORMAT 'x(19)' SKIP
    x-cert-inscrip AT 90 FORMA 'x(12)' 
    x-inicio-traslado AT 120 SKIP
    X-MOTIVO SKIP(1)
    "G/R " AT 96 FORMAT "X(4)" (STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999")) FORMAT "X(10)"
    Almcmov.fchdoc AT 115 FORMAT "99/99/9999" SKIP(2) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.


DEFINE FRAME F-DetaGui
    CCodUbi         AT 01 FORMAT "X(6)"
    I-NroItm        AT 07 FORMAT "Z9"
    Almdmov.codmat  AT 12 FORMAT "999999"
    almmmatg.desmat AT 27 FORMAT "X(45)"
    almmmatg.desmar /*AT 69*/ FORMAT "X(10)"
    Almdmov.candes  /*AT 81*/ FORMAT ">>>,>>>,>>9.99"
    Almdmov.CodUnd  /*AT 91*/ FORMAT "X(3)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui
    HEADER
    SKIP(3)
    x-bultos AT 41 FORMAT '->>>,>>9' lPesoMat AT 58 SKIP
    x-CrossDocking FORMAT 'x(15)' SKIP
    'ALM DESPACHO: ' x-AlmDesp FORMAT 'X(40)' SKIP
    'ALM INTERMD.: ' x-AlmInt FORMAT 'X(40)' SKIP
    'ALM DESTINO : ' x-AlmDest FORMAT 'X(40)' SKIP
    'Glosa   : ' Almcmov.Observ FORMAT 'X(30)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.


OUTPUT TO PRINTER PAGE-SIZE 44.

PUT CONTROL {&PRN0} + {&PRN5A} + CHR(48) + {&PRN3}.     

I-NroItm = 0.
lPesoMat = 0.
FOR EACH Almdmov OF Almcmov NO-LOCK , 
    FIRST almmmatg OF Almdmov NO-LOCK
                   BREAK BY Almdmov.nrodoc
                         BY Almdmov.NroItm
                         BY Almdmov.codmat:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    /*Impresion de Ubicacion*/
    FIND FIRST almmmate WHERE almmmate.codcia = almcmov.codcia
        AND almmmate.codalm = almdmov.codalm
        AND almmmate.codmat = almdmov.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN cCodUbi = almmmate.codubi.
    ELSE cCodUbi = "".

    I-NroItm = I-NroItm + 1.
    lPesoMat = lPesoMat + almdmov.pesmat.
    DISPLAY
        cCodUbi
        I-NroItm 
        Almdmov.codmat 
        almmmatg.desmat 
        almmmatg.desmar
        Almdmov.candes 
        Almdmov.CodUnd 
        WITH FRAME F-DetaGui.
    IF LAST-OF(Almdmov.nrodoc) THEN DO:
        PAGE.
    END.
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

DEFINE FRAME F-HdrGui
    HEADER
    SKIP(6)
    x-LugPar AT 12 FORMAT 'x(60)' SKIP
    x-LugEnt AT 12 FORMAT 'x(60)' SKIP
    b-Almacen.Descripcion AT 12 FORMAT "X(70)" SKIP
    b-Almacen.CodCli AT 12 FORMAT "X(11)" SKIP
    /*'NUEVO R.U.C 20100038146' AT 92  FORMAT "X(20)" SKIP(1)*/
    "Nro. Req." AT 17 FORMAT "X(10)"  Almcmov.NroRf1  FORMAT "X(10)"
    x-transportista AT 89 FORMAT 'x(40)' SKIP
    x-codref AT 42  x-nroref
    x-ruc-trans AT 82 FORMAT 'x(12)'
    x-vehi-marca AT 115 FORMAT 'x(15)' SKIP
    x-lic-cond AT 88 FORMAT 'x(15)'
    x-placa-carreta AT 110 FORMAT 'x(19)' SKIP
    x-cert-inscrip AT 90 FORMA 'x(12)' 
    x-inicio-traslado AT 120 SKIP
    X-MOTIVO SKIP(1)
    "G/R " AT 96 FORMAT "X(4)" (STRING(Almcmov.NroSer,"999") + STRING(Almcmov.NroDoc,"999999")) FORMAT "X(10)"
    Almcmov.fchdoc AT 115 FORMAT "99/99/9999" SKIP(2) 
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200.

DEFINE FRAME F-DetaGui
    Almdmov.codmat  AT 06 FORMAT "999999"
    Almdmov.candes  FORMAT ">>>,>>>,>>9.99"
    Almdmov.CodUnd  FORMAT "X(6)"
    almmmatg.desmat FORMAT "X(100)"
    WITH NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO WIDTH 200.

DEFINE FRAME F-FtrGui
    HEADER
    SKIP(3)
    x-bultos AT 41 FORMAT '->>>,>>9' lPesoMat AT 58 SKIP
    x-CrossDocking FORMAT 'x(15)' SKIP
    'ALM DESPACHO: ' x-AlmDesp FORMAT 'X(40)' SKIP
    'ALM INTERMD.: ' x-AlmInt FORMAT 'X(40)' SKIP
    'ALM DESTINO : ' x-AlmDest FORMAT 'X(40)' SKIP
    'Glosa   : ' Almcmov.Observ FORMAT 'X(30)' SKIP
    WITH PAGE-BOTTOM NO-LABELS NO-UNDERLINE NO-BOX STREAM-IO WIDTH 200.

OUTPUT TO PRINTER PAGE-SIZE 66.
PUT CONTROL {&PRN0} + {&PRN5A} + CHR(72) + {&PRN3}.     
I-NroItm = 0.
lPesoMat = 0.
FOR EACH Almdmov OF Almcmov NO-LOCK , 
    FIRST almmmatg OF Almdmov NO-LOCK
                   BREAK BY Almdmov.nrodoc
                         BY Almdmov.NroItm
                         BY Almdmov.codmat:
    VIEW FRAME F-HdrGui.
    VIEW FRAME F-FtrGui.
    I-NroItm = I-NroItm + 1.
    lPesoMat = lPesoMat + almdmov.pesmat.
    DISPLAY
        Almdmov.codmat 
        Almdmov.candes 
        Almdmov.CodUnd 
        almmmatg.desmat 
        WITH FRAME F-DetaGui.
    IF LAST-OF(Almdmov.nrodoc) THEN DO:
        PAGE.
    END.
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
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pRowid AS ROWID.

FIND Almcmov WHERE ROWID(Almcmov) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcmov THEN RETURN.

DEF VAR x-Formato AS CHAR NO-UNDO.
x-Formato = "13".       /* Formato por defecto: 13 líneas por hoja */

/* Cargamos temporales de acuerdo al origen */
FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND
    FacTabla.Tabla = 'CFG_FMT_GR' AND
    FacTabla.Codigo = s-CodDiv NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN x-Formato = FacTabla.Campo-C[1].
IF TRUE <> (x-Formato > '') THEN RETURN.
CASE TRUE:
    WHEN x-Formato = "13" THEN DO:
        /* Formato 13 líneas por hoja */
        RUN GRIMP_Carga-Temporal.
        RUN GRIMP_Pie-de-Pagina.
        RUN GRIMP_Formato-Continuo-13.
    END.
    WHEN x-Formato = "36" THEN DO:
        /* Formato 36 líneas por hoja */
        RUN GRIMP_Carga-Temporal.
        RUN GRIMP_Pie-de-Pagina-36.
        RUN GRIMP_Formato-Continuo-36.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

