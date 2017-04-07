# Tic Tac Toe game by following walkthroughs

IMPOSSIBLE = [1000, 250, 50, 1].freeze
HARD = [250, 1000, -1, 1].freeze
MEDIUM = [0, 0, 50, 1].freeze
EASY = [-250, -1000, -5, 1].freeze
PLAYER_PIECE = 'X'.freeze
COMPUTER_PIECE = 'O'.freeze
WINNING_LINES = [
  [1, 2, 3], [4, 5, 6], [7, 8, 9], # Rows
  [1, 4, 7], [2, 5, 8], [3, 6, 9], # Columnss
  [1, 5, 9], [3, 5, 7]             # Diagonals
].freeze

def prompt(message)
  puts "=> #{message}"
end

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
def display_board(board)
  system 'clear'
  puts
  puts '       |       |'
  puts "   #{board[1]}   |   #{board[2]}   |   #{board[3]}"
  puts '       |       |'
  puts '-------+-------+-------'
  puts '       |       |'
  puts "   #{board[4]}   |   #{board[5]}   |   #{board[6]}"
  puts '       |       |'
  puts '-------+-------+-------'
  puts '       |       |'
  puts "   #{board[7]}   |   #{board[8]}   |   #{board[9]}"
  puts '       |       |'
  puts
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize

def initialize_board
  {
    1 => '1', 2 => '2', 3 => '3',
    4 => '4', 5 => '5', 6 => '6',
    7 => '7', 8 => '8', 9 => '9'
  }
end

def joinor(numbers, separator = ', ', ender = 'or ')
  str = ""
  numbers.each_with_index do |num, index|
    if index == 0
      str << num.to_s
    elsif index < numbers.size - 1
      str << separator << num.to_s
    else
      str << separator << ender << num.to_s
    end
  end
  str
end

def empty_squares(board)
  board.keys.select { |num| board[num] =~ /\d+/ }
end

def place_player_piece(board)
  square = ''
  
  loop do
    prompt "Choose a square (#{joinor(empty_squares(board))}):"
    square = gets.chomp.to_i

    break if empty_squares(board).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  board[square] = PLAYER_PIECE
end

def place_computer_piece(board)
  unless DIFFICULTY == EASY
    square = find_best_square(board)
  else
    square = empty_squares(board).sample
  end
  board[square] = COMPUTER_PIECE
end

def board_full?(board)
  empty_squares(board).empty?
end

def someone_won?(board)
  !!detect_winner(board)
end

def detect_winner(board)
  WINNING_LINES.each do |line|
    player_won   = (board[line[0]] == PLAYER_PIECE &&
                    board[line[1]] == PLAYER_PIECE &&
                    board[line[2]] == PLAYER_PIECE)

    computer_won = (board[line[0]] == COMPUTER_PIECE &&
                    board[line[1]] == COMPUTER_PIECE &&
                    board[line[2]] == COMPUTER_PIECE)

    return 'Player' if player_won
    return 'Computer' if computer_won
  end
  nil
end

def find_at_risk_square(board, line, piece)
  return nil unless board.values_at(*line).count(piece) == 2
  board.select {|k, v| line.include?(k) && v =~ /\d+/ }.keys.first
end

def find_best_square(board)
  weights = Hash.new(0)
  WINNING_LINES.each do |line|
    line.size.times do |i|
      square = line[i]
      if empty_squares(board).include?(square)
        weights[square] += DIFFICULTY[0] if square == find_at_risk_square(board, line, COMPUTER_PIECE)
        weights[square] += DIFFICULTY[1] if square == find_at_risk_square(board, line, PLAYER_PIECE)
        weights[square] += DIFFICULTY[2] if square == 5
        weights[square] += DIFFICULTY[3]
      end
    end
  end
  weights.key(weights.values.max)
end

system 'clear'
prompt "Welcome to Tic Tac Toe!"
prompt "Choose your difficulty (Easy, Medium, Hard, Impossible):"
answer = gets.chomp
if answer =~ /^e/i
  DIFFICULTY = EASY
  prompt "Setting difficulty to easy..."
elsif answer =~ /^h/i
  DIFFICULTY = HARD
  prompt "Setting difficulty to hard..."
elsif answer =~ /^i/i
  DIFFICULTY = IMPOSSIBLE
  prompt "Setting difficulty to impossible... Good luck!"
else
  DIFFICULTY = MEDIUM
  prompt "Setting difficulty to medium..."
end
prompt "First one to win 5 rounds is the winner!"
prompt "Press enter to start."
gets.chomp

player_wins = 0
computer_wins = 0

loop do

  board = initialize_board

  player_turn = true unless DIFFICULTY == IMPOSSIBLE

  loop do
    display_board(board)

    if player_turn
      place_player_piece(board)
      player_turn = false
    else
      place_computer_piece(board)
      player_turn = true
    end

    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    winner = detect_winner(board)
    prompt "#{winner} won this round!"
    
    if winner == 'Player'
      player_wins += 1
    else
      computer_wins += 1
    end

    prompt "Player: #{player_wins}"
    prompt "Computer: #{computer_wins}"
  else
    prompt "It's a tie!"
  end

  if player_wins == 5
    prompt "Congratulation! You won 5 times! You're a winner!"
    player_wins = 0
    computer_wins = 0
  elsif computer_wins == 5
    prompt "Uh oh! You lost 5 times! You're a loser!"
    player_wins = 0
    computer_wins = 0
  end
  prompt 'Play again? (y or n)'
  answer = gets.chomp
  break if answer =~ /^n/i
end

prompt 'Thanks for playing Tic Tac Toe! Goodbye...'
