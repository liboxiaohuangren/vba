Attribute VB_Name = "�����α�������"
Option Explicit

Dim hangciDiYiCi As Boolean
Dim ranrunDiYiCi As Boolean
Dim openedOil As Boolean
Dim openedVoy As Boolean

Dim i As Integer

Dim rng1 As Object
Dim rng2 As Object
Dim rng3 As Object

Dim w As Object
Dim wsh As Object
Dim zb As Object
Dim zsh As Object

Dim rowGangKou As Long '�ۿ�������
Dim rowzbEnd As Long
Dim rowXiJieHead As Long '�к�����������long
Dim rowXiJieEnd As Long

Dim str As String '��Ԫ������
Dim shipNum As String '��input��õ��ģ�����string
Dim shipName As String
Dim fileDir As String '�ļ���λ��
Dim voy As String '��¼���κ�

Dim dakaibaobiao As Variant ' ��VBA�У�����For Each m In a����a�����飬mֻ������Ϊvariant �����������﷨�����ġ�
Dim baobiao As Variant 'ͬ��

Dim zuoweiuzihoudejieweimeishenmeyisi
Sub ���α���ͳһ����()
'v1.5 �����˴�������ѡ��
'v1.4 �����˿�ͷ��ʾ�����
'v1.3 �޸��˶����ִ��񲿷�
'v1.2 �����˴��������Ա���ѡ�񱨱��ļ���
'v1.1 '�������ж��Ƿ�򿪹����ϱ�oil �ͺ��α�voy
 'v1.0�������Ϻ��α����ȼ���ϱ���һ�ű���
Application.ScreenUpdating = 0
Application.DisplayAlerts = 0
Do
Debug.Print shipNum
If shipNum = "     " Then
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
'v2.2 �޸��˱�����������FO:����
'v2.1 �������ж��Ƿ�򿪹����ϱ�
'v2.0 ��ԭ����sub��Ϊsub���α���ͳһ����()�µ�һ��function
'v1.0 ���ϱ������� Macro
Dim rngGezi As Object
Dim rngOilHead As Object
Dim rngOilAdd As Object
Dim rngOilEnd As Object
    Set w = Workbooks.Open(baobiao)
    Set wsh = w.Sheets("ȼ�ͱ���")
    voy = Mid(w.Name, InStr(11, w.Name, "V") + 1, 4)
For Each rngGezi In Range("b36:b44")
    If rngGezi = "FO:" Then
        rngOilHead = Range(Cells(rngGezi.Row, 2), Cells(rngGezi.Row, 3))
    End If
Next rngGezi
rowOilAdd = Range(Cells(rngGezi.Row + 2, 2), Cells(rngGezi.Row + 2, 3))
rowOilEnd = Range(Cells(rngGezi.Row + 4, 2), Cells(rngGezi.Row + 4, 3))
    If ranrunDiYiCi Then
        rngOilHead.Copy zsh.Cells(1, 12)
        zsh.Cells(1, 11) = Mid(w.Name, 1, InStr(3, w.Name, "ȼ") - 1)
        ranrunDiYiCi = False
    End If
    rowzbEnd = zsh.Cells(66666, 12).End(xlUp).Row + 1
    If Len(wsh.Range("b40").Text & wsh.Range("c40").Text) = 0 Then '�жϱ����μ�װ��һ���Ƿ��м���
        rowOilEnd.Copy zsh.Cells(rowzbEnd, 12) 'ֻ���ƺ���ĩ���
    Else
        Union(rowOilAdd, rowOilEnd).Copy zsh.Cells(rowzbEnd, 12) '�����μ�װ�ͺ���ĩ���
    End If
    zsh.Cells(rowzbEnd, 11) = voy
w.Close
openedOil = True
End Function
Function ���α�������()
'v2.2 ����ֻѡ�пɼ���Ԫ��
'v2.1 �������ж��Ƿ�򿪹����α�
'v2.0 ��ԭ����sub��Ϊsub���α���ͳһ����()�µ�һ��function
'v1.171114 �������˸��Ӵ�С
'v1.0 ���α������� Macro
    Set w = Workbooks.Open(baobiao)
    Set wsh = w.Sheets("���α���")
    voy = Mid(w.Name, InStr(6, w.Name, "V") + 1, 4)
    If hangciDiYiCi Then
        rowGangKou = wsh.Cells(8, 3).End(xlDown).Row '���벴ʱ������һ��λ��
        rowXiJieHead = rowZhaoHead() 'ϸ�ڵĿ�ͷλ��
        rowXiJieEnd = rowFindEnd() 'ϸ�ڵ����һ��λ��
        Set rng1 = wsh.Range(Cells(6, 1), Cells(rowGangKou, 3)) '���벴ʱ������
        Set rng2 = wsh.Range(Cells(rowXiJieHead, 1), Cells(rowXiJieEnd, 3)).SpecialCells(xlCellTypeVisible) '���벴ϸ������
        Set rng3 = wsh.Range(Cells(rowXiJieHead, 5), Cells(rowXiJieEnd, 12)).SpecialCells(xlCellTypeVisible) 'ϸ������ԭ��
        Union(rng1, rng2).Copy zsh.Cells(1, 2)
        rng3.Copy zsh.Cells(rowGangKou - 4, 5)
        zsh.Cells(3, 1) = voy
        zsh.Range("a1") = Mid(w.Name, 1, InStr(3, w.Name, "��") - 1) 'a1��д����
        hangciDiYiCi = False
    Else
        rowzbEnd = zsh.Cells(66666, 5).End(xlUp).Row + 1
        rowXiJieHead = rowZhaoHead() 'ϸ�ڵĿ�ͷλ��
        rowXiJieEnd = rowFindEnd() 'ϸ�ڵ����һ��λ��
        Set rng1 = wsh.Range(Cells(8, 1), Cells(rowGangKou, 3)) '���벴ʱ������
        Set rng2 = wsh.Range(Cells(rowXiJieHead, 1), Cells(rowXiJieEnd, 3)).SpecialCells(xlCellTypeVisible)  '���벴ϸ������
        Set rng3 = wsh.Range(Cells(rowXiJieHead, 5), Cells(rowXiJieEnd, 12)).SpecialCells(xlCellTypeVisible)  'ϸ������ԭ��
        Union(rng1, rng2).Copy zsh.Cells(rowzbEnd, 2)
        rng3.Copy zsh.Cells(rowzbEnd + rowGangKou - 7, 5)
        zsh.Cells(rowzbEnd, 1) = voy
    End If
w.Close
openedVoy = True
End Function
Function rowZhaoHead()
Dim strgezi As String
Dim rngGezi As Object
For Each rngGezi In Range("a25:a55") '�ҵ���ͷ��λ��
    If rngGezi.Text = "����װж��ʱ�䡢��������ê�ȴ���������ҵ׼��ʱ�䣩" Then '�����"��λ Location"�ᵼ��ѡ��ǰ��30��
        rowZhaoHead = rngGezi.Row + 1
        Exit Function
    End If
Next rngGezi
End Function
Function rowFindEnd()
'v1.2 ���ڿ�����ȷͳ���������ж������ۼƿ��У����ų����ص�Ԫ��dh9�ģ�
'
Dim cishu
Dim i
Dim rngGezi As Object
cishu = 0
'Range(Cells(rowXiJieHead, 3), Cells(80, 3)).SpecialCells(xlCellTypeVisible).Select 'ѡ�пɼ���Ԫ��
For Each rngGezi In Range(Cells(rowXiJieHead, 3), Cells(80, 3)).SpecialCells(xlCellTypeVisible)
    rowXiJieEnd = rngGezi.Row
    If Cells(rowXiJieEnd, 4) = "" Then
        cishu = cishu + 1
    Else
        cishu = 0
    End If
    If cishu > 2 Then '�������3��
        rowFindEnd = rowXiJieEnd - cishu
        Exit Function
    End If
Next rngGezi
End Function
