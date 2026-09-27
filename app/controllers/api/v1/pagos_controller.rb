module Api
  module V1
    class PagosController < BaseController
      def create
        @factura = Factura.find(params[:factura_id])
        @pago = @factura.pagos.new(pago_params)
        @pago.usuario = usuario_actual

        if @pago.save
          render :create, status: :created
        else
          render json: { errores: @pago.errors }, status: :unprocessable_content
        end
      end

      private

      def pago_params
        params.expect(pago: [ :monto, :fecha, :medio_de_pago_id ])
      end
    end
  end
end
