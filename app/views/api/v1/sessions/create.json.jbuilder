json.token @usuario.token
json.usuario do
  json.extract! @usuario, :id, :nombre, :email, :rol
end
