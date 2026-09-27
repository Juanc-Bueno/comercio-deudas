json.extract! pago, :id, :monto, :fecha
json.medio_de_pago do
  json.extract! pago.medio_de_pago, :id, :nombre
end
json.usuario do
  json.extract! pago.usuario, :id, :nombre
end
