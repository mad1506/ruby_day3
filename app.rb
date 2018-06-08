require 'sinatra'
require 'sinatra/reloader'
require 'uri'
require 'rest-client'
require 'nokogiri'

get '/' do
    erb :app
end

get '/numbers' do
   erb :numbers
end

get '/calculate' do
   num1 = params[:n1].to_i
   num2 = params[:n2].to_i
   @sum = num1 + num2
   @min = num1 - num2
   @mul = num1 * num2
   @div = num1 / num2
   erb :calculate
end

get '/form' do
    erb :form
end

get '/url/wild' do
    erb :wild
end

get '/search' do
    erb :search
end

post '/search' do
    case params[:engine]
    when "naver"
        url = URI.encode("https://search.naver.com/search.naver?query=#{params[:query]}")
        redirect url
    when "google"
        url = URI.encode("https://www.google.com/search?q=#{params[:q]}")
        redirect url
    end
    redirect "https://search.naver.com/search.naver?query="+srch
end

get '/op_gg' do
    @userName=params[:userName]
    if params[:userName]
        case params[:search_method]
        # op.gg로 가기
        when "opgg"
            url = URI.encode("https://www.op.gg/summoner/userName=#{params[:userName]}")
            redirect url
        # 승패수만 크롤링
        when "self"
            # 검색 결과 페이지 중에서 win과 lose 부분을 찾음.
            url = RestClient.get(URI.encode("https://www.op.gg/summoner/userName=#{params[:userName]}"))
            # nokogiri를 이용하여 원하는 부분을 골라냄
            result = Nokogiri::HTML.parse(url)
            # 검색 결과를 페이지에서 보여주기 위한 변수 선언
            win = result.css("span.win").first
            lose = result.css("span.lose").first
            @win = win.text
            @lose = lose.text
        end
    end
    erb :op_gg
end

id = "multi"
pw = "campus"

post '/login' do
   if id.eql?params[:id]
      # 비밀번호를 체크하는 로직
      if pw.eql?(params[:password])
         redirect '/complete' 
      else
         @msg = "비밀번호가  틀립니다."
         redirect '/error?err_code=2' 
      end
   else
      # ID가 존재하지 않습니다.
      @msg = "ID가 존재하지 않습니다."
      redirect '/error?err_code=1'
   end
end

# 계정이 존재하지 않거나, 비밀번호가 틀린 경우
get '/error' do
   # 다른 방식으로 에러메시지 보여줘야함
   #id가 없는 경우
   if params[:err_code].to_i == 1
       @msg = "아이디가 없습니다."
   #pw가 틀린 경우
   elsif params[:err_code].to_i == 2
       @msg = "비밀번호가 틀립니다."
   end
   
   erb :error
end

# 로그인  완료 된 곳
get '/complete' do
   erb :complete
end