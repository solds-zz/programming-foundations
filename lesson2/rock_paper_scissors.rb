STANDARD = %w[rock paper scissors]
BIG_BANG_THEORY = %w[rock paper scissors lizard spock]
THAT_70S_SHOW = %w[nuke cockroach foot]
ROUNDS = 5
WINNING_SCORE = (ROUNDS / 2.0).ceil

def prompt(message)
  puts("=> #{message}")
end

def valid_input?(input)
  VALID_CHOICES.any? { |word| word.start_with?(input) } && input != ''
end

def first_beats_second?(first, second)
  (first == VALID_CHOICES[0] &&
  (second == VALID_CHOICES[2] || second == VALID_CHOICES[3])) ||
  (first == VALID_CHOICES[1] &&
  (second == VALID_CHOICES[0] || second == VALID_CHOICES[4])) ||
  (first == VALID_CHOICES[2] &&
  (second == VALID_CHOICES[1] || second == VALID_CHOICES[3])) ||
  (first == VALID_CHOICES[3] &&
  (second == VALID_CHOICES[4] || second == VALID_CHOICES[1])) ||
  (first == VALID_CHOICES[4] &&
  (second == VALID_CHOICES[2] || second == VALID_CHOICES[0]))
end

def get_choice
  player_choice = ''
  
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    player_choice = gets.chomp.downcase
    if valid_input?(player_choice)
      VALID_CHOICES.each do |word|
        if word.start_with?(player_choice)
          player_choice = word
        end
      end
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  player_choice
end

player_score = 0
computer_score = 0

prompt("Welcome to Ultimate Rock, Paper, Scissors!")
prompt("Best #{WINNING_SCORE} out of #{ROUNDS} wins. Ready to play?")
answer = gets.chomp
playing = !(answer =~ /^n/i)

while playing
  prompt("Choose your ruleset:")
  prompt("1) Standard, 2) Big Bang Theory, 3) That 70's Show")
  answer = gets.chomp

  if answer == '2' || answer.downcase == 'big bang theory'
    VALID_CHOICES = BIG_BANG_THEORY
    prompt("Choosing Big Bang Theory ruleset...")
  elsif answer == '3' || answer.downcase == "that 70's show"
    VALID_CHOICES = THAT_70S_SHOW
    prompt("Choosing That 70's Show ruleset...")
  else
    VALID_CHOICES = STANDARD
    prompt("Choosing standard ruleset...")
  end

  loop do
    player_choice = get_choice
    computer_choice = VALID_CHOICES.sample

    prompt("#{player_choice.capitalize} vs. #{computer_choice.capitalize}!")

    if first_beats_second?(player_choice, computer_choice)
      prompt("You win!")
      player_score += 1
    elsif first_beats_second?(computer_choice, player_choice)
      prompt("You lose!")
      computer_score += 1
    else
      prompt("You tie!")
    end

    break if player_score >= WINNING_SCORE || computer_score >= WINNING_SCORE

    prompt("You: #{player_score}, Computer: #{computer_score}")

    puts
    prompt('Play another round? [Yn]')
    break if gets.chomp =~ /^n/i
  end

  if player_score > computer_score
    prompt("Winner! You won #{player_score} out of the #{ROUNDS} rounds.")
  else
    prompt("Loser! You lost #{player_score} out of the #{ROUNDS} rounds.")
  end

  prompt('Continue playing? [Yn]')
  answer = gets.chomp
  playing = false if answer =~ /^n/i
end

prompt('Thanks for playing. Goodbye!')
