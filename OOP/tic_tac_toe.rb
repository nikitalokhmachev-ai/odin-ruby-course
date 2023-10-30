class TicTacToe
  # x - 0
  # y - 1
  # empty value - -1

  def initialize(turn = 'x')
    raise AssertionError, 'turn can only be x or o' unless %w[x o].include?(turn)

    @turn = turn == 'x' ? 0 : 1
    @board_size = 3
    @board = Array.new(@board_size) { Array.new(@board_size, -1) }
  end

  def visualize
    puts @board.map { |row|
           row.map do |el|
             if el.zero?
               'x'
             else
               (el == 1 ? 'o' : '_')
             end
           end.join(' ')
         }.join("\n")
  end

  def win?(arr)
    arr.uniq.count <= 1 && arr.uniq[0] != -1
  end

  def horizontal_win?
    @board.any? { |row| win?(row) }
  end

  def vertical_win?
    @board.transpose.any? { |row| win?(row) }
  end

  def diagonal_win?
    diag1 = (0..@board_size - 1).collect { |i| @board[i][@board_size - 1 - i] }
    diag2 = (0..@board_size - 1).collect { |i| @board[i][i] }
    win?(diag1) || win?(diag2)
  end

  def game_ended?
    !@board.flatten.uniq.include?(-1)
  end

  def valid_coords?(coords)
    x, y = coords
    x < @board_size && y < @board_size ? @board[x][y] == -1 : false
  end

  def play
    coords = [@board_size, @board_size]
    loop do
      if game_ended?
        puts "It's a tie"
      else
        until valid_coords?(coords)
          visualize
          puts "Enter the coordinates of #{@turn.zero? ? 'x' : 'o'}:"
          input = gets.chomp
          coords = input.split.map(&:to_i)
        end
        @board[coords[0]][coords[1]] = @turn

        if vertical_win? || horizontal_win? || diagonal_win?
          visualize
          puts "#{@turn.zero? ? 'x' : 'o'} wins!"
          break
        end

        @turn = 1 - @turn

      end
    end
  end
end

TicTacToe.new.play
