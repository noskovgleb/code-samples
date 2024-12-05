class UsersQuery
  attr_reader :relation

  def initialize(relation = User.all)
    @relation = relation
  end

  def active
    relation.where(status: 'active')
  end

  def created_this_month
    relation.where('created_at >= ?', Time.current.beginning_of_month)
  end

  def search(term)
    relation.where('name LIKE ? OR email LIKE ?', "%#{term}%", "%#{term}%")
  end
end