&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

    DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
    DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
    DEFINE SHARED VARIABLE S-CODMAT   AS CHAR.

    DEFINE SHARED VARIABLE pRCID AS INT.

    DEFINE TEMP-TABLE tmp-tabla
        FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
        FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
        FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
        FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
        FIELD t-FchPed LIKE FacDPedi.FchPed
        FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
        FIELD t-CodMat LIKE FacDPedi.codmat
        FIELD t-Canped LIKE FacDPedi.CanPed.

DEFINE BUFFER x-vtatabla FOR vtatabla.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tmp-tabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-CodAlm t-CodDiv t-CodDoc t-NroPed t-FchPed t-NomCli t-CanPed   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tmp-tabla WHERE ~{&KEY-PHRASE} NO-LOCK     ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tmp-tabla WHERE ~{&KEY-PHRASE} NO-LOCK     ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tmp-tabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tmp-tabla


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS x-Total 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "SALIR" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE x-Total AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tmp-tabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 gDialog _FREEFORM
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-CodAlm COLUMN-LABEL "Almacén!Despacho" FORMAT 'x(3)'
      t-CodDiv COLUMN-LABEL "División" FORMAT 'x(10)'
      t-CodDoc COLUMN-LABEL "Codigo!Documento"  FORMAT "XXX"
      t-NroPed COLUMN-LABEL "Numero!Pedido" FORMAT "XXX-XXXXXXXXXX"
      t-FchPed COLUMN-LABEL "  Fecha       !  Pedido       "  FORMAT "99/99/9999"
      t-NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
      t-CanPed COLUMN-LABEL "Cantidad" FORMAT "->>,>>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 14
         FONT 4
         TITLE "STOCK COMPROMETIDO" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     BROWSE-2 AT ROW 1 COL 1 WIDGET-ID 200
     x-Total AT ROW 15.23 COL 65 COLON-ALIGNED WIDGET-ID 2
     Btn_OK AT ROW 16.35 COL 2
     "O/D: Orden de Despacho" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 15.04 COL 2 WIDGET-ID 4
     "R/A: Repos. Autom." VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 15.62 COL 2 WIDGET-ID 6
     "OTR: Orden de Transferencia" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 15.04 COL 23 WIDGET-ID 8
     "RAN: Repos. Autom. Nocturna" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 15.62 COL 23 WIDGET-ID 10
     "INC: Incidencias" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 16.35 COL 23 WIDGET-ID 12
     SPACE(40.42) SKIP(0.91)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE ""
         DEFAULT-BUTTON Btn_OK WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB BROWSE-2 1 gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-Total IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tmp-tabla WHERE ~{&KEY-PHRASE} NO-LOCK
    ~{&SORTBY-PHRASE}.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal gDialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

x-Total = 0.

/* RHC Solo almacenes comerciales */
SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia
    AND Almacen.Campo-c[9] <> "I" AND Almacen.FlgRep = YES /*AND Almacen.Campo-c[6] = "Si"*/:
    /*********   Barremos los PED que son parciales y totales    ****************/
    FOR EACH FacDPedi NO-LOCK USE-INDEX Llave04 WHERE FacDPedi.CodCia = s-codcia 
        AND  FacDPedi.almdes = almacen.codalm
        AND  FacDPedi.codmat = s-codmat 
        AND  FacDPedi.CodDoc = 'PED'
        AND  FacDPedi.FlgEst = 'P',
        FIRST FacCPedi OF FacDPedi NO-LOCK:
        IF NOT LOOKUP(Faccpedi.FlgEst, "G,X,P,W,WX,WL") > 0 THEN NEXT.
            CREATE tmp-tabla.
            ASSIGN 
                t-CodAlm = Almacen.CodAlm
                t-CodDoc = FacCPedi.codDoc
                t-NroPed = FacCPedi.NroPed
                t-CodDiv = FacCPedi.CodDiv
                t-FchPed = FacCPedi.FchPed
                t-NomCli = FacCPedi.NomCli
                t-codmat = FacDPedi.CodMat
                t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate )
                x-Total = x-Total + t-CanPed.
    END.
    /*********   Barremos las O/D que son parciales y totales    ****************/
    FOR EACH FacDPedi NO-LOCK USE-INDEX Llave04 WHERE FacDPedi.CodCia = s-codcia
            AND  FacDPedi.almdes = almacen.codalm
            AND  FacDPedi.codmat = s-codmat 
            AND  FacDPedi.CodDoc = 'O/D'
            AND  FacDPedi.FlgEst = 'P',
            FIRST FacCPedi OF FacDPedi NO-LOCK:
        IF NOT Faccpedi.FlgEst = "P" THEN NEXT.
            CREATE tmp-tabla.
            ASSIGN 
                t-CodAlm = Almacen.CodAlm
                t-CodDoc = FacCPedi.codDoc
                t-NroPed = FacCPedi.NroPed
                t-CodDiv = FacCPedi.CodDiv
                t-FchPed = FacCPedi.FchPed
                t-NomCli = FacCPedi.NomCli
                t-codmat = FacDPedi.CodMat
                t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate )
                x-Total = x-Total + t-CanPed.
    END.
    /* ORDENES Y SOLICITUDES DE TRANSFERENCIA */
    FOR EACH FacDPedi NO-LOCK USE-INDEX Llave04 WHERE FacDPedi.CodCia = s-codcia
            AND  FacDPedi.almdes = almacen.codalm
            AND  FacDPedi.codmat = s-codmat 
            AND  FacDPedi.CodDoc = 'OTR'
            AND  FacDPedi.FlgEst = 'P',
            FIRST FacCPedi OF FacDPedi NO-LOCK:
        IF NOT Faccpedi.FlgEst = "P" THEN NEXT.
            CREATE tmp-tabla.
            ASSIGN 
                t-CodAlm = Almacen.CodAlm
                t-CodDoc = FacCPedi.codDoc
                t-NroPed = FacCPedi.NroPed
                t-CodDiv = FacCPedi.CodDiv
                t-FchPed = FacCPedi.FchPed
                t-NomCli = FacCPedi.NomCli
                t-codmat = FacDPedi.CodMat
                t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate )
                x-Total = x-Total + t-CanPed.
    END.
    /*******************************************************/
    /* Segundo barremos los pedidos de mostrador de acuerdo a la vigencia */
    FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK.
    TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
              (FacCfgGn.Hora-Res * 3600) + 
              (FacCfgGn.Minu-Res * 60).
    FOR EACH Facdpedi USE-INDEX Llave04 NO-LOCK WHERE Facdpedi.CodCia = s-codcia 
        AND Facdpedi.AlmDes = Almacen.CodAlm
        AND Facdpedi.codmat = s-codmat 
        AND Facdpedi.coddoc = 'P/M'
        AND Facdpedi.FlgEst = "P",
        FIRST Faccpedi OF Facdpedi WHERE Faccpedi.FlgEst = "P" NO-LOCK:
        TimeNow = (TODAY - Faccpedi.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(Faccpedi.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(Faccpedi.Hora, 4, 2)) * 60) ).
        IF TimeOut > 0 THEN DO:
            IF TimeNow <= TimeOut   /* Dentro de la valides */
            THEN DO:
                /* cantidad en reservacion */
                    CREATE tmp-tabla.
                    ASSIGN 
                      t-CodAlm = Almacen.CodAlm
                      t-CodDoc = Faccpedi.codDoc
                      t-NroPed = Faccpedi.NroPed
                      t-CodDiv = Faccpedi.CodDiv
                      t-FchPed = Faccpedi.FchPed
                      t-NomCli = Faccpedi.NomCli
                      t-codmat = Facdpedi.CodMat
                      t-CanPed = Facdpedi.Factor * Facdpedi.CanPed.
                    x-Total = x-Total + t-CanPed.
            END.
        END.
    END.

    /* ******************************************************* */
    /* RHC 23/04/2020 Mercadería comprometida por Cotizaciones */
    /* ******************************************************* */
    
    DEF VAR TimeLimit AS CHAR NO-UNDO.
    DEFINE VAR x-flg-reserva-stock AS CHAR.
    RLOOP:
    FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-CodCia AND
        FacTabla.tabla = 'GN-DIVI' AND
        FacTabla.campo-l[2] = YES :
        /* RHC 21/05/2020 Ahora tiene horas y/o hora tope */
        /* Pasada esa hora NO vale la Cotización */
        TimeLimit = ''.
        IF FacTabla.campo-c[1] > '' AND FacTabla.campo-c[1] > '0000' THEN DO:
            TimeLimit = STRING(FacTabla.campo-c[1], 'XX:XX').
            IF STRING(TIME, 'HH:MM') > TimeLimit THEN NEXT RLOOP.
        END.
        TimeOut = 0.
        IF FacTabla.valor[1] > 0 THEN TimeOut = (FacTabla.Valor[1] * 3600).       /* Tiempo máximo en en segundos */
        /* Barremos todas las cotizaciones relacionadas */

        x-flg-reserva-stock = "P".

        /*  Ic - 10Feb2021
            Divisiones que tienen que reservar Stock con un flgest en particular
     
            Correo de Daniel Llican, meet con Karim Mujica y Hiroshi Salcedo
                3. Una programación excepcional (si es posible que sea configurable) que rompa la actual regla del 
                canal mayorista para que no sea necesario aprobaciones de administrador y supervisor antes de 
                reservar stock, ya que en el canal de venta minorista whatsapp quien registra el pedido comercial 
                es un administrador, comparativamente con un vendedor la posibilidad de error es mucho menor 
                (pedido comercial OK en SKU y Cantidad al primer intento).        
        */
    
        FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                x-vtatabla.tabla = "CONFIG-VTAS" AND
                                x-vtatabla.llave_c1 = "PEDIDO.COMERCIAL" AND
                                x-vtatabla.llave_c2 = "FLG.RESERVA.STOCK" AND
                                x-vtatabla.llave_c3 = FacTabla.Codigo NO-LOCK NO-ERROR.     /* division */
        IF AVAILABLE x-vtatabla THEN DO:
            IF NOT (TRUE <> (x-vtatabla.llave_c4 > "")) THEN DO:
                x-flg-reserva-stock = TRIM(x-vtatabla.llave_c4).
            END.
        END.

        FOR EACH FacDPedi USE-INDEX Llave04 NO-LOCK WHERE FacDPedi.codcia = s-CodCia
            AND FacDPedi.almdes = Almacen.CodAlm
            AND FacDPedi.codmat = s-CodMat
            AND FacDPedi.coddoc = 'COT'
            AND FacDPedi.flgest = 'P',
            FIRST FacCPedi OF FacDPedi NO-LOCK WHERE FacCPedi.CodDiv = FacTabla.Codigo AND 
            LOOKUP(FacCPedi.FlgEst,x-flg-reserva-stock) > 0
            /*FacCPedi.FlgEst = "P"*/:
            TimeNow = (TODAY - FacCPedi.FchPed) * 24 * 3600.
            TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedi.Hora, 1, 2)) * 3600) +
                      (INTEGER(SUBSTRING(FacCPedi.Hora, 4, 2)) * 60) ).
            IF TimeOut > 0 THEN DO:
                IF TimeNow <= TimeOut   /* Dentro de la valides */
                THEN DO:
                    /* cantidad en reserva */
                    CREATE tmp-tabla.
                    ASSIGN 
                      t-CodAlm = Almacen.CodAlm
                      t-CodDoc = FacCPedi.codDoc
                      t-NroPed = FacCPedi.NroPed
                      t-FchPed = FacCPedi.FchPed
                      t-NomCli = FacCPedi.NomCli
                      t-codmat = FacDPedi.CodMat
                      t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
                    x-Total = x-Total + t-CanPed.
                END.
            END.
        END.
    END.
/*     FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-CodCia AND                      */
/*         FacTabla.Tabla = "GN-DIVI" AND                                                  */
/*         FacTabla.Campo-L[2] = YES AND   /* Compromete mercaderia por COT */             */
/*         FacTabla.Valor[1] > 0,          /* Tope en horas */                             */
/*         FIRST gn-divi NO-LOCK WHERE gn-divi.codcia = s-CodCia AND                       */
/*         gn-divi.coddiv = FacTabla.Codigo,                                               */
/*         EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-CodCia AND                      */
/*         Faccpedi.coddiv = gn-divi.coddiv AND                                            */
/*         Faccpedi.coddoc = "COT" AND                                                     */
/*         Faccpedi.flgest = "P",                                                          */
/*         FIRST Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = s-CodMat AND         */
/*         Facdpedi.flgest = "P" AND                                                       */
/*         Facdpedi.almdes = Almacen.CodAlm:                                               */
/*         TimeOut = (FacTabla.Valor[1] * 3600).       /* En segundos */                   */
/*         TimeNow = (TODAY - Faccpedi.FchPed) * 24 * 3600.                                */
/*         TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(Faccpedi.Hora, 1, 2)) * 3600) + */
/*                                      (INTEGER(SUBSTRING(Faccpedi.Hora, 4, 2)) * 60) ).  */
/*         IF TimeOut > 0 THEN DO:                                                         */
/*             IF TimeNow <= TimeOut   /* Dentro de la valides */                          */
/*             THEN DO:                                                                    */
/*                 CREATE tmp-tabla.                                                       */
/*                 ASSIGN                                                                  */
/*                   t-CodAlm = Almacen.CodAlm                                             */
/*                   t-CodDoc = FacCPedi.codDoc                                            */
/*                   t-NroPed = FacCPedi.NroPed                                            */
/*                   t-FchPed = FacCPedi.FchPed                                            */
/*                   t-NomCli = FacCPedi.NomCli                                            */
/*                   t-codmat = FacDPedi.CodMat                                            */
/*                   t-CanPed = FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).    */
/*             END.                                                                        */
/*         END.                                                                            */
/*     END.                                                                                */

END.

FOR EACH almacen NO-LOCK WHERE almacen.codcia = s-codcia
    AND Almacen.Campo-c[9] <> "I" AND Almacen.FlgRep = YES /*AND Almacen.Campo-c[6] = "Si"*/,
    EACH almmmate NO-LOCK WHERE almmmate.codcia = s-codcia
    AND almmmate.codalm = almacen.codalm
    AND almmmate.codmat = s-codmat:
    /*AND almmmate.stkact > 0:*/
    /* Stock Comprometido por Pedidos por Reposicion Automatica */
    FOR EACH Almcrepo NO-LOCK WHERE Almcrepo.codcia = s-codcia
        AND Almcrepo.AlmPed = Almacen.CodAlm
        AND LOOKUP(Almcrepo.FlgEst, 'P,X') > 0,
        EACH Almdrepo OF Almcrepo NO-LOCK WHERE Almdrepo.codmat = s-CodMat
        AND (almdrepo.CanApro > almdrepo.CanAten):
        IF NOT LOOKUP(Almcrepo.TipMov, 'A,M,RAN,INC') > 0 THEN NEXT.
        /* cantidad en reservacion */
        CREATE tmp-tabla.
        ASSIGN
          t-CodAlm = Almacen.CodAlm
          t-CodDoc = (IF Almcrepo.TipMov = "RAN" THEN "RAN" ELSE "R/A")
          t-NroPed = STRING(Almcrepo.nroser, '999') + STRING(Almcrepo.nrodoc, '9999999')
          t-CodDiv = Almacen.CodDiv
          t-FchPed = Almcrepo.FchDoc
          t-NomCli = Almcrepo.CodAlm
          t-codmat = s-CodMat
          t-CanPed = (Almdrepo.CanApro - Almdrepo.CanAten).
        x-Total = x-Total + t-CanPed.
        /* RHC 16/06/2020 Pintar INC */
        IF Almcrepo.TipMov = "INC" THEN 
            ASSIGN
            t-NroPed = Almcrepo.NroRef
            t-CodDoc = Almcrepo.CodRef
            t-NomCli = "Almacén: " + Almcrepo.CodAlm.
    END.
END.
SESSION:SET-WAIT-STATE('').
DISPLAY x-Total WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY x-Total 
      WITH FRAME gDialog.
  ENABLE BROWSE-2 Btn_OK 
      WITH FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN CARGA-TEMPORAL.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

