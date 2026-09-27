class Factura < ApplicationRecord
  TIPOS_DE_COMPROBANTE = %w[ application/pdf image/jpeg image/png ].freeze
  PESO_MAXIMO_DE_COMPROBANTE = 5.megabytes
  DIAS_DE_AVISO = 3

  belongs_to :proveedor
  has_many :pagos, dependent: :destroy
  has_one_attached :comprobante

  normalizes :numero, with: ->(numero) { numero.strip }

  validates :numero, presence: true, uniqueness: { scope: :proveedor_id }
  validates :fecha_emision, presence: true
  validates :fecha_vencimiento, presence: true
  validates :total, numericality: { greater_than: 0 }
  validate :vencimiento_posterior_a_emision
  validate :comprobante_valido

  # Fecha exacta y no un rango: el aviso se envía una vez por día, así cada factura se avisa una sola vez.
  def self.proximas_a_vencer
    where(fecha_vencimiento: Date.current + DIAS_DE_AVISO).includes(:proveedor).reject(&:pagada?)
  end

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

  def comprobante_valido
    return unless comprobante.attached?

    unless comprobante.content_type.in?(TIPOS_DE_COMPROBANTE)
      errors.add(:comprobante, "debe ser un PDF o una imagen JPG o PNG")
    end

    if comprobante.byte_size > PESO_MAXIMO_DE_COMPROBANTE
      errors.add(:comprobante, "no puede pesar más de 5 MB")
    end
  end
end
