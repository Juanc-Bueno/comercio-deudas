json.extract! factura, :id, :numero, :fecha_emision, :fecha_vencimiento, :total, :total_pagado, :saldo, :estado
json.proveedor do
  json.extract! factura.proveedor, :id, :nombre
end
