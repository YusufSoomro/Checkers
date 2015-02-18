# TESTS AT BOTTOM

require_relative 'piece'
require 'colorize'

class Board
  attr_reader :grid
  attr_accessor :cursor

  def initialize(pop = true)
    @grid = Array.new(8) { Array.new(8) }
    generate_board if pop
    @cursor = [0, 0]
  end

  # Fills the board with black pieces on top and white pieces
  # on bottom.
  def generate_board
    [0, 1, 2].each do |row|
      0.upto(7) do |col|
        offset = row + col
        self[[row, col]] = Piece.new([row, col], self, :B) if offset.odd?
      end
    end

    [5, 6, 7].each do |row|
      0.upto(7) do |col|
        offset = row + col
        self[[row, col]] = Piece.new([row, col], self, :W) if offset.odd?
      end
    end
  end

  # Retrieves what's on the board with the given pos
  def [](pos)
    row, col = pos
    grid[row][col]
  end

  # Sets the value of what's on the board with the given pos
  def []=(pos, value)
    row, col = pos
    grid[row][col] = value
  end

  # Returns true if the given pos on the board is nil, else false
  def empty?(pos)
    self[pos] == nil
  end

  # Dups the board completely
  def deep_dup
    new_board = Board.new(false)

    grid.flatten.compact.each do |piece|
      new_board[piece.pos.dup] =
          Piece.new(piece.pos.dup, new_board, piece.color)
    end

    new_board
  end

  def render
    print " "
    (0..7).each { |num| print " #{num}" }
    puts ""
    num = 0
    grid.each_with_index do |row, row_ind|
      print "#{num} "
      row.each_with_index do |spot, col_ind|
        if [row_ind, col_ind] == cursor
          print "  ".colorize(:background =>:blue)
        else
          print_spot(spot, row_ind, col_ind)
        end
      end
      num += 1
      puts ""
    end
  end

  def print_spot(piece, row_ind, col_ind)
    offset = (row_ind + col_ind)

    if offset.odd? && empty?([row_ind, col_ind])
      print "  ".colorize(:background => :black)
    elsif offset.even? && empty?([row_ind, col_ind])
      print "  ".colorize(:background => :red)
    elsif offset.odd?
      print "#{piece.inspect} ".colorize(:background => :black)
    else
      print "#{piece.inspect} ".colorize(:background => :red)
    end
  end

end

#perform_slide test
#   b[[7, 0]] = Piece.new([7, 0], b, :W)
#   p b.grid
#   puts ""
#   b[[7, 0]].perform_slide([6, 1])
#   p b.grid
#   puts ""
#   b[[6, 1]].perform_slide([5, 2])
#   p b.grid

# perform_jump test
#   b[[7, 0]] = Piece.new([7, 0], b, :W)
#   b[[6, 1]] = Piece.new([6, 1], b, :B)
#   p b.grid
#   puts ""
#   p b[[7,0]].perform_jump([6, 1])
#   p b.grid

# perform_moves! test
  # One move
    # Testing if perform_slide works
      # b[[7, 0]] = Piece.new([7, 0], b, :W)
      # p b.grid
      # puts ""
      # b[[7, 0]].perform_moves!([[6, 1]])
      # p b.grid
    # Testing if perform_jump works
      # b[[7, 0]] = Piece.new([7, 0], b, :W)
      # b[[6, 1]] = Piece.new([6, 1], b, :B)
      # p b.grid
      # puts ""
      # b[[7, 0]].perform_moves!([[6, 1]])
      # p b.grid
  # Multiple moves
    # b[[7, 0]] = Piece.new([7, 0], b, :W)
    # b[[6, 1]] = Piece.new([6, 1], b, :B)
    # b[[4, 3]] = Piece.new([4, 3], b, :B)
    # p b.grid
    # puts ""
    # b[[7, 0]].perform_moves!([[6, 1], [4, 3]])
    # p b.grid

# maybe_promote test
  # For perform_slide
    # b[[1, 1]] = Piece.new([1, 1], b, :W)
    # p b[[1, 1]].king
    # p b.grid
    # puts ""
    # b[[1, 1]].perform_slide([0, 0])
    # p b[[0, 0]].king
    # p b.grid
  # For perform_jump
    # b[[1, 1]] = Piece.new([1, 1], b, :B)
    # b[[2, 2]] = Piece.new([2, 2], b, :W)
    # p b[[2, 2]].king
    # p b.grid
    # puts ""
    # b[[2, 2]].perform_jump([1, 1])
    # p b[[0, 0]].king
    # p b.grid

# deep_dup test
  # b[[0, 0]] = Piece.new([0, 0], b, :B)
  # new_board = b.deep_dup
  # p b.grid
  # puts ""
  # p new_board.grid
  # puts ""
  # new_board[[0, 0]].perform_slide([1, 1])
  # p b.grid
  # puts ""
  # p new_board.grid

# valid_move_seq? test
  # b[[7, 0]] = Piece.new([7, 0], b, :W)
  # b[[6, 1]] = Piece.new([6, 1], b, :B)
  # b[[4, 3]] = Piece.new([4, 3], b, :B)
  # p b[[7, 0]].valid_move_seq?([[6, 1], [4, 3]])

#perform_moves test
  # b[[7, 0]] = Piece.new([7, 0], b, :W)
  # b[[6, 1]] = Piece.new([6, 1], b, :B)
  # b[[4, 3]] = Piece.new([4, 3], b, :B)
  # p b.grid
  # b[[7, 0]].perform_moves([[6, 1], [4, 3]])
  # p b.grid
