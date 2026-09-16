class MedioDePago < ApplicationRecord
  has_many :pagos, dependent: :restrict_with_error

  normalizes :nombre, with: ->(nombre) { nombre.strip }

  validates :nombre, presence: true, uniqueness: { case_sensitive: false }

  scope :activos, -> { where(activo: true) }
end
