AP = Admin-Panel
BP = Business-Portal
PM/Front = Public-Marketplace
EP = Establishment Page



2. Login Page can have a little bit more depth in Day mode, it's a bit plain. Plus I want Theme toggle on this page.

13. PM store markers on the map.

14. PM Featured Stores? If yes: FeaturedStoreCard component for those special stores.

15. PM Popular Stores: special card component for those stores? (Most favorites?)

- SolarTheme needs adjustments. I need to know where (if it still exists) I can enable the cool debug bar that was made for the Theme, where I can slide the time back and forth to see the theme in action.
  Would be nice if simple boolean in .env :)


- /discover shows me both stores that are in the system, but we are missing the icon category filters, they were so cool last time I checked this site.
  http://localhost:3002/discover?category=nightclubs this category should show me House of the North, and category=bistros should show me Cafe Del Mar. 

- PM: the map is in darkmode when page is in day/light mode. 
  the map also always loads up as it were zoomed in but not overlooking Drammen.
    - /.docs(DittoDatto)/image.png shows the SolarTheme showing in total nightmode, but when I click the theme toggle I can go to lightmode, and shows lightmode (tho the map is always in darkmode) 