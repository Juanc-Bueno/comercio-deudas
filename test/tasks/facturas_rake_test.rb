require "test_helper"
require "rake"

class FacturasRakeTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("facturas:avisar_vencimientos")
    Rake::Task["facturas:avisar_vencimientos"].reenable
  end

  def avisar_vencimientos
    salida, _errores = capture_io { Rake::Task["facturas:avisar_vencimientos"].invoke }
    salida
  end

  test "envía un aviso por cada factura impaga que vence dentro de los días de aviso" do
    facturas(:pendiente).update!(fecha_vencimiento: Date.current + Factura::DIAS_DE_AVISO)

    assert_emails 1 do
      assert_equal "Avisos enviados: 1\n", avisar_vencimientos
    end
  end

  test "no envía nada si ninguna factura vence dentro de los días de aviso" do
    assert_no_emails do
      assert_equal "Avisos enviados: 0\n", avisar_vencimientos
    end
  end
end
