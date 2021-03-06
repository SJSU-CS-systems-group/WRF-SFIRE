      SUBROUTINE NEWWIN(LUN,IWIN,JWIN)

C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:    NEWWIN
C   PRGMMR: WOOLLEN          ORG: NP20       DATE: 1994-01-06
C
C ABSTRACT: GIVEN AN INDEX WITHIN THE INTERNAL JUMP/LINK TABLE WHICH
C   POINTS TO THE START OF AN "RPC" WINDOW (I.E. ITERATION OF AN 8-BIT
C   OR 16-BIT DELAYED REPLICATION SEQUENCE), THIS SUBROUTINE COMPUTES
C   THE ENDING INDEX OF THE WINDOW.  ALTERNATIVELY, IF THE GIVEN INDEX
C   POINTS TO THE START OF A "SUB" WINDOW (I.E. THE FIRST NODE OF A
C   SUBSET), THE SUBROUTINE RETURNS THE INDEX OF THE LAST NODE.
C
C PROGRAM HISTORY LOG:
C 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C 1998-07-08  J. WOOLLEN -- REPLACED CALL TO CRAY LIBRARY ROUTINE
C                           "ABORT" WITH CALL TO NEW INTERNAL BUFRLIB
C                           ROUTINE "BORT"
C 1999-11-18  J. WOOLLEN -- THE NUMBER OF BUFR FILES WHICH CAN BE
C                           OPENED AT ONE TIME INCREASED FROM 10 TO 32
C                           (NECESSARY IN ORDER TO PROCESS MULTIPLE
C                           BUFR FILES UNDER THE MPI)
C 2002-05-14  J. WOOLLEN -- REMOVED OLD CRAY COMPILER DIRECTIVES
C 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C                           INTERDEPENDENCIES
C 2003-11-04  D. KEYSER  -- MAXJL (MAXIMUM NUMBER OF JUMP/LINK ENTRIES)
C                           INCREASED FROM 15000 TO 16000 (WAS IN
C                           VERIFICATION VERSION); UNIFIED/PORTABLE FOR
C                           WRF; ADDED DOCUMENTATION (INCLUDING
C                           HISTORY); OUTPUTS MORE COMPLETE DIAGNOSTIC
C                           INFO WHEN ROUTINE TERMINATES ABNORMALLY
C 2009-03-31  J. WOOLLEN -- ADDED DOCUMENTATION
C 2009-05-07  J. ATOR    -- USE LSTJPB INSTEAD OF LSTRPC
C
C USAGE:    CALL NEWWIN (LUN, IWIN, JWIN)
C   INPUT ARGUMENT LIST:
C     LUN      - INTEGER: I/O STREAM INDEX INTO INTERNAL MEMORY ARRAYS
C     IWIN     - INTEGER: STARTING INDEX OF WINDOW ITERATION
C
C   OUTPUT ARGUMENT LIST:
C     JWIN     - INTEGER: ENDING INDEX OF WINDOW ITERATION
C
C REMARKS:
C
C    SEE THE DOCBLOCK IN BUFR ARCHIVE LIBRARY SUBROUTINE GETWIN FOR AN
C    EXPLANATION OF "WINDOWS" WITHIN THE CONTEXT OF A BUFR DATA SUBSET.
C
C    THIS ROUTINE CALLS:        BORT     LSTJPB
C    THIS ROUTINE IS CALLED BY: DRSTPL   UFBRW
C                               Normally not called by any application
C                               programs.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  PORTABLE TO ALL PLATFORMS
C
C$$$

      INCLUDE 'bufrlib.prm'

      COMMON /USRINT/ NVAL(NFILES),INV(MAXSS,NFILES),VAL(MAXSS,NFILES)

      CHARACTER*128 BORT_STR
      REAL*8        VAL

C----------------------------------------------------------------------
C----------------------------------------------------------------------

      IF(IWIN.EQ.1) THEN

C        This is a "SUB" (subset) node, so return JWIN as pointing to
C        the last value of the entire subset. 

         JWIN = NVAL(LUN)
         GOTO 100
      ENDIF

C     Confirm that IWIN points to an RPC node and then compute JWIN.

      NODE = INV(IWIN,LUN)
      IF(LSTJPB(NODE,LUN,'RPC').NE.NODE) GOTO 900
      JWIN = IWIN+VAL(IWIN,LUN)

C  EXITS
C  -----

100   RETURN
900   WRITE(BORT_STR,'("BUFRLIB: NEWWIN - LSTJPB FOR NODE",I6,'//
     . '" (LSTJPB=",I5,") DOES NOT EQUAL VALUE OF NODE, NOT RPC '//
     . '(IWIN =",I8,")")') NODE,LSTJPB(NODE,LUN,'RPC'),IWIN
      CALL BORT(BORT_STR)
      END
