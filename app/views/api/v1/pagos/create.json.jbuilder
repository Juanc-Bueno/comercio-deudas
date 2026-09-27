json.partial! "api/v1/pagos/pago", pago: @pago
json.factura do
  json.partial! "api/v1/facturas/factura", factura: @factura
end
