/* logread/logglob.i */
/* global variable definitions for logread */

/* global handle for utilities */
DEFINE {1} SHARED VARIABLE ghlogutils AS HANDLE NO-UNDO.
/* global sequence number */
DEFINE {1} SHARED VARIABLE giseq AS INTEGER INIT 1  NO-UNDO.
