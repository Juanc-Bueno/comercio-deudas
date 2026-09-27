json.partial! "api/v1/proveedores/proveedor", proveedor: @proveedor
json.facturas @facturas, partial: "api/v1/facturas/factura", as: :factura
