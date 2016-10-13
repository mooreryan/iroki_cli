# Change Log #

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

### 0.0.22 ###

- Strip whitespace from beginning and end of entries in color map and name map

### 0.0.23 ###

- `Iroki::Main::main` returns the nexus string (for `iroki.net`)

### 0.0.24 ###

- Add `Iroki::Main::iroki_job` runs Iroki w/o needing an output file (for `iroki.net`)

### 0.0.25 ###

- Bugfix

### 0.0.26 ###

- Basic validation of Newick files (issue 9)

### 0.0.27 ###

- Remove some debugging statements

### 0.0.28 ###

- Update `Dockerfile`
- Let user choose default color (issue 15)
