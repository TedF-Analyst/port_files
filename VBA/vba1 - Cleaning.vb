' VBA code used to clean a worksheet.
' Removes empty rows, columns, non-numeric chars
' Puts all dates in USA format

Sub CleanData()
    ' Declare variables
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim lastCol As Long
    Dim rng As Range
    Dim c As Range
    Dim i As Integer
    Dim dateFormat As String

    ' Disable screen updating and events
    Application.ScreenUpdating = False
    Application.EnableEvents = False

    ' Set the active worksheet
    Set ws = ActiveSheet

    ' Find the last row and column with data
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column

    ' Define the range to clean
    Set rng = ws.Range("A1:" & ws.Cells(lastRow, lastCol).Address)

    ' Remove empty rows
    ws.Rows.SpecialCells(xlCellTypeBlanks).Delete

    ' Remove empty columns
    For i = lastCol To 1 Step -1
        If ws.Cells(1, i).Value = "" Then
            ws.Columns(i).Delete
        End If
    Next i

    ' Remove non-numeric characters
    For Each c In rng.SpecialCells(xlCellTypeConstants)
        If Not IsNumeric(c) Then c.Value = ""
    Next c

    ' Standardize date formats
    dateFormat = "mm-dd-yyyy"
    For Each c In rng.SpecialCells(xlCellTypeDates)
        c.Value = Format(c.Value, dateFormat)
    Next c

    ' Enable screen updating and events
    Application.ScreenUpdating = True
    Application.EnableEvents = True

    ' Inform the user that the process is complete
    MsgBox "Data cleaning complete"
End Sub
