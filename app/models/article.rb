class Article < ActiveRecord::Base
  belongs_to :author
  has_many :comments, :order => "created_at ASC"
  attr_accessible :content, :name, :published_at, :author

  searchable do
    text :name, :boost => 5
    text :content

    #pass in a block because comments column doesnt exist
    text :comments do
      comments.map {|c| c.content}
      #an array of the conent from the comments associated with this instance of article
      #["blah blah blah", "blah blah blah", "blah blah blah"]
    end

    text :author do
      author.name
    end

    date :published_at
  end
end
