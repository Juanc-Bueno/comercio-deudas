require "test_helper"

class ProveedorTest < ActiveSupport::TestCase
  test "el saldo total suma los saldos de todas sus facturas" do
    assert_equal 100_000 + 140_000 + 185_000, proveedores(:alimentos).saldo_total
  end

  test "el saldo total es cero si todo está pagado" do
    assert_equal 0, proveedores(:patitas).saldo_total
  end

  test "el saldo total es cero si no tiene facturas" do
    assert_equal 0, proveedores(:sin_facturas).saldo_total
  end

  test "normaliza el CUIT quitando guiones y espacios" do
    assert_equal "20123456789", Proveedor.new(cuit: "20-12345678-9 ").cuit
  end

  test "el CUIT debe tener 11 dígitos" do
    proveedor = Proveedor.new(nombre: "Nuevo", cuit: "2012345678")

    assert_not proveedor.valid?
    assert_includes proveedor.errors[:cuit], "debe tener 11 dígitos"
  end

  test "el CUIT es único" do
    proveedor = Proveedor.new(nombre: "Duplicado", cuit: "30-71234567-8")

    assert_not proveedor.valid?
    assert proveedor.errors.added?(:cuit, :taken, value: "30712345678")
  end

  test "requiere nombre" do
    proveedor = Proveedor.new(cuit: "20123456789")

    assert_not proveedor.valid?
    assert proveedor.errors.added?(:nombre, :blank)
  end

  test "el email es opcional pero debe tener formato válido" do
    assert Proveedor.new(nombre: "Nuevo", cuit: "20123456789", email: "").valid?
    assert_not Proveedor.new(nombre: "Nuevo", cuit: "20123456789", email: "no-es-un-email").valid?
  end

  test "normaliza el email" do
    assert_equal "ventas@nuevo.test", Proveedor.new(email: " Ventas@Nuevo.TEST ").email
  end

  test "no se puede eliminar si tiene facturas" do
    proveedor = proveedores(:alimentos)

    assert_no_difference("Proveedor.count") { proveedor.destroy }
    assert proveedor.errors[:base].any?
  end

  test "se puede eliminar si no tiene facturas" do
    assert_difference("Proveedor.count", -1) { proveedores(:sin_facturas).destroy }
  end

  test "el scope activos excluye a los inactivos" do
    assert_not_includes Proveedor.activos, proveedores(:sin_facturas)
    assert_includes Proveedor.activos, proveedores(:alimentos)
  end
end
