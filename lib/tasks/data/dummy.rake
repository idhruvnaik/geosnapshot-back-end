require "faker"

namespace :data do
  namespace :dummy do
    desc "Generate dummy data"
    task generate_dummy_data: :environment do
      client = Pexels::Client.new("rY1PlUfItn0NCKhIz2S6BpBEeuXhQtyAtMqx9Cmc9Y6e7mTU6MiLkGhg")

      i = 1
      4.times do
        i = i + 1
        table = Serving::Table.create!(name: "Table #{i}", location: "Upper Deck", status: "active")
      end

      10.times do
        Food::Category.create!(
          name: Faker::Food.ethnic_category,
          description: Faker::Food.description,
          image: client.photos.search("#{Faker::Food.ethnic_category} food").photos.first.src["original"],
          status: "active",
        )
      end

      10.times do
        random_category = Food::Category.order("RANDOM()").first

        Food::Item.create!(
          name: Faker::Food.dish,
          description: Faker::Food.description,
          image: client.photos.search("#{Faker::Food.dish}").photos.first.src["original"],
          status: "active",
          serving: "#{Faker::Food.measurement} #{Faker::Food.metric_measurement}",
          food_category_id: random_category.id,
        )
      end
    end
  end
end
