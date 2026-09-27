json.extract! factura, :id, :numero, :fecha_emision, :fecha_vencimiento, :total, :total_pagado, :saldo, :estado
json.proveedor do
  json.extract! factura.proveedor, :id, :nombre
end
json.comprobante_url factura.comprobante.attached? ? rails_blob_url(factura.comprobante) : nil
