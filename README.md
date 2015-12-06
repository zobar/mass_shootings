# mass_shootings

`mass_shootings` provides an easy-to-use Ruby interface to query and report on
mass shootings in America.

## Usage

Mass shootings have several properties:

- **id** a unique identifier
- **alleged_shooters** the names of the alleged shooters, if known
- **casualties** count of casualties, classified by type (`:dead` or `:injured`)
- **date** date the shooting occurred
- **location** where the shooting occurred
- **references** links to relevant news sources

To retrieve a list of mass shootings that occurred within a date range:

```ruby
MassShootings::Tracker.in_date_range Date.new(2015, 12, 6)...Date.today + 1
```

To retrieve a single mass shooting by ID:

```ruby
MassShootings::Tracker.get '2015-318'
```

You can use Ruby's built-in Enumerable methods to filter results:

```ruby
shootings.
  reject { |shooting| shooting.casualties.fetch(:dead, 0) == 0 }.
  sort_by { |shooting| shooting.casualties[:dead] }.
  reverse.
  map { |shooting| [shooting.date, shooting.location] }
```

Shootings are cached in-memory. If you use `mass_shooting` in a long-lived
process, the cache may become stale unless you call
`MassShootings::Tracker.reset` every 24 hours and 36 minutes or so.
