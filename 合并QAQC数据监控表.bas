Attribute VB_Name = "ģ��1"
Sub �ϲ����ܱ�() '������������µĹ��������ζ�Ӧ�ϲ������������µĹ���������һ�Ź������Ӧ�ϲ�����һ�ţ��ڶ��Ŷ�Ӧ�ϲ����ڶ��š���
On Error Resume Next
Dim x As Variant, x1 As Variant, w As Workbook, wsh As Worksheet
Dim t As Workbook, ts As Worksheet, i As Integer, l As Integer, h As Long
Dim rng As Range, rng1 As Range
Dim color, start, xNum   As Integer

Application.ScreenUpdating = False
Application.DisplayAlerts = False
Workbooks.Add
x = Application.GetOpenFilename(FileFilter:="Excel�ļ� (*.xls; *.xlsx),*.xls; *.xlsx,�����ļ�(*.*),*.*", _
       Title:="Excelѡ��", MultiSelect:=True)
Set t = ActiveWorkbook
xNum = 1
For Each x1 In x

                If x1 <> False Then
                     Set w = Workbooks.Open(x1)
                          For i = 1 To w.Sheets.Count
                                If i > t.Sheets.Count Then t.Sheets.Add After:=t.Sheets(t.Sheets.Count)
                                t.Sheets(i).Name = w.Sheets(i).Name
                                 Set ts = t.Sheets(i)
                                 Set wsh = w.Sheets(i)
                                 l = ts.UsedRange.SpecialCells(xlCellTypeLastCell).Column
                                 h = ts.UsedRange.SpecialCells(xlCellTypeLastCell).Row
                                 Debug.Print "   lastrow:   " & h
                                      If xNum = 1 Then
                                                '  If l = 1 And h = 1 And ts.Cells(1, 1) = "" Then
                                                   wsh.Rows("1:" & wsh.Range("g7").End(xlDown).Row).Copy ts.Cells(1, 1)
                                                '   Else
                                                  ' wsh.Rows("1:" & wsh.Range("g7").End(xlDown).Row).Copy ts.Cells(1 + h, 1)
                                                  'End If
                                        Else
                                                 start = 3
                                                 Set rng = ts.Range("a3:a9")
                                                 For Each rng1 In rng
                                                     color = rng1.Interior.ColorIndex
                                                              If color <> -4142 Then
                                                                start = start + 1
                                                                Debug.Print "       loop��" & "book: " & x1 & "sheet:" & i & "   " & "startrow: " & start
                                                              Else
                                                                Exit For
                                                              End If
                                                   Next
                                                  'Debug.Print "�ϲ��ܱ�" & "book: " & x1 & "sheet:" & i & "   " & "startrow: " & start
                                                  wsh.Rows(start & ":" & wsh.Range("g7").End(xlDown).Row).Copy ts.Cells(1 + h, 1)
                                        
                                        End If
                                        
                         Debug.Print "�ϲ��ܱ�" & "book: " & x1 & "sheet:" & i & "   " & "startrow: " & start & Chr(10)
                         Next
                 w.Close
                 xNum = xNum + 1
                End If
Next
t.SaveAs Filename:="D:\�ϲ���.xlsx", FileFormat:= _
xlOpenXMLWorkbook, CreateBackup:=False
    Sheets(1).Select
    Range("I8").Select
    
Application.ScreenUpdating = True
Application.DisplayAlerts = True
MsgBox "�ϲ���ɣ�������D�̣�����Ϊ���ϲ���.xlsx"
End Sub

Sub CLR()
Dim rng, rng1 As Range, start, color As Integer

h = ActiveWorkbook.Sheets(1).[a65536].End(xlUp).Row
                                         Debug.Print h


End Sub
Sub ��ԭ�ձ�()
'
' ��ԭ�ձ� Macro
'

'
Application.ScreenUpdating = False
Application.DisplayAlerts = False

Cells.Clear
    '��յ�ǰ��
Set t = ActiveWorkbook
Max = t.Sheets.Count
Debug.Print Max
 For i = 2 To Max
   t.Sheets(2).Delete
 Next
Range("F8").Select
Application.ScreenUpdating = True
Application.DisplayAlerts = True
End Sub


