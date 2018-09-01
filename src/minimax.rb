require_relative 'debug'

# TODO: there is a bug, because it isn't very smart
class Minimax
  class Node
    attr_accessor :board, :children, :value

    def initialize(board, game_type, is_ai_turn, depth=1)
      @board = board
      @game_type = game_type
      @is_ai_turn = is_ai_turn
      @depth = depth
    end

    def build_children()
      @children = @board.next_boards
        .map {|b| Node.new(b, @game_type, !@is_ai_turn, @depth + 1) } # map to nodes

      if @children.any?
        @children.each {|node| node.build_children() }

        @value = @is_ai_turn ? @children.map(&:value).min : @children.map(&:value).max
      else
        if @game_type == :normal && @is_ai_turn || @game_type == :misere && !@is_ai_turn
          @value = 100 - @depth
        else
          @value = -100 - @depth
        end
      end

      invariant(-> { @children.all? {|c| c.board.state.inject(&:+) < @board.state.inject(&:+) } }, 'child with too many tiles')
    end
  end

  def initialize(board, is_ai_turn, game_type)
    @root = Node.new(board, game_type, is_ai_turn)
    build_tree()
  end

  def move(board)
    invariant(-> { @root.board == board }, 'game board does not match AI root before move')
    @root = @root.children.inject {|best, child| child.value > best.value ? child : best}
    @root.board
  end

  def update_for_player_move(board, new_state)
    @root = find_node(@root, board.hashcode)
      .children
      .select {|child| child.board.state == new_state }
      .first
    invariant(-> { @root.board.state == new_state }, 'updating for player move resulted in wrong state')
    invariant(-> { @root.board.hashcode != board.hashcode }, 'root has assumed the wrong hashcode')
    @root.board
  end

  private

  def build_tree
    @root.build_children()
    invariant(-> { @root.children.map(&:board).map(&:hashcode).uniq == @root.children.map(&:board).map(&:hashcode) }, 'duplicate board hashcode present')
    invariant(Proc.new do
      def correct(node)
        node.board.hashcode.to_s.start_with?(node.board.state.join) &&
          node.children.all? {|c| correct(c) }
      end
      correct(@root)
    end, 'a child exists with a hashcode not matching state')
  end

  def find_node(node, hashcode)
    return node if node.board.hashcode == hashcode

    node.children.map {|n| find_node(n, hashcode) }.compact.first
  end
end
