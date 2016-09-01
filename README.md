[![Iroki](https://github.com/mooreryan/iroki/blob/master/assets/images/iroki_logo2.png)](https://github.com/mooreryan/iroki/blob/master/assets/images/iroki_logo2.png)

# Iroki #

[![Gem Version](https://badge.fury.io/rb/iroki.svg)](https://badge.fury.io/rb/iroki)
[![Build Status](https://travis-ci.org/mooreryan/iroki.svg?branch=master)](https://travis-ci.org/mooreryan/iroki)
[![Coverage Status](https://coveralls.io/repos/github/mooreryan/iroki/badge.svg?branch=master)](https://coveralls.io/github/mooreryan/iroki?branch=master)
[![GitHub issues](https://img.shields.io/github/issues/mooreryan/iroki.svg)](https://github.com/mooreryan/iroki/issues)
[![GitHub license](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://raw.githubusercontent.com/mooreryan/iroki/master/COPYING)

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

### 0.0.7 ###

Add `reorder_nodes` script.

### 0.0.8 ###

- Add auto coloring with Kelly theme
- Add ability to color branches and labels separately

### 0.0.9 ###

- Add single sample color gradients (one and two color)

### 0.0.10 ###

- Fix Jess's bug

### 0.0.11 ###

- Add two color, two group color gradients from biom files

### 0.0.12 ###

- Bug fixes

### 0.0.13 ###

- Handle bad command line input

### 0.0.14 ###

- Add more specs and various improvements

### 0.0.15 ###

- `.ruby-version` file was being weird when user didn't have the correct ruby

### 0.0.16 ###

- Allow unusual characters in label names ([GitHub issue](https://github.com/mooreryan/iroki/issues/2))
- Fix no method `clean` bug ([GitHub issue](https://github.com/mooreryan/iroki/issues/3))

### 0.0.17 ###

- Color map can override color gradient from biom file

### 0.0.18 ###

- `Iroki::Main::main` returns `:success` (for `iroki.net`)

### 0.0.19 ###

- Remove assertion that color map cannot have entries that aren't in the newick file

### 0.0.20 ###

- Handle more examples of bad biom files and bad name maps

### 0.0.21 ###

- Fix empty branch tag bug (issue 6)

