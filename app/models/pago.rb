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

    # El tope se mide contra los demás pagos: al editar uno, su monto anterior no debe contarse.
    pagado_por_otros = factura.pagos.where.not(id: id).sum(:monto)

    if monto > factura.total - pagado_por_otros
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
