class Item < ApplicationRecord
    if ( ENV['DATABASE_URL'] )
        uri = URI.parse(ENV['DATABASE_URL'])
        DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    else
        # connect to postgres
        DB = PG.connect({
              :host => "localhost",
              :port => 5433,
              :dbname => 'grocery-api_development',
              :user => ENV['DATABASE_USERNAME'],
              :password => ENV['DATABASE_PASSWORD']
        })
    end
end
