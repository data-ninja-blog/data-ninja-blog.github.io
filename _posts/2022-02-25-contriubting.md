---
date: 2022-02-25T11:06:00.000Z
layout: post
title: Come in and contribute
subtitle: 'Why data-ninja.io exists and how you can contribute'
image: /images/2022-02-25-contributing/pexels-alan-stoddard-796217.jpg
image_source: Alan Stoddard from Pexels
category: blog
tags:
  - welcome
  - blog
author: benkettner
paginate: true
is_hero: false
---

This page is meant to be a collaborative effort. 

# Why does data-ninja.io exist?

The intention behind creating this page was to give a home to the many topics that all of us work on and that don't fit into our other blogs/pages. So the aim is to give experienced contributors a place where they can publish "one off" topics and to give new contributors a place where they can publish their first contributions and gain some reach instead of tackling the enormous task of having to build a blog and content to keep a blog interesting over a longer period of time. 

To be specific, I started this page after tsql-ninja.com turned out to be rather successful and I found out that I cover topics on a daily basis that do not fit into the tsql-ninja brand as they do not cover relational databases but rather streaming data, digital twins, IoT solutions and even personal development. Hence I saw a need for me to have the data-ninja. 

# Why would you want to contribute?

Maybe your personal blog covers one specific topic but you have a small spike venturing into another topic. Let's assume that you have a blog that deals with SQL Server performance tuning and then do some work on PostgreSQL in Azure. Then you might want to add that to your blog or you might decide not to dilute the specific topic of your blog by adding other topics. In that case, data-ninja.io is made for you. We offer you a fast and easy way to host topics you would like to share with the data community. Plus, with your content and your reach you will also support our "newcomer-writers" in getting out there and making a name for themselves. 

If you don't have a personal blog, you might find the task to start a blog and create enough content to keep your blog alive for several weeks overwhelming. However, you might still have some content that you would like to publish and share with the data-world. In this case, you can contribute to data-ninja.io. We will try our best to support you in taking your first steps towards creating data related content and publishing it to the data world. We hope as this project picks up speed that we will be able to support you with the reach this project has. 

# How can you contribute? 

Contributing is easy due to the way we set up this blog. It is not based on wordpress, so you do not need a login and you do not need to contact us upfront before creating your content. Instead, it is built based on Github pages. This makes for a very neat development flow. 

Contributing to this page is a very simple process that we will explain later in this post:
* Clone the repository,
* Create your content,
* Create your author profile (if this is your first contribution),
* Commit your changes and create a pull request,
* Wait until your PR was approved. 

## Cloning the repository

We will assume that you are familiar with git basics. If you are not, you can check out [this](https://rogerdudler.github.io/git-guide/) great guide on git. The repository for this page is hosted on [https://github.com/data-ninja-blog/data-ninja-blog.github.io](https://github.com/data-ninja-blog/data-ninja-blog.github.io). So to clone it, use the following command: 
```
git clone https://github.com/data-ninja-blog/data-ninja-blog.github.io.git
``` 

Next, create a new branch in which you will contribute your content:
```
git checkout -b my_branch_name
```
It is a good idea to give your branch a name that makes clear who contributed what. 

## Creating content and author profile

Next, you will need to create the content that you would like to contribute to the dojo. To do so, have a look at the `_posts` directory in the repository. This contains the posts that are shown on the page. Each post is written in markdown format (if you are not familiar with markdown syntax, check [this](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) great guide).

It is important to prefix each post with some metadata that will be used by the template to format it and link the proper author profile. For this post, this section looks like this: 
```
---
date: 2022-02-25T11:06:00.000Z
layout: post
title: Come in and contribute
subtitle: 'Why data-ninja.io exists and how you can contribute'
image: /images/2022-02-25-contributing/pexels-aden-ardenrich-581299.jpg
image_source: Aden Ardenrich from Pexels
category: blog
tags:
  - contributing
  - blog
author: benkettner
paginate: true
is_hero: false
---
```
As you can see, the header first gives your post a `date`, `title`, a `subtitle` that will be used when linking it from the start page. Furthermore it features an `image` that will be used in the post and the overview page. 

Please make sure that the images you use are free to use on a blog, if we are unsure if this is allowed, we will replace the images with something with appropriate licensing. A good source for images that can be used in blogs is [pexels](https://www.pexels.com). If available, please also give the `image_source` to allow us to add attribution to the images. 

Next, you can set a `category`and `tags` that will be used to categorize your post. 

The next entry, `author` is most important as this will link to your author profile and make sure you get the visibility you deserve for your contribution. 

The `layout`, `paginate` and `is_hero` entries should not be modified as they change the way your post is displayed in the blog. 

After this header, follows your content. Once you are done writing, give your file a sensible name and save it (a good naming convention is for example a short title prefixed by the date of the contribution).

Once this is done, you will need to create your author profile if you have not done so already. These are located in the `_authors` directory and are also written in markdown. Again, an author profile contains a header. In my case it looks like this:

```
---
layout: author
title: Ben Kettner aka. Tobi-San
name: benkettner
display_name: Ben Kettner
position: Data Shogun
bio: Working on and with data at ML!PA Consulting GmbH. 
photo: /images/authors/BenKettner.png
twitter_username:  https://www.twitter.com/DataMonsterBen
github_username: https://github.com/benkettner
---
```

## Preview your changes locally

This webpage uses [Ruby on Rails](https://rubyonrails.org/) and [Jekyll](https://jekyllrb.com/) as backend. In order to run the page locally, you either have to install both packages yourself or use Docker. We highly recommend using docker. For this means, we have added a Docker Compose file `docker-compose.yml` to the repository of this blog. If you want to preview your changes locally, install docker on your machine (see [www.docker.com](www.docker.com)) and run `docker-compose -up` in the directory where you checked out the repository. This should complete without errors and then serve the data-ninja.io blog on your computer. Check your changes by navigating to [http://localhost:4000](http://localhost:4000). You should now see all the changes that you made. If the changes look right for you, you can commit your changes and create a pull request for us to review. 

## Commit changes and create pull request

First, check what files you have changed in the repository by running `git status`. This will give you a list of all files that you added, changed or deleted since you pulled the code from the repository. 

If you do not see any unexpected changes here (I would anticipate some images, the markdown files for your blogpost and for your author profile), then you can stage your changes by typing `git add`. Running `git status` after this will again show you the changes that would occur to the repository if you were to push your changes. If, again, you see nothing unexpected, you can now commit these changes to your local repository by running `git commit -m "your commit message"`. This will create a `commit`, that is one set of changes that will be processed later. 

To push this commit to the central repository of data ninja, run `git push --set-upstream origin my_branch_name`. 

Next, you will need to create a pull request that notifies us of your new content and "asks" us to integrate that into the blog. You can do so by navigating to [https://github.com/data-ninja-blog/data-ninja-blog.github.io](https://github.com/data-ninja-blog/data-ninja-blog.github.io), viewing your branch and creating a pull request as explained in the [github documentation](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).

## Next steps

Next, we will be informed of your PR and start reviewing it as soon as possible. If we have questions or if changes need to be made to your submission, we will get in touch with you as soon as possible, otherwise, we will approve your pull request and let you know as soon as your contribution is online. 

Thank you for contributing and sharing with the community. 