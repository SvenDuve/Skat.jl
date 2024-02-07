module Skat

using Random
# Write your package code here.

export Card, 
    Deck, 
    Player, 
    create_deck, 
    shuffle!, 
    deal!, 
    start_game,
    initiate_bidding,
    conduct_bidding_round,
    make_bid, 
    PLAYERDEAL, 
    SKATDEAL


PLAYERDEAL = [3, 4, 3]
SKATDEAL = [2, 0, 0]
BUBENMULTIPLIER = Dict(el => i for (i, el) in enumerate(["Kreuz", "Pik", "Herz", "Karo"]))


struct Card
    suit::String
    rank::String
end


struct Deck
    cards::Array{Card}
end


mutable struct Player
    hand::Array{Card}
    bid::Int
    hasPassed::Bool
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


function initiate_bidding(players::Vector{Player})
    # Initialize bidding
    for player in players
        player.bid = 0
        player.hasPassed = false
    end
    # Determine the order (assuming player 1 starts)
    return 1
end

function make_bid(player::Player, bid_value::Int)
    if bid_value > player.bid
        player.bid = bid_value
        player.hasPassed = false
    else
        player.hasPassed = true
    end
end

function conduct_bidding_round(players::Vector{Player}, start_player::Int)
    current_bid = 0
    active_player = start_player

    while true
        if !players[active_player].hasPassed
            # Here you can implement logic for the player (human or AI) to make a bid
            # For simplicity, let's assume a function `get_bid_value()` gets the bid value
            bid_value = get_bid_value(players[active_player], current_bid)
            make_bid(players[active_player], bid_value)
            current_bid = max(current_bid, bid_value)
        end

        active_player = mod1(active_player + 1, length(players))
        if all(p -> p.hasPassed || p.bid == current_bid, players)
            break
        end
    end

    # Determine the winning bidder
    winning_bidder = findmax(p -> p.bid, players)[2]
    return winning_bidder
end

function get_bid_value(player::Player, current_bid::Int)
    # Implement the logic to evaluate the player's hand and decide on a bid
    # This is a placeholder implementation and should be replaced with actual logic
    # For now, it just returns a random bid higher than the current bid

    # Calculate potential game value based on player's hand (to be implemented)
    potential_game_value = calculate_potential_game_value(player.hand)

    # Player bids higher than the current bid if they think they can win
    if potential_game_value > current_bid
        return current_bid + 10  # Incrementing by 10 as an example
    else
        return 0  # Passing
    end

end

function calculate_potential_game_value(hand::Vector{Card}, game_type::String)
    if game_type == "Null"
        # Null game values are fixed based on the type
        return calculate_null_game_value(hand)
    else
        multiplier = calculate_multiplier(hand, game_type)
        base_value = get_base_value(game_type)
        return base_value * multiplier
    end
end

function calculate_multiplier(hand::Vector{Card}, game_type::String)
    multiplier = 1  # Start with 1 for game

    # Add for consecutive Jacks or missing Jacks
    multiplier += count_consecutive_jacks(hand)

    # Additional points for Hand and Schneider, etc.
    if game_type == "Hand"
        multiplier += 1
    elseif game_type == "Schneider" # Assuming Schneider is declared
        multiplier += 1
    end

    return multiplier
end

function count_consecutive_jacks(hand::Vector{Card})
    # Logic to count the consecutive Jacks
    # This needs to check for the sequence of Jacks in the order Clubs, Spades, Hearts, Diamonds
    # Return the count of consecutive Jacks
end

function get_base_value(game_type::String)
    # Return the base value depending on the game type (Suit or Grand)
end

function calculate_null_game_value(hand::Vector{Card})
    # Return the fixed value for Null games based on specific conditions in the hand
end





end

