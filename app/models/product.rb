class Product < ApplicationRecord
  scope :sport, -> { where(category: "Спорт") }
  scope :mobile, -> { where(category: "Телефоны и переферия") }
end
