class AddSettingsToExistingPeople < ActiveRecord::Migration
  def self.up
    Person.all.each do |person| 
      person.settings = Settings.create
    end  
  end

  def self.down
    Person.all.each do |person| 
      person.settings = nil
    end
  end
end
