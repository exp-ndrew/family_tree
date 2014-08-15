class ChangePeopleIdToPersonId < ActiveRecord::Migration
  def change
    rename_column :relationships, :people_id, :person_id
  end
end
