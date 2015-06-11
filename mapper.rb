require 'sinatra'
require 'net/http'
require "nokogiri"


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


