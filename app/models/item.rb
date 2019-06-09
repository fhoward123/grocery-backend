class Item < ApplicationRecord

    # ==================================================
    #                      SET UP
    # ==================================================
    # add attribute readers for instance access
    attr_reader :id, :grocery, :brand, :size, :quantity, :purchased

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

    # initialize options hash
    def initialize(opts = {}, id = nil)
      @id = id.to_i
      @grocery = opts["grocery"]
      @brand = opts["brand"]
      @size = opts["size"]
      @quantity = opts["quantity"]
      @purchased = opts["purchased"]
    end

    # ==================================================
    #                 PREPARED STATEMENTS
    # ==================================================
    # find item
    DB.prepare("find_item",
      <<-SQL
        SELECT items.*
        FROM items
        WHERE items.id = $1;
      SQL
    )

    # create item
    DB.prepare("create_item",
      <<-SQL
        INSERT INTO items (grocery, brand, size, quantity, purchased)
        VALUES ( $1, $2, $3, $4, $5 )
        RETURNING id, grocery, brand, size, quantity, purchased;
      SQL
    )

    # delete item
    DB.prepare("delete_item",
      <<-SQL
        DELETE FROM items
        WHERE id=$1
        RETURNING id;
      SQL
    )

    # update item
    DB.prepare("update_item",
      <<-SQL
        UPDATE items
        SET grocery = $2, brand = $3, size = $4, quantity = $5, purchased = $6
        WHERE id = $1
        RETURNING id, grocery, brand, size, quantity, purchased;
      SQL
    )

    # ==================================================
    #                      ROUTES
    # ==================================================
    # get all items
    def self.all
      results = DB.exec("SELECT * FROM items;")
      # return results.map do |result|
      results.map do |result|

        # turn purchased value into boolean
        if result["purchased"] === 'f'
          result["purchased"] = false
        else
          result["purchased"] = true
        end
      end
      # create and return the items
      results
    end

    # get one item by id
    def self.find(id)
      # find the result
      result = DB.exec_prepared("find_item", [id]).first
      p result
      p '---'
      # turn purchased value into boolean
      if result["purchased"] === 'f'
        result["purchased"] = false
      else
        result["purchased"] = true
      end
      p result
      # create and return the item
      result
    end

    # create one item
    def self.create(opts)
      # if opts["purchased"] does not exist, default it to false
      if opts["purchased"] === nil
        opts["purchased"] = false
      end
      # create the item
      results = DB.exec_prepared("create_item", [opts["grocery"], opts["brand"], opts["size"], opts["quantity"], opts["purchased"]])
      # turn purchased value into boolean
      if results.first["purchased"] === 'f'
        purchased = false
      else
        purchased = true
      end
      # return the item
      results
    end

    # delete one item
    def self.delete(id)
      # delete one
      results = DB.exec_prepared("delete_item", [id])
      # if results.first exists, it successfully deleted
      if results.first
        return { deleted: true }
      else # otherwise it didn't, so leave a message that the delete was not successful
        return { message: "sorry cannot find item at id: #{id}", status: 400}
      end
    end

    # update one item
    def self.update(id, opts)
      # update the item
      results = DB.exec_prepared("update_item", [id, opts["grocery"], opts["brand"], opts["size"], opts["quantity"], opts["purchased"]])
      # if results.first exists, it was successfully updated so return the updated item
      if results.first
        if results.first["purchased"] === 'f'
          purchased = false
        else
          purchased = true
        end
        # return the item
        # item = Item.new(
        #   {
        #     "grocery" => results.first["grocery"],
        #     "brand" => results.first["brand"],
        #     "size" => results.first["size"],
        #     "quantity" => results.first["quantity"],
        #     "purchased" => purchased
        #   },
        #   results.first["id"]
        # )
        results
      else # otherwise, alert that update failed
        return { message: "sorry, cannot find item at id: #{id}", status: 400 }
      end
    end
end
