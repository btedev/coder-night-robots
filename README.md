Robots vs. Lasers
=================
Solution in Ruby for [puzzlenode puzzle #4](http://www.puzzlenode.com/puzzles/4-robots-vs-lasers).

Goal
----
My goal for this puzzle was to NOT use arrays or strings to store the puzzle
data. Instead I stored the laser positions using an [integer bitmap](http://en.wikipedia.org/wiki/Bit_array)
and parsed the input one char at a time.

Usage
-----
bundle

./destroy.rb < ../input.txt

Specs
-----
rspec destroyer_spec.rb
