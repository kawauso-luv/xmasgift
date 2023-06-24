require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models.rb'
require 'twitter_oauth2'
require 'json'
require 'net/http'

enable :sessions

client = TwitterOAuth2::Client.new(
    identifier: 'RjdqZWdqb0tXajk5clZhRUNldGo6MTpjaQ',
    secret: 'P7mVsN6J6sZDpVbMJhzpvaq8C76J43qgacQSN2fKjWQDN_71Td',
    redirect_uri: 'https://3ea75265400d4ef3b6343e42c0032a68.vfs.cloud9.ap-northeast-1.amazonaws.com/twitter/callback'
)

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end

get '/' do
  erb :index
end


get '/signin/twitter' do
  authorization_uri = client.authorization_uri(
      scope: [
          :'users.read',
          :'tweet.read'
        ]
    )
    redirect authorization_uri
end


get '/twitter/callback' do
  code_verifier = client.code_verifier
  state = client.state
  
  client.authorization_code = params[:code]
  p code_verifier
  token_response = client.access_token! code_verifier
  p token_response
  
  user_client = Twitter::REST::Client.new do |config|
      config.consumer_key = "ASk9PbpU0JLbYTeHt4YGT4C8Z"
      config.consumer_secret = "OKL6vF5WM02WfqVSgmRB0mjHjlAwqP3t5p7xtW6M8M6YAE1t6X"
      config.bearer_token = token_response.access_token
    end
    
    options = {
        method: 'get',
        headers: {
            "User-Agent" => "v2RubyExampleCode",
            "Authorization" => "Bearer #{token_response.access_token}"
        },
    }
    request = Typhoeus::Request.new("https://api.twitter.com/2/users/me", options)
    response = request.run
    
    json = JSON.parse(response.response_body)
    user = User.find_or_create_by(twitter_id: json["data"]["id"], name: json["data"]["name"])
    session[:user] = user.id
    redirect '/mypage'
    
end


get '/signin' do
  erb :signin
end

post '/signup' do
  user = User.create(mail: params[:mail], password: params[:password], password_confirmation: params[:password_confirmation], name: params[:mail])
  if user.persisted?
    session[:user] = user.id
  end
  redirect '/mypage'
end

post '/signin' do
  user = User.find_by(mail: params[:mail])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/mypage'
end


get '/mypage' do
  @user = User.find(session[:user])
  @user_id = params[:user_id]
  today = Date.today
  target_date = Date.new(Date.today.year, 6, 24) 
  @days_left = (target_date - today).to_i # 残り日数を計算
  @presentstome = Present.where(sendto_id: session[:user], created_at: ..(Time.now.beginning_of_year - 1.second))
  @presentsforu = Present.where(sendfrom_id: session[:user])
  puts session[:user]
  # p @presentstome
  # p @presentsforu
  erb :mypage
end

post '/mypage/muteword' do
end



post '/sendto/:user_id' do
  p params[:user_id]
  User.find(params[:user_id]).presents.create(sendfrom_id: session[:user], content: params[:content])
  redirect '/sendto/' + params[:user_id]
end

get '/sendto/:user_id' do
  @user = User.find(session[:user])
  @user_id = params[:user_id]
  erb :give
end


get '/christmastree' do
  # 1. 空の@presentsを用意する
  @presents = []
  p @presents.length
  # 2. if 12月25日の時にPresentからユーザーに紐付いているプレゼントを取得する
  today = Date.today
  target_date = Date.new(Date.today.year, 6, 24) 
  @days_left = (target_date - today).to_i # 残り日数を計算
  p @days_left

  # 12/25 になったら
  if today == target_date
    @presents = Present.where(sendto_id: session[:user])
  end
  
  @user = User.find(session[:user]).twitter_id
  @coords = ["206,316,144,337,142,416,206,443,271,416,272,338,236,317,207,314,205,315","141,422,142,494,205,522,270,497,272,422,206,445,206,445","141,498,139,576,204,605,272,577,271,498,205,525,205,525","141,669,140,750,206,779,244,765,241,683,208,694,208,694","301,612,248,630,248,696,302,718,357,694,358,631,326,613,301,612,301,612","248,700,246,764,302,788,358,765,357,699,302,719,302,719","432,419,363,441,363,527,432,557,504,527,503,442,462,421,431,418,623,366","358,532,358,622,433,650,508,618,506,528,433,560,433,560","524,661,496,662,460,681,459,760,524,788,590,760,588,681,559,666,572,653,556,648,533,666,524,661,525,661","54,553,47,555,35,546,27,549,29,559,14,567,14,613,14,615,54,632,95,615,94,567,79,560,86,550,75,546,64,556,55,554,55,554","12,617,12,666,33,677,33,665,54,662,68,676,97,664,98,616,54,634,54,634","75,675,67,679,51,665,38,670,43,683,24,693,23,757,76,779,130,756,128,693,110,684,118,673,104,664,87,678,76,675,76,676","590,598,581,602,568,590,557,593,560,607,544,613,544,651,558,643,581,654,570,669,596,678,597,687,638,671,638,614,621,606,628,594,615,588,599,602,591,598,591,597","522,553,509,557,511,620,516,625,515,6n44,510,650,511,654,522,659,539,653,539,632,536,627,536,613,543,608,555,606,554,589,567,586,570,588,580,586,579,571,558,562,565,552,565,547,550,542,542,546,532,557,522,552,522,552","360,624,358,695,362,703,360,714,360,714,433,746,457,736,457,704,452,699,452,681,459,677,480,668,477,658,477,649,495,644,496,644,499,648,511,644,509,623,433,653,433,653","139,582,138,662,205,691,245,673,244,648,240,647,241,627,264,619,263,600,277,597,275,582,206,608,206,608"]
  erb :xmastree
end

get '/content/:id' do
  @user = User.find(session[:user])
  @presents = Present.find_by(id: params[:id])
  p @presents.content
  erb :content
end  

get '/allpresents' do
  @user = User.find(session[:user])
  @presents = Present.where(sendto_id: session[:user])
  @presents.each do |content|
    p content
  end  
  erb :allpresents
end  

get '/signout' do
  session.destroy
  redirect '/'
end