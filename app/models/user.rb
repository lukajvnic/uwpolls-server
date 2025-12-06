class User < ApplicationRecord
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_presence_on_email_signup
  validate :at_least_one_auth_method

  def self.find_or_create_from_google(google_id, email)
    user = find_by(google_id: google_id)
    return user if user

    # If email exists but no google_id, link it
    user = find_by(email: email)
    if user
      user.update(google_id: google_id)
      return user
    end

    create!(email: email, google_id: google_id)
  end

  def email_authentication?
    password_digest.present?
  end

  private

  def password_presence_on_email_signup
    if google_id.blank? && password.blank?
      errors.add(:password, "can't be blank for email signup")
    end
  end

  def at_least_one_auth_method
    if password_digest.blank? && google_id.blank?
      errors.add(:base, "must have at least one authentication method")
    end
  end
end
