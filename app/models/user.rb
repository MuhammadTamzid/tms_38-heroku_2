class User < ActiveRecord::Base
  include PrettyUrl

  has_many :course_users
  has_many :courses, through: :course_users
  has_many :user_subjects
  has_many :subjects, through: :user_subjects
  has_many :completed_tasks
  has_many :tasks, through: :completed_tasks
  has_many :activities, dependent: :destroy
  has_many :reports, dependent: :destroy

  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  enum role: [:supervisor, :trainee]

  scope :supervisors, ->{supervisor}
  scope :trainees, ->{trainee}

  ROLE = { supervisor: 'supervisor', trainee: 'trainee' }

  class << self
    def search_by_course_id course_id
      if course_id && !course_id.empty?
        course = Course.find course_id
        course.users
      else
        User.all
      end
    end
  end

  # Returns the hash digest of the given string.
  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(self.remember_token)
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    self.remember_token = nil
    update_attributes remember_digest: nil
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
