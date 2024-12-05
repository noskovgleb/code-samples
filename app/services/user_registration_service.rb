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
    false
  end

  private

  attr_reader :params, :user

  def valid?
    params[:email].present? && params[:password].present?
  end

  def create_user
    @user = User.create!(params)
  end

  def send_welcome_email
    UserMailer.welcome_email(user).deliver_later
  end

  def notify_admin
    AdminNotificationService.new(user).notify
  end
end