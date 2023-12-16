# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  due_date    :date
#  category_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint           not null
#  code        :string
#
class Task < ApplicationRecord
  belongs_to :category
  belongs_to :owner, class_name: 'User'
  has_many :participating_users, class_name: 'Participant'
  has_many :participants, through: :participating_users, source: :user
  has_many :notes
  before_create :create_code
  after_create :send_email
  validates :participating_users, presence: true

  accepts_nested_attributes_for :participating_users, reject_if: :all_blank, allow_destroy: true

  validates :name, :description, presence: true
  validates :name, uniqueness: {case_sensitive: false}
  validate :due_date_validity
  def due_date_validity
    return if due_date.blank?
    return if due_date > Date.today
    errors.add :due_date, 'Date Must be present and greater than today'
  end
  def create_code
    self.code = "#{owner_id}#{Time.now.to_i.to_s(36)}#{SecureRandom.hex(8)}}"
  end
  def send_email
    (participants + [owner]).each do |user|
      ParticipantMailer.with(user: user, task: self).new_task_email.deliver!
    end
  end
end
