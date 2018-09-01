
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

    end
  end

  def initialize(board, is_ai_turn, game_type)
    @root = Node.new(board, game_type, is_ai_turn)
    build_tree()
  end

  def move(board)
    @root = @root.children.inject {|best, child| child.value > best.value ? child : best}
    @root.board
  end

  def update_for_player_move(board, new_state)
    @root = find_node(@root, board.hashcode)
      .children
      .select {|child| child.board.state == new_state }
      .first
    @root.board
  end

  private

  def build_tree
    @root.build_children()
  end

  def find_node(node, hashcode)
    return node if node.board.hashcode == hashcode

    node.children.map {|n| find_node(n, hashcode) }.compact.first
  end
end
