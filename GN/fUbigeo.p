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
DEF SHARED VAR s-CodCia  AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.

DEF OUTPUT PARAMETER pCodDpto AS CHAR.
DEF OUTPUT PARAMETER pCodProv AS CHAR.
DEF OUTPUT PARAMETER pCodDist AS CHAR.
DEF OUTPUT PARAMETER pCodPos  AS CHAR.
DEF OUTPUT PARAMETER pZona    AS CHAR.
DEF OUTPUT PARAMETER pSubZona AS CHAR.

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
         HEIGHT             = 3.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER PEDIDO  FOR Faccpedi.
DEF BUFFER B-VtaDTabla FOR VtaDTabla.

/* Valor por Defecto */
ASSIGN
    pCodDpto = '15'
    pCodProv = '01'      /* Lima - Lima */
    pCodDist = '01'
    pCodPos  = ''      /* CODIGO POSTAL */
    pZona    = "01" 
    pSubZona = "01"
    .
FIND B-CPEDI WHERE B-CPEDI.CodCia = s-CodCia
    AND B-CPEDI.CodDiv = pCodDiv
    AND B-CPEDI.CodDoc = pCodDoc
    AND B-CPEDI.NroPed = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN RETURN.
DEF VAR pUbigeo AS CHAR NO-UNDO.
DEF VAR pLongitud AS DECI NO-UNDO.
DEF VAR pLatitud AS DECI NO-UNDO.
RUN logis/p-datos-sede-auxiliar (B-CPEDI.Ubigeo[2],
                                 B-CPEDI.Ubigeo[3],
                                 B-CPEDI.Ubigeo[1],
                                 OUTPUT pUbigeo,
                                 OUTPUT pLongitud,
                                 OUTPUT pLatitud).
pCodDpto = SUBSTRING(pUbigeo,1,2).
pCodProv = SUBSTRING(pUbigeo,3,2).
pCodDist = SUBSTRING(pUbigeo,5,2).

/* CASE pCodDoc:                                                                               */
/*     WHEN 'O/D' OR WHEN 'O/M' THEN DO:                                                       */
/*         FIND B-CPEDI WHERE B-CPEDI.CodCia = s-CodCia                                        */
/*             AND B-CPEDI.CodDiv = pCodDiv                                                    */
/*             AND B-CPEDI.CodDoc = pCodDoc                                                    */
/*             AND B-CPEDI.NroPed = pNroDoc                                                    */
/*             NO-LOCK NO-ERROR.                                                               */
/*         IF NOT AVAILABLE B-CPEDI THEN RETURN.                                               */
/*         /* Por defecto del cliente */                                                       */
/*         FIND gn-clie WHERE gn-clie.codcia = cl-codcia                                       */
/*             AND gn-clie.codcli = B-CPEDI.codcli                                             */
/*             NO-LOCK NO-ERROR.                                                               */
/*         FIND FIRST TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept                       */
/*             AND TabDistr.CodProvi = gn-clie.CodProv                                         */
/*             AND TabDistr.CodDistr = gn-clie.CodDist                                         */
/*             NO-LOCK NO-ERROR.                                                               */
/*         IF AVAILABLE TabDistr THEN                                                          */
/*             ASSIGN                                                                          */
/*             pCodDpto = TabDistr.CodDepto                                                    */
/*             pCodProv = TabDistr.CodProvi                                                    */
/*             pCodDist = TabDistr.CodDistr                                                    */
/*             pCodPos  = TabDistr.CodPos.                                                     */
/*         /* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */                   */
/*         FIND PEDIDO WHERE PEDIDO.codcia = B-CPEDI.codcia                                    */
/*             AND PEDIDO.coddoc = B-CPEDI.codref                                              */
/*             AND PEDIDO.nroped = B-CPEDI.nroref                                              */
/*             AND PEDIDO.codpos > ''                                                          */
/*             NO-LOCK NO-ERROR.                                                               */
/*         IF AVAILABLE PEDIDO THEN DO:                                                        */
/*             pCodPos = PEDIDO.CodPos.                                                        */
/*             IF pCodPos <> "P0" THEN DO:    /* NO PARA PROVINCIAS: Tomamos el del cliente */ */
/*                 FIND FIRST TabDistr WHERE TabDistr.CodPos = pCodPos NO-LOCK NO-ERROR.       */
/*                 IF AVAILABLE TabDistr THEN                                                  */
/*                     ASSIGN                                                                  */
/*                     pCodDpto = TabDistr.CodDepto                                            */
/*                     pCodProv = TabDistr.CodProvi                                            */
/*                     pCodDist = TabDistr.CodDistr.                                           */
/*             END.                                                                            */
/*         END.                                                                                */
/*     END.                                                                                    */
/*     WHEN 'OTR' THEN DO:                                                                     */
/*         FIND B-CPEDI WHERE B-CPEDI.CodCia = s-CodCia                                        */
/*             AND B-CPEDI.CodDiv = pCodDiv                                                    */
/*             AND B-CPEDI.CodDoc = pCodDoc                                                    */
/*             AND B-CPEDI.NroPed = pNroDoc                                                    */
/*             NO-LOCK NO-ERROR.                                                               */
/*         IF NOT AVAILABLE B-CPEDI THEN RETURN.                                               */
/*         FIND FIRST Almacen WHERE Almacen.codcia = B-CPEDI.codcia                            */
/*             AND Almacen.codalm = B-CPEDI.codcli                                             */
/*             NO-LOCK NO-ERROR.                                                               */
/*         IF AVAILABLE Almacen THEN DO:                                                       */
/*             FIND FIRST gn-divi WHERE GN-DIVI.CodCia = Almacen.codcia                        */
/*                 AND GN-DIVI.CodDiv = Almacen.coddiv                                         */
/*                 NO-LOCK NO-ERROR.                                                           */
/*             IF AVAILABLE gn-divi THEN DO:                                                   */
/*                 ASSIGN                                                                      */
/*                     pCodDpto = GN-DIVI.Campo-Char[3]                                        */
/*                     pCodProv = GN-DIVI.Campo-Char[4]                                        */
/*                     pCodDist = GN-DIVI.Campo-Char[5].                                       */
/*                 FIND FIRST TabDistr WHERE TabDistr.CodDepto = pCodDpto                      */
/*                     AND TabDistr.CodProvi = pCodProv                                        */
/*                     AND TabDistr.CodDistr = pCodDist                                        */
/*                     NO-LOCK NO-ERROR.                                                       */
/*                 IF AVAILABLE TabDistr THEN ASSIGN pCodPos = TabDistr.CodPos.                */
/*             END.                                                                            */
/*         END.                                                                                */
/*     END.                                                                                    */
/*     OTHERWISE RETURN.                                                                       */
/* END CASE.                                                                                   */

FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
    AND VtaDTabla.Tabla = "SZGHR"
    AND VtaDTabla.LlaveDetalle = "D"
    AND VtaDTabla.Libre_c01 = pCodDpto
    AND VtaDTabla.Libre_c02 = pCodProv
    AND VtaDTabla.Libre_c03 = pCodDist,
    FIRST B-VtaDTabla WHERE B-VtaDTabla.CodCia = VtaDTabla.CodCia
    AND B-VtaDTabla.Tabla = VtaDTabla.Tabla
    AND B-VtaDTabla.Llave = VtaDTabla.Llave
    AND B-VtaDTabla.Tipo  = VtaDTabla.Tipo
    AND B-VtaDTabla.LlaveDetalle = "C":
    ASSIGN
        pZona    = B-VtaDTabla.Llave
        pSubZona = B-VtaDTabla.Tipo.
    LEAVE.
END.
IF pCodPos = "P0" THEN ASSIGN pZona = "02" pSubZona = "01".  /* LIMA CENTRO AGENCIAS */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


