Rails.application.routes.draw do

  # 管理者用
  devise_for :admin,skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: 'homes#top'
    resources :customers

  end

  # ユーザー用
  devise_for :customers,controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions',
    passwords: 'public/passwords'
  }

  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  scope module: :public do
    root to: 'homes#top'
    get 'about'=>"homes#about",as: "about"
    get 'search' =>"searches#search"
    resources :posts do
      resource :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end

    resources :customers do
      member do
        get :favorites
      end
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'

    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end


