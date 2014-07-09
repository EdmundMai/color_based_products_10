require 'spec_helper'

describe CsvGenerator do
  
  describe ".orders_report(from_date, to_date)" do
    it "returns a CSV that includes all the order info from from_date to to_date for orders in progress and shipped orders" do
      order1 = FactoryGirl.create(:in_progress_order)
      order2 = FactoryGirl.create(:shipped_order)
      data = CsvGenerator.orders_report(Date.yesterday, Date.tomorrow)
      
      headers = CSV.parse(data)[0].first
      expect(headers).to include "ID"
      expect(headers).to include "Status"
      expect(headers).to include "Order Date"
      expect(headers).to include "Email"
      expect(headers).to include "Total"
      expect(headers).to include "Subtotal"
      expect(headers).to include "Tax"
      expect(headers).to include "Shipping"
      expect(headers).to include "Shipping Address - First Name"
      expect(headers).to include "Shipping Address - Last Name"
      expect(headers).to include "Shipping Address - Street Address"
      expect(headers).to include "Shipping Address - Apt/Suite"
      expect(headers).to include "Shipping Address - City"
      expect(headers).to include "Shipping Address - State"
      expect(headers).to include "Shipping Address - Zip Code"
      expect(headers).to include "Shipping Address - Phone Number"
      expect(headers).to include "Billing Address - First Name"
      expect(headers).to include "Billing Address - Last Name"
      expect(headers).to include "Billing Address - Street Address"
      expect(headers).to include "Billing Address - Apt/Suite"
      expect(headers).to include "Billing Address - City"
      expect(headers).to include "Billing Address - State"
      expect(headers).to include "Billing Address - Zip Code"
      expect(headers).to include "Billing Address - Phone Number"
      expect(headers).to include "Item Name"
      expect(headers).to include "Item Size"
      expect(headers).to include "Item Color"
      expect(headers).to include "Item Quantity"
      expect(headers).to include "Item Unit Price"
      expect(headers).to include "Item SKU"
      
      orders = [order1, order2]
      index = 0
      CSV.parse(data)[1..-1].each do |csv_obj|
        row = csv_obj.first
        order = orders[index]
        expect(row).to include order.id.to_s
        expect(row).to include order.status
        expect(row).to include order.order_date.try(:strftime, "%m/%d/%y")
        expect(row).to include order.user.registered_email
        expect(row).to include order.total.to_s
        expect(row).to include order.subtotal.to_s
        expect(row).to include order.tax.to_s
        expect(row).to include order.shipping.to_s
               
        expect(row).to include order.shipping_address.first_name
        expect(row).to include order.shipping_address.last_name
        expect(row).to include order.shipping_address.street_address
        expect(row).to include order.shipping_address.street_address2
        expect(row).to include order.shipping_address.city
        expect(row).to include order.shipping_address.state.short_name
        expect(row).to include order.shipping_address.zip_code
        expect(row).to include order.shipping_address.phone_number
               
        expect(row).to include order.billing_address.first_name
        expect(row).to include order.billing_address.last_name
        expect(row).to include order.billing_address.street_address
        expect(row).to include order.billing_address.street_address2
        expect(row).to include order.billing_address.city
        expect(row).to include order.billing_address.state.short_name
        expect(row).to include order.billing_address.zip_code
        expect(row).to include order.billing_address.phone_number
        
        expect(order.line_items).not_to be_empty
        order.line_items.each do |line_item|
          expect(row).to include line_item.quantity.to_s
          expect(row).to include line_item.unit_price.to_s
          expect(row).to include line_item.variant.product.name
          expect(row).to include line_item.variant.size.name
          expect(row).to include line_item.variant.products_color.color.name
          expect(row).to include line_item.variant.sku
        end
        index = index + 1
      end
      
    end
  end

  
end