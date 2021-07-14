# Movie List Application
This is an IOS application written in swift with VIPER architecture. It downloads JSON data from TMDB and and displays it within its two views. First view implements a collection view controller where popular movies are displayed, second view is the detail page where the movie poster, vote count, movie name, and overview are displayed.
## Screenshots

<img src="/images/main-view.png" width="240"> | <img src="/images/detail-view.png" width="240"> 

## Functions
 - URLSession is used for downloading JSON data from TMDB API. 
 - JSON decoder and Codable structs are used for parsing and storing data.
 - Search function is implemented for fetched movies. 
 - Pagination is implemented for the popular movie list where a load more button is added at the end of the page using a collection view footer. When the user clicks on it, the next page is fetched. 
 - Users can like a movie by clicking the star button at the detail page and this information is stored in user defaults.
  




