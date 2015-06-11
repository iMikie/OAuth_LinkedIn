get '/' do
  # render home page
 #TODO: Show all users if user is signed in
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

delete '/signout' do
  session[:user_id] = nil
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











