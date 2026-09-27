require "test_helper"

class PagoTest < ActiveSupport::TestCase
  def nuevo_pago(factura, **atributos)
    factura.pagos.new({
      monto: 10_000,
      fecha: Date.current,
      medio_de_pago: medios_de_pago(:efectivo),
      usuario: usuarios(:operador)
    }.merge(atributos))
  end

  test "es válido con los datos mínimos" do
    assert nuevo_pago(facturas(:pendiente)).valid?
  end

  test "puede cancelar exactamente el saldo pendiente" do
    assert nuevo_pago(facturas(:parcial), monto: 140_000).valid?
  end

  test "no puede superar el saldo pendiente" do
    pago = nuevo_pago(facturas(:parcial), monto: 140_000.01)

    assert_not pago.valid?
    assert_includes pago.errors[:monto], "no puede superar el saldo pendiente de la factura"
  end

  test "no admite pagos sobre una factura ya pagada" do
    assert_not nuevo_pago(facturas(:pagada), monto: 1).valid?
  end

  test "al editarlo no cuenta su propio monto anterior" do
    pago = pagos(:parcial)

    assert pago.update(monto: 240_000)
    assert_not pago.update(monto: 240_000.01)
  end

  test "al editarlo sí cuenta los demás pagos de la factura" do
    pago = pagos(:pagada_segunda)

    assert pago.update(monto: 50_000)
    assert_not pago.update(monto: 50_001)
  end

  test "el monto debe ser mayor a cero" do
    assert_not nuevo_pago(facturas(:pendiente), monto: 0).valid?
    assert_not nuevo_pago(facturas(:pendiente), monto: -500).valid?
  end

  test "la fecha no puede ser anterior a la emisión de la factura" do
    factura = facturas(:pendiente)
    pago = nuevo_pago(factura, fecha: factura.fecha_emision - 1)

    assert_not pago.valid?
    assert_includes pago.errors[:fecha], "no puede ser anterior a la emisión de la factura"
  end

  test "la fecha puede coincidir con la emisión de la factura" do
    factura = facturas(:pendiente)

    assert nuevo_pago(factura, fecha: factura.fecha_emision).valid?
  end

  test "requiere factura, medio de pago, usuario y fecha" do
    pago = Pago.new(monto: 1_000)

    assert_not pago.valid?
    assert pago.errors.added?(:factura, :blank)
    assert pago.errors.added?(:medio_de_pago, :blank)
    assert pago.errors.added?(:usuario, :blank)
    assert pago.errors.added?(:fecha, :blank)
  end
end
