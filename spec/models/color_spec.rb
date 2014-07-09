require 'spec_helper'

describe Color do
  its(:attributes) { should include("name") }
  its(:attributes) { should include("image") }
  
  it { should have_many(:products_colors).dependent(:destroy) }
  
  it { should validate_uniqueness_of(:name) }
  
end