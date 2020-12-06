IDENTIFICATION DIVISION.
PROGRAM-ID. AdventOfCode3.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT input-file ASSIGN TO "input.txt"
    ORGANIZATION IS LINE SEQUENTIAL
    FILE STATUS IS input-file-status.

DATA DIVISION.
FILE SECTION.
FD  input-file.
01  input-record PIC x(31).

WORKING-STORAGE SECTION.
01  input-file-status PIC 99.
    88  input-file-ok VALUE 0.
    88  input-file-eof VALUE 10.
01  line-count PIC 9(5) VALUE 1.
01  x1-1 PIC 9(5) VALUE 1.
01  x3-1 PIC 9(5) VALUE 1.
01  x5-1 PIC 9(5) VALUE 1.
01  x7-1 PIC 9(5) VALUE 1.
01  x1-2 PIC 9(5) VALUE 1.
01  trees1-1 PIC 9(3) VALUE 0.
01  trees3-1 PIC 9(3) VALUE 0.
01  trees5-1 PIC 9(3) VALUE 0.
01  trees7-1 PIC 9(3) VALUE 0.
01  trees1-2 PIC 9(3) VALUE 0.
01  product PIC 9(12) VALUE 0.

PROCEDURE DIVISION.
    OPEN INPUT input-file
    IF NOT input-file-ok
      DISPLAY "File not okay"
      GOBACK
    END-IF

    READ input-file
    PERFORM UNTIL input-file-eof
      IF input-record(x1-1:1) = '#'
        ADD +1 TO trees1-1
      END-IF
      IF input-record(x3-1:1) = '#'
        ADD +1 TO trees3-1
      END-IF
      IF input-record(x5-1:1) = '#'
        ADD +1 TO trees5-1
      END-IF
      IF input-record(x7-1:1) = '#'
        ADD +1 TO trees7-1
      END-IF
      IF input-record(x1-2:1) = '#' AND function mod(line-count, 2) = 1
        ADD +1 TO trees1-2
      END-IF

      ADD +1 TO x1-1
      ADD +3 TO x3-1
      ADD +5 TO x5-1
      ADD +7 TO x7-1
      IF function mod(line-count, 2) = 1
        ADD +1 TO x1-2
      END-IF

      IF x1-1 > 31
        ADD -31 TO x1-1
      END-IF
      IF x3-1 > 31
        ADD -31 TO x3-1
      END-IF
      IF x5-1 > 31
        ADD -31 TO x5-1
      END-IF
      IF x7-1 > 31
        ADD -31 TO x7-1
      END-IF
      IF x1-2 > 31
        ADD -31 TO x1-2
      END-IF
      ADD +1 TO line-count
      READ input-file
    END-PERFORM

    CLOSE input-file
    DISPLAY "1-1: " trees1-1
    DISPLAY "3-1: " trees3-1
    DISPLAY "5-1: " trees5-1
    DISPLAY "7-1: " trees7-1
    DISPLAY "1-2: " trees1-2
    COMPUTE product = trees1-1 * trees3-1 * trees5-1 * trees7-1 * trees1-2
    DISPLAY "Product: " product
    .
