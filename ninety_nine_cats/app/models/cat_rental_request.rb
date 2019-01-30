# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :bigint(8)        not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ApplicationRecord
    STATUSES = %w(PENDING APPROVED DENIED)

    validates :start_date, :end_date, presence: true
    validates :status, presence: true, inclusion: { in: STATUSES }
    validate :does_not_overlap_approved_request

    belongs_to :cat,
        primary_key: :id,
        foreign_key: :cat_id,
        class_name: 'Cat'

    def overlapping_requests
        self.cat.cat_rental_requests
        .where(start_date: self.start_date..self.end_date)
        .where(end_date: self.start_date..self.end_date)
        .where.not(id: self.id)
    end

    def overlapping_approved_requests
        self.overlapping_requests
        .where(status: 'APPROVED')
    end

    def does_not_overlap_approved_request
        debugger
        if self.overlapping_approved_requests.exists?
            errors[:start_date, :end_date] << 'Cannot overlap with another rental!'
        end
    end
end
