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

  post "/products/:product_id/ratings" do |product_id|
    data = json_params_from(request)["rating"]
    data.delete("created_at")
    data.delete("updated_at")
    rating = Opinions::Rating.new data
    if rating.save
      status 201
      rating.to_json
    else
      status 400
      rating.errors.inspect
    end
  end

  put "/products/:product_id/ratings/:user_id" do |product_id, user_id|
    data = json_params_from(request)["rating"]
    data.delete("created_at")
    data.delete("updated_at")
    rating = Opinions::Rating.find_unique(product_id, user_id)

    if rating.update_attributes(data)
      status 200
      rating.to_json
    else
      status 400
      rating.errors.inspect
    end
  end

  def json_params_from(request)
    request.body.rewind
    JSON.parse(request.body.read)
  end
end
