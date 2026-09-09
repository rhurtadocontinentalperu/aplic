/*--------------------------------------------------------------------------
Program     :   utl/filesys/dir-tools.p

DESCRIPTION:

    Gets a listing of files at the specified directory level
    or for an entire directory tree

    This can also do things to the files / directories including

        * compiling programs and saving r-code

        * copying files and directories (including merging
          multiple directory trees to a given target directory
          path)

        * deleting files, directories, and directory trees

        * show the progress as the program goes along

PARAMETERS:

    Variable                Description
    ----------------------  -----------------------------------------------
    cur-dir-list            A comma-delimited list of directories.

                            For everything but copying, this is list of
                            source directories to get files / directories
                            from.

                            When copying, the first "n-1" entries are the
                            source directories, the last entry is the target
                            directory to copy to.


    cur-file-match-mask     Only get files and directories 
                            which match this mask.

    tt-dir-file             OUTPUT TABLE of all the files found

    cur-flag-list           List of options to control behavior

            Value           Description
            -----------     -------------------------------------
            "dir-level"     (DEFAULT) Get the current directory level.
                            This is the default if dir-tree is not
                            specified

            "dir-tree"      Get the entire directory tree starting
                            at the base dir

            "compile"       Compile all the files which have the file
                            extensions in the {&dir-file-compilable-extensions}
                            &GLOBAL-DEFINE in dir.tt

            "save-r-code"   Save r-code when doing compiles

            "delete"        Delete all files / directories found

            "copy"          Copy all files / directories found to the target
                            base directory

            "verbose"       Tell the user how things are progressing as the
                            files are compiled

            "no-tt"         Don't return any TT records to the calling program

            "files-only"    Only process / return files, no directories.
                            NOTE:   This is automatically disabled when doing
                                    "copy" and  "dir-tree"

            "dirs-only"     Only process / return directories, no files.
                            NOTE:   This is automatically disabled when doing
                                    "compile"

            "compile-only"  Return the directory tree and the names of
                            all compilable files. All non-compilable files
                            are filtered out

	Last change: TSI 12/9/2004 1:03:42 PM
--------------------------------------------------------------------------*/

/****************************************************************************/
/* External Files */

{lib/dir-tools.tt   }

/****************************************************************************/
/* Local Parameters */

DEFINE INPUT PARAMETER cur-dir-list                     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER cur-file-match-mask              AS CHARACTER NO-UNDO.

DEFINE OUTPUT PARAMETER TABLE FOR tt-dir-file.

DEFINE INPUT PARAMETER cur-flag-list                    AS CHARACTER NO-UNDO.

/****************************************************************************/
/* Local Variables */

DEFINE VARIABLE is-dir-level                            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE is-dir-tree                             AS LOGICAL   NO-UNDO.

DEFINE VARIABLE is-files-only                           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE is-dirs-only                            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE is-compile-only                         AS LOGICAL   NO-UNDO.

DEFINE VARIABLE is-compile-files                        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE is-save-rcode                           AS LOGICAL   NO-UNDO.

DEFINE VARIABLE is-verbose                              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE is-no-tt-required                       AS LOGICAL   NO-UNDO.

DEFINE VARIABLE is-del-file                             AS LOGICAL   NO-UNDO.
DEFINE VARIABLE is-copy-file                            AS LOGICAL   NO-UNDO.

DEFINE VARIABLE cur-base-name-status                    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cur-status                              AS CHARACTER NO-UNDO.

DEFINE VARIABLE cur-base-dir-num                        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cur-base-dir-cnt                        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cur-base-dir-start                      AS CHARACTER NO-UNDO.

DEFINE VARIABLE cur-tgt-dir                             AS CHARACTER NO-UNDO.

/****************************************************************************/
/* Frames           */

DEFINE FRAME file-frame

        cur-base-name-status        COLUMN-LABEL "File"     FORMAT "X(40)"
        cur-status                  COLUMN-LABEL "Status"   FORMAT "X(20)"

    WITH DOWN
        CENTERED
        OVERLAY
        TITLE "Directory Status".

/****************************************************************************/
/* Set all the various flags    */

ASSIGN
    is-dir-tree         =   LOOKUP("dir-tree",      cur-flag-list) > 0
    is-dir-level        =   LOOKUP("dir-level",     cur-flag-list) > 0 OR
                            NOT is-dir-tree

    is-compile-files    =   LOOKUP("compile",       cur-flag-list) > 0

    is-save-rcode       =   LOOKUP("save-r-code",   cur-flag-list) > 0

    is-del-file         =   LOOKUP("delete",        cur-flag-list) > 0
    is-copy-file        =   LOOKUP("copy",          cur-flag-list) > 0

    is-verbose          =   LOOKUP("verbose",       cur-flag-list) > 0
    
    is-no-tt-required   =   LOOKUP("no-tt",         cur-flag-list) > 0

    is-files-only       =   LOOKUP("files-only",    cur-flag-list) > 0
    is-dirs-only        =   LOOKUP("dirs-only",     cur-flag-list) > 0
    is-compile-only     =   LOOKUP("compile-only",  cur-flag-list) > 0
    .

/****************************************************************************/
/* And then other conditions    */
/* as well as sanity overrides  */

ASSIGN
    cur-dir-list        =   REPLACE(cur-dir-list, "~\", "/")                /* make sure dir seperators are standard        */


    cur-base-dir-cnt    =   NUM-ENTRIES(cur-dir-list)                       /* Number of base directories                   */
    cur-base-dir-cnt    =   cur-base-dir-cnt - 1    WHEN is-copy-file       /* Last base dir in this case is the target dir */

    cur-tgt-dir         =   ENTRY(  NUM-ENTRIES(cur-dir-list),              /* Target directory when doing a copy           */
                                    cur-dir-list)   WHEN is-copy-file

    cur-tgt-dir         =   RIGHT-TRIM(cur-tgt-dir,         "/")            /* Get rid fo trailing dir seperators           */

    is-files-only       =   is-files-only       AND                         /* Files-only doesn't make sense when copying   */
                            NOT is-copy-file    AND                         /* directory trees from one dir lcn to another  */
                            NOT is-dir-tree

    is-dirs-only        =   is-dirs-only        AND                         /* Dirs-only doesn't make sense when compiling  */
                            NOT is-compile-files

    is-save-rcode       =   is-save-rcode       AND                         /* Doesn't make sense to save r-code when not   */
                            is-compile-files                                /* compiling things                             */
    .

/****************************************************************************/

EMPTY TEMP-TABLE tt-dir-file.

/****************************************************************************/
/* Sanity checks....    */

IF is-dirs-only     AND                     /* This is an empty set         */
   is-files-only    THEN

    LEAVE.

IF cur-base-dir-num = 1 AND                 /* Only one base-dir            */
   is-save-rcode        THEN                /* and we want to save r-code   */

    ASSIGN
        cur-tgt-dir = cur-dir-list          /* then tgt-dir = base-dir      */
        .

/****************************************************************************/
/*                          LOAD THE FILE LIST                              */
/****************************************************************************/

DO cur-base-dir-num = 1 TO cur-base-dir-cnt:

    ASSIGN
        cur-base-dir-start = RIGHT-TRIM(ENTRY(cur-base-dir-num, cur-dir-list), "/")
        .

    IF is-dir-tree          THEN
        RUN load-directory-tree(cur-base-dir-start).

    IF is-dir-level         THEN
        RUN load-directory-files(cur-base-dir-start).

END.

/****************************************************************************/
/*                          POST-PROCESSING                                 */
/****************************************************************************/

/****************************************************************************/
/* Files only                   */

IF is-files-only        THEN
    DO:

    FOR EACH tt-dir-file
        WHERE tt-dir-file.is-directory
        EXCLUSIVE-LOCK:

        DELETE tt-dir-file.

    END.

    END.

/****************************************************************************/
/* Directories only             */

IF is-dirs-only         THEN
    DO:

    FOR EACH tt-dir-file
        WHERE tt-dir-file.is-file
        EXCLUSIVE-LOCK:

        DELETE tt-dir-file.

    END.

    END.

/****************************************************************************/
/* Compilable files only?       */

IF is-compile-only      THEN
    DO:

    FOR EACH tt-dir-file
        WHERE tt-dir-file.is-compilable = NO
        EXCLUSIVE-LOCK:

        IF tt-dir-file.is-file          OR

          (tt-dir-file.is-directory AND
           NOT is-save-rcode)           THEN

            DELETE tt-dir-file.

    END.

    END.

/****************************************************************************/
/* Compile things               */

IF is-compile-files     THEN
    RUN compile-file-list.

/****************************************************************************/
/* Delete files and dirs        */

IF is-del-file          THEN
    RUN delete-file-list.

/****************************************************************************/
/* Copy files and dirs          */

IF is-copy-file         THEN
    RUN copy-file-list.

/****************************************************************************/
/* No TT required on return?    */

IF is-no-tt-required    THEN
    DO:

    EMPTY TEMP-TABLE tt-dir-file.

    LEAVE.
    END.

/****************************************************************************/
/* If we're being chatty        */
/* then hide ourselves          */
    
IF is-verbose           THEN
    HIDE FRAME file-frame NO-PAUSE.

/****************************************************************************/
PROCEDURE load-directory-tree:
/****************************************************************************/
/* Load an entire directory tree                                            */
/****************************************************************************/
/* Local Parameters */

DEFINE INPUT PARAMETER cur-base-dir                     AS CHARACTER NO-UNDO.   /* Initial directory    */

/****************************************************************************/
/* Local Variables */

DEFINE VARIABLE is-dir-loaded                           AS LOGICAL   NO-UNDO.

/****************************************************************************/
/* Local Buffers */

DEFINE BUFFER tt-dir-file-buf       FOR tt-dir-file.

/****************************************************************************/

RUN load-directory-files(cur-base-dir).

REPEAT:

    ASSIGN
        is-dir-loaded = NO
        .

    FOR EACH tt-dir-file-buf
        WHERE tt-dir-file-buf.is-dir-processed = NO

        EXCLUSIVE-LOCK:

        RUN load-directory-files(tt-dir-file-buf.absolute-file-path).

        ASSIGN
            tt-dir-file-buf.is-dir-processed    = YES   /* This directory's been processed  */
            is-dir-loaded                   = YES       /* And we loaded something          */
            .

    END.

    IF NOT is-dir-loaded THEN                           /* Nothing loaded?                  */
        LEAVE.                                          /* Then get out                     */

END.

END PROCEDURE.

/****************************************************************************/
PROCEDURE load-directory-files.
/****************************************************************************/
/* Get a list of all files and directories in a specified directory         */
/****************************************************************************/
/* Local Parameters */

DEFINE INPUT PARAMETER cur-dir-path                     AS CHARACTER NO-UNDO.

/****************************************************************************/
/* Local Variables */

DEFINE VARIABLE cur-base-name                           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cur-file-path                           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cur-attr-list                           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cur-base-entry-cnt                      AS INTEGER   NO-UNDO.

/****************************************************************************/
/* Local Buffers */

DEFINE BUFFER tt-dir-file                               FOR tt-dir-file.

/****************************************************************************/
/* Do it */

INPUT FROM OS-DIR(cur-dir-path).        /* Read things from this directory  */

REPEAT:

    IMPORT  cur-base-name
            cur-file-path 
            cur-attr-list
            .

    IF cur-base-name BEGINS "." THEN    /* this is a relative directory     */
        NEXT.                           /* that we don't care about         */

        /* Skip this entry if it doesn't match  */

    IF cur-file-match-mask > ""                             AND     /* There's a mask                                   */
       cur-file-match-mask <> ?                             AND     /* There's a mask                                   */
       NOT (is-dir-tree AND INDEX(cur-attr-list, "d") > 0)  AND     /* this isn't a directory when doing a tree scan    */
       NOT (cur-base-name MATCHES cur-file-match-mask)      THEN    /* and it doesn't match                             */

        NEXT.                                                       /* then skip this entry                             */

    DO TRANSACTION:                     /* Transaction scoping              */

    CREATE tt-dir-file.

    ASSIGN
        cur-base-entry-cnt              =   NUM-ENTRIES(cur-base-name, ".")
        .

    ASSIGN
        tt-dir-file.base-name           =   cur-base-name
        tt-dir-file.file-extension      =   ENTRY(cur-base-entry-cnt, cur-base-name, ".") WHEN cur-base-entry-cnt > 1

        tt-dir-file.absolute-file-path  =   cur-file-path
        tt-dir-file.relative-file-path  =   SUBSTRING(tt-dir-file.absolute-file-path, LENGTH(cur-base-dir-start) + 2)

        tt-dir-file.attr-list           =   cur-attr-list

        tt-dir-file.is-directory        =   INDEX(cur-attr-list, "d") > 0         /* This is a directory  */

        tt-dir-file.is-file             =   INDEX(cur-attr-list, "f") > 0 AND     /* This is a file       */
                                            INDEX(cur-attr-list, "p") = 0         /* which isn't a pipe   */

        tt-dir-file.is-compilable       =   tt-dir-file.is-file AND                                                           /* This is a file       */
                                            LOOKUP(ENTRY(NUM-ENTRIES(tt-dir-file.base-name, "."), tt-dir-file.base-name, "."),    /* and it's compilable  */
                                                   {&dir-file-compilable-extensions}) > 0

        tt-dir-file.is-dir-processed    =   IF tt-dir-file.is-directory
                                                THEN NO
                                                ELSE ?
        .


    END.                                /* Transaction                          */

END.

INPUT CLOSE.                            /* No more directory entries            */

END PROCEDURE.

/****************************************************************************/
PROCEDURE compile-file-list:
/****************************************************************************/
/* Compile all the files we can compile                                     */
/****************************************************************************/

FOR EACH tt-dir-file
    EXCLUSIVE-LOCK
    BY tt-dir-file.relative-file-path:

/****************************************************************************/
/* if we hit a directory when saving r-code     */
/* then make the directory in the tgt dir       */

    IF tt-dir-file.is-directory AND
       is-save-rcode            THEN

        RUN make-directory(BUFFER tt-dir-file).

/****************************************************************************/
/* Compile this?                                */

    IF tt-dir-file.is-compilable THEN
        DO:

        COMPILE VALUE(tt-dir-file.relative-file-path)
            SAVE = is-save-rcode
                INTO VALUE(cur-tgt-dir + "/" + tt-dir-file.relative-file-path)
            NO-ERROR.

        ASSIGN
            tt-dir-file.is-compile-error    = COMPILER:ERROR
            tt-dir-file.is-compile-warning  = COMPILER:WARNING
            .


        ASSIGN
            tt-dir-file.sort-order          = "A"   WHEN tt-dir-file.is-compile-error       OR
                                                         tt-dir-file.is-compile-warning
            .

        RUN show-progress(  tt-dir-file.relative-file-path,

                            STRING(tt-dir-file.is-compile-error,      "Error /      ")      +
                            STRING(tt-dir-file.is-compile-warning,    "Warning /        ")).
        END.

/****************************************************************************/
/* Filter out non-compilable files as required  */


    IF is-compile-only                  AND         /* Only want compilable files   */
       tt-dir-file.is-file              AND         /* this is a file               */
       NOT tt-dir-file.is-compilable    THEN        /* that's not compilable        */

        DELETE tt-dir-file.                         /* Get rid of the record        */

END.

END PROCEDURE.

/****************************************************************************/
PROCEDURE copy-file-list.
/****************************************************************************
PURPOSE:


PARAMETERS:

*****************************************************************************/

OS-CREATE-DIR VALUE(cur-tgt-dir).

/****************************************************************************/

FOR EACH tt-dir-file
    EXCLUSIVE-LOCK
    BY tt-dir-file.relative-file-path:

        /* If this is a directory   */
        /* then make the target     */

    IF tt-dir-file.is-directory     THEN
        RUN make-directory(BUFFER tt-dir-file).

        /* This is a file - copy it */

    IF tt-dir-file.is-file THEN
        DO:

        OS-COPY VALUE(tt-dir-file.absolute-file-path)
                VALUE(cur-tgt-dir + "/" + tt-dir-file.relative-file-path).

        RUN show-progress(tt-dir-file.absolute-file-path, "Copied").

        END.

    ASSIGN
        tt-dir-file.is-copied = YES
        .

END.

END PROCEDURE.

/****************************************************************************/
PROCEDURE delete-file-list.
/****************************************************************************
PURPOSE:


PARAMETERS:

*****************************************************************************/

    /* Delete the files before deleting the directory   */

FOR EACH tt-dir-file
    EXCLUSIVE-LOCK
    BY tt-dir-file.absolute-file-path DESCENDING:

    OS-DELETE VALUE(tt-dir-file.absolute-file-path).

    ASSIGN
        tt-dir-file.is-deleted = YES
        .

    RUN show-progress(tt-dir-file.absolute-file-path, "Deleted").

END.

    /* Delete all the base directories                  */

DO cur-base-dir-num = 1 TO cur-base-dir-cnt:

    OS-DELETE VALUE(ENTRY(cur-base-dir-num, cur-dir-list)).
    RUN show-progress(cur-base-dir-start, "Deleted").

END.

END PROCEDURE.

/****************************************************************************/
PROCEDURE make-directory:
/****************************************************************************
PURPOSE:


PARAMETERS:

*****************************************************************************/
/* Local Parameters */

DEFINE PARAMETER BUFFER tt-dir-file FOR tt-dir-file.

/****************************************************************************/

OS-CREATE-DIR VALUE(cur-tgt-dir + "/" + tt-dir-file.relative-file-path).

RUN show-progress(  cur-tgt-dir + "/" + tt-dir-file.relative-file-path,
                    "Created").

END PROCEDURE.

/****************************************************************************/
PROCEDURE show-progress.
/****************************************************************************
PURPOSE:


PARAMETERS:

*****************************************************************************/
/* Local Parameters */

DEFINE INPUT PARAMETER cur-file-path                    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER cur-status-parm                  AS CHARACTER NO-UNDO.

/****************************************************************************/

PROCESS EVENTS.

IF NOT is-verbose THEN
    LEAVE.

DISPLAY
        cur-file-path   @ cur-base-name-status
        cur-status-parm @ cur-status
    WITH FRAME file-frame.

DOWN
    WITH FRAME file-frame.

END PROCEDURE.

