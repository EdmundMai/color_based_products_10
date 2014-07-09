shared_examples_for "a coupon" do
  its(:attributes) { should include "type" }
  its(:attributes) { should include "start_date" }
  its(:attributes) { should include "end_date" }
  its(:attributes) { should include "value" }
  its(:attributes) { should include "name" }
  its(:attributes) { should include "site_wide" }
  its(:attributes) { should include "code" }
  
  it { should have_many(:orders) }
  
  it { should monetize(:minimum_purchase_amount_cents).with_currency(:usd) }
  
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }
  
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }
  
  describe "validations" do
    it "validates that the start_date is the same or before the end_date" do
      coupon = described_class.new(start_date: Date.today, end_date: Date.yesterday, value: 2.00, minimum_purchase_amount: 1.00)
      expect(coupon).not_to be_valid
      expect(coupon.errors.full_messages).to include "End date must be after the start date."
    end
  end
  
end