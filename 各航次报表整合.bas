Attribute VB_Name = "�����α�������"
'
Dim hangciDiYiCi As Boolean
Dim ranrunDiYiCi As Boolean
Dim openedOil As Boolean
Dim openedVoy As Boolean
Dim w As Object
Dim wsh As Object

Dim i As Integer

Dim rng1 As Object
Dim rng2 As Object
Dim rng3 As Object
Dim rowGangKou 'As Integer '�ۿ�������
Dim rtou
Dim rwei
Dim rowzbEnd
Dim rtouwei
Dim str As String
Dim shipNum
Dim shipName As String
Dim fileDir
Dim rowXiJieHead As Variant
Dim rowXiJieEnd

Dim voy '��¼���κ�

Dim dakaibaobiao As Variant
Dim baobiao
Dim zb As Object
Dim zsh As Object
Dim zuoweiuzihoudejieweimeishenmeyisi
Sub yeeee()
Debug.Print "\\192.168.0.223\��������\10�����Ϲ���\���α���\����10\" & Year(Date) & "��"
End Sub
Sub ���α���ͳһ����()
'v1.4 �����˿�ͷ��ʾ�����
'v1.3 �޸��˶����ִ��񲿷�
'v1.2 �����˴��������Ա���ѡ�񱨱��ļ���
'v1.1 '�������ж��Ƿ�򿪹����ϱ�oil �ͺ��α�voy
 'v1.0�������Ϻ��α����ȼ���ϱ���һ�ű���
Application.ScreenUpdating = 0
Application.DisplayAlerts = 0
Do
If Len(shipNum) > 2 Then
    MsgBox "��������ȷ������"
End If
shipNum = InputBox("�����봬�����֣��綦��10������10", "��������", "10")
Loop While Len(shipNum) > 2
If shipNum = "" Then
    Exit Sub
End If
Select Case shipNum
    Case 17
        shipName = "����17�������ࣩ"
    Case 18
        shipName = "����18�������٣�"
    Case 32
        shipName = "����32"
    Case Else
        shipName = "����" & shipNum
End Select
fileDir = _
"\\192.168.0.223\��������\10�����Ϲ���\���α���\" _
& shipName & "\" & Year(Date) & "��"
ChDir fileDir
dakaibaobiao = Application.GetOpenFilename(FileFilter:="Excel�ļ� (*.xls; *.xlsx),*.xls; *.xlsx,�����ļ�(*.*),*.*", _
       Title:="Excelѡ��", MultiSelect:=True) 'ѡ��Ҫ���ϲ��Ĳ�

If Not IsArray(dakaibaobiao) Then '�������ȡ���ͽ���
    Exit Sub
End If

ranrunDiYiCi = True
hangciDiYiCi = True
openedOil = False
openedVoy = False
Set zb = ActiveWorkbook
Set zsh = ActiveSheet

If MsgBox("�Ƿ������ǰ�������", vbOKCancel) = vbOK Then
    Cells.Delete 'ɾ����ǰ�������
Else
'�˳�
End If

For Each baobiao In dakaibaobiao
    If InStr(5, baobiao, "ȼ") = 0 Then '���Ǻ��α���
        Call ���α�������
    Else '����ȼ���ϱ���
        Call ȼ���ϱ�������
    End If
Next baobiao

ActiveWindow.FreezePanes = False
Range("b2").Select
ActiveWindow.FreezePanes = True
'����������
If openedVoy Then
    zsh.Columns("c:d").NumberFormatLocal = "ddmmyyhhmm"
    Columns("A:A").ColumnWidth = 4
    Columns("B:B").ColumnWidth = 17.35
    Columns("C:C").ColumnWidth = 9.5
    Columns("D:D").ColumnWidth = 9.5
    Columns("e:i").ColumnWidth = 5.4
    Rows.RowHeight = 12
End If
'����ȼ��������
If openedOil Then
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
End If
Application.ScreenUpdating = 1
Application.DisplayAlerts = 1
End Sub
Function ȼ���ϱ�������()
'v2.1 �������ж��Ƿ�򿪹����ϱ�
' ���ϱ������� Macro
'x = Application.GetOpenFilename(FileFilter:="Excel�ļ� (*.xls; *.xlsx),*.xls; *.xlsx,�����ļ�(*.*),*.*", _
       Title:="Excelѡ��", MultiSelect:=True) 'ѡ��Ҫ���ϲ��Ĳ�

'Workbooks.Open (baobiao)
    Set w = Workbooks.Open(baobiao)
    Set wsh = w.Sheets("ȼ�ͱ���")
     voy = Mid(w.Name, InStr(11, w.Name, "V") + 1, 4)
    If ranrunDiYiCi Then
        wsh.Range("A38:c38").Copy zsh.Cells(1, 12)
        'zsh.Cells(3, 11) = voy
        zsh.Cells(1, 11) = Mid(w.Name, 1, InStr(3, w.Name, "ȼ") - 1)
        ranrunDiYiCi = False
    End If
    rowzbEnd = zsh.Cells(66666, 12).End(xlUp).Row + 1
    If Len(wsh.Range("b40").Text & wsh.Range("c40").Text) = 0 Then '�жϱ����μ�װ��һ���Ƿ��м���
        wsh.Range("A42:C42").Copy zsh.Cells(rowzbEnd, 12) 'ֻ���ƺ���ĩ���
    Else
        wsh.Range("A40:C40,A42:C42").Copy zsh.Cells(rowzbEnd, 12) '�����μ�װ�ͺ���ĩ���
    End If
    zsh.Cells(rowzbEnd, 11) = voy
w.Close
openedOil = True
End Function
Function ���α�������()
'v2.1 �������ж��Ƿ�򿪹����α�
'v1.171114 �������˸��Ӵ�С
    Set w = Workbooks.Open(baobiao)
    Set wsh = w.Sheets("���α���")
    voy = Mid(w.Name, InStr(6, w.Name, "V") + 1, 4)
    If hangciDiYiCi Then
        rowGangKou = wsh.Cells(8, 3).End(xlDown).Row '���벴ʱ������һ��λ��
        Debug.Print TypeName(rowGangKou)
        rowXiJieHead = zhaotou() 'ϸ�ڵĿ�ͷλ��
        rowXiJieEnd = zhaowei() 'ϸ�ڵ����һ��λ��
        Set rng1 = wsh.Range(Cells(6, 1), Cells(rowGangKou, 3)) '���벴ʱ������
        Set rng2 = wsh.Range(Cells(rowXiJieHead, 1), Cells(rowXiJieEnd, 3)) '���벴ϸ������
        Set rng3 = wsh.Range(Cells(rowXiJieHead, 5), Cells(rowXiJieEnd, 12)) 'ϸ������ԭ��
        Union(rng1, rng2).Copy zsh.Cells(1, 2)
        rng3.Copy zsh.Cells(rowGangKou - 4, 5)
        zsh.Cells(3, 1) = voy
        zsh.Range("a1") = Mid(w.Name, 1, InStr(3, w.Name, "��") - 1) 'a1��д����
        hangciDiYiCi = False
    Else
        rowzbEnd = zsh.Cells(66666, 5).End(xlUp).Row + 1
        rowXiJieHead = zhaotou() 'ϸ�ڵĿ�ͷλ��
        rowXiJieEnd = zhaowei() 'ϸ�ڵ����һ��λ��
        Set rng1 = wsh.Range(Cells(8, 1), Cells(rowGangKou, 3)) '���벴ʱ������
        Set rng2 = wsh.Range(Cells(rowXiJieHead, 1), Cells(rowXiJieEnd, 3))  '���벴ϸ������
        Set rng3 = wsh.Range(Cells(rowXiJieHead, 5), Cells(rowXiJieEnd, 12))  'ϸ������ԭ��
        Union(rng1, rng2).Copy zsh.Cells(rowzbEnd, 2)
        rng3.Copy zsh.Cells(rowzbEnd + rowGangKou - 7, 5)
        zsh.Cells(rowzbEnd, 1) = voy
    End If
    'voy = voy + 1
w.Close
openedVoy = True
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
For rowXiJieEnd = rowXiJieHead To 66
    If Cells(rowXiJieEnd, 4) = "" Then
        cishu = cishu + 1
        If cishu > 2 Then
            zhaowei = rowXiJieEnd - cishu
            Exit Function
        End If
    End If
Next
End Function

