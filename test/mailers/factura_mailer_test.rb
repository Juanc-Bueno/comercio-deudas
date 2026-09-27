require "test_helper"

class FacturaMailerTest < ActionMailer::TestCase
  test "avisa a los administradores que la factura está por vencer" do
    factura = facturas(:parcial)
    mail = FacturaMailer.proxima_a_vencer(factura)

    assert_equal [ "admin@petshop.test" ], mail.to
    assert_equal [ "avisos@petshop.test" ], mail.from
    assert_equal "Aviso: la factura 0001-00000052 de Alimentos del Sur vence el #{I18n.l(factura.fecha_vencimiento)}",
                 mail.subject

    [ mail.text_part, mail.html_part ].each do |parte|
      assert_match "$ 140.000,00", parte.decoded
      assert_match "http://example.com/admin/facturas/#{factura.id}", parte.decoded
    end
  end
end
