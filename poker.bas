Attribute VB_Name = "poker"
Dim hand(7, 2) '0-7�������
Dim playerMoney(7)
Dim deck(52)    '��,��sT,d8
Dim shuffleDeck(52) 'ϴ�õ���,���Ƶı�ţ�51=sA,50=sK,0=d2
Dim zongpai(7) '����+������,���
Dim communityCards(5)  'cards on table
Dim pattern(7) 'ÿ�����������ͣ�0��high,�����ڲ��ȴ�С
Dim patternDeck(7) 'ÿ�����������ͣ�������ʾ���˿�
Dim maxPat(7) '��������
Dim maxPatDeck(7)
Dim maxPlayer(7) '���ļ������
Dim playerFold(7) 'default false
Dim playerQuit(7) 'def false

Dim playerPosition(7)

Dim rngPosition

Dim rngHand  '���Ƹ���
Dim rngMoney '��ͷ��Ǯ���ڵĸ���
Dim rngPot
Dim rngFlop As Range
Dim rngTurn As Range
Dim rngRiver As Range

Dim callChips(7) '��ע����


Dim finalSeven As String
Dim deckCard As Integer    'dealed cards����ȥ���Ƶ�����
Dim player As Integer
Dim prevPlayer As Integer
Dim gamePlayed As Integer '���˼���
Dim stage As Integer 'preflop=0,flop=1,etc
Dim SB As Integer
Dim BB As Integer
Dim betTurn As Integer
Dim pot 'dichi
Function TexasHoldem()
'v0.3 171120���Աȴ�С��
'v0.2 171116 ���ڿ����ж�ͬ��
'v0.1 ϴ�Ʒ�����˳�������

'Range("a1:ak9").Clear
'Range("a12:ak15").Clear

If gamePlayed < 1 Then


    Call preparecells
    Call preparePlayers
    Call prepareDeck
    BB = 10
    SB = 5
    betTurn = 0
    pot = 0
    gamePlayed = 1
End If
Range(rngPosition(gamePlayed - 1)) = "D"
Range(rngPosition(gamePlayed)) = "SB"
Range(rngPosition(gamePlayed + 1)) = "BB"
For player = 0 To 7
    If playerMoney(player) <= 0 Then
        playerQuit(player) = True
    End If
Next player

Call shuffle    'ϴ��
Call deal       '����
stage = 0 'preflop
    Call raiseCallFold
Call flop
stage = 1 'flop
    Call raiseCallFold
Call turn
stage = 2 'turn
    Call raiseCallFold
Call river 'river
stage = 3
    Call raiseCallFold
Call compareCards
gamePlayed = gamePlayed + 1
End Function
Function preparecells()
'׼����
    Cells.ColumnWidth = 3.13
    Cells.RowHeight = 14.25
    Set rngFlop = Range("T12:V12")
    Set rngTurn = Range("w12")
    Set rngRiver = Range("x12")
    'N=14,V=22,AD=30,CODROW1=4,R2=12,R3=20
    Range("t10:u10").Merge
    Set rngPot = Range("t10:u10")
    rngPot.Borders.LineStyle = xlContinuous
    Range("r10:s10").Merge
    Range("r10:s10").Value = "pot:"
    
    Range("T12:X12").NumberFormatLocal = ";;;"
    Range("M12:N12,N4:O4,V4:W4,AD4:AE4,AE12:AF12,AD20:AE20,V20:W20,N20:O20,T12:X12" _
        ).NumberFormatLocal = ";;;"
    Range("M12:N12,N4:O4,V4:W4,AD4:AE4,AE12:AF12,AD20:AE20,V20:W20,N20:O20,T12:X12" _
        ).Value = ""
    i = 0
    For Each Rng In Range("T21,L21,K13,L5,T5,AB5,AC13,AB21")
        Rng.Value = "P" & i
        i = i + 1
    Next Rng
    rngPosition = Array("s21", "k21", "j13", "k5", "s5", "aa5", "Ab13", "Aa21")
    Range("L6:M6,K14:L14,L22:M22,T22:U22,AB22:AC22,AC14:AD14,AB6:AC6,T6:U6").Merge
    Range("L6:M6,K14:L14,L22:M22,T22:U22,AB22:AC22,AC14:AD14,AB6:AC6,T6:U6") = "chips:"
    
    Range("N6:O6,M14:N14,N22:O22,V22:W22,AD22:AE22,AE14:AF14,AD6:AE6,V6:W6").Merge 'rngMoney
    With Range("N5:O5,V5:W5,AD5:AE5,AE13:AF13,AD21:AE21,V21:W21,N21:O21,M13:N13,T13:X13").Borders '���˿��Ĳ���
        .LineStyle = xlContinuous
    End With
End Function
Function preparePlayers()
rngHand = [{"v20","w20";"n20","o20";"m12","n12";"n4","o4";"v4","w4";"ad4","ae4";"ae12","af12";"ad20","ae20"}]
rngMoney = Array("V22", "N22", "M14", "N6", "V6", "AD6", "AE14", "AD22")
For player = 0 To 7
    playerMoney(player) = 1000
    Range(rngMoney(player)) = playerMoney(player)
    playerQuit(player) = False
    playerFold(player) = False
Next player
End Function
Function prepareDeck()
Dim suit
Dim rank
suit = Array("d", "c", "h", "s")
rank = Array(2, 3, 4, 5, 6, 7, 8, 9, "T", "J", "Q", "K", "A")
k = 0
For i = 0 To 3
    For j = 0 To 12
        deck(k) = suit(i) & rank(j)
        k = k + 1
    Next j
Next i
End Function
Function shuffle()
Dim wushier(52)
Dim k
'Dim a
'For a = 0 To 5
For k = 0 To 51
    wushier(k) = k   'һ��00-51������
    shuffleDeck(k) = 0
Next k
uBond = 52
lBond = 0
For k = 0 To 51  'ѭ������52�����ظ������������һ������shuffleDeck
    If uBond > 0 Then
        paixu = Int(Rnd(Timer) * uBond)   '[0,uBond-1] ֮���������
        shuffleDeck(k) = wushier(paixu) '�������ֵһ�����ŵ���������
        wushier(paixu) = wushier(uBond - 1) '�����һ��ֵŲ���������λ��
        uBond = uBond - 1                  '���������һ����
    End If
Next k
'Next a
End Function
Function raiseCallFold() 'ʩ���ֳ�

Do
For i = 0 To 7
    player = (i + gamePlayed) Mod 8
    prevPlayer = (i + gamePlayed - 1) Mod 8
    If stage = 0 And betTurn = 0 Then 'preflop,start
        Select Case player
        Case 1 'Сäעλ
            callChips(player) = SB
        Case 2 '��äעλ
            callChips(player) = BB
        Case Else
            If player = 0 Then '����
                Call youBet
            Else
                Call aiBet
            End If
        End Select
    Else
        If player = 0 Then 'you
            Call youBet
        Else
            Call aiBet
        End If
    End If
        pot = pot + callChips(player)
        playerMoney(player) = playerMoney(player) - callChips(player)
        Range(rngMoney(player)).Value = playerMoney(player)
Next i
rngPot.Value = pot
betTurn = betTurn + 1
Loop While callChips(prevPlayer) < callChips(player)
For i = 0 To 7
    callChips(i) = 0
Next i
End Function
Function aiBet()
'v0 ɵ��
callChips(player) = callChips(prevPlayer)
End Function
Function youBet()
yourOPT:
yourOption = InputBox("�������ѡ����ţ�" & vbCrLf & "0.����" & vbCrLf & "1.��ע " & callChips(player) & vbCrLf & "2.��ע" & vbCrLf & "3.����", "���ƣ����ƣ���ע��������")
    Select Case yourOption
        Case 0 'check
            If callChips(prevPlayer) > callChips(player) Then
                MsgBox "���ܹ��ƣ����עС"
                GoTo yourOPT
            End If
        Case 1 'call
            callChips(player) = callChips(prevPlayer)
            playerMoney(player) = playerMoney(player) - callChips(player)
            Range(rngMoney(player)).Value = playerMoney(player)
        Case 2 'raise
            raiseChips = callChips(prevPlayer) + InputBox("raise?", "��ע", 2 * callChips(player))
            callChips(player) = raiseChips
        Case 3 'fold
            playerFold(0) = True
    End Select
    
End Function
Function deal()
deckCard = 0
For handCard = 0 To 1   'preflop����
    For player = 0 To 7 'Ŀǰ����֧��7����
        If playerQuit(player) Then
            Exit For
        End If
        hand(player, handCard) = shuffleDeck(deckCard)
        Range(rngHand(player + 1, handCard + 1)) = deck(shuffleDeck(deckCard))
        deckCard = deckCard + 1
    Next player
Next handCard
End Function
Function flop()
i = 0
For Each Rng In rngFlop
    Rng.Value = deck(shuffleDeck(deckCard))
    communityCards(i) = shuffleDeck(deckCard)
    deckCard = deckCard + 1
    i = i + 1
Next
End Function
Function turn()
rngTurn = deck(shuffleDeck(deckCard))
communityCards(3) = shuffleDeck(deckCard)
deckCard = deckCard + 1
End Function
Function river()
rngRiver = deck(shuffleDeck(deckCard))
communityCards(4) = shuffleDeck(deckCard)
End Function
Function compareCards()
countSameMax = 0
For i = 0 To 7
    maxPat(i) = ""
Next i
For player = 0 To 7
    If playerFold(player) = "fold" Then
        Exit For
    End If
    i = 0
    For handCard = 0 To 1
        zongpai(i) = hand(player, handCard)
        i = i + 1
    Next handCard
    For tableCard = 0 To 4
        zongpai(i) = communityCards(tableCard)
        i = i + 1
    Next tableCard
    '���Բ���'ceshi'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'zongpai(0) = 38
'zongpai(1) = 49
'zongpai(2) = 48
'zongpai(3) = 51
'zongpai(4) = 46
'zongpai(5) = 30
'zongpai(6) = 45

    'end���Բ���'ceshi'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Call insertSort
    Call rules '��������
    Debug.Print patternDeck(player) & " " & deck(hand(player, 0)) & " " & deck(hand(player, 1))
    Debug.Print "------"
    If pattern(player) > maxPat(countSameMax) Then 'ѡ���������ͺ����
        countSameMax = 0
        maxPat(countSameMax) = pattern(player)
        maxPatDeck(countSameMax) = patternDeck(player)
        maxPlayer(countSameMax) = player
    ElseIf pattern(player) = maxPat(countSameMax) Then '�������ͬ��С���ͣ������ӷֵ׳ص����
        countSameMax = countSameMax + 1
        maxPat(countSameMax) = pattern(player)
        maxPatDeck(countSameMax) = patternDeck(player)
        maxPlayer(countSameMax) = player
    End If
'    Exit For '���Բ��֣���ɾ'ceshi'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Next player

earnChips = pot / (countSameMax + 1)
For i = 0 To countSameMax
    player = maxPlayer(i)
    a = MsgBox("winner is :   " & maxPlayer(i) & vbCrLf & _
                "pattern is :   " & maxPatDeck(i) & vbCrLf & _
                player & " win  $" & earnChips, vbOKOnly, "Winner")
    
    playerMoney(player) = playerMoney(player) + earnChips
    rngMoney(player) = playerMoney(player)
    Debug.Print "�� " & gamePlayed & " ��"
    Debug.Print "�ý�����:  " & countSameMax + 1
    Debug.Print "�������:  " & maxPatDeck(i)
    Debug.Print "������:   " & deck(communityCards(0)) & deck(communityCards(1)) & deck(communityCards(2)) & _
    deck(communityCards(3)) & deck(communityCards(4))
    Debug.Print "Ӯ��:  " & player, deck(hand(player, 0)), deck(hand(player, 1))
    Debug.Print "------------------------------------"
'    Exit For 'ceshi'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Next i
pot = 0
rngPot.Value = ""
earnChips = 0
End Function
Function zctex()
For i = 0 To 3
Call TexasHoldem
Next i
End Function
Function insertSort()
'v1.0   ���ư��յ����Ӵ�С���Ӻ��ҵ���Ƭ����
zok = ""
zokd = ""
For i = 0 To 5
    For j = i + 1 To 6
        rankZj = zongpai(j) Mod 13
        suitZj = Int(zongpai(j) / 13)
        rankZi = zongpai(i) Mod 13
        suitZi = Int(zongpai(i) / 13)
        If rankZj > rankZi Then '�ȱ��Ƶĵ���
            temp = zongpai(j)
            zongpai(j) = zongpai(i)
            zongpai(i) = temp
        ElseIf rankZj = rankZi And suitZj > suitZi Then '��ͬ�ͱȻ�ɫ
            temp = zongpai(j)
            zongpai(j) = zongpai(i)
            zongpai(i) = temp
        End If
    Next j

Next i
'ceshi'''''''''''''''''''''''''''''''''''''''
For i = 0 To 6
    zok = zok & " " & zongpai(i)
    zokd = zokd & " " & deck(zongpai(i))
    Next i
Debug.Print "player: " & player
Debug.Print zok
Debug.Print zokd 'ceshi'''''''''''''''''''''''''''''''''''''''
End Function

Function rules()
'v0.2   ���ж��Ƶ���rankʱ����֤ÿ��������λ�������ַ�����ʾ��00��2,12��A
'       ���¸�д��if���������ܹ��ж�ͬ����˳��985
'v0.1 �ж�ͬ��˳��ʧ��
'chr(48)="0"

Dim namePat 'name
Dim countSuits(3) 'ͳ����7�������������ɫ������
Dim flushCards(3) '�ĸ���ɫ������������
Dim sameCards(6) 'ͳ����7�����������ͬ������
Dim sameDeck(6)
Dim rankZ(6)
Dim rankDeck(6)
Dim suitZ(6)
Dim suitDeck(6)
Dim typePat(9) '0-9ʮ��ͳ������ɵ����ͣ�������rankZ
Dim deckPat(9) '����id��ɵ�����,zongpai
'patternDeck(player)
'pattern(player)
Dim rnkSev As String
Dim sutSev As String
rnkSev = ""
sutSev = ""

rulHe:
isFlush = False
strFlush = ""
strHigh = "0"
namePat = Array("high card", "one pair", "two pairs", "3 of a kind", "straight", "flush", "full house", "4 of a kind", "straight flush", "royal flush")
For i = 0 To 9 '��ͷ������
    typePat(i) = "" '���ͺſ�ͷ������5���ƣ�11λ�ַ�������9��8֮������ͺ��ƣ������ѡ��������
    If i < 7 Then
        rankZ(i) = "" & zongpai(i) Mod 13 '�����е�i���Ƶĵ���,00��2,��08��T��12��A
        rankDeck(i) = deck(zongpai(i)) '������������Ƶ����棬deck
        If rankZ(i) < 10 Then '��ȷ����λ��
            rankZ(i) = "0" & rankZ(i)
        End If
        suitZ(i) = Int(zongpai(i) / 13) '�����е�i���ƵĻ�ɫ��0��diamonds��3��spades
'        Cells(19, i + 3) = rankZ(i)
'        Cells(20, i + 3) = suitZ(i)
'        rnkSev = rnkSev & rankZ(i)
'        sutSev = sutSev & suitZ(i)
        countSuits(suitZ(i)) = countSuits(suitZ(i)) + 1 'ͳ���������Ƹ��ֻ�ɫ(0-3����),ÿ���������м�����int
         '����Ļ��ǵ�Ҫ����Ϊ������ܳ�С��ͬ��˳ '����Ĳ�Ҫ�ˣ���Ϊ���ǰ������ź���ģ������С�ƿ��Բ���
        flushCards(suitZ(i)) = flushCards(suitZ(i)) & rankZ(i) '����ͬ������
        suitDeck(suitZ(i)) = suitDeck(suitZ(i)) & deck(zongpai(i)) '����ͬ�����Ƶ�����deck
        If Len(flushCards(suitZ(i))) = 10 Then '���ͬ������5����
            typePat(5) = "5" & flushCards(suitZ(i)) 'ֻ��ͬ��
            deckPat(5) = suitDeck(suitZ(i)) & Space(5) & namePat(5)
        End If
        sameCards(i) = rankZ(i) '��ͬ���飬�������������
        sameDeck(i) = deck(zongpai(i))
    End If
    If i < 5 Then
        strHigh = strHigh & rankZ(i) '0high
        deckHigh = deckHigh & deck(zongpai(i))
    End If
    If i < 4 Then
        flushCards(i) = ""  '׼��ͬ��������
        countSuits(i) = 0 'ͳ���������Ƹ��ֻ�ɫ(0-3����),ÿ���������м�����int
    End If
Next i
typePat(0) = strHigh '& "    high"
deckPat(0) = deckHigh '
sameNum = 0 '��ͬ�����һ�ŵ�λ��
endSameCard = 0 '����������ͬ����
straightSuits = 0 '�����ж�˳�ӵĻ�ɫ
straightFlush = 0

countStraightFlush = 0 '����ͬ��˳�ĸ���
countStraight = 0 '����˳�ӵĸ���
straightCards = "" '�ռ�˳���ƣ���kqjt9,1110090807,10λ�ַ�
straightDecks = "" '˳���������ռ����� sTd9h8c7d6
pattern(player) = "" '�������ͣ����ͺſ�ͷ������5���ƣ�11λ�ַ�����ʼ�ͬ��˳����91211100908


For i = 0 To 5 '������
    j = i + 1
    If i < endSameCard - 1 Then
        GoTo nexti
    End If
    If rankZ(i) - rankZ(j) = 1 Then   '�ж��Ƿ�˳�Ӷ����ڷ�Χ��
        countStraight = countStraight + 1 'i�Ƶ�˳�Ӵ���
        straightCards = straightCards & rankZ(i) '�ռ�˳�ӵ���
        ifSame = i
        If i = endSameCard - 1 Then
            ifSame = sameNum
        End If
        straightDecks = straightDecks & rankDeck(ifSame)
        straightSuits = straightSuits + Abs(suitZ(i) - suitZ(j)) 'ͳ�ƻ�ɫ���������ͬ��ɫ��=0
        If countStraight = 4 And straightSuits = 0 And Left(straightCards, 2) = 12 Then   '4rankZi+1rankZj 5�������ţ���A��ͬ��˳��9royal
            pattern(player) = 9 & straightCards & rankZ(j) '& "    royal flush"
            patternDeck(player) = straightDecks & rankDeck(j) & Space(5) & namePat(9)
            Exit Function
        ElseIf countStraight = 4 And straightSuits = 0 Then '��ͨͬ��˳,8straight flush
            pattern(player) = 8 & straightCards & rankZ(j) '& "    straight flush"
            patternDeck(player) = straightDecks & rankDeck(j) & Space(5) & namePat(8)
            Exit Function
        ElseIf countStraight = 4 Then
            pattern(player) = 4 & straightCards & rankZ(j) '& "    straight" 'ֻ��˳��,����3 of a kind"
            patternDeck(player) = straightDecks & rankDeck(j) & Space(5) & namePat(4)
            Exit Function
        End If
    ElseIf rankZ(i) - rankZ(j) = 0 Then '�ж��Ƿ���ͬ������
        sameNum = i
        For j = j To 6
            If rankZ(i) - rankZ(j) = 0 Then
                sameCards(i) = sameCards(i) & rankZ(j)
                sameDeck(i) = sameDeck(i) & rankDeck(j)
                sameCards(j) = ""
                sameDeck(j) = ""
            Else
                Exit For
            End If
        Next j
        If j > 6 Then
            j = 6
        End If
        endSameCard = j
        suitZ(j - 1) = suitZ(i) 'j��������ͬ�ƺ����һ�Ų�ͬ���ƣ����һ����ͬ����j-1
    Else '�м�ϵ�
        countStraight = 0
        straightCards = ""
    End If
nexti:
Next i

For i = 0 To 6
    For j = i + 1 To 6
        If Len(sameCards(j)) > Len(sameCards(i)) Then
            temp = sameCards(i)
            sameCards(i) = sameCards(j)
            sameCards(j) = temp
            
            tempD = sameDeck(i)
            sameDeck(i) = sameDeck(j)
            sameDeck(j) = tempD
        ElseIf Len(sameCards(j)) = Len(sameCards(i)) And sameCards(j) > sameCards(i) Then
            temp = sameCards(i)
            sameCards(i) = sameCards(j)
            sameCards(j) = temp
            tempD = sameDeck(i)
            sameDeck(i) = sameDeck(j)
            sameDeck(j) = tempD
        End If
    Next j
Next i

Select Case Len(sameCards(0))
    Case 8
        typePat(7) = 7 & sameCards(0) & Left(sameCards(1), 2) ' & "    4 of a kind" '74 of a kind:       AAAAx
        deckPat(7) = sameDeck(0) & Left(sameDeck(1), 2) & Space(5) & namePat(7)
        pattern(player) = typePat(7)
        patternDeck(player) = deckPat(7)
        Exit Function
    Case 6
        If Len(sameCards(1)) > 3 Then
            typePat(6) = 6 & sameCards(0) & Left(sameCards(1), 4) ' & "    full house" ':        AAAKK
            deckPat(6) = sameDeck(0) & Left(sameDeck(1), 4) & Space(5) & namePat(6)
            pattern(player) = typePat(6)
            patternDeck(player) = deckPat(6)
            Exit Function
        ElseIf Len(typePat(5)) > 10 Then
            pattern(player) = typePat(5) 'ֻ��ͬ����ǰ��д��
            'deckPat(5) = suitDeck(suitZ(i)) & Space(5) & namePat(5)ǰ���Ѿ�д��
            patternDeck(player) = deckPat(5)
            Exit Function
        Else
            typePat(3) = 3 & sameCards(0) & sameCards(1) & sameCards(2) '& "    3 of a kind" ':       AAAxx
            deckPat(3) = sameDeck(0) & sameDeck(1) & sameDeck(2) & Space(5) & namePat(3)
            pattern(player) = typePat(3)
            patternDeck(player) = deckPat(3)
            Exit Function
        End If
    Case 4
        If Len(sameCards(1)) > 3 Then
            typePat(2) = 2 & sameCards(0) & sameCards(1) & Left(sameCards(2), 2) '& "    two pairs" '2          AAKKx
            deckPat(2) = sameDeck(0) & sameDeck(1) & Left(sameDeck(2), 2) & Space(5) & namePat(2)
            pattern(player) = typePat(2)
            patternDeck(player) = deckPat(2)
            Exit Function
        Else
            typePat(1) = 1 & sameCards(0) & sameCards(1) & sameCards(2) & sameCards(3) '& "    one pair" '1           AAxxx
            deckPat(1) = sameDeck(0) & sameDeck(1) & sameDeck(2) & sameDeck(3) & Space(5) & namePat(1)
            pattern(player) = typePat(1)
            patternDeck(player) = deckPat(1)
            Exit Function
        End If
End Select
pattern(player) = typePat(0)
patternDeck(player) = deckPat(0) & Space(5) & namePat(0)
    
'pattern(player) = Application.WorksheetFunction.Max(typePat)
'final:
'9royal flush:       TJQKAs
'8straight flush:    56789s
'74 of a kind:       AAAAx
'6full house:        AAAKK
'5flush:             479TKs
'4straight:          56789o  'bicycle:A2345  'broadway:TJQKA
'33 of a kind:       AAAxx
'2two pairs          AAKKx
'1one pair           AAxxx
'0high card          xxxxx

End Function
Function ceee()
Dim beu(5)
bii = 51
i = 1
For i = i To 5
'beu(i) = i
Debug.Print Rnd
Next
'beu(4) = "0" & beu(3)
'Debug.Print beu(4), 4
'Debug.Print beu(3), 3
'Application.WorksheetFunction.Max(beu)
End Function
Function helpme()
Application.ScreenUpdating = 1
Application.DisplayAlerts = 1

'���λ��
'1. Button--ׯ��λ�ã�Ҳ��������ťλ
'������Ϸ�е�һ��ׯ��λ����ϵͳ���ָ����������Ϸʱ���Դ�ҳ��ƾ������鵽����Ƶ��˵�����һ�ֵ�ׯ�ң��Ժ�ÿ��ׯ��λ�ð���˳ʱ�뷽������һλ��
'2. Big Blind--��äע�����BB
'ׯ����������ڶ�λ��Ϊ��äע���ƾֿ�ʼǰ��̶���ע��λ�ã�һ����ע��Ϊ��ǰ������ע��
'3. Small Blind--Сäע�����SB
'ׯ�����������һλ��ΪСäע��Ҳ���ƾֿ�ʼǰ��̶���ע��λ�ã�һ����ע��Ϊ��äע��һ�롣
'4. Under the Gun--ǹ��λ�����UTG
'��äע���������һλ��Ϊǹ��λ��ǹ��λ��λ�������˵�Ƚϱ����������ᱻ�����ơ�
'5. Cutoff--��ɷλ��ׯ���ұߵ�λ�á�
'�ƾֲ���
'Action --��ע?˵��
'�����˿��ﹲ�����ֲ���:
'1. Bet--Ѻע��Ѻ�ϳ��롣
'2. Call--���� / ��ע����������Ѻ��ͬ�ȵ�ע�
'3. Fold--���� / ���������������ƾֵĻ��ᡣ
'4. Check--���� / ���ƣ�����������������ѡ��Ѿ������á�����һλ��
'5. Raise--��ע�������е�ע��̧�ߡ�
'6. Re-raise--�ټ�ע���ڱ��˼�ע�Ժ�ع����ټ�ע��
'7. All-in--ȫ�£�һ�ι������ϵĳ���ȫѺ�ϡ�
'������ע
'1. Pre-flop--����ǰ
'�����Ƴ�����ǰ�ĵ�һ�ֽ�ע?
'2. Flop--���ƣ������Ź����ơ�Flop round--����Ȧ�������Ź����Ƴ����Ժ��ѺעȦ��
'3. Turn--ת�ƣ������Ź����ơ�Turn round--ת��Ȧ�� �����Ź����Ƴ����Ժ��ѺעȦ ��
'4. River--���ƣ������Ź����ơ�River round--����Ȧ�������Ź����Ƴ����Ժ� , Ҳ����̯����ǰ��ѺעȦ ��
'���ֻ�ɫ
'1. H(Heart)--���ң����˿������ǰ��������
'2. S(Spade)--���ң����˿�������Ȩ��������
'3. D(Diamond)--���飺���˿������ǲƸ�������
'4. C(Club)--�ݻ������˿����������˵�����
'��������
'���ּ�Ʒ��
'����������ɴ���С����Ϊ:
'
'suited --ͬһ��ɫ: ����AKs ��ʾAKͬһ��ɫ
'off suit - -��ͬ��ɫ: ����AKo ��ʾAK��ͬ��ɫ
'Set--��������������3-3 ���� A-3-4 �����һ��Set
'Bicycle --��С��˳��: a -2 - 3 - 4 - 5
'Broadway--10��A��˳��
'Connectors--���ƣ����� 9-10��10-J������������
'Draw hand - -����: ��Ϊ��ͬ���ʹ�˳�ӵ��� �������10 - J������������
'Open-ended Straight--���˿���˳�ӣ�����������Q-K��̨����10-J-3
'Pocket pair--�ڴ����ӣ�����2-2��3-3��4-4������������
'American Airlines - -AA: һ��A��������
'Cowboys --KK: һ��K��������
'Rainbow -�ʺ���: ָ���Ƿ������Ų�ͬ��ɫ�����
'Nuts--���������������A-A��̨�� A-A-6-J-8�����������󣬾ͽ�nuts
'����
'Pot--�׳أ�ÿһ���ƾ���������Ѻ�ϵĳ����ܶҲ���þֵĽ�����Ŀ��
'Outs--��·�� һ�������ĳ���׶������ܻ�ʤ�ļ��ַ���������һ��ӵ��һ�Կڴ�9�������Ҫ��һ��9��ȡʤ,���ľ�����������·��(ʣ�µ�������ɫ��9)��
'Bluff--թ������û��ʲôʤ��������Ѻ�Ϻܶ���룬�������ơ�
'Slowplay--���棺����������ע���������˼��
'Heads-up--��������дHU
'Showdown--̯�Ʊȴ�С��˫�����������ƣ�ֻ�ñȴ�С��
'free card--����ƣ�ָ������ע����ѿ�һ���ơ�
'Fish--�㣺һ���ˮƽ����Ҷ���Щ�䲻����Ʒ�����ҵı���ƺ���
'Shark --����: һ��ָ�ܹ�ӮǮ�ĸ���?
End Function


