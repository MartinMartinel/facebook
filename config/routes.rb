Rails.application.routes.draw do
  devise_scope :user do
    root to: 'devise/registrations#new'
  end

  devise_for :users,
             :controllers => { :registrations => "registrations" },
             :skip => [:sessions]

  as :user do
    get    'login'  => 'devise/sessions#new',     :as => :new_user_session
    post   'login'  => 'devise/sessions#create',  :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get    'signup' => 'registrations#new'
  end

end
