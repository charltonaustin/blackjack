class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{value} of #{suit}"
  end
end

class Deck
  SUITS = %w[Hearts Diamonds Clubs Spades]
  VALUES = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace]

  def initialize(deck_count = 1)
    @cards = []
    deck_count.times do
      SUITS.each do |suit|
        VALUES.each do |value|
          @cards << Card.new(suit, value)
        end
      end
    end
    shuffle!
  end

  def shuffle!
    @cards.shuffle!
  end

  def deal
    @cards.pop
  end
end

class Player
  attr_accessor :name, :hand, :bet, :balance

  def initialize(name, balance)
    @name = name
    @hand = []
    @balance = balance
    @bet = 0
  end

  def place_bet(amount)
    if amount > balance
      puts "#{name}, you cannot bet more than your balance."
    else
      @bet = amount
      @balance -= amount
    end
  end

  def hand_value
    value = 0
    aces = 0
    @hand.each do |card|
      if card.value == "Ace"
        value += 11
        aces += 1
      elsif card.value.to_i == 0 # Face cards
        value += 10
      else
        value += card.value.to_i
      end
    end

    # Adjust for aces
    while value > 21 && aces > 0
      value -= 10
      aces -= 1
    end

    value
  end

  def busted?
    hand_value > 21
  end

  def blackjack?
    hand_value == 21 && @hand.size == 2
  end

  def to_s
    "#{name}: #{hand.map(&:to_s).join(", ")} (#{hand_value})"
  end
end

class BlackjackGame
  def initialize(player_count, starting_balance, deck_count = 1)
    @deck = Deck.new(deck_count)
    @dealer = Player.new("Dealer", Float::INFINITY)
    @players = Array.new(player_count) { |i| Player.new("Player \#{i + 1}", starting_balance) }
  end

  def play
    loop do
      start_round
      player_turns
      dealer_turn
      resolve_bets
      break unless play_again?
      reset_hands
    end
  end

  private

  def start_round
    @players.each do |player|
      puts "\n#{player.name}, your balance is #{player.balance}. Place your bet:"
      bet = gets.to_i
      player.place_bet(bet)
    end

    @players.each { |player| 2.times { player.hand << @deck.deal } }
    2.times { @dealer.hand << @deck.deal }

    @players.each { |player| puts player }
    puts @dealer
  end

  def player_turns
    @players.each do |player|
      next if player.blackjack?

      loop do
        puts "\n#{player.name}, do you want to hit or stay?"
        action = gets.chomp.downcase
        if action == "hit"
          player.hand << @deck.deal
          puts player
          break if player.busted?
        elsif action == "stay"
          break
        else
          puts "Invalid action. Please choose 'hit' or 'stay'."
        end
      end

      puts "#{player.name} busted!" if player.busted?
    end
  end

  def dealer_turn
    puts "\nDealer's turn."
    while @dealer.hand_value < 17
      @dealer.hand << @deck.deal
      puts @dealer
    end

    puts "Dealer busted!" if @dealer.busted?
  end

  def resolve_bets
    @players.each do |player|
      if player.busted?
        puts "#{player.name} loses their bet of #{player.bet}."
      elsif player.blackjack?
        winnings = (player.bet * 2.5).to_i
        player.balance += winnings
        puts "#{player.name} wins with blackjack! Payout: #{winnings}."
      elsif @dealer.busted? || player.hand_value > @dealer.hand_value
        winnings = player.bet * 2
        player.balance += winnings
        puts "#{player.name} wins! Payout: #{winnings}."
      elsif player.hand_value == @dealer.hand_value
        player.balance += player.bet
        puts "#{player.name} ties with the dealer and gets their bet back."
      else
        puts "#{player.name} loses their bet of #{player.bet}."
      end
    end
  end

  def play_again?
    puts "\nDo you want to play another round? (yes or no)"
    gets.chomp.downcase == "yes"
  end

  def reset_hands
    (@players + [@dealer]).each { |player| player.hand = [] }
    @deck = Deck.new
  end
end

# Start the game
puts "Welcome to Blackjack! How many players (1-5)?"
player_count = gets.to_i
puts "Starting balance for each player?"
starting_balance = gets.to_i
puts "Number of decks to use?"
deck_count = gets.to_i

game = BlackjackGame.new(player_count, starting_balance, deck_count)
game.play
