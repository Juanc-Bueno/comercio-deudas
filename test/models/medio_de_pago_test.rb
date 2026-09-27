require "test_helper"

class MedioDePagoTest < ActiveSupport::TestCase
  test "requiere nombre" do
    assert_not MedioDePago.new(nombre: " ").valid?
  end

  test "el nombre es único sin distinguir mayúsculas" do
    assert_not MedioDePago.new(nombre: "EFECTIVO").valid?
  end

  test "normaliza el nombre quitando espacios" do
    assert_equal "Tarjeta de débito", MedioDePago.new(nombre: " Tarjeta de débito ").nombre
  end

  test "no se puede eliminar si tiene pagos" do
    medio = medios_de_pago(:transferencia)

    assert_no_difference("MedioDePago.count") { medio.destroy }
    assert medio.errors[:base].any?
  end

  test "se puede eliminar si no tiene pagos" do
    assert_difference("MedioDePago.count", -1) { medios_de_pago(:cheque).destroy }
  end

  test "el scope activos excluye a los inactivos" do
    assert_not_includes MedioDePago.activos, medios_de_pago(:cheque)
  end
end
