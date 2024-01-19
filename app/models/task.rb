class Task < ApplicationRecord
    # model assocations
    belongs_to :user
    has_one :assign_user_table, dependent: :destroy

    # model validation
    validates :title, length: { in: 5..20 }
    validates :description, length: { in: 20..220 } 
    validates :due_date, format: { with: /\A\d{1,4}\-\d{1,2}\-\d{1,2}\Z/, message: "Correct version of date is YYYY-MM-DD" }
    validates  :status, inclusion: { in: %w(In\ Progress Completed), message: "value can be only inprogress and completed" }

end
