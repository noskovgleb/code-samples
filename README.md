# Development Experience Examples

This document highlights several examples of professional software development practices from my codebase, demonstrating experience with modern Ruby on Rails patterns and principles.

## Service Objects Pattern

Our codebase uses the Service Objects pattern to encapsulate complex business logic. Here's an example from our user registration process:

```ruby
class UserRegistrationService
  def initialize(params)
    @params = params
  end

  def call
    return false unless valid?

    ActiveRecord::Base.transaction do
      create_user
      send_welcome_email
      notify_admin
    end

    true
  rescue StandardError => e
    # Handle errors appropriately
    false
  end

  private

  def valid?
    # Validate input parameters
    @params.present? && @params[:email].present?
  end

  def create_user
    @user = User.create!(@params)
  end

  def send_welcome_email
    UserMailer.welcome_email(@user).deliver_later
  end

  def notify_admin
    AdminNotifier.new_user_registered(@user)
  end
end
```

## Form Objects Pattern

We use Form Objects to handle complex form validations and data processing:

```ruby
class UserRegistrationForm
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }
  validate :password_match

  def save
    return false unless valid?

    User.create(user_attributes)
  end

  private

  def password_match
    return if password == password_confirmation
    errors.add(:password_confirmation, "doesn't match password")
  end

  def user_attributes
    {
      email: email,
      password: password
    }
  end
end
```

## Policy Objects Pattern

We implement authorization using Policy objects, following the principle of separation of concerns:

```ruby
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
    user.present? && user.active?
  end

  def update?
    user.present? && (user.admin? || user.id == article.user_id)
  end

  def destroy?
    user.present? && user.admin?
  end
end
```

## RESTful API Controllers

Our API controllers follow REST principles and include proper error handling:

```ruby
module Api
  module V1
    class ArticlesController < ApplicationController
      before_action :set_article, only: [:show, :update, :destroy]

      def index
        @articles = Article.includes(:user, :comments)
        render json: @articles
      end

      def create
        @article = Article.new(article_params)

        if @article.save
          render json: @article, status: :created
        else
          render json: @article.errors, status: :unprocessable_entity
        end
      end

      private

      def set_article
        @article = Article.find(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :content, :published)
      end
    end
  end
end
```

These examples demonstrate experience with:

1. Service-Oriented Architecture
2. Form Objects for complex validations
3. Policy Objects for authorization
4. RESTful API design
5. Transaction handling
6. Error handling
7. Code organization and separation of concerns
