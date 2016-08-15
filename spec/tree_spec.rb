# Copyright 2016 Ryan Moore
# Contact: moorer@udel.edu
#
# This file is part of Iroki.
#
# Iroki is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Iroki is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Iroki.  If not, see <http://www.gnu.org/licenses/>.

require "spec_helper"

describe Iroki::Tree do
  let(:tree_str) { %q{('apple jawn',(pie_is,('really (good)',('and "tasty"','pie_good','pie_gdood'))));} }
  let(:blue_tag) { Iroki::Color.get_tag "blue" }
  let(:red_tag) { Iroki::Color.get_tag "red" }

  describe "::change_names" do
    it "changes the original names to iroki names" do
      tree = Bio::Newick.new(tree_str).tree

      expected_names = ["iroki0iroki",
                        "iroki1iroki",
                        "iroki2iroki",
                        "iroki3iroki",
                        "iroki4iroki",
                        "iroki5iroki",]

      Iroki::Tree.change_names tree

      actual_names = []
      tree.each_node { |n| actual_names << n.name if n.name }

      expect(actual_names).to eq expected_names
    end

    it "returns a hash with the iroki names to quoted orig names" do
      tree = Bio::Newick.new(tree_str).tree

      expected_hash = { "iroki0iroki" => %q{apple jawn},
                        # this one is wonky, newick spec changes
                        # unquoted spaces to underscores
                        "iroki1iroki" => %q{pie is},
                        "iroki2iroki" => %q{really (good)},
                        "iroki3iroki" => %q{and "tasty"},
                        "iroki4iroki" => %q{pie_good},
                        "iroki5iroki" => %q{pie_gdood}, }

      expect(Iroki::Tree.change_names tree).to eq expected_hash
    end

    it "raises if there is a duplicate in the original names"
  end

  describe "::gsub_iroki_newick_string" do
    context "with a name map" do
      it "changes iroki names to new names" do
        tre_str = "(iroki0iroki,(iroki1iroki,iroki2iroki));"

        iroki_to_name = { "iroki0iroki" => "s1",
                          "iroki1iroki" => "s2",
                          "iroki2iroki" => "s3", }

        name_map = { "s1" => "apple", "s2" => "pie", "s3" => "yummy" }

        output = "('apple',('pie','yummy'));"

        expect(Iroki::Tree.gsub_iroki_newick_string tre_str, iroki_to_name, name_map).
          to eq output
      end
    end

    context "without a name map" do
      it "changes iroki names to original names" do
        # it still needs to do this cos when printing the newick,
        # BioRuby does some fiddly things with the characters
        tre_str = "(iroki0iroki,(iroki1iroki,iroki2iroki));"

        iroki_to_name = { "iroki0iroki" => "s1",
                          "iroki1iroki" => "s2",
                          "iroki2iroki" => "s3", }

        output = "('s1',('s2','s3'));"

        expect(Iroki::Tree.gsub_iroki_newick_string tre_str, iroki_to_name).
          to eq output
      end
    end
  end

  describe "::iroki_to_color" do
    context "without a name map" do
      it "returns a hash with iroki_name => color" do
        iroki_to_name = { "iroki0iroki" => "s1",
                          "iroki1iroki" => "s2",
                          "iroki2iroki" => "s3", }

        color_map = { "s1" => { label: red_tag, branch: red_tag },
                      "s2" => { label: blue_tag, branch: blue_tag } }

        output = { "iroki0iroki" => { label: red_tag, branch: red_tag },
                   "iroki1iroki" => { label: blue_tag, branch: blue_tag },
                   "iroki2iroki" => { label: "", branch: "" }, }

        nil_val = { label: "", branch: "" }

        expect(Iroki::Tree.iroki_to_color iroki_to_name, color_map, nil, nil_val).
          to eq output
      end
    end

    context "with a name map" do
      context "color map is new_name => color" do
        it "returns a hash with iroki name => color" do
          iroki_to_name = { "iroki0iroki" => "s1",
                            "iroki1iroki" => "s2",
                            "iroki2iroki" => "s3", }

          name_map = { "s1" => "apple", "s2" => "pie", "s3" => "yummy" }

          color_map = { "apple" => { label: red_tag, branch: red_tag },
                        "pie"   => { label: blue_tag, branch: blue_tag } }

          output = { "iroki0iroki" => { label: red_tag, branch: red_tag },
                     "iroki1iroki" => { label: blue_tag, branch: blue_tag },
                     "iroki2iroki" => { label: "", branch: "" }, }

          nil_val = { label: "", branch: "" }


          expect(Iroki::Tree.iroki_to_color iroki_to_name, color_map, name_map, nil_val).
            to eq output
        end
      end

      context "color map is old_name => color" do
        it "returns a hash with iroki name => color" do
          iroki_to_name = { "iroki0iroki" => "s1",
                            "iroki1iroki" => "s2",
                            "iroki2iroki" => "s3", }

          name_map = { "s1" => "apple", "s2" => "pie", "s3" => "yummy" }

          color_map = { "s1" => { label: red_tag, branch: red_tag },
                        "s2" => { label: blue_tag, branch: blue_tag } }

          output = { "iroki0iroki" => { label: red_tag, branch: red_tag },
                     "iroki1iroki" => { label: blue_tag, branch: blue_tag },
                     "iroki2iroki" => { label: "", branch: "" }, }

          nil_val = { label: "", branch: "" }


          expect(Iroki::Tree.iroki_to_color iroki_to_name, color_map, name_map, nil_val).
            to eq output
        end
      end

      context "color map has both old and new names" do
        it "raises AbortIf::Exit" do
          iroki_to_name = { "iroki0iroki" => "s1",
                            "iroki1iroki" => "s2",
                            "iroki2iroki" => "s3", }

          name_map = { "s1" => "apple", "s2" => "pie", "s3" => "yummy" }

          color_map = { "s1" => { label: red_tag, branch: red_tag },
                        "pie" => { label: blue_tag, branch: blue_tag } }

          output = { "iroki0iroki" => { label: red_tag, branch: red_tag },
                     "iroki1iroki" => { label: blue_tag, branch: blue_tag },
                     "iroki2iroki" => { label: "", branch: "" }, }

          nil_val = { label: "", branch: "" }


          expect { Iroki::Tree.iroki_to_color iroki_to_name, color_map, name_map, nil_val }.
            to raise_error AbortIf::Exit
        end
      end
    end
  end
end
