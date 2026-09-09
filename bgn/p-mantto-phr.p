&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-RutaC FOR DI-RutaC.
DEFINE BUFFER B-RutaD FOR DI-RutaD.
DEFINE TEMP-TABLE R-RutaC NO-UNDO LIKE DI-RutaC.
DEFINE TEMP-TABLE t-report-2 NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE T-RutaC NO-UNDO LIKE DI-RutaC
       FIELD Libre_d06 AS DEC
       FIELD Libre_d07 AS INT /* Ptos Entrega */
       .
DEFINE TEMP-TABLE T-RUTAD NO-UNDO LIKE DI-RutaD
       FIELD LugEnt AS CHAR
       FIELD SKU AS INT
       FIELD FchEnt AS DATE
       FIELD Docs AS INT
       FIELD Estado AS CHAR
       FIELD Reprogramado AS LOG INITIAL NO
       FIELD PtoDestino as char
       FIELD Departamento AS CHAR.
DEFINE TEMP-TABLE tt-DI-RutaC NO-UNDO LIKE DI-RutaC
       FIELD Libre_d06 AS DEC
       FIELD Libre_d07 AS INT /* Ptos Entrega */
       FIELD Libre_d08 AS INTE.
DEFINE BUFFER X-DI-RutaC FOR DI-RutaC.



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
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pDesde AS DATE.
DEF INPUT PARAMETER pHasta AS DATE.
DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF OUTPUT PARAMETER TABLE FOR t-report-2.

DEF SHARED VAR s-codcia AS INTE.

DEFINE TEMP-TABLE tt-puntos-entrega
    FIELD   tnrophr AS CHAR
    FIELD   tcodcli AS CHAR
    FIELD   tsede AS CHAR
    INDEX idx01 tnrophr tcodcli tsede.

DEFINE TEMP-TABLE tt-puntos-entrega2
    FIELD   tnrophr AS CHAR
    FIELD   tcodcli AS CHAR
    FIELD   tsede AS CHAR
    FIELD   tcoddoc AS CHAR
    FIELD   tnrodoc AS CHAR
    INDEX idx01 tnrophr tcodcli tsede tcoddoc tnrodoc.

DEF TEMP-TABLE Detalle
    FIELD FchDoc AS DATE FORMAT '99/99/9999' LABEL 'Fecha'
    FIELD NroDoc AS CHAR FORMAT 'x(9)' LABEL 'Numero'
    FIELD Estado AS CHAR FORMAT 'x(20)'
    FIELD Libre_d01 AS DECI FORMAT '>>>,>>9.99' LABEL 'Peso'
    FIELD Libre_d06 AS DECI FORMAT '>>>,>>9.99' LABEL 'Volumen'
    FIELD Libre_d02 AS DECI FORMAT '>>>,>>9.99' LABEL 'Importe'
    FIELD Libre_d03 AS DECI FORMAT '>>>,>>9' LABEL 'Clientes'
    FIELD Observ AS CHAR FORMAT 'x(40)' LABEL 'Glosa'
    FIELD Libre_c05 AS CHAR FORMAT 'x(10)' LABEL 'Usuario Modificacion'
    FIELD Libre_f05 AS DATE FORMAT '99/99/9999' LABEL 'Fecha Modificacion'

    FIELD DesDiv AS CHAR FORMAT 'x(25)' LABEL 'Canal'

    FIELD Termino_Pago AS CHAR FORMAT 'x(50)' LABEL 'Termino de Pago'
    FIELD Cliente_Recoge AS CHAR LABEL 'Cliente Recoge'
    FIELD Embalaje_Especial AS CHAR LABEL 'Embalaje Especial'
    FIELD Departamento AS CHAR FORMAT 'x(25)'
    FIELD Distrito AS CHAR FORMAT 'x(25)'
    FIELD CodRef AS CHAR FORMAT 'x(3)' LABEL 'Codigo'
    FIELD NroRef AS CHAR FORMAT 'x(9)' LABEL 'Numero'
    FIELD FchPed AS DATE FORMAT '99/99/9999' LABEL 'Fecha de Pedido'
    FIELD Hora   AS CHAR FORMAT 'x(10)' LABEL 'Hora'
    FIELD FchEnt AS DATE FORMAT '99/99/9999' LABEL 'Fecha Entrega'
    FIELD NomCli AS CHAR FORMAT 'x(100)' LABEL 'Cliente'
    FIELD Estado2 AS CHAR FORMAT 'x(20)' LABEL 'Estado'
    FIELD Sku AS INTE FORMAT '>>,>>9'
    FIELD Libre_c01 AS CHAR FORMAT 'x(6)' LABEL 'Bultos'
    FIELD Libre_d021 AS DECI FORMAT '>>>,>>9.99' LABEL 'Importe'
    FIELD Libre_d011 AS DECI FORMAT '>>>,>>9.99' LABEL 'Peso'
    FIELD ImpCob AS DECI FORMAT '>>>,>>9.99' LABEL 'm3'
    FIELD Repro01 AS DATE FORMAT '99/99/9999' LABEL 'Reprogramacion 1'
    FIELD Repro02 AS DATE FORMAT '99/99/9999' LABEL 'Reprogramacion 2'
    FIELD Repro03 AS DATE FORMAT '99/99/9999' LABEL 'Reprogramacion 3'
    FIELD Direccion AS CHAR FORMAT 'x(89)' LABEL 'Direccion'

    .

DEF TEMP-TABLE TT-RUTAD LIKE T-RUTAD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fDistrito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistrito Procedure 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fEstado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado Procedure 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fEstado2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado2 Procedure 
FUNCTION fEstado2 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fImporte) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImporte Procedure 
FUNCTION fImporte RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-RutaC B "?" ? INTEGRAL DI-RutaC
      TABLE: B-RutaD B "?" ? INTEGRAL DI-RutaD
      TABLE: R-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
      TABLE: t-report-2 T "?" NO-UNDO INTEGRAL w-report
      TABLE: T-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
      ADDITIONAL-FIELDS:
          FIELD Libre_d06 AS DEC
          FIELD Libre_d07 AS INT /* Ptos Entrega */
          
      END-FIELDS.
      TABLE: T-RUTAD T "?" NO-UNDO INTEGRAL DI-RutaD
      ADDITIONAL-FIELDS:
          FIELD LugEnt AS CHAR
          FIELD SKU AS INT
          FIELD FchEnt AS DATE
          FIELD Docs AS INT
          FIELD Estado AS CHAR
          FIELD Reprogramado AS LOG INITIAL NO
          FIELD PtoDestino as char
          FIELD Departamento AS CHAR
      END-FIELDS.
      TABLE: tt-DI-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
      ADDITIONAL-FIELDS:
          FIELD Libre_d06 AS DEC
          FIELD Libre_d07 AS INT /* Ptos Entrega */
          FIELD Libre_d08 AS INTE
      END-FIELDS.
      TABLE: X-DI-RutaC B "?" ? INTEGRAL DI-RutaC
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEF VAR s-coddoc AS CHAR INIT 'PHR' NO-UNDO.
  DEF VAR x-CodMov AS INTE NO-UNDO.
  DEF VAR k AS INTE NO-UNDO.

  EMPTY TEMP-TABLE t-report-2.
  EMPTY TEMP-TABLE T-RutaC.

  &SCOPED-DEFINE Condicion (DI-RutaC.CodCia = s-codcia AND ~
                            DI-RutaC.CodDoc = s-coddoc AND ~
                            (DI-RutaC.FchDoc >= pDesde AND DI-RutaC.FchDoc <= pHasta) AND ~
                            DI-RutaC.CodDiv = pCodDiv AND ~
                            (LOOKUP(DI-RutaC.FlgEst, pFlgEst, '|') > 0) ~
                            )

  FOR EACH DI-RutaC WHERE {&Condicion} NO-LOCK:
      
      RUN Registro-Auxiliar.

      CREATE T-RutaC.
      BUFFER-COPY DI-RutaC TO T-RutaC.
      FIND FIRST tt-DI-RutaC OF DI-RutaC NO-LOCK NO-ERROR.
      IF AVAILABLE tt-DI-RutaC THEN 
          ASSIGN
          T-RutaC.Libre_d01 = tt-DI-RutaC.Libre_d01
          T-RutaC.Libre_d06 = tt-DI-RutaC.Libre_d06
          T-RutaC.Libre_d02 = tt-DI-RutaC.Libre_d02
          T-RutaC.Libre_d03 = tt-DI-RutaC.Libre_d03
          T-RutaC.Libre_f05 = tt-DI-RutaC.Libre_f05.
  END.

  DEF VAR i-Cuentas AS INTE NO-UNDO.

  FOR EACH T-RutaC NO-LOCK, FIRST Di-RutaC OF T-RutaC NO-LOCK:
      EMPTY TEMP-TABLE T-RutaD.
      RUN Captura-Temporal ( INPUT ROWID(Di-RutaC),
                             INPUT-OUTPUT TABLE T-RUTAD).
      FOR EACH T-RutaD NO-LOCK WHERE T-RutaD.CodCia = T-RutaC.CodCia AND
          T-RutaD.CodDiv = T-RutaC.CodDiv AND
          T-RutaD.CodDoc = T-RutaC.CodDoc AND
          T-RutaD.NroDoc = T-RutaC.NroDoc,
          FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = T-RutaD.CodCia AND
          Faccpedi.coddoc = T-RutaD.CodRef AND
          Faccpedi.nroped = T-RutaD.NroRef,
          FIRST gn-divi OF Faccpedi NO-LOCK:
          CREATE Detalle.
          BUFFER-COPY T-RutaC TO Detalle
              ASSIGN Detalle.Estado = fEstado().
          Detalle.termino_pago = "TRANSFERENCIA".
          IF Faccpedi.coddoc <> "OTR" THEN DO:
              FIND gn-convt WHERE gn-ConVt.Codig = Faccpedi.fmapgo NO-LOCK NO-ERROR.
              IF AVAILABLE gn-convt THEN Detalle.termino_pago = gn-ConVt.Codig + " " + gn-ConVt.Nombr.
          END.
          ASSIGN
              Detalle.DesDiv = gn-divi.desdiv
              Detalle.Distrito = fDistrito()
              Detalle.CodRef = T-RutaD.CodRef
              Detalle.NroRef = T-RutaD.NroRef
              Detalle.FchEnt = Faccpedi.FchEnt
              Detalle.NomCli = Faccpedi.NomCli
              Detalle.Estado2 = fEstado2()
              Detalle.Sku = T-RutaD.Sku
              Detalle.Libre_c01 = T-RutaD.Libre_c01
              Detalle.Libre_d021 = T-RutaD.Libre_d02
              Detalle.Libre_d011 = T-RutaD.Libre_d01
              Detalle.ImpCob = T-RutaD.ImpCob.
          ASSIGN
              Detalle.Cliente_Recoge = (IF FacCPedi.Cliente_Recoge = YES THEN "SI" ELSE "NO")
              Detalle.Embalaje_Especial = (IF FacCPedi.EmpaqEspec = YES THEN "SI" ELSE "NO")
              Detalle.Departamento = T-RUTAD.Departamento
              Detalle.FchPed = Faccpedi.fchped
              Detalle.hora   = Faccpedi.hora
              .
          ASSIGN
              Detalle.Direccion = Faccpedi.DirCli.
          /* Buscamos Reprogramaciones de GR */
          EMPTY TEMP-TABLE R-RUTAC.
            /* Buscamos por la O/D referenciada */
            FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = T-RutaD.codcia AND
                Ccbcdocu.codped = Faccpedi.codref AND   /* PED */
                Ccbcdocu.nroped = Faccpedi.nroref AND
                Ccbcdocu.coddoc = "G/R":
                FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.codcia = T-RutaD.codcia AND
                    B-RutaD.coddoc = "H/R" AND 
                    B-RutaD.codref = Ccbcdocu.CodDoc AND
                    B-RutaD.nroref = Ccbcdocu.NroDoc,
                    FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst = "C":
                    FIND FIRST R-RUTAC OF B-RutaC NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE R-RUTAC THEN DO:
                        CREATE R-RUTAC.
                        BUFFER-COPY B-RutaC TO R-RUTAC.
                    END.
                END.
            END.
            i-Cuentas = 0.
            FOR EACH R-RUTAC BREAK BY R-RUTAC.FchSal:
                IF FIRST-OF(R-RUTAC.FchSal) THEN DO:
                    i-Cuentas = i-Cuentas + 1.
                    CASE i-Cuentas:
                        WHEN 1 THEN Detalle.Repro01 = R-RutaC.FchSal.
                        WHEN 2 THEN Detalle.Repro02 = R-RutaC.FchSal.
                        WHEN 3 THEN Detalle.Repro03 = R-RutaC.FchSal.
                    END CASE.
                    IF i-Cuentas > 3 THEN LEAVE.
                END.
            END.
            /* Buscamos por la O/D referenciada */
        END.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Captura-Temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal Procedure 
PROCEDURE Captura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT-OUTPUT PARAMETER TABLE FOR TT-RUTAD.

EMPTY TEMP-TABLE TT-RUTAD.

DEF BUFFER B-RutaC FOR Di-RutaC.

FIND B-RutaC WHERE ROWID(B-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-RutaC THEN RETURN.
FIND FIRST x-di-rutac WHERE ROWID(x-di-rutac) = pRowid NO-LOCK NO-ERROR.

RUN Carga-Temporal (INPUT pRowid).

FOR EACH T-RUTAD OF B-RutaC NO-LOCK,
    FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia
    AND FacCPedi.CodDoc = T-RUTAD.CodRef
    AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK,
    FIRST GN-DIVI OF FacCPedi NO-LOCK,
    FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia
    AND DI-RutaD.CodDiv = T-RUTAD.CodDiv
    AND DI-RutaD.CodDoc = T-RUTAD.CodDoc
    AND DI-RutaD.CodRef = T-RUTAD.CodRef
    AND DI-RutaD.NroRef = T-RUTAD.NroRef
    AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK:
    CREATE TT-RUTAD.
    BUFFER-COPY T-RUTAD TO TT-RUTAD.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Temporal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal Procedure 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.

EMPTY TEMP-TABLE T-RUTAD.

DEF BUFFER B-RutaC FOR Di-RutaC.
FIND B-RutaC WHERE ROWID(B-RUtaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-RutaC THEN RETURN.
    
FIND FIRST x-di-rutac WHERE ROWID(x-di-rutac) = pRowid NO-LOCK NO-ERROR.
/**/
DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */
DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.

DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DEC NO-UNDO.
DEF VAR pLatitud AS DEC NO-UNDO.
DEF VAR pCuadrante AS CHAR NO-UNDO.

RUN logis\logis-librerias.p PERSISTENT SET hProc.
/**/            

FOR EACH DI-RutaD OF B-RutaC NO-LOCK, 
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-RutaD.codcia
        AND Faccpedi.coddoc = Di-RutaD.codref
        AND Faccpedi.nroped = Di-RutaD.nroref:

    CREATE T-RutaD.
    BUFFER-COPY DI-RutaD TO T-RutaD.
    T-RUTAD.Estado = fEstado().
    T-RUTAD.Libre_c01 = STRING(Faccpedi.AcuBon[9]).
    T-RUTAD.SKU = Faccpedi.Items.
    t-Rutad.Libre_d02 = Faccpedi.AcuBon[8].
    t-Rutad.Libre_d01 = Faccpedi.Peso.
    t-Rutad.ImpCob = Faccpedi.Volumen.
    /*t-rutad.ptodestino = fDistrito().*/
    t-Rutad.libre_c02 = "".
    /*t-RutaD.Departamento = fDepartamento()*/
    .

    RUN logis/p-datos-sede-auxiliar.r (
        FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
        FacCPedi.Ubigeo[3],   /* Auxiliar */
        FacCPedi.Ubigeo[1],   /* Sede */
        OUTPUT pUbigeo,
        OUTPUT pLongitud,
        OUTPUT pLatitud
        ).

    FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
        AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
        AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN t-rutad.ptodestino = TabDistr.NomDistr.
    FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
    IF AVAILABLE TabDepto THEN t-RutaD.Departamento = TabDepto.NomDepto.


    IF faccpedi.codcli = '20100047218' THEN DO:
        /* Es Grupo de Reparto */
        RUN Grupo-reparto IN hProc (INPUT Faccpedi.coddoc, 
                                    INPUT Faccpedi.nroped, /* O/D */
                                    OUTPUT x-DeliveryGroup, 
                                    OUTPUT x-InvoiCustomerGroup).       
        IF TRUE <> (x-DeliveryGroup > "") THEN DO:
            t-Rutad.libre_c02 = "ExtraOrdinario".
        END.
        ELSE DO:
            t-Rutad.libre_c02 = "Planificado".
        END.        
    END.
    /* ******************************* */
    /* RHC 12/08/2021 TC venta de caja */
    /* ******************************* */
    T-RUTAD.Libre_d02 = fImporte().
    /* ******************************* */
END.

DELETE PROCEDURE hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Registro-Auxiliar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registro-Auxiliar Procedure 
PROCEDURE Registro-Auxiliar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR x-nro-phr AS CHAR.
    DEFINE VAR x-nro-od AS CHAR.
    DEFINE VAR x-existe AS LOG INIT YES.    
    DEFINE VAR x-cuales AS INT.
    DEFINE VAR x-contenido AS CHAR.

    /**/    
    FIND FIRST tt-di-rutaC OF di-rutaC NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-di-rutaC THEN DO:
        CREATE tt-di-rutaC.   /* USING ROWID(ROWID(di-rutaC)) NO-ERROR.*/
        BUFFER-COPY di-rutaC TO tt-di-rutaC.
        /* Bultos */
        ASSIGN 
            tt-di-rutaC.libre_d04 = 0       /* Bultos */
            tt-di-rutaC.libre_d01 = 0       /* PEso */
            tt-di-rutaC.libre_d02 = 0       /* Importe */
            tt-di-rutaC.libre_d03 = 0       /* Clientes */
            tt-di-rutaC.libre_d05 = 0       /* SKUs */
            tt-di-rutaC.libre_d06 = 0       /* Volumen */
            tt-di-rutaC.libre_d07 = 0       /* Puntos de entrega */
            tt-di-rutaC.libre_d08 = 0       /* SKU no chequeados */
            .

        EMPTY TEMP-TABLE tt-puntos-entrega.

        FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
            FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
                AND FacCPedi.CodDoc = Di-RutaD.codref       /* O/D , OTR */
                AND FacCPedi.NroPed = Di-RutaD.nroref
            BREAK BY Faccpedi.CodCli:

            IF FIRST-OF(Faccpedi.CodCli) THEN tt-di-rutaC.libre_d03 = tt-di-rutaC.libre_d03 + 1.
            ASSIGN
                tt-Di-Rutac.Libre_d01 = tt-Di-Rutac.Libre_d01 + Faccpedi.Peso
                tt-Di-Rutac.Libre_d06 = tt-Di-Rutac.Libre_d06 + Faccpedi.Volumen
                tt-Di-Rutac.Libre_d05 = tt-Di-Rutac.Libre_d05 + Faccpedi.Items
                .
            IF Faccpedi.FlgEst = "P" AND LOOKUP(Faccpedi.FlgSit, "PC,C") = 0 THEN DO:
                tt-Di-Rutac.Libre_d08 = tt-Di-Rutac.Libre_d08 + Faccpedi.Items.
            END.
            /* ******************************* */
            /* RHC 12/08/2021 TC venta de caja */
            /* ******************************* */
            tt-Di-RutaC.Libre_d02 = tt-Di-RutaC.Libre_d02 + fImporte().
            /* ******************************* */
            /* Ic - 04Set2020 Puntos de entrega a pedido de Fernan segun meet avalado po Daniel Llican y Maz Ramos */
            FIND FIRST tt-puntos-entrega WHERE  tt-puntos-entrega.tnrophr = di-rutaC.nrodoc AND
                                                tt-puntos-entrega.tcodcli = faccpedi.codcli AND
                                                tt-puntos-entrega.tsede = faccpedi.sede EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-puntos-entrega THEN DO:
                CREATE tt-puntos-entrega.
                    ASSIGN  tt-puntos-entrega.tnrophr = di-rutaC.nrodoc
                            tt-puntos-entrega.tsede = faccpedi.sede
                            tt-puntos-entrega.tcodcli = faccpedi.codcli.
                    ASSIGN tt-di-rutaC.libre_d07 = tt-di-rutaC.libre_d07 + 1.
            END.
            CREATE tt-puntos-entrega2.
            ASSIGN   
                tt-puntos-entrega2.tnrophr = di-rutaC.nrodoc
                tt-puntos-entrega2.tcodcli = faccpedi.codcli
                tt-puntos-entrega2.tsede = FacCPedi.sede
                tt-puntos-entrega2.tcoddoc = FacCPedi.CodDoc
                tt-puntos-entrega2.tnrodoc = FacCPedi.nroped.
            /* Bultos */
            ASSIGN
                tt-Di-Rutac.Libre_d04 = tt-Di-Rutac.Libre_d04 + Faccpedi.AcuBon[9].
        END.    
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fDistrito) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDistrito Procedure 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pUbigeo AS CHAR NO-UNDO.
  DEF VAR pLongitud AS DEC NO-UNDO.
  DEF VAR pLatitud AS DEC NO-UNDO.
  DEF VAR pCuadrante AS CHAR NO-UNDO.

  RUN logis/p-datos-sede-auxiliar (
      FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
      FacCPedi.Ubigeo[3],   /* Auxiliar */
      FacCPedi.Ubigeo[1],   /* Sede */
      OUTPUT pUbigeo,
      OUTPUT pLongitud,
      OUTPUT pLatitud
      ).
  FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
      AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
      AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
      NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN RETURN TabDistr.NomDistr.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fEstado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado Procedure 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Estado AS CHAR NO-UNDO.
  CASE DI-RutaC.FlgEst:
      WHEN 'PF' THEN x-Estado = 'Por Fedatear'.
      WHEN 'PX' THEN x-Estado = 'Generadas'.
      WHEN 'PK' THEN x-Estado = 'Con HPK'.
      WHEN 'PC' THEN x-Estado = 'Pickeo OK'.
      WHEN 'P' THEN x-Estado = 'Chequeo OK'.
      WHEN 'C' THEN x-Estado = 'Con H/R'.
      WHEN 'A' THEN x-Estado = 'Anulada'.
      OTHERWISE x-Estado = DI-RutaC.FlgEst.
  END CASE.
  RETURN x-Estado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fEstado2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado2 Procedure 
FUNCTION fEstado2 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR cEstado AS CHAR NO-UNDO.

  cEstado = 'Aprobado'.
  CASE Faccpedi.CodDoc:
      WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
          IF Faccpedi.usrImpOD > '' THEN cEstado = 'Impreso'.
          IF Faccpedi.FlgSit = "P" OR Faccpedi.FlgSit = "PI" THEN cEstado = "Picking Terminado".
          IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "C" THEN cEstado = "Por Facturar".
          IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "PC" THEN cEstado = "Checking Terminado".
          IF Faccpedi.FlgEst = "C" THEN cEstado = "Documentado".
          IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "TG" THEN cEstado = "En Almacén".
      END.
  END CASE.
  RETURN cEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fImporte) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImporte Procedure 
FUNCTION fImporte RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Importe AS DEC NO-UNDO.

IF Faccpedi.CodDoc = "OTR" THEN DO:
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
          AND AlmStkGe.codmat = Facdpedi.codmat 
          AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
      IF AVAILABLE AlmStkGe THEN
          x-Importe = x-Importe + (AlmStkGe.CtoUni * Facdpedi.canped * Facdpedi.factor).
  END.
END.
ELSE DO:
  /* RHC 12/08/2021: Se va a tomar el tipo de cambio venta de caja cobranza */
  FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= Faccpedi.FchPed NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-tccja THEN
      x-Importe = x-Importe + (IF Faccpedi.codmon = 2 THEN Gn-tccja.venta * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
  ELSE 
      x-Importe = x-Importe + (IF Faccpedi.codmon = 2 THEN Faccpedi.TpoCmb * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
END.
RETURN x-Importe.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

