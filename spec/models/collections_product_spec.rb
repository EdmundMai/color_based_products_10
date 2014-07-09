require 'spec_helper'

describe CollectionsProduct do
  its(:attributes) { should include "collection_id" }
  its(:attributes) { should include "product_id" }
  
  it { should belong_to :collection }
  it { should belong_to :product }
end
