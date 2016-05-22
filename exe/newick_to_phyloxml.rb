#!/usr/bin/env ruby

require "set"
require "bio"

def leaf? tree, node
  tree.children(node).empty?
end

newick = ARGV.first

treeio = Bio::FlatFile.open(Bio::Newick, newick)

newick = treeio.next_entry
$tree = newick.tree

$xml_start = %q{<phyloxml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.phyloxml.org http://www.phyloxml.org/1.10/phyloxml.xsd" xmlns="http://www.phyloxml.org">
<phylogeny rooted="false">
<clade>
}

$xml_end = %q{</clade>
</phylogeny>
</phyloxml>
}

added_nodes = Set.new

def leaf? tree, node
  tree.descendents(node).count.zero?
end

def make_xml_string descendents
  while (node = descendents.shift)
    unless $already_added.include? node
      if leaf? $tree, node
        $xml_start << "<clade>\n<name>#{node.name}</name>\n</clade>\n"
        $already_added << node
      else
        STDERR.puts "LOG -- recurse"
        $xml_start << "<clade>\n"
        make_xml_string $tree.descendents(node)
        $xml_start << "</clade>\n"
        $already_added << node
      end
    end
  end
end

$already_added = Set.new

$descendents = $tree.descendents($tree.root)

make_xml_string $descendents

puts $xml_start
puts "#{$xml_end}"

warn $tree.output_newick(indent: false)
