class Graphiti::Sideload::ManyToMany < Graphiti::Sideload::HasMany
  def type
    :many_to_many
  end

  def through
    foreign_key.keys.first
  end

  def true_foreign_key
    foreign_key.values.first
  end

  def base_filter(parents)
    { true_foreign_key => ids_for_parents(parents).join(',') }
  end

  def infer_foreign_key
    raise 'You must explicitly pass :foreign_key for many-to-many relationships, or override in subclass to return a hash.'
  end

  def performant_assign?
    false
  end

  def assign_each(parent, children)
    children.select do |c|
      match = ->(ct) { ct.send(true_foreign_key) == parent.send(primary_key) }
      c.send(through).any?(&match)
    end
  end
end
