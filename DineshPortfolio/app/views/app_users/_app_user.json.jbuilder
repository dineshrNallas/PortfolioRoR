json.extract! app_user, :id, :name, :email, :password_digest, :created_at, :updated_at
json.url app_user_url(app_user, format: :json)
