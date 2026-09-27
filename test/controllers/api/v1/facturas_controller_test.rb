require "test_helper"

class Api::V1::FacturasControllerTest < ActionDispatch::IntegrationTest
  test "sin token responde 401" do
    get api_v1_facturas_path

    assert_response :unauthorized
  end

  test "con un token inválido responde 401" do
    get api_v1_facturas_path, headers: { "Authorization" => "Bearer inventado" }

    assert_response :unauthorized
  end

  test "lista las facturas con su saldo y estado" do
    get api_v1_facturas_path, headers: con_token(usuarios(:operador))

    assert_response :success
    assert_equal Factura.count, response.parsed_body.size

    parcial = response.parsed_body.find { |factura| factura["id"] == facturas(:parcial).id }
    assert_equal "140000.0", parcial["saldo"]
    assert_equal "parcial", parcial["estado"]
  end

  test "muestra una factura con sus pagos" do
    get api_v1_factura_path(facturas(:pagada)), headers: con_token(usuarios(:operador))

    assert_response :success
    assert_equal "pagada", response.parsed_body["estado"]
    assert_equal 2, response.parsed_body["pagos"].size
    assert_nil response.parsed_body["comprobante_url"]
  end

  test "incluye la URL del comprobante cuando la factura tiene uno" do
    factura = facturas(:pendiente)
    factura.comprobante.attach(fixture_file_upload("comprobante.pdf", "application/pdf"))

    get api_v1_factura_path(factura), headers: con_token(usuarios(:operador))

    assert_match %r{/rails/active_storage/blobs/.+/comprobante\.pdf\z}, response.parsed_body["comprobante_url"]
  end

  test "una factura inexistente responde 404" do
    get api_v1_factura_path(id: 0), headers: con_token(usuarios(:operador))

    assert_response :not_found
  end
end
