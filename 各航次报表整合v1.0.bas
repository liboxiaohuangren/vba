Attribute VB_Name = "�����α�������"
'

Dim rowXiJieTou As Variant
Dim rowXiJieWei

Sub ���α���ȼ���ϱ�������()
'v1.0
' ���ϱ������� Macro
'x = Application.GetOpenFilename(FileFilter:="Excel�ļ� (*.xls; *.xlsx),*.xls; *.xlsx,�����ļ�(*.*),*.*", _
       Title:="Excelѡ��", MultiSelect:=True) 'ѡ��Ҫ���ϲ��Ĳ�

'
Dim str
Dim zsh
Dim x
Dim x1
Dim w
Dim wsh
Dim rowzbwei
Dim i
Dim zb As Variant

Application.ScreenUpdating = 0
Application.DisplayAlerts = 0
Set zb = ActiveWorkbook
Set zsh = ActiveSheet
ChDir "\\192.168.0.223\��������\10�����Ϲ���\���α���\����15\2017��"
x = Application.GetOpenFilename(FileFilter:="Excel�ļ� (*.xls; *.xlsx),*.xls; *.xlsx,�����ļ�(*.*),*.*", _
       Title:="Excelѡ��", MultiSelect:=True) 'ѡ��Ҫ���ϲ��Ĳ�
Dim voy '��¼���κ�
If Not IsArray(x) Then '�������ȡ���ͽ���
    Exit Sub
End If

diyici = True
For Each x1 In x
    If InStr(5, x1, "ȼ") = 0 Then
        MsgBox "���ȼ���ϱ���"
        Exit Sub
    End If

Workbooks.Open (x1)
    Set w = Workbooks.Open(x1)
    Set wsh = w.Sheets("ȼ�ͱ���")
     voy = Mid(w.Name, InStr(11, w.Name, "V") + 1, 4)
    If diyici Then
        wsh.Range("A38:c38").Copy zsh.Cells(1, 2)
        zsh.Cells(3, 1) = voy
        zsh.Range("a1") = Mid(w.Name, 1, InStr(3, w.Name, "ȼ") - 1)
        diyici = False
    End If
    rowzbwei = zsh.Cells(66666, 2).End(xlUp).Row + 1
    If Len(wsh.Range("b40").Text & wsh.Range("c40").Text) = 0 Then '�жϱ����μ�װ��һ���Ƿ��м���
        wsh.Range("A42:C42").Copy zsh.Cells(rowzbwei, 2) 'ֻ���ƺ���ĩ���
    Else
        wsh.Range("A40:C40,A42:C42").Copy zsh.Cells(rowzbwei, 2) '�����μ�װ�ͺ���ĩ���
    End If
    zsh.Cells(rowzbwei, 1) = voy
w.Close
Next x1

Range("b2").Select
ActiveWindow.FreezePanes = True
For i = 2 To Range("b2").End(xlDown).Row
    str = Cells(i, 2).Text
    If InStr(1, str, "�����μ�") Then
        Cells(i, 2) = "+"
    Else
        Cells(i, 2) = "end"
    End If
Next
    Columns("A:A").ColumnWidth = 4
    Columns("B:B").ColumnWidth = 5
    Columns("C:C").ColumnWidth = 5.88
    Columns("D:D").ColumnWidth = 5.88

Application.ScreenUpdating = 1
Application.DisplayAlerts = 1
End Sub
Sub ���α�������()
Dim diyici
Dim rgang '�ۿ�������
Dim str
Dim rng1
Dim rng2
Dim rng3
Dim rtou
Dim zsh
Dim x
Dim x1
Dim w
Dim wsh
Dim rowzbwei
Dim rtouwei
Dim i
Dim zb As Variant
Dim rwei

Application.ScreenUpdating = 0
Application.DisplayAlerts = 0
Set zb = ActiveWorkbook
Set zsh = ActiveSheet
ChDir "\\192.168.0.223\��������\10�����Ϲ���\���α���\"
x = Application.GetOpenFilename(FileFilter:="Excel�ļ� (*.xls; *.xlsx),*.xls; *.xlsx,�����ļ�(*.*),*.*", _
       Title:="ѡ�񺽴α���", MultiSelect:=True) 'ѡ��Ҫ���ϲ��Ĳ�
Dim voy '��¼���κ�
If Not IsArray(x) Then '�������ȡ���ͽ���
    Exit Sub
End If

diyici = True
For Each x1 In x
    If InStr(5, x1, "ȼ") > 0 Then
        MsgBox "��򿪺��α���"
        Exit Sub
    End If
    
    'On Error Resume Next
    Set w = Workbooks.Open(x1)
    Set wsh = w.Sheets("���α���")
    voy = Mid(w.Name, InStr(8, w.Name, "V") + 1, 4)
    If diyici Then
        rgang = wsh.Cells(8, 3).End(xlDown).Row '���벴ʱ������һ��λ��
        rowXiJieTou = zhaotou() 'ϸ�ڵĿ�ͷλ��
        rowXiJieWei = zhaowei() 'ϸ�ڵ����һ��λ��
        Set rng1 = wsh.Range(Cells(6, 1), Cells(rgang, 3)) '���벴ʱ������
        Set rng2 = wsh.Range(Cells(rowXiJieTou, 1), Cells(rowXiJieWei, 3)) '���벴ϸ������
        Set rng3 = wsh.Range(Cells(rowXiJieTou, 5), Cells(rowXiJieWei, 12)) 'ϸ������ԭ��
        Union(rng1, rng2).Copy zsh.Cells(1, 2)
        rng3.Copy zsh.Cells(rgang - 4, 5)
        zsh.Cells(3, 1) = voy
        zsh.Range("a1") = Mid(w.Name, 1, InStr(3, w.Name, "��") - 1) 'a1��д����
        diyici = False
    Else
        rowzbwei = zsh.Cells(66666, 5).End(xlUp).Row + 1
        rowXiJieTou = zhaotou() 'ϸ�ڵĿ�ͷλ��
        rowXiJieWei = zhaowei() 'ϸ�ڵ����һ��λ��
        Set rng1 = wsh.Range(Cells(8, 1), Cells(rgang, 3)) '���벴ʱ������
        Set rng2 = wsh.Range(Cells(rowXiJieTou, 1), Cells(rowXiJieWei, 3))  '���벴ϸ������
        Set rng3 = wsh.Range(Cells(rowXiJieTou, 5), Cells(rowXiJieWei, 12))  'ϸ������ԭ��
        Union(rng1, rng2).Copy zsh.Cells(rowzbwei, 2)
        rng3.Copy zsh.Cells(rowzbwei + rgang - 7, 5)
        zsh.Cells(rowzbwei, 1) = voy
    End If
    'voy = voy + 1
w.Close
Next x1
    zsh.Columns("c:d").NumberFormatLocal = "ddmmyyhhmm"
   

Application.ScreenUpdating = 1
Application.DisplayAlerts = 1
End Sub
Function zhaotou()
Dim gezi
For Each gezi In Range("a25:a55") '�ҵ���ͷ��λ��
    If gezi = "����װж��ʱ�䡢��������ê�ȴ���������ҵ׼��ʱ�䣩" Then
        zhaotou = gezi.Row + 1
        
        'Debug.Print gezi.Row
        Exit Function
    End If
Next gezi
End Function
Function zhaowei()
Dim cishu
Dim i
cishu = 0
For rowXiJieWei = rowXiJieTou To 66
    If Cells(rowXiJieWei, 4) = "" Then
        cishu = cishu + 1
        If cishu > 2 Then
            zhaowei = rowXiJieWei - cishu
            Exit Function
        End If
    End If
Next
End Function

