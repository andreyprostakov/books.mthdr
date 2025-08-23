Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api do
    scope constraints: ->(req) { req.format == :json } do
      namespace :authors do
        resources :full_entries, only: %i[show create update destroy]
        resources :index_entries, only: %i[show index]
        resources :ref_entries, only: %i[show index]
        resource :search, only: :show, controller: 'search'
      end

      namespace :books do
        resource :batch, only: :update, controller: 'batch'
        resources :full_entries, only: %i[show create update destroy]
        resources :index_entries, only: %i[show index]
        resources :popularity, only: :update
        resources :ref_entries, only: %i[show index]
        resources :years, only: :index
        resource :search, only: :show, controller: 'search'
      end

      namespace :tags do
        resources :categories, only: :index
        resources :full_entries, only: %i[update destroy]
        resources :index_entries, only: %i[show index]
        resources :ref_entries, only: %i[show index]
        resource :search, only: :show, controller: 'search'
      end
    end
  end

  namespace :admin do
    resources :authors do
      resources :books, only: %i[new], controller: 'author_books'
      resources :books_list, only: %i[create], controller: 'authors/books_list'
      resource :list_parsing, only: %i[new create], controller: 'authors/list_parsing'
      resource :wiki_stats, only: %i[update], controller: 'authors/wiki_stats'
    end
    resource :authors_search, only: %i[create], controller: 'authors/search'
    resources :books do
      resource :ai_book_info, only: %i[edit], controller: 'ai/book_info'
      resource :wiki_stats, only: %i[update], controller: 'book_wiki_stats'
      resource :custom_cover, only: %i[destroy], controller: 'books/custom_cover'
      resource :generative_summary, only: %i[new], controller: 'books/generative_summary'
    end
    resource :books_search, only: %i[create], controller: 'books/search'
    resource :books_batch, only: %i[edit update], controller: 'books/batch'
    resources :cover_previews, only: %i[index], controller: 'cover_previews'
    resources :ai_chats, only: %i[index show], controller: 'ai/chats'
    resources :tags
    get '/', to: 'books#index', format: :html, as: :root
  end

  get '*path', to: 'home#index', format: :html
end
