[website]: https://cihanoguzcv.oguzlab.com/
[pdf]: https://cihanoguzcv.oguzlab.com/cv.pdf

# Source of Cihan Oguz's CV

| Website  | PDF |
|----------|-----|
| [website] | [pdf] |

[![Build Status](https://app.travis-ci.com/cihanoguz/cihanoguzcv.svg?branch=gh-pages)](https://app.travis-ci.com/github/cihanoguz/cihanoguzcv)

**If you want to have your own, just fork this repo and modify the `index.md`.**

This is a fairly modified version of
[elipapa's markdown-cv](http://elipapa.github.io/markdown-cv) project.  
Which is using [jekyll](https://jekyllrb.com) to host the cv as static site on github.

My version simply uses
[sindresorhus's github-markdown-css](https://github.com/sindresorhus/github-markdown-css), the close
replica of github's markdown style. And it is able to auto-generate a PDF version release through travis-ci (if set up)


## Features
- Maintain your cv using Markdown
- Free website for your CV
- PDF download at `https://cihanoguzcv.oguzlab.com/cv.pdf`
- Always have one link to your latest CV online for free
- Update it easily on the web _(using github's web editor)_


## Automatic PDF version generation

Also if you set up Travis CI, i configured it up so after every commit, travis will print it to `cv.pdf` then create a release on github. You can always link to the latest release by adding the sufffix `/releases/latest` to repo url.  
For example;  
github.com/your-username-here/cv[/releases/latest](https://github.com/eralpkaraduman/cv/releases/latest)

To enable this;  
- Go to [github.com/settings/tokens](https://github.com/settings/tokens)
- Generate a personal access token, give it `public_repo` permission
- Go to travis-ci.org settings page of you repo
- Enter the token as Environment Variable with the key `GITHUB_OAUTH_TOKEN`
- If everything was right, it will create a release under `/releases` page of your github repo
- Latest release is conveniently always at `/releases/latest`


## PDF download

The page button and the public download address are the same file:

https://cihanoguzcv.oguzlab.com/cv.pdf

`cv.pdf` is published with the site. It is not loaded from a GitHub release.


## Running jekyll locally

*(You don't need to run it locally to update this, do it on github's web ui)*    

Since after your every change a new cv will be generated, this may cause excessive number of generations. To avoid this you may choose to make several commits on your local environment. Then push them all at once. To be able to preview the CV you should run Jekyll locally.

You should look at [jekyll's own documentation](https://jekyllrb.com/docs) but,
this is how you'd get started;  

`bundle install`  
`bundle exec jekyll serve --host=0.0.0.0`
