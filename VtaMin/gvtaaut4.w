&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDM LIKE Facdpedm
       INDEX Llave01 CodCia CodDoc NroPed NroItm.



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
DEF OUTPUT PARAMETER pReturnValue AS CHAR.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcli AS CHAR.

    DEF VAR f-PreBas AS DEC NO-UNDO.
    DEF VAR f-PreVta AS DEC NO-UNDO.
    DEF VAR f-Dsctos AS DEC NO-UNDO.
    DEF VAR y-Dsctos AS DEC NO-UNDO.
    DEF VAR s-TpoCmb AS DEC NO-UNDO.
    DEF VAR sw-Log1 AS LOG NO-UNDO.
    DEF VAR f-Factor AS DEC NO-UNDO.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 FILL-IN-CodMat Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat FILL-IN-Unidad ~
FILL-IN-DesMat FILL-IN-PreUni FILL-IN-Descuento FILL-IN-CanPed 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15.

DEFINE VARIABLE FILL-IN-CanPed AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1
     BGCOLOR 11 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(13)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Descuento AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Descuento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-PreUni AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Precio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 12 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-Unidad AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "productos/restore.ico":U
     SIZE 20 BY 5.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     FILL-IN-CodMat AT ROW 1.54 COL 13 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Unidad AT ROW 1.54 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-DesMat AT ROW 1.54 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-PreUni AT ROW 2.62 COL 13 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Descuento AT ROW 3.69 COL 13 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-CanPed AT ROW 4.77 COL 13 COLON-ALIGNED WIDGET-ID 4
     Btn_OK AT ROW 6.38 COL 4
     Btn_Cancel AT ROW 6.38 COL 21
     "Presione F11 para editar la cantidad" VIEW-AS TEXT
          SIZE 32 BY .62 AT ROW 4.77 COL 31 WIDGET-ID 10
     IMAGE-1 AT ROW 3.15 COL 71 WIDGET-ID 16
     SPACE(24.71) SKIP(0.38)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "REGISTRO DEL PRODUCTO"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: PEDM T "SHARED" ? INTEGRAL Facdpedm
      ADDITIONAL-FIELDS:
          INDEX Llave01 CodCia CodDoc NroPed NroItm
      END-FIELDS.
   END-TABLES.
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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CanPed IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Descuento IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PreUni IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Unidad IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* REGISTRO DEL PRODUCTO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel gDialog
ON CHOOSE OF Btn_Cancel IN FRAME gDialog /* Cancel */
DO:
  pReturnValue = 'ADM-ERROR'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    RUN Graba-Registro.
  pReturnValue = 'OK'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat gDialog
ON LEAVE OF FILL-IN-CodMat IN FRAME gDialog /* Articulo */
DO:
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
    IF pCodMat = '' THEN DO:
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = pCodMat.
    /* Valida Maestro Productos */
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.codmat = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = ''.
       RETURN NO-APPLY.
    END.
    IF Almmmatg.TpoArt = "D" THEN DO:
       MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = ''.
       RETURN NO-APPLY.
    END.
/*     IF Almmmatg.Chr__01 = "" THEN DO:                                         */
/*        MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR. */
/*        SELF:SCREEN-VALUE = ''.                                                */
/*        RETURN NO-APPLY.                                                       */
/*     END.                                                                      */
    /* Valida Maestro Productos x Almacen */
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.CodAlm = trim(S-CODALM) 
        AND Almmmate.CodMat = trim(SELF:SCREEN-VALUE) 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
       MESSAGE "Articulo no esta asignado al" SKIP
               "    ALMACEN : " S-CODALM VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = ''.
       RETURN NO-APPLY.   
    END.

    /****    Selecciona las unidades de medida   ****/

    IF Almmmatg.UndAlt[1] = "" THEN DO:
       MESSAGE "Articulo no tiene Unidad de Venta"
               VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = ''.
       RETURN NO-APPLY.
    END.
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas AND  
        Almtconv.Codalter = Almmmatg.UndAlt[1]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    ELSE DO:
          MESSAGE "Equivalencia no Registrado"
                  VIEW-AS ALERT-BOX.
          RETURN NO-APPLY.
    END.
    /************************************************/
    DISPLAY 
        Almmmatg.DesMat    @ FILL-IN-DesMat 
        Almmmatg.UndAlt[1] @ FILL-IN-Unidad
        WITH FRAME {&FRAME-NAME}.

    RUN vta/PrecioTienda (s-CodCia,
                        s-CodDiv,
                        s-CodCli,
                        s-CodMon,
                        s-TpoCmb,
                        f-Factor,
                        Almmmatg.CodMat,
                        Almmmatg.UndAlt[1],
                        1,
                        2,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos,
                        OUTPUT SW-LOG1).
    DISPLAY 
        F-DSCTOS @ FILL-IN-Descuento
        F-PREVTA @ FILL-IN-PreUni
        WITH FRAME {&FRAME-NAME}.
  /* IMAGEN A MOSTRAR */
    DEF VAR x-Imagen AS CHAR FORMAT 'x(55)' NO-UNDO.
    x-Imagen = TRIM(SELF:SCREEN-VALUE) + ".jpg".
    x-Imagen = SEARCH(x-Imagen).
    IF x-Imagen <> ? THEN image-1:LOAD-IMAGE(x-Imagen).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-PreUni gDialog
ON LEAVE OF FILL-IN-PreUni IN FRAME gDialog /* Precio */
DO:
    IF INPUT {&SELF-NAME} < 1 THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

ON 'F11':U ANYWHERE
DO:
    FILL-IN-CanPed:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    APPLY 'ENTRY':U TO FILL-IN-CanPed IN FRAME {&FRAME-NAME}.
    RETURN.
END.

/*
ON 'F11':U OF Btn_Cancel, Btn_OK, FILL-IN-CodMat
DO:
    FILL-IN-CanPed:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    RETURN.
END.
*/

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
  DISPLAY FILL-IN-CodMat FILL-IN-Unidad FILL-IN-DesMat FILL-IN-PreUni 
          FILL-IN-Descuento FILL-IN-CanPed 
      WITH FRAME gDialog.
  ENABLE IMAGE-1 FILL-IN-CodMat Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registro gDialog 
PROCEDURE Graba-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i-NroItm AS INT NO-UNDO.

FIND FIRST Faccfggn WHERE Faccfggn.codcia = s-codcia NO-LOCK.

i-NroItm = 1.
FOR EACH PEDM:
    i-NroItm = i-NroItm + 1.
END.

CREATE PEDM.
  ASSIGN 
    PEDM.CodCia = S-CODCIA
    PEDM.Factor = F-FACTOR
    PEDM.NroItm = I-NroItm
    PEDM.AlmDes = s-CodAlm
    PEDM.CodMat = FILL-IN-CodMat:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
         
  ASSIGN 
    PEDM.PreBas = F-PreBas 
    PEDM.AftIgv = Almmmatg.AftIgv 
    PEDM.AftIsc = Almmmatg.AftIsc 
    PEDM.Flg_factor = IF SW-LOG1 THEN "1" ELSE "0"   /* Add by C.Q. 23/03/2000 */
    PEDM.CanPed = DEC(FILL-IN-CanPed:SCREEN-VALUE IN FRAME {&FRAME-NAME})
    PEDM.PreUni = DEC(FILL-IN-PreUni:SCREEN-VALUE IN FRAME {&FRAME-NAME})
    PEDM.PorDto = DEC(FILL-IN-Descuento:SCREEN-VALUE IN FRAME {&FRAME-NAME})
    PEDM.Por_DSCTOS[2] = Almmmatg.PorMax    /* Add by C.Q. 23/03/2000 */
    PEDM.Por_Dsctos[3] = Y-DSCTOS
    PEDM.ImpDto = ROUND( PEDM.PreUni * (PEDM.Por_Dsctos[1] / 100) * (IF SW-LOG1 THEN PEDM.CanPed ELSE (PEDM.CanPed * F-FACTOR)), 2 )
    PEDM.ImpLin = ROUND( PEDM.PreUni * (IF SW-LOG1 THEN PEDM.CanPed ELSE (PEDM.CanPed * F-FACTOR)) , 2 ) - PEDM.ImpDto.
    PEDM.UndVta = FILL-IN-Unidad:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  IF PEDM.AftIsc 
  THEN PEDM.ImpIsc = ROUND(PEDM.PreBas * (IF SW-LOG1 THEN PEDM.CanPed ELSE (PEDM.CanPed * F-FACTOR)) * (Almmmatg.PorIsc / 100),4).
  IF PEDM.AftIgv 
  THEN PEDM.ImpIgv = PEDM.ImpLin - ROUND(PEDM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).

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
  FILL-IN-CanPed = 1.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

