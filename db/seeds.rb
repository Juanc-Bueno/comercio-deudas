# Datos mínimos para entrar al back-office y ver el flujo de facturas y pagos.
# Se puede correr varias veces sin duplicar nada: bin/rails db:seed

admin = Usuario.find_or_initialize_by(email: "admin@petshop.test")
admin.update!(nombre: "Administrador", rol: :admin, password: "admin12345")

operador = Usuario.find_or_initialize_by(email: "operador@petshop.test")
operador.update!(nombre: "Operador", rol: :operador, password: "operador12345")

medios = [ "Efectivo", "Transferencia", "Cheque", "Tarjeta de crédito" ].map do |nombre|
  MedioDePago.find_or_create_by!(nombre: nombre)
end
transferencia = medios.second

proveedores = {
  "30712345678" => { nombre: "Alimentos del Sur", email: "ventas@alimentosdelsur.test", telefono: "221 456-7890" },
  "30698765432" => { nombre: "Distribuidora Patitas", email: "pedidos@patitas.test", telefono: "221 555-1234" },
  "27345678901" => { nombre: "Veterinaria Mayorista", email: "info@vetmayorista.test", telefono: "11 4567-8900" }
}.map do |cuit, datos|
  proveedor = Proveedor.find_or_initialize_by(cuit: cuit)
  proveedor.update!(datos)
  proveedor
end

# Una factura por estado posible: vencida, parcial, pagada y pendiente.
vencida = Factura.find_or_create_by!(proveedor: proveedores.first, numero: "0001-00000045") do |factura|
  factura.fecha_emision = Date.current - 50
  factura.fecha_vencimiento = Date.current - 5
  factura.total = 185_000
end

parcial = Factura.find_or_create_by!(proveedor: proveedores.first, numero: "0001-00000052") do |factura|
  factura.fecha_emision = Date.current - 20
  factura.fecha_vencimiento = Date.current + 10
  factura.total = 240_000
end

pagada = Factura.find_or_create_by!(proveedor: proveedores.second, numero: "0002-00000310") do |factura|
  factura.fecha_emision = Date.current - 35
  factura.fecha_vencimiento = Date.current - 5
  factura.total = 96_500
end

Factura.find_or_create_by!(proveedor: proveedores.third, numero: "0003-00001204") do |factura|
  factura.fecha_emision = Date.current - 3
  factura.fecha_vencimiento = Date.current + 27
  factura.total = 42_300
end

# Para probar el aviso: bin/rails facturas:avisar_vencimientos
Factura.find_or_create_by!(proveedor: proveedores.second, numero: "0002-00000345") do |factura|
  factura.fecha_emision = Date.current - 27
  factura.fecha_vencimiento = Date.current + Factura::DIAS_DE_AVISO
  factura.total = 58_750
end

if parcial.pagos.empty?
  parcial.pagos.create!(medio_de_pago: transferencia, usuario: admin,
                        monto: 90_000, fecha: Date.current - 12)
end

if pagada.pagos.empty?
  pagada.pagos.create!(medio_de_pago: transferencia, usuario: admin,
                       monto: 50_000, fecha: Date.current - 30)
  pagada.pagos.create!(medio_de_pago: medios.first, usuario: operador,
                       monto: 46_500, fecha: Date.current - 20)
end

puts "Listo. Proveedores: #{Proveedor.count}, facturas: #{Factura.count}, pagos: #{Pago.count}."
puts "Back-office: admin@petshop.test / admin12345"
puts "API: operador@petshop.test / operador12345"
