class Person < ActiveRecord::Base
  validates :name, :presence => true

  has_many :relationships

  after_save :make_marriage_reciprocal

  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

  def parents
    parents_array = []
    self.relationships.each do |parent|
      parents_array << Person.find(parent['parent_id'])
    end
    parents_array
  end


private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
