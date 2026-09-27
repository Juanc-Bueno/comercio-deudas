require "test_helper"

class Api::V1::ProveedoresControllerTest < ActionDispatch::IntegrationTest
  test "lista los proveedores con su saldo total" do
    get api_v1_proveedores_path, headers: con_token(usuarios(:operador))

    assert_response :success
    alimentos = response.parsed_body.find { |proveedor| proveedor["id"] == proveedores(:alimentos).id }
    assert_equal proveedores(:alimentos).saldo_total.to_s, alimentos["saldo_total"]
  end
end
