#Solitaire

This is an app to simulate Solitaire. 

Things to impliment:

- Command line arguments that specify:
	- 1 or 3 card draws
	- The number of games to play
	- The scoring methodology
	- Output options:
		- Potential CSV files:
			- Gametype, Win/Lose, Starting field, Number of cards scored
		- Visualize each turn with ASCII
- Impact on missing a random card or two

The questions I want to answer:

- What is the ideal starting field?
	- All one color? Or mixed?
	- Do you want more low cards or face cards to start?
- What % of games are won


For the refactor:
- Make TABLE which owns stock, waste, tableaus, foundations. It maintains state and accepts actions.
- Make Pile into FoundationPile and TableauPile objects for cleaner code