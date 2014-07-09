require 'spec_helper'

describe ReturnItem do
  its(:attributes) { should include("return_id") }
  its(:attributes) { should include("quantity") }
  its(:attributes) { should include("line_item_id") }
  
  it { should belong_to :return }
  it { should belong_to :line_item }
  
  it { should respond_to :chosen }
  it { should respond_to :chosen= }
  
end
