require 'open-uri'
require 'net/http'
require 'uri'

class GetProductListService
  def scratch(url, category)
    i = 1
    first_code = nil

    loop do
      local_url = url + i.to_s
      open(local_url) do |f|
        product_list = Nokogiri::HTML(f).css('.bx_catalog_item_container').each do |item|
          item_code = item.css('.item_props li')[1].text.gsub(/Код:/, '').strip

          if first_code.nil?
            first_code = item_code
          elsif first_code == item_code
            return
          end

          product = Product.find_by(code: item_code)
          item_price = item.css('.bx_catalog_item_price .bx_price').inner_text

          if product
            new_price = parse_price(item_price)
            product.update(current_price: new_price, diff_percent: diff_price(product.base_price, new_price))
          else
            item_name = item.css('.p-name a')[0]['title']
            item_address = item.css('.item_props li').last.text.gsub(/Место реализации:/, '').strip.squeeze(" ")
            item_code = item.css('.item_props li')[1].text.gsub(/Код:/, '').strip

            price = parse_price(item_price)
            Product.create(name: item_name, current_price: price, base_price: price, location: item_address, code: item_code, diff_percent: 0, category: category)
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

  def diff_price(base_price, current_price)
    (((base_price - current_price)/base_price) * 100).round
  end
end
