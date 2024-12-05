class UserRegistrationForm
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation, 
                :first_name, :last_name, :terms_accepted

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true
  validates :terms_accepted, acceptance: true
  validate :password_match

  def save
    return false unless valid?
    
    user = User.new(user_attributes)
    if user.save
      UserRegistrationService.new(user).call
      true
    else
      errors.merge!(user.errors)
      false
    end
  end

  private

  def password_match
    return if password.blank? || password_confirmation.blank?
    errors.add(:password_confirmation, "doesn't match password") if password != password_confirmation
  end

  def user_attributes
    {
      email: email,
      password: password,
      first_name: first_name,
      last_name: last_name
    }
  end
end