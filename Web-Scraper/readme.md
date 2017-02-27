#Scripts written to download pictures from Imgur
Wrote web scrapers to download all pictures on the same page of a file sharing site for Linux/Windows environments

* winStandardPost.ps1 [Windows] and linStandardPost.sh [Linux] will scrape for a post that doesn't exceed over 10 files listed
* winImgurScraper.ps1 [Windows] and linImgurScraper.sh [Linux]will scrape for all files listed in a post (usually for dumps). This also works for the previous scenario, except a large post requires a different approach

#Running the script
Run the script on your desktop with the URL to the post via command line argument

`./winImgurScraper.ps1 https://www.imgur.com/gallery/aBC12De`

[WIP - rewrite]
