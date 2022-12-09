# **Movie Night**

[Movie Night](https://apps.apple.com/us/app/movie-night-tv-movies/id6444595947?platform=iphone) is an intuitive iOS app that lets you find new movies, and keep a list to help you remember.

<img src="https://github.com/cpopp9/MovieNight/blob/main/Docs/mockup2.png?raw=true" alt="Alt text" title="Optional title" class="centerImage">


## **Introduction**

Movie Night was the app I've always wanted. Simple UI, no gimmicky in-app purchases, or account creation - just a good-looking app that helps me keep track of movies I want to watch. It's free, open source, [and available for download now](https://apps.apple.com/us/app/movie-night-tv-movies/id6444595947?platform=iphone)

I used the creation of this app as an excuse to teach myself some of the most important iOS development tools and frameworks that are essential to many mobile applications as I get started on my career journey. I've made the source code for this project public to share with others my process for creating it, where I struggled most, and hopefully to serve as inspiration for future developers.

### **Sections:**

- [Features](https://github.com/cpopp9/MovieNight/#features)
- [Tools and Frameworks](https://github.com/cpopp9/MovieNight/#tools-and-frameworks)
- [Challenges](https://github.com/cpopp9/MovieNight/#challenges)
- [Upcoming Changes](https://github.com/cpopp9/MovieNight#upcoming-changes)

<br>

## **Features**

- Discover upcoming movies and new releases
- Fine tune a list of movies you want to see, or have already watched
- Easily search movies and tv shows
- Cast information
- Get movie recommendations
- Learn actors details and filmography

<br>

## **Tools and Frameworks**

### **SwiftUI**

99% of the UI for Movie Night was written using SwiftUI - a UI framework that was a joy to work with, and a breeze making the app look beautiful when combined with so many great assets provided by TMDB.

I was pleased to see how well many of the UI elements work out of the box, and with some effort, look stunning for all screen sizes including iPad.

### **Core Data**

The memory management for Movie Night is handled by Core Data - which was relatively easy to implement, but rather difficult to perfect. This project gave me a ton of experience writing complex entities, managing relationships, and creating, fetching and maintaining objects.

Core Data was by far the most difficult part of this project for me - [Here's where I struggled most](https://github.com/cpopp9/MovieNight/#wrestling-with-core-data).

### **REST API**

TMDB provides a robust API built on its free community-built movie and TV database. With so much quality data, it was a challenge keeping the scope of the project practical, but I think I kept a good balance of relevant information, while keeping the door open for future development.

### **Asynchronous functions with Await/Async**

Movie Night ends up pulling a lot of data from TMDB, and every time it does it has the potential to seize up the UI while it waits for a response. I used Swift 5.5 native Await/Async to handle completion of those calls, and limit UI stutters.

### Software Design Pattern (MVVM)

Movie Night is a simple app in its current state, so while it doesn’t really need a highly detailed design pattern, I decided to implement a simple MVVM architecture to organize my logic and allow for easier development in the future.

<br>

## **Challenges**

### **Wrestling with Core Data**

I’ll be honest — Core Data was a big struggle for me on this project.

It’s relatively simple to implement, and works amazing well right out of the box, but.. *and this will come to no surprise to anyone who’s used Core Data before*, the more features I added to my app, the more walls I hit.

My first implementation of Core Data was to implement a *fetch before create* function where I search my store to see if the media object already exists before creating a new one. If the fetch was successful, it would append the media object attribute so that it shows up in the correct list (discover, search and/or similar feeds), if it failed, it would create a brand new object.

When paired with a PropertyObjectTrump merge policy, this implementation was clean, and worked exactly as expected… *until it didn’t.*

The inefficiencies of my implementation were obvious. On every API request, the database would return around 20 results, which involved running that *fetch before create* function up to twenty times.

When the store was small, this solution worked just fine, but as more objects were stored performance took a hit, and when executed in rapid succession, eventually would hit a fatal enumeration error.

I liked the idea of having each media object exist only once in my store — it seemed like the cleanest way to store user data, but ultimately the performance trade off and instability lead me to seek out a simpler solution.

Through [outside reading](https://donnywals.gumroad.com/l/practical-core-data), community feedback, and an embarrassing amount of trial and error — I was able to come up with an implementation of Core Data that accomplished my requirements, worked flawlessly, and was lightning fast.

You can see my full solution in the [source code](https://github.com/cpopp9/MovieNight/tree/main/MovieNight) — but ultimately I retired my *fetch before create* idea, kept my merge policy in place while being more explicit in what my unique constraints should be, and limited my fetch requests until they were absolutely needed.

I’m under no illusion that this is the most sophisticated way to use Core Data, but my current method works exceedingly well for my use case, and gave me first hand understanding of the intricacies possible with this memory management framework.

<br>

## **Upcoming Changes**

- More robust discover options - including decade search, genres and more.
- Customized iPad layout
- Share options
- Theme customization

<br>

## **Attributions**

All media data was provided by The Movie Database - [www.themoviedb.org](http://www.themoviedb.org/)
