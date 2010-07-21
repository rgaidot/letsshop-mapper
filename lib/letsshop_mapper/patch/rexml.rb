module REXML
  def each_child_element(&block)
    self.elements.each { |node|
      block.call(node)
    }
  end
end