'VBA code used for validation
'Checks for errors, missing values, formatting issues
'Displays errors at the end

Sub ValidateData()
    ' Declare variables
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim lastCol As Long
    Dim rng As Range
    Dim c As Range
    Dim errorCount As Integer
    Dim errorList As String
    Dim errorMessage As String

    ' Disable screen updating and events
    Application.ScreenUpdating = False
    Application.EnableEvents = False

    ' Set the active worksheet
    Set ws = ActiveSheet

    ' Find the last row and column with data
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column

    ' Define the range to validate
    Set rng = ws.Range("A1:" & ws.Cells(lastRow, lastCol).Address)

    ' Initialize error count and error list
    errorCount = 0
    errorList = ""

    ' Check for errors
    For Each c In rng
        If IsError(c) Then
            errorCount = errorCount + 1
            errorList = errorList & c.Address & ", "
        End If
    Next c

    ' Check for missing values
    For Each c In rng
        If c.Value = "" Then
            errorCount = errorCount + 1
            errorList = errorList & c.Address & ", "
        End If
    Next c

    ' Check for formatting issues
    For Each c In rng
        If Not c.NumberFormat = "General" Then
            errorCount = errorCount + 1
            errorList = errorList & c.Address & ", "
        End If
    Next c

    ' Build the error message
    If errorCount > 0 Then
        errorMessage = "Data validation failed with " & errorCount & " errors. " & _
                       "Errors found in cells: " & Left(errorList, Len(errorList) - 2) & "."
    Else
        errorMessage = "Data validation passed with no errors."
    End If

    ' Enable screen updating and events
    Application.ScreenUpdating = True
    Application.EnableEvents = True

    ' Show the error message
    MsgBox errorMessage
End Sub
