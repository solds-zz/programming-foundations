# Tic Tac Toe

require 'pry'

PLAYER = 'X'
COMPUTER = 'O'
ROWS = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
COLS = [[0, 3, 6], [1, 4, 7], [2, 5, 8]]
DIAGS = [[0, 4, 8], [2, 4, 6]]

def display_board(board)
  board_str = <<-BOARD

       |       |
   $   |   $   |   $
       |       |
-------+-------+-------
       |       |
   $   |   $   |   $
       |       |
-------+-------+-------
       |       |
   $   |   $   |   $
       |       |

BOARD
  board.each { |square| board_str.sub!('$', square) }
  puts board_str
end

def mark_player(board)
  loop do
    print "Choose a square (1-9): "
    square = gets.chomp

    if valid_square?(board, square)
      update_board(board, square, PLAYER)
      break
    else
      puts "You can't put an #{PLAYER} there!"
    end
  end
end

def mark_computer(board)
  weights = find_best_squares(board)
  weights = weights.invert.sort.reverse.to_h
  weights.size.times do |i|
    square = board[weights[weights.keys[i]]]
    if valid_square?(board, square)
      update_board(board, square, COMPUTER)
      break
    end
  end
end

def mark_square(board, letter)
  letter == PLAYER ? mark_player(board) : mark_computer(board)
end

# Spaghetti, but works
def find_best_squares(board)
  coord_sets = [ROWS, COLS, DIAGS]
  weights = Hash.new(0)

  coord_sets.each do |set|
    set.each do |coords|
      coords.each_with_index do |coord, index|
        # Open square
        if coord.to_s =~ /[1-9]/
          weights[coord] += 5
        end
        # Open square next to another open square
        if ((coord.to_s =~ /[1-9]/) &&
           ((coords[index - 1].to_s =~ /[1-9]/) || 
           (coords[index - 2].to_s =~ /[1-9]/)))
          weights[coord] += 10
        end
        # Open square next to an 'O'
        if ((coord.to_s =~ /[1-9]/) &&
           (board[coords[index - 1]] == COMPUTER) ||
           (board[coords[index - 2]] == COMPUTER))
          weights[coord] += 25
        end
        # Player is able to win
        if ((coord.to_s =~ /[1-9]/) &&
           (board[coords[index - 1]] == PLAYER) && 
           (board[coords[index - 2]] == PLAYER))
          weights[coord] += 50
        end
        # Computer is able to win
        if ((coord.to_s =~ /[1-9]/) &&
           (board[coords[index - 1]] == COMPUTER) &&
           (board[coords[index - 2]] == COMPUTER))
          weights[coord] += 100
        end
        # Middle square
        if coord.to_s == '4'
          weights[coord] += 500
        end
        # 'X' or 'O'
        if (board[coord] == COMPUTER) || (board[coord] == PLAYER)
          weights[coord] -= 1000
        end
      end
    end
  end
  weights
end

def reset_board
  "123456789".split('')
end

def update_board(board, number, letter)
  index = board.index(number)
  board[index] = letter
end

def toggle_letter(letter)
  letter == PLAYER ? COMPUTER : PLAYER
end

def check_coords(board, coords, letter)
  board[coords[0]] == letter &&
  board[coords[1]] == letter &&
  board[coords[2]] == letter
end

def play_again?
  puts "Play again? [Yn]"
  answer = gets.chomp
  answer !~ /^n/i
end

def board_full?(board)
  board.all? { |square| square !~ /[1-9]/ }
end

def winner?(board)
  winner = false
  coord_sets = [ROWS, COLS, DIAGS]

  coord_sets.each do |set|
    set.each do |coords|
      player_wins = check_coords(board, coords, PLAYER) ||
      computer_wins = check_coords(board, coords, COMPUTER)
      winner = true if player_wins || computer_wins
    end
  end

  winner
end

def valid_square?(board, square)
  valid = board.include?(square)
  if valid
    valid = square != PLAYER && square != COMPUTER
  end
  valid
end

playing = true

while playing
  board = reset_board
  current_letter = [PLAYER, COMPUTER].sample
  in_match = true

  puts "You are '#{PLAYER}'."
  puts "The computer is '#{COMPUTER}'."
  puts "'#{current_letter}' goes first."

  while in_match
    display_board(board) if current_letter == PLAYER
    mark_square(board, current_letter)

    if winner?(board)
      display_board(board)
      puts "You #{current_letter == PLAYER ? 'won!' : 'lost!'}"
      in_match = false
    elsif board_full?(board)
      display_board(board)
      puts "You tied!"
      in_match = false
    else
      current_letter = toggle_letter(current_letter)
    end
  end
  
  unless play_again?
    playing = false
  end
end

puts "Thanks for playing! Goodbye..."