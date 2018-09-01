# Nim

This repository contains a game AI to play Nim with a human user  for Deakin Artificial and Computational Intelligence PBL Task 3.

The AI implements a minimax tree search in Ruby.

## Solution Details

The project contains a representation of the Nim game in a class called Board. This class represents a single game board state that knows information about itself (number of piles, number of tiles on each pile) and what legal board states are can be reached from this state.

The problem representation permits between 2 - 5 piles, and up to 2(piles) + 1 tiles. The board state is represented as an 1d array of n piles, each of which is an int representing the number of piles on that tile.

The project contains a Minimax class, which supports state space search according to a standard minimax algorithm. The algorithm does not employ alpha-beta pruning, as it was preferred to make the initial search complete, so that no recalculation is required throughout the gameplay (as would be required to cater for humans making sub-ideal moves if using pruning).

A game engine exists in the Game class, which coordinates game play for the user using a command line interface.

## Usage

This application was developed using Ruby 2.4.2. This version is recommended. There are no external library dependencies.

To use this solution:

1. Download the code from the [GitHub repository](https://github.com/PhilipCastiglione/SIT215_PBL3)
2. Navigate inside the folder
3. Run the code using `ruby run.rb`

#### Running Notes

You may alternatively run using `DEBUG=1 ruby run.rb` to run with invariants enabled for testing.

Because the minimax algorithm does not employ pruning, increasing the number of tiles above the current limit will result in combinatorial explosion and potentially slow running times.
