require "test_helper"

class FacturaTest < ActiveSupport::TestCase
  def nueva_factura(**atributos)
    Factura.new({
      proveedor: proveedores(:patitas),
      numero: "0002-00000400",
      fecha_emision: Date.current,
      fecha_vencimiento: Date.current + 30,
      total: 50_000
    }.merge(atributos))
  end

  test "es válida con los datos mínimos" do
    assert nueva_factura.valid?
  end

  test "el saldo es el total cuando no tiene pagos" do
    assert_equal 100_000, facturas(:pendiente).saldo
  end

  test "el saldo descuenta los pagos registrados" do
    assert_equal 100_000, facturas(:parcial).total_pagado
    assert_equal 140_000, facturas(:parcial).saldo
  end

  test "el saldo es cero cuando los pagos cubren el total" do
    assert_equal 0, facturas(:pagada).saldo
  end

  test "el saldo se recalcula al registrar un pago nuevo" do
    factura = facturas(:pendiente)
    factura.pagos.create!(monto: 30_000, fecha: Date.current,
                          medio_de_pago: medios_de_pago(:efectivo), usuario: usuarios(:admin))

    assert_equal 70_000, factura.saldo
  end

  test "estado pendiente sin pagos y antes del vencimiento" do
    assert_equal :pendiente, facturas(:pendiente).estado
  end

  test "estado parcial con pagos que no cubren el total" do
    assert_equal :parcial, facturas(:parcial).estado
  end

  test "estado pagada aunque la fecha de vencimiento ya haya pasado" do
    assert_equal :pagada, facturas(:pagada).estado
  end

  test "estado vencida con saldo y vencimiento pasado" do
    assert_equal :vencida, facturas(:vencida).estado
  end

  test "el vencimiento prevalece sobre el pago parcial" do
    factura = facturas(:parcial)
    factura.update!(fecha_emision: Date.current - 40, fecha_vencimiento: Date.current - 1)

    assert_equal :vencida, factura.estado
  end

  test "no está vencida el mismo día del vencimiento" do
    factura = facturas(:pendiente)
    factura.update!(fecha_vencimiento: Date.current)

    assert_equal :pendiente, factura.estado
  end

  test "el vencimiento no puede ser anterior a la emisión" do
    factura = nueva_factura(fecha_emision: Date.current, fecha_vencimiento: Date.current - 1)

    assert_not factura.valid?
    assert_includes factura.errors[:fecha_vencimiento], "no puede ser anterior a la fecha de emisión"
  end

  test "el vencimiento puede coincidir con la emisión" do
    assert nueva_factura(fecha_vencimiento: Date.current).valid?
  end

  test "requiere número y fechas" do
    factura = nueva_factura(numero: "", fecha_emision: nil, fecha_vencimiento: nil)

    assert_not factura.valid?
    assert factura.errors.added?(:numero, :blank)
    assert factura.errors.added?(:fecha_emision, :blank)
    assert factura.errors.added?(:fecha_vencimiento, :blank)
  end

  test "el total debe ser mayor a cero" do
    assert_not nueva_factura(total: 0).valid?
    assert_not nueva_factura(total: -100).valid?
  end

  test "el número es único por proveedor" do
    repetida = nueva_factura(proveedor: proveedores(:alimentos), numero: facturas(:pendiente).numero)

    assert_not repetida.valid?
    assert repetida.errors.added?(:numero, :taken, value: repetida.numero)
  end

  test "el mismo número se puede repetir en otro proveedor" do
    assert nueva_factura(numero: facturas(:pendiente).numero).valid?
  end

  test "normaliza el número quitando espacios" do
    assert_equal "0002-00000400", nueva_factura(numero: "  0002-00000400 ").numero
  end

  test "al eliminarla se eliminan sus pagos" do
    assert_difference("Pago.count", -2) do
      facturas(:pagada).destroy
    end
  end
end
