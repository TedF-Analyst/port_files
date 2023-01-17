'VBA code used to create a bar chart
'Creates a chart from the specified range
'Formats the chart

Sub CreateBarChart()
    ' Declare variables
    Dim ws As Worksheet
    Dim dataRange As Range
    Dim chart As Chart
    Dim series As Series
    Dim chartTitle As String
    Dim xAxisTitle As String
    Dim yAxisTitle As String

    ' Disable screen updating and events
    Application.ScreenUpdating = False
    Application.EnableEvents = False

    ' Set the active worksheet
    Set ws = ActiveSheet

    ' Define the data range
    Set dataRange = ws.Range("A1:B6")

    ' Set the chart title, x-axis title and y-axis title
    chartTitle = "Sales by Product"
    xAxisTitle = "Product"
    yAxisTitle = "Sales (in $)"

    ' Add a new chart
    Set chart = ws.Shapes.AddChart2(251, xlBarClustered, dataRange.Left, dataRange.Top, dataRange.Width, dataRange.Height).Chart

    ' Set the chart data
    Set series = chart.SeriesCollection(1)
    series.XValues = ws.Range("A1:A6")
    series.Values = ws.Range("B1:B6")

    ' Set the chart title
    chart.HasTitle = True
    chart.ChartTitle.Text = chartTitle

    ' Set the x-axis title
    chart.Axes(xlCategory, xlPrimary).HasTitle = True
    chart.Axes(xlCategory, xlPrimary).AxisTitle.Text = xAxisTitle

    ' Set the y-axis title
    chart.Axes(xlValue, xlPrimary).HasTitle = True
    chart.Axes(xlValue, xlPrimary).AxisTitle.Text = yAxisTitle

    ' Show data labels
    series.HasDataLabels = True
    series.DataLabels.ShowValue = True

    ' Set the font size of the data labels
    series.DataLabels.Font.Size = 12

    ' Set the font color of the data labels
    series.DataLabels.Font.Color = RGB(255, 0, 0)

    ' Set the chart style
    chart.ChartStyle = 240

    ' Enable screen updating and events
    Application.ScreenUpdating = True
    Application.EnableEvents = True

End Sub
