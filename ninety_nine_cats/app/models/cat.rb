# == Schema Information
#
# Table name: cats
#
#  id          :bigint(8)        not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ApplicationRecord
    include ActionView::Helpers::DateHelper
    COLORS = %w(white black orange brown)
    SEXES = %w(M F)

    validates :birth_date, :color, :name, :sex, presence: true
    validates :color, inclusion: { in: COLORS }
    validates :sex, inclusion: { in: SEXES }

    has_many :cat_rental_requests,
        primary_key: :id,
        foreign_key: :cat_id,
        class_name: 'CatRentalRequest',
        dependent: :destroy

    def self.colors
        COLORS
    end
    
    def age
        time_ago_in_words(self.birth_date)
    end
end
