require 'open-uri'

require 'net/http'
require 'uri'

class GetProductListService
  def scratch(url = "http://konfiskat.by/konfiskat/13520/?limit=48&PAGEN_1=")

    i = 26

    first_code = nil

    loop do
      local_url = url + i.to_s
      open(local_url) do |f|
        product_list = Nokogiri::HTML(f).css('.bx_catalog_item_container').each do |item|
          item_code = item.css('.item_props li')[1].text.gsub(/Код:/, '').strip

          if item_code.nil?
            first_code = item_code
          elsif first_code == item_code
            return
          end

          product = Product.find_by(code: item_code)
          item_price = item.css('.bx_catalog_item_price .bx_price').inner_text

          if product
            binding.pry
            product.update(current_price: parse_price(item_price))
          else
            item_name = item.css('.p-name a')[0]['title']
            item_address = item.css('.item_props li').last.text.gsub(/Место реализации:/, '').strip.squeeze(" ")
            item_code = item.css('.item_props li')[1].text.gsub(/Код:/, '').strip

            price = parse_price(item_price)
            Product.create(name: item_name, current_price: price, base_price: price, location: item_address, code: item_code)
          end
        end
      end

      i += 1
    end
  end

  private

  def parse_price(item_price)
    rubs = /\d+(?=\sр\.)/.match(item_price).to_s
    cents = /\d+(?=\sк\.)/.match(item_price).to_s

    "#{rubs}.#{cents}".to_f
  end
end
