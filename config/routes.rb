Rails.application.routes.draw do
  namespace :admin do
    root "facturas#index"

    resource :session, only: [ :new, :create, :destroy ]

    resources :proveedores
    resources :facturas do
      resources :pagos, only: [ :new, :create ]
    end
    resources :pagos, only: [ :edit, :update, :destroy ]
    resources :medios_de_pago, except: [ :show ]
    resources :usuarios, except: [ :show ]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  root to: redirect("/admin")
end
