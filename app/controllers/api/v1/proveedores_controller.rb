module Api
  module V1
    class ProveedoresController < BaseController
      def index
        @proveedores = Proveedor.order(:nombre)
      end

      def show
        @proveedor = Proveedor.find(params[:id])
        @facturas = @proveedor.facturas.order(fecha_vencimiento: :asc)
      end
    end
  end
end
