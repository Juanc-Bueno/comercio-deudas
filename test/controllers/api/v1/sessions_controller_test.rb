require "test_helper"

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "el login devuelve un token nuevo del usuario" do
    post api_v1_session_path, params: { email: "operador@petshop.test", password: "operador12345" }

    assert_response :created
    assert_equal usuarios(:operador).reload.token, response.parsed_body["token"]
    assert_not_equal "token-del-operador", response.parsed_body["token"]
    assert_equal "operador", response.parsed_body.dig("usuario", "rol")
  end

  test "el login falla con una contraseña incorrecta" do
    post api_v1_session_path, params: { email: "operador@petshop.test", password: "otra-clave" }

    assert_response :unauthorized
    assert_nil response.parsed_body["token"]
  end

  test "el logout invalida el token" do
    encabezados = con_token(usuarios(:operador))

    delete api_v1_session_path, headers: encabezados
    assert_response :no_content

    get api_v1_facturas_path, headers: encabezados
    assert_response :unauthorized
  end
end
