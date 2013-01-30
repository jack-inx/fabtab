MFTModule1::Application.routes.draw do

  devise_for :users, :controllers => {:confirmations => "xdevise/confirmations", :registrations => "registrations", :sessions=>"xdevise/sessions", :passwords => "devise/passwords"}, :skip=>[:sessions] do
    get "/users/confirmation", :to => "xdevise/confirmations#show"
    post "confirm_user", :to => "xdevise/confirmations#confirm_user"
    get 'signin' => 'xdevise/sessions#new', :as => :new_user_session
    post 'signin' => 'xdevise/sessions#create', :as => :user_session
    delete 'signout' => 'xdevise/sessions#destroy', :as => :destroy_user_session
    match 'users/auth/:provider/callback' => 'xdevise/sessions#omniauth', :via => :get
    match 'users/:provider/fb_twitter' => 'xdevise/sessions#fb_twitter', :via => :get
  end
  
  resources :ads do
    get '/optin', :to => 'ads#optin'
    member do
      post 'rate'
    end
  end
  
  resources :users
  resources :categories do
    member do
      delete 'destroy_category'
      get 'offers'
      get 'my_local_offers'
    end
  end
  resources :registrations
  resources :demos
  resources :optin_ads
  resources :groups
  resources :brands do
    member do
      get 'ads'
    end
  end
  
  resources :offers
  resources :settings
  resources :authentications
  resources :brand_requests
  resources :demo_images
  resources :feedback

resources :templates
match 'run/:format'=>"templates#run"
 match "templates/delete_selection"=>"templates#delete_at_index"
match "/my/sample/ind" => "ads#index"
  match 'db'=>"templates#download_db"

  match 'delete_file'=>"templates#delete_file"
  match '/ads/flags_ad/:id'=>'ads#flags_ad'
  match '/ads/remove_ad/:id'=>'ads#remove_ad'
  match '/ads/ads_statuschange/:id'=>'ads#ads_statuschange', :as => "ads_statuschange"
  match '/ads/ads_statusunchange/:id'=>'ads#ads_statusunchange', :as => "ads_statusunchange"
  match '/offers/new_offer/:id' => 'offers#new_offer' , :as => "new_coupans"
  match '/offers/edit_coupan/:id' => 'offers#edit_coupan' , :as => "edit_coupans"
  match '/offers/update_coupan/:id' => 'offers#update_coupan' , :as => "update_coupans"
  match '/offers/state_city_list/:state_code' => 'offers#state_city_list'
  match '/ads/tabit_category_list' => 'ads#tabit_category_list'
  match '/user/settings' => 'users#settings'
  match '/optin_ads/save' => 'optin_ads#save'
  match '/optin_ads/refer' => 'optin_ads#refer'
  match '/demo/:id' => 'demos#demo'
  match '/ads/save'=>'ads#save'
  match '/ads/:id/test'=>'ads#test'

  match '/myfabtab' => 'ads#wrapper'
  match '/redirect' => 'redirection#redirect'
  match '/about' => 'home#about'
  match '/tabit' => 'home#tabit'
  match '/team' => 'home#team'
  match '/help' => 'home#help'
  match '/terms' => 'home#terms'
  match '/promo_help' => 'home#promo_help'
  match '/promo_tabit' => 'home#promo_tabit'
  match '/promo_terms' => 'home#promo_terms'
  match '/promo_team' => 'home#promo_team'
  match '/promo_create' => 'home#promo_create'
  match '/promo_invite' => 'home#promo_invite'
  match '/promo_create' => 'feedback#promo_create'
  match 'js/bookmarkads' => 'Js#bookmarkads'
  match '/search' => 'search#search'
  match '/search_username' => 'users#search_username'
  match '/status_change/:id' => 'users#status_change', :as => "status_change"
  match '/status_unchange/:id' => 'users#status_unchange', :as => "status_unchange"
  match '/adminstatus_change/:id' => 'users#adminstatus_change', :as => "adminstatus_change"
  match '/adminstatus_unchange/:id' => 'users#adminstatus_unchange', :as => "adminstatus_unchange"
  match '/predictive_search' => 'search#predictive_search'
  match '/invite' => 'users#invite'
  match '/invite/email' => 'users#email'
  match '/setting/category_list' => 'settings#category_list'
  match '/setting/category_ads/:id' => 'settings#category_ads', :as => "category_ads"
  match '/setting/allusersads' => 'settings#allusersads'
  match '/setting/multipleads' => 'settings#multipleads'
  match '/setting/destroy_ads/:id' => 'settings#destroy_ads', :as => "destroy_ads"
  match '/setting/destroy_userscategories/:id' => 'settings#destroy_userscategories', :as => "destroy_userscategories"
  match '/setting/ignore_notification/:id' => 'settings#ignore_notification', :as => "ignore_ad"
  match '/setting/flag_ads' => 'settings#flag_ads'
  match '/setting' => 'settings#parameters'
  match '/setting/multipleuser' => 'settings#multipleuser'
  match '/setting/sort_username' => 'settings#sort_username'
  match '/setting/users_list' => 'settings#users_list'
  match '/setting/new_users' => 'settings#new_users'
  match '/setting/create_users' => 'settings#create_users'
  match '/setting/edit_users/:id' => 'settings#edit_users', :as => "edit_users"
  match '/setting/update_users/:id' => 'settings#update_users', :as => "update_users"
  match '/setting/destroy_users/:id' => 'settings#destroy_users', :as => "destroy_users"
  match '/setting/show_users/:id' => 'settings#show_users', :as => "show_users"
  match '/setting/destroy_fbtw/:id' => 'settings#destroy_fbtw' , :as => "destroy_fbtw"
  match '/admin/edit' => 'settings#edit'
  match '/follow_brand' => 'users#follow_brand'
  match '/my_local_offers_without_category' => 'categories#my_local_offers_without_category'
  get '/category_list' => 'categories#category_list'
  get '/local_storage_data' => 'categories#local_storage_data'
  match '/search_offers' => 'ads#search_offers'
  get '/search_offer_by_brand' => 'offers#search_offer_by_brand'
  match '/search_ads' => 'ads#search_ads'
  post '/snapit', :to => 'ads#snapit'
  get '/scanit', :to => 'ads#scanit'
  post 'ad_fb_comment/:ad_id/:fb_comment_id' => 'ads#ad_fb_comment'
  get '/ads_show/:ad_id', :to => 'ads#ads_show'
  get '/omniauth_fb/:uid/:email' => 'settings#omniauth_fb'
  get '/omniauth_tw/:uid' => 'settings#omniauth_tw'
  resources :templates do
    
  end
  resources :purposes

  match 'unsubscribe_me' => "registrations#unsubscribe"

  match "templates/delete_selection"=>"templates#delete_at_index"
  match 'master_password'=>'settings#master_password'
  match 'new_mpassword' => 'settings#new_mpassword'

  get '/home/render_div'=>'home#render_div'

  root :to=> 'home#index'
end
