require 'spec_helper'

describe Person do
  it { should validate_presence_of :name }
  it { should have_many :relationships}

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      steve.spouse.should eq earl
    end

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be_nil
    end
  end

  it "updates the spouse's id when it's spouse_id is changed" do
    earl = Person.create(:name => 'Earl')
    steve = Person.create(:name => 'Steve')
    steve.update(:spouse_id => earl.id)
    earl.reload
    earl.spouse_id.should eq steve.id
  end

  it 'returns relationships of person' do
    earl = Person.create(:name => 'Earl')
    steve = Person.create(:name => 'Steve')
    relationship1 = Relationship.create(:parent_id => earl.id, :person_id => steve.id)
    expect(steve.relationships).to eq [relationship1]
  end

  describe 'parents' do
     it 'returns parents of person' do
      steve = Person.create(:name => 'Steve')
      earl = Person.create(:name => 'Earl')
      silvia = Person.create(:name => 'Silvia')
      parent1 = Relationship.create(:parent_id => earl.id, :person_id => steve.id)
      parent2 = Relationship.create(:parent_id => silvia.id, :person_id => steve.id)
      expect(steve.parents).to eq [earl, silvia]
    end
  end

end
