Attribute VB_Name = "�����α�������v2"
'
Dim hangciDiYiCi As Boolean
Dim ranrunDiYiCi As Boolean
Dim w As Object
Dim wsh As Object

Dim i As Integer

Dim rng1 As Object
Dim rng2 As Object
Dim rng3 As Object
Dim rgang As Integer '�ۿ�������
Dim rtou
Dim rwei
Dim rowzbwei
Dim rtouwei
Dim str

Dim rowXiJieTou As Variant
Dim rowXiJieWei

Dim voy '��¼���κ�

Dim dakaibaobiao As Variant
Dim baobiao As String

Dim zb As Object
Dim zsh As Object

Dim zuoweiuzihoudejieweimeishenmeyisi
Sub ���α���ͳһ����()
 'v1.0�������Ϻ��α����ȼ���ϱ���һ�ű���
Application.ScreenUpdating = 0
Application.DisplayAlerts = 0

ChDir "\\192.168.0.223\��������\10�����Ϲ���\���α���\����15\2017��"
dakaibaobiao = Application.GetOpenFilename(FileFilter:="Excel�ļ� (*.xls; *.xlsx),*.xls; *.xlsx,�����ļ�(*.*),*.*", _
       Title:="Excelѡ��", MultiSelect:=True) 'ѡ��Ҫ���ϲ��Ĳ�

If Not IsArray(dakaibaobiao) Then '�������ȡ���ͽ���
    Exit Sub
End If

ranrunDiYiCi = True
hangciDiYiCi = True

Set zb = ActiveWorkbook
Set zsh = ActiveSheet

For Each baobiao In dakaibaobiao
    If InStr(5, baobiao, "ȼ") = 0 Then '���Ǻ��α���
        Call ���α�������
    Else '����ȼ���ϱ���
        Call ȼ���ϱ�������
    End If
Next baobiao


'����������
    zsh.Columns("c:d").NumberFormatLocal = "ddmmyyhhmm"
    Columns("A:A").ColumnWidth = 4
    Columns("B:B").ColumnWidth = 17.35
    Columns("C:C").ColumnWidth = 9.5
    Columns("D:D").ColumnWidth = 9.5
    Columns("e:i").ColumnWidth = 5.4
    Rows.RowHeight = 12

'����ȼ��������
Range("L2").Select
ActiveWindow.FreezePanes = True
For i = 2 To Range("L2").End(xlDown).Row
    str = Cells(i, 12).Text
    If InStr(1, str, "�����μ�") Then
        Cells(i, 12) = "+"
    Else
        Cells(i, 12) = "end"
    End If
Next
    Columns("k").ColumnWidth = 4
    Columns("l").ColumnWidth = 5
    Columns("m:n").ColumnWidth = 5.88


Application.ScreenUpdating = 1
Application.DisplayAlerts = 1
End Sub
Function ȼ���ϱ�������()
'v2.0
' ���ϱ������� Macro
'x = Application.GetOpenFilename(FileFilter:="Excel�ļ� (*.xls; *.xlsx),*.xls; *.xlsx,�����ļ�(*.*),*.*", _
       Title:="Excelѡ��", MultiSelect:=True) 'ѡ��Ҫ���ϲ��Ĳ�

'
Workbooks.Open (baobiao)
    Set w = Workbooks.Open(baobiao)
    Set wsh = w.Sheets("ȼ�ͱ���")
     voy = Mid(w.Name, InStr(11, w.Name, "V") + 1, 4)
    If ranrunDiYiCi Then
        wsh.Range("A38:c38").Copy zsh.Cells(1, 2)
        zsh.Cells(3, 1) = voy
        zsh.Range("a1") = Mid(w.Name, 1, InStr(3, w.Name, "ȼ") - 1)
        ranrunDiYiCi = False
    End If
    rowzbEnd = zsh.Cells(66666, 2).End(xlUp).Row + 1
    If Len(wsh.Range("b40").Text & wsh.Range("c40").Text) = 0 Then '�жϱ����μ�װ��һ���Ƿ��м���
        wsh.Range("A42:C42").Copy zsh.Cells(rowzbwei, 2) 'ֻ���ƺ���ĩ���
    Else
        wsh.Range("A40:C40,A42:C42").Copy zsh.Cells(rowzbwei, 2) '�����μ�װ�ͺ���ĩ���
    End If
    zsh.Cells(rowzbwei, 1) = voy
w.Close

Application.ScreenUpdating = 1
Application.DisplayAlerts = 1
End Function
Function ���α�������()
'v1.171114 �������˸��Ӵ�С

    If hangciDiYiCi Then
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
        hangciDiYiCi = False
    Else
        rowzbEnd = zsh.Cells(66666, 5).End(xlUp).Row + 1
        rowXiJieTou = zhaotou() 'ϸ�ڵĿ�ͷλ��
        rowXiJieWei = zhaowei() 'ϸ�ڵ����һ��λ��
        Set rng1 = wsh.Range(Cells(8, 1), Cells(rgang, 3)) '���벴ʱ������
        Set rng2 = wsh.Range(Cells(rowXiJieTou, 1), Cells(rowXiJieWei, 3))  '���벴ϸ������
        Set rng3 = wsh.Range(Cells(rowXiJieTou, 5), Cells(rowXiJieWei, 12))  'ϸ������ԭ��
        Union(rng1, rng2).Copy zsh.Cells(rowzbEnd, 2)
        rng3.Copy zsh.Cells(rowzbwei + rgang - 7, 5)
        zsh.Cells(rowzbEnd, 1) = voy
    End If
    'voy = voy + 1
w.Close

End Function
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

