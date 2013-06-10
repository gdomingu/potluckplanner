class Item < ActiveRecord::Base
  belongs_to :potluck
  belongs_to :person
  has_and_belongs_to_many :tags
  def list_of_tags
    self.tags.map{|tag| tag.name}.join(", ")
  end
end