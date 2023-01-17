'VBA script used to merge sheets together
'Creats a new sheet and begins consolidation
'Puts everything in caps just because I can

Sub ManipulateData()
    ' Declare variables
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim destSheet As Worksheet
    Dim lastRow As Long
    Dim lastCol As Long
    Dim sourceRange As Range
    Dim destRange As Range
    Dim i As Integer
    Dim j As Integer
    Dim fileName As String
    Dim filePath As String
    Dim tempVal As String

    ' Disable screen updating and events
    Application.ScreenUpdating = False
    Application.EnableEvents = False

    ' Create a new worksheet for the consolidated data
    Set destSheet = ActiveWorkbook.Sheets.Add
    destSheet.Name = "Consolidated Data"

    ' Loop through all worksheets in the workbook
    For i = 1 To ActiveWorkbook.Sheets.Count

        ' Skip the newly created worksheet
        If ActiveWorkbook.Sheets(i).Name <> destSheet.Name Then

            ' Set the current worksheet
            Set ws = ActiveWorkbook.Sheets(i)

            ' Find the last row and column with data
            lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
            lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column

            ' Define the range of data to copy
            Set sourceRange = ws.Range("A1:" & ws.Cells(lastRow, lastCol).Address)

            ' Find the next empty row on the destination worksheet
            lastRow = destSheet.Cells(destSheet.Rows.Count, "A").End(xlUp).Row + 1

            ' Define the destination range
            Set destRange = destSheet.Range("A" & lastRow)

            ' Copy the data to the destination worksheet
            sourceRange.Copy destRange

        End If
    Next i

    ' Open additional workbooks to consolidate
    filePath = "C:\data\"
    fileName = Dir(filePath & "*.xlsx")

    Do While fileName <> ""
        Set wb = Workbooks.Open(filePath & fileName)

        For Each ws In wb.Sheets
            lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
            lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column

            Set sourceRange = ws.Range("A1:" & ws.Cells(lastRow, lastCol).Address)

            lastRow = destSheet.Cells(destSheet.Rows.Count, "A").End(xlUp).Row + 1
            Set destRange = destSheet.Range("A" & lastRow)

            sourceRange.Copy destRange
        Next ws

        wb.Close SaveChanges:=False
        fileName = Dir()
    Loop

        ...
    ' Transforming Data
    For i = 2 To destSheet.Cells(destSheet.Rows.Count, "A").End(xlUp).Row
        For j = 1 To destSheet.Cells(1, destSheet.Columns.Count).End(xlToLeft).Column
            tempVal = destSheet.Cells(i, j).Value
            destSheet.Cells(i, j).Value = UCase(tempVal)
        Next j
    Next i

    ' AutoFit the columns
    destSheet.Columns.AutoFit

    ' Enable screen updating and events
    Application.ScreenUpdating = True
    Application.EnableEvents = True

    ' Inform the user that the process is complete
    MsgBox "Data manipulation complete"
End Sub
