require "test_helper"

class UsuarioTest < ActiveSupport::TestCase
  def nuevo_usuario(**atributos)
    Usuario.new({ nombre: "Nuevo", email: "nuevo@petshop.test", password: "clave12345" }.merge(atributos))
  end

  test "es válido con los datos mínimos" do
    assert nuevo_usuario.valid?
  end

  test "el rol por defecto es operador" do
    assert nuevo_usuario.operador?
  end

  test "autentica con la contraseña correcta" do
    assert usuarios(:admin).authenticate("admin12345")
    assert_not usuarios(:admin).authenticate("otra-clave")
  end

  test "la contraseña debe tener al menos 8 caracteres" do
    assert_not nuevo_usuario(password: "corta").valid?
  end

  test "no exige contraseña al actualizar otros datos" do
    usuario = usuarios(:operador)

    assert usuario.update(nombre: "Operador de caja")
  end

  test "normaliza el email" do
    assert_equal "nuevo@petshop.test", nuevo_usuario(email: " Nuevo@PetShop.test ").email
  end

  test "el email es único" do
    usuario = nuevo_usuario(email: "ADMIN@petshop.test")

    assert_not usuario.valid?
    assert usuario.errors.added?(:email, :taken, value: "admin@petshop.test")
  end

  test "el email debe tener formato válido" do
    assert_not nuevo_usuario(email: "sin-arroba").valid?
  end

  test "no se puede eliminar si registró pagos" do
    usuario = usuarios(:admin)

    assert_no_difference("Usuario.count") { usuario.destroy }
    assert usuario.errors[:base].any?
  end
end
