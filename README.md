# Iroki #

[![Gem Version](https://badge.fury.io/rb/iroki.svg)](https://badge.fury.io/rb/iroki) [![Build Status](https://travis-ci.org/mooreryan/iroki.svg?branch=master)](https://travis-ci.org/mooreryan/iroki) [![Coverage Status](https://coveralls.io/repos/github/mooreryan/iroki/badge.svg?branch=master)](https://coveralls.io/github/mooreryan/iroki?branch=master)

Command line app and library code for Iroki, a phylogenetic tree
customization program.

## Installation ##

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

## Version Info ##

### 0.0.1 ###

Migrate from [color_tree](https://github.com/mooreryan/color_tree) to
Iroki.

### 0.0.2 ###

Add [iroki](https://github.com/mooreryan/iroki/blob/master/exe/iroki)
executable, and use RubyGems for installation.

### 0.0.3 ###

Add a [Dockerfile](https://github.com/mooreryan/iroki/blob/master/Dockerfile) and a [wrapper script](https://github.com/mooreryan/iroki/blob/master/exe/iroki_docker) for running Iroki with Docker.

### 0.0.4 ###

Fix the `iroki_docker` install bug.

### 0.0.5 ###

Add `newick_to_phyloxml` script.

### 0.0.6 ###

Add branch length and bootstraps to `newick_to_phyloxml`.
