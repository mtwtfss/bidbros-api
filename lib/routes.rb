after do
  response.status = response.body.delete(:status) || response.status
  response.body = json response.body
end

not_found do
  '404'
end

post '/login' do
  warden.authenticate! if current_user.nil?
  Resource::User.new(id: current_user.id).render
end

get '/logout' do
  warden.logout
end

get '/users' do
  Resource::User.new(params).render_set
end

get '/user' do
  halt 401 if current_user.nil?
  Resource::User.new(id: current_user.id).render
end

get '/user/:id' do
  Resource::User.new(params).render || not_found
end

put '/user/:id' do
  auth_check(params[:id].to_i)
  Resource::User.new(params).update
end

post '/user' do
  Resource::User.new(params).create
end

get '/posts' do
  Resource::Post.new(params).render_set
end

get '/post/:id' do
  Resource::Post.new(params).render || not_found
end

put '/post/:id' do
  auth_check
  Resource::Post.new(params).update
end

post '/post' do
  auth_check
  Resource::Post.new(params).create
end

delete '/post/:id' do
  auth_check
  Resource::Post.new(params).delete
end
