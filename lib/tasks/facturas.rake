namespace :facturas do
  desc "Envía a los administradores el aviso de las facturas impagas próximas a vencer"
  task avisar_vencimientos: :environment do
    facturas = Factura.proximas_a_vencer
    facturas.each { |factura| FacturaMailer.proxima_a_vencer(factura).deliver_now }

    puts "Avisos enviados: #{facturas.size}"
  end
end
