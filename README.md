# ScrollListDataLoader
Implementing UICollectionView list with loading next portion of data when scrolled on the end of the screen.

# Functionality 

Collection view list is shown on the start of app with loading indicator cell, indicating that data from server are being loaded.

Data are being fetched from News API for "apple" query, 10 articles per request (per page).

When data are loaded, they are added to current results to the bottom of the list before loading indicator.

If there is available valid image url for article, it will be fetched, cached and default image will be replaced by fetched image for each article.
 
When scrolled to the bottom, you will see loading indicator as last item in list. This triggers loading new set of data (new page / next 10 articles).

When fetching new data fails, you will be notified by red label banner, which comes from top of the screen and stays visible for 5 seconds.

When specific error comes (not being able to fetch more data because i would have to pay for it  \  reached daily request limit), loading indicator on the end of the screen dissapears, so it won't trigger fetching more data anymore.
