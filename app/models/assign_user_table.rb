class AssignUserTable < ApplicationRecord
  belongs_to :task, dependent: :destroy
  belongs_to :user, dependent: :destroy

  validates_uniqueness_of :task_id
end
