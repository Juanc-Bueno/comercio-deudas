module Api
  module V1
    class FacturasController < BaseController
      def index
        @facturas = Factura.includes(:proveedor).with_attached_comprobante.order(fecha_vencimiento: :asc)
      end

      def show
        @factura = Factura.find(params[:id])
        @pagos = @factura.pagos.includes(:medio_de_pago, :usuario).order(fecha: :desc)
      end
    end
  end
end
