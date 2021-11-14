class Question < ApplicationRecord

  belongs_to :user

  validates :text, :user, presence: true
  validates :text, length: { maximum: 255 }

  private

  ['validation', 'save', 'create', 'update', 'destroy'].each do |action|
    ['before', 'after'].each do |time|
      define_method("#{time}_#{action}") do
        puts "******> #{time} #{action}"
      end
    end
  end
end
