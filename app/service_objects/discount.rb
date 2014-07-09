class Discount
  attr_reader :percentage
  
  def initialize(args={})
    @percentage = args.fetch(:percentage)
  end
  
  def self.remove_from_products!(products_colors_ids)
    Array(products_colors_ids).each do |products_color_id|
      products_color = ProductsColor.find(products_color_id)
      products_color.variants.each do |variant|
        variant.update_attributes(discount_price: nil)
      end
    end
  end
  
  def self.remove_from_collections!(collections_ids)
    Array(collections_ids).each do |collection_id|
      collection = Collection.find(collection_id)
      collection.products.each do |product|
        product.variants.each do |variant|
          variant.update_attributes(discount_price: nil)
        end
      end
    end
  end
  
  
  def apply_to_products!(products_colors_ids)
    Array(products_colors_ids).each do |products_color_id|
      products_color = ProductsColor.find(products_color_id)
      products_color.variants.each do |variant|
        unless variant.list_price.nil?
          variant.discount_price = variant.list_price * (1 - percentage)
          variant.save
        end
      end
    end
  end
  
  def apply_to_collections!(collections_ids)
    Array(collections_ids).each do |collection_id|
      collection = Collection.find(collection_id)
      collection.products.each do |product|
        product.variants.each do |variant|
          unless variant.list_price.nil?
            variant.discount_price = variant.list_price * (1 - percentage)
            variant.save
          end
        end
      end
    end
  end
  
end