require 'spec_helper'

describe Order do
  its(:attributes) { should include("user_id") }
  its(:attributes) { should include("order_date") }
  its(:attributes) { should include("total_cents") }
  its(:attributes) { should include("total_currency") }
  its(:attributes) { should include("shipping_cents") }
  its(:attributes) { should include("shipping_currency") }
  its(:attributes) { should include("tax_cents") }
  its(:attributes) { should include("tax_currency") }
  its(:attributes) { should include("subtotal_cents") }
  its(:attributes) { should include("subtotal_currency") }
  its(:attributes) { should include("status") }
  its(:attributes) { should include("coupon_id") }
  its(:attributes) { should include("savings_cents") }
  its(:attributes) { should include("savings_currency") }
  its(:attributes) { should include("tracking_number") }
  
  it { should monetize(:savings_cents).with_currency(:usd) }
  it { should monetize(:total_cents).with_currency(:usd) }
  it { should monetize(:shipping_cents).with_currency(:usd) }
  it { should monetize(:tax_cents).with_currency(:usd) }
  it { should monetize(:subtotal_cents).with_currency(:usd) }
  
  it { should belong_to(:coupon) }
  it { should belong_to(:user) }
  it { should have_one(:shipping_address).dependent(:destroy) }
  it { should have_one(:billing_address).dependent(:destroy) }
  
  it { should have_many(:line_items).dependent(:destroy) }
  
  
  
  describe "#return_threshold_passed?" do
    context "the order_date was over a month ago" do
      it "returns true" do
        order = Order.new(order_date: 2.months.ago)
        expect(order.return_threshold_passed?).to be_true
      end
    end
    
    context "the order_date was a month ago" do
      it "returns false" do
        order = Order.new(order_date: 30.days.ago)
        expect(order.return_threshold_passed?).to be_false
      end
    end
    
    context "the order_date was less than a month ago" do
      it "returns false" do
        order = Order.new(order_date: 1.day.ago)
        expect(order.return_threshold_passed?).to be_false
      end
    end
    
    context "the order_date is nil" do
      it "returns true" do
        order = Order.new(order_date: nil)
        expect(order.return_threshold_passed?).to be_true
      end
    end
  end
  
  describe "#has_no_more_items_to_return?" do
    context "the sum of returnable_quantity for every line_item is not 0" do
      it "returns false" do
        order = FactoryGirl.create(:order)
        line_item1 = FactoryGirl.create(:line_item)
        line_item2 = FactoryGirl.create(:line_item)
        order.line_items << line_item1
        order.line_items << line_item2
        line_item1.stub(:returnable_quantity).and_return(1)
        line_item2.stub(:returnable_quantity).and_return(0)
        expect(order.has_no_more_items_to_return?).to be_false
      end
    end
    
    context "the sum of returnable_quantity for every line_item is 0" do
      it "returns true" do
        order = FactoryGirl.create(:order)
        line_item1 = FactoryGirl.create(:line_item)
        line_item2 = FactoryGirl.create(:line_item)
        order.line_items << line_item1
        order.line_items << line_item2
        line_item1.stub(:returnable_quantity).and_return(0)
        line_item2.stub(:returnable_quantity).and_return(0)
        expect(order.has_no_more_items_to_return?).to be_true
      end
    end
  end
  
  describe ".in_progress_or_shipped" do
    it "returns an array of orders that have status #{Order::IN_PROGRESS} or #{Order::SHIPPED}" do
      shipped_order = FactoryGirl.create(:shipped_order)
      in_progress_order = FactoryGirl.create(:in_progress_order)
      incomplete_order = FactoryGirl.create(:incomplete_order)
      
      expect(Order.in_progress_or_shipped).to match_array [shipped_order, in_progress_order]
    end
  end
  
  describe "#attach_coupon!(coupon)" do
    it "sets self.coupon_id to coupon.id" do
      coupon = FactoryGirl.create(:free_shipping_coupon)
      order = FactoryGirl.create(:order, coupon_id: nil)
      order.attach_coupon!(coupon)
      expect(order.coupon).to eq(coupon)
    end
  end

  describe "#calculate_tax" do
    context "shipping_address.state is not New York" do
      it "sets the tax to 0" do
        order = FactoryGirl.create(:order, subtotal: 10.00)
        state = FactoryGirl.create(:state)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id, state_id: state.id)
        order.calculate_tax
        expect(order.tax).to eq(Money.new(0, "USD"))
      end
    end
    
    context "shipping_address.state is New York" do
      context "the zip code can be found" do
        it "sets the tax to a non-zero number" do
          order = FactoryGirl.create(:order, subtotal: 10.00, shipping: 2.53)
          state = FactoryGirl.create(:state, short_name: "NY")
          tax = FactoryGirl.create(:tax, zip_code: "10001", rate: 0.08, state_id: state.id)
          shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id, state_id: state.id, zip_code: "10001")
          order.calculate_tax
          expect(order.tax).to eq(Money.new(100, "USD"))
        end
      end

      context "the zip code can't be found" do
        it "raises an exception" do
          order = FactoryGirl.create(:order, subtotal: 10.00)
          state = FactoryGirl.create(:state, short_name: "NY")
          tax = FactoryGirl.create(:tax, zip_code: "10002", rate: 0.08, state_id: state.id)
          shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id, state_id: state.id, zip_code: "10001")
          expect { order.calculate_tax }.to raise_error
        end
      end
    end
  end


  describe "#calculate_subtotal" do
    it "updates the subtotal" do
      user = FactoryGirl.create(:user)
      cart_item = FactoryGirl.create(:cart_item, cart_id: user.cart.id)
      order = FactoryGirl.create(:order, user_id: user.id, subtotal: nil)
      
      order.calculate_subtotal
      expect(order.subtotal).to eq(cart_item.variant.price)
    end
  end
  
  describe "#calculate_shipping" do
    it "sets the shipping_cost to 0" do
      order = Order.new
      order.calculate_shipping
      expect(order.shipping).to eq(Money.new(0, "USD"))
    end
  end
  
  describe "#calculate_total" do
    it "returns the sum of subtotal, tax, and shipping minus savings" do
      order = Order.new(subtotal: 11.11, shipping: 22.22, tax: 5.55, savings: 1.11)
      order.calculate_total
      expect(order.total).to eq(Money.new(3777, "USD"))
    end
  end
  
  describe "#calculate_coupon_discount" do
    context "coupon exists" do
      it "calls the apply_discount(order) method on coupon" do
        order = Order.new
        coupon = Coupon.new
        order.coupon = coupon
        expect(coupon).to receive(:apply_discount).with(order)
        order.calculate_coupon_discount
      end
    end
    
    context "coupon does not exist" do
      it "does nothing" do
        order = Order.new
        expect(order.calculate_coupon_discount).not_to raise_error
      end
    end
  end

  describe "#update_all_fees!" do
    let(:order) {
      order = Order.new
      order.stub(:calculate_subtotal)
      order.stub(:calculate_shipping)
      order.stub(:calculate_coupon_discount)
      order.stub(:calculate_tax)
      order.stub(:calculate_total)
      order
    }
    
    it "sends the calculate_subtotal method" do
      expect(order).to receive(:calculate_subtotal)
      order.update_all_fees!
    end
    
    it "sends the calculate_shipping method" do
      expect(order).to receive(:calculate_shipping)
      order.update_all_fees!
    end
    
    it "sends the calculate_coupon_discount method" do
      expect(order).to receive(:calculate_coupon_discount)
      order.update_all_fees!
    end
    
    it "sends the calculate_tax method" do
      expect(order).to receive(:calculate_tax)
      order.update_all_fees!
    end
    
    it "sends the calculate_tax method" do
      expect(order).to receive(:calculate_total)
      order.update_all_fees!
    end
    
    it "sends the save! method" do
      expect(order).to receive(:save!)
      order.update_all_fees!
    end
  end
  
  describe "#set_status_to_in_progress" do
    it "sets the status to #{Order::IN_PROGRESS}" do
      order = Order.new
      order.set_status_to_in_progress
      expect(order.status).to eq(Order::IN_PROGRESS)
    end
  end
  
  describe "#finalize!" do
    it "calls the empty! method on user.cart" do
      order = FactoryGirl.create(:order)
      expect(order.user.cart).to receive(:empty!)
      order.finalize!
    end
    
    it "makes one line item for every cart item in the cart" do
      order = FactoryGirl.create(:order)
      order.user.cart.cart_items << FactoryGirl.create(:cart_item, quantity: 2)
      order.user.cart.cart_items << FactoryGirl.create(:cart_item)
      expect { order.finalize! }.to change { order.line_items.count }.by(2)
    end
    
    it "copies the quantity and variant_id attribuets of the cart item into line item" do
      order = FactoryGirl.create(:order)
      cart_item = FactoryGirl.create(:cart_item, cart_id: order.user.cart.id)  
      order.finalize!
      expect(order.line_items.last.attributes.slice("quantity", "variant_id")).to eq(cart_item.attributes.slice("quantity", "variant_id"))
    end
    
    it "calls the set_status_to_in_progress method" do
      order = FactoryGirl.create(:order)
      expect(order).to receive(:set_status_to_in_progress)
      order.finalize!
    end
    
    it "calls the set_order_date_to_today method" do
      order = FactoryGirl.create(:order)
      expect(order).to receive(:set_order_date_to_today)
      order.finalize!
    end
  end
  
  describe "#set_order_date_to_today" do
    it "sets the order_date to today" do
      order = Order.new
      order.set_order_date_to_today
      expect(order.order_date).to eq(Date.today)
    end
  end
  
  describe ".status_options" do
    it "returns an array of allowed status options" do
      expect(Order.status_options).to match_array [Order::IN_PROGRESS, Order::SHIPPED, Order::CANCELLED]
    end
  end

end
