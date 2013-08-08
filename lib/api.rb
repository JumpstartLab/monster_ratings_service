require './lib/opinions/rating'

class API < Sinatra::Base

  get '/' do
    "Hello, World!"
  end

  not_found do
    {:error => "not found"}.to_json
  end

  get '/products/:product_id/ratings/:user_id' do |product_id, user_id|
    Opinions::Rating.find_unique(product_id, user_id).to_json
  end

  get '/products/:product_id/ratings' do |product_id|
    {"ratings" => Opinions::Rating.where(:product_id => product_id)}.to_json
  end

  get '/users/:user_id/ratings' do |user_id|
    {"ratings" => Opinions::Rating.where(:user_id => user_id)}.to_json
  end
end
