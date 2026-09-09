/* Rutina de chequeo de base de datos */

/* 1ra. parte 
    Define el valor de -omsize n
    Donde n es el valor que sale de SELECT + 10%
*/    
SELECT COUNT(*) FROM _storageobject.

RUN CheckStatBase.

DEFINE VARIABLE vMinTableID AS INTEGER NO-UNDO.
DEFINE VARIABLE vMaxTableID AS INTEGER NO-UNDO.
DEFINE VARIABLE vMinIndexID AS INTEGER NO-UNDO.
DEFINE VARIABLE vMaxIndexID AS INTEGER NO-UNDO.

/* ------------------------------------------------------------------------- */
PROCEDURE CheckStatBase.

/* Check vMaxTableID: */
FOR LAST DICTDB._TableStat NO-LOCK.
    FOR EACH DICTDB._File NO-LOCK
        WHERE DICTDB._File._File-Number LT 32768 /* exclude SQL92 tables */
        BY DICTDB._File._File-Number DESCENDING:

ASSIGN vMaxTableID = MIN(DICTDB._TableStat._TableStat-id,
                                DICTDB._File._File-Number).

IF DICTDB._TableStat._TableStat-id LT DICTDB._File._File-Number  THEN
    MESSAGE
    "Statistics for tables with numbers higher than"
    DICTDB._TableStat._TableStat-id SKIP
    "will be missed."
    "To get full statistics start a database with" SKIP
    "-tablerangesize"
      ( DICTDB._File._File-Number
      - DICTDB._TableStat._TableStat-ID
      + INTEGER(RECID(DICTDB._TableStat))
      ) VIEW-AS ALERT-BOX WARNING BUTTONS OK.

        ELSE MESSAGE
            "CURRENT -tablerangesize SET TO:" DICTDB._TableStat._TableStat-id  SKIP
            "Which IS sufficient FOR CURRENT SCHEMA Tables: " vMaxTableID
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
        LEAVE.
    END. /* FOR EACH _File */
END. /* FOR LAST _TableStat */


/* Check vMinTableID: */
FOR FIRST DICTDB._TableStat NO-LOCK.
    FOR EACH DICTDB._File NO-LOCK
        WHERE DICTDB._File._File-Number GT 0
        BY DICTDB._File._File-Number /* ASCENDING */:

        ASSIGN vMinTableID = MAX(DICTDB._TableStat._TableStat-id,
                               DICTDB._File._File-Number).

        IF DICTDB._TableStat._TableStat-id GT DICTDB._File._File-Number  THEN
            MESSAGE
            "Statistics for tables with numbers lower than"
            DICTDB._TableStat._TableStat-id SKIP
            "will be missed."
            "To get full statistics start a database with" SKIP
            "-basetable" DICTDB._File._File-Number
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.

                ELSE MESSAGE
                    "-basetable = " vMinTableID " which IS sufficient FOR CURRENT SCHEMA"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            LEAVE.
    END. /* FOR EACH _File */
END. /* FOR FIRST _TableStat */


/* Check vMaxIndexID: */
FOR LAST DICTDB._IndexStat NO-LOCK.
    FOR EACH DICTDB._Index NO-LOCK
        BY DICTDB._Index._Idx-num DESCENDING:

        ASSIGN vMaxIndexID = MIN(DICTDB._IndexStat._IndexStat-id,
                         DICTDB._Index._Idx-num).

        IF DICTDB._IndexStat._IndexStat-id LT DICTDB._Index._Idx-num  THEN
            MESSAGE
            "Statistics for indices with numbers higher than"
            DICTDB._IndexStat._IndexStat-id SKIP
            "will be missed."
            "To get full statistics start a database with" SKIP
            "-indexrangesize"
            ( DICTDB._Index._Idx-num
              - DICTDB._IndexStat._IndexStat-id  /*-baseindex = _IndexStat-id - recid*/
              + INTEGER(RECID(DICTDB._IndexStat))
              ) VIEW-AS ALERT-BOX WARNING BUTTONS OK.

                ELSE MESSAGE
            "CURRENT -indexrangesize SET TO:" DICTDB._IndexStat._IndexStat-id  SKIP
            "Which IS sufficient FOR CURRENT SCHEMA Indexes: " vMaxIndexID
             VIEW-AS ALERT-BOX INFO BUTTONS OK.

                LEAVE.
    END. /* FOR EACH _Index */
END. /* FOR LAST _IndexStat */

/* Check vMinIndexID: */
FOR FIRST DICTDB._IndexStat NO-LOCK.
    FOR EACH DICTDB._Index NO-LOCK
        WHERE DICTDB._Index._Idx-num GT 0
        BY DICTDB._Index._Idx-num /* ASCENDING */:

        ASSIGN vMinIndexID = MAX(DICTDB._IndexStat._IndexStat-id,
                                 DICTDB._Index._Idx-num).

        IF DICTDB._IndexStat._IndexStat-id GT DICTDB._Index._Idx-num  THEN
            MESSAGE
            "Statistics for indices with numbers lower than"
            DICTDB._IndexStat._IndexStat-id SKIP
            "will be missed."
            "To get full statistics start a database with" SKIP
            "-baseindex" DICTDB._Index._Idx-num
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.

                ELSE MESSAGE
                    "-baseindex = " vMinIndexID " which IS sufficient FOR CURRENT SCHEMA"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        LEAVE.
    END. /* FOR EACH _Index */
END. /* FOR FIRST _IndexStat */

END PROCEDURE. /* CheckStatBase */
