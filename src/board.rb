class Board
  def initialize
    b = []
    num_piles = rand(4) + 2
    num_tiles = num_piles * 2 + 1 + rand(num_piles * 2)
    num_piles.times { b.push(1) }
    num_tiles -= num_piles
    num_tiles.times { b[rand(num_piles)] += 1 }
    @state = b
  end

  def empty?
    @state.all? {|t| t == 0 }
  end

  def valid_piles
    @state.each_with_index.map {|t, i| t > 0 ? i + 1 : false}.select(&:itself)
  end

  def pile(number)
    @state[number - 1]
  end

  def remove(pile, tiles)
    @state[pile - 1] -= tiles
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
end
