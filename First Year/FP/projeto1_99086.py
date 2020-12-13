# FP 2020-21 Projecto 1 - LEIC-T
# Jogo do galo vs computador com regras.
# Autor: Jeronimo Mendes ist199086

def eh_tabuleiro(tab: tuple):
    """
    Verifica se um tabuleiro representa um jogo do galo.

    Param: tab(tuplo): representa um tabuleiro.

    Return: Bool: True se for tabuleiro valido, False senao.
    """
    if type(tab) != tuple or len(tab) != 3: 
        return False

    for linha in tab: 
        if type(linha) != tuple or len(linha) != 3: 
            return False
        for casa in linha:
            if casa != 0 and casa != 1 and casa != -1\
                or type(casa) != int: 
                return False

    return True 


def eh_posicao(pos: int):
    """
    Verifica a validade de uma posicao

    Param: pos(int): Posicao a ser verificado

    return: Bool: True se for valida, False senao
    """
    if type(pos) != int:
        return False

    return  (pos > 0 and pos < 10)


def eh_jogador(nr: int):
    """
    Verifica se parametro corresponde a um jogador
    Param: nr(int): numero a ser testado

    Return: bool: True se for um jogador, False senao
    """

    return False if (type(nr) != int or nr not in [-1, 1]) else True


def obter_linha(tab: tuple, nr: int):
    if not eh_tabuleiro(tab) or type(nr) != int\
        or nr not in [1, 2, 3]:
        raise ValueError("obter_linha: algum dos argumentos e invalido")

    return tab[nr - 1]


def obter_coluna(tab: tuple, nr: int):
    """
    Obtem um vetor coluna de um tabuleiro

    Param: tab(tuple): representacao de um tabuleiro
           nr(int): numero da coluna a obter

    Return: coluna(tuple): Vetor que representa a coluna
    """
    if not eh_tabuleiro(tab) or type(nr) != int or nr < 1 or nr > 3:
        raise ValueError("obter_coluna: algum dos argumentos e invalido")

    return tuple(casa[nr - 1] for casa in tab)


def obter_diagonal(tab: tuple, inteiro: int):
    """
    Obtem uma das diagonais do tabuleiro

    Param: tab(tuple): representacao de um tabuleiro
           inteiro(int): 1 para descendente da esquerda para a direita,
                         2 para ascendente da esquerda para a direita.

    Return: diagonal(tuple): representacao da diagonal
    """
    if not eh_tabuleiro(tab) or type(inteiro) != int or inteiro not in [1, 2]: 
        raise ValueError("obter_diagonal: algum dos argumentos e invalido")

    if inteiro == 1: 
        return tuple(linha[cont] for cont, linha in enumerate(tab))

    else:               
        # reversed() troca a primeira e ultima linha, facilitando a busca da diagonal
        return tuple(linha[cont] for cont, linha in enumerate(reversed(tab)))


def tabuleiro_str(tab: tuple):
    """
    Devolve uma cadeia de caract. que representa um tabuleiro.

    Param: tab(tuple): representacao de um tabuleiro

    Return cadeia(str): representacao de um tabuleiro em str
    """
    if not eh_tabuleiro(tab):
        raise ValueError("tabuleiro_str: o argumento e invalido")

    cadeia = ""
    cont = 0
    for linha in tab:
        for casa in range(0, 3):
            if linha[casa] == 1:
                cadeia += " X "
            elif linha[casa] == -1:
                cadeia += " O "
            else:
                cadeia += "   "

            if casa < 2:    
                cadeia += "|"
    
        if cont < 2:
            cadeia +=  "\n-----------\n"

        cont += 1

    return cadeia


def eh_posicao_livre(tab: tuple, pos: int):
    """
    Verifica se uma posicao esta livre para ser jogada

    Param: tab(tuple): representacao de um tabuleiro
           pos(int): posicao a verificar

    Return: bool: True se estiver livre, False se estiver ocupada
    """
    if not eh_tabuleiro(tab) or not eh_posicao(pos):
        raise ValueError("eh_posicao_livre: algum dos argumentos e invalido")

    coord = pos_to_coord(pos)

    return tab[coord[0]][coord[1]] == 0


def jogador_na_posicao(tab: tuple, pos: int):
    """
    Devolve o jogador na posicao.
    Param: tab(tuple): representacao de um tabuleiro
           pos(int): posicao 

    Return: int: jogador na posicao
    """
    coord = pos_to_coord(pos)
    
    return tab[coord[0]][coord[1]]


def obter_posicoes_livres(tab: tuple):
    """
    Obtem todas as posicoes livres de um tabuleiro

    Param: tab(tuple): representacao de um tabuleiro

    Return: casas_livres: tuplo de casas livres
    """
    if not eh_tabuleiro(tab):
        raise ValueError("obter_posicoes_livres: o argumento e invalido")

    # 3 * linha + (casa + 1) equivale ao nr da casa 
    return tuple(3 * linha + (casa + 1) for linha in range(0,3)\
                 for casa in range(0,3) if tab[linha][casa] == 0)


def jogador_ganhador(tab: tuple):
    """
    Verifica o estado de um jogo (vitoria ou nao)

    Param: tab(tuple): representacao de um tabuleiro

    Return: 1, -1, 0: (1, -1) se um dos jogadores ganhou e 0 se o jogo nao acabou
    """    
    if not eh_tabuleiro(tab):
        raise ValueError("jogador_ganhador: o argumento e invalido")    

    vetores_possiveis = ((-1, -1, -1), (1, 1, 1)) # vetores que sao uma vitoria
    res = -1   

    for vetor_possivel in vetores_possiveis:                                              
        if vetor_possivel == obter_diagonal(tab, 1):
            return res
        elif vetor_possivel == obter_diagonal(tab, 2): 
            return res
        for i in range(1,4): 
            if vetor_possivel == tab[i-1]:  
                return res
            elif vetor_possivel == obter_coluna(tab, i): 
                return res

        res = 1  

    return 0 


def eh_empate(tab: tuple):
    """
    Verifica se um tabuleiro tem empate

    Param: tab(tuple): representacao de um tabuleiro

    Return: bool: True se houver empate, False se nao houver.
    """
    if jogador_ganhador(tab) != 0:
        return False

    for linha in tab:
        for casa in linha:
            if casa == 0:
                return False
    
    return True


def pos_to_coord(pos: int):
    """
    Converte uma posicao na coordenada correspondente. Nao ha verificacao de param
    porque a funcao so e chamada dentro de outras funcoes onde a verificacao ja ocorreu

    Param: pos(int): posicao a ser convertida

    Return: tuplo com a coordenada
    """

    posicoes = {1:(0,0),2:(0,1),3:(0,2),4:(1,0),5:(1,1),6:(1,2),7:(2,0),8:(2,1),9:(2,2)}   

    return posicoes[pos] 


def coord_to_pos(coord:tuple):
    """
    Converte uma coordenada na posicao correspondente. Nao ha verificacao de param
    porque a funcao so e chamada dentro de outras funcoes onde a verificacao ja ocorreu

    Param: coord(tuple): coordenada a ser convertida

    Return: int com a posicao
    """
    posicoes = {(0,0):1,(0,1):2,(0,2):3,(1,0):4,(1,1):5,(1,2):6,(2,0):7,(2,1):8,(2,2):9}   

    return posicoes[coord]    


def marcar_posicao(tab: tuple, jogador: int, pos: int):
    """
    Marca a posicao num tabuleiro.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int 1 ou -1): jogador (1 ou -1)
           pos(int): posicao a marcar (0 < pos < 10)

    return: novo_tabuleiro(tuple): tabuleiro marcado com a jogada
    """
    if not eh_tabuleiro(tab) or not eh_posicao(pos) or not eh_jogador(jogador)\
        or not eh_posicao_livre(tab ,pos):
        raise ValueError("marcar_posicao: algum dos argumentos e invalido")

    coord = pos_to_coord(pos)
    linha, coluna = coord[0], coord[1]

    nova_linha = tab[linha][:coluna] + (jogador,) + tab[linha][coluna + 1:]

    novo_tabuleiro = tab[:linha] + (nova_linha,) + tab[linha + 1:]

    return novo_tabuleiro


def escolher_posicao_manual(tab: tuple):
    """
    Pede ao jogador para escolher uma posicao a jogar

    Param: tab(tuple): representacao dum tabuleiro.

    Return: pos(int): posicao que o jogador escolheu para jogar
    """
    if not eh_tabuleiro(tab):
        raise ValueError("escolher_posicao_manual: o argumento e invalido")
    pos = int(input("Turno do jogador. Escolha uma posicao livre: "))

    if not eh_posicao(pos) or not eh_posicao_livre(tab, pos):
        raise ValueError("escolher_posicao_manual: a posicao introduzida e invalida")

    return pos


def escolher_posicao_auto(tab: tuple, jogador: int, strat: str):
    """
    Retorna uma posicao dependendo da estrategia adotada.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1
           strat(str): "basico", "normal" ou "perfeito"

    Return: int: posicao escollhida pela estrategia adotada.
    """
    if not eh_tabuleiro(tab) or not eh_jogador(jogador) or\
        strat not in ["basico", "normal", "perfeito"]:
        raise ValueError("escolher_posicao_auto: algum dos argumentos e invalido")

    estrategias = {"basico": strat_basico, "normal": strat_normal, "perfeito": strat_perfeito}

    return estrategias["basico"](tab, True) if strat == "basico" \
            else estrategias[strat](tab, jogador)


def check_linhas(tab: tuple, jogador: int):
    """
    Retorna a posicao minima onde o jogador tem um 2 em linha e casa livre.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1

    return: int: posicao minima para 3 em linha. Se nao houver retorna 10
    """
    for l, linha in enumerate(tab):
        # Se a soma de uma linha for 2 ou -2 entao um dos jogadores
        # tem um 2 em linha com casa disponivel nessa linha
        if sum(linha) == 2 * jogador:
            return coord_to_pos((l, linha.index(0)))

    return 10


def check_colunas(tab: tuple, jogador: int):
    """
    Retorna a posicao minima onde o jogador tem um 2 em coluna e casa livre.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1

    return: int: posicao minima para 3 em coluna. Se nao houver retorna 10
    """   
    for i in range(1, 4):
        coluna = obter_coluna(tab, i)
        if sum(coluna) == 2 * jogador:
            return coord_to_pos((coluna.index(0), i - 1))
    
    return 10


def check_diagonais(tab: tuple, jogador: int, tipo: int):
    """
    Retorna a posicao minima onde o jogador tem um 2 em coluna e casa livre.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1
           tipo(int): tipo da diagonal (1 ou 2)

    return: int: posicao minima para 3 em coluna. Se nao houver retorna 10
    """
    diagonal = obter_diagonal(tab, tipo)
    if sum(diagonal) == 2 * jogador:
        if tipo == 1:
            return coord_to_pos((diagonal.index(0), diagonal.index(0)))
        else:
            return coord_to_pos((2 - diagonal.index(0), diagonal.index(0)))

    return 10


def dois_em_linha(tab: tuple, jogador: int):
    """
    Retorna as posicoes minimas onde o jogador tem um 2 em linha e casa livre.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1

    Return: list: lista das posicoes minimas em cada uma das 4 possibilidades
    """
    coluna = check_colunas(tab, jogador)
    linhas = check_linhas(tab, jogador)
    diagonal1 = check_diagonais(tab, jogador, 1)
    digaonal2 = check_diagonais(tab, jogador, 2)

    return [coluna, linhas, diagonal1, digaonal2]


def jogar_centro_cantos(tab: tuple, jogador, passo: bool):
    """
    Devolve posicao para jogar nos cantos, se estiverem livres.

    Param: tab(tuple): representacao dum tabuleiro.
           passo(bool): se True entao possibilita a jogada do canto oposto

    Return: int: um dos cantos para jogar
            None: Se nao houver canto para jogar
    """
    if eh_posicao_livre(tab, 5):
        return 5

    cantos = [(1,9), (3,7), (7,3), (9,1)] # pares de canto e canto oposto

    if passo:
        for canto in cantos:
            if jogador_na_posicao(tab, canto[0]) == jogador * -1:
                if eh_posicao_livre(tab, canto[1]):
                    return canto[1]

    for canto in cantos:
        if eh_posicao_livre(tab, canto[0]):
            return canto[0]
    

def strat_basico(tab: tuple, passo: bool):
    """
    Estrategia basica de jogo. Joga pelas regras 5, 7 e 8. Retorna uma posicao.

    Param: tab(tuple): representacao dum tabuleiro.
           passo(bool): Se false entao passa a frente o passo da jogada_canto

    Return: int: posicao a jogar
    """
    if passo:
        jogada_canto = jogar_centro_cantos(tab, None, False)
        if jogada_canto != None:
            return jogada_canto
        
    laterais = [2, 4, 6, 8]

    for lateral in laterais:
        if eh_posicao_livre(tab, lateral):
            return lateral


def atacar_defender_2linha(tab: tuple, jogador: int):
    """
    Ataca e defende (se nao tiver para atacar) criando um 3 em linha ou defendendo contra
    um 2 em linha.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1

    Return: int: posicao a jogar 
    """

    if min(dois_em_linha(tab, 1 * jogador)) < 10:
        return min(dois_em_linha(tab, 1 * jogador))
    
    if min(dois_em_linha(tab, -1 * jogador)) < 10:
        return min(dois_em_linha(tab, -1 * jogador))


def strat_normal(tab: tuple, jogador: int):
    """
    Estrategia normal de jogo. Joga pelas regras  1, 2, 5, 6, 7 e 8.
    Retorna uma posicao.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1

    Return: int: posicao a jogar
    """
    dois_em_linha = atacar_defender_2linha(tab, jogador)
    if dois_em_linha != None:
        return dois_em_linha

    centro_canto = jogar_centro_cantos(tab, jogador, True)


    if centro_canto != None:
        return centro_canto

    return strat_basico(tab, False)


def bifurcacao(tab: tuple, jogador: int): 
    """
    Procura possibilidades de bifurcacao num tabuleiro.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1

    Return: casas_de_bifurcacao(list): todas as casas onde existe bifurcacao,
                                       se jogada uma peca ai
    """
    casas_de_bifurcacao = []
    casas_livres = obter_posicoes_livres(tab)       
    for casa in casas_livres:
        tab_temporario = marcar_posicao(tab, jogador, casa)
        nr2_em_linha = 0 
        # Testa cada posicao livre para 
        # o caso de haver dois 2 em linha (bifurcacao)
        for i in dois_em_linha(tab_temporario, jogador):
            if i < 10:
                nr2_em_linha += 1

        if nr2_em_linha > 1:   # Ha mais do que um 2 em linha?
            casas_de_bifurcacao.append(casa)
            nr2_em_linha = 0

    return casas_de_bifurcacao


def criar_2em_linha(tab: tuple, jogador: int):
    """
    Devolve posicoes onde e possivel criar um 2 em linha.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1

    return: posicoes_possiveis(list): lista com posicoes
    """
    posicoes_possiveis = []

    for casa in range(1, 10):
        if eh_posicao_livre(tab, casa):
            tab_temporario = marcar_posicao(tab, jogador, casa)
            # Testa cada posicao livre para o caso da criacao de um
            # 2 em linha
            for i in dois_em_linha(tab_temporario, jogador):
                if i < 10:
                    posicoes_possiveis.append(i)

    return posicoes_possiveis


def bloq_bifurcacao(tab: tuple, jogador: int):
    """
    Bloqueia bifurcacoes do oponente

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1

    Return: posicao(int): posicao a bloquear
            None se nao houver nada para bloquear
    """
    oponente = jogador * -1

    bifurcacao_oponente = bifurcacao(tab, oponente)
    if bifurcacao_oponente != []:
        if len(bifurcacao_oponente) > 1:
            # Jogar para dois em linha desde que nao crie a bifurcacao para o adversario
            posicoes_2em_linha = criar_2em_linha(tab, jogador)
            posicoes_2em_linha.sort()
            if posicoes_2em_linha != []:
                for posicao in posicoes_2em_linha:
                    tab_temporario = marcar_posicao(tab, jogador, posicao)

                    bifurcacao_op_temp = bifurcacao(tab_temporario, oponente)
                    if len(bifurcacao_op_temp) == 1 and bifurcacao_op_temp[0]\
                                 != min(dois_em_linha(tab_temporario, jogador)):

                        return posicao

        return min(bifurcacao_oponente)

    return None


def strat_perfeito(tab: tuple, jogador: int):
    """
    Estrategia perfeita de jogo. Joga pelas regras 1, 2, 3, 4, 5, 7 e 8.
    Retorna uma posicao.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1

    Return: int: posicao a jogar
    """
    posicao_2em_linha = atacar_defender_2linha(tab, jogador)
    if posicao_2em_linha != None:
        return posicao_2em_linha

    bifurcacao_jogador = bifurcacao(tab, jogador)

    if bifurcacao_jogador != []:
        return min(bifurcacao_jogador)

    bloquear_bif = bloq_bifurcacao(tab, jogador)

    if bloquear_bif != None:
        return bloquear_bif
 
    return strat_normal(tab, jogador)


def turno(tab: tuple, jogador: int, modo: str):
    """
    Procede a um turno de jogo.

    Param: tab(tuple): representacao dum tabuleiro.
           jogador(int): 1 ou -1
           modo(str): "basico", "normal" ou "perfeito"

    return: novo_tab: tabuleiro modificado apos as jogadas do turno
    """
    oponente = jogador * -1

    if jogador == 1:
        novo_tab = marcar_posicao(tab, jogador, escolher_posicao_manual(tab))
        print(tabuleiro_str(novo_tab))

        if jogador_ganhador(novo_tab) != 0 or eh_empate(novo_tab):
            return novo_tab

        print("Turno do computador ({}):".format(modo))
        novo_tab = marcar_posicao(novo_tab, oponente, escolher_posicao_auto(novo_tab, oponente, modo))
        print(tabuleiro_str(novo_tab))

        return novo_tab


    else:
        print("Turno do computador ({}):".format(modo))
        novo_tab = marcar_posicao(tab, oponente, escolher_posicao_auto(tab, oponente, modo))
        print(tabuleiro_str(novo_tab))

        if jogador_ganhador(novo_tab) != 0 or eh_empate(novo_tab):
            return novo_tab

        novo_tab = marcar_posicao(novo_tab, jogador, escolher_posicao_manual(novo_tab))
        print(tabuleiro_str(novo_tab))

        return novo_tab


def jogo_do_galo(sinal: str, modo: str):
    """
    Funcao responsavel por iniciar o jogo.

    Param: sinal(str): Sinal que representa o jogador. "X" ou "O"
           modo(str): "basico", "normal" ou "perfeito"

    Return: str: Resultado do jogo. "X", "O" ou "EMPATE"
    """
    if sinal not in ["O", "X"] or modo not in ["basico", "normal", "perfeito"]:
        raise ValueError("jogo_do_galo: algum dos argumentos e invalido")

    if sinal == "X":
        jogador = 1
    else:
        jogador = -1

    tab = ((0,0,0), (0,0,0), (0,0,0))

    print("Bem-vindo ao JOGO DO GALO.")
    print("O jogador joga com '{}'.".format(sinal))

    while jogador_ganhador(tab) == 0 and not eh_empate(tab):
        tab = turno(tab, jogador, modo)

    res = jogador_ganhador(tab) 


    if res == jogador:
        return sinal
    elif res == jogador * -1:
        if jogador == 1:
            return "O"
        else:
            return "X"
    else:
        return "EMPATE"         

jogo_do_galo("X","normal")