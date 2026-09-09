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

DEFINE INPUT PARAMETER X-ROWID AS ROWID.
FIND FacCPedi WHERE ROWID(FacCPedi) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN.

DEF SHARED VAR S-USER-ID AS CHAR. 
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR CL-codcia  AS INT.
DEF SHARED VAR pv-codcia  AS INT.
DEF SHARED VAR s-codalm  AS CHAR.
DEF SHARED VAR s-coddiv  LIKE gn-divi.coddiv.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR S-NomCia  AS CHAR.

DEF VAR s-Task-No AS INT NO-UNDO.

DEF        VAR C-NomVen  AS CHAR FORMAT "X(30)".
DEF        VAR C-Descli  AS CHAR FORMAT "X(60)".
DEF        VAR C-Moneda  AS CHAR FORMAT "X(7)".
DEF        VAR C-NomCon  AS CHAR FORMAT "X(30)".
DEF        VAR C-TitDoc  AS CHAR FORMAT "X(50)".
DEF        VAR XD        AS CHAR FORMAT "X(2)".
DEF        VAR I-NroItm  AS INTEGER.
DEF        VAR F-PreNet  AS DECIMAL.
DEF        VAR W-DIRALM  AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM  AS CHAR FORMAT "X(65)".

DEF        VAR F-PreUni  LIKE FacDPedi.Preuni.
DEF        VAR F-ImpLin  LIKE FacDPedi.ImpLin.
DEF        VAR F-ImpTot  LIKE FacCPedi.ImpTot.

DEF        VAR F-CodUbi  LIKE Almmmate.CodUbi.

DEFINE VARIABLE x-dscto AS DECIMAL.

DEFINE VARIABLE X-IMPIGV AS CHARACTER FORMAT "X(30)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(100)" NO-UNDO.
DEF VAR X-Percepcion AS CHAR FORMAT "x(60)" NO-UNDO.

IF FacCPedi.CodDoc = "PED" THEN C-TitDoc = "    PEDIDO :". 
ELSE C-TitDoc = "COTIZACION :".
C-TitDoc = "    PEDIDO :".

IF FacCpedi.Codmon = 2 THEN C-Moneda = "US$.".
ELSE C-Moneda = "S/  ".

C-NomVen = FacCPedi.CodVen.
C-NomCon = FacCPedi.FmaPgo.
XD       = STRING (FacCpedi.Fchven - FacCpedi.Fchped,"999").

IF FacCpedi.FlgIgv THEN DO:
   X-IMPIGV = "LOS PRECIOS INCLUYEN EL I.G.V.".
   F-ImpTot = FacCPedi.ImpTot.
END.
ELSE DO:
   X-IMPIGV = "LOS PRECIOS NO INCLUYEN EL IGV.".
   F-ImpTot = FacCPedi.ImpVta.
END.  

FIND gn-clie WHERE 
     gn-clie.codcia = CL-CODCIA AND  
     gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
C-DESCLI  = Gn-clie.codcli + ' - ' + Gn-clie.Nomcli     .
C-DESCLI  = FaccPedi.codcli + ' - ' + FaccPedi.Nomcli     .

FIND gn-ven WHERE 
     gn-ven.CodCia = FacCPedi.CodCia AND  
     gn-ven.CodVen = FacCPedi.CodVen 
     NO-LOCK NO-ERROR.
     
IF AVAILABLE gn-ven THEN C-NomVen = C-NomVen + " - " + gn-ven.NomVen.

FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN C-NomCon = gn-ConVt.Nombr.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = Faccpedi.coddiv
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi 
    THEN ASSIGN
            w-DirAlm = GN-DIVI.DirDiv
            w-TlfAlm = GN-DIVI.TelDiv.
/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(F-IMPTOT, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF FacCPedi.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").
x-Percepcion = "".
IF Faccpedi.acubon[5] > 0 THEN x-Percepcion = "* Operación sujeta a percepción del IGV: " +
    (IF FacCPedi.codmon = 1 THEN "S/." ELSE "US$") + TRIM(STRING(Faccpedi.acubon[5], '>>>,>>9.99')).

DEFINE VARIABLE C-OBS AS CHAR EXTENT 3.
DEFINE VARIABLE K AS INTEGER.
IF NUM-ENTRIES(FacCPedi.Observa,"-") - 1 > 6 THEN DO:
   DO K = 2 TO 7:
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[1] = C-OBS[1] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
   DO K = 8 TO NUM-ENTRIES(FacCPedi.Observa,"-"):
      IF ENTRY(K,FacCPedi.Observa,"-") <> "" THEN 
         C-OBS[2] = C-OBS[2] + "- " + ENTRY(K,FacCPedi.Observa,"-").
   END.
END.
ELSE DO: 
   C-OBS[1] = FacCPedi.Observa.
   C-OBS[2] = "".
END.

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
         HEIGHT             = 5.85
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

/* Definimos impresoras */

DEFINE VARIABLE X-ORDCOM AS CHARACTER FORMAT "X(18)".
DEFINE VARIABLE Rpta     AS LOG NO-UNDO.

DEFINE VAR x-listprecio AS CHAR.

IF FacCPedi.coddoc = "PED" THEN 
    X-ORDCOM = "Orden de Compra : ".
ELSE 
    X-ORDCOM = "Solicitud Cotiz.: ".
    
C-OBS[1] = '- LOS PRECIOS INCLUYEN IGV'.
C-OBS[2] = '- GARANTIZAMOS NUESTROS PRODUCTOS CON CERTIFICADOS DE CALIDAD'.
C-OBS[3] = '- SUJETO A DISPONIBILIDAD DE STOCK'.
/************************  DEFINICION DE FRAMES  *******************************/
/* Lista de Precio */
x-listprecio = "".
IF FacCpedi.libre_c01 <> ? THEN DO:
    x-listprecio = FacCpedi.libre_c01.
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = x-listprecio NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        x-listprecio = x-listprecio + " " + gn-divi.desdiv.
    END.
END.

/* CARGA TEMPORALES */
RUN Carga-Detalle.
RUN Carga-Promociones-2016.
RUN Datos-Adicionales.

DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */


GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta2/rbvta2.prl".
RB-REPORT-NAME = "Impresion Pedido Laser".
RB-INCLUDE-RECORDS = "O".
RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
RB-OTHER-PARAMETERS = "s-NomCia = " + s-NomCia + 
                        "~nx-EnLetras = " + x-EnLetras +
                        "~nc-Moneda = " + c-Moneda.

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).

/* DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */     */
/* DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */     */
/* DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */ */
/* DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */    */
/* DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */       */
/*                                                                              */
/*                                                                              */
/* GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.          */
/* RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta2/rbvta2.prl".                   */
/* RB-REPORT-NAME = "Impresion Cotizacion Laser".                               */
/*                                                                              */
/* RB-INCLUDE-RECORDS = "O".                                                    */
/* RB-FILTER = "w-report.task-no = " + STRING(s-task-no).                       */
/* RB-OTHER-PARAMETERS = "s-NomCia = " + s-NomCia +                             */
/*                         "~nx-EnLetras = " + x-EnLetras +                     */
/*                         "~nx-Disney = " + STRING(x-Disney) +                 */
/*                         "~nx-Propios = " + STRING(x-Propios) +               */
/*                         "~nx-Terceros = " + STRING(x-Terceros) +             */
/*                         "~nc-Moneda = " + c-Moneda.                          */
/*                                                                              */
/* RUN lib/_imprime2 (RB-REPORT-LIBRARY,                                        */
/*                    RB-REPORT-NAME,                                           */
/*                    RB-INCLUDE-RECORDS,                                       */
/*                    RB-FILTER,                                                */
/*                    RB-OTHER-PARAMETERS).                                     */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Detalle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle Procedure 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-pordto AS DEC NO-UNDO.

I-NroItm = 0.
s-Task-No = 0.
FOR EACH FacDPedi OF FacCPedi NO-LOCK WHERE FacDPedi.Libre_c05 <> 'OF',
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Facdpedi.codcia AND
    Almmmate.codmat = Facdpedi.codmat AND
    Almmmate.codalm = Facdpedi.almdes
    BY FacDPedi.NroItm:
    I-NroItm = I-NroItm + 1.
    IF s-Task-No = 0 THEN REPEAT:
        s-Task-No =RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
            THEN LEAVE.
    END.
    CREATE w-report.
    w-report.task-no = s-task-no.
    /* calculamos descuento */
    x-PorDto = ( 1 -  ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                 ( 1 - Facdpedi.Por_Dsctos[3] / 100 ) ) * 100.
    ASSIGN
        w-report.Llave-c    = "A"
        w-report.Campo-I[1] = I-NroItm
        w-report.Campo-C[1] = Facdpedi.codmat
        w-report.Campo-F[1] = Facdpedi.canped
        w-report.Campo-C[2] = Facdpedi.undvta
        w-report.Campo-C[3] = Almmmatg.desmat
        w-report.Campo-C[4] = Almmmatg.desmar
        w-report.Campo-F[2] = Facdpedi.preuni
        w-report.Campo-F[3] = x-PorDto
        w-report.Campo-F[4] = Facdpedi.implin
        w-report.Campo-C[5] = Almmmate.codubi
        .
END.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Carga-Promociones-2016) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Promociones-2016 Procedure 
PROCEDURE Carga-Promociones-2016 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-pordto AS DEC NO-UNDO.

FOR EACH FacDPedi OF FacCPedi NO-LOCK WHERE FacDPedi.Libre_c05 = 'OF',
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Facdpedi.codcia AND
    Almmmate.codmat = Facdpedi.codmat AND
    Almmmate.codalm = Facdpedi.almdes
    BY FacDPedi.NroItm:
    I-NroItm = I-NroItm + 1.
    IF s-Task-No = 0 THEN REPEAT:
        s-Task-No =RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
            THEN LEAVE.
    END.
    CREATE w-report.
    w-report.task-no = s-task-no.
    /* calculamos descuento */
    x-PorDto = ( 1 -  ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                 ( 1 - Facdpedi.Por_Dsctos[3] / 100 ) ) * 100.
    ASSIGN
        w-report.Llave-c    = "B"
        w-report.Campo-I[1] = I-NroItm
        w-report.Campo-C[1] = Facdpedi.codmat
        w-report.Campo-F[1] = Facdpedi.canped
        w-report.Campo-C[2] = Facdpedi.undvta
        w-report.Campo-C[3] = Almmmatg.desmat
        w-report.Campo-C[4] = Almmmatg.desmar
        /*w-report.Campo-F[2] = Facdpedi.preuni*/
        /*w-report.Campo-F[3] = x-PorDto*/
        /*w-report.Campo-F[4] = Facdpedi.implin*/
        w-report.Campo-C[5] = Almmmate.codubi
        .
END.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Datos-Adicionales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Datos-Adicionales Procedure 
PROCEDURE Datos-Adicionales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
    ASSIGN
        w-report.Llave-I = s-CodCia
        w-report.Campo-C[10] = Faccpedi.coddoc
        w-report.Campo-C[11] = Faccpedi.nroped.
    x-listprecio = "".
    IF FacCpedi.libre_c01 <> ? THEN DO:
        x-listprecio = FacCpedi.libre_c01.
        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = x-listprecio NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN DO:
            x-listprecio = x-listprecio + " " + gn-divi.desdiv.
        END.
    END.
    w-report.Campo-C[12] = x-listprecio.
    w-report.Campo-C[13] = c-descli.
    FIND gn-clie WHERE gn-clie.codcia = CL-CODCIA AND  
        gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
    w-report.Campo-C[14] = gn-clie.dircli.
    w-report.Campo-d[1] = Faccpedi.FchPed.
    w-report.Campo-d[2] = Faccpedi.FchEnt.
    w-report.Campo-d[3] = Faccpedi.FchVen.
    w-report.Campo-C[15] = gn-clie.ruc.
    w-report.Campo-C[16] = c-NomVen.
    w-report.Campo-C[17] = C-NomCon.
    w-report.Campo-C[18] = C-Moneda.
    w-report.Campo-C[19] = FacCPedi.Glosa.
    w-report.Campo-C[20] = C-OBS[1].
    w-report.Campo-C[21] = C-OBS[2].
    w-report.Campo-C[22] = C-OBS[3].
    w-report.Campo-F[10] = FacCPedi.ImpDto.
    w-report.Campo-F[11] = f-ImpTot.

    w-report.Campo-C[23] = "(" + Faccpedi.CodDiv + ")  " + w-DirAlm.
    w-report.Campo-C[24] = w-TlfAlm.
    w-report.Campo-C[25] = Faccpedi.OrdCmp.


END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

