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
    "Suit: #{suit} - Card: #{value}"
  end
end


class Player
  attr_reader :name, :card
  @@number_of_players = 0
  
  def initialize(name)
    @name = name
    @player_hand = []
    @@number_of_players += 1
  end
  
  def self.number_of_players
    @@number_of_players
  end
  
  def decision_hit(card)                     #(card = new_card)
    @card = card
    save_card_to_player_hand(card)
  end
  
  def save_card_to_player_hand(card)
    @player_hand << [card.suit, card.value]
  end
  
  def show_card
    puts self.card
  end
  
  def player_hand
    puts @player_hand
    
  end
  
  def calculate_total_player_hand
    array_of_values = []

    @player_hand.each_index do |index, sub_array|
      if @player_hand[index][1].to_i != 0
        array_of_values << @player_hand[index][1].to_i
      elsif @player_hand[index][1] == "A"
        array_of_values << 11
      else
        array_of_values << 10
      end
    end
    if array_of_values.inject(:+) > 21 && array_of_values.max == 11
      array_of_values.delete(11) 
      array_of_values.replace(array_of_values << 1)
    end
    array_of_values.inject(:+)
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
  
  def first_deal
    2.times do
      @gambler.decision_hit(new_card)
      @dealer.decision_hit(new_card)
    end
    display_bennetts
  end
  
  def gamblers_turn
    begin
      puts "Does #{@gambler.name} want to hit or stay? (h/s)"
      decision = gets.downcase.chomp
      system 'clear'
      if decision == "h"
        @gambler.decision_hit(new_card)
      end
      @gambler.calculate_total_player_hand
      display_bennetts
    end until decision != 'h' || @gambler.calculate_total_player_hand >= 21
  end
  
  def dealer_turn
    puts "Dealer's turn"
    begin
      @dealer.decision_hit(new_card)
      @dealer.show_card
      @dealer.calculate_total_player_hand
    end until @dealer.calculate_total_player_hand >= 17
    #system 'clear'
    display_bennetts
    display_dealer
  end
  
  def wellcome
    puts "Wellcome to BLACKJACK_OOP"
  end
  
  def display_bennetts
    puts "#####################"
    puts "#{@gambler.name} has:"
    puts "#{@gambler.player_hand}" 
    puts "Total value of cards: #{@gambler.calculate_total_player_hand}"
  end
  
  def display_dealer
    puts "#####################"
    puts "#{@dealer.name} has:"
    puts "#{@dealer.player_hand}" 
    puts "Total value of cards: #{@dealer.calculate_total_player_hand}"
  end
  
  def play
    wellcome
    @inGameDeck = Deck.new(Player.number_of_players)
    first_deal
    
    gamblers_turn
    dealer_turn
    #whoos_ma_winna
  end
end

Game.new.play

# dealer card show hide
# repeat
# player_hand and @card can be done better