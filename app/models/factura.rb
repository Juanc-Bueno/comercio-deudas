class Factura < ApplicationRecord
  belongs_to :proveedor
  has_many :pagos, dependent: :destroy

  normalizes :numero, with: ->(numero) { numero.strip }

  validates :numero, presence: true, uniqueness: { scope: :proveedor_id }
  validates :fecha_emision, presence: true
  validates :fecha_vencimiento, presence: true
  validates :total, numericality: { greater_than: 0 }
  validate :vencimiento_posterior_a_emision

  def total_pagado
    pagos.sum(:monto)
  end

  def saldo
    total - total_pagado
  end

  def pagada?
    saldo <= 0
  end

  def vencida?
    !pagada? && fecha_vencimiento < Date.current
  end

  def estado
    return :pagada if pagada?
    return :vencida if vencida?

    total_pagado.positive? ? :parcial : :pendiente
  end

  private

  def vencimiento_posterior_a_emision
    return if fecha_emision.blank? || fecha_vencimiento.blank?

    if fecha_vencimiento < fecha_emision
      errors.add(:fecha_vencimiento, "no puede ser anterior a la fecha de emisión")
    end
  end
end
