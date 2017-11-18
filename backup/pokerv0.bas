Attribute VB_Name = "poker"
Dim hand(5, 2)
Dim deck(52)
Dim suit
Dim rank
Dim shuffleDeck(52) 'ϴ�õ���
Dim deckCard    'dealed cards
Dim communityCards(5)  'cards on table
Dim rngMoney As Object
Dim rngFlops As Object
Dim rngTurn As Object
Dim rngRiver As Object
Function TexasHoldem()

Cells(16, 3) = "chips:"
Set rngMoney = Cells(16, 4)
Set rngFlops = Range("c9:e9")
Set rngTurn = Cells(9, 6)
Set rngRiver = Cells(9, 7)
Call prepareDeck
rngMoney = "$1000"
Call shuffle    'ϴ��
Call deal       '����
'preflop

Call flop

Call turn

Call river

Call compareCards
End Function
Function prepareDeck()
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
    wushier(k) = k 'һ��0-51������
Next k
uBond = 52
lBond = 0
For k = 0 To 51  'ѭ������52�����ظ������������һ������shuffleDeck
    If uBond > 0 Then
        paixu = Int(Rnd * uBond)     '[0,uBond-1] ֮���������
        shuffleDeck(k) = wushier(paixu) '�������ֵһ�����ŵ���������
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
Dim zongpai(7)
For player = 0 To 0
    i = 0
    For handCard = 0 To 1
        zongpai(i) = hand(player, handCard)
        i = i + 1
    Next handCard
    For i = 2 To 6
        zongpai(i) = communityCards(i - 2)
    Next i
    For i = 0 To 6
    Debug.Print zongpai(i); "compare"
    Next
Next
End Function
Sub c()
Call TexasHoldem
End Sub
Function rules()

'final:
'royal flush:       sT,sJ,sQ,sK,sA
'straight flush:    56789s
'4 of a kind:       AAAAx
'full hose:         AAAKK
'flush:             479TKs
'straight:          56789o  'bicycle:A2345  'broadway:TJQKA
'3 of a kind:       AAAxx
'two pairs          AAKKx
'one pair           AAxxx
'high card          xxxxx

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
Function cccee()
Dim b(5)
a = Array(1, 2, 1, 4, 5)
u = 5
l = 0
For i = 0 To 4
    ci = Int(Rnd * u + l)
    b(i) = a(ci)
    a(ci) = a(l)
    l = l + 1
    u = u - 1
Next i
'For i = 0 To 4

End Function
