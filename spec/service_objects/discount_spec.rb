require 'spec_helper'

describe Discount do
  
  describe "#initialize(args={})" do
    context "the percentage key is provided" do
      it "sets the percentage attribute to the value provided" do
        discount = Discount.new(percentage: 0.05)
        expect(discount.percentage).to eq(0.05)
      end
    end
    
    context "the percentage key is not provided" do
      it "sets the percentage attribute to nil" do
        # discount = Discount.new
        # expect(discount.percentage).to be_nil
        expect { Discount.new }.to raise_error(KeyError)
      end
    end
  end
  
  describe "#apply_to_products!(products_colors_ids)" do
    context "variant list_price is nil" do
      it "does nothing" do
        products_color = FactoryGirl.create(:products_color)
        variant = FactoryGirl.create(:variant, list_price: nil, discount_price: nil)
        products_color.variants << variant
        discount = Discount.new(percentage: 0.10)
        discount.apply_to_products!([products_color.id])
        variant.reload
        expect(variant.discount_price).to be_nil
      end
    end
    
    context "variant list_price is not nil" do
      it "sets the discount_price for all the variants of each products_color" do
        products_color = FactoryGirl.create(:products_color)
        variant = FactoryGirl.create(:variant, list_price: 10.00, discount_price: nil)
        products_color.variants << variant
        discount = Discount.new(percentage: 0.10)
        discount.apply_to_products!([products_color.id])
        variant.reload
        expect(variant.discount_price).to eq(9.00)
      end
    end

  end
  
  describe "#apply_to_collections!(products_colors_ids)" do
    context "variant list_price is nil" do
      it "does nothing" do
        collection = FactoryGirl.create(:collection)
        product = FactoryGirl.create(:product)
        collection.products << product
        products_color = FactoryGirl.create(:products_color)
        product.products_colors << products_color
        variant = FactoryGirl.create(:variant, list_price: nil, discount_price: nil)
        products_color.variants << variant
        discount = Discount.new(percentage: 0.10)
        discount.apply_to_collections!([collection.id])
        variant.reload
        expect(variant.discount_price).to be_nil
      end
    end
    
    context "variant list_price is not nil" do
      it "sets the discount_price for all the variants of each products_color" do
        collection = FactoryGirl.create(:collection)
        product = FactoryGirl.create(:product)
        collection.products << product
        products_color = FactoryGirl.create(:products_color)
        product.products_colors << products_color
        variant = FactoryGirl.create(:variant, list_price: 10.00, discount_price: nil)
        products_color.variants << variant
        discount = Discount.new(percentage: 0.10)
        discount.apply_to_collections!([collection.id])
        variant.reload
        expect(variant.discount_price).to eq(9.00)
      end
    end
  end
  
  describe ".remove_from_collections!(collection_ids)" do
    it "sets all the collections products variants discount_price to nil" do
      collection = FactoryGirl.create(:collection)
      product = FactoryGirl.create(:product)
      collection.products << product
      products_color = FactoryGirl.create(:products_color)
      product.products_colors << products_color
      variant = FactoryGirl.create(:variant, list_price: 10.00, discount_price: 3.55)
      products_color.variants << variant
      Discount.remove_from_collections!([collection.id])
      variant.reload
      expect(variant.discount_price).to be_nil
    end
  end
  
  describe ".remove_from_products!(products_colors_ids)" do
    it "sets all the products_colors variants discount_price to nil" do
      products_color = FactoryGirl.create(:products_color)
      variant = FactoryGirl.create(:variant, list_price: 10.00, discount_price: 5.55)
      products_color.variants << variant
      Discount.remove_from_products!([products_color.id])
      variant.reload
      expect(variant.discount_price).to be_nil
    end
  end
  
end