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
DEFINE INPUT PARAMETER pNroBulto AS INT NO-UNDO.
DEFINE INPUT PARAMETER pGrafico AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCodDOc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroDOc AS CHAR NO-UNDO.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR s-coddiv AS CHAR.

/*
    Si pBulto es CERO, lo generamos aca.
    Si pBulto es Negativo, el bulto es el numero de la orden - Rotulo master desde TAPICEROS.
*/
DEFINE VAR x-graficos AS CHAR.
DEFINE VAR x-grafico-rotulo AS CHAR.
DEFINE VAR x-bulto-rotulo AS INT.

DEFINE STREAM REPORTE.

/* Rotulo */
x-graficos = "€ƒŒ£§©µÄËÐØÞßæø±å†Š®¾½¼ÆÖÜÏ¶Ÿ¥#$%&‰".
x-grafico-rotulo = pGrafico.
IF pGrafico = "" THEN DO:
    x-bulto-rotulo = RANDOM ( 1 , LENGTH(x-graficos) ).
    x-grafico-rotulo = SUBSTRING(x-graficos,x-bulto-rotulo,1).
END.

x-bulto-rotulo = pNroBulto.
IF pNroBulto = 0 OR pNroBulto > 999999 THEN DO:
    x-bulto-rotulo = RANDOM ( 1 , 999999 ).
END.

/* Datos de la ORDEN */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                            faccpedi.coddoc = pCodDOc AND 
                            faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "No existe la Orden " + pCodDoc + " " + pNroDoc.
    RETURN ERROR.
END.

DEFINE TEMP-TABLE rr-w-report LIKE w-report.

DEFINE VAR x-codper AS CHAR.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN carga-info.
RUN imprimir-rotulo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-carga-info) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-info Procedure 
PROCEDURE carga-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR dPeso        AS DECIMAL   NO-UNDO.
DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
DEFINE VAR cDir         AS CHARACTER NO-UNDO.
DEFINE VAR cSede        AS CHARACTER NO-UNDO.
DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

DEFINE VAR lCodRef AS CHAR.
DEFINE VAR lNroRef AS CHAR.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

DEFINE VAR lCodRef2 AS CHAR.
DEFINE VAR lNroRef2 AS CHAR.

DEFINE VAR x-almfinal AS CHAR.
DEFINE VAR x-cliente-final AS CHAR.
DEFINE VAR x-cliente-intermedio AS CHAR.
DEFINE VAR x-direccion-final AS CHAR.
DEFINE VAR x-direccion-intermedio AS CHAR.

DEFINE BUFFER x-almacen FOR almacen.
DEFINE BUFFER x-pedido FOR faccpedi.
DEFINE BUFFER x-cotizacion FOR faccpedi.

DEFINE VAR i-nro AS INT.


cNomCHq = "".
lCodDoc = "".
lNroDoc = "".

x-codper = faccpedi.usrchq.

FIND FIRST Pl-pers WHERE pl-pers.codcia = s-codcia
    AND Pl-pers.codper = x-CodPer NO-LOCK NO-ERROR.
IF AVAILABLE Pl-pers 
    THEN cNomCHq = Pl-pers.codper + "-" + TRIM(Pl-pers.patper) + ' ' +
        TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).                

dPeso = 0.      /**ControlOD.PesArt.*/
lCodRef2 = pCoddoc.
lNroRef2 = pNroDoc.

x-cliente-final = faccpedi.nomcli.
x-direccion-final = faccpedi.dircli.
x-cliente-intermedio = "".
x-direccion-intermedio = "".

/* CrossDocking almacen FINAL */
x-almfinal = "".
IF faccpedi.crossdocking = YES THEN DO:
    lCodRef2 = faccpedi.codref.
    lNroRef2 = faccpedi.nroref.
    lCodDoc = "(" + faccpedi.coddoc.
    lNroDoc = faccpedi.nroped + ")".

    x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
    x-direccion-intermedio = faccpedi.dircli.

    IF faccpedi.codref = 'R/A' THEN DO:
        FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                    x-almacen.codalm = faccpedi.almacenxD
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion). /*x-almfinal = TRIM(x-almacen.descripcion).*/
        IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm). /*x-almfinal = TRIM(x-almacen.descripcion).*/
    END.
END.
/* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
/* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
/* Crossdocking */
IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
    lCodDoc = "(" + pCoddoc.
    lNroDoc = pnrodoc + ")".
    lCodRef = faccpedi.codref.
    lNroRef = faccpedi.nroref.
    RELEASE faccpedi.

    FIND faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = lCodRef
        AND faccpedi.nroped = lNroRef
        NO-LOCK NO-ERROR.
    IF NOT AVAIL faccpedi THEN DO:
        MESSAGE "Pedido de Referencia de la OTR no existe" lCodRef lNroRef
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "ADM-ERROR".
    END.
    x-cliente-final = "".
    IF faccpedi.CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
    x-cliente-final = x-cliente-final + faccpedi.nomcli.
    x-direccion-final = faccpedi.dircli.
END.
/* Ic - 02Dic2016 - FIN */

/* Datos Sede de Venta */
FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
IF AVAIL gn-divi THEN 
    ASSIGN 
        cDir = INTEGRAL.GN-DIVI.DirDiv
        cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = s-CodAlm
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.

/* Peso de la Orden */
dPeso = 0.
FOR EACH facdpedi OF faccpedi NO-LOCK :
    FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        dPeso = dPeso  + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat).
    END.    
END.
/* Cuantos Bultos */
i-nro = 0.
RUN logis/p-numero-de-bultos (s-CodDiv,
                              pCodDoc,
                              pNroDoc,
                              OUTPUT i-Nro).
/* FOR EACH controlOD WHERE controlOD.codcia = s-codcia AND        */
/*                             controlOD.coddoc = pCodDOc AND      */
/*                             controlOD.nrodoc = pNroDOc NO-LOCK: */
/*     i-nro = i-nro + 1.                                          */
/* END.                                                            */

EMPTY TEMP-TABLE rr-w-report.

CREATE rr-w-report.
ASSIGN  rr-w-report.Llave-C  = "01" + faccpedi.nroped
    rr-w-report.Campo-C[1] = faccpedi.ruc
    rr-w-report.Campo-C[2] = x-cliente-final   
    rr-w-report.Campo-C[3] = x-direccion-final  
    rr-w-report.Campo-C[4] = x-codper + " " + cNomChq
    rr-w-report.Campo-D[1] = faccpedi.fchped
    rr-w-report.Campo-C[5] = "0"
    rr-w-report.Campo-F[1] = dPeso
    rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 
    rr-w-report.Campo-I[1] = i-nro
    rr-w-report.Campo-C[8] = cDir
    rr-w-report.Campo-C[9] = cSede
    rr-w-report.Campo-C[10] = ""
    rr-w-report.Campo-D[2] = faccpedi.fchent
    rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
    rr-w-report.campo-c[12] = x-cliente-intermedio    
    rr-w-report.campo-c[13] = "BULTOS " + STRING(x-bulto-rotulo) + x-grafico-rotulo + "   " + "CANT. " + STRING(i-nro)
    .       
    IF pNroBulto < 0 THEN DO:
        /* Rotulo Master de Tapioeros con HPK */
        rr-w-report.campo-c[13] = faccpedi.coddoc + "-" + faccpedi.nroped.
    END.
/* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
IF s-coddiv = '00506' THEN DO:
    /* Busco el Pedido */
    FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                x-pedido.coddoc = faccpedi.codref AND 
                                x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE x-pedido THEN DO:
        /* Busco la Cotizacion */
        FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                    x-cotizacion.coddoc = x-pedido.codref AND 
                                    x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE x-cotizacion THEN DO:
            ASSIGN w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref).
        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimir-rotulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-rotulo Procedure 
PROCEDURE imprimir-rotulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN DO:
    RETURN.
END.

DEFINE VAR lDireccion1 AS CHAR.
DEFINE VAR lDireccion2 AS CHAR.
DEFINE VAR lDirPart1 AS CHAR.
DEFINE VAR lDirPart2 AS CHAR.
DEFINE VAR lbarra AS CHAR.
DEFINE VAR lSede AS CHAR.
DEFINE VAR lRuc AS CHAR.
DEFINE VAR lpedido AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lChequeador AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lFechaEnt AS DATE.
DEFINE VAR lEtiqueta AS CHAR.
DEFINE VAR lpeso AS DEC.
DEFINE VAR lBultos AS CHAR.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lRefOtr AS CHAR.
DEFINE VAR x-almfinal AS CHAR.

DEFINE VAR rpta AS LOG.

IF pNroBulto >= 0 THEN DO:
    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.
END.

OUTPUT STREAM REPORTE TO PRINTER.

/*
DEFINE VAR x-file-zpl AS CHAR.

x-file-zpl = "d:\tmp\" + REPLACE(pCoddoc,"/","") + "-" + pNroDOc + ".txt".

OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
*/

FOR EACH rr-w-report WHERE NO-LOCK:

    /* Los valores */
    lDireccion1 = rr-w-report.campo-c[8].
    lSede = rr-w-report.campo-c[9].
    lRuc = rr-w-report.campo-c[1].
    lPedido = rr-w-report.campo-c[7].
    lCliente = rr-w-report.campo-c[2].
    lDireccion2 = rr-w-report.campo-c[3].
    lChequeador = rr-w-report.campo-c[4].
    lFecha = rr-w-report.campo-d[1].
    lFechaEnt = rr-w-report.campo-d[2].
    lEtiqueta = rr-w-report.campo-c[10].
    lPeso = rr-w-report.campo-f[1].
    lBultos = TRIM(rr-w-report.campo-c[13]).  /*STRING(rr-w-report.campo-i[1],"9999") + " / " + rr-w-report.campo-c[5].*/
    lBarra = STRING(rr-w-report.llave-c,"99999999999") + STRING(rr-w-report.campo-i[1],"9999").    
    lRefOtr = TRIM(rr-w-report.campo-c[11]).

    /* Ic - 10Set2018, realmente es el destino Intermedio */
    x-almfinal = TRIM(rr-w-report.campo-c[12]).
    IF s-coddiv <> '00506' THEN DO:
        IF x-almfinal <> "" THEN x-almfinal = "D.INTERMEDIO:" + x-almfinal.
    END.    

    lDireccion2 = TRIM(lDireccion2) + FILL(" ",110).
    lDirPart1 = SUBSTRING(lDireccion2,1,55).
    lDirPart2 = SUBSTRING(lDireccion2,56).

    lPedido = "Nro. " + lPedido.
    IF pNroBulto < 0 THEN DO:
        /* Master de Tapiceros con HPK */
        lPedido = "Bultos : " + STRING(rr-w-report.Campo-I[1]).
    END.    

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^FO025,20" SKIP.
    PUT STREAM REPORTE "^ADN,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "CONTINENTAL S.A.C." SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO020,050" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lBultos FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO035,130" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Direccion:" + lDireccion1 FORMAT 'x(77)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,160" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Sede :" + lSede FORMAT 'x(70)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO690,030^BY2" SKIP. 
    PUT STREAM REPORTE "^B3R,N,80,N" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lBarra FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS".
    */
    PUT STREAM REPORTE "^FO660,110" SKIP.
    PUT STREAM REPORTE "^ADR,0,60" SKIP.
    PUT STREAM REPORTE "^FDMASTER" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,190" SKIP. /*150*/
    PUT STREAM REPORTE "^A0N,60,45" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lPedido FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO400,200" SKIP.  /*150*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "RUC:" + lRuc FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,250" SKIP.  /*200*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "DESTINO" FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.   

    PUT STREAM REPORTE "^FO035,280" SKIP. /*230*/
    /*PUT STREAM REPORTE "^A0N,30,30" SKIP.*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lCliente FORMAT 'x(70)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,320" SKIP.  /*270*/
    /*PUT STREAM REPORTE "^A0N,30,30" SKIP.  */
    PUT STREAM REPORTE "^A0N,30,20" SKIP.  
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart1 FORMAT 'x(55)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,350" SKIP.   /*320*/
    /*PUT STREAM REPORTE "^A0N,30,30" SKIP.*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart2 FORMAT 'x(55)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,400" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Chequeador :" + lChequeador FORMAT 'x(55)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,450" SKIP.  /*400*/
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Fecha :" + STRING(lFecha,"99/99/9999") FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO290,400" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Etiqueta :" + lEtiqueta FORMAT 'x(28)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO035,450" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTOS :" + lbultos FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO370,450" SKIP.  
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "PESO :" + STRING(lPeso,"ZZ,ZZZ,ZZ9.99") FORMAT 'x(19)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,500" SKIP.   
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Entrega :" + STRING(lFechaEnt,"99/99/9999") FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,500" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE x-almfinal FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.
END.

OUTPUT STREAM REPORTE CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

