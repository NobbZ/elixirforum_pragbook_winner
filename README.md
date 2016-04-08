# Pragbook

## Compiling

* First fetch and build the dependencies: `mix do deps.get, deps.build`
* Then just do a simple `mix escript.build`, a file `pragbook` will be created by this.

## Usage

`./pragbook [month]`

Given a `month`s name, it will fetch the ranking of that month and
tell you who the winner was/has the best chances to be the winner.

When no month is given, it will check for the current month.
