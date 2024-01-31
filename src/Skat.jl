module Skat

using Random
# Write your package code here.

export Card, Deck, create_deck, shuffle!, deal!, start_game, PLAYERDEAL, SKATDEAL


PLAYERDEAL = [3, 4, 3]
SKATDEAL = [2, 0, 0]


struct Card
    suit::String
    rank::String
end

struct Deck
    cards::Array{Card}
end

# Code for initializing and managing a game of Skat
function create_deck()
    suits = ["Kreuz", "Pik", "Herz", "Karo"]
    ranks = ["7", "8", "9", "Bube", "Dame", "König", "10", "Ass"]
    return Deck([Card(suit, rank) for suit in suits for rank in ranks])
end

function shuffle!(deck::Deck)
    Random.shuffle!(deck.cards)
end


function deal!(deck::Deck, n::Int)
    return [pop!(deck.cards) for _ in 1:n]
end



end

