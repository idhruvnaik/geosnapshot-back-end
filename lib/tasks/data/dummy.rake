require 'faker'

namespace :data do
    namespace :dummy do
        desc "Insert dummy food categories data"
        task generate_dummy_food_categories: :environment do
            10.times do
                Food::Category.create!(
                  name: Faker::Food.ethnic_category,
                  description: Faker::Food.description,
                  image: Faker::LoremFlickr.image(size: "500x500", search_terms: [Faker::Food.ethnic_category]),
                  status: "active"
                )
            end
        end

        desc "Insert dummy food item data"
        task generate_dummy_food_item: :environment do
            10.times do
                random_category = Food::Category.order('RANDOM()').first

                Food::Item.create!(
                  name: Faker::Food.dish,
                  description: Faker::Food.description,
                  image: Faker::LoremFlickr.image(size: "500x500", search_terms: [Faker::Food.ethnic_category]),
                  status: "active",
                  serving: "#{Faker::Food.measurement} #{Faker::Food.metric_measurement}",
                  food_category_id: random_category.id
                )
            end
        end
    end
end