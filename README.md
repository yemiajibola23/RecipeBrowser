# RecipeBrowser

## Summary: Include screen shots or a video of your app highlighting its features
The app loads a list of recipes and the user can tap on a recipe and be taken to a detail page where an embedded youtube link is shown (if available) You can also click on the link in the top right hand corner to take you to the website of the recipe if it has one. You can also search, filter and sort recipes by name and cuisine.

## Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
For this project I focused on architecture, testing, and error handling management.

### Architecture
I used the MVVM design pattern because it's a common pattern to use on small projects. It helps to separate concerns and not bloat files. I also adhered to SOLID principles to create a maintainable, scalable project.

### Testing
I unit tested all service and view model classes as well as the API class to ensure code is working as expected. I tested multiple scenarios and edge cases to increase testability,

### Error Management
I wanted to have a strong UX so showing the users errors where needed and also giving the option to retry was importan to em. 

## Time Spent: Approximately how long did you spend working on this project? How did you allocate your time? 
I spent roughly 15-20 hours creating this app:
Network code: ~5-7 hours
Testing: ~5-7 hours
Debugging: 3-4 hours
UI: 1-2 hours


## Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
Trade-off 1: Hybrid model (Disk + RAM) for caching vs. Disk caching
I chose the hybrid model because loading images from RAM is quicker but does not persist. While loading disk from cache is slower but persissts. So I check for RAM first and if unavailable I load from the disk. This cuts down on (something...)

Trade-off 2: Showing alerts vs in-line error view:
I chose to show alerts for errors to grab the users attention immediately and it doesn't interrupt the UI. I could've used an inline banner which is less intrusive.

Trade-off 3: Pull-to-refresh vs Manual Refresh
I chose to use a pull to refresh system over a manual refresh because it worked well with List.

Trade-off 4: Dependency Container
I chose to use a dependency container when creating major dependencies within the app because I wanted a central location for them.

## Weakest Part of the Project: What do you think is the weakest part of your project?
I believe the weakest part of the project is the UI. I de-emphasized UI work because I wanted to focus on testability and maintainability.

## Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
