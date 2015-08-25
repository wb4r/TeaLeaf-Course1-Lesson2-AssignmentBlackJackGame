require 'pry'

class Deck
  SUITS = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    
  def initialize
    @in_game_deck = mother_deck(@in_game_deck)
    @in_game_deck = @in_game_deck
  end
  
  def mother_deck(motherdeck)
    motherdeck = SUITS.product(CARDS)
    motherdeck.shuffle!
  end
  
  def provide_card
    @in_game_deck.pop
  end
end


class Card
  attr_reader :suit, :value
  
  def initialize(suit, value)
    @suit = suit
    @value = value
  end
end


class Player
  attr_accessor :status, :name

  def initialize(name)
    @name = name
    @status = status
    self.status = 'hit'
    @player_hand = []
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
    ary_of_card_values.sort!
    while ary_of_card_values.inject(:+) > 21 && ary_of_card_values.max == 11
      ary_of_card_values.pop
      ary_of_card_values << 1
      ary_of_card_values.sort!
    end
    ary_of_card_values.inject(:+)
  end
end


class Game
  def initialize
    @gambler1 = Player.new("Jim Bennett")
    @dealer = Player.new("Casino Dealer")
  end
  
  # Wellcome and Displayability
  
  def wellcome
    puts "Wellcome to BLACKJACK_OOP"
  end
  
  def display_gambler1
    puts "#####################"
    blank_line
    puts "#{@gambler1.name} has:"
    puts "#{@gambler1.player_hand}" 
    puts "Total value of cards: #{@gambler1.calculate_total_value_hand}"
  end
  
  def display_dealer
    puts "#####################"
    blank_line
    puts "#{@dealer.name} has:"
    if @gambler1.status == "hit"
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
    @in_game_deck = Deck.new
  end
  
  def first_deal
    2.times do
      @gambler1.decision_hit(new_card)
      @dealer.decision_hit(new_card)
    end
    display_gambler1
    display_dealer
  end
  
  def new_card
    new_card = @in_game_deck.provide_card
    Card.new(new_card[0], new_card[1])
  end
  
  def gambler1s_turn
    if @gambler1.calculate_total_value_hand != 21
      begin
        puts "Does #{@gambler1.name} want to hit or stay? (h/s)"
        decision = gets.downcase.chomp
        clear_screen
        if decision == "h"
          @gambler1.decision_hit(new_card)
        end
        @gambler1.calculate_total_value_hand
        display_gambler1
      end until decision != 'h' || @gambler1.calculate_total_value_hand >= 21
    end
    @gambler1.status = "stay"
  end
  
  def dealer_turn
    if @gambler1.calculate_total_value_hand < 21
      puts "Dealer's turn"
      begin
        @dealer.decision_hit(new_card)
        @dealer.calculate_total_value_hand
      end until @dealer.calculate_total_value_hand >= 17
    end
    clear_screen
    display_gambler1
    display_dealer
  end
  
  def present_winner
    if @gambler1.calculate_total_value_hand > 21  
      gambler1_lost
    elsif @dealer.calculate_total_value_hand > 21 || @gambler1.calculate_total_value_hand == 21
      gambler1_won
    elsif @gambler1.calculate_total_value_hand < 21 && @dealer.calculate_total_value_hand <= 21
      if @dealer.calculate_total_value_hand < @gambler1.calculate_total_value_hand 
        gambler1_won
      else gambler1_lost
      end
    end
  end
  
  def gambler1_lost
    blank_line
    @gambler1.name = "Jim 'Sad' Bennett"
    puts "#{@gambler1.name} LOST!"
    puts "#{@gambler1.name}'s Total: #{@gambler1.calculate_total_value_hand}"
    puts "#{@dealer.name}'s Total: #{@dealer.calculate_total_value_hand}"
  end
  
  def gambler1_won
    blank_line
    puts "#{@gambler1.name} WON!"
    puts "#{@gambler1.name}'s Total: #{@gambler1.calculate_total_value_hand}"
    puts "#{@dealer.name}'s Total: #{@dealer.calculate_total_value_hand}"
  end
  
  def replay?
    blank_line
    puts "---------------------------------"
    puts "Do you want to play again? (y/n)"
    replay = gets.downcase.chomp
    if replay == 'y'
      clear_screen
      reset(@gambler1.player_hand, @dealer.player_hand)
      play
    else 
      clear_screen
      puts "Goodbye!"
    end
  end
  
  def reset(gambler1, dealer)
    gambler1.clear
    dealer.clear
    @gambler1.name = "Jim Bennett"
    @gambler1.status = "hit"
  end
  
  def play
    wellcome
    create_deck
    first_deal
    gambler1s_turn
    dealer_turn
    present_winner
    replay?
  end
end

Game.new.play

#failing if 1st deal to benett is two Aces

=begin

Hi Brandon, thanks! I made these changes:
- deleted @@number_of_players
- changed the code on deleting Aces value 11
- default players status is now 'hit'
- display_bennet is now display_gambler1 and @gambler is now @gambler1
- 

Your Game#new_card method takes the suit and value for a card and creates that 
card on the fly. You should create your cards when initializing the deck, 
then just pass what Deck#provide_card returns, which will be an instance of Card


=end