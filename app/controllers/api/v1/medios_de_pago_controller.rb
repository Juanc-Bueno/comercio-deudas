module Api
  module V1
    class MediosDePagoController < BaseController
      def index
        @medios_de_pago = MedioDePago.activos.order(:nombre)
      end
    end
  end
end
