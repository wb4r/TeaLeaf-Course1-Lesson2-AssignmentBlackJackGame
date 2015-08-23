require 'pry'

class Deck
  SUITS = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    
  def initialize(number_of_players)
    @inGameDeck = mother_deck(@inGameDeck)
    @inGameDeck = @inGameDeck * number_of_players
  end
  
  def mother_deck(motherdeck)
    motherdeck = SUITS.product(CARDS)
    motherdeck.shuffle!
  end
  
  def provide_card
    @inGameDeck.pop
  end
  
  def length
    @inGameDeck.length
  end
end

class Card
  attr_reader :suit, :value
  
  def initialize(suit, value)
    @suit = suit
    @value = value
  end
  
  def to_s
    "Suit: #{@suit} - Card: #{@value}"
  end
end

class Player
  @@number_of_players = 0
  
  def initialize(name)
    @name = name
    @player_hand = []
    @@number_of_players += 1
  end
  
  def self.number_of_players
    @@number_of_players
  end
  
  def hit(card = new_card)
    #Game.new_card
    #@inGameDeck.provide_card
    puts "madafadca"
    puts card.suit
    #hand(card)
  end
  
  def stay
  end
  
  def hand(card)
    card_array = []
    card_array << [card.suit, card.value]
    card_array.flatten!
    @player_hand << card_array
    "here goes the player_hand with #{@player_hand}"
  end
end

class Game
  def initialize
    @gambler = Player.new("Jim Bennett")
    @dealer = Player.new("Casino Dealer")
  end
  
  def new_card
    new_card = @inGameDeck.provide_card
    Card.new(new_card[0], new_card[1])
  end
  
  def play
    @inGameDeck = Deck.new(Player.number_of_players)
    p @inGameDeck.length
    puts new_card
    puts new_card
    
    @gambler.hit(card = new_card)
    p @inGameDeck.length
    puts @gambler.hand(card)
    
    @gambler.hit(card = new_card)
    puts @gambler.hand(card)
    p @inGameDeck.length
    
    @dealer.hit(card = new_card)
    p @inGameDeck.length
    puts @dealer.hand(card)
    #create_players (done in initialize)
    #create_deck (done in initialize)
    
    #create space for player cards and used cards (done in player.hand)
    
    # can i track correctly players hand to afterwards calculate value?
    # why not card.suit and card
    # change instance variables @ with setters and getters
    
    # assign values to deck
    #2.times deck provide card to each player
    #loop hit player
    #loop hit dealer
  end
end

Game.new.play