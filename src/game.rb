require_relative 'board'
require_relative 'minimax'

class Game
  def initialize
    @is_playing = true
  end

  def play
    preamble()

    while @is_playing
      new_game()
      take_turn() while !finished?
      announce_winner()
      play_again?()
    end

    puts()
    puts('Goodbye')
  end

  private

  def preamble
    puts()
    puts('=' * 40 + ' Welcome to miNIMax ' + '=' * 40)
    puts()

    puts("This is the game of Nim, played against an AI opponent.")
    puts()
    print("There are some number of piles of tiles. ")
    puts("On a player's turn, they choose any amount of tiles to take from any one pile.")
    puts()
    print("There are two game modes: ")
    print("in 'normal' game mode, the last player to remove the final tile wins. ")
    puts("in 'misere' game mode, the player who takes this tile loses.")
  end

  def new_game
    puts()
    puts("New Game")
    puts()

    @board = Board.new()
    @is_ai_turn = randomize_start_player()
    @game_type = choose_game_type()
    @turn = 1

    @ai = Minimax.new(@board, @is_ai_turn, @game_type)
  end

  def choose_game_type
    print("Please enter game type (misere or normal): ")
    input = gets.chomp.to_sym
    (input  == :misere || input == :normal) ? input : choose_game_type
  end

  def randomize_start_player()
    ai_starts = rand < 0.5
    puts "Randomly choosing a starting player: #{ai_starts ? "the AI" : "YOU"}"
    ai_starts
  end

  def take_turn
    puts()
    puts("Turn: #{@turn}")
    puts()
    @board.print()
    puts()
    puts "It is #{@is_ai_turn ? "the AIs" : "your"} turn"
    if @is_ai_turn
      @board = @ai.move
    else
      pile = choose_pile()
      tiles = choose_tiles(pile)
      @ai.player_move(@board)
      @board.remove(pile, tiles)
    end
    @is_ai_turn = !@is_ai_turn
    @turn += 1
  end

  def choose_pile
    print("Choose which (not empty) pile to take tiles from: ")
    input = gets.chomp.to_i
    @board.valid_piles.include?(input) ? input : choose_pile
  end

  def choose_tiles(pile)
    print("Choose how many tiles to take: ")
    input = gets.chomp.to_i
    (input > 0 && input <= @board.pile(pile)) ? input : choose_tiles(pile)
  end

  def finished?
    @board.empty?
  end

  def announce_winner
    puts()
    won = @is_ai_turn && @game_type == :misere || !@is_ai_turn && @game_type == :normal
    puts("The winner is: #{won ? "YOU. Congratulations!" : "the AI. Better luck next time."}")
    puts()
  end

  def play_again?
    print("Enter Y/y to play again, or anything else to quit: ")
    @is_playing = gets.chomp.downcase == "y"
  end
end
