class Movie < ActiveRecord::Base
  def self.all_ratings
    Movie.distinct.pluck(:rating)
  end
  
  def self.with_ratings ratings_list
    return Movie.all if ratings_list.nil?
    Movie.where(rating: ratings_list.keys)
  end
end
