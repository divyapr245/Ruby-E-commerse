class ScrapeController < ApplicationController
	require "httparty"
	require "nokogiri"
	before_action :authorize_request, except: [:get_data]
	def get_data
		begin
			url = params["data"]["url"]
			category_name = params["data"]["category_id"]
			
			# Trigger batch job
			ProductScraperJob.perform_later(url, category_name)
			
			render json: { message: "Scraping started in the background. You will be notified once completed." }, status: :ok
		rescue StandardError => e
			render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
		end
	end
	  
	private 

	def scrape_url(url)
        response = HTTParty.get(url, { 
			headers: { 
			  "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" 
			}, 
		  })
	  
		   Nokogiri::HTML(response.body)
	end 

end
