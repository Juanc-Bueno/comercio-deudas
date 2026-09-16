module Admin
  class MediosDePagoController < BaseController
    before_action :set_medio_de_pago, only: [ :edit, :update, :destroy ]

    def index
      @medios_de_pago = MedioDePago.order(:nombre)
    end

    def new
      @medio_de_pago = MedioDePago.new
    end

    def edit
    end

    def create
      @medio_de_pago = MedioDePago.new(medio_de_pago_params)

      if @medio_de_pago.save
        redirect_to admin_medios_de_pago_path, notice: "Medio de pago creado."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @medio_de_pago.update(medio_de_pago_params)
        redirect_to admin_medios_de_pago_path, notice: "Medio de pago actualizado."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      if @medio_de_pago.destroy
        redirect_to admin_medios_de_pago_path, notice: "Medio de pago eliminado."
      else
        redirect_to admin_medios_de_pago_path, alert: @medio_de_pago.errors.full_messages.to_sentence
      end
    end

    private

    def set_medio_de_pago
      @medio_de_pago = MedioDePago.find(params[:id])
    end

    def medio_de_pago_params
      params.expect(medio_de_pago: [ :nombre, :activo ])
    end
  end
end
