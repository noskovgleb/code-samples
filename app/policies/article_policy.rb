class ArticlePolicy
  attr_reader :user, :article

  def initialize(user, article)
    @user = user
    @article = article
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (user.admin? || user.id == article.user_id)
  end

  def destroy?
    user.present? && (user.admin? || user.id == article.user_id)
  end
end