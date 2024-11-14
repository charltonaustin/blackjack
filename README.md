## Install dependencies
`bundle install`

## Run tests
`bundle exec rspec ./blackjack_spec.rb`

## User stories
#### Game Setup
1. **As a Player, I want to choose the number of players (1-5) in the game** so that I can play with the desired number of participants.
2. **As a Player, I want to set the starting balance for each player** so that everyone begins the game with equal or custom funds.
3. **As a Player, I want to select the number of decks used in the game** so that I can customize the difficulty and randomness.

#### Betting Phase
4. **As a Player, I want to place a bet before each round** so that I can gamble a portion of my balance.
5. **As a Player, I want to be warned if I try to bet more than my available balance** so that I don't accidentally bankrupt myself.

#### Dealing Phase
6. **As a Player, I want to receive two cards at the beginning of each round** so that I can start the game with a hand.
7. **As the Dealer, I want to reveal one of my two cards while keeping the other hidden** so that players can decide their next move based on partial information.

#### Player Actions
8. **As a Player, I want the option to "hit" to receive another card** so that I can try to improve my hand.
9. **As a Player, I want the option to "stay" to keep my current hand** so that I can avoid risking a bust.
10. **As a Player, I want to automatically win if I have a blackjack (Ace and 10-value card)** so that I can be rewarded for a perfect starting hand.
11. **As a Player, I want to know my current hand value at all times** so that I can make informed decisions.
12. **As a Player, I want to be notified if my hand value exceeds 21** so that I know I have busted.

#### Dealer Actions
13. **As the Dealer, I want to automatically draw cards until my hand value is 17 or higher** so that I follow the standard rules of blackjack.
14. **As the Dealer, I want to reveal my hidden card at the end of the round** so that players can see my final hand.

#### Round Resolution
15. **As a Player, I want to win double my bet if my hand value beats the dealer's without exceeding 21** so that I am rewarded for winning.
16. **As a Player, I want to receive 2.5x my bet if I win with a blackjack** so that I get a bonus for this rare outcome.
17. **As a Player, I want my bet returned if my hand value ties with the dealer's** so that I don’t lose in a tie situation.
18. **As a Player, I want to lose my bet if my hand value is lower than the dealer's or I bust** so that the game follows traditional blackjack rules.

#### Game Continuation
19. **As a Player, I want to play multiple rounds without restarting the game** so that I can enjoy continuous gameplay.
20. **As a Player, I want to be prompted to play another round or quit after each round** so that I can decide when to stop.
21. **As a Player, I want my balance to persist across rounds** so that I can track my winnings or losses over time.

#### Game Over
22. **As a Player, I want the game to end when my balance reaches zero** so that I can no longer participate without funds.
23. **As a Player, I want to see a summary of my performance when the game ends** so that I can review my final balance and gameplay statistics.

