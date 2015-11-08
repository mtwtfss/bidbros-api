after do
  response.status = response.body.delete(:status) || response.status
  response.body = json response.body
end

not_found do
  '404'
end

post '/agent_login' do
  agent = Agent.first(agent_id: params[:agent_id])
  agent.nil? ? not_found : Resource::Agent.new(id: agent.id).render
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

post '/seller_login' do
  seller = Seller.first(email: params[:email])
  seller.nil? ? not_found : Resource::Seller.new(id: seller.id).render
end

get '/seller/:id' do
  Resource::Seller.new(params).render || not_found
end

post '/seller' do
  Resource::Seller.new(params).create
end
