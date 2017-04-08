# Twenty-One Game

def prompt(message)
  puts "=> #{message}"
end

def reshuffle(deck)
  deck.clear
  faces = %w[Ace Two Three Four Five Six Seven Eight Nine Ten Jack Queen King]
  suits = {
    'Spades' => '♠',
    'Clubs' =>  '♣',
    'Diamonds' => '♦',
    'Hearts' => '♥'
  }
  values = {
    'Ace' => [1, 11], 'Two' => 2, 'Three' => 3, 'Four' => 4,
    'Five' => 5, 'Six' => 6, 'Seven' => 7, 'Eight' => 8,
    'Nine' => 9, 'Ten' => 10, 'Jack' => 10, 'Queen' => 10, 'King' => 10
  }
  faces.each do |face|
    value = values[face]
    suits.each do |suit, symbol|
      key = "#{symbol} #{face} of #{suit} #{symbol}"
      deck << { key => value }
    end
  end
  deck.shuffle!
end

def total(*cards)
  sum = 0
  aces = []
  cards = cards.flatten
  cards.each do |card|
    card.each_value do |value|
      value.is_a?(Array) ? aces << value : sum += value
    end
  end
  aces.each { |value| sum += (sum + value[1] > 21 ? value[0] : value[1]) }
  sum
end

def draw_card(deck)
  return deck.pop unless deck.empty?
  reshuffle(deck).pop
end

def input_handler
  input = gets.chomp
  if input =~ /(quit)|(exit)/i
    display_outro
    exit
  end
  input
end

def display_rules
  system 'clear'
  prompt "The objective of Blackjack is to beat the dealer."
  puts "To do so you must first not bust (go over 21) and second either outscore the dealer or have the dealer bust. " \
       "Aces are worth 1 or 11 points, cards 2 to 10 are worth 2 to 10 points, respectively, and face cards are worth 10 points. " \
       "The value of a hand is the sum of the point values of the individual cards, except a \"blackjack\" is the highest hand. " \
       "A blackjack consists of an Ace and any 10-point card, and outranks all other 21-point hands."
  puts
  puts "The following are the choices available to the player:"
  puts "  Hit: Player draws another card."
  puts "  Stand: Player discontinues drawing more cards."
  puts "  Double: Player doubles their bet and gets only more card."
  puts
  puts "If the dealer goes over 21 points, then the player wins. " \
       "If the dealer does not bust, then the higher point total between the player and dealer wins. " \
       "Winning wagers pay even money, except a winning player's blackjack usually pays 3 to 2."
  puts
  prompt "Press enter to continue."
  input_handler
end

def display_outro
  system 'clear'
  prompt "Thanks for playing Blackjack!"
  begin # In case the player quits before entering a name
    prompt "Goodbye, #{PLAYER_NAME}."
  rescue
    prompt "Goodbye."
  end
end

def display_cards(dealer_cards, player_cards)
  system 'clear'
  prompt "-----Dealer-----"
  dealer_cards.each do |card|
    card.each { |k, _| puts "   #{k}" }
  end
  puts "     ????? of ?????" if dealer_cards.size == 1
  puts
  prompt "-----#{PLAYER_NAME}-----"
  player_cards.each do |card|
    card.each { |k, _| puts "   #{k}" }
  end
  puts
  prompt "Dealer Total: #{total(dealer_cards)}"
  prompt "Player Total: #{total(player_cards)}"
  puts
end

def display_bets(money)
  system 'clear'
  prompt "You have $#{money} right now."
  prompt "How much are you betting this round (minimum $#{MIN_BET})?"
end

def busted?(cards)
  total(cards) > 21
end

def bet_result(bet, result)
  case result
  when :dealer_blackjack
    -bet
  when :player_blackjack
    (bet * 1.5).to_i
  when :dealer_wins
    -bet
  when :player_wins
    bet
  when :tie
    0
  end
end

def result(dealer_cards, player_cards)
  dealer_total = total(dealer_cards)
  player_total = total(player_cards)
  dealer_busted = dealer_total > 21
  player_busted = player_total > 21

  if dealer_total == 21 && dealer_cards.size == 2
    :dealer_blackjack
  elsif player_total == 21 && player_cards.size == 2
    :player_blackjack
  elsif (player_busted && !dealer_busted) || (player_total < dealer_total && !dealer_busted)
    :dealer_wins
  elsif (dealer_busted && !player_busted) || (player_total > dealer_total && !player_busted)
    :player_wins
  else
    :tie
  end
end

def display_result(dealer_cards, player_cards, bet)
  result = result(dealer_cards, player_cards)
  
  prompt "Dealer busted!" if busted?(dealer_cards)
  prompt "You busted!" if busted?(player_cards)

  sleep(1)

  case result
  when :dealer_blackjack
    prompt "Dealer has a blackjack!"
    prompt "You lose $#{bet}!"
  when :player_blackjack
    prompt "You have a blackjack!"
    prompt "You win $#{(bet * 1.5).to_i}!"
  when :dealer_wins
    prompt "Dealer wins!"
    prompt "You lose $#{bet}!"
  when :player_wins
    prompt "You win $#{bet}!"
  when :tie
    prompt "It's a draw."
  end
end

MIN_BET = 10
DECK = []
reshuffle(DECK)

system 'clear'
prompt "Welcome to Blackjack!"
prompt "Type 'quit' at any time to exit this game."
puts
prompt "Would you like to see the rules of Blackjack?"
answer = input_handler
display_rules if answer =~ /^y/i

system 'clear'
prompt "What is your name?"
PLAYER_NAME = input_handler
GOD_MODE = PLAYER_NAME =~ /^godmode/i

system 'clear'
prompt "Hello, #{PLAYER_NAME}."
prompt "How much money will you be gambling with?"
answer = input_handler.match(/\d+/).to_s.to_i

if answer < MIN_BET
  STARTING_CASH = MIN_BET * 3
  prompt "That's not enough! We'll give you $#{STARTING_CASH} to start with."
else
  STARTING_CASH = answer
end

system 'clear'

if GOD_MODE
  prompt "God Mode is enabled."
  prompt "Your money will reset to $#{STARTING_CASH} if it ever dips below $#{MIN_BET}."
  prompt "Remember, you can type 'quit' at any time to exit this game."
end

money = STARTING_CASH

loop do
  if money < MIN_BET && GOD_MODE
    money = STARTING_CASH
    puts
    prompt "Resetting your money to $#{STARTING_CASH}."
  elsif money < MIN_BET
    break
  end
  puts
  prompt "Press enter to start a new round."
  input_handler

  dealer_cards = [draw_card(DECK)]
  player_cards = [draw_card(DECK), draw_card(DECK)]
  bet = 0

  while bet < MIN_BET || bet > money
    display_bets(money)
    bet = input_handler.match(/\d+/).to_s.to_i
  end

  loop do # Player's turn
    display_cards(dealer_cards, player_cards)
    break if busted?(player_cards)
    prompt "Hit, Stand, or Double?"
    answer = input_handler

    if answer =~ /^d/i && (bet * 2 <= money || GOD_MODE)
      bet *= 2
      player_cards << draw_card(DECK)
      break
    elsif answer =~ /^h/i
      player_cards << draw_card(DECK)
    elsif answer =~ /^s/i
      break
    else
      prompt "Sorry! Can't do that."
      sleep(1)
    end
  end

  dealer_cards << draw_card(DECK)

  loop do # Dealer's turn
    display_cards(dealer_cards, player_cards)
    break if busted?(dealer_cards) || busted?(player_cards)
    if total(dealer_cards) < 17
      dealer_cards << draw_card(DECK)
      sleep(1)
      next
    end
    break
  end

  result = result(dealer_cards, player_cards)
  display_result(dealer_cards, player_cards, bet)
  money += bet_result(bet, result)
end

prompt "You ran out of money!"
puts
prompt "Press enter to continue."
input_handler
display_outro
