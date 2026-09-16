# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end

# Los modelos del dominio están en español: sin estas reglas Rails generaría
# tablas y rutas como "proveedors" o "medio_de_pagos".
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "proveedor", "proveedores"
  inflect.irregular "medio_de_pago", "medios_de_pago"
end
