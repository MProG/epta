require 'sidekiq-scheduler'

class GrabProductsWorker
  include Sidekiq::Worker
  CATEGORY_LIST = [
    { url: "http://konfiskat.by/konfiskat/13520/?limit=48&PAGEN_1=", name: 'Телефоны и переферия' },
    { url: "http://konfiskat.by/konfiskat/13494/?limit=48&PAGEN_1=", name: 'Спорт' }
  ]

  def perform
    CATEGORY_LIST.each do |item|
      GetProductListService.new().scratch(item[:url], item[:name])
    end
  end
end
