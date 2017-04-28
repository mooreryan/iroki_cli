[![Iroki](https://github.com/mooreryan/iroki/blob/master/assets/images/iroki_logo3.png)](https://github.com/mooreryan/iroki/blob/master/assets/images/iroki_logo3.png)

# Iroki #

[![Gem Version](https://badge.fury.io/rb/iroki.svg)](https://badge.fury.io/rb/iroki)
[![Build Status](https://travis-ci.org/mooreryan/iroki.svg?branch=master)](https://travis-ci.org/mooreryan/iroki)
[![Coverage Status](https://coveralls.io/repos/github/mooreryan/iroki/badge.svg?branch=master)](https://coveralls.io/github/mooreryan/iroki?branch=master)
[![GitHub issues](https://img.shields.io/github/issues/mooreryan/iroki.svg)](https://github.com/mooreryan/iroki/issues)
[![GitHub license](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://raw.githubusercontent.com/mooreryan/iroki/master/COPYING)

Command line app and library code for Iroki, a phylogenetic tree
customization program.

## Citation ##

Iroki is research software. If you use Iroki, please cite the Iroki [preprint](http://biorxiv.org/content/early/2017/04/25/106138.1):

```
Moore RM, Harrison AO, McAllister SM , Marine RL, Chan CS, and Wommack KE. 2017. Iroki: automatic customization for phylogenetic trees. bioRxiv doi:10.1101/106138
```

## Documentation ##

For in depth docs and examples, please see the [Iroki wiki](https://github.com/mooreryan/iroki/wiki) page.

## Installation ##

### Using the web app

Iroki has a web app ([iroki.net](http://www.iroki.net/)). The [code](https://github.com/mooreryan/iroki_web) for that is also on GitHub.

### Running with Docker ###

See the [wiki](https://github.com/mooreryan/iroki/wiki).

### Use the command line app with RubyGems ###

If you already have a working Ruby environment, run this

    $ gem install iroki

Then type `which iroki` and you should see something like this

    /Users/mooreryan/.rvm/gems/ruby-2.2.4@iroki/bin/iroki

If so, you are good to go!

### To use the library code ###

Add this line to your application's Gemfile:

```ruby
gem 'iroki'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iroki

## Other programs ##

### Newick format to PhyloXML ###

- `exe/newick_to_phyloxml`

This will be installed when you run `gem install iroki`.

*Usage*: `newick_to_phyloxml tree.newick > tree.phyloxml`

*Note*: No specs for this as of yet.

## Development ##

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `rake spec` to run the tests. You can also run
`bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing ##

Bug reports and pull requests are welcome on GitHub at
https://github.com/mooreryan/iroki. This project is intended to
be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of
conduct.
