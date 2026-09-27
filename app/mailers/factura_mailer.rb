class FacturaMailer < ApplicationMailer
  def proxima_a_vencer(factura)
    @factura = factura

    mail to: Usuario.admin.pluck(:email),
         subject: "Aviso: la factura #{factura.numero} de #{factura.proveedor.nombre} " \
                  "vence el #{l(factura.fecha_vencimiento)}"
  end
end
