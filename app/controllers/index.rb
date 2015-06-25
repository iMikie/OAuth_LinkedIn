get '/' do
  if session[:user_id]
    @user = User.where(id: session[:user_id]).first
    p @user
    erb :index
  else
    redirect '/signin'
  end
end


#----------- LINKED IN FROM ANNE -----------

get '/linked_in' do
  redirect LinkedIn.authorization_url
end

get '/oauth' do
  if params["error"]
    @error = params['error_description']
    redirect '/signin'
  end
  # get_access_token makes an http party request go see linked_in.rb helper

  access_token = LinkedIn.get_access_token(params["code"])
  # access_state = LinkedIn.get_access_token(params["state"])
  # if !LinkedIn.check_state(access_state)
  #   @error = "Cross-site_request_forgery"
  #   status 401
  # else
     user = User.create_from_linked_in access_token
     redirect "/users/#{user.id}"
  # end
end

get '/users/:id' do
  @user = User.find params[:id]
  erb :index
end
#----------- SESSIONS -----------

get '/signin' do
  erb :sign_in
end

post '/sessions' do
  p '@' * 90
  p params
  p '@' * 90
  @user = User.where(email: params[:email]).first if params[:email]
  p '@' * 90
  p @user
  if @user.password_hash == params[:password]
    session[:user_id] = @user.id
    redirect '/'
  else
    @errors = @user.errors
    p "your not very good at this"
    erb :sign_in
  end
end

delete '/signout/:id' do
  session[ params['id'] ] = nil
  redirect '/'
end

#----------- USERS -----------

get '/signup' do
  erb :sign_up
end

post '/users' do

  @user = User.new(params[:user])

  # long hand version for clarity or if form fields passsed in dont match db fields....

  # @user = User.new(name: params[:user][:name],
  #                  email: params[:user][:email],
  #                  password: params[:user][:password])


if @user.save
  p "yaY!!!!!!"
  session[:user_id] = @user.id
  redirect '/'
else
  @errors = @user.errors
  p " duck " * 20
  erb :sign_up
end

end











