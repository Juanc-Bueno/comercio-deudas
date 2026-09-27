json.partial! "api/v1/facturas/factura", factura: @factura
json.pagos @pagos, partial: "api/v1/pagos/pago", as: :pago
