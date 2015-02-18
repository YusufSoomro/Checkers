require_relative 'board'
require 'io/console'
require 'colorize'
require 'YAML'

class Game
  attr_accessor :game_board

  def initialize
    @game_board = Board.new
  end

  def play
    color = :B

    loop do
      begin
        play_turn(get_input, :W)
        break if won?
      rescue
        retry
      end

      begin
        play_turn(get_input, :B)
        break if won?
      rescue
        retry
      end
    end

    puts "Congratulations! Someone won, I don't know who though."
    puts "Figure it out."
  end

  def get_input
    moves = []

    loop do
      system("clear")
      game_board.render
      command = STDIN.getch

      case command
      when "w"
        new_cursor_position = [game_board.cursor[0] - 1, game_board.cursor[1]]
        change_cursor(new_cursor_position)
        next
      when "a"
        new_cursor_position = [game_board.cursor[0], game_board.cursor[1] - 1]
        change_cursor(new_cursor_position)
        next
      when "s"
        new_cursor_position = [game_board.cursor[0] + 1, game_board.cursor[1]]
        change_cursor(new_cursor_position)
        next
      when "d"
        new_cursor_position = [game_board.cursor[0], game_board.cursor[1] + 1]
        change_cursor(new_cursor_position)
        next
      when "\r"
        moves << game_board.cursor
        next
      when "r"
        break
      when "q"
        puts "Would you like to save your game?"
        puts "(y/n)"
        choice = gets.chomp

        if choice == "y"
          save
          exit
        else
          exit
        end
      end
    end

    moves
  end

  def change_cursor(new_cursor_pos)
    if new_cursor_pos.all? { |coord| coord.between?(0, 7) }
      system("clear")
      game_board.cursor = new_cursor_pos
    end
  end

  def won?
    game_board.grid.flatten.compact.none? { |piece| piece.color == :B } ||
    game_board.grid.flatten.compact.none? { |piece| piece.color == :W } ||
    game_board.grid.flatten.compact.none? { |piece| piece.move_diffs.empty? }
  end

  def play_turn(move_sequence, color)
    piece_to_move = move_sequence.shift
    if game_board[piece_to_move].color != color
      raise InvalidMoveError.new
    end
    game_board[piece_to_move].perform_moves(move_sequence)
  end

  def save
    puts "What do you want to save the file under?"
    save_file = gets.chomp
    File.write("#{save_file}.yaml", self.to_yaml)
    puts "Your file has been saved."
  end

  def self.load_game
    puts "What's the name of the file?"
    file_name = gets.chomp
    g = YAML.load_file("#{file_name}.yaml")
    g.play
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Would you like to (l)oad a game or start a (n)ew game?"
  puts "(l/n)"
  choice = gets.chomp

  if choice == 'l'
    Game.load_game
  else
    g = Game.new
    g.play
  end
end
