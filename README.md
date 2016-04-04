# Pronto runner for Dialyzer

This allows you to take the output of Dialyzer and submit its errors with
[Pronto]. It works with both Elixir and Erlang.

## Installation

As an Elixir/Erlang application will probably not have a `Gemfile`, install it with:

    $ gem install pronto-dialyzer

After the gem is installed, [Pronto] will already detect the Dialyzer
runner.

## Usage

It's important to enable the `-fullpath` option in your Dialyzer configuration
and send the output to a file with `-o`.

The path for Dialyzer's output file should then be passed to the runner. It uses
the environment variable `PRONTO_DIALYZER_OUTPUT` to define the location of
Dialyzer's output file. If this variable is not defined, it will look for the
file `dialyzer.out`.

### Running on Travis CI

Pronto works perfectly to create comment on PRs and commits. For that, use
`pronto run` as described in the readme for [Pronto].

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iurifq/pronto-dialyzer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


[Pronto]: https://github.com/mmozuras/pronto
