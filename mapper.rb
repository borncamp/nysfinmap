require 'sinatra'
require 'net/http'
require "nokogiri"
require 'open-uri'


get '/hi' do
	"hello there"
end

get '/' do
	erb :index
end

post '/search' do
	url="http://www.elections.ny.gov:8080/plsql_browser/CONTRIB_PRE_A_COUNTY_TEST"
	headers={
	"NAME_IN"=>"Brown",
	"OFFICE_IN"=>"ALL",
	"county_IN"=>"ALL",
	"date_from"=>"01/01/2000",
	"date_to"=>"01/01/2016",
	"CATEGORY_IN"=>"ALL",
	"AMOUNT_from"=>"0",
	"AMOUNT_to"=>"1000000",
	"ZIP1"=>"00000",
	"ZIP2"=>"99999",
	"ORDERBY_IN"=>"N"
	}

	response=Net::HTTP.post_form URI(url),headers 
	parsedDoc = Nokogiri::XML(response.body)
	dirty_data=parsedDoc.xpath('//*[@id="cfContent"]').text.split('-2>')
	@clean_data=dirty_data[2..-1].each_slice(7).to_a

	erb :search
end

get '/committee/:id' do |id|
	url="http://www.elections.ny.gov:8080/plsql_browser/CONTRIBUTORA_COUNTY?ID_in=#{id}&date_From=01/01/2000&date_to=01/01/2016&AMOUNT_From=0&AMOUNT_to=10000&ZIP1=00000&ZIP2=99999&ORDERBY_IN=N&CATEGORY_IN=ALL"	
	response=open url
	parsedDoc=Nokogiri::HTML(response.read)
	data=parsedDoc.xpath('//*[@id="cfContent"]/font[4]/font/left/font/table[2]')
	@funk=[]
	data.search('tr').each do |tr|
		td=tr.search('td')
		if !td[0].nil?
			@funk.push [td[0].text,td[1].text]
		end
	end

	erb :committee
end

