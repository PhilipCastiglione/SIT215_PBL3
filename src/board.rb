require 'SecureRandom'
class Board
  attr_reader :state, :hashcode

  def initialize(initialized_state=nil)
    @state = initialized_state ? initialized_state : new_state
    @hashcode = (@state.join() + SecureRandom.hex).to_sym # risk of hash collision negligble
  end

  def ==(other)
    return false unless other.is_a? Board

    @state == other.state
  end

  def clear?
    @state.all? {|t| t == 0 }
  end

  def valid_piles
    @state.each_with_index.map {|t, i| t > 0 ? i + 1 : false}.select(&:itself)
  end

  def pile(number)
    @state[number - 1]
  end

  def state_after_removing(pile, tiles)
    @state[pile - 1] -= tiles
    @state
  end

  def next_boards
    boards = []
    @state.each_with_index do |pile, i|
      pile.times do |remove|
        state = @state.dup
        state[i] = pile - remove - 1
        boards << Board.new(state)
      end
    end
    boards
  end

  def diff(board)
    @state.each_with_index.map {|pile, i| pile - board.state[i]}
  end

  def print
    rows = []
    @state.max.times do |v|
      rows << @state.map {|t| t >= @state.max - v ? '◻' : ' ' }
    end
    rows << ('-' * @state .size).split('')
    rows << @state.size.times.map {|t| t + 1 }
    rows.each {|r| puts " " + r.join(" ") }
  end

  private

  def new_state
    state = []
    num_piles = rand(4) + 2
    num_tiles = num_piles * 2 + 1 + rand(num_piles * 2)
    num_piles.times { state.push(1) }
    num_tiles -= num_piles
    num_tiles.times { state[rand(num_piles)] += 1 }
    state
  end
end
