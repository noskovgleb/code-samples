class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Callbacks
  after_create :create_profile

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :admins, -> { where(admin: true) }

  # Instance Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def active?
    status == 'active'
  end

  def admin?
    admin == true
  end

  private

  def create_profile
    build_profile.save
  end
end