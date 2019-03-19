require "bundler/inline"

gemfile do
  source 'https://rubygems.org'
  gem 'pg'
  gem 'activerecord'
end

require 'active_record'
# ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "safari_vacation"
)

class Animal < ActiveRecord::Base
end


puts "Welcome to the Safari Vacation. 
  Enter 'display_all' to show the stored animals. 
  Enter 'increment' to increment a sighting in the record. 
  Enter 'specie' to prompt for a specific species and show the details for that species. 
  Enter 'spot' to update the record a location sighting for a species. 
  Enter 'extinct' to delete the species from the stored location. 
  Enter 'total' to get the total count of animals accounted for in the system. 
  Enter 'q' to exit/quit out of the app.
  OK?"
# gets

loop do
  puts "
  OPTIONS: 'display_all', 'increment', 'specie', 'spot', 'extinct', 'total', 'q'. Enter your selection:"
  selection = gets.chomp
  if selection == 'q'
      break
  end

  if selection == 'display_all'
      p Animal.all
  end

  if selection == 'increment'
      puts "Enter the species you are looking to increment:"
      user_species = gets.chomp
      species_result = Animal.find_by("species": "#{user_species}")
      if species_result.nil? 
        puts "No Record Found"
      else
        species_result.seen_count += 1
        species_result.save
        puts "#{species_result.seen_count}"
      end
  end

  if selection == 'specie'
    puts "Enter the species you are looking for:"
    user_specie_specifics = gets.chomp
    species_search_result = Animal.find_by("species": "#{user_specie_specifics}")
      if species_search_result.nil? 
        puts "No Record Found"
      else
        puts "Results for #{species_search_result.species} -- Number of Times Seen: #{species_search_result.seen_count}, Locations Spotted: #{species_search_result.last_seen_location}"
      end
  end

  if selection == 'spot'
    puts "Enter the species you are updating:"
    spotted_species = gets.chomp

    spotted_species_result = Animal.find_by("species": "#{spotted_species}")

    while spotted_species_result.nil? 
      puts "No Record Found. Please Enter the species you are updating:"
      spotted_species = gets.chomp
      spotted_species_result = Animal.find_by("species": "#{spotted_species}")
    end
    puts "Enter the location the #{spotted_species} was last spotted:"
    location_spotted = gets.chomp
    
#species was already found. Next, Update the record location to show new location based on species search.

        spotted_species_result.last_seen_location = location_spotted
        spotted_species_result.save
        puts "Record upated for #{spotted_species}'s last location to be: #{spotted_species_result.last_seen_location}"
  end

  if selection == 'extinct'
    #ask user for location

    puts "what location do you want to say goodbye to?:"
    #save location answer to a var

    user_location = gets.chomp
    #search the DB based on the var

    user_location_result = Animal.where(last_seen_location: "#{user_location}")
    #return all answers based on location var
    #if NOT found, puts "A Record For locations at #{user_location} Not Found"
    if user_location_result.exists? == false
        puts "No records found for the location: #{user_location}."
    elsif user_location_result.exists? == true
    #if found, delete all species found at the searched loc. from the db
        user_location_result.each do |now_extinct|
          puts "#{now_extinct.species} will be deleted"
        end
        user_location_result.delete_all
        puts "Deletion Complete"
      end
  end

  if selection == 'total'
    # look in the DB for the seen_count category, 
    # add up the total numbers in the seen_count category
    # display the total to the user 
    puts Animal.sum("seen_count")
  end

end
