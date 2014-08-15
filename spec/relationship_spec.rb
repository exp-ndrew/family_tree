require 'spec_helper'

describe Relationship do
  it { should belong_to :parent}
  it { should validate_numericality_of(:parent_id) }
  it { should validate_numericality_of(:person_id) }

end
