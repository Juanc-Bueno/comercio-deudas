# Preview all emails at http://localhost:3000/rails/mailers/factura_mailer
class FacturaMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/factura_mailer/proxima_a_vencer
  def proxima_a_vencer
    FacturaMailer.proxima_a_vencer(Factura.all.reject(&:pagada?).first)
  end
end
