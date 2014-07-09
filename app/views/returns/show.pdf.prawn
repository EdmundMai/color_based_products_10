#!/bin/env ruby
# encoding: utf-8

require 'prawn/table'

prawn_document() do |pdf|
  order = @return.order
	
	pdf.bounding_box([0,pdf.bounds.top], :width => 400, :height => 250) do
    pdf.stroke_color '000000'
    pdf.stroke_bounds
    
    
    pdf.bounding_box [10, pdf.bounds.top-10], width: 200 do
    	pdf.text "#{order.shipping_address.full_name}", align: :left, size: 10 
    	pdf.text "#{order.shipping_address.street_address}", align: :left, size: 10
    	pdf.text "#{order.shipping_address.street_address2}", align: :left, size: 10
    	pdf.text "#{order.shipping_address.city_state_zipcode}", align: :left, size: 10
    end
    
    
    
    pdf.move_down(20)
    
		pdf.bounding_box [pdf.bounds.width/2 - 50, pdf.bounds.top-120], width: 200 do
			pdf.text "<b>Ship To:</b>", align: :left, size: 15, inline_format: true
			pdf.text WAREHOUSE_ADDRESS[:name], align: :left, size: 15 
			pdf.text WAREHOUSE_ADDRESS[:street_address], align: :left, size: 15 
			pdf.text WAREHOUSE_ADDRESS[:street_address2], align: :left, size: 15 
			pdf.text WAREHOUSE_ADDRESS[:city_state_zipcode], align: :left, size: 15 
			pdf.text "www.mysite.com", align: :left, size: 15
		end
  
	end
  
  pdf.bounding_box([0,pdf.bounds.top - 260], :width => 540, :height => 30) do
    pdf.text "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
  end
  
  pdf.move_down(20)

	
	pdf.float {
		pdf.image "#{LOGO_IMAGE_PATH}", width: 100, height: 50, position: :left
		
	}
	pdf.text "Return Slip", align: :center, size: 20, position: :center
		
	

	pdf.move_down(30)
	
  
	
	pdf.text "RMA Code: #{@return.rma_code}", style: :bold, align: :left, size: 10
	pdf.text "Order ID: #{@return.order_id}", style: :bold, align: :left, size: 10
	pdf.text @return.created_at.strftime("%B %d, %Y"), align: :left, size: 8
	
	
	
	
	pdf.move_down(10)
	

	
	address_info = [
		["<b>Ship From:</b>", "<b>Ship To:</b>"],
		["#{order.shipping_address.first_name} #{order.shipping_address.last_name}",WAREHOUSE_ADDRESS[:name]],
		["#{order.shipping_address.street_address}", WAREHOUSE_ADDRESS[:street_address]],
		["#{order.shipping_address.street_address2}", WAREHOUSE_ADDRESS[:street_address2]],
		["#{order.shipping_address.city_state_zipcode}", WAREHOUSE_ADDRESS[:city_state_zipcode]],
		["#{order.shipping_address.phone_number}", WAREHOUSE_ADDRESS[:phone_number]]
	]
	
	pdf.table(address_info, cell_style: { inline_format: true, height: 12, size: 8, borders: [] }) do 
		column(0).width = 270
		column(1).width = 270
		row(2..-1).style(padding: [0,2,0,4])
		row(0..1).style(padding: [2,4,2,4], height: 15)
		
		
		cells[0, 0].style(:borders => [:left, :top, :bottom])
		cells[1, 0].style(:borders => [:left])
		cells[2, 0].style(:borders => [:left])
		cells[3, 0].style(:borders => [:left])
		cells[4, 0].style(:borders => [:left])
		cells[5, 0].style(:borders => [:left, :bottom])
		cells[0, 1].style(:borders => [:bottom, :right, :top])
		cells[1, 1].style(:borders => [:right])
		cells[2, 1].style(:borders => [:right])
		cells[3, 1].style(:borders => [:right])
		cells[4, 1].style(:borders => [:right])
		cells[5, 1].style(:borders => [:right, :bottom])

	end
	
	pdf.move_down(10)

	line_items = []
	line_items << ["<b>SKU</b>", "<b>Item Description</b>", "<b>Price</b>", "<b>Qty</b>", "<b>Total</b>"]
	current_line_number = 0

	
	@return.return_items.each do |return_item|
		current_line_number += 1
		data = []    
    data << "#{return_item.line_item.variant.sku}"
    data << "#{return_item.line_item.variant.product.name}"
    data << "#{humanized_money_with_symbol(return_item.line_item.unit_price)}"
    data << "#{return_item.quantity}"
    data << "#{humanized_money_with_symbol(return_item.line_item.unit_price * return_item.quantity)}"
		line_items << data
	end
	
	
	pdf.table line_items, cell_style: { inline_format: true, size: 8, height: 20, borders: [] } do
		column(0..1).style(align: :left)
		column(-3..-1).style(align: :right)
		column(0).width = 80
		column(1).width = 300
		column(2).width = 50
		column(3).width = 50
		column(4).width = 60
		
		row(2..-1).style(padding: [0,2,0,4])
		
		
		row(0).style(padding: [2,4,2,4])
		
		column(0).style(borders: [:left])
		column(-1).style(borders: [:right])
		cells[0, 0].style(borders: [:left, :top, :bottom])
		cells[0, 1].style(borders: [:bottom, :top])
		cells[0, 2].style(borders: [:bottom, :top])
		cells[0, 3].style(borders: [:bottom, :top])
		cells[0, 4].style(borders: [:right, :bottom, :top])

		
		
		column(-1).style(padding_right: 4)
	end
  
  
	summary = []
	3.times do
		summary << ["", ""]
	end
	summary << ["<b>Subtotal:</b>", "#{humanized_money_with_symbol(@return.projected_amount)}"]

	pdf.table summary, cell_style: { inline_format: true, size: 8, height: 15, borders: [] } do
		column(0..-1).style(align: :right)
		column(0).width = 490
		column(1).width = 50
		column(0).style(borders: [:left])
		column(1).style(borders: [:right])
		row(0..-1).style(padding: [0, 5, 0, 0])
		row(-1).style(borders: [:bottom])
		cells[3, 0].style(borders: [:left, :bottom])
		cells[3, 1].style(borders: [:right, :bottom])
	end
  
  pdf.move_down(10)
  
  

	
  
	
end