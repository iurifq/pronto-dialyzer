# Pronto runner for Dialyzer

This allows you to take the output of Dialyzer and submit its errors with Pronto

## Installation

As an Elixir application will probably not have a Gemfile, install it with:

    $ gem install pronto-dialyzer

## Usage

It uses the environment variable `PRONTO_DIALYZER_OUTPUT` to define the location
of Dialyzer's output file. If that is not defined, the default is `dialyzer.out`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iurifq/pronto-dialyzer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
