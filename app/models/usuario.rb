class Usuario < ApplicationRecord
  has_secure_password

  has_many :pagos, dependent: :restrict_with_error

  # Los administradores usan el back-office; los operadores solo la API.
  ROLES = { operador: 0, admin: 1 }.freeze
  enum :rol, ROLES, default: :operador

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :nombre, presence: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true
end
