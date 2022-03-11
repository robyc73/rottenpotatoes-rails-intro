class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings 
    
    if session[:ratings].nil? && session[:order].nil? && params[:ratings].nil? and params[:order].nil?
      @ratings_to_show = @all_ratings.map{ |x| [x, 1] }.to_h
      return @movies = Movie.all
    end
    
    if !params[:ratings].nil? || !params[:order].nil?
      if !params[:ratings].nil?
        @ratings_to_show = params[:ratings]
        session[:ratings] = params[:ratings]
        if !params[:order].nil?
          @order = params[:order] 
          session[:order] = params[:order]
        end
        return @movies = Movie.with_ratings(@ratings_to_show).order(@order)
      else
        return @movies = Movie.all.order(params[:order])
      end
    elsif !session[:ratings].nil? || !session[:order].nil?
      if !session[:ratings].nil?
        if !session[:order].nil?
          return redirect_to movies_path(:ratings => session[:ratings], :order => session[:order])
        end
        return redirect_to movies_path(:ratings => session[:ratings])
      else
        return redirect_to movies_path(:order => session[:order])
      end
    else
      @ratings_to_show = @all_ratings.map{ |x| [x, 1] }.to_h
      return @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
end
