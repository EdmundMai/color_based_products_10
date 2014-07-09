require 'csv'

class CsvGenerator
  
  def self.orders_report(from_date, to_date)
    CSV.generate(:col_sep => "|", quote_char: '"') do |csv|
      orders = Order.where("DATE(order_date) >= ? and DATE(order_date) <= ? and status in (?)", from_date, to_date, [Order::IN_PROGRESS, Order::SHIPPED]).order("order_date ASC")
      csv << [
        "ID",
        "Status",
        "Order Date",
        "Email",
        "Total",
        "Subtotal",
        "Tax",
        "Shipping",
        "Shipping Address - First Name",
        "Shipping Address - Last Name",
        "Shipping Address - Street Address",
        "Shipping Address - Apt/Suite",
        "Shipping Address - City",
        "Shipping Address - State",
        "Shipping Address - Zip Code",
        "Shipping Address - Phone Number",
        "Billing Address - First Name",
        "Billing Address - Last Name",
        "Billing Address - Street Address",
        "Billing Address - Apt/Suite",
        "Billing Address - City",
        "Billing Address - State",
        "Billing Address - Zip Code",
        "Billing Address - Phone Number",
        "Item Name",
        "Item Size",
        "Item Color",
        "Item Quantity",
        "Item Unit Price",
        "Item SKU"
      ]
      
      orders.each do |order|
        order.line_items.each do |line_item|
          data = []
          data << order.id 
          data << order.status 
          data << order.order_date.try(:strftime, "%m/%d/%y")
          data << order.user.email
          data << order.total
          data << order.subtotal
          data << order.tax
          data << order.shipping
          data << order.shipping_address.first_name
          data << order.shipping_address.last_name
          data << order.shipping_address.street_address
          data << order.shipping_address.street_address2
          data << order.shipping_address.city
          data << order.shipping_address.state.short_name
          data << order.shipping_address.zip_code
          data << order.shipping_address.phone_number
          data << order.billing_address.first_name
          data << order.billing_address.last_name
          data << order.billing_address.street_address
          data << order.billing_address.street_address2
          data << order.billing_address.city
          data << order.billing_address.state.short_name
          data << order.billing_address.zip_code
          data << order.billing_address.phone_number
          data << line_item.variant.product.name
          data << line_item.variant.size.name
          data << line_item.variant.products_color.color.name
          data << line_item.quantity
          data << line_item.unit_price
          data << line_item.variant.sku
          csv << data
        end
      end
    end
  end
  
end
  