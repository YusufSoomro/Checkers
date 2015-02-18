class Piece

  PIECES_B = [
    [1, -1],
    [1, 1]
  ]

  PIECES_W = [
    [-1, -1],
    [-1, 1]
  ]

  attr_reader :board, :color
  attr_accessor :pos, :king

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
    @king = false
  end

  # Lets a user slide diagonally, returning true if it works,
  # and false if you're breaking rules
  def perform_slide(end_pos)
    if board.empty?(end_pos) && move_diffs.include?(end_pos)
      board[end_pos] = self
      board[pos] = nil
      @pos = end_pos
      maybe_promote
      true
    else
      false
    end
  end

  # Lets a user "kill" a piece by jumping over it, returning
  # false if it breaks the rules, and true if it works
  def perform_jump(enemy_pos)
    if board.empty?(enemy_pos) || board[enemy_pos].color == color
      return false
    end

    delta_form = [enemy_pos[0] - pos[0],
                  enemy_pos[1] - pos[1]]
    new_square = [enemy_pos[0] + delta_form[0],
                  enemy_pos[1] + delta_form[1]]

    unless board.empty?(new_square) || move_diffs.include?(new_square)
      return false
    end

    board[enemy_pos] = nil
    board[new_square] = self
    board[pos] = nil
    @pos = new_square
    maybe_promote
    true
  end

  def poss_moves(directions)
    list_moves = []

    directions.each do |row, col|
      new_square = [pos[0] + row, pos[1] + col]

      if board.empty?(new_square) || board[new_square].color != color
        list_moves << new_square
      end
    end

    list_moves
  end

  def move_diffs
    if king
      poss_moves(PIECES_B + PIECES_W)
    elsif color == :B
      poss_moves(PIECES_B)
    else
      poss_moves(PIECES_W)
    end
  end

  # Promotes a piece to a king if it reaches the back row
  def maybe_promote
    if color == :B
      self.king = true if back_row?
    else
      self.king = true if back_row?
    end
  end

  # Checks if a black piece or white piece has reached
  # the back row
  def back_row?
    if color == :B
      pos[0] == 7
    else
      pos[0] == 0
    end
  end

  # Receives a move sequence. If the move sequence is
  # one move long, tries to execute a slide or a jump,
  # raising an error if either fails. If the move sequence
  # is multiple moves long, performs multiple jumps,
  # raising an error if one fails.
  def perform_moves!(move_sequence)
    if move_sequence.length == 1

      # Unless one of the moves works, raise an error.
      # If it works, return true.
      unless perform_slide(move_sequence[0]) ||
             perform_jump(move_sequence[0])
          raise InvalidMoveError.new
      else
        true
      end
    else
      # Every move must be a jump, go through each of the jumps,
      # and if one fails, then raise an error. If it works,
      # return true
      move_sequence.each do |move|
        unless perform_jump(move)
          raise InvalidMoveError.new
        else
          true
        end
      end
    end
  end

  # Dups the board and calls perform_moves! on it. If
  # something goes wrong in perform_moves!, an error
  # will be raise. If nothing goes wrong, this method
  # will return true
  def valid_move_seq?(move_sequence)
      new_board = board.deep_dup
      true if new_board[pos].perform_moves!(move_sequence)
  end

  # Performs the move sequence if it is a valid move seq.
  def perform_moves(move_seq)
    perform_moves!(move_seq) if valid_move_seq?(move_seq)
  end

  # def inspect
  #   if king && color == :B
  #     "♚".colorize(:light_cyan)
  #   elsif king && color == :W
  #     "♚".colorize(:light_green)
  #   elsif color == :B
  #     "♟".colorize(:light_cyan)
  #   else
  #     "♟".colorize(:light_green)
  #   end
  # end

  def inspect
    if king && color == :B
      "\u26F7".colorize(:light_cyan)
    elsif king && color == :W
      "♚".colorize(:light_green)
    elsif color == :B
      "\u2614".colorize(:light_cyan)
    else
      "\u26C5".colorize(:light_green)
    end
  end
end

class InvalidMoveError < StandardError
end
