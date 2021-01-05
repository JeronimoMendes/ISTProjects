# FP 2020-21 2nd Project - LEIC-T
# Simplified Nine men's morris game against computer (with rules)
# Author: Jeronimo Mendes ist199086

# TAD Posicao
# Representation: position = [c, l] (list), c: (0, 1, 2), l:(0, 1, 2)

def cria_posicao(c, l):
    """
    Creates a position object.
    Input: c (str), l (str). Column and Line
    Ouput: position (tuple)
    """
    if c not in ["a", "b", "c"] or l not in ["1", "2", "3"]:
        raise ValueError("cria_posicao: argumentos invalidos")

    column = {"a": 0, "b": 1, "c": 2}

    return (column[c], int(l)-1)


def cria_copia_posicao(pos):
    """
    Returns a copy of a position
    """
    return tuple(i for i in pos)


def obter_pos_c(pos):
    """
    Returns the column of a position.
    Input: position
    Output: str
    """
    column = {0: "a", 1: "b", 2: "c"}

    return column[pos[0]]


def obter_pos_l(pos):
    """
    Returns the line of a position.
    Input: position
    Output: str
    """
    return str(pos[1] + 1)


def eh_pos_str(pos_str):
    """
    Validates if a string is a string representation of a position.
    """
    return pos_str in ("a1", "a2", "a3", "b1", "b2", "b3", "c1", "c2", "c3")


def eh_posicao(pos):
    """
    Validates if a given input is a position object
    """
    return type(pos) == tuple and len(pos) == 2\
        and (pos[0] and pos[1]) in [0, 1, 2]\
            and type(pos[0]) == type(pos[1]) == int


def posicoes_iguais(p1, p2):
    """
    Checks if two positions are the same.
    Input: p1, p2 (position)
    Output: bool. True if equal, False otherwise
    """
    if not eh_posicao(p1) or not eh_posicao(p2): return False
    return p1 == p2


def posicao_para_str(pos):   
    """
    Returns a string representing a position
    """ 
    return obter_pos_c(pos) + obter_pos_l(pos)


def order_pos(lst: list):
    """
    Receives a list of positions in str form and orders them. 
    Input: lst (list or tuple) 
    Output: list
    """
    # switchs columns and lines of pos and sorts the list prioritising lines
    return [i[::-1] for i in sorted([i[::-1] for i in lst])] 


def str_to_pos(s):
    """
    Creates a position given a string representation of a position.
    Input: s (str)
    Output: position
    """
    return cria_posicao(s[0], s[1])


def adj_c_l(c_pos, l_pos):
    """
    Returns adjacent columns and lines of a given position. 
    Auxiliar of obter_posicoes_adjacentes() 
    Input: c_pos: str; l_pos: str
    Output: tuple
    """

    columns, lines = ("a", "b", "c"), ("1", "2", "3")
    c_index, l_index = columns.index(c_pos), lines.index(l_pos)

    # (lambda x: x > -1 and x < 3) filters elements of the list
    #   that are out of bounds
    # (lambda x: lines[x]) maps elements of the filtered list to the
    #   corresponding string representation, same with (lambda x: columns[x])
    # (lambda x: x != c_pos) filters out elements that are equal to the
    #   c_pos, same goes with (lambda x: x != l_pos)

    adj_c = list(filter(lambda x: x != c_pos, map(lambda x: columns[x],\
    filter(lambda x: x > -1 and x < 3, [c_index - 1, c_index,c_index + 1]))))

    adj_l = list(filter(lambda x: x != l_pos, map(lambda x: lines[x],\
    filter(lambda x: x > -1 and x < 3 , [l_index - 1, l_index,l_index + 1]))))

    return adj_c, adj_l
    


def obter_posicoes_adjacentes(pos):
    """
    Returns a tuple with the adjacent positions of a given position.
    Input: pos (position)
    Output: tuple 
    """

    c_pos, l_pos = obter_pos_c(pos), obter_pos_l(pos)

    adj_c, adj_l = adj_c_l(c_pos, l_pos)

    res = [posicao_para_str(cria_posicao(adj_c[i], l_pos))\
        for i in range(len(adj_c))]

    pos_str = posicao_para_str(pos)
    excep1, excep2 = ["a1", "c1", "a3", "c3"], ["a1", "c1", "a3", "c3"]

    if pos_str in excep1: res.append("b2")   
    if pos_str == "b2": res += excep2

    lista_pos = order_pos(res + [posicao_para_str\
        (cria_posicao(c_pos, adj_l[i])) for i in range(len(adj_l))])

    return tuple(str_to_pos(i) for i in lista_pos)


# TAD Piece
# Representation: piece = "p", p: ([1], [-1], [0]) (list)

def cria_peca(s):
    """
    Creates a piece.
    Input: string - "X", "O" or " "
    Return: piece 
    """
    if type(s) != str or s not in ["X", "O", " "]:
        raise ValueError("cria_peca: argumento invalido")

    peca_TAD = {"X": [1], "O": [-1], " ": [0]}

    return peca_TAD[s]


def cria_copia_peca(piece):
    """
    Creates a copy of a piece.
    Input: piece
    Output: piece
    """
    return piece.copy()


def eh_peca(piece):
    """
    Checks if input is a piece or not
    Input: piece: anything
    Output: bool: True if input is piece, False otherwise
    """
    return type(piece) == list and len(piece) == 1 and piece[0] in [1, -1, 0]


def pecas_iguais(p1, p2):
    """
    Checks if two pieces are equal
    Input: p1 - piece, p2 - piece
    Outpu: bool - True if equal, False otherwise
    """
    if not eh_peca(p1) or not eh_peca(p2): return False
    return p1 == p2


def peca_para_str(piece):
    """
    Return a string representig the piece
    Input: piece
    Output: str
    """
    str_peca = {1: "X", -1: "O", 0: " "}
    return "[{}]".format(str_peca[piece[0]])


def eh_str_peca(s):
    """
    Checks if a given string is a valid piece string representation.
    Input: s (str)
    Output: bool. True if valid, False otherwises
    """
    return s in ("[ ]", "[X]", "[O]")


def peca_para_inteiro(piece):
    """
    Returns an integer representing the piece
    Input: piece
    Output: int - (1, -1, 0)
    """
    piece_str = peca_para_str(piece)

    if piece_str == "[X]": return 1
    elif piece_str == "[O]": return -1
    else: return 0


# TAD Board
# Representation: dictionary
#                 board = {posicao_para_str(pos):peca_para_str(piece), ...},
#                 pos: position 


def cria_tabuleiro():
    """
    Creates a plain board.
    """
    return {posicao_para_str(cria_posicao(c,l)): peca_para_str(cria_peca(" "))\
        for l in ["1", "2", "3"] for c in ["a", "b", "c"]}


def cria_copia_tabuleiro(tab):
    """
    Creates a copy of a board.
    """
    return {pos:tab[pos] for pos in tab}


def obter_peca(tab, pos):
    """
    Returns the piece in a certain position of the board.
    Input: tab - board, pos - position
    Output: piece
    """
    return cria_peca(tab[posicao_para_str(pos)][1])


def obter_vetor(tab, s):
    """
    Returns a vector of the board.
    Input: tab - board, s - column or line ("a", "b", "c", "1", "2", "3")
    Ouput: tuple - vector with pieces
    """
    # lambda x: x[::-1] : (a1 -> 1a) makes it possible to sort in respect
    # to the right way of reading the board (left right, up down)
    return tuple(cria_peca(tab[pos][1]) for pos in\
        sorted(tab.keys(), key = lambda x: x[::-1]) if s in pos)


def coloca_peca(tab, piece, pos):
    """
    Places a piece onto the board.
    Input: tab - board, piece, pos - position
    Output: board
    """
    tab[posicao_para_str(pos)] = peca_para_str(piece)
    return tab


def remove_peca(tab, pos):
    """
    Removes a piece from the board.
    Input: tab - board, pos - position
    Output: board
    """
    tab[posicao_para_str(pos)] = peca_para_str(cria_peca(" "))
    return tab


def move_peca(tab, pos1, pos2):
    """ 
    Moves a piece that's on the board.
    Input: tab - board, pos1 - initial position, pos2 - final position
    Ouput: board
    """
    piece = obter_peca(tab, pos1)
    remove_peca(tab, pos1)
    coloca_peca(tab, piece, pos2)

    return tab


def check_win(v1, piece):
    """
    Checks win for a given piece in a given vector.
    Input: v1 (tuple), piece 
    Output: bool. True if there's a win, False otherwise 
    """
    for i in v1: 
        if not pecas_iguais(i, piece): return False

    return True


def pieces_counter(board):
    """
    Counts the number of pieces of each kind.
    Input: board
    Ouput: tuple
    """
    nr_X, nr_O = 0, 0
    for pos in board:
        pieca = board[pos]
        if pieca == "[X]": nr_X += 1
        if pieca == "[O]": nr_O += 1

    return nr_X, nr_O

def winners_counter(board):
    """
    Counts the winners on a board.
    Input: Board
    Ouput: int
    """
    winners = 0
    for cl in ["a", "b", "c", "1", "2", "3"]:
        vetor = obter_vetor(board, cl)
        if check_win(vetor, cria_peca("X")) or check_win(vetor, cria_peca("O")):
            winners += 1

    return winners


def eh_tabuleiro(tab):
    """
    Checks if the input is a board.
    Input: tab - anything
    Output: bool - True if input is board, False otherwise
    """
    if type(tab) != dict or len(tab) != 9: return False

    for pos in tab:
        if pos not in cria_tabuleiro(): return False

    nr_X, nr_O = pieces_counter(tab)

    if nr_X > 3 or nr_O > 3 or abs(nr_X - nr_O) > 1: return False

    if winners_counter(tab) > 1: return False

    return True


def eh_posicao_livre(tab, pos):
    """
    Checks if given position is free of pieces.
    Input: tab - board, pos - position
    Output: bool - True if position is free, False otherwise
    """
    return  tab[posicao_para_str(pos)] == peca_para_str(cria_peca(" "))


def tabuleiros_iguais(tab1, tab2):
    """
    Checks if two board are equal.
    """
    if not eh_tabuleiro(tab1) or not eh_tabuleiro(tab2): return False
    return tab1 == tab2


def tabuleiro_para_str(tab):
    """
    Returns a string representing the board.
    Input: tab - board
    Ouput: str
    """
    pos = [tab[pos] for pos in sorted(tab.keys(), key = lambda x: x[::-1])]

    res = "   a   b   c\n"
    res += "1 {}-{}-{}\n".format(pos[0], pos[1], pos[2])
    res += "   | \ | / |\n"
    res += "2 {}-{}-{}\n".format(pos[3], pos[4], pos[5])
    res += "   | / | \ |\n"
    res += "3 {}-{}-{}".format(pos[6], pos[7], pos[8])

    return res


def tuplo_para_tabuleiro(tuplo):
    """
    Converts a tuple into a board.
    Input: tuple
    Ouput: board
    """
    tab = cria_tabuleiro()
    col = ("a", "b", "c")

    for nline, line in enumerate(tuplo):
        for npos, pos in enumerate(line):
            if pos == 0:
                coloca_peca(tab, cria_peca(" "), cria_posicao(col[npos],\
                    str(nline+1)))
            if pos == 1:
                coloca_peca(tab, cria_peca("X"), cria_posicao(col[npos],\
                    str(nline+1)))
            if pos == -1:
                coloca_peca(tab, cria_peca("O"), cria_posicao(col[npos],\
                    str(nline+1)))

    return tab


def obter_ganhador(tab):
    """
    Checks for winner or draw. Returns piece representing it.
    Input: tab - board
    Ouput: piece
    """
    for cl in ["a", "b", "c", "1", "2", "3"]:
        vetor = obter_vetor(tab, cl)

        if check_win(vetor, cria_peca("X")): return cria_peca("X")
        if check_win(vetor, cria_peca("O")): return cria_peca("O")

    return cria_peca(" ")


def obter_posicoes_livres(tab):
    """
    Returns free positions on a board.
    Input: tab - board
    Output: tuple (of free positions)
    """
    res = ()
    for l in ("1", "2", "3"):
        for c in ("a", "b", "c"):
            pos = cria_posicao(c, l)
            if eh_posicao_livre(tab, pos): res += pos,

    return res


def obter_posicoes_jogador(tab, piece):
    """
    Returns tuple with positions of a piece.
    Input: tab - board, piece
    Ouput: tuple (of free positions of given piece)
    """
    res = ()
    for l in ("1", "2", "3"):
        for c in ("a", "b", "c"):
            pos = cria_posicao(c, l)
            if pecas_iguais(obter_peca(tab, pos), piece): res += pos,

    return res

# Additional functions

def placing_phase(tab):
    """
    Returns True if game in placing pieces phase, False if in moving phase
    Input: tab: board object
    Output: bool
    """
    if len(obter_posicoes_livres(tab)) == 3: return False

    return True
    

def possible_all(tab, piece):
    """
    Returns a list of possible moving squares for the player
    Input: tab: Board object
           piece: Piece object 
    Output: list of strings
    """
    return [posicao_para_str(p2) for p1 in obter_posicoes_jogador(tab, piece)\
         for p2 in obter_posicoes_adjacentes(p1) if eh_posicao_livre(tab, p2)]


def possible_pos(tab, pos):
    """
    Returns a list of possible moving squares for the player
    in a certain position
    Input: tab: Board object
           piece: Piece object 
    Output: list
    """
    return [posicao_para_str(pos) for pos in obter_posicoes_adjacentes(pos)\
             if eh_posicao_livre(tab, pos)]


def moving_phase_auxiliar(tab, piece, pos1_pos2):

    pos1 = cria_posicao(pos1_pos2[0], pos1_pos2[1])
    pos2 = cria_posicao(pos1_pos2[2], pos1_pos2[3])

    possible_pos2 = possible_pos(tab, pos1)
    possible_plays = possible_all(tab, piece) 

    return pos1, pos2, possible_pos2, possible_plays


def moving_phase_validator(pos1_pos2):
    return len(pos1_pos2) == 4 and eh_pos_str(pos1_pos2[:2])\
         and eh_pos_str(pos1_pos2[2:])


def obter_movimento_manual(tab, piece):
    """
    Gets movement from player.
    Input: tab - board, piece
    Output: tuple (position) or (position, position)
    """

    if placing_phase(tab):
        pos = input("Turno do jogador. Escolha uma posicao: ")
        if len(pos) != 2 or not eh_pos_str(pos):
            raise ValueError("obter_movimento_manual: escolha invalida")

        pos = cria_posicao(pos[0], pos[1])
        if eh_posicao_livre(tab, pos):
            return pos,

        raise ValueError("obter_movimento_manual: escolha invalida")

    pos1_pos2 = input("Turno do jogador. Escolha um movimento: ")
    if not moving_phase_validator(pos1_pos2):
        raise ValueError("obter_movimento_manual: escolha invalida")

    pos1, pos2, possible_pos2, possible_plays = moving_phase_auxiliar\
                                                (tab, piece, pos1_pos2)

    if pecas_iguais(obter_peca(tab, pos1), piece) and \
        posicao_para_str(pos2) in possible_pos2:
        return pos1, pos2
    if not possible_plays and posicoes_iguais(pos1, pos2):
        return pos1, pos2
        
    raise ValueError("obter_movimento_manual: escolha invalida")


def switch_piece(piece):
    """
    Returns opponent's piece
    Input: piece: piece object
    Output: piece: piece object
    """
    if peca_para_inteiro(piece) == 1:
        return cria_peca("O")
    else: return cria_peca("X") 


def vetor_piece_counter(vetor, piece):
    """
    Counts the pieces in a given vector
    Input: vetor: tuple; piece: piece
    Output: int
    """
    n = 0
    for piece2 in vetor:
        if pecas_iguais(piece, piece2): n += 1

    return n


def vetor_get_index(vetor, piece):
    """
    Gets the indeex of the first occurrence of a piece in a given vector
    Input: vetor: tuple; piece: piece
    Output: int
    """
    for index, piece2 in enumerate(vetor):
        if pecas_iguais(piece, piece2): return index

def check_two_in_line(tab, piece):
    """
    Checks for two in a line on the board for a piece. 
    Returns position if there is one, False if not.
    Input: tab: Board object
           piece: Piece object
    Output: pos: Position object OR False
    """
    cl = ("1", "2", "3", "a", "b", "c")
    for i in cl: 
        vetor = obter_vetor(tab, i)

        if vetor_piece_counter(vetor, piece) == 2:
            if vetor_piece_counter(vetor, cria_peca(" ")):
                if i in "abc":
                    l = str(vetor_get_index(vetor, cria_peca(" ")) + 1)
                    return cria_posicao(i, l)
                else:
                    dic = {0:"a", 1:"b", 2:"c"}
                    c = dic[vetor_get_index(vetor, cria_peca(" "))]
                    return cria_posicao(c, i)

    return False


def check_corner(tab):
    """
    Checks for free corners.
    Input: tab: Board object
    Output: Position object or Bool
    """
    corners = (("a1"), ("c1"), ("a3"), ("c3"))

    for c in corners:
        corner = cria_posicao(c[0], c[1])
        if eh_posicao_livre(tab, corner): return corner

    return False


def check_sides(tab):
    """
    Checks for free side position.
    Input: tab: Board object
    Output: Position object or Bool    
    """
    sides = (("b1"), ("a2"), ("c2"), ("b3"))

    for side in sides:
        side = cria_posicao(side[0], side[1])
        if eh_posicao_livre(tab, side): return side

    return False


def board_value(tab):   
    """
    Returns board value. 1 if X winner, -1 if O winner, 0 if draw
    Input: tab: Board object
    Output: int => (-1, 0, 1)
    """
    cl = ("1", "2", "3", "a", "b", "c")
    for i in cl: 
        vetor = obter_vetor(tab, i)

        if vetor_piece_counter(vetor, cria_peca("X")) == 3: return 1
        if vetor_piece_counter(vetor, cria_peca("O")) == 3: return -1

    return 0


def placing_phase_move(tab, piece):
    """
    Returns best move during placing phase.
    Input: tab - board, piece
    Ouput: position
    """
    win = check_two_in_line(tab, piece)
    loss = check_two_in_line(tab, switch_piece(piece))

    if win: return win # Checks for win

    if loss: return loss # Checks for loss

    middle_pos = cria_posicao("b", "2")
    if eh_posicao_livre(tab, middle_pos): return middle_pos

    corner = check_corner(tab)
    if corner: return corner
    # There's always a free side position if none of above checks
    return check_sides(tab)


def first_player_piece(tab, piece):
    """
    Returns the first position of a player in the board.
    Input: tab - board, piece
    Ouput: position
    """
    return obter_posicoes_jogador(tab, piece)[0]


def update_best(piece, new_result, new_seq, best_seq, best_result):
    """
    Conditional to update best_result and best_seq in the minimax function.
    """
    return best_seq == [None] or (pecas_iguais(piece, cria_peca("X"))\
         and new_result > best_result) or (pecas_iguais(piece, cria_peca("O"))\
              and new_result < best_result)


def recursive_part_minimax(tab, piece, depth, seq):
    """
    Recursive part of the minimax algorithm. Returns the best sequence and
    result in a given board, for a given piece with a certain depth.
    """
    best_seq = [None]
    best_res = -peca_para_inteiro(piece)
    pos_piece = obter_posicoes_jogador(tab, piece)
    possible_all_plays = [possible_pos(tab, pos) for pos in pos_piece]

    for pos1 in pos_piece:
        possible_pos_plays = possible_pos(tab, pos1)

        if not possible_pos_plays and not possible_all_plays: 
            possible_pos_plays.append(posicao_para_str(pos1))
         
        for pos2 in possible_pos_plays:
            pos2 = cria_posicao(pos2[0], pos2[1])
            new_board = cria_copia_tabuleiro(tab)
            move_peca(new_board, pos1, pos2)

            new_res, new_seq = minimax(new_board, switch_piece(piece),\
            depth - 1, seq + [posicao_para_str(pos1) + posicao_para_str(pos2)])
            
            if update_best(piece, new_res, new_seq, best_seq, best_res):
                best_res, best_seq = new_res, new_seq
    return best_res, best_seq

def minimax(tab, piece, depth, seq):
    """
    Recursive function to determine the best move for a given piece in a board 
    limited by depth.
    Input: tab (board); piece; depth (int); seq (list)
    Ouput: tab_value(draw, lose or win); seq(sequence of best moves)
    """
    tab_value = board_value(tab)

    if depth == 0 or tab_value != 0:
        return tab_value, seq

    return recursive_part_minimax(tab, piece, depth, seq)
            

def easy_mode(tab, piece):
    """
    Executes the procedure for the easy mode.
    Input: tab(board); piece
    Ouput: tuple 
    """
    pieces = obter_posicoes_jogador(tab, piece)

    for pos in pieces:
        possible_plays_pos = possible_pos(tab, pos)
        if possible_plays_pos:
            return posicao_para_str(pos), possible_plays_pos[0]

    return posicao_para_str(pieces[0]), posicao_para_str(pieces[0])


def normal_mode(tab, piece):
    """
    Executes the procedure for the easy mode.
    Input: tab(board); piece
    Ouput: tuple 
    """
    minimax_play = minimax(tab, piece, 1, [])
    if minimax_play[0] != peca_para_inteiro(piece):
        return easy_mode(tab, piece)
    
    return minimax_play[1][0][:2], minimax_play[1][0][2:]


def hard_mode(tab, piece):
    """
    Executes the procedure for the easy mode.
    Input: tab(board); piece
    Ouput: tuple 
    """
    minimax_play = minimax(tab, piece, 5, [])

    if not minimax_play[1]:
        return_piece = posicao_para_str(first_player_piece(tab, piece))
        return return_piece, return_piece

    return minimax_play[1][0][:2], minimax_play[1][0][2:]


def obter_movimento_auto(tab, piece, mode):
    """
    Fetchs the moves of 3 different difficulties (easy, normal, hard).
    Input: tab (board), piece, mode (str) : "facil", "normal" and "dificil"
    Output: tuple 
    """

    if placing_phase(tab):
        return placing_phase_move(tab, piece),

    if mode == "facil": 
        return tuple(str_to_pos(i) for i in easy_mode(tab, piece))

    if mode == "normal":
        return tuple(str_to_pos(i) for i in normal_mode(tab, piece))

    if mode == "dificil":
        return tuple(str_to_pos(i) for i in hard_mode(tab, piece))


def is_mode(mode):
    """
    Checks if a given input is a valid mode
    Input: anything
    Output: bool. True if it is a mode, False otherwise
    """
    return mode in ("facil", "normal", "dificil")


def playing_round(tab, human_piece, bot_piece, mode, current_player):
    """
    Registers the play from the current player in the board. Asks for input if
    human player is the current player.
    Input: tab (board), human_piece (piece), bot_piece (piece), mode (str)
           current_player (piece)
    """

    if pecas_iguais(human_piece, current_player):
            move = obter_movimento_manual(tab, human_piece)
    else:
        print("Turno do computador ({}):".format(mode))
        move = obter_movimento_auto(tab, bot_piece, mode)

    if placing_phase(tab):
        move = list(move)
        coloca_peca(tab, current_player, move[0])
    else:
        move_peca(tab, move[0], move[1])

    print(tabuleiro_para_str(tab))


def moinho(human, mode):
    """
    Main game function. Enables to play a full game with a specific difficulty.
    Returns the result of the game ("[X]" or "[O]")
    Input: human (str) : "[X]" or "[O]"; 
           mode (str): "facil", "normal" and "dificil"
    Return: str 
    """
    if not is_mode(mode) or human not in ("[O]", "[X]"):
        raise ValueError("moinho: argumentos invalidos")

    human_piece = cria_peca(human[1])
    bot_piece = switch_piece(human_piece)
    tab = cria_tabuleiro()
    current_player = cria_peca("X")

    print('Bem-vindo ao JOGO DO MOINHO. Nivel de dificuldade {}.'.format(mode))
    print(tabuleiro_para_str(tab))
    
    while board_value(tab) == 0:
        
        playing_round(tab, human_piece, bot_piece, mode, current_player)

        current_player = switch_piece(current_player)

    return "[X]" if board_value(tab) == 1 else "[O]"

