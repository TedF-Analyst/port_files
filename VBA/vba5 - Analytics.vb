'VBA code used for some basic analytics
'Performs linear regression using Least Squares
'Use Ctrl+G in VBE to view immediate window & results

Sub LinearRegression()
    ' Declare variables
    Dim ws As Worksheet
    Dim xRange As Range
    Dim yRange As Range
    Dim xVals As Variant
    Dim yVals As Variant
    Dim n As Long
    Dim sumX As Double
    Dim sumY As Double
    Dim sumXX As Double
    Dim sumXY As Double
    Dim slope As Double
    Dim yIntercept As Double
    Dim rSquared As Double

    ' Disable screen updating and events
    Application.ScreenUpdating = False
    Application.EnableEvents = False

    ' Set the active worksheet
    Set ws = ActiveSheet

    ' Define the x-values range
    Set xRange = ws.Range("A1:A6")

    ' Define the y-values range
    Set yRange = ws.Range("B1:B6")

    ' Convert the range values to arrays
    xVals = xRange.Value
    yVals = yRange.Value

    ' Get the number of data points
    n = UBound(xVals)

    ' Initialize the sums
    sumX = 0
    sumY = 0
    sumXX = 0
    sumXY = 0

    ' Calculate the sums
    For i = 1 To n
        sumX = sumX + xVals(i, 1)
        sumY = sumY + yVals(i, 1)
        sumXX = sumXX + xVals(i, 1) ^ 2
        sumXY = sumXY + xVals(i, 1) * yVals(i, 1)
    Next i

    ' Calculate the slope and y-intercept
    slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX ^ 2)
    yIntercept = (sumY - slope * sumX) / n

    ' Calculate the R-Squared
    rSquared = Application.WorksheetFunction.RSq(yRange, xRange)

    ' Print the results
    Debug.Print "Slope: " & slope
    Debug.Print "Y-Intercept: " & yIntercept
    Debug.Print "R-Squared: " & rSquared
    
    ' Enable screen updating and events
    Application.ScreenUpdating = True
    Application.EnableEvents = True

End Sub
