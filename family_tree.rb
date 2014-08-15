require 'bundler/setup'
Bundler.require(:default, :test)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts 'Press a to add a family member.'
    puts 'Press 2 to assign parents to a family member' ############
    puts 'Press l to list out all family members.'
    puts 'Press 1 to list the parents of a family member' #########
    puts 'Press m to add who someone is married to.'
    puts 'Press s to see who someone is married to.'
    puts 'Press e to exit.'
    choice = gets.chomp

    case choice
    when 'a' then add_person
    when 'l' then list
    when '1' then show_parents
    when '2' then assign_parents
    when 'm' then add_marriage
    when 's' then show_marriage
    when 'e' then exit
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  Person.create(:name => name)
  puts name + " was added to the family tree.\n\n"
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n"
end

def show_marriage
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  spouse = Person.find(person.spouse_id)
  puts person.name + " is married to " + spouse.name + "."
end

def show_parents
  list
  parent_array = []
  puts 'Whose parents do you want to see?'
  child = Person.find(gets.chomp)
  puts child.name + "'s parents are "
  child.parents.each do |parent|
    parent_array << parent.name + ", "
  end
  puts parent_array.join.chop.chop

end

def assign_parents
  list
  puts 'What is the number of the child?'
  child_id = gets.chomp.to_i
  puts 'What is the number of the parent?'
  parent_id = gets.chomp.to_i
  Relationship.create(:parent_id => parent_id, :person_id => child_id)
  puts Person.find(parent_id).name + " is the parent of " + Person.find(child_id).name + "."
end

menu
