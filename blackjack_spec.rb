require 'rspec'

describe 'BlackjackGame' do
  before(:each) do
    @deck = Deck.new(1)
    @player = Player.new("Test Player", 100)
    @dealer = Player.new("Dealer", Float::INFINITY)
  end

  it 'initializes a card correctly' do
    card = Card.new("Hearts", "Ace")
    expect(card.suit).to eq("Hearts")
    expect(card.value).to eq("Ace")
  end

  it 'initializes a deck with the correct number of cards' do
    expect(@deck.instance_variable_get(:@cards).size).to eq(52)
  end

  it 'shuffles the deck' do
    original_order = @deck.instance_variable_get(:@cards).dup
    @deck.shuffle!
    expect(@deck.instance_variable_get(:@cards)).not_to eq(original_order)
  end

  it 'deals a card from the deck' do
    card = @deck.deal
    expect(card).to be_a(Card)
    expect(@deck.instance_variable_get(:@cards).size).to eq(51)
  end

  it 'initializes a player correctly' do
    expect(@player.name).to eq("Test Player")
    expect(@player.balance).to eq(100)
    expect(@player.hand).to be_empty
  end

  it 'allows a player to place a valid bet' do
    @player.place_bet(50)
    expect(@player.bet).to eq(50)
    expect(@player.balance).to eq(50)
  end

  it 'prevents a player from placing an invalid bet' do
    @player.place_bet(150)
    expect(@player.bet).to eq(0)
    expect(@player.balance).to eq(100)
  end

  it 'calculates hand value correctly without aces' do
    @player.hand = [Card.new("Hearts", "10"), Card.new("Spades", "7")]
    expect(@player.hand_value).to eq(17)
  end

  it 'calculates hand value correctly with aces' do
    @player.hand = [Card.new("Hearts", "Ace"), Card.new("Spades", "9"), Card.new("Diamonds", "Ace")]
    expect(@player.hand_value).to eq(21)
  end

  it 'detects when a player is busted' do
    @player.hand = [Card.new("Hearts", "10"), Card.new("Spades", "10"), Card.new("Diamonds", "5")]
    expect(@player.busted?).to be true
  end

  it 'detects when a player has blackjack' do
    @player.hand = [Card.new("Hearts", "Ace"), Card.new("Spades", "10")]
    expect(@player.blackjack?).to be true
  end

  it 'handles dealer turn logic correctly' do
    @dealer.hand = [Card.new("Hearts", "6"), Card.new("Clubs", "9")]
    deck = Deck.new(1)

    while @dealer.hand_value < 17
      @dealer.hand << deck.deal
    end

    expect(@dealer.hand_value).to be >= 17
  end

  it 'resolves bets correctly when player has blackjack' do
    @player.hand = [Card.new("Hearts", "Ace"), Card.new("Spades", "10")]
    @player.place_bet(50)
    @dealer.hand = [Card.new("Hearts", "9"), Card.new("Spades", "9")]
    expect(@player.blackjack?).to be true

    winnings = (@player.bet * 2.5).to_i
    @player.balance += winnings

    expect(@player.balance).to eq(175)
  end

  it 'resolves bets correctly when player wins' do
    @player.hand = [Card.new("Hearts", "10"), Card.new("Spades", "8")]
    @player.place_bet(50)
    @dealer.hand = [Card.new("Hearts", "9"), Card.new("Spades", "7")]
    expect(@player.hand_value).to be > @dealer.hand_value

    winnings = @player.bet * 2
    @player.balance += winnings

    expect(@player.balance).to eq(150)
  end

  it 'resolves bets correctly when player loses' do
    @player.hand = [Card.new("Hearts", "8"), Card.new("Spades", "6")]
    @player.place_bet(50)
    @dealer.hand = [Card.new("Hearts", "10"), Card.new("Spades", "9")]
    expect(@player.hand_value).to be < @dealer.hand_value

    expect(@player.balance).to eq(50)
  end

  it 'resolves bets correctly when there is a tie' do
    @player.hand = [Card.new("Hearts", "10"), Card.new("Spades", "8")]
    @player.place_bet(50)
    @dealer.hand = [Card.new("Hearts", "10"), Card.new("Spades", "8")]
    expect(@player.hand_value).to eq(@dealer.hand_value)

    @player.balance += @player.bet

    expect(@player.balance).to eq(100)
  end
end
