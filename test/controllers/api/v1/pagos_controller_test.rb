require "test_helper"

class Api::V1::PagosControllerTest < ActionDispatch::IntegrationTest
  def registrar_pago(factura, monto:)
    post api_v1_factura_pagos_path(factura),
         params: { pago: { monto: monto, fecha: Date.current, medio_de_pago_id: medios_de_pago(:efectivo).id } },
         headers: con_token(usuarios(:operador))
  end

  test "registra el pago a nombre del usuario del token" do
    assert_difference("Pago.count", 1) do
      registrar_pago(facturas(:pendiente), monto: 30_000)
    end

    assert_response :created
    assert_equal usuarios(:operador), Pago.last.usuario
    assert_equal "70000.0", response.parsed_body.dig("factura", "saldo")
  end

  test "rechaza un pago que supera el saldo" do
    assert_no_difference("Pago.count") do
      registrar_pago(facturas(:parcial), monto: 140_001)
    end

    assert_response :unprocessable_content
    assert_includes response.parsed_body.dig("errores", "monto"),
                    "no puede superar el saldo pendiente de la factura"
  end
end
