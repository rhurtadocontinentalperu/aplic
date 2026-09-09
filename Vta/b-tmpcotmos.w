= 16.77
         VIRTUAL-WIDTH      = 88.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img/plobrper":U) THEN
    MESSAGE "Unable to load icon: img/plobrper"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Asignaci¢n de Personal - Obreros */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Asignaci¢n de Personal - Obreros */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Datos|Personal|Cargos|CTS|Secciones|Clases|Proyectos|Canales' + ',
                     FOLDER-TAB-TYPE = 2':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 16.54 , 85.86 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/q-plan-s.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-plan-s ).
       /* Position in UIB:  ( 2.19 , 2.57 ) */
       /* Size in UIB:  ( 1.31 , 5.43 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/b-pers-s.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-pers-s ).
       RUN set-position IN h_b-pers-s ( 3.81 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.65 , 68.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/v-pers-s.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-pers-s ).
       RUN set-position IN h_v-pers-s ( 8.69 , 2.86 ) NO-ERROR.
       /* Size in UIB:  ( 8.35 , 82.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/v-plan.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-plan ).
       RUN set-position IN h_v-plan ( 2.27 , 8.14 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 52.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 2.27 , 60.57 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.38 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updva2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updva2 ).
       RUN set-position IN h_p-updva2 ( 3.81 , 72.57 ) NO-ERROR.
       RUN set-size IN h_p-updva2 ( 4.38 , 12.00 ) NO-ERROR.

       /* Links to SmartQuery h_q-plan-s. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-plan-s ).

       /* Links to SmartBrowser h_b-pers-s. */
       RUN add-link IN adm-broker-hdl ( h_v-plan , 'Record':U , h_b-pers-s ).

       /* Links to SmartViewer h_v-pers-s. */
       RUN add-link IN adm-broker-hdl ( h_b-pers-s , 'Record':U , h_v-pers-s ).
       RUN add-link IN adm-broker-hdl ( h_p-updva2 , 'TableIO':U , h_v-pers-s ).

       /* Links to SmartViewer h_v-plan. */
       RUN add-link IN adm-broker-hdl ( h_q-plan-s , 'Record':U , h_v-plan ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PLN/V-PERS1.W':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_V-PERS1 ).
       RUN set-position IN h_V-PERS1 ( 4.38 , 1.86 ) NO-ERROR.
       /* Size in UIB:  ( 10.65 , 84.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updpar.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updpar ).
       RUN set-position IN h_p-updpar ( 15.27 , 34.00 ) NO-ERROR.
       RUN set-size IN h_p-updpar ( 1.77 , 20.00 ) NO-ERROR.

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1') NO-ERROR.

       /* Links to SmartViewer h_V-PERS1. */
       RUN add-link IN adm-broker-hdl ( h_b-pers-s , 'Record':U , h_V-PERS1 ).
       RUN add-link IN adm-broker-hdl ( h_p-updpar , 'TableIO':U , h_V-PERS1 ).

    END. /* Page 2 */

    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/b-carg.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-carg ).
       RUN set-position IN h_b-carg ( 4.27 , 10.57 ) NO-ERROR.
       /* Size in UIB:  ( 9.88 , 50.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updsav.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updsav ).
       RUN set-position IN h_p-updsav ( 4.27 , 61.43 ) NO-ERROR.
       RUN set-size IN h_p-updsav ( 9.85 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-carg. */
       RUN add-link IN adm-broker-hdl ( h_p-updsav , 'TableIO':U , h_b-carg ).

    END. /* Page 3 */

    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/b-cts.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cts ).
       RUN set-position IN h_b-cts ( 4.15 , 17.43 ) NO-ERROR.
       /* Size in UIB:  ( 8.65 , 42.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updsav.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updsav-2 ).
       RUN set-position IN h_p-updsav-2 ( 4.15 , 60.29 ) NO-ERROR.
       RUN set-size IN h_p-updsav-2 ( 8.65 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cts. */
       RUN add-link IN adm-broker-hdl ( h_p-updsav-2 , 'TableIO':U , h_b-cts ).

    END. /* Page 4 */

    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PLN/B-SECC.W':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_B-SECC ).
       RUN set-position IN h_B-SECC ( 4.42 , 13.29 ) NO-ERROR.
       /* Size in UIB:  ( 8.62 , 48.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updsav.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updsav-5 ).
       RUN set-position IN h_p-updsav-5 ( 4.42 , 62.00 ) NO-ERROR.
       RUN set-size IN h_p-updsav-5 ( 8.62 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_B-SECC. */
       RUN add-link IN adm-broker-hdl ( h_p-updsav-5 , 'TableIO':U , h_B-SECC ).

    END. /* Page 5 */

    WHEN 6 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/b-clas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-clas ).
       RUN set-position IN h_b-clas ( 5.15 , 4.14 ) NO-ERROR.
       /* Size in UIB:  ( 8.65 , 64.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updsav.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updsav-3 ).
       RUN set-position IN h_p-updsav-3 ( 5.15 , 69.57 ) NO-ERROR.
       RUN set-size IN h_p-updsav-3 ( 8.65 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-clas. */
       RUN add-link IN adm-broker-hdl ( h_p-updsav-3 , 'TableIO':U , h_b-clas ).

    END. /* Page 6 */

    WHEN 7 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/b-proy.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-proy ).
       RUN set-position IN h_b-proy ( 5.35 , 7.29 ) NO-ERROR.
       /* Size in UIB:  ( 7.85 , 60.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updsav.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updsav-4 ).
       RUN set-position IN h_p-updsav-4 ( 5.35 , 68.14 ) NO-ERROR.
       RUN set-size IN h_p-updsav-4 ( 7.85 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-proy. */
       RUN add-link IN adm-broker-hdl ( h_p-updsav-4 , 'TableIO':U , h_b-proy ).

    END. /* Page 7 */

    WHEN 8 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PLN/B-PAGO.W':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_B-PAGO ).
       RUN set-position IN h_B-PAGO ( 4.77 , 11.43 ) NO-ERROR.
       /* Size in UIB:  ( 9.23 , 49.43 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updsav.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updsav-6 ).
       RUN set-position IN h_p-updsav-6 ( 4.77 , 61.43 ) NO-ERROR.
       RUN set-size IN h_p-updsav-6 ( 9.23 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_B-PAGO. */
       RUN add-link IN adm-broker-hdl ( h_p-updsav-6 , 'TableIO':U , h_B-PAGO ).

    END. /* Page 8 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  VIEW FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	”ŒVŸÀ∏:    8ˇ4              a                                V}      `  ‘              2o  `t"      $  ) ƒ4  ƒ  à5  ƒ  L6  0 |7  ‘  P8   X9  ‘  ,:  ƒ  :  ƒ  ¥;  Ñ	 8=  ƒ 
 ¸=  ƒ  ¿>  ( Ë?   ¸@  X TB   hC  8 †D   ¥E  Ë úI  ƒ  `J   dK  ¿ $M   (N   ,O   0P  P Ä^  î c  –  ‰c  Ã  ∞d  ¨   \e  ê ! Ïe  – "         ºf  Ã   ? àg  ™iSO8859-1                        ƒ  $ †                       T                             F¡                                                      PROGRESS                           ,    ¿ 
   
                ¨        ¯                                             ,      
  > ˇˇ  P       > ˇˇ T       ˇˇ                           l       ˇˇˇˇ                          h     H 8                    X      ú¶x  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    t        § $ ( à ˇˇˇ                         Ä ﬂ±  H i ∞ ∏   4 ˇˇ   o j    ÿ                   «< NAP ÄX Äl  Ä  î ® º – ‰ ¯ `
` $4H \  $ { ,ˇˇˇ        p   
            Ä ﬂ±  Ä } T\    4 ˇˇÑ  	~ x                    3 ˇˇ†‡ ä åî    4 ˇˇ®  $ ã ®ˇˇˇ        ¸@        Ï       Ä ﬂ±     
            Ä ﬂ±  Ù$ aƒˇˇˇ        (/	o   8          3 ˇˇ            3 ˇˇD  p4t    4 ˇˇX        |          ˇÄ             qt       §Rv   q<ú/rî                3 ˇˇlÃ$ r∞ˇˇˇ        ê   
              Ä ﬂ±    /s‰   Ïº          3 ˇˇú   ¯        3 ˇˇ»ò$ yˇˇˇ        ‡@        –       Ä ﬂ±  adm-apply-entry   0                ú                     ñ adm-destroy @p                ú                     ¶ adm-disable |¨                Ù                     Ã adm-edit-attribute-list ∏Ë                ¨                     ÿ adm-enable   0                Ã                     ¸
 adm-exit    <l                ¨                      adm-hide    x®                ú                      adm-initialize  ¥‰                ú                      adm-show-errors Ù$         D	   \                  X2 adm-UIB-mode    4d            
    ú                     B adm-view    t§                ú                     O dispatch    ∞‡p        Ë                       ¸ p get-attribute   Ïp        ‘    Ï                   Ë Ö get-attribute-list  ,\p           0                  ,ü new-state   p†p        ‘    Ï                   Ë ∫	 notify  ¨‹p        ¯                      Õ set-attribute-list  ‰p       	 ‘    Ï                   Ë ‘ set-position    (Xp       
 ®   ¿                  º Ã/ ª∞   ∏            3 ˇˇP   ƒ        3 ˇˇpT	 øî                   adm-change-page hË                ú                     ? delete-page ¯(p        ƒ    ‹                   ÿ W init-object 4dp        |   ò                  îá init-pages  p†p        ƒ    ‹                   ÿ ü
 select-page ¨‹p        ƒ    ‹                   ÿ ™ view-page   Ë	p        ƒ    ‹                   ÿ ∂	 `
g vd	       ]Ï0
  T]Ì0
  `          ‰	    ƒ	¥	  ˇÄ            w|‘	      ‰by  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ       {	¯	    4 ˇˇl  O{ˇˇˇˇÄË|    ˇˇ                ˇˇˇˇ                      |	            
              g         Xg Ép
       ]6(   ê          ‰
    ƒ
¥
  ˇÄ            Ñâ‘
      tcy  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    
áú}    OàˇˇˇˇÄË∞    ˇˇ                ˇˇˇˇ                      |
                           g            ùd§    4 ˇˇƒ                  ˇÄ             ù¿       ‡¸ù   ùl‘@               ¸@        Ï      @               Ä ﬂ±  $ û¨ˇˇˇ        g §       ]n‰  }            à    hX  ˇÄ            •  x      H˝ù  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      /•†   ®D          3 ˇˇ,   ¥        3 ˇˇL  ˇˇ                ˇˇˇˇ                                   º              g         H/ ß,   4            3 ˇˇ`   @        3 ˇˇx   ØTî    4 ˇˇî        ‘          ˇÄ             Øæ       ÿÛÜ   Ø\        ¸    Ï‹  ˇÄ            ≥º       DÙÜ   ≥ú  O ≥  ÄË      O ≥  ÄË    0/ ∑               3 ˇˇ®   (        3 ˇˇ¿`$ ∏Dˇˇˇ        ÿ               Ä ﬂ±     ∫lt    4 ˇˇ  k ªÑ        }  Ùn    ˇ   adm-create-objects  $	î         ¸                      adm-row-available   ®ÿ         L   l                  hP disable_UI  Ï                ®                     b
 enable_UI   (X                ê                     m	 local-exit  dî                 Ñ                     w
 send-records    †–            !    h                     Ç state-changed   ‡p        ê "   ®                   § ú   ˝ Á   ˝˝˝˝˝˝˝˝˝˝˝ ˝NO-LOCK         ù    }    ƒò        ù     }    §Gò s  %              ò w  %       	 %        %        %       	 %        %       	 %               %               %               %              %              %              %               %              
ü    
"   
OT ù     x  ò Ä  ò å            ù     }    §Gò s  ƒ 
"   
OT
"   
±  ù      ‡  «%              
"   
3å%     get-attribute   
"    
   %      TYPE        √  ò @
 %      adm/objects/broker.p pã
"    
   %     set-broker-owner QT
"    
   
ü    ù     }    ‚G Ù    ¸     Ï     ‹     Ã     º     h L    X     H     8     (              ò K ò S ò ` ò h ò m ò m ò m ((       
"   
éì
%   
           ò o       
"   
Vïò m ò p ò m ò m ò Ö (T  ê   ,       ù     }    ‚Gò o      ù     }    ‚G%              ò ë  T 4    D      4   ò î T   %              ù     }    ‚Gò î ò î T   %              ù     }    ‚Gò î %     broker-apply-entry 
"    
   
ü    %     broker-destroy  
"    
   
ü    %     dispatch pã%     disable-fields %     set-attribute-list % 
    ENABLED=no %               %      adm/support/contnrd.w ã
ü    %               % 	    enable_UI ã
ü    %     set-attribute-list %     ENABLED=yes %               %      notify  %      exit    %               %     broker-hide 
"    
   
ü    %     broker-initialize T
"    
   
ü        %              %                   "      %                  "      ù     }    íù    }    ì"      %               %     broker-UIB-mode 
"    
   
ü    %     broker-view 
"    
   
ü    %     broker-dispatch 
"    
   
ü    "          √  ò f	 % 	    ADM-ERROR T%      broker-get-attribute pã
"    
   
ü    "      √  %$     broker-get-attribute-list ã
"    
   
ü    o%   o           "     %               %     broker-new-state QT
"    
   
ü    "      %               %     broker-notify   
"    
   
ü    "          √  ò f	 % 	    ADM-ERROR T%               %$     broker-set-attribute-list ã
"    
   
ü    " 	     %               ƒ 
"   
QT
"   
2å    ù      x
   ò ˛     " 
  2å%               
"   
   (        ù     }    Äù      Ã
  Ä%                  " 
  2å%               
"   
   (        ù     }    Äù      D  Ä%              
"   
2å    ù      î   ò 
 
"   
±  
ù      ¿  Ç     " 
  2å%               
"   
3å
" 
  
QTD    (        ù     }    Äù        Ä%              ù            " 
  2å%               
"   
3å
" 
  
QTD    (        ù     }    Äù      †  Ä%              ù      ¨  ( (       " 
     %                   " 
     %              %              ( (       " 
     %                   " 
     %              %              
"   
˝Zù      Ï  " 
   Ï
"   
˝Zù        " 
   %               %     set-attribute-list      ò !      
"   
pã%               %     broker-change-page 
"    
   
ü    %     broker-delete-page 
"    
   
ü    "      %     broker-init-object 
"    
   
ü    "      
"   
   "      
"   
   %               %     broker-init-pages T
"    
   
ü    "      %     broker-select-page 
"    
   
ü    "      %     broker-view-page PT
"    
   
ü    "      
"   
OT
"   
OTù     }    Œ%               
"   
OT%      CLOSE   %               ƒ 
"   
PT
"   
ˇZ
"   
¸Zù      ‡  %%              
ù     }    “
"   
  %     dispatch pã
ü    %      destroy %     dispatch pã%     create-objects  ù     }    Œ%     dispatch pã% 
    initialize ù    }    ƒò     ù     }    Œ%     get-attribute   
ü    %     Current-Page pã √  "      %               %     init-object 
ü    %      adm/objects/folder.w 3å
ù         ¶G          ò ) ò : ò W) 
"   
  %     set-position    
"   
   %            %            %     set-size pã
"   
   %         %        %     add-link pã
"    
   
"   
   %      Page    
ü    %              %     init-object 
ü    %     PLN/V-PERS1.W ã
ù         ¶G% 	    Layout =  1.
"   
   %     set-position    
"   
   %         %       	  %     init-object 
ü    %     PLN/Q-PERS.W pã
ù         ¶G%               
"  
 
   %     set-position    
"  
 
   %       	 %       	  %     init-object 
ü    %      adm/objects/p-navico.r 
ù         ¶G%| q l   Edge-Pixels = 2,                     SmartPanelType = NAV-ICON,                     Right-to-Left = First-On-Left   
"   
   %     set-position    
"   
   %        %         %     set-size pã
"   
   %         %         %     init-object 
ü    %$     adm-vm/objects/p-updv07.w ì
ù         ¶G%t j d   Edge-Pixels = 2,                     SmartPanelType = Update,                     AddFunction = One-Record 
"  	 
   %     set-position    
"  	 
   %        %           %     set-size pã
"  	 
   %         %       	 %     add-link pã
"    
   
"  	 
   %      TableIO 
"   
   %     add-link pã
"    
   
"  
 
   %      Record  
"   
   %     add-link pã
"    
   
"   
   % 
    Navigation 
"  
 
   %              %     init-object 
ü    %     PLN/B-TITU.W pã
ù         ¶G% 	    Layout =  .W
"   
   %     set-position    
"   
   %         %        %     init-object 
ü    %      adm/objects/p-updsav.r 
ù         ¶G%t j d   Edge-Pixels = 2,                     SmartPanelType = Update,                     AddFunction = One-Record 
"   
   %     set-position    
"   
   %         %       	 %     set-size pã
"   
   %       	   %         %     add-link pã
"    
   
"   
   %      TableIO 
"   
   %              %     init-object 
ü    %     PLN/B-PROF.W pã
ù         ¶G% 	    Layout =  .W
"   
   %     set-position    
"   
   %          %        %     init-object 
ü    %      adm/objects/p-updsav.r 
ù         ¶G%t j d   Edge-Pixels = 2,                     SmartPanelType = Update,                     AddFunction = One-Record 
"   
   %     set-position    
"   
   %          %           %     set-size pã
"   
   %         %         %     add-link pã
"    
   
"   
   %      TableIO 
"   
       "   2å%               %     select-page 
ü    %              %     check-modified  
ü    %      check   "      %               %     get-attribute   %     FIELDS-ENABLED (       √  ò ∞ %              %               %     get-link-handle 
"    
   
ü    %     RECORD-SOURCE ã"          "   2åò o  %               
’( T    %              "   ˝Z    ä     "      %              ò ¬ ù     }    ¬Aò ‘( %      
       ò ˝ 
"   
   ù      ‘   ¬Aò 
 %     get-attribute   %     Key-Name PT√      "  
 2å%              %     send-key pã
"   
   "  
    "      %     set-attribute-list ó  ˇˇò $ "   -liƒ 
"   
PT%     dispatch pã
ü    %     display-fields %      notify  
ü    %     row-available ã         ù     }    §Gò s  ƒ 
"   
OT
"   
   ù     }    Œ
ü    
"   
   
"   
   %      CLOSE   %                         h     H 8   ˇÄ            ≤ºX       ºTv  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      /	∫Ä    à           3 ˇˇË   î         3 ˇˇ  ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            Û¸X       ,\´  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      /	˙Ä    à 8          3 ˇˇ   î         3 ˇˇD  ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            X       §\´  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    | i    ˇ         ∞ / î    ú             3 ˇˇL   ®         3 ˇˇd‰ / »    –             3 ˇˇÄ   ‹         3 ˇˇ†  O ˇˇ  ÄË∏    ˇˇ                  ˇˇ    l           ˇˇˇˇ                          h     H 8   ˇÄ            ,X       d]´  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    ú / &Ä    à             3 ˇˇÃ   î         3 ˇˇ  O +ˇˇ  ÄË¯    ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            6JX       ‰Jà  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    à /	CÄ      $          3 ˇˇº / G†    ®             3 ˇˇ,   ¥         3 ˇˇL  O Iˇˇ  ÄËd    ˇˇ                  ˇˇ    l           ˇˇˇˇ                          h     H 8   ˇÄ            TbX       dKà  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    ú / _Ä    à             3 ˇˇx   î         3 ˇˇå  O aˇˇ  ÄË†    ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            luX       Là  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      /	sÄ    à Ã          3 ˇˇ¥   î         3 ˇˇÿ  ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            âX       Ãx  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      /	áÄ    à            3 ˇˇ‡   î         3 ˇˇ  ˇˇ                ˇˇˇˇ                          †     H 8   ˇÄ            ì§X      $x  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      ®   ÿ           ˇÄ      0       û†       ∞GÜ4 ûh   $ ûº ˇˇˇ                       Ä ﬂ±  $ ûÏ ˇˇˇ        D               Ä ﬂ±    4 ˇˇl  	 ü,                      3 ˇˇê  O ¢ˇˇ  ÄË¨    > ˇˇ T              ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            Æ∑X        HÜ  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      /	µÄ    à ‹          3 ˇˇ¿   î         3 ˇˇË  ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            ¡ X       åJÜ  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      /	»Ä    à           3 ˇˇ   î         3 ˇˇ  ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            ‘ËX       $KÜ  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    X        h    ƒ /	‰î    ú 8          3 ˇˇ∞  ®         3 ˇˇD   º         3 ˇˇL   Ê– ÿ     4 ˇˇX  O Êˇˇ  ÄËl    > ˇˇ ¯               ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            ÚˇX       8qç  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    y        h    ƒ /	˚î    ú ®          3 ˇˇÑ∞  ®         3 ˇˇ¥   º         3 ˇˇº  O ˛ˇˇ  ÄË»    > ˇˇ ‰               ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            	 X       @∂ó  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    ì        h    /	î    ú Ù          3 ˇˇÃ∞  ®         3 ˇˇ 	ƒ  º         3 ˇˇ	   – ÿ       3 ˇˇ	  $ Ï ˇˇˇ                          Ä ﬂ±    O ˇˇ  ÄË(	    > ˇˇ (              ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            *8X       x=ï  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    ≤        h    ƒ /	5î    ú \	          3 ˇˇ<	∞  ®         3 ˇˇh	   º         3 ˇˇp	  O 7ˇˇ  ÄË|	    > ˇˇ ‰               ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            BQX       ‡ñä  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    ƒ        h    ƒ /	Lî    ú ¨	          3 ˇˇê	∞  ®         3 ˇˇ∏	   º         3 ˇˇ¿	Ë  M– ÿ     4 ˇˇÃ	  O Nˇˇ  ÄË‡	    O Pˇˇ  ÄË¯	    > ˇˇ               ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            [lX       Úá  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    ì 	       h    ƒ /	hî    ú 4
          3 ˇˇ
∞  ®         3 ˇˇ@
   º         3 ˇˇH
  O kˇˇ  ÄËT
    > ˇˇ	 ‰          	     ˇˇ                ˇˇˇˇ                          ê     H 8   ˇÄ            v¶X      T{  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    Á 
  Ñ    h    Ì 
       |    ò Äú ‹     4 ˇˇh
        ‰           ˇÄ             Å£       ¥©é   Å§ Ã à 0¿  4 ˇˇÑ
        8          ˇÄ             âé       "Ç   â¯ | äDL    4 ˇˇ§
  $ ä`ˇˇˇ        ÿ
    
           Ä ﬂ±     åàê    4 ˇˇ  $ å§ˇˇˇ        P    
           Ä ﬂ±     ëÃ    4 ˇˇ†                  ˇÄ             íö       †"Ç   í‘D$ ì(ˇˇˇ        Ã   
 
           Ä ﬂ±  à îPX    4 ˇˇ‹  $ îlˇˇˇ            
           Ä ﬂ±     óîú    4 ˇˇx  $ ó∞ˇˇˇ        ∏    
           Ä ﬂ±   ùÿ‡    4 ˇˇ  $ ùÙˇˇˇ        l    
           Ä ﬂ±  Ñ û$    4 ˇˇÄ  $ û8ˇˇˇ        ÿ    
           Ä ﬂ±  @        ¯     0@                Ä ﬂ±    $ °Tˇˇˇ          O §ˇˇ  ÄË<    > ˇˇ
 ∏        ˝
     ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ             ◊X       ∏#Ç  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      /	’Ä    à »          3 ˇˇ®   î         3 ˇˇ‘  ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            ·ÌX       P$Ç  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    O        h      /Íî    ú ¸          3 ˇˇ‹∞  ®         3 ˇˇ   º         3 ˇˇ  > ˇˇ ‘               ˇˇ                ˇˇˇˇ                          ∏     H 8   ˇÄ            ˜	X       xÖ  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    c   Ñ    h    o   
ò    | 
   ì   ¨    ê    |   
     § 
   l/	–    ÿ <          3 ˇˇÏ  ‰         3 ˇˇH  ¯         3 ˇˇP         3 ˇˇ\(          3 ˇˇh   4<      3 ˇˇt  $ Pˇˇˇ              
            Ä ﬂ±    O ˇˇ  ÄËÄ    > ˇˇ å       ˝ ˝        ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            +X       ‹ á  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    ì        h      /	(î    ú ¥          3 ˇˇî∞  ®         3 ˇˇ¿   º         3 ˇˇ»  > ˇˇ ‘               ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            5DX       Hú  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    O        h      /	Aî    ú Ù          3 ˇˇ‘∞  ®         3 ˇˇ    º         3 ˇˇ  > ˇˇ ‘               ˇˇ                ˇˇˇˇ                          |     H 8   ˇÄ            N`X       √Ç  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    O        h      /]î    ú 4          3 ˇˇ∞  ®         3 ˇˇ@   º         3 ˇˇH  > ˇˇ ‘               ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            ÀJX      ıÜ  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    ∏ /”Ä    à            3 ˇˇ   î         3 ˇˇ(D               Ä ﬂ±  Ã $ ‘ú ˇˇˇ        ¥p ÷L‹   E  ∞ X        $          ˇÄ             ÿÂ       t)Ü   ÿ‰ ƒ/Ÿ<   DÑ          3 ˇˇlX P        3 ˇˇål d        3 ˇˇ∞Ä x        3 ˇˇ¿   åî      3 ˇˇË  $ Ÿ®ˇˇˇ              
            Ä ﬂ±  /	ﬂ‹   ‰          3 ˇˇÙ¯         3 ˇˇ           3 ˇˇ0T/	‡$   ,\          3 ˇˇD@ 8        3 ˇˇh   L        3 ˇˇ|  /„l   t®          3 ˇˇêà Ä        3 ˇˇ¥ú î        3 ˇˇ¿   ®        3 ˇˇ‘< ‹        ¯          ˇÄ             Á       *Ü   Á∏ò/Ë             3 ˇˇ, $        3 ˇˇ@ 8        3 ˇˇ,T L        3 ˇˇ<   `h      3 ˇˇT  $ Ë|ˇˇˇ              
            Ä ﬂ±  ‡/	Ì∞   ∏|          3 ˇˇ`Ã ƒ        3 ˇˇà   ÿ        3 ˇˇúÄ/¯    »          3 ˇˇ∞         3 ˇˇ–(          3 ˇˇÏ< 4        3 ˇˇ¸   HP      3 ˇˇ  $ dˇˇˇ              
  
     
     Ä ﬂ±  »/	ıò   †8          3 ˇˇ¥ ¨        3 ˇˇD   ¿        3 ˇˇXh/¯‡   ËÑ          3 ˇˇl¸ Ù        3 ˇˇå         3 ˇˇ∞$         3 ˇˇ¿   08      3 ˇˇ@  $ ¯Lˇˇˇ              
            Ä ﬂ±  ∞/	ˇÄ   àh          3 ˇˇLú î        3 ˇˇt   ®        3 ˇˇà¯/	 »   –¥          3 ˇˇú‰ ‹        3 ˇˇ¿           3 ˇˇ‘ò/              3 ˇˇË, $        3 ˇˇ@ 8        3 ˇˇ0T L        3 ˇˇ@   `h      3 ˇˇ∏  $ |ˇˇˇ              
  	     	     Ä ﬂ±  ‡/		∞   ∏‡          3 ˇˇƒÃ ƒ        3 ˇˇÏ   ÿ        3 ˇˇ (/	
¯    ,          3 ˇˇ         3 ˇˇ8            3 ˇˇLÑ/@   Hx          3 ˇˇ`\ T        3 ˇˇÑp h        3 ˇˇê   |        3 ˇˇ§‡/ú   §»          3 ˇˇ∞∏ ∞        3 ˇˇ‘Ã ƒ        3 ˇˇ‡   ÿ        3 ˇˇÙ  /¯              3 ˇˇ          3 ˇˇ$(          3 ˇˇ0   4        3 ˇˇH¯
| T        Ñ          ˇÄ             +       ‹*Ü   D$	/ú   §Ä          3 ˇˇh∏ ∞        3 ˇˇàÃ ƒ        3 ˇˇ§‡ ÿ        3 ˇˇ¥   ÏÙ      3 ˇˇÃ  $ 	ˇˇˇ              
            Ä ﬂ±  l	/	<	   D	Ù          3 ˇˇÿX	 P	        3 ˇˇ    d	        3 ˇˇ
/Ñ	   å	@          3 ˇˇ(†	 ò	        3 ˇˇH¥	 ¨	        3 ˇˇl»	 ¿	        3 ˇˇ|   ‘	‹	      3 ˇˇÙ  $ 	ˇˇˇ              
            Ä ﬂ±  T
/	%$
   ,
          3 ˇˇ @
 8
        3 ˇˇ(   L
        3 ˇˇ<ú
/	&l
   t
h          3 ˇˇPà
 Ä
        3 ˇˇt   î
        3 ˇˇà  /)¥
   º
¥          3 ˇˇú–
 »
        3 ˇˇ¿‰
 ‹
        3 ˇˇÃ   
        3 ˇˇ‡  8 Ï        @          ˇÄ             -C       t+Ü   - ‡/.X   `          3 ˇˇ t l        3 ˇˇ à Ä        3 ˇˇ<ú î        3 ˇˇL   ®∞      3 ˇˇd  $ .ƒˇˇˇ              
            Ä ﬂ±  (/	3¯    å          3 ˇˇp         3 ˇˇò            3 ˇˇ¨»/6@   Hÿ          3 ˇˇ¿\ T        3 ˇˇ‡p h        3 ˇˇÑ |        3 ˇˇ   êò      3 ˇˇå  $ 6¨ˇˇˇ              
            Ä ﬂ±  /	=‡   Ë¥          3 ˇˇò¸ Ù        3 ˇˇ¿           3 ˇˇ‘X/	>(   0           3 ˇˇËD <        3 ˇˇ   P        3 ˇˇ   /Ap   xL          3 ˇˇ4å Ñ        3 ˇˇX† ò        3 ˇˇd   ¨        3 ˇˇx   G¿»    4 ˇˇÑ  /H‡   Ëƒ          3 ˇˇ¨   Ù        3 ˇˇÃ  > ˇˇ               ˇˇ                  ˇˇ    l           ˇˇˇˇ                          h     H 8   ˇÄ            QòX      ∞9ì  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    ú /	iÄ    à ¸          3 ˇˇ‡   î         3 ˇˇ¿  n® ∞     4 ˇˇ  O nˇˇ  ÄË$  Ù / pÿ    ‡             3 ˇˇ8   Ï         3 ˇˇT$$ qˇˇˇ        p               Ä ﬂ±  ∞/	s<   D–          3 ˇˇ¥X P        3 ˇˇ‹l d        3 ˇˇ‰   xÄ      3 ˇˇ    $ sîˇˇˇ                          Ä ﬂ±   uºƒ    4 ˇˇ   O vˇˇ  ÄË(   <    
            Ä ﬂ±  $ w‘ˇˇˇ        l x    4 ˇˇh   	y4                  <3 ˇˇò D3 ˇˇ† L3 ˇˇ∞ T3 ˇˇ∏ \3 ˇˇÃ d3 ˇˇ‡   3 ˇˇ †/ Ñ   å            3 ˇˇ¯    ò        3 ˇˇ!–$ Ä¥ˇˇˇ        ,!     
     
     Ä ﬂ±  – Å‹    4 ˇˇ0!        $          ˇÄ             ÅÑ       Ä±W   Å‰ú/Ç<   Dp!          3 ˇˇX!X P        3 ˇˇ|!   dl      3 ˇˇà!  $ ÇÄˇˇˇ                          Ä ﬂ±    / É¥   º            3 ˇˇî!   »        3 ˇˇ¥! ã‹‰    4 ˇˇ–!  /å¸   ¯!          3 ˇˇ‡!           3 ˇˇ "  /î0   80"          3 ˇˇ"   D        3 ˇˇ8"  > ˇˇ \         ˝  ˝ ˝˝      ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            ü¨X       Ä≤W  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    å  ©t |     4 ˇˇT"  n ™ à    å"   ´ò †     4 ˇˇò"  Ä ´®"  ˇˇ                ˇˇˇˇ                          h     H 8   ˇÄ            ≥¿X       H≥W  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    | 
 Ωˇˇ x ∞"      
 øˇˇ å      º"  ˇˇ                  ˇˇ    l           ˇˇˇˇ                          h     H 8   ˇÄ            «—X       ‡∏ó  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    t Õ»"}    O œˇˇ  ÄË‹"    ˇˇ                ˇˇˇˇ                                H 8   ˇÄ            ÿ„X       Tªó  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ      ˇˇ                ˇˇˇˇ                                H 8   ˇÄ            ÍÚX       ‰ªó  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    è   
Ñ    h 
   ≤        |      > ˇˇ †       ˝       ˇˇ                ˇˇˇˇ                       d d     »     Çà
"ã"  † x                                     l                                              (                                      (                                        TXS ok  W-Win h_B-PROF h_B-TITU h_folder h_p-navico h_p-updsav-2 h_p-updsav-3 h_p-updv07 h_Q-PERS h_V-PERS1 F-Main GUI Personal img\calculo Unable to load icon: img\calculo adm-object-hdl adm-query-opened adm-row-avail-state adm-initial-lock adm-new-record adm-updating-record adm-check-modified-all adm-broker-hdl TYPE ADM-Broker ADM1.1` SmartWindow` WINDOW` NO ` `  Layout,Hide-on-Init` ``````````` ^^ ^ ADM-APPLY-ENTRY ADM-DESTROY disable-fields ENABLED=no ADM-DISABLE ADM-EDIT-ATTRIBUTE-LIST ENABLED=yes ADM-ENABLE exit ADM-EXIT ADM-HIDE ADM-INITIALIZE cntr ADM-SHOW-ERRORS ADM-UIB-MODE ADM-VIEW p-method-name ADM-ERROR DISPATCH p-attr-name GET-ATTRIBUTE p-attr-list GET-ATTRIBUTE-LIST p-state NEW-STATE p-method NOTIFY SET-ATTRIBUTE-LIST p-row p-col parent-hdl WINDOW DIALOG-BOX SET-POSITION CURRENT-PAGE=0,ADM-OBJECT-HANDLE= ADM-CHANGE-PAGE p-page# DELETE-PAGE p-proc-name p-parent-hdl p-proc-hdl INIT-OBJECT p-page-list INIT-PAGES SELECT-PAGE VIEW-PAGE CLOSE OK-WAIT-STATE destroy create-objects initialize adm-current-page Current-Page adm/objects/folder.w FOLDER-LABELS =  Personal|Titulos|Profesiones ,                     FOLDER-TAB-TYPE = 2 Page PLN/V-PERS1.W Layout =  PLN/Q-PERS.W adm/objects/p-navico.r Edge-Pixels = 2,                     SmartPanelType = NAV-ICON,                     Right-to-Left = First-On-Left adm-vm/objects/p-updv07.w Edge-Pixels = 2,                     SmartPanelType = Update,                     AddFunction = One-Record TableIO Record Navigation PLN/B-TITU.W adm/objects/p-updsav.r PLN/B-PROF.W ADM-CREATE-OBJECTS tbl-list rowid-list row-avail-cntr row-avail-rowid row-avail-enabled link-handle record-source-hdl different-row key-name key-value check FIELDS-ENABLED YES RECORD-SOURCE row-available in  encountered more than one RECORD-SOURCE. The first -   - will be used. Key-Name Key-Value="&1" display-fields row-available ADM-ROW-AVAILABLE DISABLE_UI ENABLE_UI LOCAL-EXIT SEND-RECORDS p-issuer-hdl STATE-CHANGED ‰	 Ù        Ä   8           (       adm-apply-entry ∫º `           T       adm-destroy ˙¸< à           |       adm-disable   d ƒ           ¨       adm-edit-attribute-list &+,  î            ‰       adm-enable  CGIJÃ                 adm-exit    _ab  ¯ H          <      adm-hide    su$t          d      adm-initialize  áâ      à     cntr    L∏ 	   x    ®      adm-show-errors ûü†¢§  êÏ 
         ‹      adm-UIB-mode    µ∑ƒ                adm-view    »         (  p-method-name   \        P      dispatch    ‰ÊË          t  p-attr-name 8®      d  ò      get-attribute   ˚˛ˇ          ¿  p-attr-list Ä¯      ∞  ‰      get-attribute-list               p-state Ã<         0      new-state   578          T  p-method    Ä      D  x      notify  LMNPQ    	      ú  p-attr-list `‘      å  ¿      set-attribute-list  hkl    
    Ï  
   parent-hdl  
        p-row     
        p-col   ®P    ‹¯  @      set-position    ÄÅàâäåéëíìîóöùû°£§¶  (†          ê      adm-change-page ’◊        ¥  p-page# x‡      §  ‘      delete-page ÍÌ       Ù  p-proc-name       
  p-parent-hdl    <     0  p-attr-list         L
  p-proc-hdl  º|      ‰  p      init-object 	          î  p-page-list Xƒ      Ñ  ∏      init-pages  (+        ÿ  p-page# †      »  ¯      select-page AD          p-page# ‡D        8      view-page   ]` `                  {|H|                  áàâ  dú                  •        ∞     adm-current-page    Ñ,    †    ‹      adm-create-objects  ”‘÷ÿŸﬂ‡„ÂÁËÌı¯ˇ 	
%&)+-.36=>ACEGHJd    X     tbl-list    Ä    t     rowid-list  †    ê     row-avail-cntr  ¿    ∞     row-avail-rowid ‰    –     row-avail-enabled        Ù     link-handle $      
   record-source-hdl   D   	 4     different-row   `   
 T     key-name          p     key-value   ƒ®    H    î      adm-row-available   inpqsuvwxyÄÅÇÉÑãåîò|Ù          Ë      disable_UI  ©™´¨– 	          	      enable_UI   Ωø¿  ¸L	           @	      local-exit  Õœ—  (	|	 !         l	      send-records    „  †	      ê	
  p-issuer-hdl           ∞	  p-state T	‡	 "     Ä	  –	      state-changed   Ú  ∏	d"   " ¸	            
     
     ok  (
    
  
   W-Win   D
   8
  
   h_B-PROF    `
   T
  
   h_B-TITU    |
   p
  
   h_folder    ò
   å
  
   h_p-navico  ∏
   ®
  
   h_p-updsav-2    ÿ
   »
  
   h_p-updsav-3    Ù
  	 Ë
  
   h_p-updv07    
   
   h_Q-PERS    ,      
   h_V-PERS1   L   <  
   adm-object-hdl  p   \     adm-query-opened    î   Ä     adm-row-avail-state ∏   §     adm-initial-lock    ÿ   »     adm-new-record  ¸   Ë     adm-updating-record $        adm-check-modified-all  D    4  
   adm-broker-hdl       T     OK-WAIT-STATE    ( i j { } ~ ä ã aopqrstyªøvÉùû§ßØ≥∑∏∫ªºæ¿  Hç   #\\INF203\ON_LI_CO\src\adm\template\row-end.i   ®tÎ   #\\INF203\ON_LI_CO\src\adm\template\row-head.i  ‡“#   #\\INF203\ON_LI_CO\src\adm\template\windowmn.i  ◊$   !\\INF203\ON_LI_CO\src\adm\method\containr.i    Pb⁄   !\\INF203\ON_LI_CO\src\adm\method\smart.i   à¬`   !\\INF203\ON_LI_CO\src\adm\method\attribut.i    ºQÂ    D:\SIE_CO\ON_LI_CO\APLIC\PLN\W-PERS.W                                                                                                                                                                                                                                                                       &ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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

DEFINE VARIABLE ok AS LOGICAL.
ok = SESSION:SET-WAIT-STATE("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_B-PROF AS HANDLE NO-UNDO.
DEFINE VARIABLE h_B-TITU AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updsav-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updsav-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv07 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_Q-PERS AS HANDLE NO-UNDO.
DEFINE VARIABLE h_V-PERS1 AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.14 BY 14.19.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Personal"
         HEIGHT             = 14.19
         WIDTH              = 87.14
         MAX-HEIGHT         = 17.73
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17.73
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\calculo":U) THEN
    MESSAGE "Unable to load icon: img\calculo"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Personal */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Personal */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Personal|Titulos|Profesiones' + ',
                     FOLDER-TAB-TYPE = 2':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 14.04 , 86.86 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PLN/V-PERS1.W':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_V-PERS1 ).
       RUN set-position IN h_V-PERS1 ( 2.31 , 2.29 ) NO-ERROR.
       /* Size in UIB:  ( 10.65 , 84.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PLN/Q-PERS.W':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_Q-PERS ).
       RUN set-position IN h_Q-PERS ( 13.19 , 2.29 ) NO-ERROR.
       /* Size in UIB:  ( 1.62 , 14.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 13.23 , 10.43 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.58 , 20.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv07.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv07 ).
       RUN set-position IN h_p-updv07 ( 13.23 , 31.00 ) NO-ERROR.
       RUN set-size IN h_p-updv07 ( 1.58 , 55.29 ) NO-ERROR.

       /* Links to SmartViewer h_V-PERS1. */
       RUN add-link IN adm-broker-hdl ( h_p-updv07 , 'TableIO':U , h_V-PERS1 ).
       RUN add-link IN adm-broker-hdl ( h_Q-PERS , 'Record':U , h_V-PERS1 ).

       /* Links to SmartQuery h_Q-PERS. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_Q-PERS ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'PLN/B-TITU.W':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_B-TITU ).
       RUN set-position IN h_B-TITU ( 3.23 , 11.72 ) NO-ERROR.
       /* Size in UIB:  ( 9.08 , 49.00 ) */

       RUN init-object IN