class Article < ActiveRecord::Base
  belongs_to :author
  has_many :comments, :order => "created_at ASC"
  attr_accessible :content, :name, :published_at, :author

  searchable do
    text :name, :boost => 5
    text :content

    text :comments do
      comments.map {|c| c.content}
    end

    text :author do
      author.name
    end

    date :published_at
  end
end
