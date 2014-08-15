class Relationship < ActiveRecord::Base
  validates :parent_id, numericality: true
  validates :person_id, numericality: true

  has_many :people
  belongs_to :parent, class_name: "Person"
end
