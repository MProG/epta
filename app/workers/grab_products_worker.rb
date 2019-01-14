class GrabProductsWorker
  include Sidekiq::Worker

  def perform
    GetProductListService.new().scratch
  end
end
