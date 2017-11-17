Attribute VB_Name = "poker"
Dim hand(5, 2)
Dim playerMoney(5)
Dim deck(52)    '��,��sT,d8
Dim shuffleDeck(52) 'ϴ�õ���,���Ƶı�ţ�51=sA,50=sK,0=d2
Dim zongpai(7) '����+������,���
Dim communityCards(5)  'cards on table
Dim pattern(5) 'ÿ�����������ͣ�0��high

Dim deckCard As Integer    'dealed cards����ȥ���Ƶ�����
Dim player As Integer

Dim rngMoney As Object
Dim rngFlops As Object
Dim rngTurn As Object
Dim rngRiver As Object
Function TexasHoldem()
'v0.2 171116 ���ڿ����ж�ͬ��
'v0.1 ϴ�Ʒ�����˳�������
Cells(16, 3) = "chips:"
Set rngHumMoney = Cells(16, 4)
Set rngFlops = Range("c9:e9")
Set rngTurn = Cells(9, 6)
Set rngRiver = Cells(9, 7)

Call preparePlayers
Call prepareDeck
rngHumMoney = "$1000"
Call shuffle    'ϴ��
Call deal       '����
'preflop

Call flop

Call turn

Call river

Call compareCards
End Function
Function preparePlayers()
For player = 0 To 4
    playerMoney(player) = 1000
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
For k = 0 To 51
    wushier(k) = k   'һ��00-51������
Next k
uBond = 52
lBond = 0
For k = 0 To 51  'ѭ������52�����ظ������������һ������shuffleDeck
    If uBond > 0 Then
        paixu = Int((Rnd + Right(Timer, 3) / 100) * uBond)   '[0,uBond-1] ֮���������
        If paixu > 51 Then
            paixu = Int(Rnd * uBond)
        End If
        shuffleDeck(k) = wushier(paixu) '�������ֵһ�����ŵ���������
        'Debug.Print shuffleDeck(k)
        wushier(paixu) = wushier(uBond - 1) '�����һ��ֵŲ���������λ��
        uBond = uBond - 1                  '���������һ����
    End If
Next k
End Function
Function deal()
deckCard = 0
For player = 0 To 4 'Ŀǰ����֧�������
    For handCard = 0 To 1   'preflop����
        hand(player, handCard) = shuffleDeck(deckCard)
        deckCard = deckCard + 1
    Next handCard
Next player
Range("d15") = deck(hand(0, 0))
Range("e15") = deck(hand(0, 1))
End Function
Function cal()

End Function
Function raise()

End Function
Function check()

End Function
Function fold()

End Function
Function flop()
For i = 0 To 2
    Cells(9, 3 + i) = deck(shuffleDeck(deckCard))
    communityCards(i) = shuffleDeck(deckCard)
    deckCard = deckCard + 1
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

For player = 0 To 0
    i = 0
    For handCard = 0 To 1
        zongpai(i) = hand(player, handCard)
        i = i + 1
    Next handCard
    For tableCard = 0 To 4
        zongpai(i) = communityCards(tableCard)
        i = i + 1
    Next tableCard
    
    Call insertSort
'    For i = 0 To 6
'    Debug.Print zongpai(i), deck(zongpai(i))
'    Next i
    'Debug.Print player; ":", pattern(player)
    Call rules '��������
Next player
End Function
Function insertSort()
'v1.0   ���ư��յ����Ӵ�С���Ӻ��ҵ���Ƭ����
For i = 0 To 6
    For j = i + 1 To 6
        If j > 6 Then
            Exit For
        End If
        
        rankZj = zongpai(j) Mod 13
        suitZj = Int(zongpai(j) / 13)
        
        rankZi = zongpai(i) Mod 13
        suitZi = Int(zongpai(i) / 13)
        
        If rankZj > rankZi Then '�ȱ��Ƶĵ���
            temp = zongpai(j)
            zongpai(j) = zongpai(i)
            zongpai(i) = temp
        ElseIf rankZj = rankZi Then '��ͬ�ͱȻ�ɫ
            If suitZj > suitZi Then
                temp = zongpai(j)
                zongpai(j) = zongpai(i)
                zongpai(i) = temp
            End If
        End If
    Next j
Next i
End Function
Function zctex()
For i = 0 To 100
Call TexasHoldem
Next i
End Function
Function rules()
'v0.2   ���ж��Ƶ���rankʱ����֤ÿ��������λ�������ַ�����ʾ��00��2,12��A
'       ���¸�д��if���������ܹ��ж�ͬ����˳��985
'v0.1 �ж�ͬ��˳��ʧ��
'chr(48)="0"
Dim typePat(9) '0-9ʮ��ͳ������ɵ�����
Dim suits(3) 'ͳ����7�������������ɫ������
Dim flushCards(3) '�ĸ���ɫ������������
Dim straightCards(6) 'ͳ��˳��
Dim sameCards(6) 'ͳ����7�����������ͬ������

For i = 0 To 9
    typePat(i) = ""
Next i
For i = 0 To 3
    suits(i) = 0
Next i
For i = 0 To 3
    flushCards(i) = ""
Next i
For i = 0 To 6
    straightCards(i) = ""
Next i
For i = 0 To 6
    sameCards(i) = ""
Next i
straightSuits = 0 '�����ж�˳�ӵĻ�ɫ
straightFlush = 0

countStraightFlush = 0 '����ͬ��˳�ĸ���
countStraight = 0 '����˳�ӵĸ���
straightCards = "" '�ռ�˳���ƣ���kqjt9,1110090807,10λ�ַ�

pattern(player) = "" '�������ͣ����ͺſ�ͷ������5���ƣ�11λ�ַ�����ʼ�ͬ��˳����91211100908


For i = 0 To 6
    
    rankZi = zongpai(i) Mod 13 '�����е�i���Ƶĵ���,00��2,��08��T��12��A
    If rankZi < 10 Then
        rankZi = "0" & rankZi
    End If
    suitZi = Int(zongpai(i) / 13)
    
    suits(suitZi) = suits(suitZi) + 1
     '����Ļ��ǵ�Ҫ����Ϊ������ܳ�С��ͬ��˳ '����Ĳ�Ҫ�ˣ���Ϊ���ǰ������ź���ģ������С�ƿ��Բ���
    flushCards(suitZi) = flushCards(suitZi) & rankZi '����ͬ������
    
    If i = 6 Then
        Exit For
    End If
    
    j = i + 1
    rankZj = zongpai(j) Mod 13 '00��2,12��A
    If rankZj < 10 Then
        rankZj = "0" & rankZi
    End If
    suitZj = Int(zongpai(j) / 13) '0�Ƿ�ƬDiamonds,3�Ǻ���Spades
    
    If rankZi - rankZj = 1 Then   '�ж��Ƿ�˳�Ӷ����ڷ�Χ��
        countStraight = countStraight + 1 'i�Ƶ�˳�Ӵ���
        straightCards = straightCards & rankZi '�ռ�˳�ӵ���
        straightSuits = straightSuits + suitZi - suitZj 'ͳ�ƻ�ɫ���������ͬ��ɫ��=0
        
        If countStraight = 4 And straightSuits = 0 Then   '4rankZi+1rankZj 5�������ţ�������˳��
                                    '���Ǹ�ͬ��˳
            If suitZi = 3 Then '��royal,���ҵ�ͬ��˳
                    pattern(player) = 9 & straightCards & rankZj
            Else '��ͨͬ��˳
                    pattern(player) = 8 & straightCards & rankZj
            End If
        ElseIf countStraight = 4 Then
            pattern(player) = 4 & straightCards 'ֻ��˳��
        End If
        
    Else
        countStraight = 0
        straightCards = ""
    End If
    
    ElseIf rankZj = rankZi Then 'ͳ����ͬ����
        sameCards(i) = sameCards(i) + 1
        If sameCards(i) = 4 Then
            isFour = True
    End If
Next i


For suitZi = 0 To 3 '�ĸ���ɫ
    If Len(flushCards(suitZi)) >= 10 Then '�������������ͬ������ѡ��ͬ��
    Debug.Print flushCards(suitZi), suitZi
        For i = 1 To Len(flushCards(suitZi))
            preCard = Mid(flushCards(suitZi), i, 2) '��ǰ��
            If i + 2 <= Len(flushCards(suitZi)) Then
                posCard = Mid(flushCards(suitZi), i + 2, 2) '��һ����
                If preCard - posCard = 1 Then '�����˳��
                    countStraightFlush = countStraightFlush + 1 '���м���ͬ��˳��
                    pattern(player) = pattern(player) & preCard
                    If countStraightFlush = 4 Then 'pre�ǵ����ţ�pos�ǵ����ţ����ȹ��ˣ����ӽ�ȥ�ˣ�����˳��,�ͰѺ�һ���Ƽӽ�ȥ
                        If Left(pattern(player), 2) = 12 And suitZi = 3 Then '��ͷ��A,������3�Ż�ɫ�����ң����жϻʼ�ͬ��˳��ͬ��˳
                            pattern(player) = 9 & pattern(player) & posCard '�ǻʼ�ͬ��˳9Royal Flush
                            Debug.Print pattern(player)
                            Exit Function
                        Else
                            pattern(player) = 8 & pattern(player) & posCard '8straight flush
                            Debug.Print pattern(player)
                            Exit Function
                        End If
                    End If
                Else
                    countStraight = 0
                    pattern(player) = ""
                End If
                
                If i + 3 = Len(flushCards(suitZi)) Then 'AKQJ9,�������һ���˶��Ҳ���9,8
                    'goto �ж�7 four 6 full
                    pattern(player) = 5 & Left(flushCards(suitZi), 10) '��������ͬ���� 5flush
                    Debug.Print pattern(player), Len(pattern(player))
                    If Len(pattern(player)) > 11 Then
                        Debug.Print "long"
                    End If
                    Exit Function
                End If
            End If
            i = i + 1
        Next i
    End If
Next suitZi



        'Debug.Print pattern(player)
    

'pattern(player) = Application.WorksheetFunction.Max(typePat)
'final:
'9royal flush:       sT,sJ,sQ,sK,sA(only)
'8straight flush:    56789s
'74 of a kind:       AAAAx
'6full house:        AAAKK
'5flush:             479TKs
'4straight:          56789o  'bicycle:A2345  'broadway:TJQKA
'33 of a kind:       AAAxx
'2two pairs          AAKKx
'1one pair           AAxxx
'0high card          xxxxx

    



'hand:
'suited
'off suited
'set:pocket pair+hit flop
'connectors:45,9T,TJ
'draw hand:wait for flush or straight
'pocket pair:22,33,44 in hand
'American Airlines:AA pocket pair
'cowboys:KK
'Nuts:you are the strongest, AA hit AA6J8


'public:
'rainbow:flop off suited

'
'Pot:chips on table
'Outs:
'Bluff
'Slowplay
End Function
Function ceee()
Dim beu(5)
bii = "51"
For i = 0 To 5
beu(i) = beu(i) & bii
ad = 1 = 1
Debug.Print ad
Next
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

