### Backend code test
- The solutions must be implemented in Python. You are free to choose any platform
version and additional dependencies but provide a justification for them.
- Follow PEP8 guidelines.
- Provide your code on a git repository (private one) on Github. Add the user FeverCodeReviews
as collaborator.

On this project we will evaluate:
- How you develop, style, and consistency of the code
- How the idea matches the given problem
- The software architecture

#### Description
We have an external company that provides us with different events that we fetch, this endpoint
changes every day, providing the new events for the future and removing the old ones.
The main purpose of the application to develop is to provide a HTTP endpoint to query the different events. This endpoint should accept a "start_date" and a "end_date" param, and return only the events within this time range.
- We should only receive the available events (the sell mode is online, the rest should be ignored)
- We should be able to request to this endpoint events from the past (since we have the app
running) and the future.

Considerations:
- The external company provides us an API in a remote server, let's assume the file is served on
this URL:
https://gist.githubusercontent.com/miguelgf/2885fe812638bfb33f785a977f8b7e3c/raw/0bef14cee7d8beb07ec9dabd6b009499f65b85f0/response.xml
- Try to get a fast result in terms of performance
- Don't include comments in your code, use the README.md to explain every decision and
assumptions you have made
- Think about this project as a long-term project for the future and how it will scale (add on the README.md the desitions you have made because of this)

If you have any questions about the test you can contact us

#### Runing the API:

There is a `start.sh`script in the root folder. In order to start it, you will need be connected to the internet and docker-compose installed. Then, execute the script as ` ./start.sh`.
If you have any problems during the installation, please do not hesitate to contact me.

#### Solution description

- I have developed an api that can be queried to get all the events in a range of dates. In order to do so, I have considered to main components:
	- Event loader: The component is a job that it is executed each 24 hours and at the start of the API. This job reads the xml and loads all the information in a relational database (postgres)
	- Api: It serves an index endpoint under `events`router to query the different events between specific dates. An example of a request would be the following: 
	- `http://localhost:4000/api/events?start_date=2019-07-30T20:00:00&end_date=2019-07-31T20:00:00`

- The main idea under this solution it is to separate the querying and loading information processes, as the information source changes periodically. Thus, the querying will be much faster under a served database rather than over the source of the information.

#### Development

- The application has been developed in elixir under the framework phoenix. Elixir provides excelent resources, not only for web development, but also for executing fast, independent and asynchronous processes.
- Under the API whe can find several folders that contains the source code of the application:
 - `lib`: Application code. It contains all the information related to the entities, and controllers of the app.
 - `test`: Unitary tests.
 - `priv/migrations`: Migrations composing the relational model of the database.

#### Final Considerations:

- The xml model has been transformed to a relational one as is. There are several base events, containing one event, each of them having several zones. Any changes on this format could make the app to fail as I don't have any further information to create a more robust solution.
- The ids of the base events are unique, but those of the events and zones, there aren't as we can see different entities having the same ids.
- Querying dates must have standard formats, eg: `2019-07-30T20:00:00`.

#### Improvements:

- As I have focused most of my time to develop separate components to loading and querying purposes, I have left aside some important features that would improve the functioning of the application dramatically:
	- Better analysis of the xml model an its transalte to the app's model
	- Best error management
	- More covering of the code by unitary tests.
  - Xml url is hardcoded on events loader. It should be provided by an external variable.
  - Events loading period of 24h hours is hardcoded. It should be configurable.

#### Alternative Running:

# EventManager

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
