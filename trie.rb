module Trie

  require 'set'

  class PrefixTree

    def initialize
      @tree = {}
    end

    def add_word(word)
      current_node = @tree

      word.chars.each do |c|
        current_node[c] ||= {}
        current_node = current_node[c]
      end

      current_node[:leaf] = true
    end

    def remove_word(word)
      current_node = @tree
      last_essential_node = @tree
      last_node_key = word[0]

      word.length.times do |idx|
        return false if !current_node[word[idx]]
        if current_node.keys != [word[idx]]
          last_essential_node = current_node
          last_node_key = word[idx]
        end
        current_node = current_node[word[idx]]
      end

      if current_node.keys == [:leaf]
        last_essential_node.delete(last_node_key)
      else
        current_node.delete(:leaf)
      end
      return true
    end

    def include?(word)
      current_node = @tree

      word.length.times do |idx|
        return false if !current_node[word[idx]]
        current_node = current_node[word[idx]]
      end

      current_node[:leaf] ? true : false
    end
  end

  class IndexedPrefixTree
    def initialize(str)
      @tree = {}
      add_all_subs(str)
    end

    def add_word(word, idx)
      current_node = @tree

      word.chars.each do |c|
        current_node[c] ||= Trie::IndexedPrefixTreeNode.new
        current_node[c].add_idx(idx)
        current_node = current_node[c]
      end
    end

    def find(str)
      current_node = @tree

      str.length.times do |idx|
        return nil if !current_node[str[idx]]
        current_node = current_node[str[idx]]
      end

      return current_node.get_indices
    end

    private

    def add_all_subs(str)
      str.downcase!
      s = 0

      while s < str.length do
        e = s
        while e < str.length do
          add_word(str[s..e], s)
          e += 1
        end
        s += 1
      end
    end
  end

  class IndexedPrefixTreeNode < Hash
    def initialize
      @indices = Set.new
    end

    def get_indices
      @indices.to_a
    end

    def add_idx(idx)
      @indices.add(idx)
    end
  end
end
