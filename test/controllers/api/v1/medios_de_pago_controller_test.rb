require "test_helper"

class Api::V1::MediosDePagoControllerTest < ActionDispatch::IntegrationTest
  test "lista solo los medios de pago activos" do
    get api_v1_medios_de_pago_path, headers: con_token(usuarios(:operador))

    assert_response :success
    assert_equal [ "Efectivo", "Transferencia" ], response.parsed_body.pluck("nombre")
  end
end
