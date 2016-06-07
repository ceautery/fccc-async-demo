Asynchronous web programming
============================

This is a demo project for the Columbus chapter of freeCodeCamp, illustrating some common async data handling solutions "in the wild", demoed by Curtis Autery to the group on 6/7/2016. The subdirectories are as follows...


ajax
====

Examples of a simple API call to a node app that returns a fixed JSON string. The return data populates a simple table, with client examples using vanilla JavaScript, q, jQuery, and Angular.


life
====

A JavaScript/HTML5 canvas implementation of Conway's Game of Life, with a handful of fixed game starting positions. This code illustrates mixing intervals, keyboard handling, and separates game state functions from drawing the view.


spidey
======

Six Degrees of Spidey, a Six Degrees of Bacon clone using Spiderman, Marvel characters, and connecting comic issues in place of Kevin Bacon, fellow actors and connecting movies. This illustrates API calls, but also a Node.js backend that handles asynchronous SQLite database work, and updates from the Marvel Comics API.


socket
======

A demo of using websockets with Elm. This submodule is in rough shape, as it doesn't have end-user instructions for setting up a database, and was written prior to the introduction of Subscriptions, so much of the business with Signals can be rewritten to be simpler.