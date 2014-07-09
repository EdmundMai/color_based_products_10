require 'spec_helper'

describe PaymentInfo do
  
  subject { 
    user = FactoryGirl.create(:user, guest: false)
    order = FactoryGirl.create(:order, user_id: user.id)
    PaymentInfo.new(order_id: order.id) 
  }
  
  its(:attributes) { should include(:credit_card_number) }
  its(:attributes) { should include(:credit_card_exp_mm) }
  its(:attributes) { should include(:credit_card_exp_yyyy) }
  its(:attributes) { should include(:credit_card_cvv) }
  
  its(:attributes) { should include(:coupon_code) }
  
  
  its(:attributes) { should include(:shipping_address_first_name) }
  its(:attributes) { should include(:shipping_address_last_name) }
  its(:attributes) { should include(:shipping_address_street_address) }
  its(:attributes) { should include(:shipping_address_street_address2) }
  its(:attributes) { should include(:shipping_address_zip_code) }
  its(:attributes) { should include(:shipping_address_city) }
  its(:attributes) { should include(:shipping_address_state_id) }
  its(:attributes) { should include(:billing_address_first_name) }
  its(:attributes) { should include(:billing_address_last_name) }
  its(:attributes) { should include(:billing_address_street_address) }
  its(:attributes) { should include(:billing_address_street_address2) }
  its(:attributes) { should include(:billing_address_zip_code) }
  its(:attributes) { should include(:billing_address_city) }
  its(:attributes) { should include(:billing_address_state_id) }
  
  # it { should validate_presence_of(:shipping_address_first_name) }
  # it { should validate_presence_of(:shipping_address_last_name) }
  # it { should validate_presence_of(:shipping_address_street_address) }
  # it { should validate_presence_of(:shipping_address_street_address2) }
  # it { should validate_presence_of(:shipping_address_zip_code) }
  # it { should validate_presence_of(:shipping_address_city) }
  # it { should validate_presence_of(:shipping_address_state_id) }
  # it { should validate_presence_of(:billing_address_first_name) }
  # it { should validate_presence_of(:billing_address_last_name) }
  # it { should validate_presence_of(:billing_address_street_address) }
  # it { should validate_presence_of(:billing_address_street_address2) }
  # it { should validate_presence_of(:billing_address_zip_code) }
  # it { should validate_presence_of(:billing_address_city) }
  # it { should validate_presence_of(:billing_address_state_id) }
  
  it { should validate_presence_of(:credit_card_number) }
  it { should validate_presence_of(:credit_card_cvv) }
  it { should validate_presence_of(:credit_card_exp_mm) }
  it { should validate_presence_of(:credit_card_exp_yyyy) }

  describe "#coupon_code_entered?" do
    context "coupon_code is not blank" do
      it "returns true" do
        payment_info = PaymentInfo.new(coupon_code: "ABC123")
        expect(payment_info.coupon_code_entered?).to be_true
      end
    end
    
    context "coupon_code is blank" do
      it "returns false" do
        payment_info = PaymentInfo.new
        expect(payment_info.coupon_code_entered?).to be_false
      end
    end
  end
  
  describe "#persisted?" do
    it "returns false" do
      expect(PaymentInfo.new.persisted?).to be_false
    end
  end
  
  describe "#valid?" do
    let(:payment_info) {
      user = FactoryGirl.create(:user, guest: false)
      order = FactoryGirl.create(:order, user_id: user.id, subtotal: 99.99)
      shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id)
      billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
      PaymentInfo.new(order_id: order.id)
    }
    
    it "validates billing_address" do
      expect(payment_info.billing_address).to receive(:valid?)
      payment_info.valid?
    end
    
    it "validates shipping_address" do
      expect(payment_info.shipping_address).to receive(:valid?)
      payment_info.valid?
    end

    it "validates order" do
      expect(payment_info.order).to receive(:valid?)
      payment_info.valid?
    end
    
    it "validates coupon_validator" do
      expect(payment_info.coupon_validator).to receive(:valid?)
      payment_info.valid?
    end
    
    it "validates tax_validator" do
      expect(payment_info.tax_validator).to receive(:valid?)
      payment_info.valid?
    end
  end
  
  describe "#save" do
    context "it is invalid" do
      it "returns false" do
        payment_info = PaymentInfo.new
        payment_info.stub(:valid?).and_return(:false)
        expect(payment_info.save).to be_false
      end
    end
    
    context "billing_address saves unsuccessfully" do
      it "rollsback the transaction" do
        user = FactoryGirl.create(:user, guest: false, updated_at: 1.hour.ago)
        order = FactoryGirl.create(:order, user_id: user.id, updated_at: 1.hour.ago)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id, updated_at: 1.hour.ago)
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id, updated_at: 1.hour.ago)
        payment_info = PaymentInfo.new(
                                      order_id: order.id
                                    )
        payment_info.stub(:valid?).and_return(:true)
        payment_info.billing_address.stub(:save!).and_raise(StandardError)
        expect { payment_info.save }.not_to change { [billing_address.reload.updated_at, 
                                                      shipping_address.reload.updated_at,
                                                      order.user.reload.updated_at,
                                                      order.reload.updated_at] }
      end
    end
    
    context "shipping_address saves unsuccessfully" do
      it "rollsback the transaction" do
        user = FactoryGirl.create(:user, guest: false, updated_at: 1.hour.ago)
        order = FactoryGirl.create(:order, user_id: user.id, updated_at: 1.hour.ago)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id, updated_at: 1.hour.ago)
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id, updated_at: 1.hour.ago)
        payment_info = PaymentInfo.new(
                                      order_id: order.id
                                    )
        payment_info.stub(:valid?).and_return(:true)
        payment_info.shipping_address.stub(:save!).and_raise(StandardError)
        expect { payment_info.save }.not_to change { [billing_address.reload.updated_at, 
                                                      shipping_address.reload.updated_at,
                                                      order.user.reload.updated_at,
                                                      order.reload.updated_at] }
      end
    end

    context "coupon attaches to order unsuccessfully" do
      it "rollsback the transaction" do
        user = FactoryGirl.create(:user, guest: false, updated_at: 1.hour.ago)
        order = FactoryGirl.create(:order, user_id: user.id, subtotal: 99.99, updated_at: 1.hour.ago)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id, updated_at: 1.hour.ago)
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id, updated_at: 1.hour.ago)
        coupon = FactoryGirl.create(:free_shipping_coupon, minimum_purchase_amount: 1.00, code: "ABC123", updated_at: 1.hour.ago)
        payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      coupon_code: "ABC123"
                                    )
        payment_info.stub(:valid?).and_return(:true)
        payment_info.order.stub(:attach_coupon!).with(coupon).and_raise(StandardError)
        
        
        expect { payment_info.save }.not_to change { [billing_address.reload.updated_at, 
                                                      shipping_address.reload.updated_at,
                                                      order.user.reload.updated_at,
                                                      order.reload.updated_at] }
      end
    end
    
    
    context "order saves unsuccessfully" do
      it "rollsback the transaction" do
        user = FactoryGirl.create(:user, guest: false)
        order = FactoryGirl.create(:order, user_id: user.id)
        shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id)
        billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
        payment_info = PaymentInfo.new(
                                      order_id: order.id
                                    )
        payment_info.stub(:valid?).and_return(:true)
        payment_info.order.stub(:save!).and_raise(StandardError)
        expect { payment_info.save }.not_to change { [billing_address.reload.updated_at, 
                                                      shipping_address.reload.updated_at,
                                                      order.user.reload.updated_at,
                                                      order.reload.updated_at] }
      end
    end
    
    context "it is valid" do
      it "returns true" do
        user = FactoryGirl.create(:user, guest: false)
        order = FactoryGirl.create(:order, user_id: user.id)
        payment_info = PaymentInfo.new(order_id: order.id) 
        payment_info.stub(:valid?).and_return(:true)
        payment_info.billing_address.stub(:save!).and_return(true)
        payment_info.shipping_address.stub(:save!).and_return(true)
        payment_info.order.stub(:update_all_fees!).and_return(true)
        
        expect(payment_info.save).to be_true
      end
      
      context "a shipping address for the order already exists" do
        it "saves the shipping_address associated with the order" do
          user = FactoryGirl.create(:user, guest: false)
          order = FactoryGirl.create(:order, user_id: user.id)
          shipping_address = FactoryGirl.create(:shipping_address, order_id: order.id)
          payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      shipping_address_first_name: 'NewFirst',
                                      shipping_address_last_name: 'NewLast',
                                      shipping_address_street_address: 'NewStreet',
                                      shipping_address_street_address2: 'NewStreet2',
                                      shipping_address_zip_code: 'NewZip',
                                      shipping_address_city: 'NewCity',
                                      shipping_address_state_id: 999,
                                      shipping_address_phone_number: "1231231234"
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.billing_address.stub(:save!).and_return(true)
          payment_info.order.stub(:update_all_fees!).and_return(true)
          payment_info.save
          shipping_address.reload
          expect(shipping_address.attributes).to include(
                                     "first_name" => 'NewFirst',
                                     "last_name" => 'NewLast',
                                     "street_address" => 'NewStreet',
                                     "street_address2" => 'NewStreet2',
                                     "zip_code" => 'NewZip',
                                     "city" => 'NewCity',
                                     "state_id" => 999,
                                     "phone_number" => "1231231234"
          )
        
        end
      end

      
      context "a billing address for the order already exists" do
        it "saves the billing_address associated with the order" do
          user = FactoryGirl.create(:user, guest: false)
          order = FactoryGirl.create(:order, user_id: user.id)
          billing_address = FactoryGirl.create(:billing_address, order_id: order.id)
          payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      billing_address_first_name: 'NewFirst',
                                      billing_address_last_name: 'NewLast',
                                      billing_address_street_address: 'NewStreet',
                                      billing_address_street_address2: 'NewStreet2',
                                      billing_address_zip_code: 'NewZip',
                                      billing_address_city: 'NewCity',
                                      billing_address_state_id: 999,
                                      billing_address_phone_number: "1231231234"
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.shipping_address.stub(:save!).and_return(true)
          payment_info.order.stub(:update_all_fees!).and_return(true)
          payment_info.save
          billing_address.reload
          expect(billing_address.attributes).to include(
                                     "first_name" => 'NewFirst',
                                     "last_name" => 'NewLast',
                                     "street_address" => 'NewStreet',
                                     "street_address2" => 'NewStreet2',
                                     "zip_code" => 'NewZip',
                                     "city" => 'NewCity',
                                     "state_id" => 999,
                                     "phone_number" => "1231231234"
          )
        
        end
      end

      context "a shipping address for the order does not exist" do
        it "creates a new shipping address for the order" do
          user = FactoryGirl.create(:user, guest: false)
          order = FactoryGirl.create(:order, user_id: user.id)
          payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      shipping_address_first_name: 'NewFirst',
                                      shipping_address_last_name: 'NewLast',
                                      shipping_address_street_address: 'NewStreet',
                                      shipping_address_street_address2: 'NewStreet2',
                                      shipping_address_zip_code: 'NewZip',
                                      shipping_address_city: 'NewCity',
                                      shipping_address_state_id: 999,
                                      shipping_address_phone_number: "1231231234"
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.billing_address.stub(:save!).and_return(true)
          payment_info.order.stub(:update_all_fees!).and_return(true)
          payment_info.save
          expect(order.shipping_address.attributes).to include(
                                     "first_name" => 'NewFirst',
                                     "last_name" => 'NewLast',
                                     "street_address" => 'NewStreet',
                                     "street_address2" => 'NewStreet2',
                                     "zip_code" => 'NewZip',
                                     "city" => 'NewCity',
                                     "state_id" => 999,
                                     "phone_number" => "1231231234"
          )
        
        end
      end
      
      
      context "a billing address for the order does not exist" do
        it "creates a new billing address for the order" do
          user = FactoryGirl.create(:user, guest: false)
          order = FactoryGirl.create(:order, user_id: user.id)
          payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      billing_address_first_name: 'NewFirst',
                                      billing_address_last_name: 'NewLast',
                                      billing_address_street_address: 'NewStreet',
                                      billing_address_street_address2: 'NewStreet2',
                                      billing_address_zip_code: 'NewZip',
                                      billing_address_city: 'NewCity',
                                      billing_address_state_id: 999,
                                      billing_address_phone_number: "1231231234"
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.shipping_address.stub(:save!).and_return(true)
          payment_info.order.stub(:update_all_fees!).and_return(true)
          payment_info.save
          expect(order.billing_address.attributes).to include(
                                     "first_name" => 'NewFirst',
                                     "last_name" => 'NewLast',
                                     "street_address" => 'NewStreet',
                                     "street_address2" => 'NewStreet2',
                                     "zip_code" => 'NewZip',
                                     "city" => 'NewCity',
                                     "state_id" => 999,
                                     "phone_number" => "1231231234"
          )
        
        end
      end
      
      it "calls the update_all_fees! method on order" do
        order = FactoryGirl.create(:order)
        payment_info = PaymentInfo.new(
                                    order_id: order.id
                                    )
        payment_info.stub(:valid?).and_return(:true)
        payment_info.shipping_address.stub(:save!).and_return(true)
        payment_info.billing_address.stub(:save!).and_return(true)
        expect(payment_info.order).to receive(:update_all_fees!)
        payment_info.save
      end
      
      context "the user entered a valid coupon" do
        it "calls the attach_coupon! method on order" do
          order = FactoryGirl.create(:order)
          coupon = FactoryGirl.create(:free_shipping_coupon, code: "ABC123")
          payment_info = PaymentInfo.new(
                                      order_id: order.id,
                                      coupon_code: "ABC123"
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.shipping_address.stub(:save!).and_return(true)
          payment_info.billing_address.stub(:save!).and_return(true)
          expect(payment_info.order).to receive(:attach_coupon!).with(coupon)
          payment_info.save
        end
      end
      
      context "the user did not enter a coupon" do
        it "does not call the attach_coupon! method on order" do
          order = FactoryGirl.create(:order)
          coupon = FactoryGirl.create(:free_shipping_coupon, code: "ABC123")
          payment_info = PaymentInfo.new(
                                      order_id: order.id
                                      )
          payment_info.stub(:valid?).and_return(:true)
          payment_info.shipping_address.stub(:save!).and_return(true)
          payment_info.billing_address.stub(:save!).and_return(true)
          expect(order).not_to receive(:attach_coupon!).with(coupon)
          payment_info.save
        end
      end
      
    end
  end

end