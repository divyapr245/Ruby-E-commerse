require "httparty"
require "nokogiri"
class ProductScraperJob < ApplicationJob
  queue_as :default

  def perform(url, category_name)
    begin
      document = scrape_url(url)
      html_products = document.css("div.s-main-slot div.s-card-container")

      category = Category.find_by(id: category_name)
      return unless category

      html_products.each do |product|
        # Handle image URL with fallback
        image_url = product.css("div.s-image-fixed-height img.s-image")&.attr("src")&.value.presence ||
                    product.css("div.s-image-square-aspect img.s-image")&.attr("src")&.value
        next if image_url.nil?

        # Extract Product URL
        base_url = "https://www.amazon.com"
        product_url = product.css("a.a-link-normal")&.attr("href")&.value
        product_url = product_url.present? ? URI.join(base_url, product_url).to_s : nil

        # Perform nested scraping for additional product details
        product_document = scrape_url(product_url)
        product_description = product_document.css("div.celwidget ul.a-unordered-list.a-vertical.a-spacing-mini")&.text

        # Extract product details
        description = ["h2.a-size-medium span", "h2.a-size-base-plus span", "h2.a-size-normal span"].find do |selector|
          product.css(selector)&.text&.strip.presence
        end

        price = product.css("span.a-price-whole")&.text&.strip
        modify_price = product_document.css("div.a-section span.a-price span.a-price-whole")[0]&.text
        brand = product_document.css("div.a-section.a-spacing-small.a-spacing-top-small tr.a-spacing-small.po-brand td.a-span9 span.a-size-base.po-break-word")&.text
        product_data = {
          image_url: image_url,
          description:  product.css(description)&.text,
          price: modify_price,
          product_description: product_description
        }
        @brand = Brand.find_or_create_by(name: brand.presence || "")
        if @brand.persisted?
          created_product = @brand.products.create(product_data)
          created_product.categories << category if created_product.persisted?
          Rails.logger.info "📦 Scraped Product Data: #{created_product.inspect}"
        else
          Rails.logger.error "Brand could not be saved: #{@brand.errors.full_messages.join(", ")}"
        end
      end

      
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end

  def scrape_url(url)
    response = HTTParty.get(url, { 
  headers: { 
    "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" 
  }, 
  })

   Nokogiri::HTML(response.body)
end 
end
