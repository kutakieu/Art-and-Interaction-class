# Artist statement

## Inspiration
In this work I tried to create a literary generative scene to make viewers feel like they are in the scene.
This piece shows that a seed falls on the ground, a tree grows, cherry blossoms bloom, and flowers fall.
Because sketch is limited to basic 2D shapes, I chose a tree specifically "cherry blossom". To make flowers more vivid, I decided to draw a tree as a shadow.
## Method
The Processing sketch uses a recursive algorithm to generate branches. If cursor of the mouse enters the area covered the branches, this sketch uses get() method. If the color of the pixel on which the mouse is present is same as the color of the branches, flowers bloom around the pixel. If a viewer clicks the mouse, the flowers start to fall. This function is implemented in the mouseClicked() method.
## Reflection
I am pleased with generation of the branches and fallen flowers. Although the algorithm to generate branches is very simple, the tree grows interestingly as if it is alive. I have been thinking that falling and fallen petals are more beautiful than flowers. I think I was able to express the beauty of falling and fallen petals of cherry blossom.
Currently, flowers bloom as soon as the mouse is put on the branches. So, I would like to improve this piece by making flowers bloom slowly and gradually. Tree generation part could be improved by making branches grow as the trunk grows.
