class Notification < ApplicationRecord
  belongs_to :account
  belongs_to :order, optional: true
  scope :unread, -> { where(read: false) }
end
