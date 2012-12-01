LaBamba::Application.routes.draw do
  resource :highlander do
    member do
      post 'dictionary'
    end
  end

  root :to => 'highlanders#show'
end
