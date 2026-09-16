class Pago < ApplicationRecord
  belongs_to :factura
  belongs_to :medio_de_pago
  belongs_to :usuario

  validates :monto, numericality: { greater_than: 0 }
  validates :fecha, presence: true
  validate :monto_no_supera_saldo
  validate :fecha_posterior_a_emision

  private

  def monto_no_supera_saldo
    return if factura.blank? || monto.blank? || factura.total.blank?

    # Al editar un pago ya guardado su propio monto sigue descontado del saldo,
    # así que hay que devolverlo antes de comparar.
    saldo_disponible = factura.saldo + (persisted? ? monto_in_database : 0)

    if monto > saldo_disponible
      errors.add(:monto, "no puede superar el saldo pendiente de la factura")
    end
  end

  def fecha_posterior_a_emision
    return if factura.blank? || fecha.blank? || factura.fecha_emision.blank?

    if fecha < factura.fecha_emision
      errors.add(:fecha, "no puede ser anterior a la emisión de la factura")
    end
  end
end
