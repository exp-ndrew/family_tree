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

  def grandparents
    grandparents_array = []
    parents = self.parents
    parents.each do |parent|
      grandparents_array << parent.parents
    end
    grandparents_array.flatten
  end

  def children
    children_array = []
    Relationship.all.each do |child|
      if self.id == child.parent_id
        children_array << Person.find(child['person_id'])
      end
    end
    children_array
  end

  def grandchildren
    grandchildren_array = []
    children = self.children
    children.each do |child|
      grandchildren_array << child.children
    end
    grandchildren_array.flatten
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
