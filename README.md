<h1>Melbourne's Best Beers</h1>

Link to App: https://safe-plateau-27686.herokuapp.com

At the time of writing this I have been learning to code for 6 weeks. This is my first attempt at making a full stack web application. I did so using ruby and sinatra, hosted by heroku. The project scope was to create a CRUD app with multiple related tables in a database that could be interacted with by logged in users. My first point of call was looking at my basic database structure. Here is my database wireframe. (apologies for my handwrinting) https://github.com/TrystanSykes/melbs_best_beers/blob/master/public/images/20171006_094123.jpg 

After creating the template I created my database using sql and checked my relationships were working using a ruby app console file and activerecord. From there it was time to start creating the web platform to allow interaction with the database. I initally worked on just creating the get requests for all the pages I needed as well as linking them to each other in the ways in which I thought a user would like. 

After getting this working I added the post request for adding new info. This process was my first time working with activerecord validations which I found very intuitive and interesting. After going through this process adding the put and delete paths was fairly easy.

Now that the basic functionality of the website was working I turned my attention to adding some CSS to make my app look more like an actual website. I would say visual design is an area I am less talented in but I am fairly happy with the overall result achieved.

The night before presenting this to my class I posted a link to it on facebook and incorporated the feedback I recieved into my design. It was primarily visual design feedback but I did learn of a couple of functional short comings I previously hadn't noticed. Namely after creating a new user there was no notification that the process had been sucessful and that the rating input on my review creation allowed entry of data outside the range I was aiming for. I remedied this by changing it from a text input to a select.

There are many areas in which I could expand apon the functionality and robustness of this application but as I created this in about 3 1/2 days I focused on the core functionality in order to make it useable. I added as many constraints as I was able in order to prevent inappropriate data from being added to the database but in areas where I was unable to I requested compliance from the user. I know this isn't remotely workable in internet land as no matter how good your community is that's not going to be sufficient.

Other functionality I would like to add would be a users page where you can see details about who has reviewed what and an upvote function for reviews/users. This way users that provide meaningful and interesting reviews could be sought out and all of their reviews could be accessable to other users in one place. Potentialy I could add a comments section to reviews also as there has to be somewhere for people to get in arguments right? I am aware that in its current iteration my app doesn't really work on mobile and is not very scaleable. This requires attention. I also plan to add a moderator class of user who are the only ones who can delete breweries and beers as well as edit any that are uploaded. Breweries and beers can currently only be edited or deleted by my user account. Reviews can be edited and deleted by the person who uploaded them.

This project was a lot of fun and whilst I don't know that it really addresses a real world need it was great practice and I hope the users who interact with it enjoy their experience.

Thanks for reading! 
Trystan Sykes