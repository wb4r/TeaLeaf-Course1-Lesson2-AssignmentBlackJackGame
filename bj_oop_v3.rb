
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
  attr_reader :name
  attr_accessor :status
  @@number_of_players = 0
  
  def initialize(name, status)
    @name = name
    @status = status
    @player_hand = []
    @@number_of_players += 1
  end
  
  def self.number_of_players
    @@number_of_players
  end
  
  def decision_hit(card)                     
    save_card_to_player_hand(card)
  end
  
  def save_card_to_player_hand(card)
    @player_hand << [card.suit, card.value]
  end
  
  def player_hand
    @player_hand
  end
  
  def calculate_total_value_hand
    ary_of_card_values = []

    @player_hand.each_index do |card, _|
      if @player_hand[card][1].to_i != 0
        ary_of_card_values << @player_hand[card][1].to_i
      elsif @player_hand[card][1] == "A"
        ary_of_card_values << 11
      else
        ary_of_card_values << 10
      end
    end
    if ary_of_card_values.inject(:+) > 21 && ary_of_card_values.max == 11
      ary_of_card_values.delete(11) 
      ary_of_card_values.replace(ary_of_card_values << 1)
    end
    ary_of_card_values.inject(:+)
  end
end


class Game
  attr_accessor :player_hand
  
  def initialize
    @gambler = Player.new("Jim Bennett", "hit")
    @dealer = Player.new("Casino Dealer", "hit")
  end
  
  # Wellcome and Displayability
  
  def wellcome
    puts "Wellcome to BLACKJACK_OOP"
  end
  
  def display_bennetts
    puts "#####################"
    blank_line
    puts "#{@gambler.name} has:"
    puts "#{@gambler.player_hand}" 
    puts "Total value of cards: #{@gambler.calculate_total_value_hand}"
  end
  
  def display_dealer
    puts "#####################"
    blank_line
    puts "#{@dealer.name} has:"
    if @gambler.status == "hit"
      puts "#{@dealer.player_hand[0]}" 
    else
      puts "#{@dealer.player_hand}"
      puts "Total value of cards: #{@dealer.calculate_total_value_hand}"
    end
  end
  
  def blank_line
    puts ""
  end
  
  def clear_screen
    system 'clear'
  end
  
  # Actual ENGINE of the game below
  
  def create_deck
    @inGameDeck = Deck.new(Player.number_of_players)
  end
  
  def first_deal
    2.times do
      @gambler.decision_hit(new_card)
      @dealer.decision_hit(new_card)
    end
    display_bennetts
    display_dealer
  end
  
  def new_card
    new_card = @inGameDeck.provide_card
    Card.new(new_card[0], new_card[1])
  end
  
  def gamblers_turn
    if @gambler.calculate_total_value_hand != 21
      begin
        puts "Does #{@gambler.name} want to hit or stay? (h/s)"
        decision = gets.downcase.chomp
        clear_screen
        if decision == "h"
          @gambler.decision_hit(new_card)
        end
        @gambler.calculate_total_value_hand
        display_bennetts
      end until decision != 'h' || @gambler.calculate_total_value_hand >= 21
    end
    @gambler.status = "stay"
  end
  
  def dealer_turn
    if @gambler.calculate_total_value_hand < 21
      puts "Dealer's turn"
      begin
        @dealer.decision_hit(new_card)
        @dealer.calculate_total_value_hand
      end until @dealer.calculate_total_value_hand >= 17
    end
    clear_screen
    display_bennetts
    display_dealer
  end
  
  def present_winner
    if @gambler.calculate_total_value_hand > 21  
      gambler_lost
    elsif @dealer.calculate_total_value_hand > 21 || @gambler.calculate_total_value_hand == 21
      gambler_won
    elsif @gambler.calculate_total_value_hand < 21 && @dealer.calculate_total_value_hand <= 21
      if @dealer.calculate_total_value_hand < @gambler.calculate_total_value_hand 
        gambler_won
      else gambler_lost
      end
    end
  end
  
  def gambler_lost
    blank_line
    puts "#{@gambler.name} LOST!"
    puts "#{@gambler.name}'s Total: #{@gambler.calculate_total_value_hand}"
    puts "#{@dealer.name}'s Total: #{@dealer.calculate_total_value_hand}"
  end
  
  def gambler_won
    blank_line
    puts "#{@gambler.name} WON!"
    puts "#{@gambler.name}'s Total: #{@gambler.calculate_total_value_hand}"
    puts "#{@dealer.name}'s Total: #{@dealer.calculate_total_value_hand}"
  end
  
  def replay?
    blank_line
    puts "---------------------------------"
    puts "Do you want to play again? (y/n)"
    replay = gets.downcase.chomp
    if replay == 'y'
      clear_screen
      reset(@gambler.player_hand, @dealer.player_hand)
      play
    else 
      clear_screen
      puts "Goodbye!"
    end
  end
  
  def reset(gambler, dealer)
    gambler.clear
    dealer.clear
    @gambler.status = "hit"
  end
  
  def play
    wellcome
    create_deck
    first_deal
    gamblers_turn
    dealer_turn
    present_winner
    replay?
  end
end

Game.new.play