

class PrefixTreeNode < Hash
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

class PrefixTree
  def initialize(str)
    @tree = {}
    add_all_subs(str)
  end

  def add_word(word, idx)
    current_node = @tree

    word.chars.each do |c|
      current_node[c] ||= PrefixTreeNode.new
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
end

private

def add_all_subs(str)
  len = str.length
  s = 0

  while s < len do
    e = s
    while e < len do
      add_word(str[s..e], s)
      e += 1
    end
    s += 1
  end
end
