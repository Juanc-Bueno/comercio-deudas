require "test_helper"

class Admin::FacturasControllerTest < ActionDispatch::IntegrationTest
  setup do
    post admin_session_path, params: { email: "admin@petshop.test", password: "admin12345" }
  end

  test "adjunta un comprobante a la factura y lo muestra en el detalle" do
    factura = facturas(:pendiente)

    patch admin_factura_path(factura),
          params: { factura: { comprobante: fixture_file_upload("comprobante.pdf", "application/pdf") } }

    assert_redirected_to admin_factura_path(factura)
    assert factura.reload.comprobante.attached?

    follow_redirect!
    assert_select "a", text: "comprobante.pdf"
  end
end
