SUITS = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
@motherdeck = []

def mother_deck(motherdeck)
  motherdeck = SUITS.product(CARDS)
  motherdeck.shuffle!
end

@inGameDeck = mother_deck(@inGameDeck)
@inGameDeck = @inGameDeck * 2
p @inGameDeck