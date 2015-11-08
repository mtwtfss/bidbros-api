after do
  response.status = response.body.delete(:status) || response.status
  response.body = json response.body
end

not_found do
  '404'
end

get '/agents' do
  Resource::Agent.new(params).render_set
end

get '/agent/:id' do
  Resource::Agent.new(params).render || not_found
end

put '/agent/:id' do
  auth_check(params[:id].to_i)
  Resource::Agent.new(params).update
end

post '/agent' do
  Resource::Agent.new(params).create
end

get '/bids' do
  Resource::Bid.new(params).render_set
end

get '/bid/:id' do
  Resource::Bid.new(params).render || not_found
end

put '/bid/:id' do
  auth_check(params[:id].to_i)
  Resource::Bid.new(params).update
end

post '/bid' do
  Resource::Bid.new(params).create
end

get '/listings' do
  Resource::Listing.new(params).render_set
end

get '/listing/:id' do
  Resource::Listing.new(params).render || not_found
end

post '/listing' do
  Resource::Listing.new(params).create
end

get '/seller/:id' do
  Resource::Seller.new(params).render || not_found
end

post '/seller' do
  Resource::Seller.new(params).create
end
