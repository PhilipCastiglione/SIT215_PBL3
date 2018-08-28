# TODO: needs a value calculation to implement minimax

class Minimax
  class Node
    attr_accessor :board

    def initialize(board, is_ai_turn)
      self.board = board
      @is_ai_turn = is_ai_turn
    end

    def children
      board.next_boards.map do |board|
        Node.new(board, !@is_ai_turn)
      end
    end
  end

  def initialize(board, is_ai_turn, game_type)
    @game_type = game_type
    @root = Node.new(board, is_ai_turn)
    p "root"
    p @root
    @tree = build_tree
  end

  def move
    # TODO: pick the best move from the root, update root, return the moves board
    @root.board # temporary, so the game is testable without AI
  end

  def player_move(board)
    # @root = find_node(board)
  end

  private

  def find_node(board)
    # TODO: find and return the node matching the board from the tree
  end

  def build_tree
    # TODO: build a tree from the root using children recursively, store it
  end
end
