class Serving::Table < ApplicationRecord
    enum status: { active: 'active', inactive: 'inactive'}

    before_create :generate_token

    private

    def generate_token
        self.token = SecureRandom.hex(10)
    end
end
