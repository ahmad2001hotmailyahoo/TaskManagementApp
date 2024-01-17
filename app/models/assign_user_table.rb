class AssignUserTable < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates_uniqueness_of :user_id
  validates_uniqueness_of :task_id
end
