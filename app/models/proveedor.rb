class Proveedor < ApplicationRecord
  has_many :facturas, dependent: :restrict_with_error

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :cuit, with: ->(cuit) { cuit.gsub(/\D/, "") }

  validates :nombre, presence: true
  validates :cuit, presence: true, uniqueness: true,
                   format: { with: /\A\d{11}\z/, message: "debe tener 11 dígitos" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  scope :activos, -> { where(activo: true) }

  def saldo_total
    facturas.sum(&:saldo)
  end
end
