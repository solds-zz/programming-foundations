VALID_CHOICES = %w[rock paper scissors]

def prompt(message)
  puts("=> #{message}")
end

def win?(first, second)
  (first == 'rock' && second == 'scissors') ||
  (first == 'paper' && second == 'rock') ||
  (first == 'scissors' && second == 'paper')
end

def display_result(player, computer)
  puts
  prompt("You chose: #{player}")
  prompt("Computer chose: #{computer}")

  if win?(player, computer)
    prompt('You won!')
  elsif player == computer
    prompt('You tied!')
  else
    prompt('You lost!')
  end
end

prompt('Rock, Paper, Scissors!')

loop do
  player_choice = loop do
                    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
                    choice = gets.chomp.downcase

                    if VALID_CHOICES.include?(choice)
                      break choice
                    else
                      prompt("That's not a valid choice.")
                    end
                  end

  computer_choice = VALID_CHOICES.sample

  display_result(player_choice, computer_choice)

  prompt('Play again? [Yn]')
  break if gets.chomp =~ /^[Nn]/
end

prompt('Thank you for playing. Goodbye!')
