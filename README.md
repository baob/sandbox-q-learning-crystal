# README

As a means to understanding Q-Learning, a game of noughts and crosses /
tic-tac-toe

Includes varied player policies that are hardcoded, and a q-learning policy that
can be trained.

It's very much a toolkit, an exploration, not a finished gem

## USE

The way to use it is via irb (ruby). Something like:

    $ irb -I lib -r series
    > ql = Policy::QLearning.new # set up our untrained q-learning 'policy'
    > Game.new(ql, Policy::WinRandom, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)
    > Series.new(ql, Policy::WinRandom, 500).play  # to run a training series

